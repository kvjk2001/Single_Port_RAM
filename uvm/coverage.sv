`uvm_analysis_imp_decl(_in_mon)
`uvm_analysis_imp_decl(_out_mon)

class coverage extends uvm_subscriber;

	//Registering coverage in factory
	`uvm_component_utils(coverage)

	//declaring sequence item handles
	sequence_item in_mon_packet;
	sequence_item out_mon_packet;

	//declaring analysis implication ports
	uvm_analysis_imp_in_mon #(sequence_item, coverage) cov2in_mon;
	uvm_analysis_imp_out_mon #(sequence_item, coverage) cov2out_mon;

	//declaring variables to store input and output coverage percentage
	real input_coverage;
	real output_coverage;

	//defining covergroup for input signals
	covergroup input_cg;
		coverpoint in_mon_packet.data_in
		{
		bins in_0 = {[0:127]};
		bins in_1 ={[128:255]};
		}

		coverpoint in_mon_packet.write_enable
		{
		bins wr_en_0 = {0};
		bins wr_en_1 = {1};
		}

		coverpoint in_mon_packet.read_enable
		{
		bins rd_en_0 = {0};
		bins rd_en_1 = {1};
		}
	endgroup

	//defining input covergroup object
	input_cg = new();

	//defining covergroup for output signal
	covergroup output_cg;
		coverpoint out_mon_packet.data_out
		{
		bins out_0 = {[0:127]};
		bins out_1 = {[128:255]};
		}
	endgroup

	//defining output covergroup object
	output_cg = new();

	extern function new(string name = "coverage", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void write_in_mon(sequence_item packet);
	extern function void write_out_mon(sequence_item packet);
	extern function void write(T t);

endclass	

	//defining class constructor
	function coverage::new(string name = "coverage", uvm_component parent);
		super.new(name, parent);
	endfunction

	//defining build phase
	function void coverage::build_phase(uvm_phase phase);
		in_mon_packet = sequence_item::type_id::create("in_mon_packet", this);
		out_mon_packet = sequence_item::type_id::create("out_mon_packet", this);

		cov2in_mon = new("cov2in_mon", this);
		cov2out_mon = new("cov2out_mon", this);
	endfunction


	//defining write method for input monitor port
	function void coverage::write_in_mon(sequence_item packet);
		in_mon_packet = packet;
		input_cg.sample();
	endfunction

	//defining write method for output monitor port
	function void coverage::write_out_mon(sequence_item packet);
		out_mon_packet = packet;
		output_cg.sample();
	endfunction

	//defining default write method
	function void coverage::write(T t);
	endfunction

