function removeDatasetOffset(obj)
%REMOVEDATASETOFFSET Removes the offset from a given dataset
%   The fucntion assumes that `obj.inputDataStruct` didn't have it's offset removed
%   before.
obj.inputDataStruct.signals = obj.inputDataStruct.signals(:,1:6) + obj.datasetOffset;
obj.FT.offsetRemoved = true;
end
