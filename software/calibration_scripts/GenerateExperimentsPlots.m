%% Parse data
parse_data % creates `parser_training` and `parser_validation`
parser_training.showDirDetails();
parser_validation.showDirDetails();


%% Plot grid trajectory

% folder: 'l5kg-r5kg'
% name: 'robot_logger_device_2023_03_17_20_42_57.mat'
inputTime = parser_training.dirStruct{6}(1).measures.FTs.r_arm_ft_sensor.time;
inputData = [parser_training.dirStruct{6}(1).measures.FTs.r_arm_ft_sensor.data ,...
    parser_training.dirStruct{6}(1).measures.temp.r_arm_ft_sensor.data];
outputTime = parser_training.dirStruct{6}(1).expectedValues.FTs.r_arm_ft_sensor.time;
outputData = parser_training.dirStruct{6}(1).expectedValues.FTs.r_arm_ft_sensor.data;

expGrid = Experiment;
expGrid.appendData(inputTime, inputData, outputTime, outputData);
expGrid.plot3DforceAndTorque()

%%
widthTH = 12;
heightTH = 7;
saveF('grid_traj.eps',[widthTH heightTH])


%% Plot grid trajectory - for multiple loads

fig = figure;
fig.Position = [0 0 1500 1000];
% folder: 'l0kg-r0kg'
% name: 'robot_logger_device_2023_03_17_20_14_15.mat'
plot3(parser_training.dirStruct{1}(1).expectedValues.FTs.r_arm_ft_sensor.data(:,1),...
      parser_training.dirStruct{1}(1).expectedValues.FTs.r_arm_ft_sensor.data(:,2),...
      parser_training.dirStruct{1}(1).expectedValues.FTs.r_arm_ft_sensor.data(:,3),  '.', 'LineWidth', 1)
hold on
% folder: 'l5kg-r5kg'
% name: 'robot_logger_device_2023_03_17_20_42_57.mat'
plot3(parser_training.dirStruct{6}(1).expectedValues.FTs.r_arm_ft_sensor.data(:,1),...
      parser_training.dirStruct{6}(1).expectedValues.FTs.r_arm_ft_sensor.data(:,2),...
      parser_training.dirStruct{6}(1).expectedValues.FTs.r_arm_ft_sensor.data(:,3),  '.', 'LineWidth', 1)

% folder: 'l0kg-r7kg'
% name: 'robot_logger_device_2023_03_17_21_20_37.mat'
plot3(parser_training.dirStruct{3}(1).expectedValues.FTs.r_arm_ft_sensor.data(:,1),...
      parser_training.dirStruct{3}(1).expectedValues.FTs.r_arm_ft_sensor.data(:,2),...
      parser_training.dirStruct{3}(1).expectedValues.FTs.r_arm_ft_sensor.data(:,3),  '.', 'LineWidth', 1)

% folder: 'l0kg-r10kg'
% name: 'robot_logger_device_2023_03_20_18_08_26.mat'
plot3(parser_training.dirStruct{2}(1).expectedValues.FTs.r_arm_ft_sensor.data(:,1),...
      parser_training.dirStruct{2}(1).expectedValues.FTs.r_arm_ft_sensor.data(:,2),...
      parser_training.dirStruct{2}(1).expectedValues.FTs.r_arm_ft_sensor.data(:,3),  '.', 'LineWidth', 1)

grid
xlabel('Force X [N]')
ylabel('Force Y [N]')
zlabel('Force Z [N]')
%legend('F/T sensor meas.', 'Expected meas.')
legend('No load', '5kg load', '7kg load', '10kg load', 'Location','northeast')


%%
widthTH = 12;
heightTH = 7;
saveF('grid_traj_multiple_loads.eps',[widthTH heightTH])


%% Plot grid trajectory - for temperature effect

% left arm

fig = figure;
fig.Position = [0 0 1500 1000];
% folder: 'l0kg-r0kg'
% name: 'robot_logger_device_2023_03_17_20_14_15.mat'
plot3(parser_training.dirStruct{1}(1).measures.FTs.l_arm_ft_sensor.data(:,1),...
      parser_training.dirStruct{1}(1).measures.FTs.l_arm_ft_sensor.data(:,2),...
      parser_training.dirStruct{1}(1).measures.FTs.l_arm_ft_sensor.data(:,3),  '.', 'LineWidth', 1)
hold on
% folder: 'l0kg-r7kg'
% name: 'robot_logger_device_2023_03_17_21_20_37.mat'
plot3(parser_training.dirStruct{3}(1).measures.FTs.l_arm_ft_sensor.data(:,1),...
      parser_training.dirStruct{3}(1).measures.FTs.l_arm_ft_sensor.data(:,2),...
      parser_training.dirStruct{3}(1).measures.FTs.l_arm_ft_sensor.data(:,3),  '.', 'LineWidth', 1)

% folder: 'l0kg-r7kg'
% name: 'robot_logger_device_2023_03_17_22_50_23.mat'
plot3(parser_validation.dirStruct{1}(1).measures.FTs.l_arm_ft_sensor.data(:,1),...
      parser_validation.dirStruct{1}(1).measures.FTs.l_arm_ft_sensor.data(:,2),...
      parser_validation.dirStruct{1}(1).measures.FTs.l_arm_ft_sensor.data(:,3),  '.', 'LineWidth', 1)

grid
xlabel('Force X [N]')
ylabel('Force Y [N]')
zlabel('Force Z [N]')
%legend('F/T sensor meas.', 'Expected meas.')
legend('around 25°C', 'around 37°C', 'around 43°C', 'Location','northeast')

%%

widthTH = 12;
heightTH = 7;
saveF('temperature_effect.eps',[widthTH heightTH])

%% Plot full trajectory

% right arm

fig = figure;
fig.Position = [0 0 1500 1000];
% no load
% folder: 'l0kg-r0kg'
% name: 'robot_logger_device_2023_03_17_20_14_15.mat'
plot3(parser_training.dirStruct{1}(1).measures.FTs.r_arm_ft_sensor.data(:,1),...
      parser_training.dirStruct{1}(1).measures.FTs.r_arm_ft_sensor.data(:,2),...
      parser_training.dirStruct{1}(1).measures.FTs.r_arm_ft_sensor.data(:,3),  '.', 'LineWidth', 1)
hold on
% no load
% folder: 'l5kg-r0kg'
% name: 'robot_logger_device_2023_03_17_20_30_51.mat'
plot3(parser_validation.dirStruct{2}(1).measures.FTs.r_arm_ft_sensor.data(:,1),...
      parser_validation.dirStruct{2}(1).measures.FTs.r_arm_ft_sensor.data(:,2),...
      parser_validation.dirStruct{2}(1).measures.FTs.r_arm_ft_sensor.data(:,3),  '.', 'LineWidth', 1)
% 5kg
% folder: 'l5kg-r5kg'
% name: 'robot_logger_device_2023_03_17_20_42_57.mat'
plot3(parser_training.dirStruct{6}(1).measures.FTs.r_arm_ft_sensor.data(:,1),...
      parser_training.dirStruct{6}(1).measures.FTs.r_arm_ft_sensor.data(:,2),...
      parser_training.dirStruct{6}(1).measures.FTs.r_arm_ft_sensor.data(:,3),  '.', 'LineWidth', 1)
% 7kg
% folder: 'l0kg-r7kg'
% name: 'robot_logger_device_2023_03_17_21_20_37.mat'
plot3(parser_training.dirStruct{3}(1).measures.FTs.r_arm_ft_sensor.data(:,1),...
      parser_training.dirStruct{3}(1).measures.FTs.r_arm_ft_sensor.data(:,2),...
      parser_training.dirStruct{3}(1).measures.FTs.r_arm_ft_sensor.data(:,3),  '.', 'LineWidth', 1)
% 2kg
% folder: 'l2kg-r2kg'
% name: 'robot_logger_device_2023_03_17_22_17_49.mat'
plot3(parser_training.dirStruct{4}(1).measures.FTs.r_arm_ft_sensor.data(:,1),...
      parser_training.dirStruct{4}(1).measures.FTs.r_arm_ft_sensor.data(:,2),...
      parser_training.dirStruct{4}(1).measures.FTs.r_arm_ft_sensor.data(:,3),  '.', 'LineWidth', 1)
% 4kg
% folder: 'l4kg-r4kg'
% name: 'robot_logger_device_2023_03_17_22_30_22.mat'
plot3(parser_training.dirStruct{5}(1).measures.FTs.r_arm_ft_sensor.data(:,1),...
      parser_training.dirStruct{5}(1).measures.FTs.r_arm_ft_sensor.data(:,2),...
      parser_training.dirStruct{5}(1).measures.FTs.r_arm_ft_sensor.data(:,3),  '.', 'LineWidth', 1)
% 7kg
% folder: 'l0kg-r7kg'
% name: 'robot_logger_device_2023_03_17_22_50_23.mat'
plot3(parser_validation.dirStruct{1}(1).measures.FTs.r_arm_ft_sensor.data(:,1),...
      parser_validation.dirStruct{1}(1).measures.FTs.r_arm_ft_sensor.data(:,2),...
      parser_validation.dirStruct{1}(1).measures.FTs.r_arm_ft_sensor.data(:,3),  '.', 'LineWidth', 1)
% 10kg
% folder: 'l0kg-r10kg'
% name: 'robot_logger_device_2023_03_17_22_50_23.mat'
plot3(parser_training.dirStruct{2}(1).measures.FTs.r_arm_ft_sensor.data(:,1),...
      parser_training.dirStruct{2}(1).measures.FTs.r_arm_ft_sensor.data(:,2),...
      parser_training.dirStruct{2}(1).measures.FTs.r_arm_ft_sensor.data(:,3),  '.', 'LineWidth', 1)

grid
xlabel('Force X [N]')
ylabel('Force Y [N]')
zlabel('Force Z [N]')
%legend('F/T sensor meas.', 'Expected meas.')
legend('No load', 'No load', '5kg load', ...
    '7kg load', '2kg load', '4kg load', ...
    '7kg load', '10kg load', 'Location','northeast')


%%
widthTH = 14;
heightTH = 9;
saveF('full_traj_forces.eps',[widthTH heightTH])

%% Plot full trajectory - TORQUES

fig = figure;
fig.Position = [0 0 1500 1000];
% no load
% folder: 'l0kg-r0kg'
% name: 'robot_logger_device_2023_03_17_20_14_15.mat'
plot3(parser_training.dirStruct{1}(1).measures.FTs.r_arm_ft_sensor.data(:,4),...
      parser_training.dirStruct{1}(1).measures.FTs.r_arm_ft_sensor.data(:,5),...
      parser_training.dirStruct{1}(1).measures.FTs.r_arm_ft_sensor.data(:,6),  '.', 'LineWidth', 1)
hold on
% no load
% folder: 'l5kg-r0kg'
% name: 'robot_logger_device_2023_03_17_20_30_51.mat'
plot3(parser_validation.dirStruct{2}(1).measures.FTs.r_arm_ft_sensor.data(:,4),...
      parser_validation.dirStruct{2}(1).measures.FTs.r_arm_ft_sensor.data(:,5),...
      parser_validation.dirStruct{2}(1).measures.FTs.r_arm_ft_sensor.data(:,6),  '.', 'LineWidth', 1)
% 5kg
% folder: 'l5kg-r5kg'
% name: 'robot_logger_device_2023_03_17_20_42_57.mat'
plot3(parser_training.dirStruct{6}(1).measures.FTs.r_arm_ft_sensor.data(:,4),...
      parser_training.dirStruct{6}(1).measures.FTs.r_arm_ft_sensor.data(:,5),...
      parser_training.dirStruct{6}(1).measures.FTs.r_arm_ft_sensor.data(:,6),  '.', 'LineWidth', 1)
% 7kg
% folder: 'l0kg-r7kg'
% name: 'robot_logger_device_2023_03_17_21_20_37.mat'
plot3(parser_training.dirStruct{3}(1).measures.FTs.r_arm_ft_sensor.data(:,4),...
      parser_training.dirStruct{3}(1).measures.FTs.r_arm_ft_sensor.data(:,5),...
      parser_training.dirStruct{3}(1).measures.FTs.r_arm_ft_sensor.data(:,6),  '.', 'LineWidth', 1)
% 2kg
% folder: 'l2kg-r2kg'
% name: 'robot_logger_device_2023_03_17_22_17_49.mat'
plot3(parser_training.dirStruct{4}(1).measures.FTs.r_arm_ft_sensor.data(:,4),...
      parser_training.dirStruct{4}(1).measures.FTs.r_arm_ft_sensor.data(:,5),...
      parser_training.dirStruct{4}(1).measures.FTs.r_arm_ft_sensor.data(:,6),  '.', 'LineWidth', 1)
% 4kg
% folder: 'l4kg-r4kg'
% name: 'robot_logger_device_2023_03_17_22_30_22.mat'
plot3(parser_training.dirStruct{5}(1).measures.FTs.r_arm_ft_sensor.data(:,4),...
      parser_training.dirStruct{5}(1).measures.FTs.r_arm_ft_sensor.data(:,5),...
      parser_training.dirStruct{5}(1).measures.FTs.r_arm_ft_sensor.data(:,6),  '.', 'LineWidth', 1)
% 7kg
% folder: 'l0kg-r7kg'
% name: 'robot_logger_device_2023_03_17_22_50_23.mat'
plot3(parser_validation.dirStruct{1}(1).measures.FTs.r_arm_ft_sensor.data(:,4),...
      parser_validation.dirStruct{1}(1).measures.FTs.r_arm_ft_sensor.data(:,5),...
      parser_validation.dirStruct{1}(1).measures.FTs.r_arm_ft_sensor.data(:,6),  '.', 'LineWidth', 1)
% 10kg
% folder: 'l0kg-r10kg'
% name: 'robot_logger_device_2023_03_17_22_50_23.mat'
plot3(parser_training.dirStruct{2}(1).measures.FTs.r_arm_ft_sensor.data(:,4),...
      parser_training.dirStruct{2}(1).measures.FTs.r_arm_ft_sensor.data(:,5),...
      parser_training.dirStruct{2}(1).measures.FTs.r_arm_ft_sensor.data(:,6),  '.', 'LineWidth', 1)

grid
xlabel('Torque X [Nm]')
ylabel('Torque Y [Nm]')
zlabel('Torque Z [Nm]')
%legend('F/T sensor meas.', 'Expected meas.')
legend('No load', 'No load', '5kg load', ...
    '7kg load', '2kg load', '4kg load', ...
    '7kg load', '10kg load', 'Location','northeast')

%%
widthTH = 12;
heightTH = 7;
saveF('full_traj_torques.eps',[widthTH heightTH])
