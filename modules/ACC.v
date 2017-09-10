// Intermediate data register
// TODO: mux zp signals for fewer bits
module ACC (
	clk,
	reset_l,
	data,
	ALU,
	ACC_load,
	ACC
);

input clk;
input reset_l;
input [7:0] data;
input [7:0] ALU;
input ACC_load;

wire [7:0] data;
wire [7:0] ALU;

output [7:0] ACC;

reg [7:0] ACC;

always @(posedge clk) begin : ACC_reg
	if (~reset_l) begin
		ACC <= 0;
	end else if (ACC_load) begin
		ACC <= ALU;
	end
end

endmodule
