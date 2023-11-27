function configComputingExpectedValues(obj, consideredFixedJointsFTs, contact_frames, use_velocity_and_acceleration, use_floating_base_kinematics, ft_ext_wrench_frames, fixed_link_name, imu_link_name)
%CONFIGCOMPUTINGEXPECTEDVALUES Summary of this function goes here
%   Detailed explanation goes here

disp('------------------------------------------------------------------------------------')
disp('[configComputingExpectedValues] Storing the options of computing the expected FT wrenches')
obj.expectedValuesConfig.consideredFixedJointsFTs = consideredFixedJointsFTs;
obj.expectedValuesConfig.contact_frames = contact_frames;
obj.expectedValuesConfig.use_velocity_and_acceleration = use_velocity_and_acceleration;
obj.expectedValuesConfig.use_floating_base_kinematics = use_floating_base_kinematics;
obj.expectedValuesConfig.ft_ext_wrench_frames = ft_ext_wrench_frames;
obj.expectedValuesConfig.fixed_link_name = fixed_link_name;
obj.expectedValuesConfig.imu_link_name = imu_link_name;

end
