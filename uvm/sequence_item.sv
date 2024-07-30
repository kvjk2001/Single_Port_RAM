class sequence_item extends uvm_sequence_item;

	//Input and output field declaration
	rand bit [7:0] data_in;
	rand bit write_enable;
	rand bit read_enable;
	rand bit [7:0] address;
	bit [7:0] data_out;
 
	//Registering sequence_item class with factory
	`uvm_object_utils_begin (sequence_item)
	`uvm_field_int (data_in, UVM_DEFAULT)
	`uvm_field_int (write_enable, UVM_DEFAULT)
	`uvm_field_int (read_enable, UVM_DEFAULT)
	`uvm_field_int (address, UVM_DEFAULT)
	`uvm_field_int (data_out, UVM_DEFAULT)
	`uvm_object_utils_end

	extern function new(string name = "sequence_item");
endclass

	//defining class constructor
	function sequence_item::new(string name = "sequence_item");
		super.new(name);
	endfunction

