function exportModelsXMLtoDir(obj, locationDir)
%EXPORTMODELSXMLTODIR Summary of this function goes here
%   Detailed explanation goes here


if(isfolder(locationDir))
    disp(['[exportModelsXMLtoDir] Models will be exported in the directory ' locationDir])
else
    warning(['[exportModelsXMLtoDir] No directory exists with the name: ' locationDir])
    warning('[exportModelsXMLtoDir] Creating a new directory')
    mkdir(locationDir);
end

noOfModels = length(obj.Models);

for i=1:noOfModels
    obj.Models(i).exportModelXML(strcat(locationDir, '/'), [ obj.Models(i).modelClass.string '.xml']);
end

disp(['[exportModelsXMLtoDir] Exported ' num2str(noOfModels) ' models'])

