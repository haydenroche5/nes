// CPU top module
module cpu (
	clk,
	reset_l,
	data,
	addr,
	r_w
);

input clk;
input reset_l;

inout [7:0] data;

output [15:0] addr;
output r_w;

wire r_w_int;

wire ACC_load;
wire [7:0] ACC_out;

wire ABL_load;
wire [2:0] ABL_sel;
wire ABH_load;
wire [1:0] ABH_sel;
wire [7:0] ALU_out;

wire PCL_load;
wire PCH_load;
wire PC_inc;
wire [15:0] PC_out;

wire DOR_load;
wire [7:0] DOR_out;

wire AI_load;
wire BI_load;

wire carry_in;
wire carry_out;
wire overflow_out;

wire IR_load;
wire [7:0] IR_out;

wire [7:0] AI_out;
wire [7:0] BI_out;

assign r_w = r_w_int;
// Tri-state buffer to make the RAM function as though it
// has only one data bus.
assign data = (~r_w_int) ? DOR_out : 7'bz;

ACC ACC_inst (
	.clk			(clk),			// input
	.reset_l		(reset_l),		// input
	.data			(data),			// input [7:0]
	.ALU			(ALU_out),		// input [7:0]
	.ACC_load		(ACC_load),		// input
	.ACC			(ACC_out)		// output [7:0]
);

ABR ABR_inst (
	.clk			(clk),			// input
	.reset_l		(reset_l),		// input
	.data			(data),			// input [7:0]
	.ABL_load		(ABL_load),		// input
	.ABL_sel		(ABL_sel),		// input [2:0]
	.ABH_load		(ABH_load),		// input
	.ABH_sel		(ABH_sel),		// input [1:0]
	// When is ABR loaded from ACC?
	.ACC			(ACC_out),		// input [7:0]
	.ALU			(ALU_out),		// input [7:0]
	.PCL			(PC_out[7:0]),	// input [7:0]
	.PCH			(PC_out[15:8]),	// input [7:0]
	addr			(addr)			// output [15:0]
);

PC PC_inst (
	.clk			(clk),			// input
	.reset_l		(reset_l),		// input
	.data			(data),			// input [7:0]
	.PCL_load		(PCL_load),		// input
	.PCH_load		(PCH_load),		// input
	.PC_inc			(PC_inc),		// input
	.PC				(PC_out)		// output [15:0]
);

AI AI_inst (
	.clk			(clk),			// input
	.reset_l		(reset_l),		// input
	.ACC			(ACC_out),		// input [7:0]
	.AI_load		(AI_load),		// input
	.AI				(AI_out)		// output [7:0]
);

BI BI_inst (
	.clk			(clk),			// input
	.reset_l		(reset_l),		// input
	.data			(data),			// input [7:0]
	.BI_load		(BI_load),		// input
	.BI				(BI_out)		// output [7:0]
);

DOR DOR_inst (
	.clk			(clk),			// input
	.reset_l		(reset_l),		// input
	.ALU			(ALU_out),		// input [7:0]
	.DOR_load		(DOR_load),		// input
	.DOR			(DOR_out)		// output [7:0]
);

ALU ALU_inst (
	.AI				(AI_out),		// input [7:0]
	.BI				(BI_out),		// input [7:0]
	.uop			(IR_out),		// input [3:0]
	.carry_in		(carry_in),		// input
	.carry_out		(carry_out),	// output
	.overflow_out	(overflow_out),	// output
	.result			(ALU_out)		// output [7:0]
);

IR IR_inst (
	.clk			(clk),			// input
	.reset_l		(reset_l),		// input
	.data			(data),			// input [7:0]
	.IR_load		(IR_load),		// input
	.IR				(IR_out)		// output [7:0]
);

control control_inst (
	.clk			(clk),			// input
	.reset_l		(reset_l),		// input
	.opcode			(IR_out),		// input [7:0]
	.PCL_load		(PCL_load),		// output
	.PCH_load		(PCH_load),		// output
	.ABL_sel		(ABL_sel),		// output [2:0]
	.ABH_sel		(ABH_sel),		// output [1:0]
	.ABH_load		(ABH_load),		// output
	.ABL_load		(ABL_load),		// output
	.IR_load		(IR_load),		// output
	.PC_inc			(PC_inc),		// output
	.AI_load		(AI_load),		// output
	.BI_load		(BI_load),		// output
	.DOR_load		(DOR_load),		// output
	.ACC_load		(ACC_load),		// output
	.r_w			(r_w_int)		// output
);

endmodule
