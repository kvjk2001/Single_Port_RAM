`include "macros.svh"

class ram_test;
  
  //Virtual interfaces for driver, monitor and reference model
  virtual ram_intf v_intf_d;
  virtual ram_intf v_intf_m;
  virtual ram_intf v_intf_r;
  
  //Declaring handle for environment
  ram_env test_env;
  
  //Explicitly overriding the constructor to connect the virtual
  //interfaces from driver, monitor and reference model to test
  function new(virtual ram_intf v_intf_d,virtual ram_intf v_intf_m,virtual ram_intf v_intf_r);
    this.v_intf_d=v_intf_d;
    this.v_intf_m=v_intf_m;
    this.v_intf_r=v_intf_r;
  endfunction
  
  //Task which builds the object for environment handle and
  //calls the build and start methods of the environment
  task run();
    test_env=new(v_intf_d, v_intf_m, v_intf_r);
    test_env.build;
    test_env.start;
  endtask
endclass


//child class of ram_test for only write operation
class test_write extends ram_test;
  
  ram_tx_write test_write_tx_write;

  function new(virtual ram_intf v_intf_d, virtual ram_intf v_intf_m, virtual ram_intf v_intf_r);
    super.new(v_intf_d, v_intf_m, v_intf_r);
  endfunction

  task run();
    test_env = new(v_intf_d, v_intf_m, v_intf_r);
    test_env.build();
    
    begin
    test_write_tx_write = new();
    test_env.gtr.original_tx = test_write_tx_write;
    end
    
    test_env.start();
  endtask
endclass

//child class of ram_test for only write operation
class test_read extends ram_test;
  
  ram_tx_read test_read_tx_read;

  function new(virtual ram_intf v_intf_d, virtual ram_intf v_intf_m, virtual ram_intf v_intf_r);
    super.new(v_intf_d, v_intf_m, v_intf_r);
  endfunction

  task run();
    test_env = new(v_intf_d, v_intf_m, v_intf_r);
    test_env.build();

    begin
    test_read_tx_read = new();
    test_env.gtr.original_tx = test_read_tx_read;
    end

    test_env.start();
  endtask
endclass

//child class of ram_test for regression of write and read operation sequencially
class test_regression extends ram_test;
  
  ram_tx_read test_read_tx_read;
  ram_tx_write test_write_tx_write;

  function new(virtual ram_intf v_intf_d, virtual ram_intf v_intf_m, virtual ram_intf v_intf_r);
    super.new(v_intf_d, v_intf_m, v_intf_r);
  endfunction

  task run();
    test_env = new(v_intf_d, v_intf_m, v_intf_r);
    test_env.build();
    
    test_write_tx_write = new();
    test_env.gtr.original_tx = test_write_tx_write;
    test_env.start();
    
    test_read_tx_read = new();
    test_env.gtr.original_tx = test_read_tx_read;
    test_env.start();

  endtask
endclass
