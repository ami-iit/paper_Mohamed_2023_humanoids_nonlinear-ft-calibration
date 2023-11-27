function appendDataFromParser(obj, parser, ftName)
%APPENDDATAFROMPARSER calls the appendData() method to get the data from a 
%`FTCalibParser` object 
%   Detailed explanation goes here


    arguments
        obj Experiment
        parser FTCalibParser = FTCalibParser
        ftName char = 'noName'
    end

    disp('[addDataFromParser] Adding the data from the parser..')

    noOfDirs = length(parser.dirStruct);

    for i=1:noOfDirs
        noOfMatFilesInDir = length(parser.dirStruct{i});
        for j=1:noOfMatFilesInDir
            disp(['[appendDataFromParser] Checking the data in file' parser.dirStruct{i}(j).folder, '/', parser.dirStruct{i}(j).name])
            if(parser.dirStruct{i}(j).dataIsParsed)
                inputTime = parser.dirStruct{i}(j).measures.FTs.(ftName).time;
                inputData = [parser.dirStruct{i}(j).measures.FTs.(ftName).data,...
                    parser.dirStruct{i}(j).measures.temp.(ftName).data];
                outputTime = parser.dirStruct{i}(j).expectedValues.FTs.(ftName).time;
                outputData = parser.dirStruct{i}(j).expectedValues.FTs.(ftName).data;
                obj.appendData(inputTime, inputData, outputTime, outputData);
            else
                warning('[appendDataFromParser] Data was not properly parsed from this file, aborting')
            end
        end
    end
end

