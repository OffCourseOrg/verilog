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

TOP_MODULE=REF

all: sby_tasks

diagram: $(VERILOG_SOURCES)
	$(YOSYS) -p "hierarchy -check -top $(TOP_MODULE); proc; future; opt_clean; check; opt -noff -keepdc; wreduce -keepdc; opt_clean; memory_collect; opt -noff -keepdc -fast; stat; check; write_json tmp/netlist.json" $^
	yarn netlistsvg-offcourse $(CURRENT_DIR)/tmp/netlist.json -o $(CURRENT_DIR)/diagram.svg --skin $(CURRENT_DIR)/default.svg
	xdg-open diagram.svg

env:
	source $(OSS-CAD-PATH)/environment

.PHONY: all env clean trace trace-cvr cvr prv prep
