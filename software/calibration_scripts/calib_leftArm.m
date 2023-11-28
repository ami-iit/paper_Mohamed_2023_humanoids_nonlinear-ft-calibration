%% Parse data
parse_data % creates `parser_training` and `parser_validation`
parser_training.showDirDetails();
parser_validation.showDirDetails();

%% Creating training and validation `Experiment` objects
% Training

expTrain_LeftArm = Experiment;

% Add parsed data
expTrain_LeftArm.appendDataFromParser(parser_training, 'l_arm_ft_sensor');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

expTrain_LeftArm.setDataSetName('in-situ Left Arm');
expTrain_LeftArm.setExpType('training');
expTrain_LeftArm.FT.setNameAndSN('LeftArm','--');
expTrain_LeftArm.plotInOut();

%% Add the polynomial models

expTrain_LeftArm.FT.addModels(4);

class_linear = struct('type', 'polynomial', 'np', 1, 'ny', 6, 'nu', 7, 'na', 0, 'nb', 0);
expTrain_LeftArm.FT.Models(1).setModelClass(class_linear);
expTrain_LeftArm.FT.Models(1).selectScaling(true);
expTrain_LeftArm.FT.Models(1).modelClass.string = '1st_degree';

class_quad = struct('type', 'polynomial', 'np', 2, 'ny', 6, 'nu', 7, 'na', 0, 'nb', 0);
expTrain_LeftArm.FT.Models(2).setModelClass(class_quad);
expTrain_LeftArm.FT.Models(2).selectScaling(true);
expTrain_LeftArm.FT.Models(2).modelClass.string = '2nd_degree';

class_cubic = struct('type', 'polynomial', 'np', 3, 'ny', 6, 'nu', 7, 'na', 0, 'nb', 0);
expTrain_LeftArm.FT.Models(3).setModelClass(class_cubic);
expTrain_LeftArm.FT.Models(3).selectScaling(true);
expTrain_LeftArm.FT.Models(3).modelClass.string = '3rd_degree';

class_fourth = struct('type', 'polynomial', 'np', 4, 'ny', 6, 'nu', 7, 'na', 0, 'nb', 0);
expTrain_LeftArm.FT.Models(4).setModelClass(class_fourth);
expTrain_LeftArm.FT.Models(4).selectScaling(true);
expTrain_LeftArm.FT.Models(4).modelClass.string = '4th_degree';

class_fifth = struct('type', 'polynomial', 'np', 5, 'ny', 6, 'nu', 7, 'na', 0, 'nb', 0);
expTrain_LeftArm.FT.Models(5).setModelClass(class_fifth);
expTrain_LeftArm.FT.Models(5).selectScaling(true);
expTrain_LeftArm.FT.Models(5).modelClass.string = '5th_degree';



%% Run the identification algorithm (call OSQP instances)

expTrain_LeftArm.identifyFTModels('qp',0)

%%

% Export the identified models as XML files
storage_path = './1to5degree_qp_leftArm/';
for k=1:5
    expTrain_LeftArm.FT.Models(k).exportModelXML(storage_path, [expTrain_LeftArm.FT.Models(k).modelClass.string '.xml'])
end

%% Plot training results

expTrain_LeftArm.plotAll('BestFit');

expTrain_LeftArm.plotAllError('BestFit');

expTrain_LeftArm.plotAllNorm();


%% Validation

expValid_LeftArm = Experiment;

% Add parsed data
expValid_LeftArm.appendDataFromParser(parser_validation, 'l_arm_ft_sensor');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

expValid_LeftArm.setFT(expTrain_LeftArm.FT);
expValid_LeftArm.setDataSetName('in-situ Left Arm');
expValid_LeftArm.setExpType('validation');
expValid_LeftArm.plotInOut();

%% Run the prediction with all the identified models

expValid_LeftArm.predictAllModels()

%% Plot validation results

expValid_LeftArm.plotAll('BestFit');

expValid_LeftArm.plotAllError('BestFit');

expValid_LeftArm.plotAllNorm();

