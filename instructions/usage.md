### Usage

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
4. Launch the script [`software/calibration_scripts/calib_leftArm.m`](./software/calibration_scripts/calib_leftArm.m).

The script will perform the following:
  * Parses the experiments' data from the stored datasets.
  * Computes the expected forces-torques measurements by the left-arm F/T sensor using the robot's [URDF](http://wiki.ros.org/urdf/XML/model) models and joints positions measurements.
  * Builds polynomial models for calibrating the left-arm F/T sensor.
  * Uses the F/T sensor's expected and actual measurements as input and output datasets to estimate the coefficients of the built models.
  * Computes the values of the coefficients of the models using `OSQP`.
  * Predicts the F/T sensor's measurements using the identified models and compare them to the expected measurements.
  * Generates the plots.
