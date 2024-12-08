TOOLS-DIR=../../tools/
OSS-CAD-PATH=/opt/oss-cad-suite
OSS-CAD-BIN=$(OSS-CAD-PATH)/bin
DIR_NAME=sby_tmp

FSM2GRAPH=python $(TOOLS-DIR)/fsm2graph

SHELL:=/bin/bash

SOURCE=$(wildcard *.sby)

all: sby_tasks

sby_tasks: $(SOURCE) env
	$(OSS-CAD-BIN)/sby -f $< --prefix tmp

cvr: $(SOURCE) env
	$(OSS-CAD-BIN)/sby -f $< $@ --prefix tmp

prv: $(SOURCE) env
	$(OSS-CAD-BIN)/sby -f $< $@ --prefix tmp

fsm: env
	$(OSS-CAD-BIN)/yosys -p 'read_verilog REF.v; proc; opt -nodffe -nosdff; autoname; fsm -nomap -norecode; write_table tmp/netlist.txt' | $(FSM2GRAPH) --info --verilog REF.v --netlist tmp/netlist.txt
	xdot tmp/fsm.gv

fsm_int: env
	$(OSS-CAD-BIN)/yosys -p 'read_verilog REF.v; proc; opt -nodffe -nosdff; autoname; fsm -nomap -norecode; write_table tmp/netlist.txt' | $(FSM2GRAPH) --info --netlist tmp/netlist.txt
	xdot tmp/fsm.gv

env:
	source $(OSS-CAD-PATH)/environment

clean:
	rm -rf tmp*

trace: env
	$(OSS-CAD-BIN)/gtkwave tmp_prv/engine_0/*.vcd

trace-cvr: env
	$(OSS-CAD-BIN)/gtkwave tmp_cvr/engine_0/*.vcd

.PHONY: all env clean trace trace-cvr cvr prv
