```
 *  Copyright: Sybe Feitsma
 *  This work is licensed under CC BY-SA 4.0 
```
#### Part of Series:
  | 05-Home |
  ---------------------
  | => **05A-Home-Security** |
  | 05B-Home-Intruding-step-1 |
  | 05B-Home-Intruding-step-2 |


## Assignment 05A "Home Security"

  05A requires you to construct a simple home security system with a 3 digit pincode. implemented as a moore FSM.
  
#### Your UUT will be checked against a Golden reference. 
  Every clockcyle:

  - UUT State must match REF state  
  - UUT Outputs must match REF Outputs
  - If your UUT and the REF diverge the simulation will halt immediatly

  use GTKWave (The software hiding behind the Debug/Spider button) to debug any issues.\
  *This task uses a golden reference. Therefore the trace in GTKwave will always end at the divergence/error point*

# Task
  Use the provided state graph to implement the home-security Moore FSM
  | |
  |-|
  |  **Outputs keep their value unless changed by a state.** |
  The skeleton UUT (Unit Under Test) file is given with relevant input and outputs. |

  Good luck!


<img src="fsm.svg" style="background-color:white;padding:20px;">

```
 *  This work is licensed under CC BY-SA 4.0 
```