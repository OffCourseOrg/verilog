TOOLS-DIR=../../tools/
OSS-CAD-PATH=/opt/oss-cad-suite
OSS-CAD-BIN=$(OSS-CAD-PATH)/bin
DIR_NAME=sby_tmp

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
	$(OSS-CAD-BIN)/yosys -p 'read_verilog REF.v; proc; opt -nodffe -nosdff; fsm -nomap -norecode;'

fsm_py: env
	$(OSS-CAD-BIN)/yosys -p 'read_verilog REF.v; proc; opt -nodffe -nosdff; fsm -nomap -norecode;' | $(TOOLS-DIR)/fsm_goblin.py REF.v
	xdot tmp/fsm.gv

fsm_open: fsm
	python $(TOOLS-DIR)/kiss2dot.py tmp/output.kiss2 > tmp/output.dot
	xdot tmp/output.dot

env:
	source $(OSS-CAD-PATH)/environment

clean:
	rm -rf tmp*

trace: env
	$(OSS-CAD-BIN)/gtkwave tmp_prv/engine_0/*.vcd

trace-cvr: env
	$(OSS-CAD-BIN)/gtkwave tmp_cvr/engine_0/*.vcd

.PHONY: all env clean trace trace-cvr cvr prv
