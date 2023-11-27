function plotInOut(obj)
%PLOTINOUT Plots the FT wrench (input) against the expected wrench
%(output). The expected wrench is assumed to be transformed w.r.t. the FT
%frame. The temperature is also plotted at the bottom of the wrenches (in case it
%was added to inputDataStruct)
%   Detailed explanation goes here

% check if the temperature data is added
if size(obj.inputDataStruct.signals) >= 7
    disp('[plotInOut] The input dataset includes temperature.. It will be included in the plot..')
    legend_ft = 'FT sensor meas.';
    legend_exp = 'Expected meas.';
    legend_temp = 'FT Temperature';
    legend_location = 'best';
    sps = [1;3;5;2;4;6;7;8];
    sp_rows = 4;
    sp_cols = 2;
    titles = {'Force X','Force Y','Force Z','Torque X','Torque Y','Torque Z','Internal Temperature','Internal Temperature'};
    ylabels = {'Force [N]','Force [N]','Force [N]','Torque [N.m]','Torque [N.m]','Torque [N.m]','Temperature [°C]','Temperature [°C]'};
    xlabels = {'Time [s]','Time [s]','Time [s]','Time [s]','Time [s]','Time [s]','Time [s]','Time [s]'};
else
    disp('[plotInOut] The data does not include temperature..')
    legend_ft = 'FT sensor meas.';
    legend_exp = 'Expected meas.';
    legend_location = 'best';
    sps = [1;3;5;2;4;6];
    sp_rows = 3;
    sp_cols = 2;
    titles = {'Force X','Force Y','Force Z','Torque X','Torque Y','Torque Z'};
    ylabels = {'Force [N]','Force [N]','Force [N]','Torque [N.m]','Torque [N.m]','Torque [N.m]'};
    xlabels = {'Time [s]','Time [s]','Time [s]','Time [s]','Time [s]','Time [s]'};
end

fig = figure;
fig.Position = [0 0 1500 1000];
for p=1:length(sps)
    subplot(sp_rows,sp_cols,sps(p))
    if(p <= size(obj.inputDataStruct.signals,2))
        plot(obj.inputDataStruct.time, obj.inputDataStruct.signals(:,p))
    else
        plot(obj.inputDataStruct.time, obj.inputDataStruct.signals(:,end))
    end
    if(p <= size(obj.outputDataStruct.signals,2))
        hold on
        plot(obj.outputDataStruct.time, obj.outputDataStruct.signals(:,p))
        legend(legend_ft, legend_exp, 'Location', legend_location)
    else
        legend(legend_temp, 'Location', legend_location)
    end
    grid
    title(titles{p})
    ylabel(ylabels{p})
    xlabel(xlabels{p})
end

sgtitle({['Plotting in/out data for exp: ' obj.datasetName] ['Type: ' obj.type] ['FT: ' obj.FT.name ', SN: ' obj.FT.SN]}, 'interpreter', 'none')

end

