//`include "macros.sv"
class ram_sequence extends uvm_sequence #(sequence_item);

	//Registering sequence class with factory
	`uvm_object_utils(ram_sequence)

	//defining class constructor
	function new(string name = "sequence");
		super.new(name);
	endfunction

	//executable body
	virtual task body();
	endtask

endclass


//write sequence
class write_sequence extends ram_sequence;

	`uvm_object_utils(write_sequence)

	function new(string name = "write_sequence");
		super.new(name);
	endfunction

	task body();

  	sequence_item packet = sequence_item::type_id::create("packet");
	
		repeat(`no_of_seq)
		begin
			`uvm_do_with(packet, { packet.write_enable == 1; packet.read_enable == 0; packet.address == 1;})
		end
	endtask

endclass



//read sequence
class read_sequence extends ram_sequence;

	`uvm_object_utils(read_sequence)

	function new(string name = "read_sequence");
		super.new(name);
	endfunction

	task body();
		sequence_item packet = sequence_item::type_id::create("packet");

		repeat(`no_of_seq)
		begin
			`uvm_do_with(packet, { {packet.write_enable, packet.read_enable} == 2'b01; packet.address == 1;})
		end
	endtask

endclass



//regression sequence
class regression_sequence extends ram_sequence;

	`uvm_object_utils(regression_sequence)

	function new(string name = "regression_sequence");
		super.new(name);
	endfunction

	task body();
		write_sequence seq1;
		read_sequence seq2;

		repeat(1)
		begin
			`uvm_do(seq1)
			`uvm_do(seq2)
		end
	endtask

endclass

