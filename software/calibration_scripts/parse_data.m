clear
close all
clc

%% Common configuration

type = 'armsFTs';
locationURDF = getenv("FT_ARMS_URDF_MODELS_PATH");
pathDatasets = [getenv("FT_PAPER_DATASETS_PATH"), '/'];

consideredFixedJointsFTs = {'l_leg_ft_sensor';'r_leg_ft_sensor';'l_foot_front_ft_sensor';'r_foot_front_ft_sensor';'l_foot_rear_ft_sensor';'r_foot_rear_ft_sensor';'l_arm_ft_sensor';'r_arm_ft_sensor'}; % FT sensor names in the URDF
contact_frames = {'root_link'};
use_velocity_and_acceleration = false;
use_floating_base_kinematics = false;
ft_ext_wrench_frames = {'l_foot_front','r_foot_front','l_foot_rear','r_foot_rear', 'l_upper_leg', 'r_upper_leg', 'l_elbow_1', 'r_elbow_1'}; % Names of the contact wrench frames
fixed_link_name = 'root_link';
imu_link_name = 'imu_frame';

%% Creating the data parsers

locationDataset_training   = [pathDatasets, 'training_datasets/'];
locationDataset_validation = [pathDatasets, 'validation_datasets/'];

parser_training = FTCalibParser(type, locationURDF, locationDataset_training);
parser_training.configComputingExpectedValues(consideredFixedJointsFTs, contact_frames, use_velocity_and_acceleration, use_floating_base_kinematics, ft_ext_wrench_frames, fixed_link_name, imu_link_name)
parser_training.parseInputOutput()

parser_validation = FTCalibParser(type, locationURDF, locationDataset_validation);
parser_validation.configComputingExpectedValues(consideredFixedJointsFTs, contact_frames, use_velocity_and_acceleration, use_floating_base_kinematics, ft_ext_wrench_frames, fixed_link_name, imu_link_name)
parser_validation.parseInputOutput()

