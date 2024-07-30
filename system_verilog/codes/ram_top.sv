//------------------------------------------------------------------------------
// Project      : Single_Port_RAM
// File Name    : ram_top.sv
// Developers   : K Vijay Kumar (vijaykrishnan@mirafra.com)
// Created Date : 05/07/2024
// Version      : V1.0
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

`include "macros.svh"

`include "ram_design.v"
`include "ram_intf.sv"
`include "ram_pkg.sv"

module top();

  import ram_pkg::*;
 
  //Declaring variables for clock and reset
  logic clk;
  logic rst;
  
  //Generating the clock
  initial
    begin
      clk <= 0;
      forever #20 clk=~clk; 
    end
  
  //Asserting and de-asserting the rst
  initial
    begin
      @(posedge clk);
      rst=0;
      repeat(1)@(posedge clk);
      rst=1;
    end
  
  //Instantiating the interface
  ram_intf intf_inst(clk, rst);
  
  //Instantiating the DUV
  ram_design duv(
    .data_in(intf_inst.data_in),
    .write_enb(intf_inst.write_en),
    .read_enb(intf_inst.read_en),
    .data_out(intf_inst.data_out),
    .address(intf_inst.addr),
    .clk(clk),
    .reset(rst));
  
  
  //Instantiating the Test
  ram_test top_test;            //test for random values
  test_write top_test_write;    //test for write operation
  test_read top_test_read;      //test for read operation
  
  test_regression top_test_regression;  //regression test for write and read operations sequencially
 
  //Calling the test's run task which starts the execution of the testbench architectur
  initial
    begin
			if($test$plusargs ("base"))
			begin
      	top_test = new(intf_inst.mp_drv,intf_inst.mp_mon,intf_inst.mp_ref);
				top_test.run();
			end

			if($test$plusargs ("write"))
			begin
      	top_test_write = new(intf_inst.mp_drv,intf_inst.mp_mon,intf_inst.mp_ref);
      	top_test_write.run();
			end

			if($test$plusargs ("read"))	
			begin
				top_test_read = new(intf_inst.mp_drv,intf_inst.mp_mon,intf_inst.mp_ref);
  			top_test_read.run();
			end    

			if($test$plusargs ("regression"))
			begin
      	top_test_regression = new(intf_inst.mp_drv,intf_inst.mp_mon,intf_inst.mp_ref);
      	top_test_regression.run();
			end
        
      $finish();
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars();
    end
  
endmodule
