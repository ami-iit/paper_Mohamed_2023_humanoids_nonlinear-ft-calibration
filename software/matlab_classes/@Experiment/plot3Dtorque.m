function plot3Dtorque(obj)
%PLOTINOUT Plots 3D torques of the measured wrench (input) against the expected wrench
%(output).
%   Detailed explanation goes here


disp('[plot3Dtorque] plotting..')

fig = figure;
fig.Position = [0 0 1500 1000];
% plot3(obj.inputDataStruct.signals(:,4),...
%       obj.inputDataStruct.signals(:,5),...
%       obj.inputDataStruct.signals(:,6), '.', 'LineWidth', 2)
% hold on
plot3(obj.outputDataStruct.signals(:,4),...
      obj.outputDataStruct.signals(:,5),...
      obj.outputDataStruct.signals(:,6),  '.', 'LineWidth', 1)
grid
xlabel('Torque X [N]')
ylabel('Torque Y [N]')
zlabel('Torque Z [N]')
%legend('F/T sensor meas.', 'Expected meas.')
legend('Expected meas.')

end

