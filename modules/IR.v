// Instruction register
module IR (
	clk,
	reset_l,
	data,
	IR_load,
	IR
)

input clk;
input reset_l;
input [7:0] data;
input IR_load;

wire [7:0] data;

output [7:0] IR;
reg [7:0] IR;

always @(posedge clk) begin : IR_reg
	if (~reset_l) begin
		IR <= 0;
	end else if (IR_load) begin
		IR <= data;
	end
end

endmodule
