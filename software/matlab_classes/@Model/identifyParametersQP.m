function identifyParametersQP(obj, inputDataset, outputDataset, lambda, useRegressorMatrixInPred)
%
% identifyParametersQP(obj)
%
%     DESCRIPTION: formulate the problem of computing the values of the parameters
%     that best fit the input/output data given a model type, as QP problem
%     then solve it using OSQP solver.
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
%               model class
%             - lambda {scalar}
%               Regularization factor
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

    disp('-------> QP - OSQP..')
    disp(['---> Start identification for model: ' obj.modelClass.string])
    tic
    % check if the parameters are already computed
    if obj.parametersIdentified == true
        warning('Model identification: parameteres were computed before, this operation will overwrite them.')
    end

    if(strcmp(obj.modelClass.type, 'polynomial'))
        % build the regressor matrix -> updates obj.A
        obj.buildRegressor(inputDataset,outputDataset, ...
            obj.modelClass.np, ...
            obj.modelClass.ny, ...
            obj.modelClass.nu, ...
            obj.modelClass.na, ...
            obj.modelClass.nb);
    
        % Initialize the params
        obj.parameters = zeros(size(obj.A,2),...
                               size(outputDataset,2));

        % TODO check if the datasets are consistent

        % solve (no of outputs) QP optimization problems
        n = size(outputDataset,2);
        M = size(obj.A,1);
        N = size(obj.A,2);

        % Initialize the params
        X = zeros(N,n); % parameters matrix
        obj.parameters = zeros(N,n);

        if strcmp(obj.modelClass.string,'work_bench')
            obj.setWorkBenchModel();
        else
            % proceed with identification procedure
            for k=1:n
                x0 = obj.parameters(k,:);
                x0 = [x0' ; zeros(N-size(x0,2),1)];
                H = obj.A' * obj.A + 2 * lambda * eye(N);
                % Select the vector b
                b = obj.b(:,k);
                g = -obj.A' * b - 2 * lambda * x0;
                
                m = osqp;
                settings = m.default_settings();
                settings.eps_abs = 1e-04;
                settings.eps_rel = 1e-04;
                m.setup(H, g, eye(N), -Inf(N,1), Inf(N,1), settings);
                results = m.solve();
                X(:,k) = results.x;
            end
            parametersScaled = X;
            obj.parameters = parametersScaled ./ obj.paramScaleVector;
        end
    
        % set the flag
        obj.parametersIdentified = true;

    elseif(strcmp(obj.modelClass.type, 'neuralnet'))
        disp('Start training the neural network..')
        netconf = [10];
        obj.net = feedforwardnet(netconf);
        obj.net = train(obj.net, inputDataset', outputDataset');
        % set the flag
        obj.parametersIdentified = true;
    end
    toc
    disp(['---> Done identification for model: ' obj.modelClass.string])
    if(useRegressorMatrixInPred)
        obj.y_hat = obj.predictOutput_fast(inputDataset,outputDataset);
    else
        obj.y_hat = obj.predictOutput(inputDataset,outputDataset);
    end
end
