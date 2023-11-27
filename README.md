<h1 align="center">
    Nonlinear In-situ Calibration of Strain-Gauge Force/Torque Sensors for Humanoid Robots
</h1>


<div align="center">


Hosameldin Awadalla Omer Mohamed, Gabriele Nava, Punith Reddy Vanteddu, Francesco Braghin and Daniele Pucci


</div>

<p align="center">



</p>

<div align="center">
    2023 IEEE-RAS International Conference on Humanoid Robots (Humanoids)
</div>

<p align="center">

![lifting_configs](https://github.com/ami-iit/paper_Mohamed_2023_humanoids_nonlinear-ft-calibration/assets/45564317/383e31a8-e426-4688-a684-b8666c144ea7)

</p>

<div align="center">
  <a href="#installation"><b>Installation</b></a> |
  <b>Paper</b> |
  <b>Video</b>
</div>

### Installation

This repository uses **MATLAB** (`2021a` and higher). The dependencies for running the code are:

- [iDynTree](https://github.com/robotology/idyntree) along with the MATLAB bindings (`v10.0.0`).
- [OSQP](https://doi.org/10.1007/s12532-020-00179-2) (`v6.2.3`).
- [osqp-matlab-cmake-buildsystem](https://github.com/ami-iit/osqp-matlab-cmake-buildsystem) (`v6.2.3`).

The dependencies can be easily installed using [conda](https://docs.conda.io/en/latest/) package manager. You can follow the following steps for installation:

1. Install a conda distribution or the minimal `mambaforge` distribution. You can follow the instructions in [`robotology-superbuild` documentation section](https://github.com/robotology/robotology-superbuild/blob/master/doc/conda-forge.md#install-a-conda-distribution).

2. Clone this repo:

```sh
git clone https://github.com/ami-iit/paper_Mohamed_2023_humanoids_nonlinear_ft_calibration.git
```

3. Navigate to the repo folder, then run the command:

```sh
mamba env create -f environment.yml
```

It will install all the required dependencies (excluding MATLAB) in a conda environment called `ftnlcalib`.

4. From the repo top folder, create a build directory and move in it:

```sh
mkdir build && cd build
```

5. Compile and install the code:

```sh
cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX="where-you-want-to-install"
```

Then:

```sh
make install
```

6. Source bash file `<CMAKE_INSTALL_PREFIX>/share/humanoids_nonlinear_ft_calibration/setup.sh` in your `bashrc`

```sh
source <CMAKE_INSTALL_PREFIX>/share/humanoids_nonlinear_ft_calibration/setup.sh
```

This adds some environment variables needed by the MATLAB script to run properly.

7. Add the datasets to the specific location by running the command:

```sh
git clone https://huggingface.co/datasets/ami-iit/paper_Mohamed_2023_humanoids_nonlinear-ft-calibration_dataset $FT_PAPER_DATASETS_PATH
```

### Usage

1. Open a terminal, then activate the environment by running the command:

```sh
mamba activate ftnlcalib
```

2. Open MATLAB.
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

### Citing this work

If you find the work useful, please consider citing:

```bibtex
@INPROCEEDINGS{Mohamed2023nonlinearftcalib,
  author={Mohamed, Hosameldin Awadalla Omer and Nava, Gabriele and Vanteddu, Punith Reddy and Braghin, Francesco and Pucci, Daniele},
  booktitle={2023 IEEE-RAS International Conference on Humanoid Robots (Humanoids)}, 
  title={Nonlinear In-situ Calibration of Strain-Gauge Force/Torque Sensors for Humanoid Robots}, 
  year={2023},
  volume={},
  number={},
  pages={},
  doi={}}
```

### Maintainer

This repository is maintained by:

| | |
|:---:|:---:|
| [<img src="https://avatars1.githubusercontent.com/u/45564317?s=400&v=4" width="40">](https://github.com/HosameldinMohamed) | [@HosameldinMohamed](https://github.com/HosameldinMohamed) |

