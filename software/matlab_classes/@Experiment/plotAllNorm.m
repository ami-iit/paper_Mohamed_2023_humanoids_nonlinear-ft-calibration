function plotAllNorm(obj,performanceCriteria,transformInput,note)
%PLOTALLNORM Plots all the estimates of the experiment in one plot along with
%the output dataset for comparison

arguments
    obj
    performanceCriteria    string= 'BestFit'
    transformInput logical=false
    note    string = ''
end
tempPredictedOutput = cell(length(obj.FT.Models),1);
tempLegendText = cell(length(obj.FT.Models)+1,1);
tempLegendText{1} = 'Expected FT Norm';
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
    tempLegendText{k+1} = obj.FT.Models(k).modelClass.string;
    if ~obj.FT.Models(k).parametersIdentified
        disp('Warning: PlotAll, some models are not identified, make sure you run the method "identifyFTModels".')
    end
end
% convert RMSE matrix to string cell array
switch performanceCriteria
    case 'RMSE'
        tempCriteriaMatrix = strcat(', RMSE= ', cellstr(string(tempCriteriaMatrix)));
    case 'BestFit'
        tempCriteriaMatrix = strcat(', BestFit= ', cellstr(string(tempCriteriaMatrix)), ' %');
end
subPlotsTitles = {'Fx', 'Fy', 'Fz', 'Tx', 'Ty', 'Tz'};
subPlotsYLables = {'Force [N]', 'Force [N]', 'Force [N]', 'Torque [N.m]', 'Torque [N.m]', 'Torque [N.m]'};

fig = figure;
fig.Position = [0 0 1500 2000];
p = [1 3 5 2 4 6]; % this to reorder the plots as row instead of columns
n = size(obj.outputDataStruct.signals,2);

% Quick dirty overriding the computation of the RMSE
normExpectedForce = vecnorm(obj.outputDataStruct.signals(:,1:3),2,2);
normExpectedTorque = vecnorm(obj.outputDataStruct.signals(:,4:6),2,2);
valRMSEForce = zeros(length(obj.FT.Models),1);
valRMSETorque = zeros(length(obj.FT.Models),1);

subplot(2,1,1)
plot(obj.outputDataStruct.time, normExpectedForce,'--','LineWidth',2)

subplot(2,1,2)
plot(obj.outputDataStruct.time, normExpectedTorque,'--','LineWidth',2)

hold on
for k = 1:length(obj.FT.Models)
    tempOutput = tempPredictedOutput{k};
    normMeasuredForce = vecnorm(tempOutput(:,1:3),2,2);
    normMeasuredTorque = vecnorm(tempOutput(:,4:6),2,2);
    % Warning: the input signal is being plotted with the output
    % time
    subplot(2,1,1)
    hold on
    plot(obj.outputDataStruct.time, normMeasuredForce)

    subplot(2,1,2)
    hold on
    plot(obj.outputDataStruct.time, normMeasuredTorque)

    valRMSEForce(k) = sqrt(mean((normExpectedForce-normMeasuredForce).^2));
    valRMSETorque(k) = sqrt(mean((normExpectedTorque-normMeasuredTorque).^2));
end
valRMSEForce = strcat(', RMSE= ', cellstr(string(round(valRMSEForce*100)/100)));
valRMSETorque = strcat(', RMSE= ', cellstr(string(round(valRMSETorque*100)/100)));

subplot(2,1,1)
grid
xlabel('Time [s]')
ylabel('Force [N]')
% add RMSE to the legend
legend(strcat(tempLegendText, [cell(1);valRMSEForce]), 'Interpreter', 'none', 'Location', 'best')
%legend(strcat(tempLegendText, ' '), 'Interpreter', 'none', 'Location', 'best')
title('Force Norm')

subplot(2,1,2)
grid
xlabel('Time [s]')
ylabel('Torque [Nm]')
% add RMSE to the legend
legend(strcat(tempLegendText, [cell(1);valRMSETorque]), 'Interpreter', 'none', 'Location', 'best')
%legend(strcat(tempLegendText, ' '), 'Interpreter', 'none', 'Location', 'best')
title('Torque Norm')

end
