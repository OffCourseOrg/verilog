verilate: 
	-rm -rf ./obj_dir
	verilator --cc --exe --build -j 0 -Wno-PINMISSING sim_main.cpp REF.v UUT.v -o simulate

run: verilate
	obj_dir/simulate