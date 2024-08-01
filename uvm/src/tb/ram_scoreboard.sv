class ram_scoreboard extends uvm_scoreboard;

	//Registering scoreboard with factory
	`uvm_component_utils(ram_scoreboard)

	//declaring tlm port for scoreboard to reference communication
	uvm_nonblocking_put_imp #(ram_sequence_item, ram_scoreboard) sb2ref;

	//declaring analysis port for scoreboard to output monitor communication
	uvm_analysis_imp #(ram_sequence_item, ram_scoreboard) sb2out_mon;
	
	//declaring variables for storing match and mismatch count 
	int match;
	int mismatch;	

	bit [7:0] ref_data_out[$];
	bit [7:0] mon_data_out[$];

	extern function new(string name = "scoreboard", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function bit can_put();
	extern function bit try_put(ram_sequence_item ref_packet);
	extern function void write(ram_sequence_item out_mon_packet);
	extern task run_phase(uvm_phase phase);

endclass

	//defining class constructor
	function ram_scoreboard::new(string name = "scoreboard", uvm_component parent);
		super.new(name, parent);
	endfunction

	//defining build phase
	function void ram_scoreboard::build_phase(uvm_phase phase);
		sb2ref = new("sb2ref", this);
		sb2out_mon = new("sb2out_mon", this);
	endfunction

	//defining default can_put method
	function bit ram_scoreboard::can_put();
	endfunction

	//defining try put method for reference port
	function bit ram_scoreboard::try_put(ram_sequence_item ref_packet);
		ref_data_out.push_back(ref_packet.data_out);
	endfunction

	//defining write metod for output monitor port
	function void ram_scoreboard::write(ram_sequence_item out_mon_packet);
		mon_data_out.push_back(out_mon_packet.data_out);
	endfunction

	//defining run phase
	task ram_scoreboard::run_phase(uvm_phase phase);	
		forever
		begin
			bit [7:0] ref_data;
			bit [7:0] mon_data;
		
			super.run_phase(phase);

			
			wait(ref_data_out.size() > 0 && mon_data_out.size() > 0);
				ref_data = ref_data_out.pop_front();
				mon_data = mon_data_out.pop_front();

				if(ref_data == mon_data)
				begin
					match++;		
					`uvm_info("Check_start", $sformatf("-----------------------------Start Check-----------------------"), UVM_LOW);		
					`uvm_info("REF_in_SB", $sformatf("data_out = %0h", ref_data), UVM_LOW);		
					`uvm_info("MON_in_SB", $sformatf("data_out = %0h", mon_data), UVM_LOW);	
					`uvm_info("MATCH", $sformatf("match count = %0d", match), UVM_LOW);	
					`uvm_info("Check_stop", $sformatf("-----------------------------Stop Check-----------------------"), UVM_LOW);		
				end
				else
				begin
					mismatch++;	
					`uvm_info("Check_start", $sformatf("-----------------------------Start Check-----------------------"), UVM_LOW);		
					`uvm_info("REF_in_SB", $sformatf("data_out = %0h", ref_data), UVM_LOW);		
					`uvm_info("MON_in_SB", $sformatf("data_out = %0h", mon_data), UVM_LOW);	
					`uvm_info("MISMATCH", $sformatf("mismatch count = %0d", mismatch), UVM_LOW);	
					`uvm_info("Check_stop", $sformatf("-----------------------------Stop Check-----------------------"), UVM_LOW);		

				end
		end
		endtask
	
