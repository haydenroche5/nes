// A input register
module AI (
	clk,
	reset_l,
	ACC,
	X,
	Y,
	AI_load,
	AI_sel,
	AI
)

`include "misc_constants.v"

input clk;
input reset_l;
input [7:0] ACC;
input [7:0] X;
input [7:0] Y;
input AI_load;
input [1:0] AI_sel;

wire [7:0] ACC;
wire [7:0] X;
wire [7:0] Y;
wire [1:0] AI_sel;

output [7:0] AI;
reg [7:0] AI;

always @(posedge clk) begin : AI_reg
	if (~reset_l) begin
		AI <= 0
	end else if (AI_load) begin
		case (AI_sel)
			ACC_AI:
				AI <= ACC;
			X_AI:
				AI <= X;
			Y_AI:
				AI <= Y;
		endcase
	end
end

endmodule
