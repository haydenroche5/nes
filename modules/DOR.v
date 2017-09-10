// Data output register
module DOR (
	clk,
	reset_l,
	ALU,
	DOR_load,
	DOR
)

input clk;
input reset_l;
input [7:0] ALU;
input DOR_load;

wire [7:0] ALU;

output [7:0] DOR;
reg [7:0] DOR;

always @(posedge clk) begin : DOR_reg
	if (~reset_l) begin
		DOR <= 0
	end else if (DOR_load) begin
		DOR <= ALU;
	end
end

endmodule
