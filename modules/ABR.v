// Address bus registers
module ABR  (
	clk,
	reset_l,
	data,
	ABL_load,
	ABL_sel,
	ABH_load,
	ABH_sel,
	ACC,
	ALU,
	PCL,
	PCH,
	addr
);

`include "misc_constants.v"

// Inputs
input clk;
input reset_l;
input [7:0] data;
input ABL_load;
input [2:0] ABL_sel;
input ABH_load;
input [1:0] ABH_sel;
input [7:0] ACC;
input [7:0] ALU;
input [7:0] PCL;
input [7:0] PCH;

wire [7:0] data;
wire [2:0] ABL_sel;
wire [1:0] ABH_sel;
wire [7:0] ACC;
wire [7:0] ALU;
wire [7:0] PCL;
wire [7:0] PCH;

// Output
output [15:0] addr;

// Concatenate ABH and ABL to form the 16-bit address
wire [15:0] addr = {ABH, ABL};

reg [7:0] ABL;
reg [7:0] ABH;

// Register for low byte of the address bus
always @(posedge clk) begin : ABL_reg
    if (~reset_l) begin
        ABL <= 0;
    end else if (ABL_load) begin
        case (ABL_sel)
            DATA_ABL:
                ABL <= data;
            ACC_ABL:
                ABL <= ACC;
            ALU_ABL:
                ABL <= ALU;
            PCL_ABL:
                ABL <= PCL;
            FC_ABL:
                ABL <= 8'hFC;
            FD_ABL:
                ABL <= 8'hFD;
        endcase
    end
end

// Register for high byte of the address bus
always @(posedge clk) begin : ABH_reg
    if (~reset_l) begin
        ABH <= 0;
    end else if (ABH_load) begin
        case (ABH_sel)
            CLR_ABH:
                ABH <= 0;
            DATA_ABH:
                ABH <= data;
            PCH_ABH:
                ABH <= PCH;
            FF_ABH:
                ABH <= 8'hFF;
        endcase
    end
end

endmodule
