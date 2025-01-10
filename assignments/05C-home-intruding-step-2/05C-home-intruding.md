```
 *  Copyright: Sybe Feitsma
 *  This work is licensed under CC BY-SA 4.0 
```
# TODO YOSYS BMC
#### Part of Series:
  | 05-Home |
  ---------------------
  | 05A-Home-Security |
  | 05B-Home-Intruding-step-1 |
  | => **05C-Home-Intruding-step-2** |

 
### Assignment 05C "Home Intruding" Step 2

  **05C** requires you to construct a tool to crack the security system of **05A**. As you might have noticed, the home security fsm you implemented previously contains a critical security flaw. It does not raise the alarm when incorrect pincodes are repeatedly entered. Exposing the security system to a *bruteforce* attack.

  
#### Your UUT will be checked against a Golden reference. 
  Every clockcyle:

  - UUT Outputs must match REF Outputs
  - If your UUT and the REF diverge the simulation will halt immediatly

  use GTKWave (The software hiding behind the Debug/Spider button) to debug any issues.\
  *This task uses a golden reference. Therefore the trace in GTKwave will always end at the divergence/error point*

  ## Task
  Combine four instances of the 4-bit counter from the previous step, to bruteforce the security system pincode. three to generate the pincode and one to cycle between the digits of the pincode.
  | |
  |-|
  | The counter module is provided. You do not have to create it again |
  | The skeleton UUT.v file is given with relevant input and outputs. |

  #### Extra:

  After passing this assignment you will see the found pincode. Extra credit is looking for it manually in GTKWave.

  #### Good luck!

<img src="diagram.svg" style="background-color:white;padding:20px;">

```
 *  This work is licensed under CC BY-SA 4.0 
```