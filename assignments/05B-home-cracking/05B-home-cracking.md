```
 *  Copyright: Sybe Feitsma
 *  This work is licensed under CC BY-NC-SA 4.0 
```
# TODO
### Assignment 05B "Home Cracking"

  *Completing the previous assignment `05A` is recommended.*

  05B requires you to construct a tool to crack the security system of `05A`. As you might have noticed, the home security fsm you implemented previously contains a critical security flaw. It does not raise the alarm when incorrect pincodes are repeatedly entered. Exposing the security system to a *bruteforce* attack.

  If you are comfortable with verilog, try this assignment without looking at the solution diagram. On an exam the diagram will always be provided.
  
#### Your UUT will be checked against the `05A "Home Security"` FSM the TARGET


  - The TARGET will start in its `ARMED` state.
  - Your task is to get the TARGET to its `DISARMED` state.
  - The pincode for the TARGET is randomised on every run...

  The skeleton UUT (Unit Under Test) file has been filled in with the relevant input and outputs.
  use GTKWave (The software hiding behind the Debug/Spider button) to debug any issues.

  *This task does not use a golden reference. Therefore the trace in GTKwave will not end at a divergence/error point. It instead ends ater XXX clockcycles*

[Solution Diagram is hiding here!](https://github.com/OffCourseOrg/verilog/tree/master/assignments/05B-home-cracking/diagram.svg)

```
 *  This work is licensed under CC BY-NC-SA 4.0 
```