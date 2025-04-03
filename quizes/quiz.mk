SHELL:=/bin/bash
CURRENT_DIR=$(shell pwd)
QUIZ_DIR=$(abspath $(CURRENT_DIR)/../../..)
OSS-CAD-PATH=/opt/oss-cad-suite
OSS-CAD-BIN=$(OSS-CAD-PATH)/bin
YOSYS=$(OSS-CAD-BIN)/yosys


TOP_MODULE=UUT
VERILOG_SOURCES=$(wildcard *.v)
GITHUB_CSS=../../../github_markdown.css

PREVIEW:="true"

all: diagram pandoc

diagram: ref.v
	$(YOSYS) -p "hierarchy -check -top $(TOP_MODULE); proc; future; opt_clean; check; opt -noff -keepdc; wreduce -keepdc; opt_clean; memory_collect; opt -noff -keepdc -fast; stat; check; write_json tmp/netlist.json" $^
	yarn netlistsvg-offcourse $(CURRENT_DIR)/tmp/netlist.json -o $(CURRENT_DIR)/diagram.svg --skin $(QUIZ_DIR)/default.svg
	if [ $(PREVIEW) == "true" ]; then \
		xdg-open $(CURRENT_DIR)/diagram.svg; \
	fi

pandoc: $(wildcard *.md)
	-rm *.html
	pandoc --embed-resources -c $(GITHUB_CSS) -f gfm+hard_line_breaks -t html -s $^ -o description.html

iverilog: $(template.v)
	awk 'NR==FNR { a[n++]=$$0; next }\
	/{{ANSWER}}/ { for (i=0;i<n;++i) print a[i]; next }\
	1' ref.v template.v > tmp/bench.v
	$(OSS-CAD-BIN)/iverilog -o tmp/simulate -tvvp -s bench tmp/bench.v
	$(OSS-CAD-BIN)/vvp tmp/simulate

.PHONY: all