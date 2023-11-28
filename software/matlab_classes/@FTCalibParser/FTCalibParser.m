classdef FTCalibParser < handle
    %FTCALIBPARSER a class to parse FT calibration
    %   Contains methods to parse FT calibration data for
    %   the Experiment objects
    
    properties (SetAccess = protected, GetAccess = public)
        experimentType
        locationURDFModel
        locationDataset
        dirStruct
        expectedValuesConfig
    end

    methods
        function obj = FTCalibParser(givenExperimentType, givenURDFLocation, givenDatasetLocation)
            %FTCALIBPARSER Construct an instance of this class
            arguments
                givenExperimentType  char = 'armsFTs'
                givenURDFLocation    char = getenv("FT_PAPER_URDF_MODELS_PATH")
                givenDatasetLocation char = getenv("HOME") 
            end
            obj.experimentType = givenExperimentType;
            obj.locationURDFModel = givenURDFLocation;
            obj.locationDataset = givenDatasetLocation;

            disp('------------------------------------------------------------------------------------')
            disp('[FTCalibParser] Created an FTCalibParser object')
            disp(['[FTCalibParser] Type: ' obj.experimentType ''])
            disp('[FTCalibParser] URDF location: ')
            disp(['               ' obj.locationURDFModel])
            disp('[FTCalibParser] Dataset location: ')
            disp(['               ' obj.locationDataset])

            disp('[FTCalibParser] If the expected wrenches are not computed yet, make sure to fill the')
            disp('                config of the expected data, using the method')
            disp('                configComputingExpectedValues(.)')

            obj.buildDatasetsFileStruct();
        end
    end
end

