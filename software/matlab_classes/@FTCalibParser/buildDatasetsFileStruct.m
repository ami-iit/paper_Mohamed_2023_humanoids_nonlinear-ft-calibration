function buildDatasetsFileStruct(obj)
%BUILDDATASETSFILESTRUCT Summary of this function goes here
%   Detailed explanation goes here
    
disp('------------------------------------------------------------------------------------')
disp('[buildDatasetsFileStruct] checking and copying the file structure')

% get the valid folders
dir_struct = dir( fullfile(obj.locationDataset,'l*kg-r*kg') );

if(isempty(dir_struct))
    % no folders with the name format 'l*kg-r*kg'
    error('[buildDatasetsFileStruct] The directory doesnt have folders with the required structure.');
end

noOfDatasetsDirectories = length(dir_struct);
datasetsFilesInDirectories = cell(noOfDatasetsDirectories, 1);

for i=1:length(dir_struct)
    if(dir_struct(i).isdir)
        % check if there are .mat files with each valid folder
        datasetFiles = dir(fullfile(dir_struct(i).folder , '/', dir_struct(i).name, '/','*.mat'));

        if(isempty(datasetFiles))
            % no folders with the name format 'l*kg-r*kg'
            error('[buildDatasetsFileStruct] The sub-directory doesnt contain any .mat file');
        else
            extractedWeightsCell = extract(dir_struct(i).name, digitsPattern);
            leftWeightCell = cell(length(datasetFiles), 1);
            leftWeightCell(:) = {extractedWeightsCell{1}}; %#ok<CCAT1>
            rightWeightCell = cell(length(datasetFiles), 1);
            rightWeightCell(:) = {extractedWeightsCell{2}}; %#ok<CCAT1>

            [datasetFiles.leftWeight] = leftWeightCell{:};
            [datasetFiles.rightWeight] = rightWeightCell{:};
            datasetsFilesInDirectories{i} = datasetFiles;
        end
    end
end

obj.dirStruct = datasetsFilesInDirectories;

end
