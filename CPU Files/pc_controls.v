module pc_controls (
    DX_PC_out, DX_IR_out, DX_A_out, immed, alult, aluneq, ctrl_PC, branch_jump_taken
);

    input [31:0] DX_PC_out, DX_IR_out, DX_A_out, immed;
    input alult, aluneq;
    output [31:0] ctrl_PC;
    output branch_jump_taken;

    wire bne, blt, actual_lt, branch_taken, jump, jr, bex; 
    wire rstatus_nonzero;
    wire [4:0] dx_opcode;
    wire [31:0] branch_PC, jump_PC, target;

    assign dx_opcode = DX_IR_out[31:27];
    assign actual_lt = !alult & aluneq;

    assign target[31:27] = 5'b0;
    assign target[26:0] = DX_IR_out[26:0];

    full_cla branch_adder(.A(DX_PC_out), .B(immed), .data_result(branch_PC), .c_in(1'b0), .c_out());
    assign bne = !dx_opcode[4] & !dx_opcode[3] & !dx_opcode[2] & dx_opcode[1] & !dx_opcode[0];
    assign blt = !dx_opcode[4] & !dx_opcode[3] & dx_opcode[2] & dx_opcode[1] & !dx_opcode[0];
    assign jr = !dx_opcode[4] & !dx_opcode[3] & dx_opcode[2] & !dx_opcode[1] & !dx_opcode[0];
    assign jump = !dx_opcode[4] & !dx_opcode[3] & !dx_opcode[2] & dx_opcode[0];
    assign bex = dx_opcode[4] & !dx_opcode[3] & dx_opcode[2] & dx_opcode[1] & !dx_opcode[0];

    assign rstatus_nonzero = DX_A_out || 32'b0;

    assign jump_PC = (jump | (bex & rstatus_nonzero)) ? target : DX_A_out;
    assign ctrl_PC = (bne | blt) ? branch_PC : jump_PC;
    
    assign branch_taken = (actual_lt & blt) | (aluneq & bne) | (bex & rstatus_nonzero);
    assign branch_jump_taken = branch_taken | jump | jr;

endmodule