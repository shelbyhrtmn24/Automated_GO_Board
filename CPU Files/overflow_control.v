module overflow_control (
    global_opcode, alu_opcode, alu_ovf, muldiv_ovf, ovf, xm_o_ovf
);

    input[4:0] global_opcode, alu_opcode;
    input alu_ovf, muldiv_ovf;
    output ovf;
    output[31:0] xm_o_ovf;
    wire add_insn, addi_insn, sub_insn, div_insn, mul_insn;
    wire dx_is_r_type;

    assign dx_is_r_type = !global_opcode[4] & !global_opcode[3] & !global_opcode[2] & !global_opcode[1] & !global_opcode[0];

    assign add_insn = dx_is_r_type & !alu_opcode[4] & !alu_opcode[3] & !alu_opcode[2] & !alu_opcode[1] & !alu_opcode[0];
    assign addi_insn = !global_opcode[4] & !global_opcode[3] & global_opcode[2] & !global_opcode[1] & global_opcode[0];
    assign sub_insn = dx_is_r_type & !alu_opcode[4] & !alu_opcode[3] & !alu_opcode[2] & !alu_opcode[1] & alu_opcode[0];
    assign div_insn = dx_is_r_type & !alu_opcode[4] & !alu_opcode[3] & alu_opcode[2] & alu_opcode[1] & alu_opcode[0];
    assign mul_insn = dx_is_r_type & !alu_opcode[4] & !alu_opcode[3] & alu_opcode[2] & alu_opcode[1] & !alu_opcode[0];

    tristate_buffer add_ovf(.in(32'd1), .oe((add_insn & alu_ovf)), .out(xm_o_ovf));
    tristate_buffer addi_ovf(.in(32'd2), .oe((addi_insn & alu_ovf)), .out(xm_o_ovf));
    tristate_buffer sub_ovf(.in(32'd3), .oe((sub_insn & alu_ovf)), .out(xm_o_ovf));
    tristate_buffer mul_ovf(.in(32'd4), .oe((mul_insn & muldiv_ovf)), .out(xm_o_ovf));
    tristate_buffer div_ovf(.in(32'd5), .oe((div_insn & muldiv_ovf)), .out(xm_o_ovf));

    assign ovf = (alu_ovf & (add_insn | addi_insn | sub_insn)) | (muldiv_ovf & (mul_insn | div_insn));
    
endmodule