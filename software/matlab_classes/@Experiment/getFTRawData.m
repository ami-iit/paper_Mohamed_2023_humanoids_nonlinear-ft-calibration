function getFTRawData(obj)
%GETFTRAWDATA Applies the inverse of the of the original calibration matrix
%   This function reverses the calibration done in the firmware level by
%   applying the inverse of the original calibration matrix
%   (obj.OrigCalibMatrix)) to indata.

if ~obj.rawDataComputed
    disp(['[Exp: ' obj.type '] [getFTRawData] Computing raw data!'])
    rawdata = pinv(obj.FT.OrigCalibMatrix) * (obj.inputDataStruct.signals' - obj.FT.Offset');
    obj.inputDataStruct.signals = rawdata';
    obj.rawDataComputed = true;
else
    disp(['[Exp: ' obj.type '] [getFTRawData] Raw data is already computed! Nothing to do!'])
end
end
