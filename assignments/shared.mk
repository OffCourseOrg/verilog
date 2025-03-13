CURRENT_DIR = $(shell pwd)
TOOLS-DIR=../../tools/
OSS-CAD-PATH=/opt/oss-cad-suite
OSS-CAD-BIN=$(OSS-CAD-PATH)/bin
DIR_NAME=sby_tmp

YOSYS=$(OSS-CAD-BIN)/yosys

FSM2GRAPH=python $(TOOLS-DIR)/fsm2graph

SHELL:=/bin/bash

SOURCE=$(wildcard *.sby)
VERILOG_SOURCES=$(wildcard *.v)
GITHUB_CSS=../github_markdown.css
all: sby_tasks

sby_tasks: $(SOURCE) env
	$(OSS-CAD-BIN)/sby -f $< --prefix tmp

cvr: $(SOURCE) env
	$(OSS-CAD-BIN)/sby -f $< $@ --prefix tmp

prv: $(SOURCE) env
	$(OSS-CAD-BIN)/sby -f $< $@ --prefix tmp

trace: env
	$(OSS-CAD-BIN)/gtkwave tmp_prv/engine_0/*.vcd

trace-cvr: env
	$(OSS-CAD-BIN)/gtkwave tmp_cvr/engine_0/*.vcd

fsm: env clean sby_tasks
	$(YOSYS) -p 'read_verilog -D GEN_FSM REF.v; proc; opt -nodffe -nosdff; autoname; fsm -nomap -norecode; write_table tmp/netlist.txt' | tee tmp/yosys.txt | $(FSM2GRAPH) --info --verilog REF.v --netlist tmp/netlist.txt
	dot -Tsvg tmp/fsm.gv -o fsm.svg
	xdot tmp/fsm.gv

fsm_int: env clean sby_tasks
	$(YOSYS) -p 'read_verilog -D GEN_FSM REF.v; proc; opt -nodffe -nosdff; autoname; fsm -nomap -norecode; write_table tmp/netlist.txt' | tee tmp/yosys.txt | $(FSM2GRAPH) --info --netlist tmp/netlist.txt
	dot -Tsvg tmp/fsm.gv -o fsm.svg
	xdot tmp/fsm.gv

load_for_tools:
	-rm $(TOOLS-DIR)/tmp/*
	cp REF.v $(TOOLS-DIR)/tmp/REF.v
	cp tmp/*.txt $(TOOLS-DIR)/tmp/

diagram: $(VERILOG_SOURCES)
	$(YOSYS) -p "hierarchy -check -top $(TOP_MODULE); proc; future; opt_clean; check; opt -noff -keepdc; wreduce -keepdc; opt_clean; memory_collect; opt -noff -keepdc -fast; stat; check; write_json tmp/netlist.json" $^
	yarn netlistsvg-offcourse $(CURRENT_DIR)/tmp/netlist.json -o $(CURRENT_DIR)/diagram.svg --skin $(CURRENT_DIR)/default.svg
	xdg-open diagram.svg

env:
	source $(OSS-CAD-PATH)/environment

clean:
	-rm -rf tmp*
	-rm fsm.svg
	-rm diagram.svg

pandoc: $(wildcard *.md)
	-rm description.html
	pandoc --embed-resources -c $(GITHUB_CSS) -f gfm+hard_line_breaks -t html -s $^ -o description.html
	xdg-open description.html

.PHONY: all env clean trace trace-cvr cvr prv prep
