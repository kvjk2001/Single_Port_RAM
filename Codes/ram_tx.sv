//------------------------------------------------------------------------------
// Project      : Single_Port_RAM
// File Name    : ram_tx.sv
// Developers   : K Vijay Kumar (vijaykrishnan@mirafra.com)
// Created Date : 05/07/2024
// Version      : V1.0
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------


`include "macros.svh"

class ram_tx;
  
  //INPUTS declared as rand variables
  rand logic [`DATA_WIDTH-1:0] data_in;
  rand logic write_en;
  rand logic read_en;
  rand logic [`ADDR_WIDTH-1:0] addr;
  
  //OUTPUTS declare as non-rand variables
  logic [`DATA_WIDTH-1:0] data_out;
  
  //CONSTRAINTS for write_en and read_en
  constraint c1 {{write_en,read_en} inside {[0:3]};}
  constraint c2 {{write_en,read_en}!=2'b11;}
  
  //Copying objects
  virtual function ram_tx copy();
    copy = new();
    copy.data_in=this.data_in;
    copy.write_en=this.write_en;
    copy.read_en=this.read_en;
    copy.addr=this.addr;
    return copy;
  endfunction
endclass


//child class of ram_tx to test only for write operation 
class ram_tx_write extends ram_tx;

  //overwriting c1 constraint from parent class
  constraint c_1 {{write_en, read_en} == 2'b10;}
  
  //copying objects
  virtual function ram_tx copy();
    ram_tx_write copy1;
    copy1 = new();
    copy1.data_in = this.data_in;
    copy1.write_en = this.write_en;
    copy1.read_en = this.read_en;
    copy1.addr = this.addr;
    return copy1;
  endfunction
endclass


//child class of ram_tx to test only read operation
class ram_tx_read extends ram_tx;

  //overwriting c1 constraint from parent class
  constraint c_1 {{write_en, read_en} == 2'b01;}
  
  //copying objects
  virtual function ram_tx copy();
    ram_tx_read copy2;
    copy2 = new();
    copy2.data_in = this.data_in;
    copy2.write_en = this.write_en;
    copy2.read_en = this.read_en;
    copy2.addr = this.addr;
    return copy2;
  endfunction
endclass
