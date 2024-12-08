## Setup
  ```sh
  sudo apt install npm
  sudo npm install --global yarn
  make install
  ```

## Toolchain
 - Make
 - [OSS-CAD](https://github.com/YosysHQ/oss-cad-suite-build?tab=readme-ov-file#installation)
 - [Netlistsvg-offcourse](https://github.com/OffCourseOrg/netlistsvg-offcourse)

## Evaluation

[yoSYS SBY Reference](https://readthedocs.org/projects/symbiyosys/downloads/pdf/latest/)
SBY will be used for BMC, the Bounded Model Checking, evaluation.
This method allows submodules to be developed and tested individually.
Assignments should not require unique testbenches.
