class sequencer extends uvm_sequencer #(sequence_item);

	//Registering sequencer class with factory
	`uvm_component_utils(sequencer);

	extern function new(string name = "sequencer", uvm_component parent);
endclass
	
	//defining class constructor
	function sequencer::new(string name = "sequencer", uvm_component parent);
		super.new(name, parent);
	endfunction
