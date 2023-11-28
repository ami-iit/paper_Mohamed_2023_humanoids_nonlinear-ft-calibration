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

expTrain_LeftArm.FT.addModels(5);

class_4th = struct('type', 'polynomial', 'np', 4, 'ny', 6, 'nu', 7, 'na', 0, 'nb', 0);
expTrain_LeftArm.FT.Models(1).setModelClass(class_4th);
expTrain_LeftArm.FT.Models(1).selectScaling(true);
expTrain_LeftArm.FT.Models(1).modelClass.string = '4th_degree_lambda=0.5';

expTrain_LeftArm.FT.Models(2).setModelClass(class_4th);
expTrain_LeftArm.FT.Models(2).selectScaling(true);
expTrain_LeftArm.FT.Models(2).modelClass.string = '4th_degree_lambda=1';

expTrain_LeftArm.FT.Models(3).setModelClass(class_4th);
expTrain_LeftArm.FT.Models(3).selectScaling(true);
expTrain_LeftArm.FT.Models(3).modelClass.string = '4th_degree_lambda=10';

expTrain_LeftArm.FT.Models(4).setModelClass(class_4th);
expTrain_LeftArm.FT.Models(4).selectScaling(true);
expTrain_LeftArm.FT.Models(4).modelClass.string = '4th_degree_lambda=50';

expTrain_LeftArm.FT.Models(5).setModelClass(class_4th);
expTrain_LeftArm.FT.Models(5).selectScaling(true);
expTrain_LeftArm.FT.Models(5).modelClass.string = '4th_degree_lambda=100';

expTrain_LeftArm.FT.Models(6).setModelClass(class_4th);
expTrain_LeftArm.FT.Models(6).selectScaling(true);
expTrain_LeftArm.FT.Models(6).modelClass.string = '4th_degree_lambda=200';



%% Run the identification algorithm (call OSQP instances)

expTrain_LeftArm.identifySingleFTModel(1,'qp_lasso',0.5,true)
expTrain_LeftArm.identifySingleFTModel(2,'qp_lasso',1,true)
expTrain_LeftArm.identifySingleFTModel(3,'qp_lasso',10,true)
expTrain_LeftArm.identifySingleFTModel(4,'qp_lasso',50,true)
expTrain_LeftArm.identifySingleFTModel(5,'qp_lasso',100,true)
expTrain_LeftArm.identifySingleFTModel(6,'qp_lasso',200,true)

%%

% Export the identified models as XML files
storage_path = './4degree_qplasso_leftArm/';
expTrain_LeftArm.FT.exportModelsXMLtoDir(storage_path);


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

expValid_LeftArm.predictAllModels(true)

%% Plot validation results

expValid_LeftArm.plotAll('BestFit');

expValid_LeftArm.plotAllError('BestFit');

expValid_LeftArm.plotAllNorm();

