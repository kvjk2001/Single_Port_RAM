class ram_sequence_item extends uvm_sequence_item;

	//Input and output field declaration
	rand bit [`width-1:0] data_in;
	rand bit write_enable;
	rand bit read_enable;
	rand bit [$clog2(`depth)-1:0] address;
	bit [`width-1:0] data_out;
 
	//Registering sequence_item class with factory
	`uvm_object_utils_begin (ram_sequence_item)
	`uvm_field_int (data_in, UVM_DEFAULT)
	`uvm_field_int (write_enable, UVM_DEFAULT)
	`uvm_field_int (read_enable, UVM_DEFAULT)
	`uvm_field_int (address, UVM_DEFAULT)
	`uvm_field_int (data_out, UVM_DEFAULT)
	`uvm_object_utils_end

	extern function new(string name = "sequence_item");
endclass

	//defining class constructor
	function ram_sequence_item::new(string name = "sequence_item");
		super.new(name);
	endfunction

