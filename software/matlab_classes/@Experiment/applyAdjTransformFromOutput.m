function applyAdjTransformFromOutput(obj)
%
% applyAdjointTransform(indata, transform)
%
%     DESCRIPTION: Computes the Adjoint transform of a wrench stream of
%     data
%
%     USAGE: inside a "Model" object
%
%     INPUT:  - obj.outputDataStruct
%             - obj.adjTransformFromOutput
%               Adjoint transformation matrix
%
%     OUTPUT: - obj.outputDataStruct
%
%     Authors: Hosameldin Mohamed
%
%              all authors are with the Italian Istitute of Technology (IIT)
%              email: name.surname@iit.it
%
%     Genoa, January 2022
%
temp_output = zeros(size(obj.outputDataStruct.signals));
for t = 1 : size(obj.outputDataStruct.signals,1)
    data_sample = obj.outputDataStruct.signals(t,:);
    temp_output(t,:) = (obj.adjTransformFromOutput * data_sample')';
end
obj.outputDataStruct.signals = temp_output;
end

