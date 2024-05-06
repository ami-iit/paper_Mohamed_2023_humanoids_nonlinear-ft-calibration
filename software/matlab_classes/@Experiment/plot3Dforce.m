function plot3Dforce(obj)
%PLOTINOUT Plots 3D forces of the measured wrench (input) against the expected wrench
%(output).
%   Detailed explanation goes here


disp('[plot3Dforce] plotting..')

fig = figure;
fig.Position = [0 0 1500 1000];
% plot3(obj.inputDataStruct.signals(:,1),...
%       obj.inputDataStruct.signals(:,2),...
%       obj.inputDataStruct.signals(:,3), '.', 'LineWidth', 1)
% hold on
plot3(obj.outputDataStruct.signals(:,1),...
      obj.outputDataStruct.signals(:,2),...
      obj.outputDataStruct.signals(:,3), '.', 'LineWidth', 4)
grid
xlabel('Force X [N]')
ylabel('Force Y [N]')
zlabel('Force Z [N]')
%legend('F/T sensor meas.', 'Expected meas.')


end

