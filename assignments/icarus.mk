OUTPUT = ./icarus
CXXRTL_INCLUDE=$(OSS-CAD-PATH)/share/yosys/include/backends/cxxrtl/runtime/
CXXFLAGS=CXXRTL_INCLUDE_VCD_CAPI_IMPL=1

$(OUTPUT)/simulate: $(VERILOG_SOURCES)
	-mkdir icarus
	$(OSS-CAD-BIN)/iverilog -o icarus/simulate -tvvp -s $(TOP_MODULE) $^

run: $(OUTPUT)/simulate 
	$(OSS-CAD-BIN)/vvp icarus/simulate

trace: run
	$(OSS-CAD-BIN)/gtkwave trace.vcd 

clean:
	-rm -rf ./icarus

.PHONY: run 