//------------------------------------------------------------------------------
// Project      : Single_Port_RAM
// File Name    : ram_env.sv
// Developers   : K Vijay Kumar (vijaykrishnan@mirafra.com)
// Created Date : 05/07/2024
// Version      : V1.0
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------



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
  ram_gtr env_gtr;
  ram_drv env_drv;
  ram_mon env_mon;
  ram_ref env_ref;
  ram_sb env_sb;
  
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
      env_gtr=new(mbx_gd);
      env_drv=new(mbx_gd,mbx_dr,v_intf_d);
      env_mon=new(v_intf_m,mbx_ms);
      env_ref=new(mbx_dr,mbx_rs,v_intf_r);
      env_sb=new(mbx_rs,mbx_ms);
    end
  endtask
  
  //Task which calls the start methods of each component and also calls the compare and report method
  task start();
    fork
      env_gtr.start();
      env_drv.start();
      env_mon.start();
      env_sb.start();
      env_ref.start();
    join
    
    env_sb.compare_report();
  endtask
  
endclass
