compile:
	vlib work;
	vlog -l compile.log ../src/tb/$(top_file)

run:
	vsim -c -novopt -suppress 12110 work.$(top_module) $(arg) -l run.log -do "/*; add wave -r /*; run -all; exit;" -wlf waveform.wlf

view:
	vsim -view waveform.wlf

compile_with_cov:
	vlib work;
	vlog -sv +acc +cover +fcover -l compile.log $(top_file);

run_with_cov:
	vsim -vopt work.$(top_module) $(arg) -voptargs=+acc=npr -assertdebug -l run.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; coverage report -detail; /*; add wave -r /*; run -all; exit"; -wlf waveform.wlf
	vcover report -html coverage.ucdb -htmldir covReport -details;

clean:
	rm -rf transcript *.vcd *.wlf work/ *.log *.ucdb *.vstf covReport
	
