compile:
	vlib work;
	vlog -l compile.log $(top_file)

run:
	vsim -c -novopt -suppress 12110 work.$(top_module) $(arg) -l run.log -do "run -all; exit;"

cov_compile:
	vlib work;
	vlog -sv +acc +cover +fcover -l $(top_file).log $(top_file).sv;

cov_run:
	vsim -vopt work.$(top_module) $(arg) -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; coverage report -detail;  run -all; exit";
	vcover report -html coverage.ucdb -htmldir covReport -details;

clean:
	rm -rf transcript *.vcd *.wlf work/ *.log *.ucdb *.vstf covReport
	
