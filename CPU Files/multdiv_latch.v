module multdiv_latch (
    in_a, in_b, multdiv_a, multdiv_b, ctrl_mult, ctrl_div, dx_ir, multdiv_ir, result_RDY, mult_running, div_running, clk, mult_op, div_op, reset
);

    input [31:0] in_a, in_b, dx_ir;
    input result_RDY, mult_op, div_op;
    input clk, reset;
    output [31:0] multdiv_a, multdiv_b, multdiv_ir; 
    output mult_running, div_running;
    output ctrl_mult, ctrl_div;

    single_reg multdiv_a_latch(.data_writeReg(in_a), .data_readReg(multdiv_a), .write_to(ctrl_mult | ctrl_div), .ctrl_reset(reset), .clk(clk));
    single_reg multdiv_b_latch(.data_writeReg(in_b), .data_readReg(multdiv_b), .write_to(ctrl_mult | ctrl_div), .ctrl_reset(reset), .clk(clk));
    single_reg multdiv_ir_latch(.data_writeReg(dx_ir), .data_readReg(multdiv_ir), .write_to(ctrl_mult | ctrl_div), .ctrl_reset(reset), .clk(clk));

    wire mult_dff_out, div_dff_out, mult_dff_in, div_dff_in;

    dffe_ref gen_ctrl_mult(.d(mult_op), .q(mult_dff_out), .en(1'b1), .clk(clk), .clr(reset));
    dffe_ref gen_ctrl_div(.d(div_op), .q(div_dff_out), .en(1'b1), .clk(clk), .clr(reset));

    assign ctrl_mult = mult_op & (!mult_dff_out);
    assign ctrl_div = div_op & (!div_dff_out);
    assign mult_dff_in = mult_running ? (!result_RDY) : ctrl_mult;
    assign div_dff_in = div_running ? (!result_RDY) : ctrl_div;    

    dffe_ref mult_check(.d(mult_dff_in), .q(mult_running), .en(1'b1), .clk(clk), .clr(reset | result_RDY));
    dffe_ref div_check(.d(div_dff_in), .q(div_running), .en(1'b1), .clk(clk), .clr(reset | result_RDY));
        
    
endmodule