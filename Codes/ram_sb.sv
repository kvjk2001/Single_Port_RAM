`include "macros.svh"

class ram_sb;

  //Ram transaction class handles
  ram_tx refer2sb_tx,mon2sb_tx;
  
  //Mailbox for from reference model to scoreboard connection
  mailbox #(ram_tx) mbx_rs;
  
  //Mailbox for from monitor to scoreboard connection
  mailbox #(ram_tx) mbx_ms;
  
  //2-D arrays used for storing data_out w.r.t address in reference model memory and 
  //storing data_out w.r.t address in monitor memory
  logic [`DATA_WIDTH-1:0] refer_mem [`DATA_DEPTH-1:0];
  logic [`DATA_WIDTH-1:0] mon_mem [`DATA_DEPTH-1:0];
  
  //Variables to indicate number of matches and mismatches
  int MATCH = 0;
  int MISMATCH = 0;

  //Explicitly overriding the constructor to make mailbox connection from monitor
  //to scoreboard, to make mailbox connection from reference model to scoreboard
  function new(mailbox #(ram_tx) mbx_rs, mailbox #(ram_tx) mbx_ms);
    this.mbx_rs=mbx_rs;
    this.mbx_ms=mbx_ms;
  endfunction
  
  //Task which collects data_out from reference model and monitor
  //and stores them in their respective memories
  task start();
    for(int i=0;i<`num_transactions;i++)
      begin
        refer2sb_tx=new();
        mon2sb_tx=new();
        fork
          begin
            
            //getting the reference model transaction from mailbox
            mbx_rs.get(refer2sb_tx);
            refer_mem[refer2sb_tx.addr]=refer2sb_tx.data_out;
            $display("[%0d]: !!!!!!!!!!!!!SCOREBOARD REF data_out=%0h, ADDRESS=%0h !!!!!!!!!!!!!!",$time, refer_mem[refer2sb_tx.addr], refer2sb_tx.addr);
           
          end
          begin
            
            //getting the monitor transaction from mailbox
            mbx_ms.get(mon2sb_tx);
            mon_mem[mon2sb_tx.addr]=mon2sb_tx.data_out;
            $display("[%0d]: !!!!!!!!!!!!!SCOREBOARD MON data_out=%0h, ADDRESS=%0h !!!!!!!!!!!!!!", $time, mon_mem[mon2sb_tx.addr], mon2sb_tx.addr);
          end
        join
        if (i != (`num_transactions-1))
          compare_report();
      end
  endtask
  
  //Task which compares the memories and generates the report
  task compare_report();
    if(refer_mem[refer2sb_tx.addr] === mon_mem[mon2sb_tx.addr])
      begin
        $display("***************Result***************");
        $display("[%0d]: SCOREBOARD REF: data_out=%0h addr=%0d, MON: data_out=%0h addr=%0d",$time, refer_mem[refer2sb_tx.addr],refer2sb_tx.addr, mon_mem[mon2sb_tx.addr],mon2sb_tx.addr);
        ++MATCH;
        $display("[%0d]: DATA MATCH SUCCESSFUL. MATCH count = %0d",$time, MATCH);
        $display("***************Result***************");
        $display("//////////////////////////////////////// Transaction ends//////////////////////////////////");
        
      end
    
    else
      begin
        $display("***************Result***************");
        $display("[%0d]: SCOREBOARD REF: data_out=%0h addr=%0d, MON: data_out=%0h addr=%0d",$time, refer_mem[refer2sb_tx.addr],refer2sb_tx.addr, mon_mem[mon2sb_tx.addr],mon2sb_tx.addr);        
        ++MISMATCH;
        $display("[%0d]: DATA MATCH FAILURE. MISMATCH count = %0d",$time, MISMATCH);
        $display("***************Result***************");
        $display("//////////////////////////////////////// Transaction ends//////////////////////////////////");
        
      end
  endtask
  
endclass
