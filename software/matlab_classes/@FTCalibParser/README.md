# FTCalibParser

## Input information

1. Type of calibration experiment (arms FTs, jetpack FTs, etc...).
2. Location of the dataset files
3. Location of URDF models.
4. Configuration parameters for computing the expected forces and torques, see [below](#set-the-configuration-for-computing-the-expected-wrenches).

### 💾 Datasets

- The datasets should be collected with the YARP device [`YARPRobotLoggerDevice`](https://github.com/ami-iit/bipedal-locomotion-framework/tree/v0.14.1/devices/YarpRobotLoggerDevice).

- The file structure (concerning the robot `iRonCub-Mk3-FT-ARMS`) should be:

```
<location_storage>
    |--<datasets_iRonCub-Mk3-FT-ARMS/>
        |--<Ex-YYYY-MM-DD_training/>
            |--<l<x>kg-r<y>kg/>
                |robot_logger_device_YYYY_MM_DD_HH_MM_SS.mat
                |robot_logger_device_YYYY_MM_DD_HH_MM_SS.mat
            |
            |--<l<x>kg-r<y>kg/>
                |robot_logger_device_YYYY_MM_DD_HH_MM_SS.mat
                |robot_logger_device_YYYY_MM_DD_HH_MM_SS.mat
            |
        |--<Ex-YYYY-MM-DD_validation/>
            |--<l<x>kg-r<y>kg/>
                |robot_logger_device_YYYY_MM_DD_HH_MM_SS.mat
                |robot_logger_device_YYYY_MM_DD_HH_MM_SS.mat
            |
        |
```

Where the directory name `l<x>kg-r<y>kg/` indicates the robot `iRonCub-Mk3-FT-ARMS` having `<x>`kg of weights on the left arm, and `<y>`kg of weights on the right arm, for the datasets within that directory.

At the moment, the above file structure need to built manually, as `YarpRobotLogger` would start logging on the directory it's been launched from.

### URDF models

- Currently, this repo contains [URDF files for `iRonCub-Mk3-FT-ARMS`](../../../../models/iRonCub-Mk3-FT-ARMS/iRonCub/robots/iRonCub-Mk3-FT-ARMS/) with various weights attached to left and right arms. They can be accessed using the environment variable `$FT_ARMS_URDF_MODELS_PATH`, after completing the [installation procedure](../../../../software-usage.md#procedure).

- The URDF models in `iRonCub-Mk3-FT-ARMS` should have the following file name format: `model_l<x>kg-r<y>kg.urdf`, having `<x>`kg of weights on the left arm, and `<y>`kg of weights on the right arm.

## What this class does

1. It reads the file name with the structure mentioned above, then performs a sanity check.
2. Based on the type of the experiment (arms FTs, jetpack FTs, etc...), it computes the expected forces and torques, **at the moment it supports only arms FTs**.
3. For the experiment of the type (**arms FTs**), based on the name of the directory `l<x>kg-r<y>kg/` it selects the URDF model of format `model_l<x>kg-r<y>kg.urdf` for the computation of the expected forces and torques.
4. It updates the dataset with the computed expected forces and torques using `iDynTree` classes and objects.
5. If the dataset already has a computed expected forces and torques, the parser skips the previous steps from 2 to 4.

## Usage

### Create a parser object passing the type, the URDF model and datasets paths

```matlab
type = 'armsFTs';
locationURDF = getenv("FT_ARMS_URDF_MODELS_PATH");
pathDatasets = [getenv("FT_DATASETS_PATH"), 'datasets_iRonCub-Mk3-FT-ARMS/'];

locationDataset_training   = [pathDatasets, 'Ex-2023-03-17_training/'];
```

Then create the object:

```matlab
parser = FTCalibParser(type, locationURDF, locationDataset_training);
```

### Set the configuration for computing the expected wrenches

```matlab
consideredFixedJointsFTs = {'l_leg_ft_sensor';'r_leg_ft_sensor';'l_foot_front_ft_sensor';'r_foot_front_ft_sensor';'l_foot_rear_ft_sensor';'r_foot_rear_ft_sensor';'l_arm_ft_sensor';'r_arm_ft_sensor'}; % FT sensor names in the URDF
contact_frames = {'root_link'};
use_velocity_and_acceleration = false;
use_floating_base_kinematics = false;
ft_ext_wrench_frames = {'l_foot_front','r_foot_front','l_foot_rear','r_foot_rear', 'l_upper_leg', 'r_upper_leg', 'l_elbow_1', 'r_elbow_1'}; % Names of the contact wrench frames
fixed_link_name = 'root_link';
imu_link_name = 'imu_frame';
```

Then run the command:

```matlab
parser.configComputingExpectedValues(consideredFixedJointsFTs, contact_frames, use_velocity_and_acceleration, use_floating_base_kinematics, ft_ext_wrench_frames, fixed_link_name, imu_link_name)
```

### Run the parsing procedure

```matlab
parser.parseInputOutput()
```

The above method calls a function from `iDynTree` to compute the F/Ts expected wrenches, in case they have not already been computed. If they are already computed, it will skip this step.

If it's desirable to overwrite the computation of expected wrenches, then run:

```matlab
parser.parseInputOutput(true)
```

### Check the parsing details

You can check the details of the parsed datasets by running:

```matlab
parser.showDirDetails();
```

### Plotting the parsed datasets

```matlab
dirIdx = 1; % index of the directory in the dataset location storage
fileIdx = 1 % index of the file within the directory
ftName = 'l_arm_ft_sensor'; % name of the F/T sensor, refer the configuration section above..
parser.plotParsedDataset(dirIdx, fileIdx, ftName)
```

### Load the dataset into an [`Experiment`](../README.md#experiment) object

Selecting the sensor by name

```matlab
expTrain = Experiment;
% add parsed data
expTrain.appendDataFromParser(parser, 'r_arm_ft_sensor');

```

