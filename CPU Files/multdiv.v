module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    wire mult_reset, div_reset;
    wire div_exception, mult_exception, any_exception;
    wire mult_rdy, div_rdy;
    wire last_operation;
    wire [31:0] mult_result, div_result;
    assign mult_reset = ctrl_MULT;
    assign div_reset = ctrl_DIV;

    mult mulitplier(.data_operandA(data_operandA), .data_operandB(data_operandB), .clk(clock), .rst(mult_reset), 
        .data_result(mult_result), .data_exception(mult_exception), .data_resultRDY(mult_rdy));

    div divider(.data_operandA(data_operandA), .data_operandB(data_operandB), .clk(clock), .rst(div_reset), .data_result(div_result), 
        .data_resultRDY(div_rdy), .data_exception(div_exception));

    //TODO: Replace the code below with a register/dff that remembers which operation was called last so that it can select the correct output
    //DFF, enable = ctrl_mult | ctrl_div, d = ctrl_mult | ~ctrl_div, q = last_operation, 0 for div, 1 for mult
    //last_operation then goes into muxes similar to those shown below
    dffe_ref lastop(.q(last_operation), .d(ctrl_MULT | ~ctrl_DIV), .clk(clock), .en(ctrl_MULT | ctrl_DIV), .clr(1'b0));

    assign data_result = last_operation ? mult_result : div_result;
    assign any_exception = last_operation ? mult_exception : div_exception;
    assign data_resultRDY = last_operation ? mult_rdy : div_rdy;

    assign data_exception = any_exception & data_resultRDY;

    // assign data_resultRDY = mult_rdy;
    // assign data_result = mult_result;
    // assign data_exception = mult_exception;
endmodule