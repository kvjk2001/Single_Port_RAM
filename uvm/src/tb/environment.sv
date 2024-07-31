class environment extends uvm_env;

	//registering environment class with factory
	`uvm_component_utils(environment)

	//declaring handles for testbench components under environment
	active_agent a_agent;
	passive_agent p_agent;
	reference refer;
	coverage cov;
	scoreboard sb;

	//declaring functions
	extern function new(string name = "environment", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass

	//defining class constructor
	function environment::new(string name = "environment", uvm_component parent);
		super.new(name, parent);
	endfunction

	//defining build phase
	function void environment::build_phase(uvm_phase phase);
		super.build_phase(phase);
		a_agent = active_agent::type_id::create("a_agent", this);
		p_agent = passive_agent::type_id::create("p_agent", this);
		refer = reference::type_id::create("refer", this);
		cov = coverage::type_id::create("cov", this);
		sb = scoreboard::type_id::create("sb", this);
	endfunction

	//defining connect phase
	function void environment::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		a_agent.in_mon.in_mon2cov_ref.connect(cov.cov2in_mon);
		a_agent.in_mon.in_mon2cov_ref.connect(refer.ref2in_mon);
		p_agent.out_mon.out_mon2cov_sb.connect(cov.cov2out_mon);
		p_agent.out_mon.out_mon2cov_sb.connect(sb.sb2out_mon);
		refer.ref2sb.connect(sb.sb2ref);

	endfunction

