function showDirDetails(obj)
%SHOWDIRDETAILS Summary of this function goes here
%   Detailed explanation goes here

disp('------------------------------------------------------------------------------------')
disp('[showDirDetails] Details of the parsed directory')

noOfDirs = length(obj.dirStruct);

for i=1:noOfDirs
    noOfMatFilesInDir = length(obj.dirStruct{i});
    for j=1:noOfMatFilesInDir
        disp('**************************************************************')
        disp(['[showDirDetails] Checking the data in file directory no: ' num2str(i), ', and file no: ', num2str(j)])
        disp(['                 Folder: ' obj.dirStruct{i}(j).folder])
        disp(['                 file Name: ' obj.dirStruct{i}(j).name])
        disp(['                 Left Arm Weight: ' obj.dirStruct{i}(j).leftWeight])
        disp(['                 Right Arm Weight: ' obj.dirStruct{i}(j).rightWeight])
        if(obj.dirStruct{i}(j).dataIsParsed)
            disp('[showDirDetails] Data was properly parsed from this file')
            ftName = fieldnames(obj.dirStruct{i}(j).measures.temp);
            for k=1:numel(ftName)
                disp(['                 Temperature range, for FT (', ftName{k}, '), min= ',...
                    num2str(min(obj.dirStruct{i}(j).measures.temp.(ftName{k}).data), 3),...
                    '°C, max = ', num2str(max(obj.dirStruct{i}(j).measures.temp.(ftName{k}).data), 3),...
                    '°C'])
            end
        else
            warning('[showDirDetails] Data was not properly parsed from this file, aborting')
        end
    end
end

end
