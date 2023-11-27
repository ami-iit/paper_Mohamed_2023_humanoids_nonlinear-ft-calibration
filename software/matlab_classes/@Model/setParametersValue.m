function setParametersValue(obj,givenParameters)
%
% setParametersValue(obj,givenParameter)
%
%     DESCRIPTION: Directly sets the parameters values of the model
%
%     USAGE: inside a "Model" object
%
%     INPUT:    - Model object {Model}
%               should contain all the necessary information such as the
%               model type
%
%     OUTPUT: - Given parameters values {matrix}
%               The values that directly modify the parameters of the model
%               At the moment there is no check of the format
%
%     Authors: Hosameldin Mohamed
%
%              all authors are with the Italian Istitute of Technology (IIT)
%              email: name.surname@iit.it
%
%     Genoa, August 2021
%

obj.parameters = givenParameters;
end

