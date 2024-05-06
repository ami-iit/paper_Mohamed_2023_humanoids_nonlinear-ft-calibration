function plotAllError(obj,performanceCriteria,transformInput,note)
%PLOTALLERROR Plots the estimation error of the experiment
% between the estimated outputs and output dataset

arguments
    obj
    performanceCriteria    string= 'BestFit'
    transformInput logical=false
    note    string = ''
end
tempPredictedOutput = cell(length(obj.FT.Models),1);
tempLegendText = cell(length(obj.FT.Models),1);
% RMSE matrix: raws represent the models and columns represent the F/T componenets
tempCriteriaMatrix = zeros(length(obj.FT.Models),6);
inputSize = size(obj.inputDataStruct.signals,2);
outputSize = size(obj.outputDataStruct.signals,2);
for k = 1:length(obj.FT.Models)
    if(strcmp(obj.FT.Models(k).modelClass.string , 'work_bench'))
        ny = obj.FT.Models(k).modelClass.ny;
        nu = obj.FT.Models(k).modelClass.nu;
        datasetOffset = [obj.datasetOffset , zeros(1,abs(nu-ny))];
    else
        datasetOffset = zeros(1,outputSize);
    end
    if(transformInput)
        tempPredictedOutput{k} = obj.adjTransformFromOutput * (obj.FT.Models(k).y_hat + datasetOffset);
        % compute RMSE for each model
        obj.FT.Models(k).computeRMSE(obj.inputDataStruct.signals,obj.outputDataStruct.signals - datasetOffset,obj.adjTransformFromOutput);
        obj.FT.Models(k).computeBestFit(obj.inputDataStruct.signals,obj.outputDataStruct.signals - datasetOffset,obj.adjTransformFromOutput);
    else
        tempPredictedOutput{k} = obj.FT.Models(k).y_hat + datasetOffset;
        % compute RMSE for each model
        obj.FT.Models(k).computeRMSE(obj.inputDataStruct.signals,obj.outputDataStruct.signals - datasetOffset,eye(6));
        obj.FT.Models(k).computeBestFit(obj.inputDataStruct.signals,obj.outputDataStruct.signals - datasetOffset,eye(6));
    end
    % fill the RMSE/BestFit matrix
    switch performanceCriteria
        case 'RMSE'
            tempCriteriaMatrix(k,:) = obj.FT.Models(k).RMSE;
        case 'BestFit'
            tempCriteriaMatrix(k,:) = obj.FT.Models(k).BestFit * 100;
    end
    tempLegendText{k} = obj.FT.Models(k).modelClass.string;
    if ~obj.FT.Models(k).parametersIdentified
        disp('Warning: PlotAll, some models are not identified, make sure you run the method "identifyFTModels".')
    end
end
% convert RMSE matrix to string cell array
switch performanceCriteria
    case 'RMSE'
        tempCriteriaMatrix = strcat(', RMSE= ', cellstr(string(round(tempCriteriaMatrix*100)/100)));
    case 'BestFit'
        tempCriteriaMatrix = strcat(', BestFit= ', cellstr(string(round(tempCriteriaMatrix*100)/100)), ' %');
end
subPlotsTitles = {'Fx', 'Fy', 'Fz', 'Tx', 'Ty', 'Tz'};
subPlotsYLables = {'Force [N]', 'Force [N]', 'Force [N]', 'Torque [N.m]', 'Torque [N.m]', 'Torque [N.m]'};

fig = figure;
fig.Position = [0 0 1500 2000];
%p = [1 3 5 2 4 6]; % this to reorder the plots as row instead of columns
p = 1:6;
n = size(obj.outputDataStruct.signals,2);
for i = 1:n
    subplot(6,1,p(i))
    hold on
    for k = 1:length(obj.FT.Models)
        tempOutput = tempPredictedOutput{k};
        % Warning: the input signal is being plotted with the output
        % time
        plot(obj.outputDataStruct.time, obj.outputDataStruct.signals(:,i) - tempOutput(:,i))
    end
    grid
    if(i == 6)
        xlabel('Time [s]')
    end
    ylabel(subPlotsYLables{i})
    % add RMSE to the legend
    legend(strcat(tempLegendText, [tempCriteriaMatrix(:,i)]), 'Interpreter', 'none', 'Location', 'eastoutside')
    title(subPlotsTitles{i})
end

end
