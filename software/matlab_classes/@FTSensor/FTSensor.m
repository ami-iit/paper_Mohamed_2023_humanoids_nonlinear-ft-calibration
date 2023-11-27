classdef FTSensor < handle
    %FTSENSOR 6-axis Force/Torque sensor object
    %   Contains description about the FT sensor being used, plus an array
    %   of Model objects
    
    properties (SetAccess = protected, GetAccess = public)
        name
        SN
        OrigCalibMatrix
        Offset
        Models=[];
    end

    properties (SetAccess = public, GetAccess = public)
        offsetRemoved
    end
    
    methods
        function obj = FTSensor(givenName,givenSN,nModels)
            %FTSENSOR Construct an instance of this class
            arguments
                givenName char = 'unnamed'
                givenSN   char = 'blankSN'
                nModels int16 = 1
            end
            obj.name = givenName;
            obj.SN = givenSN;
            obj = obj.addModels(nModels);
            obj.Offset = zeros(1,6);
            obj.offsetRemoved = false;
        end
        
        function obj = addModels(obj,N,modelClass,selScaling)
            %ADDMODELS Adds models with the number specified by the input N
            arguments
                obj                    FTSensor
                N                       double = 1
                modelClass     struct = struct('type', 'polynomial', 'np', 1, 'ny', 6, 'nu', 6, 'na', 0, 'nb', 0);
                selScaling       logical = false
            end
            for ik = 1:N
                if ~isempty(obj.Models)
                    obj.Models(end+1) = Model(modelClass,selScaling);
                else
                    obj.Models = Model(modelClass,selScaling);
                end
            end
        end

        function obj = removeModel(obj,index)
            %REMOVEMODELS removes the model with the specified index

            if ~isempty(obj.Models(index))
                obj.Models(index) = [];
            else
                disp(['[FT remove model] The model with the specified index ' num2str(index) ' does not exist.'])
            end
        end
        
        function displayModelsDescription(obj)
            %DISPLAYMODELSDESCRIPTION Prints a summary about the Model
            %objects contained in this object
            %   Detailed explanation goes here
            disp(['FT sensor with name: ' obj.name ' ,SN: ' obj.SN])
            for ik = 1:length(obj.Models)
                fprintf('Model %d:\n',ik);
                obj.Models(ik).displayModelDetails;
                fprintf('*-----------------------------*\n')
            end
        end
        
        function identifyModels(obj, inputDataset, outputDataset, indices, method, lambda, useRegressorMatrixInPred)
            %IDENTIFYMODELS Passes by each Model object added to this
            %object and performs the model identification method for each.
            %   Detailed explanation goes here
            arguments
                obj                               FTSensor
                inputDataset 
                outputDataset
                indices                           int32         = 0;
                method                            string        = 'qp';
                lambda                            double        = 0;
                useRegressorMatrixInPred          logical       = false;
            end
            noModels = length(obj.Models);
            if noModels >= 0
                if indices == 0 % identify all models
                    indices = 1:noModels;
                    disp('Identifying all the models added to the list..')
                end
                for id = indices
                    if id > length(obj.Models)
                        disp(['Invalid Model number, max no= ' num2str(noModels) ',, skipping..'])
                    else
                        fprintf('Identifying model %d:\n',id);
                        if method == 'least_squares'
                            obj.Models(id).identifyParametersLS(inputDataset,outputDataset,useRegressorMatrixInPred);
                        elseif method ==  'qp'
                            obj.Models(id).identifyParametersQP(inputDataset,outputDataset,lambda,useRegressorMatrixInPred);
                        elseif method == 'qp_lasso'
                            obj.Models(id).identifyParametersQPLASSO(inputDataset,outputDataset,lambda,useRegressorMatrixInPred);
                        else
                            disp('Invalid identification method, nothing was done!')
                        end
                        fprintf('*-----------------------------*\n')
                    end
                end
            else
                disp('No models to identify, you can add models using "addModels(nModels)".')
            end
        end
        
        function setNameAndSN(obj,givenName,givenSN)
            %SETNAMEANDSN Changes the name and serial number attributes of
            %this object
            oldName = obj.name;
            disp(['Changing the name from ' num2str(oldName) ' to ' givenName])
            obj.name = givenName;
            oldSN = obj.SN;
            disp(['Changing the serial number from ' num2str(oldSN) ' to ' givenSN])
            obj.SN = givenSN;
        end
        
        function setOffset(obj,givenOffset)
            %SETOFFSET Changes the offset attribute of this object
            disp(['Setting the offset value of FT: ' obj.name ', SN: ' obj.SN])
            obj.Offset = givenOffset;
        end
    end
end

