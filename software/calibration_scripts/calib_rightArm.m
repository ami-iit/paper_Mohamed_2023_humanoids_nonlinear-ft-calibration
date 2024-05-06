%% Parse data
parse_data % creates `parser_training` and `parser_validation`
parser_training.showDirDetails();
parser_validation.showDirDetails();

%% Creating training and validation `Experiment` objects
% Training

expTrain_RightArm = Experiment;

% add parsed data
expTrain_RightArm.appendDataFromParser(parser_training, 'r_arm_ft_sensor');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

expTrain_RightArm.setDataSetName('in-situ Right Arm');
expTrain_RightArm.setExpType('training');
expTrain_RightArm.FT.setNameAndSN('RightArm','--');
expTrain_RightArm.plotInOut();

%% Add the polynomial models

expTrain_RightArm.FT.addModels(4);

class_linear = struct('type', 'polynomial', 'np', 1, 'ny', 6, 'nu', 7, 'na', 0, 'nb', 0);
expTrain_RightArm.FT.Models(1).setModelClass(class_linear);
expTrain_RightArm.FT.Models(1).selectScaling(true);
expTrain_RightArm.FT.Models(1).modelClass.string = '1st_degree';

class_quad = struct('type', 'polynomial', 'np', 2, 'ny', 6, 'nu', 7, 'na', 0, 'nb', 0);
expTrain_RightArm.FT.Models(2).setModelClass(class_quad);
expTrain_RightArm.FT.Models(2).selectScaling(true);
expTrain_RightArm.FT.Models(2).modelClass.string = '2nd_degree';

class_cubic = struct('type', 'polynomial', 'np', 3, 'ny', 6, 'nu', 7, 'na', 0, 'nb', 0);
expTrain_RightArm.FT.Models(3).setModelClass(class_cubic);
expTrain_RightArm.FT.Models(3).selectScaling(true);
expTrain_RightArm.FT.Models(3).modelClass.string = '3rd_degree';

class_fourth = struct('type', 'polynomial', 'np', 4, 'ny', 6, 'nu', 7, 'na', 0, 'nb', 0);
expTrain_RightArm.FT.Models(4).setModelClass(class_fourth);
expTrain_RightArm.FT.Models(4).selectScaling(true);
expTrain_RightArm.FT.Models(4).modelClass.string = '4th_degree';

class_fifth = struct('type', 'polynomial', 'np', 5, 'ny', 6, 'nu', 7, 'na', 0, 'nb', 0);
expTrain_RightArm.FT.Models(5).setModelClass(class_fifth);
expTrain_RightArm.FT.Models(5).selectScaling(true);
expTrain_RightArm.FT.Models(5).modelClass.string = '5th_degree';



%% Run the identification algorithm (call OSQP instances)

expTrain_RightArm.identifyFTModels('qp',0,true)

%%

% Export the identified models as XML files
storage_path = './1to5degree_qp_rightArm/';
expTrain_RightArm.FT.exportModelsXMLtoDir(storage_path)

%% Plot training results

expTrain_RightArm.plotAll('RMSE');

expTrain_RightArm.plotAllError('RMSE');

expTrain_RightArm.plotAllNorm();


%% Validation

expValid_RightArm = Experiment;

% add parsed data
expValid_RightArm.appendDataFromParser(parser_validation, 'r_arm_ft_sensor');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

expValid_RightArm.setFT(expTrain_RightArm.FT);
expValid_RightArm.setDataSetName('in-situ Right Arm');
expValid_RightArm.setExpType('validation');
expValid_RightArm.plotInOut();

%%

expValid_RightArm.predictAllModels(true)

%%

expValid_RightArm.plotAll('RMSE');
widthTH = 35;
heightTH = 35;
saveF('results_validation_rightArm.eps',[widthTH heightTH])

expValid_RightArm.plotAllError('RMSE');
widthTH = 25;
heightTH = 30;
saveF('results_validation_error_rightArm.eps',[widthTH heightTH])

expValid_RightArm.plotAllNorm();
widthTH = 25;
heightTH = 20;
saveF('results_validation_norm_rightArm.eps',[widthTH heightTH])

