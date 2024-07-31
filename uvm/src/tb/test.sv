class test extends uvm_test;

	//registering test class with factory	
	`uvm_component_utils(test)

	//declaring handles for sequence and environment classes
	regression_sequence packet_seq;
	environment env;

	//declaring functions
	extern function new(string name = "test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration();
	extern task run_phase(uvm_phase phase);
endclass

	//defining class constructor
	function test::new(string name = "test", uvm_component parent);
		super.new(name, parent);
	endfunction	

	//defining build phase
	function void test::build_phase(uvm_phase phase);
		super.build_phase(phase);
		packet_seq = regression_sequence::type_id::create("packet_seq", this);
		env = environment::type_id::create("env", this);
	endfunction

	//defining end of elaboration phase
	function void test::end_of_elaboration();
		super.end_of_elaboration();
		print();
	endfunction

	//defining run phase
	task test::run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		packet_seq.start(env.a_agent.seq);
		phase.drop_objection(this);
		phase.phase_done.set_drain_time(this, 30);
	endtask


