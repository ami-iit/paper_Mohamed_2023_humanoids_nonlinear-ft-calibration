function plot3DforceAndTorque(obj)
%PLOTINOUT Plots 3D forces of the measured wrench (input) against the expected wrench
%(output).
%   Detailed explanation goes here


disp('[plot3Dforce] plotting..')

fig = figure;
fig.Position = [0 0 1500 1000];
plot3(obj.outputDataStruct.signals(:,1),...
      obj.outputDataStruct.signals(:,2),...
      obj.outputDataStruct.signals(:,3),  '.', 'LineWidth', 1)
hold on
plot3(obj.outputDataStruct.signals(:,4),...
      obj.outputDataStruct.signals(:,5),...
      obj.outputDataStruct.signals(:,6),  '.', 'LineWidth', 1)
grid
xlabel('Force X [N] / Torque X [Nm]')
ylabel('Force Y [N] / Torque Y [Nm]')
zlabel('Force Z [N] / Torque Z [Nm]')
%legend('F/T sensor meas.', 'Expected meas.')
legend('Forces', 'Torques', 'Location','northeast')


end

