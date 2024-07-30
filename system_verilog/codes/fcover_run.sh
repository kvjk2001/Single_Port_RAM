vlib work
vlog -sv +acc +cover +fcover -l $2.log $1.sv
vsim -vopt work.top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; add wave -position insertpoint sim:/top/duv/*; run -all; coverage report -detail; exit"
vcover report -html coverage.ucdb -htmldir covReport -details
cd covReport/
firefox index.html
