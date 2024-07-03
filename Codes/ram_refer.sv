`include "macros.svh"

class ram_refer;

  //Ram transaction class handle
  ram_tx refer_tx;
  
  //Mailbox for reference model to scoreboard connection
  mailbox #(ram_tx) mbx_rs;
  
  //Mailbox for driver to reference model connection
  mailbox #(ram_tx) mbx_dr;
  
  //Virtual interface with reference model modport and its instance
  virtual ram_intf.mp_refer v_intf_refer;
  
  //2-D array used for RAM storage
  reg [`DATA_WIDTH-1:0] MEM [`DATA_DEPTH-1:0];
  
  //Explicitly overriding the constructor to make a mailbox connection from driver
  //to reference model, a mailbox connection from reference model to scoreboard
  //and to connect the virtual interface from reference model to enviornment
  function new(mailbox #(ram_tx) mbx_dr, mailbox #(ram_tx) mbx_rs, virtual ram_intf.mp_refer v_intf_refer);
    this.mbx_dr=mbx_dr;
    this.mbx_rs=mbx_rs;
    this.v_intf_refer=v_intf_refer;
  endfunction
  
  //Task which mimics the functionality of the RAM
  task start();
    for(int i=0;i<`num_transactions;i++)
      begin
        refer_tx=new();
        
        //getting the driver transaction from mailbox
        mbx_dr.get(refer_tx);
        repeat(1) @(v_intf_refer.cb_refer)
          begin
            if(refer_tx.write_en)
              begin
                MEM[refer_tx.addr]=refer_tx.data_in;
	            $display("[%0d]: REFERENCE write: addr= %0d, data_in in mem= %0d",$time, refer_tx.addr,MEM[refer_tx.addr]);
              end
            else if(refer_tx.read_en)
              begin
                refer_tx.data_out=MEM[refer_tx.addr];
                $display("[%0d]: REFERENCE read: addr=%0d, data_out from mem= %0d",$time, refer_tx.addr, refer_tx.data_out);
              end
          end
        //Putting the reference model transaction to mailbox
        mbx_rs.put(refer_tx);
      end
  endtask
  
endclass
