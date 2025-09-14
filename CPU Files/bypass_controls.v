module bypass_controls (
    dx_ir, xm_ir, mw_ir, bypass_a_select, bypass_b_select, wm_select
);

    input[31:0] dx_ir, xm_ir, mw_ir;
    output[1:0] bypass_a_select, bypass_b_select;
    output wm_select;

    wire xm_is_r_type, xm_is_lw, xm_is_addi, xm_is_sw, xm_is_branch, xm_is_setx;
    wire mw_is_r_type, mw_is_lw, mw_is_addi, mw_is_setx; 
    wire dx_is_r_type, dx_is_jii, dx_is_bex;
    wire dx_a_xm_rd_same, dx_b_xm_rd_same, dx_a_mw_rd_same, dx_b_mw_rd_same, xm_mw_rds_same;
    wire wx_a_temp, wx_b_temp;
    wire[4:0] dx_opcode, xm_opcode, mw_opcode;
    wire[4:0] dx_rs, dx_rt, dx_rd, dx_a, dx_b, temp;
    wire[4:0] xm_rd;
    wire[4:0] mw_rd;

    assign dx_opcode = dx_ir[31:27];
    assign xm_opcode = xm_ir[31:27];
    assign mw_opcode = mw_ir[31:27];

    assign dx_is_r_type = !dx_opcode[4] & !dx_opcode[3] & !dx_opcode[2] & !dx_opcode[1] & !dx_opcode[0];
    assign dx_is_jii = !dx_opcode[4] & !dx_opcode[3] & dx_opcode[2] & !dx_opcode[1] & !dx_opcode[0];
    assign dx_is_bex = dx_opcode[4] & !dx_opcode[3] & dx_opcode[2] & dx_opcode[1] & !dx_opcode[0];
    // assign dx_i_not_branch = (!dx_opcode[4] & !dx_opcode[3] & dx_opcode[2] & dx_opcode[0]) | (!dx_opcode[4] & dx_opcode[3] & !dx_opcode[2] & !dx_opcode[1] & !dx_opcode[0]);
    assign xm_is_r_type = !xm_opcode[4] & !xm_opcode[3] & !xm_opcode[2] & !xm_opcode[1] & !xm_opcode[0];
    assign mw_is_r_type = !mw_opcode[4] & !mw_opcode[3] & !mw_opcode[2] & !mw_opcode[1] & !mw_opcode[0];
    assign xm_is_lw = !xm_opcode[4] & xm_opcode[3] & !xm_opcode[2] & !xm_opcode[1] & !xm_opcode[0];
    assign mw_is_lw = !mw_opcode[4] & mw_opcode[3] & !mw_opcode[2] & !mw_opcode[1] & !mw_opcode[0];
    assign xm_is_addi = !xm_opcode[4] & !xm_opcode[3] & xm_opcode[2] & !xm_opcode[1] & xm_opcode[0];
    assign mw_is_addi = !mw_opcode[4] & !mw_opcode[3] & mw_opcode[2] & !mw_opcode[1] & mw_opcode[0];
    assign xm_is_sw = !xm_opcode[4] & !xm_opcode[3] & xm_opcode[2] & xm_opcode[1] & xm_opcode[0];
    assign xm_is_branch = (!xm_opcode[4] & !xm_opcode[3] & !xm_opcode[2] & xm_opcode[1] & !xm_opcode[0]) | 
        (!xm_opcode[4] & !xm_opcode[3] & xm_opcode[2] & xm_opcode[1] & !xm_opcode[0]);
    assign xm_is_setx = xm_opcode[4] & !xm_opcode[3] & xm_opcode[2] & !xm_opcode[1] & xm_opcode[0];
    assign mw_is_setx = mw_opcode[4] & !mw_opcode[3] & mw_opcode[2] & !mw_opcode[1] & mw_opcode[0];

    //Find address for dx_a
    // assign rs_address = j_ii ? FD_IR_out[26:22] : FD_IR_out[21:17];
    // assign ctrl_readRegA = bex ? 5'd30 : rs_address;
    assign temp = dx_is_jii ? dx_ir[26:22] : dx_ir[21:17];
    assign dx_a = dx_is_bex ? 5'd30 : temp;

    //Find address for dx_b
    //assign rt_address = r_type ? FD_IR_out[16:12] : FD_IR_out[26:22];
    assign dx_b = dx_is_r_type ? dx_ir[16:12] : dx_ir[26:22];

    assign xm_rd = xm_is_setx ? 5'd30 : xm_ir[26:22];
    assign mw_rd = mw_is_setx ? 5'd30 : mw_ir[26:22];

    assign dx_a_xm_rd_same = (dx_a == xm_rd);
    assign dx_b_xm_rd_same = (dx_b == xm_rd);
    assign dx_a_mw_rd_same = (dx_a == mw_rd);
    assign dx_b_mw_rd_same = (dx_b == mw_rd);
    assign xm_mw_rds_same = xm_rd == mw_rd; 

    //Bypass selectors: 2 = WX bypass, 1 = MX bypass, 0 = no bypass
    assign wx_a_temp = (mw_is_lw | mw_is_r_type | mw_is_addi | mw_is_setx) & dx_a_mw_rd_same & mw_rd != 5'b0;
    assign bypass_a_select[0] = (xm_is_r_type | xm_is_lw | xm_is_addi | xm_is_setx) & dx_a_xm_rd_same & xm_rd != 5'b0;
    assign wx_b_temp = (mw_is_lw | mw_is_r_type | mw_is_addi | mw_is_setx) & dx_b_mw_rd_same & mw_rd != 5'b0;
    assign bypass_b_select[0] = (xm_is_r_type | xm_is_lw | xm_is_addi | xm_is_setx) & dx_b_xm_rd_same & xm_rd != 5'b0;
    assign wm_select = xm_is_sw & mw_is_lw & xm_mw_rds_same;

    //If both an MX and WX bypass are indicated, prioritize the MX bypass only if xm_ir is an instruction that will cause a RAW error
    assign bypass_a_select[1] = (wx_a_temp & bypass_a_select[0] & (xm_is_r_type | xm_is_lw | xm_is_addi | xm_is_setx)) ? 1'b0 : wx_a_temp;
    assign bypass_b_select[1] = (wx_b_temp & bypass_b_select[0] & (xm_is_r_type | xm_is_lw | xm_is_addi | xm_is_setx)) ? 1'b0 : wx_b_temp;

endmodule