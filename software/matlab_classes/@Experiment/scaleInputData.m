function scaleInputData(obj)
%SCALEINPUTDATA Applies scaling to the obj.inputDataStruct.signals by
%dividing on the maximum value in the dataset

% check if the flag is set
if obj.dataScaledFlag == false
    % compute the scaleValue from the inputData
    obj.scaleValue = max(max(obj.inputDataStruct.signals));
    
    % Apply scaling
    obj.inputDataStruct.signals = obj.inputDataStruct.signals / obj.scaleValue;
    
    % Set the flag
    obj.dataScaledFlag = true;
else
    disp(['scaleInputdata( ): data is already scaled, skipping this method!'])
end
end
