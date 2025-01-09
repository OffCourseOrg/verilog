OUTPUT = ./cxxrtl
CXXRTL_INCLUDE=$(OSS-CAD-PATH)/share/yosys/include/backends/cxxrtl/runtime/
CXXFLAGS=CXXRTL_INCLUDE_VCD_CAPI_IMPL=1

$(OUTPUT)/simulate : $(VERILOG_SOURCES)
	-mkdir cxxrtl
	$(YOSYS) -p "write_cxxrtl -header cxxrtl/module.cpp" $^
	g++ -c -D$(CXXFLAGS) -I$(CXXRTL_INCLUDE) cxxrtl/module.cpp -o cxxrtl/module.o
	gcc -c -I$(CXXRTL_INCLUDE) bench.c -o cxxrtl/bench.o
	g++ cxxrtl/module.o cxxrtl/bench.o -o cxxrtl/simulate

run: $(OUTPUT)/simulate
	cxxrtl/simulate

clean:
	-rm -r cxxrtl/