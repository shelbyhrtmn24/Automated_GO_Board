module stall_controls (
    fd_ir, dx_ir, xm_ir, mult_running, div_running, ctrl_mult, ctrl_div, hazard_stall, multdiv_stall
);
    
    input[31:0] fd_ir, dx_ir, xm_ir;
    input mult_running, div_running, ctrl_mult, ctrl_div;
    output hazard_stall, multdiv_stall;

    wire[4:0] fd_opcode, dx_opcode, xm_opcode, fd_rs, fd_rt, dx_rs, dx_rt, dx_rd, xm_rd;
    wire fd_is_r, dx_is_r, fd_is_sw, dx_is_lw;
    assign fd_opcode = fd_ir[31:27];
    assign dx_opcode = dx_ir[31:27];
    assign xm_opcode = xm_ir[31:27];

    assign fd_rs = fd_ir[21:17];
    assign fd_rt = fd_ir[16:12];
    assign dx_rs = dx_ir[21:17];
    assign dx_rt = dx_ir[16:12];
    assign dx_rd = dx_ir[26:22];
    assign xm_rd = xm_ir[26:22];

    // Lw to ALUop case
    assign fd_is_r = !fd_opcode[4] & !fd_opcode[3] & !fd_opcode[2] & !fd_opcode[1] & !fd_opcode[0];
    assign dx_is_lw = !dx_opcode[4] & dx_opcode[3] & !dx_opcode[2] & !dx_opcode[1] & !dx_opcode[0];
    assign fd_is_sw = !fd_opcode[4] & !fd_opcode[3] & fd_opcode[2] & fd_opcode[1] & fd_opcode[0];

    assign multdiv_stall = mult_running | div_running | ctrl_mult | ctrl_div; 
    assign hazard_stall = dx_is_lw & ((fd_rs == dx_rd) | ((fd_rt == dx_rd) & !fd_is_sw));
endmodule