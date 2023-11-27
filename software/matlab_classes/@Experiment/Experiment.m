classdef Experiment < handle
    %EXPERIMENT Descripes an experiment to calibrate or to validate the FT
    %sensors
    %   This object contains one FTSensor object, as well as the datasets
    %   used to in the experiemnt. It contains methods to manage the Model
    %   objects contained in the FTSensor object. Further, it has some
    %   methods to plot and show the results.
    
    properties (SetAccess = protected, GetAccess = public)
        type
        datasetName='unnamed'
        FT
        inputDataStruct
        outputDataStruct
        RMSEs=[];
        adjTransformFromOutput % Adjoint transform from the output ref. frame to the input ref. frame
        rawDataComputed
        datasetOffset
    end
    
    methods
        function obj = Experiment(givenType,givenDatasetName,FTSensor_obj)
            %EXPERIMENT Construct an instance of this class
            arguments
                givenType char = 'training'
                givenDatasetName   char = 'unnamed'
                FTSensor_obj FTSensor = FTSensor
            end
            obj.type = givenType;
            obj.datasetName = givenDatasetName;
            assert(isa(FTSensor_obj,'FTSensor'),'Individual Constructor Error:  FTSensor_obj is of class %s, not a FTSensor object.', class(FTSensor_obj));
            obj.FT = FTSensor_obj;
            obj.adjTransformFromOutput = zeros(6);
            obj.rawDataComputed = false;
            obj.datasetOffset = zeros(6,1);
        end
        
        function obj = addData(obj,t_input,input,t_output,output)
            %ADDDATA Adds the input/output datasets and converts them to
            %struct with time, and saves them in the in this object.
            %   TODO: check data consistency
            
            % start time from 0
            %t_input = t_input - t_input(1);
            %t_output = t_output - t_output(1);
            obj.inputDataStruct = struct('time',t_input,'signals',input);
            obj.outputDataStruct = struct('time',t_output,'signals',output);
            obj.rawDataComputed = false;
            obj.computeDatasetOffset();
        end
        
        function obj = appendData(obj,t_input,input,t_output,output)
            %ADDDATA Appends the input/output datasets after converting them to
            %struct with time, they are added to the existing dataset.
            %   TODO: check data consistency
            
            if isempty(obj.inputDataStruct) || isempty(obj.outputDataStruct)
                disp('Dataset is empty, adding the new dataset..')
                obj.inputDataStruct = struct('time',t_input,'signals',input);
                obj.outputDataStruct = struct('time',t_output,'signals',output);
                obj.rawDataComputed = false;
                obj.computeDatasetOffset();
            elseif obj.rawDataComputed
                disp('WARNING: Dataset was modified to compute raw data..')
                disp('Skipping this step!..')
            else
                disp('Appending new dataset..')
                obj.inputDataStruct.time = [obj.inputDataStruct.time ; t_input+obj.inputDataStruct.time(end)];
                obj.inputDataStruct.signals = [obj.inputDataStruct.signals ; input];
                obj.outputDataStruct.time = [obj.outputDataStruct.time ; t_output+obj.outputDataStruct.time(end)];
                obj.outputDataStruct.signals = [obj.outputDataStruct.signals ; output];
            end
        end

        function identifyFTModels(obj,method,lambda,useRegressorMatrixInPred)
            %IDENTIFYFTMODELS Wraps the method in the FTSensor object,
            %and prints some details about the experiment
            %   Detailed explanation goes here
            %   TODO: check if data structures are added
            %   TODO: check the dimentions of the data
            arguments
                obj                         Experiment
                method                      string     = 'qp';
                lambda                      double     = 0;
                useRegressorMatrixInPred    logical    = false;
            end
            disp(['--> Experiment type: ' obj.type ' ,DataSet name: ' obj.datasetName])
            disp(['--> FT sensor with name: ' obj.FT.name ' ,SN: ' obj.FT.SN])
            obj.FT.identifyModels(obj.inputDataStruct.signals, obj.outputDataStruct.signals,0,method,lambda,useRegressorMatrixInPred);
        end

        function identifySingleFTModel(obj, index,method,lambda,useRegressorMatrixInPred)
            %IDENTIFYFTMODELS Wraps the method in the FTSensor object,
            %and prints some details about the experiment
            %   Detailed explanation goes here
            %   TODO: check if data structures are added
            %   TODO: check the dimentions of the data
            arguments
                obj                         Experiment
                index                       int32         = 1;
                method                      string           = 'qp';
                lambda                      double         = 0;
                useRegressorMatrixInPred    logical    = false;
            end
            disp(['--> Experiment type: ' obj.type ' ,DataSet name: ' obj.datasetName])
            disp(['--> FT sensor with name: ' obj.FT.name ' ,SN: ' obj.FT.SN])
            obj.FT.identifyModels(obj.inputDataStruct.signals, obj.outputDataStruct.signals,index,method,lambda,useRegressorMatrixInPred);
        end
        
        function setFTNameAndSN(obj,givenName,givenSN)
            %SETFTNAMEANDSN Changes the name and the serial number of the
            %FTSensor object inside this object
            obj.FT.setNameAndSN(givenName,givenSN);
        end
        
        function setDataSetName(obj,givenName)
            %SETDATASETNAME Changes the name that distinguishes the dataset
            obj.datasetName = givenName;
        end
        
        function setExpType(obj,givenType)
            %SETEXPTYPE Changes the type of the experiment. It should be
            %either "training" or "validation"
            obj.type = givenType;
        end
        
        function setFT(obj,givenFT)
            %SETFT Changes all the parameters of the FT object according to
            %"givenFT"
            obj.FT = givenFT;
        end
        
        function setAdjTransformFromOutput(obj,givenAdjTransform)
            %SETADJTRANSFORMFROMOUTPUT Changes the Adjoint transform matrix
            %to the spcified value
            obj.adjTransformFromOutput = givenAdjTransform;
        end

        function setDatasetOffset(obj,givenOffset)
            %SETDATASETOFFSET Changes the offset attribute of this object
            disp('Setting the offset value of the dataset..')
            obj.datasetOffset = givenOffset;
        end

        function computeDatasetOffset(obj)
            %COMPUTEDATASETOFFSET Computes the offset by subtracting the
            %output dataset from the input dataset
            disp('Computing the offset values of the dataset..')
            disp('.. Subtracting the initial samples..')
            n = size(obj.outputDataStruct.signals, 2);
            obj.datasetOffset = obj.outputDataStruct.signals(1,:) - obj.inputDataStruct.signals(1,1:n);
            disp(['Computed offset= ' num2str(obj.datasetOffset)])
        end
    end
end

