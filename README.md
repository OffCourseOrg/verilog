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

## WSL Setup

  - Install WSL Ubuntu as normal
  `wsl --install`

  after the full wsl installation finishes and the UNIX user is created install following packages:
  ```sh
  sudo apt update && sudo apt upgrade
  sudo apt install python3 python3-is-python python3-graphviz
  sudo apt install xfce4 xdot wslu npm
  ```