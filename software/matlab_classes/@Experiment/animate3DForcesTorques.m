function animate3DForcesTorques(obj, video_location)

% create the video writer with 1 fps
writerObj = VideoWriter(video_location);
writerObj.FrameRate = 60;
% open the video writer
open(writerObj);

figure,

x0=10;
y0=10;
width=720;
height=1000;
set(gcf,'position',[x0,y0,width,height])

fx = obj.outputDataStruct.signals(:,1);
fy = obj.outputDataStruct.signals(:,2);
fz = obj.outputDataStruct.signals(:,3);

sp1 = subplot(2,1,1);
sp1.XLim = [min(fx) max(fx)];
sp1.YLim = [min(fy) max(fy)];
sp1.ZLim = [min(fz) max(fz)];

forces_curve = animatedline('LineWidth',2);
grid
view(-4, 10);
hold on;
xlabel('Force X [N]')
ylabel('Force Y [N]')
zlabel('Force Z [N]')

tx = obj.outputDataStruct.signals(:,4);
ty = obj.outputDataStruct.signals(:,5);
tz = obj.outputDataStruct.signals(:,6);

sp2 = subplot(2,1,2);
sp2.XLim = [min(tx) max(tx)];
sp2.YLim = [min(ty) max(ty)];
sp2.ZLim = [min(tz) max(tz)];

torques_curve = animatedline('LineWidth',2);
grid
view(-16, 46);
hold on;
xlabel('Torque X [N]')
ylabel('Torque Y [N]')
zlabel('Torque Z [N]')


% set(gca, 'XLim', [min(fx), max(fx)], 'YLim', [min(fy), max(fy)], 'ZLim', [min(fz), max(fz)]);

for i=1:10:length(fz)
    addpoints(forces_curve, fx(i), fy(i), fz(i));
    addpoints(torques_curve, tx(i), ty(i), tz(i));
    axes(sp1);
    head_force = scatter3(fx(i), fy(i), fz(i), 'filled', 'MarkerFaceColor','r', 'MarkerEdgeColor','r');
    axes(sp2);
    head_torque = scatter3(tx(i), ty(i), tz(i), 'filled', 'MarkerFaceColor','r', 'MarkerEdgeColor','r');
    drawnow
%     pause(0.01);
% write the frames to the video
    F = getframe(gcf) ;
    writeVideo(writerObj, F);

    delete(head_force);
    delete(head_torque);
end

% close the writer object
close(writerObj);
fprintf('Sucessfully generated the video\n')

end
