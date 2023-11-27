classdef Model < handle
    %MODEL Calibration model of 6 axes force/torque sensors
    %   The class contains information about the model type, the model paramteres, as well as
    %   the methods to compute these parameters given input/ouput data
    
    properties (SetAccess = protected, GetAccess = public)
        RMSE
        BestFit
        A % regressor matrix in `Ax=b`
        b % output vector in `Ax=b`
        xCorrValues % stores the residuals autocorrelation values
        xCorrLags % stores the residuals autocorrelations time delays
        scaling
        paramScaleVector
        net
    end

    properties (SetAccess = public, GetAccess = public)
        modelClass
        parametersIdentified
        parameters
        y_hat
    end
    
    methods
        function obj = Model(givenClass,selScaling)
            %MODEL Construct an instance of this class
            arguments
                givenClass struct = struct('type', 'polynomial', 'np', 1, 'ny', 6, 'nu', 6, 'na', 0, 'nb', 0)
                selScaling logical = false
            end
            obj.setModelClass(givenClass);
            obj.parametersIdentified = false;
            obj.scaling = selScaling;
        end
        
        function displayModelDetails(obj)
            %DISPLAYMODELDETAILS Prints the model type and whether the
            %model has been identified or not
            disp(['Model class is: ' obj.modelClass.string])
            if obj.parametersIdentified == true
                disp('Model has been identified')
                obj.parameters
            else
                disp('Model has NOT been identified')
            end
        end
        
        function selectScaling(obj,givenSelection)
            %SELECTSCALING selects whether the input dataset is scaled or not.
            %The selection is according to the value `givenSelection`
            obj.scaling = givenSelection;
        end

        function setModelClass(obj,givenClass)
            %SETMODELCLASS generates a string out of the values of
            %np,ny,nu,na,nb
            obj.modelClass = givenClass;
            if(strcmp(obj.modelClass.type, 'polynomial'))
                obj.modelClass.string = ['np' num2str(obj.modelClass.np),...
                '|ny' num2str(obj.modelClass.ny), '|nu' num2str(obj.modelClass.nu),...
                '|na' num2str(obj.modelClass.na), '|nb' num2str(obj.modelClass.nb)];
                disp('Created new model..')
                disp(['Model class is set to: ' obj.modelClass.string])
                obj.getNumParameters();
            elseif(strcmp(obj.modelClass.type, 'neuralnet'))
                obj.modelClass.string = 'NeuralNetwork';
            end
        end

        function [rows, cols] = getNumParameters(obj)
            %SETNUMPARAMETERS computes the number of parameters based on the values of
            % np, ny, nu, na and nb
            if(strcmp(obj.modelClass.type, 'polynomial'))
                obj.parametersIdentified = false;
                np = obj.modelClass.np; % polynomial order
                ny = obj.modelClass.ny; % number of "considered" outputs
                nu = obj.modelClass.nu; % number of "considered" inputs
                na = obj.modelClass.na; % number of delayed samples of the output
                nb = obj.modelClass.nb; % number of delayed samples of the input
    
                numParameters = ny * na +1; % the output and offset parts
                for p=1:np
                    numParameters  = numParameters + (nb+1) * nchoosek(nu+p-1,p); % the input part
                end
                disp(['Number of parameters of Model ' num2str(obj.modelClass.string) ' is ' num2str(numParameters) ' x ' num2str(ny) ' = ' num2str(numParameters*ny)])
                rows = numParameters;
                cols = ny;
            else
                warning('Model type is not polynomial, cant show the number of parameters..')
            end
        end

        function markAsWorkBenchModel(obj)
            % MARKASWORKBENCHMODEL sets the string:
            % obj.modelClass.string='work_bench', which is then skipped
            % during identification
            obj.modelClass.type = 'polynomial';
            obj.modelClass.string = 'work_bench';
        end
    end
end

