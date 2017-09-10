// Arithmetic-logic unit
module ALU (
	AI,
	BI,
	uop,
	carry_in,
	carry_out,
	overflow_out,
	result
);

`include "alu_uops.v"

input [7:0] AI;
input [7:0] BI;
input [3:0] uop;
input carry_in;

wire [7:0] AI;
wire [7:0] BI;
wire [3:0] uop;

output carry_out;
output overflow_out;
output [7:0] result;

wire carry_out;
reg overflow_out;
reg result;

// Logic for calculating ALU result
always @(uop) begin : result_calc
	case (uop)
		SHIFT_LEFT_BI:
			result = {BI[6:0], 1'b0};
		SHIFT_RIGHT_BI:
			result = {1'b0, BI[7:1]};
		DECREMENT:
			result = BI - 1;
		INCREMENT:
			result = BI + 1;
		ROTATE_LEFT_BI:
			result = {BI[6:0], 1'b0} | {7'b0000000, carry_in};
		ROTATE_RIGHT_BI:
			result = {1'b0, BI[7:1]} | {carry_in, 7'b0000000};
		SHIFT_LEFT_AI:
			result = {AI[6:0], 1'b0};
		SHIFT_RIGHT_AI:
			result = {1'b0, AI[7:1]};
		ROTATE_LEFT_AI:
			result = {AI[6:0], 1'b0} | {7'b0000000, carry_in};
		ROTATE_RIGHT_AI:
			result = {1'b0, AI[7:1]} | {carry_in, 7'b0000000};
		ADD:
			result = AI + BI;
		PASS_BI:
			result = BI;
		default:
			result = 0;
	endcase
end

// Logic for calculating carry out
assign carry_out = (uop == SHIFT_LEFT_BI && BI[7] == 1) ||
				   (uop == SHIFT_LEFT_AI && AI[7] == 1) ||
				   (uop == ROTATE_LEFT_BI && BI[7] == 1) ||
				   (uop == ROTATE_LEFT_AI && AI[7] == 1) ||
				   (uop == SHIFT_RIGHT_BI && BI[0] == 1) ||
				   (uop == SHIFT_RIGHT_AI && AI[0] == 1) ||
				   (uop == ROTATE_RIGHT_BI && BI[0] == 1) ||
				   (uop == ROTATE_RIGHT_AI && AI[0] == 1);

// TODO: Other flags

endmodule
