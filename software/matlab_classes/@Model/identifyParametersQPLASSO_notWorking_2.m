function results = identifyParametersQPLASSO(obj, inputDataset, outputDataset, lambda)
%
% identifyParametersQPLASSO(obj)
%
%     DESCRIPTION: formulate the problem of computing the values of the parameters
%     that best fit the input/output data given a model type, as QP problem
%     then solve it using OSQP solver with LASSO regularization.
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
%             - lambda {scalar}
%               Regularization factor
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

    % check if the parameters are already computed
    if obj.parametersIdentified == true
        disp('WARNING: Model identification: parameteres were computed before, this operation will overwrite them.')
    end

    % build the regressor matrix -> updates obj.A
    obj.buildRegressor(inputDataset,outputDataset);

    % check if the datasets are consistent
    if strcmp(obj.modelType,'work_bench')
        disp('WARNING: Model identification: Model with type "original" will keep the same parameters values')
    else
        % solve (no of outputs) QP optimization problems
        n = size(outputDataset,2);
        N = size(obj.A,2);
        X = zeros(N,n); % parameters matrix
        for k=1:n
            x0 = obj.parameters(k,:);
            x0 = [x0' ; zeros(N-size(x0,2),1)];
            H = obj.A' * obj.A + 2 * lambda * eye(N);
            b = outputDataset(:,k);
            g = -obj.A' * b;
            q = [g ; lambda*ones(N,1) ; -1*lambda*ones(N,1)];

            P = [H            , zeros(N) , zeros(N) ;...
                    zeros(N) , zeros(N) , zeros(N) ;...
                    zeros(N) , zeros(N) , zeros(N)];

            A = [   eye(N) , -1*eye(N) ,    eye(N) ;...
                 -1*eye(N) ,    eye(N) , -1*eye(N) ;...
                  zeros(N) ,    eye(N) ,  zeros(N) ;...
                  zeros(N) ,  zeros(N) ,    eye(N)];

            l = zeros(4*N,1);
            u = Inf(4*N,1);

            m = osqp;
            settings = m.default_settings();
            settings.eps_abs = 1e-04;
            settings.eps_rel = 1e-04;
            m.setup(P, q, A, l, u, settings);
            results = m.solve();
            X(:,k) = results.x(1:N,:);
        end
        obj.parameters = X;
    end
        

    % set the flag
    obj.parametersIdentified = true;
end
