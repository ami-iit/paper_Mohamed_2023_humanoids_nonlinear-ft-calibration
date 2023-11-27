function predictAllModels(obj, useRegressorMatrix)
%PREDICTALLMODELS predicts the output values for all the models inside the
%FT object

arguments
    obj                   Experiment
    useRegressorMatrix    logical      = false;
end

disp('Predicting output values for all models...')
for k = 1:length(obj.FT.Models)
    disp(['Predicting the output of model no. ' num2str(k) ' ---'])
    if(useRegressorMatrix)
        obj.FT.Models(k).y_hat = obj.FT.Models(k).predictOutput_fast(obj.inputDataStruct.signals, obj.outputDataStruct.signals);
    else
        obj.FT.Models(k).y_hat = obj.FT.Models(k).predictOutput(obj.inputDataStruct.signals, obj.outputDataStruct.signals);
    end
end

end
