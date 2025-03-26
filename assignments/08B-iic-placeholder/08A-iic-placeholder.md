```
 *  Copyright: Sybe Feitsma
 *  This work is licensed under CC BY-SA 4.0 
```
#### Part of Series:
  | 08-iic |
  ---------------------
  | => **08A-iic-decoder** |

## Assignment 08A "IIC decoder"

  ```wavedrom
  { signal: [
    {              node: " \u01A2\u01B2\u01A4   \u01B3\u01A6\u01B5  \u01A7   \u01B7  \u01A9\u01B8",
    phase:0.15 },
    { name: "SCL", wave: "1.010|10101010|1010<1.>", phase:0.15 },
    { name: "SDA", wave: "1L1.|0.....1.|0....<H>", phase:-0.4 },
    {              node: ' ABCD GHIJKLMN OPQRST', phase:0.15 }
  ],
    edge: [
      'A+B start', 'C+D BIT1', 'G+H BIT7', 'I+J write',
      'M+N BIT1', 'O+P BIT8',
      'K+L ACK', 'Q+R ACK', 'S+T stop',
      '\u01A2+\u01B2 SGN', '\u01A4+\u01B3 <b>Address</b>', '\u01A6+\u01B5 R/W',
      '\u01A7+\u01B7 <b>Data</b>', '\u01A9+\u01B8 SGN'
  ],
  }
  ```

  [Thanks to Texas Instrument's detailed Application Report](https://www.ti.com/lit/an/slva704/slva704.pdf)
  
#### Your UUT will be checked against a Golden reference. 
  Every clockcyle:

  - UUT State must match REF state  
  - UUT Outputs must match REF Outputs
  - If your UUT and the REF diverge the simulation will halt immediatly

  use GTKWave (The software hiding behind the Debug/Spider button) to debug any issues.\
  *This task uses a golden reference. Therefore the trace in GTKwave will always end at the divergence/error point*

# Task
  Use the provided state graph to implement a basic Two Wire slave.

  | |
  |-|
  | The skeleton UUT (Unit Under Test) file is given with relevant input and outputs. |

  Good luck!


<img src="fsm.svg" style="background-color:white;margin:20px;max-width:100%;">>

```
 *  This work is licensed under CC BY-SA 4.0 
```