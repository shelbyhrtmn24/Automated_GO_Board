module op_decoder (
    opcode, r_type, i_type, bex, j_ii
);
    
    input[4:0] opcode;
    output r_type, i_type, bex, j_ii;

    assign r_type = !(opcode[4] | opcode[3] | opcode[2] | opcode[1] | opcode[0]);
    assign i_type = (opcode[2] & !opcode[1] & opcode[0]);
    assign bex = opcode[4] & !opcode[3] & opcode[2] & opcode[1] & !opcode[0];
    assign j_ii = !opcode[4] & !opcode[3] & opcode[2] & !opcode[1] & !opcode[0];
endmodule