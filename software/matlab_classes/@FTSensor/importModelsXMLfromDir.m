function importModelsXMLfromDir(obj, locationDir, keepExistingModels)
%IMPORTMODELSXMLFROMDIR Summary of this function goes here
%   Detailed explanation goes here

arguments
    obj                    FTSensor
    locationDir
    keepExistingModels logical = false
end

disp('[importModelsXMLfromDir] checking if the directory contains XML files')

% check if the directory contains XML files
xmlDir = dir( fullfile(locationDir,'*.xml') );

% get the number of existing models and add store that number
existingModels = length(obj.Models);
foundXMLfiles = length(length(xmlDir));
disp(['[importModelsXMLfromDir] ' num2str(existingModels) ' models already existed in this FT sensor'])
disp(['[importModelsXMLfromDir] found ' num2str(foundXMLfiles) ' XML files that may contain FT calibration models in the specified location'])

if(~keepExistingModels)
    disp('[importModelsXMLfromDir] removing existing models')
    for m=1:existingModels
        obj.removeModel(1);
    end
    existingModels = 0;
end

if(isempty(xmlDir))
    % no files with the extension '.xml'
    error('[importModelsXMLfromDir] No XML files exist in this directory');
else
    % add Models with the number of XML files
    obj.addModels(length(xmlDir));

    % for each model, import the parameteres from the XML file - start counting from the existing number
    for i=1:length(xmlDir)
        disp(['[importModelsXMLfromDir] Adding the model from XML file no: ' num2str(i) ', name: '  xmlDir(i).name])
        obj.Models(existingModels + i).importModelXML([xmlDir(i).folder, '/', xmlDir(i).name]);
    end
end

end
