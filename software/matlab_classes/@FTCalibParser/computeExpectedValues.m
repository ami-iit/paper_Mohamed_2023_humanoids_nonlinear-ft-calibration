function [expectedValues] = computeExpectedValues(obj, robot_logger_device, pathURDFModel)
%COMPUTEEXPECTEDVALUES Summary of this function goes here
%   Detailed explanation goes here

    disp('------------------------------------------------------------------------------------')
    disp('[computeExpectedValues] Starting computing expectedValues using iDynTree bindings...')
    %% Load the robot's URDF model
    dofs = length(robot_logger_device.description_list);

    consideredJoints = iDynTree.StringVector();
    % get the list of joints from the description_list
    for i = 1 : dofs
        consideredJoints.push_back(robot_logger_device.description_list{i});
    end

    % Append the consideredJoints list with the FTs fixed joints
    for i = 1 : size(obj.expectedValuesConfig.consideredFixedJointsFTs,1)
        consideredJoints.push_back(obj.expectedValuesConfig.consideredFixedJointsFTs{i});
    end

    estimatorLoader = iDynTree.ModelLoader();
    estimatorLoader.loadReducedModelFromFile(pathURDFModel, consideredJoints);
    estimator = iDynTree.ExtWrenchesAndJointTorquesEstimator();
    estimator.setModelAndSensors(estimatorLoader.model(),estimatorLoader.sensors);

    %% Start computing expected wrenches
    q_idyn   = iDynTree.JointPosDoubleArray(dofs);
    dq_idyn  = iDynTree.JointDOFsDoubleArray(dofs);
    ddq_idyn = iDynTree.JointDOFsDoubleArray(dofs);

    q_idyn_dyn   = iDynTree.VectorDynSize(dofs);
    dq_idyn_dyn  = iDynTree.VectorDynSize(dofs);
    ddq_idyn_dyn = iDynTree.VectorDynSize(dofs);

    % Gravity vector
    grav_idyn = iDynTree.Vector3();
    grav = [0.0;0.0;-9.81];

    if strcmp(obj.expectedValuesConfig.contact_frames, 'root_link') ~= 1
        kinDyn = iDynTree.KinDynComputations();
        kinDyn.loadRobotModel(estimator.model());
        q0_idyn   = iDynTree.JointPosDoubleArray(dofs);
        q0_idyn.fromMatlab(robot_logger_device.joints_state.positions.data(:,1));
        kinDyn.setJointPos(q0_idyn);
        B_R_S = kinDyn.getRelativeTransform('root_link', 'l_sole').getRotation().toMatlab();
        grav_B = B_R_S*grav;
        grav_idyn.fromMatlab(grav_B);
    else
        grav_idyn.fromMatlab(grav);
    end

    % Prepare estimator variables
    % Store number of sensors
    n_fts = estimator.sensors().getNrOfSensors(iDynTree.SIX_AXIS_FORCE_TORQUE);

    % The estimated FT sensor measurements
    expFTmeasurements = iDynTree.SensorsMeasurements(estimator.sensors());

    % The estimated external wrenches
    estContactForces = iDynTree.LinkContactWrenches(estimator.model());

    % The estimated joint torques
    estJointTorques = iDynTree.JointDOFsDoubleArray(dofs);

    % Set the contact information in the estimator
    contact_index = -1*ones(length(obj.expectedValuesConfig.contact_frames),1);
    for j = 1 : length(obj.expectedValuesConfig.contact_frames)
        contact_index(j) = estimator.model().getFrameIndex(char(obj.expectedValuesConfig.contact_frames{j}));
    end

    if(obj.expectedValuesConfig.use_floating_base_kinematics)
        disp('[computeExpectedValues] Using FLOATING BASE Kinematics in computing expected wrenches...')
        disp(['[computeExpectedValues] IMU name = ' obj.expectedValuesConfig.imu_link_name])
        imu_link_index = estimator.model().getFrameIndex(char(obj.expectedValuesConfig.imu_link_name));
    else
        disp('[computeExpectedValues] Using FIXED BASE Kinematics in computing expected wrenches...')
        disp(['[computeExpectedValues] Fixed link name = ' obj.expectedValuesConfig.fixed_link_name])
        fixed_link_index = estimator.model().getFrameIndex(char(obj.expectedValuesConfig.fixed_link_name));
    end

    estimator.model().toString();


    % Get ft names from urdf to know the corresponding order
    ft_names_from_urdf= cell(n_fts,1);
    for i = 1 : n_fts
        ft_names_from_urdf{i} = [estimator.sensors().getSensor(iDynTree.SIX_AXIS_FORCE_TORQUE,i-1).getName(), '_sensor'];
    end

    % Specify unknown wrenches
    unknownWrench = iDynTree.UnknownWrenchContact();
    unknownWrench.unknownType = iDynTree.FULL_WRENCH;
    unknownWrench.contactPoint.zero();

    fullBodyUnknowns = iDynTree.LinkUnknownWrenchContacts(estimator.model());
    fullBodyUnknowns.clear();

    contact_frame_idx = -1*ones(length(obj.expectedValuesConfig.contact_frames),1);

    for j = 1 : length(obj.expectedValuesConfig.contact_frames)
        contact_frame_idx(j) = estimator.model().getFrameIndex(obj.expectedValuesConfig.contact_frames{j});
        fullBodyUnknowns.addNewContactInFrame(estimator.model(),contact_frame_idx(j),unknownWrench);
    end

    % We need a new set of unknowns, as we now need 7 unknown wrenches, one for
    % each submodel in the estimator
    fullBodyUnknownsExtWrenchEst = iDynTree.LinkUnknownWrenchContacts(estimator.model());

    % get the total number of samples
    len = size(robot_logger_device.joints_state.positions.data(:,:), 2);
    
    bar = waitbar(0, 'Starting');
    for i = 1 : len

        q   = robot_logger_device.joints_state.positions.data(:,i);

        if(norm(q(end-5:end) - [ 0.48795367  0.12632504 -0.02054239 -1.15031368 -0.61794705 -0.12991608]) < 0.001)
            disp("Stop here")
        end

        if obj.expectedValuesConfig.use_velocity_and_acceleration
            dq  = robot_logger_device.joints_state.velocities.data(:,i);
            ddq = robot_logger_device.joints_state.accelerations.data(:,i);
        else
            dq  = 0*robot_logger_device.joints_state.velocities.data(:,i);
            ddq = 0*robot_logger_device.joints_state.accelerations.data(:,i);
        end

        q_idyn.fromMatlab(q);
        dq_idyn.fromMatlab(dq);
        ddq_idyn.fromMatlab(ddq);

        q_idyn_dyn.fromMatlab(q);
        dq_idyn_dyn.fromMatlab(dq);
        ddq_idyn_dyn.fromMatlab(ddq);

        % Update robot kinematics
        if obj.expectedValuesConfig.use_floating_base_kinematics
            imu_lin_acc = robot_logger_device.accelerometers.rfeimu_acc.data(:,i)';
            imu_lin_acc_dyn = iDynTree.Vector3;
            imu_lin_acc_dyn.fromMatlab(imu_lin_acc);

            imu_ang_vel = robot_logger_device.gyros.rfeimu_gyro.data(:,i)';
            imu_ang_vel_dyn = iDynTree.Vector3;
            imu_ang_vel_dyn.fromMatlab(imu_ang_vel);

            % For now we just assume that the angular acceleration is zero
            imu_ang_acc_dyn = iDynTree.Vector3;
            imu_ang_acc_dyn.zero();

            estimator.updateKinematicsFromFloatingBase(q_idyn, dq_idyn,ddq_idyn, imu_link_index,...
                                                    imu_lin_acc_dyn, imu_ang_vel_dyn, imu_ang_acc_dyn);
        else
            estimator.updateKinematicsFromFixedBase(q_idyn, dq_idyn, ddq_idyn, fixed_link_index, grav_idyn);
        end

        fullBodyUnknownsExtWrenchEst.clear();

        for j = 1 : length(obj.expectedValuesConfig.ft_ext_wrench_frames)
            fullBodyUnknownsExtWrenchEst.addNewUnknownFullWrenchInFrameOrigin(estimator.model(),estimator.model().getFrameIndex(obj.expectedValuesConfig.ft_ext_wrench_frames{j}));
        end

        % Sensor wrench buffer
        estimatedSensorWrench = iDynTree.Wrench();
        estimatedSensorWrench.fromMatlab(zeros(1,6));

        % Run the prediction of FT measurements

        % run the estimation
        estimator.computeExpectedFTSensorsMeasurements(fullBodyUnknowns,expFTmeasurements,estContactForces,estJointTorques);

        % store the estimated measurements
        for j = 1:n_fts
            expFTmeasurements.getMeasurement(iDynTree.SIX_AXIS_FORCE_TORQUE, j-1, estimatedSensorWrench);

            output.FTs.(ft_names_from_urdf{j}).('data')(i,:) = estimatedSensorWrench.toMatlab()';
            % time vector is copied for the timestamps of the joint positions
            output.FTs.(ft_names_from_urdf{j}).('time')(i,:) = robot_logger_device.joints_state.positions.timestamps(i);
        end

        waitbar(i/len, bar, sprintf('[computeExpectedValues] Progress: %d %%', floor(i/len*100)));
    end
    close(bar)

    expectedValues = output;

    % reset the time vector to start from 0
    for j = 1:n_fts
        expectedValues.FTs.(ft_names_from_urdf{j}).('time') = expectedValues.FTs.(ft_names_from_urdf{j}).('time') - expectedValues.FTs.(ft_names_from_urdf{j}).('time')(1);
    end

    disp('[computeExpectedValues] Done computing expectedValues...')
end
