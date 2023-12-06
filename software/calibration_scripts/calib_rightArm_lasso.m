%% Parse data
parse_data % creates `parser_training` and `parser_validation`
parser_training.showDirDetails();
parser_validation.showDirDetails();

%% Creating training and validation `Experiment` objects
% Training

expTrain_RightArm = Experiment;

% Add parsed data
expTrain_RightArm.appendDataFromParser(parser_training, 'r_arm_ft_sensor');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

expTrain_RightArm.setDataSetName('in-situ Right Arm');
expTrain_RightArm.setExpType('training');
expTrain_RightArm.FT.setNameAndSN('RightArm','--');
expTrain_RightArm.plotInOut();

%% Add the polynomial models

expTrain_RightArm.FT.addModels(5);

class_4th = struct('type', 'polynomial', 'np', 4, 'ny', 6, 'nu', 7, 'na', 0, 'nb', 0);
expTrain_RightArm.FT.Models(1).setModelClass(class_4th);
expTrain_RightArm.FT.Models(1).selectScaling(true);
expTrain_RightArm.FT.Models(1).modelClass.string = '4th_degree_lambda=0.5';

expTrain_RightArm.FT.Models(2).setModelClass(class_4th);
expTrain_RightArm.FT.Models(2).selectScaling(true);
expTrain_RightArm.FT.Models(2).modelClass.string = '4th_degree_lambda=1';

expTrain_RightArm.FT.Models(3).setModelClass(class_4th);
expTrain_RightArm.FT.Models(3).selectScaling(true);
expTrain_RightArm.FT.Models(3).modelClass.string = '4th_degree_lambda=10';

expTrain_RightArm.FT.Models(4).setModelClass(class_4th);
expTrain_RightArm.FT.Models(4).selectScaling(true);
expTrain_RightArm.FT.Models(4).modelClass.string = '4th_degree_lambda=50';

expTrain_RightArm.FT.Models(5).setModelClass(class_4th);
expTrain_RightArm.FT.Models(5).selectScaling(true);
expTrain_RightArm.FT.Models(5).modelClass.string = '4th_degree_lambda=100';

expTrain_RightArm.FT.Models(6).setModelClass(class_4th);
expTrain_RightArm.FT.Models(6).selectScaling(true);
expTrain_RightArm.FT.Models(6).modelClass.string = '4th_degree_lambda=200';



%% Run the identification algorithm (call OSQP instances)

expTrain_RightArm.identifySingleFTModel(1,'qp_lasso',0.5,true)
expTrain_RightArm.identifySingleFTModel(2,'qp_lasso',1,true)
expTrain_RightArm.identifySingleFTModel(3,'qp_lasso',10,true)
expTrain_RightArm.identifySingleFTModel(4,'qp_lasso',50,true)
expTrain_RightArm.identifySingleFTModel(5,'qp_lasso',100,true)
expTrain_RightArm.identifySingleFTModel(6,'qp_lasso',200,true)

%%

% Export the identified models as XML files
storage_path = './4degree_qplasso_rightArm/';
expTrain_RightArm.FT.exportModelsXMLtoDir(storage_path);


%% Plot training results

expTrain_RightArm.plotAll('BestFit');

expTrain_RightArm.plotAllError('BestFit');

expTrain_RightArm.plotAllNorm();


%% Validation

expValid_RightArm = Experiment;

% Add parsed data
expValid_RightArm.appendDataFromParser(parser_validation, 'l_arm_ft_sensor');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

expValid_RightArm.setFT(expTrain_RightArm.FT);
expValid_RightArm.setDataSetName('in-situ Right Arm');
expValid_RightArm.setExpType('validation');
expValid_RightArm.plotInOut();

%% Run the prediction with all the identified models

expValid_RightArm.predictAllModels(true)

%% Plot validation results

expValid_RightArm.plotAll('BestFit');

expValid_RightArm.plotAllError('BestFit');

expValid_RightArm.plotAllNorm();

