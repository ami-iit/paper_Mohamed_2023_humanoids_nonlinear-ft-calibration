function parseInputOutput(obj, overwriteExpectedValues, urdfFileName)
%PARSEINPUTOUTPUT Summary of this function goes here
%   Detailed explanation goes here

arguments
    obj                        FTCalibParser
    overwriteExpectedValues    logical = false
    urdfFileName               char = ''
end

disp('------------------------------------------------------------------------------------')
noOfDirs = length(obj.dirStruct);

for i=1:noOfDirs
    noOfMatFilesInDir = length(obj.dirStruct{i});
    for j=1:noOfMatFilesInDir
        obj.dirStruct{i}(j).dataIsParsed = false;
        disp('**************************************************************')
        disp(['[parseInputOutput] Loading the dataset file: ' obj.dirStruct{i}(j).name])
        load([obj.dirStruct{i}(j).folder, '/', obj.dirStruct{i}(j).name], "robot_logger_device");

        disp(['[parseInputOutput] Attached weight on the left arm: ' obj.dirStruct{i}(j).leftWeight 'kg'])
        disp(['[parseInputOutput] Attached weight on the right arm: ' obj.dirStruct{i}(j).rightWeight 'kg'])

        disp('[parseInputOutput] Filtering and parsing FT measurements..')

        % create a list of FTs
        ft_names = {'l_arm_ft_sensor', 'r_arm_ft_sensor', 'l_foot_front_ft_sensor', 'l_foot_rear_ft_sensor', 'r_foot_front_ft_sensor', 'r_foot_rear_ft_sensor'};

        % Allow the possibility to parse log files with "robot_logger_device.FTs.l_arm_ft" or "robot_logger_device.FTs.l_arm_ft_sensor"
        if(isfield(robot_logger_device.FTs, "l_arm_ft_sensor"))
            ft_names_in_logger = ft_names;
        elseif(isfield(robot_logger_device.FTs, "l_arm_ft"))
            ft_names_in_logger = extractBefore(ft_names,"_sensor");
        end

        for k=1:length(ft_names)
            % smoothing and copying the data
            sgolay_order = 3;
            sgolay_framelen = 101;

            obj.dirStruct{i}(j).measures.FTs.(ft_names{k}).data = sgolayfilt(robot_logger_device.FTs.(ft_names_in_logger{k}).data(:,:)', sgolay_order, sgolay_framelen);
            obj.dirStruct{i}(j).measures.FTs.(ft_names{k}).time = robot_logger_device.FTs.(ft_names_in_logger{k}).timestamps';

            obj.dirStruct{i}(j).measures.temp.(ft_names{k}).data = sgolayfilt(robot_logger_device.temperatures.(ft_names_in_logger{k}).data(:), sgolay_order, sgolay_framelen);
            obj.dirStruct{i}(j).measures.temp.(ft_names{k}).time = robot_logger_device.temperatures.(ft_names_in_logger{k}).timestamps';

            % start timestamps from 0
            obj.dirStruct{i}(j).measures.FTs.(ft_names{k}).time = obj.dirStruct{i}(j).measures.FTs.(ft_names{k}).time - obj.dirStruct{i}(j).measures.FTs.(ft_names{k}).time(1);
            obj.dirStruct{i}(j).measures.temp.(ft_names{k}).time = obj.dirStruct{i}(j).measures.temp.(ft_names{k}).time - obj.dirStruct{i}(j).measures.temp.(ft_names{k}).time(1);
        end

        % removing expectedValues if requested
        if(overwriteExpectedValues)
            disp('[parseInputOutput] If filed "expectedValues" exists in the dataset, it will be overwritten!')
            robot_logger_device = obj.deleteExpectedValues(robot_logger_device);
        end

        % start computing expected wrenches
        disp('[parseInputOutput] Start computing expected wrenches')
        % check if field 'robot_logger_device.expectedValues' exists
        if isfield(robot_logger_device, "expectedValues") 
            disp('[parseInputOutput] Expected data exists, skipping generating them')
            obj.dirStruct{i}(j).expectedValues = robot_logger_device.expectedValues;
            obj.dirStruct{i}(j).dataIsParsed = true;

        else
            disp('[parseInputOutput] Expected values dont exist or removed from this dataset, starting genarating them..')

            if(isempty(urdfFileName))
                % model_l4kg-r4kg.urdf
                urdfFileName = strcat("model_l", obj.dirStruct{i}(j).leftWeight,"kg-r", obj.dirStruct{i}(j).rightWeight,"kg.urdf");
            end
            pathURDFModel = convertStringsToChars(strcat(obj.locationURDFModel, urdfFileName));

            if(isfile(pathURDFModel))
                obj.dirStruct{i}(j).expectedValues = obj.computeExpectedValues(robot_logger_device, pathURDFModel);

                robot_logger_device.expectedValues = obj.dirStruct{i}(j).expectedValues;

                % save expectedValues from after computing them
                disp('[parseInputOutput] Saving the generated expected wrenches to the same dataset file')
                obj.dirStruct{i}(j).dataIsParsed = true;
                save([obj.dirStruct{i}(j).folder, '/', obj.dirStruct{i}(j).name], "robot_logger_device");
            else
                warning(['[parseInputOutput] URDF file ' pathURDFModel ' doesnt exist, doing nothing'])
            end
        end
    end
end


disp('[parseInputOutput] Done parsing')
end
