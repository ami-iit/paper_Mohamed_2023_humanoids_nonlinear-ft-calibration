function obj = buildRegressor(obj,inputDataset,outputDataset,np,ny,nu,na,nb)
%
% [obj] = buildRegressor(obj,inputdataset,outputdataset,np,ny,nu,na,nb)
%
%     DESCRIPTION: Builds the regressor matrix used to identify the
%     paramters
%
%     USAGE: inside a "Model" object
%
%     INPUT:  - inputDataset {N*(6+1) matrix}
%               input samples
%             - outputDataset {N*(6+1) matrix}
%               output samples
%             - Model object {Model}
%               should contain all the necessary information
%             - np {int}
%               the polynomial order of the static part
%             - ny {int}
%               number of outputs to be considered in the model
%             - nu {int}
%               number of inputs to be considered in the model
%             - na {int}
%               number of poles of the dynamical part
%             - nb {int}
%               number of zeros of the dynamical part
%
%     OUTPUT: - Model object {Model}
%               computed regressor matrix. Saved in the
%               "A" variable
%
%     Authors: Hosameldin Mohamed
%
%              all authors are with the Italian Istitute of Technology (IIT)
%              email: name.surname@iit.it
%
%     Genoa, August 2021
%

% expecting inputDataset dimensions to be N*6 where N is the number of samples
% expecting outputDataset dimensions to be N*6
N = size(inputDataset,1);

if(ny > size(outputDataset))
    disp('[WARNING] [BUILDING REGRESSION] ny is larger than the provided number of outputs.')
    disp(['[WARNING] [BUILDING REGRESSION] setting ny to ' num2str(size(outputDataset,2)) ])
    ny = size(outputDataset,2);
end

if(nu > size(inputDataset))
    disp('[WARNING] [BUILDING REGRESSION] nu is larger than the provided number of inputs.')
    disp(['[WARNING] [BUILDING REGRESSION] setting nu to ' num2str(size(inputDataset,2)) ])
    nu = size(inputDataset,2);
end

obj.A = [];
y = outputDataset;
u = inputDataset;
nc = max(na,nb);

% adding previous output data samples to the regression matrix
for j=1:na
    for l=1:ny
        obj.A = [obj.A , y(nc-j+1:end-j,l)];
    end
end

for p=1:np
    % adding input data samples to the regression matrix
    % see the link
    % https://it.mathworks.com/matlabcentral/answers/877893-producing-all-combinations-of-a-vector-with-replacement
    idx = unique(nchoosek(repelem(1:nu,p),p),'rows');

    for j=0:nb
        for m=1:size(idx,1)
            newCol = ones(N-nc,1);
            for q=1:p
                newCol = newCol .* u(nc-j+1:end-j,idx(m,q));
            end
            obj.A = [obj.A , newCol];
        end
    end
end

% adding the offset term
obj.A = [obj.A , ones(N-nc,1)];

condNumber = norm(obj.A) * norm(pinv(obj.A));
disp(['Condition number for model ' obj.modelClass.string ' BEFORE SCALING is: ' num2str(condNumber)])

% feature scaling implementaiton
% compute the scale gains vector values
% The used method is the computing the maximum value of each
if (obj.scaling) && (~strcmp(obj.modelClass.string,'work_bench'))
    obj.paramScaleVector = max(abs(obj.A))';
    obj.paramScaleVector(obj.paramScaleVector == 0 ) = 1;
else
    obj.paramScaleVector = ones(size(obj.A,2),1);
end

obj.A = obj.A ./ obj.paramScaleVector';

condNumber = norm(obj.A) * norm(pinv(obj.A));
disp(['Condition number for model ' obj.modelClass.string ' AFTER SCALING is:    ' num2str(condNumber)])

% Build also `b`
obj.b = y(nc+1:end,:);

end
