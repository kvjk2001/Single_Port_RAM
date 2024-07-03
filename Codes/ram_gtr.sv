`include "macros.svh"

class ram_gtr;
  
  //Ram transaction class handle
  ram_tx original_tx;
  
  //Mailbox for generator to driver connection
  mailbox #(ram_tx)mbx_gd;
  
  //Explicitly overriding the constructor to make mailbox connection from generator to driver
  function new(mailbox #(ram_tx)mbx_gd);
    this.mbx_gd=mbx_gd;
    original_tx=new();
  endfunction
  
  //Task to generate the random stimuli
  task start();
    for(int i=0;i<`num_transactions;i++)
      begin
        //Randomizing the inputs
        assert(original_tx.randomize() == 1); 
        
        //Putting the randomized inputs to mailbox
        mbx_gd.put(original_tx.copy());
        
        $display("[%0d]: GENERATOR Randomized transaction data_in=%0h, write_enb=%0d, read_enb=%0d, address=%0h", $time, original_tx.data_in, original_tx.write_en, original_tx.read_en, original_tx.addr);
      end
  endtask
  
endclass
