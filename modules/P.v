// Processor status register
module P (
	clk,
	reset_l,
	p_enable,
	set_carry,
	set_zero,
	set_int_disable,
	set_break,
	set_overflow,
	set_negative,
	status
)

input clk;
input reset_l;
input p_enable;
input set_carry;
input set_zero;
input set_int_disable;
input set_break;
input set_overflow;
input set_negative;

output [7:0] status;
reg [7:0] status;

// From: http://nesdev.com/6502.txt
// Bit No.   7   6   5   4   3   2   1   0
//           S   V       B   D   I   Z   C

assign status[3] = 0;
assign status[5] = 0;

always @(posedge clk) begin : P_reg
	// Check this reset; not from my original VHDL, but I think
	// I just forgot it...
	if (~reset_l) begin
		status <= 0;
	end else if (p_enable) begin
		status[0] <= set_carry;
		status[1] <= set_zero;
		status[2] <= set_int_disable;
		status[4] <= set_break;
		status[6] <= set_overflow;
		status[7] <= set_negative;
	end
end
