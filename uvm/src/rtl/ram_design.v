module ram_design( 
  	input [`width-1:0] data_in,
	input read_enable,
	input write_enable,
	input [$clog2(`depth)-1:0] address,
	input clock,
	input reset,
	output reg [`width-1:0] data_out);

reg [`width-1:0] mem [`depth-1:0];

always@(posedge clock, negedge reset)
begin

	if(!reset)
		data_out <= 'z;

	else
	begin
		if(write_enable && !read_enable)
			mem [address] <= data_in;
		else if(read_enable && !write_enable)
			data_out <= mem [address];
		else
			data_out <= 'z;
	end

end

endmodule
	
