module control (
	clk,
	reset_l,
	opcode,
	// Load the low byte of the program start vect|| into PCL
	PCL_load,
	// Load the high byte of the program start vect|| into PCH
	PCH_load,
	// Choose which source to load ABL from
	ABL_sel,
	// Choose which source to load ABH from
	ABH_sel,
	// Load ABL (if not loaded, will default to holding previous value)
	ABL_load,
	// Load ABH (same hold behavior)
	ABH_load,
	// Load IR
	IR_load,
	// Increment PC
	PC_inc,
	AI_sel,
	// Load AI
	AI_load,
	// Load BI
	BI_load,
	// Load DOR
	DOR_load,
	// Load ACC
	ACC_load,
	// Read/write signal
	r_w,
	// ALU micro-operation
	uop,
	// ALU result and flags
	alu_result,
	carry_in,
	overflow_in,
	// Status control signals
	p_enable,
	set_carry,
	set_zero,
	set_int_disable,
	set_break,
	set_overflow,
	set_negative
);

`include "misc_constants.v"
`include "opcodes.v"

// Inputs
input clk;
input reset_l;
input [7:0] opcode;
input [7:0] alu_result;
input carry_in;
input overflow_in;

wire [7:0] opcode;
wire [7:0] alu_result;

// Outputs
output PCL_load;
output PCH_load;
output [2:0] ABL_sel;
output [1:0] ABH_sel;
output ABL_load;
output ABH_load;
output IR_load;
output PC_inc;
output [1:0] AI_sel;
output AI_load;
output BI_load;
output DOR_load;
output ACC_load;
output r_w;
output [3:0] uop;
output p_enable;
output set_carry;
output set_zero;
output set_int_disable;
output set_break;
output set_overflow;
output set_negative;

reg PCL_load;
reg PCH_load;
reg [2:0] ABL_sel;
reg [1:0] ABH_sel;
reg ABL_load;
reg ABH_load;
reg IR_load;
reg PC_inc;
reg [1:0] AI_sel;
reg AI_load;
reg BI_load;
reg DOR_load;
reg ACC_load;
reg r_w;
reg [3:0] uop;
reg p_enable;
reg set_carry;
reg set_zero;
reg set_int_disable;
reg set_break;
reg set_overflow;
reg set_negative;

// States f|| the FSM (binary encoding)
parameter RST0 = 4'b0000;
parameter RST1 = 4'b0001;
parameter RST2 = 4'b0010;
parameter RST3 = 4'b0011;
parameter T0 = 4'b0100;
parameter T1 = 4'b0101;
parameter T2 = 4'b0110;
parameter T3 = 4'b0111;
parameter T4 = 4'b1000;
parameter T5 = 4'b1001;
parameter T6 = 4'b1010;
parameter T7 = 4'b1011;

reg [3:0] state;
reg [3:0] nxt_state;

wire read_mod_write_acc;
wire read_mod_write_zp;
wire read_mod_write_zp_x;
wire read_mod_write_abs;
wire read_mod_write_abs_x;

wire internal_exec_imm;
wire internal_exec_zp;
wire internal_exec_zp_x;
wire internal_exec_zp_y;
wire internal_exec_abs;
wire internal_exec_abs_x;
wire internal_exec_abs_y;
wire internal_exec_ind_x;
wire internal_exec_ind_y;

task set_flags;
    begin
        if (carry_in) begin
            set_carry = 1;
        end else begin
            set_carry = 0;
        end
        if (alu_result) begin
            set_zero = 1;
        end else begin
            set_zero = 0;
        end
        if (alu_result[7]) begin
            set_negative = 1;
        end else begin
            set_negative = 0;
        end
        if (overflow_in) begin
            set_overflow = 1;
        end else begin
            set_overflow = 0;
        end
    end
endtask

always @(posedge clk) begin : state_register
	if (~reset_l) begin
		state <= RST0;
	end else begin
		state <= nxt_state;
	end
end

always @(state, reset_l, opcode, read_mod_write_acc, read_mod_write_zp) begin : state_trans
	// Default to current state
	nxt_state = state;
	case (state)
		RST0:
			// Initialize everything
			if (reset_l) begin
				nxt_state = RST1;
			end
		RST1:
			// Load FFFC into ADL and ADH, enable PCL
			nxt_state = RST2;
		RST2:
			// Load FFFC into ADL and ADH, enable PCL
			nxt_state = RST3;
		RST3:
			// Put PCH & PCL on the address bus, enable PC
			nxt_state = T0;
		T0:
			nxt_state = T1;
		T1:
			if (read_mod_write_acc || internal_exec_imm) begin
				nxt_state = T0;
			end else if (read_mod_write_zp || read_mod_write_zp_x) begin
				nxt_state = T2;
			end
		T2:
			if (read_mod_write_zp || read_mod_write_zp_x) begin
				nxt_state = T3;
			end
		T3:
			if (read_mod_write_zp || read_mod_write_zp_x) begin
				nxt_state = T4;
			end
		T4:
			if (read_mod_write_zp) begin
				nxt_state = T0;
			end else if (read_mod_write_zp_x) begin
				nxt_state = T5;
			end
		T5:
			if (read_mod_write_zp_x) begin
				nxt_state = T0;
			end
	endcase
end

always @(state, opcode, read_mod_write_acc, read_mod_write_zp) begin : outputs
	PCL_load = 0;
	PCH_load = 0;
	ABL_sel = 0;
	ABH_sel = 0;
	ABL_load = 0;
	ABH_load = 0;
	IR_load = 0;
	PC_inc = 0;
	BI_load = 0;
	AI_sel = 0;
	AI_load = 0;
	DOR_load = 0;
	// Default is read
	r_w = 1;
	uop = 0;

	case (state)
		RST0:
			// Load FFFC into ADL and ADH
			ABL_load = 1;
			ABH_load = 1;
		RST1:
			// Load FFFD into ADL and ADH by incrementing ADL
			// Load the low byte of the start of the program into PCL
			PCL_load = 1;
			ABL_sel = FD_ABL;
			ABL_load = 1;
		RST2:
			PCH_load = 1;
		RST3:
			// Pass the PC value to the AB registers
			ABL_sel = PCL_ABL;
			ABH_sel = PCH_ABH;
			ABL_load = 1;
			ABH_load = 1;
			PC_inc = 1;
		T0:
			IR_load = 1;
			ABL_sel = PCL_ABL;
			ABH_sel = PCH_ABH;
			ABL_load = 1;
			ABH_load = 1;
			PC_inc = 1;
			
			if (read_mod_write_acc) begin
				AI_load = 1;
				AI_sel = ACC_AI;
			end
		T1:
			if (read_mod_write_acc) begin
				ACC_load = 1;
				
				case (opcode)
					ASL_acc:
						uop = SHIFT_LEFT_AI;
					LSR_acc:
						uop = SHIFT_RIGHT_AI;
					ROL_acc:
						uop = ROTATE_LEFT_AI;
					ROR_acc:
						uop = ROTATE_RIGHT_AI;
				endcase
				
				// Set flags
				p_enable <= 1;
				set_flags();
		T2:
			if (read_mod_write_zp) begin
				BI_load = 1;
			end else if (read_mod_write_zp_x) begin
				ABL_load = 1;
				ABL_sel = ALU_ABL;
				uop = ADD;
			end else if (read_mod_write_abs) begin
				ABH_sel = DATA_ABH;
				ABH_load = 1;
				ALU_sel = PASS_BI;
				ABL_SEL = ALU_ABL;
				ABL_load = 1;
			end
		T3:
			if (read_mod_write_zp) begin
				DOR_load = 1;
				case (opcode)
					ASL_zp:
						uop = SHIFT_LEFT_BI;
					LSR_zp:
						uop = SHIFT_RIGHT_BI;
					DEC_zp:
						uop = DECREMENT;
					INC_zp:
						uop = INCREMENT;
					ROL_zp:
						uop = ROTATE_LEFT_BI;
					ROR_zp:
						uop = ROTATE_RIGHT_BI;
				endcase
				
				// Set flags
				p_enable <= 1;
				set_flags();
			end else if (read_mod_write_zp_x) begin
				BI_load = 1;
			end else if (read_mod_write_abs) begin
				BI_load <= 1;
			end
		T4:
			if (read_mod_write_zp) begin	
				r_w = 0;
				ABL_sel = PCL_ABL;
				ABH_sel = PCH_ABH;
				ABL_load = 1;
				ABH_load = 1;
				PC_inc = 1;
			end else if (read_mod_write_zp_x || read_mod_write_abs) begin
				DOR_load = 1;
				case (opcode) 
					ASL_zp_x || ASL_abs:
						uop = SHIFT_LEFT_BI;
					LSR_zp_x || LSR_abs:
						uop = SHIFT_RIGHT_BI;
					DEC_zp_x || DEC_abs:
						uop = DECREMENT;
					INC_zp_x || INC_abs:
						uop = INCREMENT;
					ROL_zp_x || ROL_abs:
						uop = ROTATE_LEFT_BI;
					ROR_zp_x || ROR_abs:
						uop = ROTATE_RIGHT_BI;
				endcase
				
				// Set flags
				p_enable = 1;
				set_flags();
			end
		T5:
			if (read_mod_write_zp_x || read_mod_write_abs) begin
				// Where should I increment PC to be consistent
				// f|| next instr retrieval? Here?
				PC_inc = 1;
				r_w = 0;
				ABL_sel = PCL_ABL;
				ABH_sel = PCH_ABH;
				ABL_load = 1;
				ABH_load = 1;
			end
	endcase
end

// Read-modify-write instructions
assign read_mod_write_acc = (opcode == ASL_acc || opcode == LSR_acc || opcode == ROL_acc || opcode == ROR_acc);
assign read_mod_write_zp = (opcode == ASL_zp || opcode == LSR_zp || opcode == DEC_zp
							|| opcode == INC_zp || opcode == ROL_zp || opcode == ROR_zp);
assign read_mod_write_zp_x = (opcode == ASL_zp_x || opcode == LSR_zp_x || opcode == DEC_zp_x
							|| opcode == ROL_zp_x || opcode == INC_zp_x || opcode == ROR_zp_x);
assign read_mod_write_abs = (opcode == ASL_abs || opcode == LSR_abs || opcode == DEC_abs
							|| opcode == INC_abs || opcode == ROL_abs  || opcode == ROR_abs);
assign read_mod_write_abs_x = (opcode == ASL_abs_x || opcode == LSR_abs_x || opcode == DEC_abs_x
							|| opcode == INC_abs_x || opcode == ROL_abs_x || opcode == ROR_abs_x);

// Internal execution instructions	
assign internal_exec_imm = (opcode == ADC_imm || opcode == AND_imm || opcode == CMP_imm ||
							opcode == CPX_imm || opcode == CPY_imm || opcode == EOR_imm || opcode 
							== LDA_imm || opcode == LDX_imm || opcode == LDY_imm || opcode == ORA_imm
							|| opcode == SBC_imm);
assign internal_exec_zp = (opcode == ADC_zp || opcode == AND_zp || opcode == BIT_zp || opcode
							== CMP_zp || opcode == CPX_zp || opcode == CPY_zp || opcode == EOR_zp ||
							opcode == LDA_zp || opcode == LDX_zp || opcode == LDY_zp || opcode == 
							ORA_zp || opcode == SBC_zp);
assign internal_exec_zp_x = (opcode == ADC_zp_x || opcode == AND_zp_x || opcode == CMP_zp_x
							|| opcode == EOR_zp_x || opcode == LDA_zp_x || opcode == LDY_zp_x ||
							opcode == ORA_zp_x || opcode == SBC_zp_x);
assign internal_exec_zp_y = (opcode == LDX_zp_y);
assign internal_exec_abs = (opcode == ADC_abs || opcode == AND_abs || opcode == BIT_abs || 
							opcode == CMP_abs || opcode == CPX_abs || opcode == CPY_abs || opcode == 
							EOR_abs || opcode == LDA_abs || opcode == LDX_abs || opcode == LDY_abs
							|| opcode == ORA_abs || opcode == SBC_abs);
assign internal_exec_abs_x = (opcode == ADC_abs_x || opcode == AND_abs_x || opcode == 
							CMP_abs_x || opcode == EOR_abs_x || opcode == LDA_abs_x || opcode == 
							LDY_abs_x || opcode == ORA_abs_x || opcode == SBC_abs_x);
assign internal_exec_abs_y = (opcode == ADC_abs_y || opcode == AND_abs_y || opcode == CMP_abs_y
							|| opcode == EOR_abs_y || opcode == LDA_abs_y || opcode == LDX_abs_y || opcode 
							== ORA_abs_y || opcode == SBC_abs_y);
assign internal_exec_ind_x = (opcode == ADC_ind_x || opcode ==AND_ind_x || opcode == CMP_ind_x
							|| opcode == EOR_ind_x || opcode == LDA_ind_x || opcode == ORA_ind_x || 
							opcode == SBC_ind_x);
assign internal_exec_ind_y = (opcode == ADC_ind_y || opcode == AND_ind_y || opcode == CMP_ind_y
							|| opcode == EOR_ind_y || opcode == LDA_ind_y || opcode == ORA_ind_y || opcode 
							== SBC_ind_y);
						
endmodule
