interface ram_intf(input bit clk,rst);
  
  //Declaring signals with width
  logic [7:0] data_in;
  logic [7:0] data_out;
  logic write_en;
  logic read_en;
  logic[4:0] addr;
  
  //Clocking block for driver
  clocking cb_drv@(posedge clk);
    //Specifying the values for input and output skews
    default input #0 output #0;
    
    //Declaring signals without widths, but specifying the direction
    inout write_en;
    inout read_en;
    inout data_in;
    inout addr;
    input rst;
  endclocking
  
  //Clocking block for monitor
  clocking cb_mon@(posedge clk);
    default input #0 output #0;
    input data_out;
    input addr; 
  endclocking
  
  //clocking block for reference model
  clocking cb_refer@(posedge clk);
    default input #0 output #0;
  endclocking
  
  //modports for driver, monitor and reference model
  modport mp_drv(clocking cb_drv);
    modport mp_mon(clocking cb_mon);
      modport mp_refer(clocking cb_refer);
    
endinterface
