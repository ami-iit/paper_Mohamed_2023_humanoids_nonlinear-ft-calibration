function plotXYtemperature(obj)
%PLOTXYTEMPERATURE Plots the FT internal temperature VS the FT measured wrench 
% (in case the temperature was added to inputDataStruct)
%   Detailed explanation goes here

% check if the temperature data is added
if size(obj.inputDataStruct.signals) >= 7
    disp('[plotXYtemperature] The input dataset includes temperature.. It will be included in the plot..')
    legend_ft = 'FT sensor meas.';
    legend_temp = 'FT Temperature';
    legend_location = 'best';
    sps = [1;3;5;2;4;6];
    sp_rows = 3;
    sp_cols = 2;
    titles = {'Force X','Force Y','Force Z','Torque X','Torque Y','Torque Z'};
    ylabels = {'Force [N]','Force [N]','Force [N]','Torque [N.m]','Torque [N.m]','Torque [N.m]'};
    xlabels = {'Temperature [°C]','Temperature [°C]','Temperature [°C]','Temperature [°C]','Temperature [°C]','Temperature [°C]'};
    
    fig = figure;
    fig.Position = [0 0 1500 1000];
    for p=1:length(sps)
        subplot(sp_rows,sp_cols,sps(p))
        plot(obj.inputDataStruct.signals(:,7), obj.inputDataStruct.signals(:,p))
        grid
        title(titles{p})
        ylabel(ylabels{p})
        xlabel(xlabels{p})
    end

else
    disp('[plotXYtemperature] The data does not include temperature!')
    disp('Make sure you add all the data!')
end


sgtitle({['Plotting X/Y data for exp: ' obj.datasetName] ['Type: ' obj.type] ['FT: ' obj.FT.name ', SN: ' obj.FT.SN]}, 'interpreter', 'none')

end

