OSS-CAD-PATH=/opt/oss-cad-suite
OSS-CAD-BIN=$(OSS-CAD-PATH)/bin
DIR_NAME=sby_tmp

SHELL:=/bin/bash

SOURCE=$(wildcard *.sby)

all: $(DIR_NAME)

$(DIR_NAME): $(SOURCE) env
	$(OSS-CAD-BIN)/sby $< -f -d $@

env:
	source $(OSS-CAD-PATH)/environment

clean:
	rm -rf $(DIR_NAME)

trace: env
	$(OSS-CAD-BIN)/gtkwave $(DIR_NAME)/engine_0/*.vcd



.PHONY: all and
