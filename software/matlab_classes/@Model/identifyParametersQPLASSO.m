function results = identifyParametersQPLASSO(obj, inputDataset, outputDataset, lambda, useRegressorMatrixInPred)
%
% identifyParametersQPLASSO(obj)
%
%     DESCRIPTION: formulate the problem of computing the values of the parameters
%     that best fit the input/output data given a model type, as QP problem
%     then solve it using OSQP solver with LASSO regularization (OSQP example).
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
%              all authors are with the Italian Institute of Technology (IIT)
%              email: name.surname@iit.it
%
%     Genoa, February 2022
%

    disp('-------> LASSO - OSQP example..')
    disp(['---> Start identification for model: ' obj.modelClass.string])
    tic
    % check if the parameters are already computed
    if obj.parametersIdentified == true
        disp('WARNING: Model identification: parameteres were computed before, this operation will overwrite them.')
    end

    if(strcmp(obj.modelClass.type, 'polynomial'))
        % build the regressor matrix -> updates obj.A
        obj.buildRegressor(inputDataset,outputDataset, ...
            obj.modelClass.np, ...
            obj.modelClass.ny, ...
            obj.modelClass.nu, ...
            obj.modelClass.na, ...
            obj.modelClass.nb);

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
                % Select the vector b
                b = obj.b(:,k);
                % OSQP data
                P = blkdiag(sparse(N, N), speye(M), sparse(N, N));
                q = [zeros(N+M,1); lambda*ones(N,1)];
                A = [obj.A, -speye(M), sparse(M,N);
                    speye(N), sparse(N, M), -speye(N);
                    speye(N), sparse(N, M), speye(N);];
                l = [b; -inf*ones(N, 1); zeros(N, 1)];
                u = [b; zeros(N, 1); inf*ones(N, 1)];
    
                prob = osqp;
                settings = prob.default_settings();
                settings.eps_abs = 1e-04;
                settings.eps_rel = 1e-04;
                prob.setup(P, q, A, l, u, settings);
                results = prob.solve();
                X(:,k) = results.x(1:N,:);
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
