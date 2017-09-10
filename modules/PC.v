// Program counter
module PC (
	clk,
	reset_l,
	data,
	PCL_load,
	PCH_load,
	PC_inc,
	PC
);

input clk;
input reset_l;
input [7:0] data;
input PCL_load;
input PCH_load;
input PC_inc;

wire [7:0] data;

output [15:0] PC;
reg [15:0] PC;

always @(posedge clk) begin : PC_reg
	if (~reset_l) begin
		PC <= 0;
	end else if (PCL_load) begin
		PC[7:0] <= data;
	end else if (PCH_load) begin
		PC[15:8] <= data;
	end else if (PC_inc) begin
		PC <= PC + 1;
	end
end

endmodule
