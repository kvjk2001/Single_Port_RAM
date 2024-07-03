`include "macros.svh"

class ram_mon;
  
  //Ram transaction class handle
  ram_tx mon_tx;
  
  //Mailbox for monitor to scoreboard connection
  mailbox #(ram_tx) mbx_ms;
  
  //Virtual interface with monitor modport and its instance
  virtual ram_intf.mp_mon v_intf_mon;
  
  //FUNCTIONAL COVERAGE for outputs
  covergroup cg_mon;
  DATA_OUT: coverpoint mon_tx.data_out {bins dout ={[0:255]};}
  endgroup

  //Explicitly overriding the constructor to make mailbox connection from monitor
  //to scoreboard, and to connect the virtual interface from monitor to environment
  function new( virtual ram_intf.mp_mon v_intf_mon, mailbox #(ram_tx) mbx_ms);
    this.v_intf_mon=v_intf_mon;
    this.mbx_ms=mbx_ms;
    
    //Creating the object for covergroup
    cg_mon=new();
  endfunction
  
  //Task to collect the output from the interface
  task start();
    repeat(4) @(v_intf_mon.cb_mon);
    for(int i=0;i<`num_transactions;i++)
      begin
        mon_tx=new();
        repeat(1) @(v_intf_mon.cb_mon)
          begin
            mon_tx.data_out=v_intf_mon.cb_mon.data_out;
            mon_tx.addr = v_intf_mon.cb_mon.addr;
          end
        $display("[%0d]: MONITOR PASSING THE DATA TO SCOREBOARD: data_out=%0h", $time, mon_tx.data_out);
        
        //Putting the collected outputs to mailbox
        mbx_ms.put(mon_tx);
        
        //Sampling the covergroup
        cg_mon.sample();
        $display("[%0d]: OUTPUT FUNCTIONAL COVERAGE = %0d", $time, cg_mon.get_coverage());
        repeat(1) @(v_intf_mon.cb_mon);
      end
  endtask
  
endclass
