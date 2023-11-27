function identifyParametersQPLASSO_BruteForce(obj, inputDataset, outputDataset)
%
% identifyParametersQPLASSO_BruteForce(obj)
%
%     DESCRIPTION: formulate the problem of computing the values of the parameters
%     that best fit the input/output data given a model type, as QP problem
%     then solve it using OSQP solver with LASSO regularization (Using brute force approach).
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
%              all authors are with the Italian Istitute of Technology (IIT)
%              email: name.surname@iit.it
%
%     Genoa, August 2021
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
        N = size(obj.A,2)


        min_RMSE = obj.RMSE; %zeros
        bar = waitbar(0, 'Starting QP Optimization tasks,, be patient!..', 'Name', 'QP brute-force');
        %bar.Position(1) = bar.Position(1)/2;
        %bar.Position(3) = 2*bar.Position(3);
        %bar
        X = zeros(N,n); % parameters matrix
        residual_matrix = outputDataset - obj.A*X;
        computed_RMSE = sqrt(mean((residual_matrix).^2));
        % iterate on 2 to the number of paramters
        for d=1:2^N
            mask = dec2bin(d) - '0';
            mask = [zeros(1, max(0, N-numel(mask))), mask];
            %mask
            % iterate on the number of parameters
            l = zeros(N,1);
            u = zeros(N,1);
            for i=1:N
                if mask(i) == 1
                    l(i) = -inf;
                    u(i) =  inf;
                end
            end
            l'
            %u'
            disp('before....')
            computed_RMSE
            for k=1:n
                H = obj.A' * obj.A;
                b = outputDataset(:,k);
                g = -obj.A' * b;

                m = osqp; 
                settings = m.default_settings();
                settings.eps_abs = 1e-04;
                settings.eps_rel = 1e-04;
                m.setup(H, g, eye(N), l, u, settings);
                results = m.solve();

                residual = outputDataset(:,k) - obj.A*results.x;
                this_RMSE = sqrt(mean((residual).^2));
                this_RMSE
                if(this_RMSE < computed_RMSE(k))
                    X(:,k) = results.x;
                    computed_RMSE(k) = this_RMSE;
                end
            disp('after....')
            computed_RMSE
            %waitbar(d/2^N,bar,['RMSE= ' num2str(computed_RMSE)])
            waitbar(d/2^N,bar,['Progress= ' num2str(d/2^N*100,'%.0f') ' %..'])
            obj.parameters = X;
            % set the flag
            obj.parametersIdentified = true;
            %obj.parameters;
            %obj.computeRMSE(inputDataset,outputDataset);
            %obj.RMSE;
        end
        end
    close(bar);
end
