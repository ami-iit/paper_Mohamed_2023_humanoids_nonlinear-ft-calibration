function setOrigCalibMatrix(obj,pathToCalibFile)
%SETORIGCALIBMATRIX Summary of this function goes here
%   Detailed explanation goes here

% For now, set the offset value to 0s
% TODO get the offset value from iCub-Tech calibration file
obj.Offset = zeros(1,6);

calibFile = strcat(pathToCalibFile,'/matrix_', obj.SN,'.txt' );
if (exist(strcat(calibFile),'file')==2)
    obj.OrigCalibMatrix = readCalibMat(calibFile);
else
    disp('[ERROR] Calibration Matrix file not found!')
     return
end
end