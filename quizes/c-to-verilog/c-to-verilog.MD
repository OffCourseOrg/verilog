### Moving from C to Verilog

#### C
Programming, as you will have done it up until now, in languages such as C has been fairly straight forward. You write lines of code that the computer then executes in the order you have written. Besides some processing to turn the human text into machine readable instructions (assembly/machine code) the essence of the program you write is maintained.
The order of execution for variables, if-statements, functions calls, etc is the same to you as it is to the computer.
_**C code becomes instructions the computer can execute.**_

#### Verilog

Verilog is not like other programming languages. It is not used to create instructions a computer could run. Verilog instead exists to describe the design of digital circuits. Making verilog a *Hardware description Language*.
_**Verilog describes digital circuits, not programs**_


#### Basic Digital Circuits
  You should be familair with analogue circuits. Circuits constructed from resistors, capacitors, etc. In these circuits values are real numbers -> voltages of 10V, 9.38V, -12.3V. **This makes analogue circuits continously variable.** //CHECK WITH THEM

  In contrast there only exist 2 possible values in digital circuits:
  |||||
  -|-|-|-|
  | `1` | **True** | `on` | `A High voltage`
  | `0` | **False**  | `off` | `A low voltage`

  These values, 0 and 1, which we refer to as **bits** make digital circuits subject to a special kind of math, Boolean Algebra!
  
  In normal algebra, where we have numbers instead of bits, `1+1 = 2`. Sadly, Boolean Algebra has no concept of `2`. Therefor `1+1=0` in our new algebra! This looks awful however, so instead we shall define new operations that are specific to working with bits.
  |Name|Effect|
  -|-
  |`NOT`| Inverter|
  |`OR`| Any|
  |`AND`|both|
  |`XOR`|one or the other|


 - Logic Gates
 - Multiplexers
 - Wires





