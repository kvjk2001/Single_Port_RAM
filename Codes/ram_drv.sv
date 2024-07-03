`include "macros.svh"

class ram_drv;
  
  //Ram transaction class handle
  ram_tx drv_tx;
  
  //Mailbox for driver to generator connection
  mailbox #(ram_tx)mbx_dg;
  
  //Mailbox for driver to reference model connection
  mailbox #(ram_tx)mbx_dr;
  
  //Virtual interface with driver modport and its instance
  virtual ram_intf.mp_drv v_intf_drv;
  
  //FUNCTIONAL COVERAGE for input
  covergroup cg_drv;
    WRITE: coverpoint drv_tx.write_en { bins wrt[ ]={0,1};}
    READ : coverpoint drv_tx.read_en { bins rd[ ]={0,1};}
    DATA_IN: coverpoint drv_tx.data_in { bins data ={[0:255]};}
    ADDRESS: coverpoint drv_tx.addr { bins addr={[0:31]};}
    WRXRD: cross WRITE,READ;
  endgroup

  //Explicitly overriding the constructor to make mailbox connection from driver to generator, 
  //to make mailbox connection from driver to reference model and
  //to connect the virtual interface from driver to environment
  function new(mailbox #(ram_tx)mbx_dg, mailbox #(ram_tx)mbx_dr, virtual ram_intf.mp_drv v_intf_drv);
    this.mbx_dg=mbx_dg;
    this.mbx_dr=mbx_dr;
    this.v_intf_drv=v_intf_drv;
    
    //Creating the object for covergroup
    cg_drv=new();
  endfunction
  
  //Task to drive the stimuli
  task start();
   repeat(3) @(v_intf_drv.cb_drv);
    for(int i=0;i<`num_transactions;i++)
      begin
        
        //creating object for Ram transaction class handle
        drv_tx=new();
        
        //Getting the transaction from generator
        mbx_dg.get(drv_tx);
        
        if(v_intf_drv.cb_drv.rst==0)
          repeat(1) @(v_intf_drv.cb_drv)
            begin
              v_intf_drv.cb_drv.write_en<=0;
              v_intf_drv.cb_drv.read_en<=0;
              v_intf_drv.cb_drv.data_in<=8'bz;
              v_intf_drv.cb_drv.addr<=0;
              
              //putting the input values for reset to mailbox
              mbx_dr.put(drv_tx);
              
              repeat(1) @(v_intf_drv.cb_drv);
              $display();
              $display("//////////////////////////////////////// Transaction starts//////////////////////////////////");
              $display("[%0d]: DRIVER DRIVING DATA TO THE INTERFACE: rst=0: data_in=%0h, write_enb=%0d, read_enb=%0d, address=%0h", $time,  v_intf_drv.cb_drv.data_in, v_intf_drv.cb_drv.write_en, v_intf_drv.cb_drv.read_en,v_intf_drv.cb_drv.addr);
            end
        else
          repeat(1) @(v_intf_drv.cb_drv)
            begin
              v_intf_drv.cb_drv.write_en<=drv_tx.write_en;
              v_intf_drv.cb_drv.read_en<=drv_tx.read_en;
              v_intf_drv.cb_drv.data_in<=drv_tx.data_in;
              v_intf_drv.cb_drv.addr<=drv_tx.addr;
              
              repeat(1) @(v_intf_drv.cb_drv);
              $display();
              $display("//////////////////////////////////////// Transaction starts//////////////////////////////////");
              $display("[%0d]: DRIVER DRIVING DATA TO THE INTERFACE: rst=1: data_in=%0h, write_enb=%0d, read_enb=%0d,address=%0h", $time,  v_intf_drv.cb_drv.data_in, v_intf_drv.cb_drv.write_en, v_intf_drv.cb_drv.read_en,v_intf_drv.cb_drv.addr);
              
              v_intf_drv.cb_drv.write_en<=0;
              
              //Putting the randomized inputs to mailbox
              mbx_dr.put(drv_tx);
              
              //Sampling the covergroup
              cg_drv.sample();
              $display("[%0d]: INPUT FUNCTIONAL COVERAGE = %0d", $time, cg_drv.get_coverage());
            end
      end
  endtask
endclass
