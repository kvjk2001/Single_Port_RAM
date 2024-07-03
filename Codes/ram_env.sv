`include "macros.svh"

class ram_env;

  //Virtual interfaces for driver, monitor and reference model
  virtual ram_intf v_intf_d;
  virtual ram_intf v_intf_m;
  virtual ram_intf v_intf_r;
  
  //Mailbox for generator to driver connection
  mailbox #(ram_tx) mbx_gd;
  
  //Mailbox for driver to reference model connection
  mailbox #(ram_tx) mbx_dr;
  
  //Mailbox for reference model to scoreboard connection
  mailbox #(ram_tx) mbx_rs;
  
  //Mailbox for monitor to scoreboard connection
  mailbox #(ram_tx) mbx_ms;
  
  //Declaring handles for components
  //generator, driver, monitor, reference model and scoreboard
  ram_gtr gtr;
  ram_drv drv;
  ram_mon mon;
  ram_refer refer;
  ram_sb sb;
  
  //Explicitly overriding the constructor to connect the virtual interfaces
  //from driver, monitor and reference model to test
  function new (virtual ram_intf v_intf_d,virtual ram_intf v_intf_m,virtual ram_intf v_intf_r);
    this.v_intf_d=v_intf_d;
    this.v_intf_m=v_intf_m;
    this.v_intf_r=v_intf_r;
  endfunction
  
  //Task which creates objects for all the mailboxes and components
  task build();
    begin
      //Creating objects for mailboxes
      mbx_gd=new();
      mbx_dr=new();
      mbx_rs=new();
      mbx_ms=new();
      
      //Creating objects for components and passing the arguments in the function new() i.e the constructor
      gtr=new(mbx_gd);
      drv=new(mbx_gd,mbx_dr,v_intf_d);
      mon=new(v_intf_m,mbx_ms);
      refer=new(mbx_dr,mbx_rs,v_intf_r);
      sb=new(mbx_rs,mbx_ms);
    end
  endtask
  
  //Task which calls the start methods of each component and also calls the compare and report method
  task start();
    fork
      gtr.start();
      drv.start();
      mon.start();
      sb.start();
      refer.start();
    join
    
    sb.compare_report();
  endtask
  
endclass
