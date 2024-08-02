class ram_test extends uvm_test;

	//registering test class with factory	
	`uvm_component_utils(ram_test)

	//declaring handles for sequence and environment classes
	regression_sequence packet_seq;
	ram_environment env;

	//declaring functions
	extern function new(string name = "test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration();
	extern task run_phase(uvm_phase phase);
endclass

	//defining class constructor
	function ram_test::new(string name = "test", uvm_component parent);
		super.new(name, parent);
	endfunction	

	//defining build phase
	function void ram_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
		packet_seq = regression_sequence::type_id::create("packet_seq", this);
		env = ram_environment::type_id::create("env", this);
	endfunction

	//defining end of elaboration phase
	function void ram_test::end_of_elaboration();
		super.end_of_elaboration();
		print();
	endfunction

	//defining run phase
	task ram_test::run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		packet_seq.start(env.a_agent.seq);
		phase.drop_objection(this);
		phase.phase_done.set_drain_time(this, 120);
	endtask


