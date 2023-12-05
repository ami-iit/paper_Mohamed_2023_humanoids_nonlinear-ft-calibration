# Installation

This repository uses **MATLAB** (`2021a` and higher, with the [`Signal Processing Toolbox`](https://it.mathworks.com/products/signal.html) installed). The dependencies for running the code are:

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
cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX="/path/to/desired/install/dir"
make install
```

### Windows

```sh
cmake .. -G"Visual Studio 17 2022" -DCMAKE_INSTALL_PREFIX="\path\to\desired\install\dir"
cmake --build . --config Release --target INSTALL
```

6. Source bash file `<CMAKE_INSTALL_PREFIX>/share/humanoids_nonlinear_ft_calibration/setup.sh` in your `bashrc`

```sh
source <CMAKE_INSTALL_PREFIX>/share/humanoids_nonlinear_ft_calibration/setup.sh
```

This adds some environment variables needed by the MATLAB script to run properly.

### Windows

Create the `setup.bat` file with the following content:

```cmd
call <CMAKE_INSTALL_PREFIX>/share/humanoids_nonlinear_ft_calibration/setup.bat 
```

7. Add the datasets to the specific location by running the commands (you need to have `git-lfs` installed):

```sh
git lfs install
git clone https://huggingface.co/datasets/ami-iit/paper_Mohamed_2023_humanoids_nonlinear-ft-calibration_dataset $FT_PAPER_DATASETS_PATH
```

