// B input register
module BI (
	clk,
	reset_l,
	data,
	BI_load,
	BI
)

input clk;
input reset_l;
input [7:0] data;
input BI_load;

wire [7:0] data;

output [7:0] BI;
reg [7:0] BI;

always @(posedge clk) begin : BI_reg
	if (~reset_l) begin
		BI <= 0;
	end else if (BI_load) begin
		BI <= data;
	end
end

endmodule
