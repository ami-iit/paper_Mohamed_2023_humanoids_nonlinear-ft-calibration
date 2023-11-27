function [robot_logger_device] = deleteExpectedValues(obj, robot_logger_device)
%DELETEEXPECTEDVALUES Summary of this function goes here
%   Detailed explanation goes here

    disp('------------------------------------------------------------------------------------')
    disp('[deleteExpectedValues] Deleting expectedValues if they exist in the dataset...')

    if isfield(robot_logger_device, "expectedValues")
        disp('[deleteExpectedValues] Expected data exists, REMOVING them from the dataset.')

        robot_logger_device = rmfield(robot_logger_device, "expectedValues");
    else
        warning('[deleteExpectedValues] Expected values dont exist in this dataset, doing nothing...')
    end
end
