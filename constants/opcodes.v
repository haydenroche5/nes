// ADC: Add with carry
parameter ADC_imm = 8'h69;
parameter ADC_zp = 8'h65;
parameter ADC_zp_x = 8'h75;
parameter ADC_abs = 8'h6D;
parameter ADC_abs_x = 8'h7D;
parameter ADC_abs_y = 8'h79;
parameter ADC_ind_x = 8'h61;
parameter ADC_ind_y = 8'h71;

// AND: Logical AND
parameter AND_imm = 8'h29;
parameter AND_zp = 8'h25;
parameter AND_zp_x = 8'h35;
parameter AND_abs = 8'h2D;
parameter AND_abs_x = 8'h3D;
parameter AND_abs_y = 8'h39;
parameter AND_ind_x = 8'h21;
parameter AND_ind_y = 8'h31;

// ASL: Arithmetic shift left
parameter ASL_acc = 8'h0A;
parameter ASL_zp = 8'h06;
parameter ASL_zp_x = 8'h16;
parameter ASL_abs = 8'h0E;
parameter ASL_abs_x = 8'h1E;

// BCC: Branch if carry clear
parameter BCC = 8'h90;

// BCS: Branch if carry set
parameter BCS = 8'hB0;

// BEQ: Branch if equal
parameter BEQ = 8'hF0;

// BIT: Bit test
parameter BIT_zp = 8'h24;
parameter BIT_abs = 8'h2C;

// BMI: Branch if minus
parameter BMI = 8'h30;

// BNE: Branch if not equal
parameter BNE = 8'hD0;

// BPL: Branch if plus
parameter BPL = 8'h10;

// BRK: Force interrupt
parameter BRK = 8'h00;

// BVC: Branch if overflow clear
parameter BVC = 8'h50;

// BVS: Branch if overflow set
parameter BVS = 8'h70;

// CLC: Clear carry flag
parameter CLC = 8'h18;

// CLD: Clear decimal flag (NOT USED)

// CLI: Clear interrupt disable
parameter CLI = 8'h58;

// CLV: Clear overflow flag
parameter CLV = 8'hB8;

// CMP: Compare
parameter CMP_imm = 8'hC9;
parameter CMP_zp = 8'hC5;
parameter CMP_zp_x = 8'hD5;
parameter CMP_abs = 8'hCD;
parameter CMP_abs_x = 8'hDD;
parameter CMP_abs_y = 8'hD9;
parameter CMP_ind_x = 8'hC1;
parameter CMP_ind_y = 8'hD1;

// CPX: Compare X
parameter CPX_imm = 8'hE0;
parameter CPX_zp = 8'hE4;
parameter CPX_abs = 8'hEC;

// CPX: Compare Y
parameter CPY_imm = 8'hC0;
parameter CPY_zp = 8'hC4;
parameter CPY_abs = 8'hCC;

// DEC: Decrement memory
parameter DEC_zp = 8'hC6;
parameter DEC_zp_x = 8'hD6;
parameter DEC_abs = 8'hCE;
parameter DEC_abs_x = 8'hDE;

// DEX: Decrement X
parameter DEX = 8'hCA;

// DEY: Decrement Y
parameter DEY = 8'h88;

// EOR: Logical XOR
parameter EOR_imm = 8'h49;
parameter EOR_zp = 8'h45;
parameter EOR_zp_x = 8'h55;
parameter EOR_abs = 8'h4D;
parameter EOR_abs_x = 8'h5D;
parameter EOR_abs_y = 8'h59;
parameter EOR_ind_x = 8'h41;
parameter EOR_ind_y = 8'h51;

// INC: Increment memory
parameter INC_zp = 8'hE6;
parameter INC_zp_x = 8'hF6;
parameter INC_abs = 8'hEE;
parameter INC_abs_x = 8'hFE;

// INX: Increment X
parameter INX = 8'hE8;

// INY: Increment X
parameter INY = 8'hC8;

// JMP: Jump
parameter JMP_abs = 8'h4C;
parameter JMP_ind = 8'h6C;

// JSR: Jump to subroutine
parameter JSR = 8'h20;

// LDA: Load accumulator
parameter LDA_imm = 8'hA9;
parameter LDA_zp = 8'hA5;
parameter LDA_zp_x = 8'hB5;
parameter LDA_abs = 8'hAD;
parameter LDA_abs_x = 8'hBD;
parameter LDA_abs_y = 8'hB9;
parameter LDA_ind_x = 8'hA1;
parameter LDA_ind_y = 8'hB1;

// LDX: Load X
parameter LDX_imm = 8'hA2;
parameter LDX_zp = 8'hA6;
parameter LDX_zp_y = 8'hB6;
parameter LDX_abs = 8'hAE;
parameter LDX_abs_y = 8'hBE;

// LDY: Load Y
parameter LDY_imm = 8'hA0;
parameter LDY_zp = 8'hA4;
parameter LDY_zp_x = 8'hB4;
parameter LDY_abs = 8'hAC;
parameter LDY_abs_x = 8'hBC;

// LSR: Logical shift right
parameter LSR_acc = 8'h4A;
parameter LSR_zp = 8'h46;
parameter LSR_zp_x = 8'h56;
parameter LSR_abs = 8'h4E;
parameter LSR_abs_x = 8'h5E;

// NOP: No operation
parameter NOP = 8'hEA;

// ORA: Logical OR
parameter ORA_imm = 8'h09;
parameter ORA_zp = 8'h05;
parameter ORA_zp_x = 8'h15;
parameter ORA_abs = 8'h0D;
parameter ORA_abs_x = 8'h1D;
parameter ORA_abs_y = 8'h19;
parameter ORA_ind_x = 8'h01;
parameter ORA_ind_y = 8'h11;

// PHA: Push accumulator
parameter PHA = 8'h48;

// PHP: Push processor status
parameter PHP = 8'h08;

// PLA: Pull accumulator
parameter PLA = 8'h68;

// PLP: Pull processor status
parameter PLP = 8'h28;

// ROL: Rotate left
parameter ROL_acc = 8'h2A;
parameter ROL_zp = 8'h26;
parameter ROL_zp_x = 8'h36;
parameter ROL_abs = 8'h2E;
parameter ROL_abs_x = 8'h3E;

// ROL: Rotate right
parameter ROR_acc = 8'h6A;
parameter ROR_zp = 8'h66;
parameter ROR_zp_x = 8'h76;
parameter ROR_abs = 8'h6E;
parameter ROR_abs_x = 8'h7E;

// RTI: Return from interrupt
parameter RTI = 8'h40;

// RTS: Return from subroutine
parameter RTS = 8'h60;

// SBC: Subtract with carry
parameter SBC_imm = 8'h69;
parameter SBC_zp = 8'h65;
parameter SBC_zp_x = 8'h75;
parameter SBC_abs = 8'h6D;
parameter SBC_abs_x = 8'h7D;
parameter SBC_abs_y = 8'h79;
parameter SBC_ind_x = 8'h61;
parameter SBC_ind_y = 8'h71;

// SEC: Set carry flag
parameter SEC = 8'h38;

// SED: Set decimal flag (NOT USED)

// SEI: Set interrupt disable
parameter SEI = 8'h78;

// STA: Store accumulator
parameter STA_zp = 8'h85;
parameter STA_zp_x = 8'h95;
parameter STA_abs = 8'h8D;
parameter STA_abs_x = 8'h9D;
parameter STA_abs_y = 8'h99;
parameter STA_ind_x = 8'h81;
parameter STA_ind_y = 8'h91;

// STX: Store X
parameter STX_zp = 8'h86;
parameter STX_zp_y = 8'h96;
parameter STX_abs = 8'h8E;

// STY: Store Y
parameter STY_zp = 8'h84;
parameter STY_zp_x = 8'h94;
parameter STY_abs = 8'h8C;

// TAX: Transfer accumulator to X
parameter TAX = 8'hAA;

// TAY: Transfer accumulator to Y
parameter TAY = 8'hA8;

// TSX: Transfer SP to X
parameter TSX = 8'hBA;

// TXA: Transfer X to accumulator
parameter TXA = 8'h8A;

// TXS: Transfer X to SP
parameter TXS = 8'h9A;

// TYA: Transfer Y to accumulator
parameter TYA = 8'h98;
