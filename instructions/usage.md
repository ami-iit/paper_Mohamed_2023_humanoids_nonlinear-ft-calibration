# Usage

1. Open a terminal, then activate the conda environment by running the command:

```sh
mamba activate ftnlcalib
```

#### Windows

   ```cmd
   call mamba activate <conda-environment-name>
   ```

2. Open MATLAB from the same terminal with the conda activated environment.
3. Browse to the repository.
4. Launch the script [`software/calibration_scripts/calib_rightArm.m`](./software/calibration_scripts/calib_rightArm.m).

The script will perform the following:
  * Parses the experiments' data from the stored datasets.
  * Computes the expected forces-torques measurements by the right-arm F/T sensor using the robot's [URDF](http://wiki.ros.org/urdf/XML/model) models and joints positions measurements.

> [!NOTE]
> To save time, the current dataset already contains the computed expected forces-torques values. If you want to re-compute them, please modify [this line](../software/calibration_scripts/parse_data.m#L26) and [this line](../software/calibration_scripts/parse_data.m#L30) to
> 
> ```matlab
> parser_training.parseInputOutput(true)
> parser_validation.parseInputOutput(true)
> ```

  * Builds polynomial models for calibrating the right-arm F/T sensor.
  * Uses the F/T sensor's expected and actual measurements as input and output datasets to estimate the coefficients of the built models.
  * Computes the values of the coefficients of the models using `OSQP`.
  * Predicts the F/T sensor's measurements using the identified models and compare them to the expected measurements.
  * Generates the plots.
