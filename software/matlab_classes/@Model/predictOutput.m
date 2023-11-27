function predictedOutput = predictOutput(obj,inputDataset,outputDataset,adjTransformation)
%
% [predictedOutput] = predictOutput(obj)
%
%     DESCRIPTION: computes output dataset from the identified model
%
%     USAGE: inside a "Model" object
%
%     INPUT:  - inputDataset {matrix}
%               input samples
%             - Model object {Model}
%               should contain all the necessary information such as the
%               model type
%
%     OUTPUT: - predicted output samples {matrix}
%               computed values from the model structure and the input
%               dataset
%
%     Authors: Hosameldin Mohamed
%
%              all authors are with the Italian Istitute of Technology (IIT)
%              email: name.surname@iit.it
%
%     Genoa, August 2021
%

arguments
    obj
    inputDataset
    outputDataset double = zeros(size(inputDataset));
    adjTransformation    double = eye(6);
end

u = inputDataset;

if(strcmp(obj.modelClass.type, 'polynomial'))
    % check if the parameters are already computed
    if (obj.parametersIdentified == false) && (~strcmp(obj.modelClass.string,'work_bench'))
        disp('WARNING: Model prediction: No parameters were identified, you will get zeros probably!')
    else
        % TODO: make a "verbose" option to print information when set...
        % disp(['Predict output: Model type: ' obj.modelType])
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    np = obj.modelClass.np; % polynomial order
    ny = obj.modelClass.ny; % number of "considered" outputs
    nu = obj.modelClass.nu; % number of "considered" inputs
    na = obj.modelClass.na; % number of delayed samples of the output
    nb = obj.modelClass.nb; % number of delayed samples of the input

    N = size(inputDataset,1);
    y_hat = zeros(N,ny);

    nc = max(na,nb);
    params = obj.parameters;
    % adding previous output data samples to the regression matrix
    for k=nc+1:N
        pId = 1;
        for j=1:na
            for l=1:ny
                y_hat(k,:) = y_hat(k,:) + y_hat(k-j,l) * params(pId,:);
                pId = pId + 1;
            end
        end

        idx = cell(np+1,1);
        len_idx = na*ny;
        pId2 = pId;
        for p=1:np
            % adding input data samples to the regression matrix
            % see the link
            % https://it.mathworks.com/matlabcentral/answers/877893-producing-all-combinations-of-a-vector-with-replacement
            idx{p+1} = unique(nchoosek(repelem(1:nu,p),p),'rows'); % save the combinations for each iteration over np
            len_idx =  len_idx + length(idx{p}); % add the length of the previous combination (iterating over np)

            for j=0:nb
                for m=1:size(idx{p+1},1)
                    newVal = 1;
                    for q=1:p
                        newVal = newVal .* u(k-j,idx{p+1}(m,q));
                    end
                    y_hat(k,:) = y_hat(k,:) + newVal * params(pId2,:);
                    pId2 = pId2 + 1;
                end
            end
        end
        % add offset
        y_hat(k,:) = y_hat(k,:) + params(end,:);
    end

    if(ny == 6)
        predictedOutput = (adjTransformation * y_hat')';
    else
        predictedOutput = y_hat;
    end

elseif(strcmp(obj.modelClass.type, 'neuralnet'))
    if (obj.parametersIdentified == false)
        disp('WARNING: Model prediction: No parameters were identified, you will get zeros probably!')
    else
        % TODO: make a "verbose" option to print information when set...
        % disp(['Predict output: Model type: ' obj.modelType])
    end
    ypred = obj.net(u');
    y_hat = ypred';

    if(size(y_hat,2) == 6)
        predictedOutput = (adjTransformation * y_hat')';
    else
        predictedOutput = y_hat;
    end
end
end

