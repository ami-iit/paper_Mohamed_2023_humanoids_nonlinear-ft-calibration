function predictedOutput = predictOutput_fast(obj,inputDataset,outputDataset,adjTransformation)
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

disp(['---> Start prediction for model: ' obj.modelClass.string])
tic

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
    np = obj.modelClass.np;
    ny = obj.modelClass.ny;
    nu = obj.modelClass.nu;
    na = obj.modelClass.na;
    nb = obj.modelClass.nb;
    nc = max(na,nb);

    obj.buildRegressor(inputDataset,outputDataset, ...
            np, ny, nu, na, nb);


    y_hat = zeros(size(outputDataset));
    y_hat(nc+1:end,:) = obj.A .* obj.paramScaleVector' * obj.parameters;

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

toc
disp(['---> Done prediction for model: ' obj.modelClass.string])
end

