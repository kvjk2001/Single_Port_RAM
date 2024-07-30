module ram_design( 
  input [7:0] data_in,
	input read_enable,
	input write_enable,
	input [7:0] address,
	input clock,
	input reset,
	output reg [7:0] data_out);

reg [7:0] mem [255:0];

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
	
