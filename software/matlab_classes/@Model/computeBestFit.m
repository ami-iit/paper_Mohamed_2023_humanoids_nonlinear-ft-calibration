function obj = computeBestFit(obj,inputdataset,outputdataset,adjTransformation)
%
% [obj] = computeBestFit(obj,inputdataset,outputdataset)
%
%     DESCRIPTION: computes the Best Fit of the
%     predicted output
%
%     USAGE: inside a "Model" object
%
%     INPUT:  - inputDataset {N*(6+1) matrix}
%               input samples
%             - outputDataset {N*(6+1) matrix}
%               output samples
%             - Model object {Model}
%               should contain all the necessary information
%
%     OUTPUT: - Model object {Model}
%               computed RMSE values for each output and saves it in the
%               "RMSE" variable
%
%     Authors: Hosameldin Mohamed
%
%              all authors are with the Italian Istitute of Technology (IIT)
%              email: name.surname@iit.it
%
%     Genoa, March 2022
%

arguments
    obj
    inputdataset
    outputdataset
    adjTransformation    double = eye(6);
end

if(strcmp(obj.modelClass.type, 'polynomial'))
    nc = max(obj.modelClass.na,obj.modelClass.nb);
    y = outputdataset(nc+1:end,:);
    yhat = obj.y_hat(nc+1:end,:);
elseif(strcmp(obj.modelClass.type, 'neuralnet'))
    y = outputdataset;
    yhat = obj.y_hat;
end
MSE = mean((y - yhat).^2);

ybar = mean(y);

obj.BestFit = 1 - sqrt(MSE ./ mean((y - ybar).^2));

end

