function setWorkBenchModel(obj)
%SETWORKBENCHMODEL Sets an identity matrix in the parameters of this Model, 
% Output = Input
%   Detailed explanation goes here

    disp('[setWorkBenchModel] Model will have an identity matrix for the parameters.')

    % parameters matrix initialization
    [rows, cols] = obj.getNumParameters();
    obj.parameters = zeros(rows, cols);

    % Fill the first (ny) rows with an identity matrix
    currentInputParamsLocation = obj.modelClass.na * obj.modelClass.ny + 1;
    currentInputRange = currentInputParamsLocation:currentInputParamsLocation + obj.modelClass.nu-1;
    obj.parameters(currentInputRange,:) = eye(obj.modelClass.nu);

    obj.parametersIdentified = true;
    obj.modelClass.string = 'work_bench';
end
