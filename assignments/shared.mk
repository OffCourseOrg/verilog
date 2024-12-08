CURRENT_DIR = $(shell pwd)
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
	$(OSS-CAD-BIN)/yosys -p 'read_verilog -D GEN_FSM REF.v; proc; opt -nodffe -nosdff; autoname; fsm -nomap -norecode; write_table tmp/netlist.txt' | tee tmp/yosys.txt | $(FSM2GRAPH) --info --verilog REF.v --netlist tmp/netlist.txt
	xdot tmp/fsm.gv

fsm_int: env
	$(OSS-CAD-BIN)/yosys -p 'read_verilog -D GEN_FSM REF.v; proc; opt -nodffe -nosdff; autoname; fsm -nomap -norecode; write_table tmp/netlist.txt' | tee tmp/yosys.txt | $(FSM2GRAPH) --info --netlist tmp/netlist.txt
	xdot tmp/fsm.gv

diagram: env
	$(OSS-CAD-BIN)/yosys -p "prep -top REF; write_json tmp/netlist.json" REF.v
	yarn netlistsvg-offcourse $(CURRENT_DIR)/tmp/netlist.json -o $(CURRENT_DIR)/tmp/diagram.svg
	xdg-open tmp/diagram.svg


env:
	source $(OSS-CAD-PATH)/environment

clean:
	rm -rf tmp*

trace: env
	$(OSS-CAD-BIN)/gtkwave tmp_prv/engine_0/*.vcd

trace-cvr: env
	$(OSS-CAD-BIN)/gtkwave tmp_cvr/engine_0/*.vcd

.PHONY: all env clean trace trace-cvr cvr prv
