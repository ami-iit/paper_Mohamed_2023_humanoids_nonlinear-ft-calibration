function obj = computeAutoCorr(obj,inputdataset,outputdataset,maxLag)
%
% [obj] = computeAutoCorr(obj,inputdataset,outputdataset)
%
%     DESCRIPTION: computes the residuals autocorrelation values of the
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
%             - maxLag {scalar}
%               The maximum lag to compute the autocorrelation function
%
%     OUTPUT: - Model object {Model}
%               computed RMSE values for each output and saves it in the
%               "xCorrValues" and "xCorrLags" variables
%
%     Authors: Hosameldin Mohamed
%
%              all authors are with the Italian Istitute of Technology (IIT)
%              email: name.surname@iit.it
%
%     Genoa, January 2022
%

y = outputdataset;
yhat = obj.predictOutput(inputdataset,outputdataset);

residuals = y - yhat;

obj.xCorrValues = zeros(2*maxLag+1,size(residuals,2));
obj.xCorrLags = zeros(2*maxLag+1,size(residuals,2));
for i = 1:size(residuals,2)
    [obj.xCorrValues(:,i), obj.xCorrLags(:,i)] = xcorr(residuals(:,i),maxLag,'coeff');
end
end

