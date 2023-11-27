function identifyParametersLS(obj, inputDataset, outputDataset, scaleValue, useRegressorMatrixInPred)
%
% identifyParameters(obj)
%
%     DESCRIPTION: apply Least Squares to compute the values of the parameters
%     that best fit the input/output data given a model type
%
%     USAGE: inside a "Model" object
%
%     INPUT:  - inputDataset {matrix}
%               input samples
%             - outputDataSet {matrix}
%               output samples
%               than this will be saturated.
%             - Model object {Model}
%               should contain all the necessary information such as the
%               model type
%             - useRegressorMatrixInPred bool {Model}
%               run the prediction function using the regressor matrix
%
%     OUTPUT: -
%
%     Authors: Hosameldin Mohamed
%
%              all authors are with the Italian Istitute of Technology (IIT)
%              email: name.surname@iit.it
%
%     Genoa, August 2021
%

    % check if the parameters are already computed
    if obj.parametersIdentified == true
        disp('WARNING: Model identification: parameteres were computed before, this operation will overright them.')
    end

    % build the regressor matrix -> updates obj.A
    obj.buildRegressor(inputDataset,outputDataset);
    
    if strcmp(obj.modelClass.string,'work_bench')
        obj.setWorkBenchModel();
    else
        parametersScaled = obj.A\outputDataset;
        obj.parameters = parametersScaled ./ obj.paramScaleVector;
    end

    % set the flag
    obj.parametersIdentified = true;

    disp(['---> Done identification for model: ' obj.modelClass.string])
    if(useRegressorMatrixInPred)
        obj.y_hat = obj.predictOutput_fast(inputDataset,outputDataset);
    else
        obj.y_hat = obj.predictOutput(inputDataset,outputDataset);
    end
end
