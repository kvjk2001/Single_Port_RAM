class ram_environment extends uvm_env;

	//registering environment class with factory
	`uvm_component_utils(ram_environment)

	//declaring handles for testbench components under environment
	ram_active_agent a_agent;
	ram_passive_agent p_agent;
	ram_reference refer;
	ram_coverage cov;
	ram_scoreboard sb;

	//declaring functions
	extern function new(string name = "environment", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass

	//defining class constructor
	function ram_environment::new(string name = "environment", uvm_component parent);
		super.new(name, parent);
	endfunction

	//defining build phase
	function void ram_environment::build_phase(uvm_phase phase);
		super.build_phase(phase);
		a_agent = ram_active_agent::type_id::create("a_agent", this);
		p_agent = ram_passive_agent::type_id::create("p_agent", this);
		refer = ram_reference::type_id::create("refer", this);
		cov = ram_coverage::type_id::create("cov", this);
		sb = ram_scoreboard::type_id::create("sb", this);
	endfunction

	//defining connect phase
	function void ram_environment::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		a_agent.in_mon.in_mon2cov_ref.connect(cov.cov2in_mon);
		a_agent.in_mon.in_mon2cov_ref.connect(refer.ref2in_mon);
		p_agent.out_mon.out_mon2cov_sb.connect(cov.cov2out_mon);
		p_agent.out_mon.out_mon2cov_sb.connect(sb.sb2out_mon);
		refer.ref2sb.connect(sb.sb2ref);

	endfunction

