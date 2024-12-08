### fsm2graph
  #### Requirements:
  - Python 3.10+
  ```sh
  pip install graphviz
  ```
  #### Usage
  ```sh
  yosys -p "..." | fsm2graph.py REF.v #Read yosys from stdin
  ```
  ```sh
  fsm2graph,py yosys_fsm.txt REF.v #Read yosys from file
  ```

  Converts finite state machines to flowgraphs
  - YoSys to resolve FSM logic
  - parses verilog files for `//@` directives.

  fsm2graph can use params to name states when declared as such
  ```verilog
    //@STATES
	localparam _MIN_STATE=0,
		DISARMED = 0,
		ARM_D_0 = 1,
		ARM_D_1 =2;
  ```


## Tools
 - Modified NetlistSVG