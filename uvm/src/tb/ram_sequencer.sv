class ram_sequencer extends uvm_sequencer #(ram_sequence_item);

	//Registering sequencer class with factory
	`uvm_component_utils(ram_sequencer);

	extern function new(string name = "sequencer", uvm_component parent);
endclass
	
	//defining class constructor
	function ram_sequencer::new(string name = "sequencer", uvm_component parent);
		super.new(name, parent);
	endfunction
