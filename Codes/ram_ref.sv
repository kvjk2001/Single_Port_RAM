//------------------------------------------------------------------------------
// Project      : Single_Port_RAM
// File Name    : ram_ref.sv
// Developers   : K Vijay Kumar (vijaykrishnan@mirafra.com)
// Created Date : 05/07/2024
// Version      : V1.0
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------


`include "macros.svh"

class ram_ref;

  //Ram transaction class handle
  ram_tx ref_tx;
  
  //Mailbox for reference model to scoreboard connection
  mailbox #(ram_tx) mbx_rs;
  
  //Mailbox for driver to reference model connection
  mailbox #(ram_tx) mbx_rd;
  
  //Virtual interface with reference model modport and its instance
  virtual ram_intf.mp_ref v_intf_ref;
  
  //2-D array used for RAM storage
  reg [`DATA_WIDTH-1:0] MEM [`DATA_DEPTH-1:0];
  
  //Explicitly overriding the constructor to make a mailbox connection from driver
  //to reference model, a mailbox connection from reference model to scoreboard
  //and to connect the virtual interface from reference model to enviornment
  function new(mailbox #(ram_tx) mbx_rd, mailbox #(ram_tx) mbx_rs, virtual ram_intf.mp_ref v_intf_ref);
    this.mbx_rd=mbx_rd;
    this.mbx_rs=mbx_rs;
    this.v_intf_ref=v_intf_ref;
  endfunction
  
  //Task which mimics the functionality of the RAM
  task start();
    for(int i=0;i<`num_transactions;i++)
      begin
        ref_tx=new();
        
        //getting the driver transaction from mailbox
        mbx_rd.get(ref_tx);
        repeat(1) @(v_intf_ref.cb_ref)
          begin
            if(ref_tx.write_en)
              begin
                MEM[ref_tx.addr]=ref_tx.data_in;
	            $display("[%0d]: REFERENCE write: addr= %0d, data_in in mem= %0d",$time, ref_tx.addr,MEM[ref_tx.addr]);
              end
            else if(ref_tx.read_en)
              begin
                ref_tx.data_out=MEM[ref_tx.addr];
                $display("[%0d]: REFERENCE read: addr=%0d, data_out from mem= %0d",$time, ref_tx.addr, ref_tx.data_out);
              end
          end
        //Putting the reference model transaction to mailbox
        mbx_rs.put(ref_tx);
      end
  endtask
  
endclass
