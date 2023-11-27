function exportModelXML(obj, locationPath, modelName)
%EXPORTMODELXML Summary of this function goes here
%   Detailed explanation goes here

if(obj.parametersIdentified && strcmp(obj.modelClass.type, 'polynomial'))
    disp('Exporting model params values..')

    docNode = com.mathworks.xml.XMLUtils.createDocument('group');
    group = docNode.getDocumentElement;
    group.setAttribute('name','modelClassParams');

    param1 = docNode.createElement('param');
    param1.setAttribute('name','np');
    param1.appendChild(docNode.createTextNode(num2str(obj.modelClass.np)));

    param2 = docNode.createElement('param');
    param2.setAttribute('name','ny');
    param2.appendChild(docNode.createTextNode(num2str(obj.modelClass.ny)));

    param3 = docNode.createElement('param');
    param3.setAttribute('name','nu');
    param3.appendChild(docNode.createTextNode(num2str(obj.modelClass.nu)));

    param4 = docNode.createElement('param');
    param4.setAttribute('name','na');
    param4.appendChild(docNode.createTextNode(num2str(obj.modelClass.na)));

    param5 = docNode.createElement('param');
    param5.setAttribute('name','nb');
    param5.appendChild(docNode.createTextNode(num2str(obj.modelClass.nb)));

    param6 = docNode.createElement('param');
    param6.setAttribute('name','string');
    param6.appendChild(docNode.createTextNode(obj.modelClass.string));

    group.appendChild(param1);
    group.appendChild(param2);
    group.appendChild(param3);
    group.appendChild(param4);
    group.appendChild(param5);
    group.appendChild(param6);

    for k=1:size(obj.parameters,1)
        newRow = strcat('(',num2str(obj.parameters(k,:)),')');
        newVal = docNode.createElement('param');
        newVal.setAttribute('name',strcat('row',num2str(k)));
        newVal.appendChild(docNode.createTextNode(newRow));
        group.appendChild(newVal);
    end

    xmlwrite(strcat(locationPath,modelName),docNode);
    disp(['Done exporting model in: ' locationPath])
else
    disp('exportModelXML: Parameters are not yet identified for this model, or the model type is not valid, nothing will be done!!')
end
end

