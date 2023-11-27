function showStats(obj)
%SHOWSTATS Prints summary of the experiment, along with the performance
%measures that compares between each Model objects inside the FTSensor
%object

disp(['--> Experiment type: ' obj.type ' ,DataSet name: ' obj.datasetName])
disp(['--> FT sensor with name: ' obj.FT.name ' ,SN: ' obj.FT.SN])
disp(['--> No. of tested models: ' num2str(length(obj.FT.Models))])

for k = 1:length(obj.FT.Models)
    disp(['--> Model no. ' num2str(k)])
    disp(['--> Model type: ' obj.FT.Models(k).modelClass.string])
    obj.FT.Models(k).computeRMSE(obj.inputDataStruct.signals,obj.outputDataStruct.signals);
    disp(['--> Computed RMSE: ' num2str(obj.FT.Models(k).RMSE)])
    obj.FT.Models(k).computeBestFit(obj.inputDataStruct.signals,obj.outputDataStruct.signals);
    disp(['--> Computed BestFit: ' num2str(obj.FT.Models(k).BestFit * 100) '%'])
end
disp('--------------------------------------------------------------------------------')
end

