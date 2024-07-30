class scoreboard extends uvm_scoreboard;

	//Registering scoreboard with factory
	`uvm_component_utils(scoreboard)

	//declaring tlm port for scoreboard to reference communication
	uvm_nonblocking_put_imp #(sequence_item, scoreboard) sb2ref;

	//declaring analysis port for scoreboard to output monitor communication
	uvm_analysis_imp #(sequence_item, scoreboard) sb2out_mon;
	
	//declaring variables for storing match and mismatch count 
	int match;
	int mismatch;	

	bit [7:0] ref_data_out[$];
	bit [7:0] mon_data_out[$];

	extern function new(string name = "scoreboard", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function bit can_put();
	extern function bit try_put(sequence_item ref_packet);
	extern function void write(sequence_item out_mon_packet);
	extern task run_phase(uvm_phase phase);

endclass

	//defining class constructor
	function scoreboard::new(string name = "scoreboard", uvm_component parent);
		super.new(name, parent);
	endfunction

	//defining build phase
	function void scoreboard::build_phase(uvm_phase phase);
		sb2ref = new("sb2ref", this);
		sb2out_mon = new("sb2out_mon", this);
	endfunction

	//defining default can_put method
	function bit scoreboard::can_put();
	endfunction

	//defining try put method for reference port
	function bit scoreboard::try_put(sequence_item ref_packet);
		ref_data_out.push_back(ref_packet.data_out);
	endfunction

	//defining write metod for output monitor port
	function void scoreboard::write(sequence_item out_mon_packet);
		mon_data_out.push_back(out_mon_packet.data_out);
	endfunction

	//defining run phase
	task scoreboard::run_phase(uvm_phase phase);
		
		forever
		begin
		bit [7:0] ref_data;
		bit [7:0] mon_data;
		
		super.run_phase(phase);

			
		wait(ref_data_out.size() > 0 && mon_data_out.size() > 0);
		
//		if(ref_data_out.size() > 0 && mon_data_out.size() > 0)
//		begin

			ref_data = ref_data_out.pop_front();
			mon_data = mon_data_out.pop_front();

			if(ref_data == mon_data)
			begin
				match++;		
				`uvm_info("REF_in_SB", $sformatf("data_out = %0h", ref_data), UVM_LOW);		
				`uvm_info("MON_in_SB", $sformatf("data_out = %0h", mon_data), UVM_LOW);	
				`uvm_info("MATCH", $sformatf("match count = %0d", match), UVM_LOW);
				`uvm_info("END", $sformatf("--------------------------------------------------------------------"), UVM_LOW);
	
			end
			else
			begin
				mismatch++;
				`uvm_info("REF_in_SB", $sformatf("data_out = %0h", ref_data), UVM_LOW);		
				`uvm_info("MON_in_SB", $sformatf("data_out = %0h", mon_data), UVM_LOW);	
				`uvm_info("MISMATCH", $sformatf("mismatch count = %0d", mismatch), UVM_LOW);	
				`uvm_info("END", $sformatf("---------------------------------------------------------------------"), UVM_LOW);

			end
//		end
/*
		else
			`uvm_info("SB", $sformatf("Both values have not arrived"), UVM_LOW);
*/
		end
	endtask
	
