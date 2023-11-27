function plotResAutCorrAll(obj, maxLag)
%PLOTRESAUTCORRALL Plots all the residual analysis results of the experiment

% compute confidence intervals
conf99 = sqrt(2)*erfcinv(2 * 0.01 / 2);
lconf = -conf99/sqrt(length(obj.inputDataStruct.signals));
upconf = conf99/sqrt(length(obj.inputDataStruct.signals));

tempPredictedOutput = cell(length(obj.FT.Models),1);
%tempLegendText = cell(length(obj.FT.Models)+1,1);
%tempLegendText{1} = 'Measured';
for k = 1:length(obj.FT.Models)
    tempPredictedOutput{k} = obj.FT.Models(k).predictOutput(obj.inputDataStruct.signals,obj.outputDataStruct.signals);
    % compute Autocorrelation values for each model
    obj.FT.Models(k).computeAutoCorr(obj.inputDataStruct.signals,obj.outputDataStruct.signals,maxLag);
end

subPlotsTitles = {'Fx', 'Fy', 'Fz', 'Tx', 'Ty', 'Tz'};
%subPlotsYLables = {'Force [N]', 'Force [N]', 'Force [N]', 'Torque [N.m]', 'Torque [N.m]', 'Torque [N.m]'};

for k = 1:length(obj.FT.Models)
    if obj.FT.Models(k).parametersIdentified
        figure, % a seperate plot for each model
        for i = 1:6
            subplot(2,3,i) % make a seperate subplot for each wrench componenet
            stem(obj.FT.Models(k).xCorrLags(:,i),obj.FT.Models(k).xCorrValues(:,i),'filled')
            %ylim([lconf-0.03 1.05])
            hold on
            plot(obj.FT.Models(k).xCorrLags(:,i),lconf*ones(size(obj.FT.Models(k).xCorrLags(:,i))),'r','linewidth',2)
            plot(obj.FT.Models(k).xCorrLags(:,i),upconf*ones(size(obj.FT.Models(k).xCorrLags(:,i))),'r','linewidth',2)
            grid
            xlabel('Time [s]')
            %ylabel(subPlotsYLables{i})
            title(subPlotsTitles{i})
        end
        fig = gcf;
        fig.Position(3) = fig.Position(3)*2;
        fig.Position(4) = fig.Position(4)*2;
        sgtitle({['Exp: ' obj.datasetName] ['Type: ' obj.type] ['FT: ' obj.FT.name ', SN: ' obj.FT.SN] ['Model type: ' obj.FT.Models(k).modelType] ['Sample Autocorrelation with 99% Confidence Intervals']}, 'interpreter', 'none')
    else
        disp('Warning: PlotAutCorrAll, some models are not identified, make sure you run the method "identifyFTModelsLS".')
    end
end

end
