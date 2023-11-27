function loadCalibMatrixToModel(obj,modelNo)
%LOADCALIBMATRIXTOMODEL Loads the specified `Model` object's parameters with the paramter `OrigCalibMatrix` and `Offset`.
%   Detailed explanation goes here

% Check if the inserted model number is larger than the number of the stored models
if modelNo > max(size(obj.Models))
    disp(['Warning [loadCalibMatrixToModel]: This FT includes ' num2str(max(size(obj.Models))) ' models currently.'])
    disp('Nothing was done!')
else
    % Assuming obj.OrigCalibMatrix is a 6x6 matrix and obj.Offset is a 1x6
    % vector, we concatenate them to for a 7x6 matrix, in order to be
    % compatible with the regressor matrix buit inside Model objects
    if strcmp(obj.Models(modelNo).modelType,'work_bench')
        inParam = [obj.OrigCalibMatrix' ; obj.Offset];
        obj.Models(modelNo).setParametersValue(inParam);
    else
        disp(['Warning [loadCalibMatrixToModel]: The selected model no. ' num2str(modelNo) ' is not of type work_bench.'])
        disp('Nothing was done!')
    end
end
