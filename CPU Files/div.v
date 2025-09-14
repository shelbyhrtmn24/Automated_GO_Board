module div (
    data_operandA, data_operandB, clk, rst, data_result, data_resultRDY, data_exception 
    //count, register_in, register_out, initial_input, saved_output, dividend, divisor, remainder, quotient, test_subtract, inverted_quotient, negated_quotient
);
    
    input [31:0] data_operandA, data_operandB;
    input clk, rst;

    output [31:0] data_result;
    output data_resultRDY, data_exception;

    wire first_pass, sub_bad;
    wire trash_wire, dead1, dead2, dead3;
    wire data_a_neg, data_b_neg, flip_quotient;
    wire [5:0] count;           // output for testing
    wire [63:0] register_in, register_out, initial_input, saved_output;         // output for testing
    wire [31:0] dividend, divisor;          //output for testing
    wire [31:0] inverted_A, inverted_B, negated_A, negated_B, errorless_result;
    wire [31:0] remainder, quotient, test_subtract, inverted_quotient, negated_quotient;        //output for testing

    assign data_a_neg = data_operandA[31];
    assign data_b_neg = data_operandB[31];

    assign inverted_A = ~data_operandA;
    assign inverted_B = ~data_operandB;

    full_cla negateA(.A(inverted_A), .B(32'b1), .data_result(negated_A), .c_in(1'b0), .c_out(dead1));
    full_cla negateB(.A(inverted_B), .B(32'b1), .data_result(negated_B), .c_in(1'b0), .c_out(dead2));

    assign dividend = data_a_neg ? negated_A : data_operandA;
    assign divisor = data_b_neg ? negated_B : data_operandB;

    counter_32 counter(.clk(clk), .rst(rst), .count(count));   

    div_reg running_quotient(.data_writeReg(register_in), .data_readReg(register_out), .write_to(1'b1), .ctrl_reset(rst), .clk(clk)); 

    assign saved_output = register_out<<1;
    //assign remainder = saved_output[63:32]; at least before the test subtract control logic
    //assign quotient = saved_output[31:0];

    assign initial_input = {32'b0, dividend};
    assign first_pass = ~count[0] & ~count[1] & ~count[2] & ~count[3] & ~count[4] & ~count[5];

    full_cla subtracter(.A(saved_output[63:32]), .B(~divisor), .data_result(test_subtract), .c_in(1'b1), .c_out(trash_wire));

    assign sub_bad = test_subtract[31];

    //assign quotient[0] = sub_bad ? 1'b0 : 1'b1;
    assign quotient = sub_bad ? {saved_output[31:1], 1'b0} : {saved_output[31:1], 1'b1};
    assign remainder = sub_bad ? saved_output[63:32] : test_subtract;

    assign register_in = first_pass ? initial_input : {remainder, quotient};

    divisor_all_zero exceptioncheck(.divisor(data_operandB), .oof(data_exception));
    assign data_resultRDY = count[5] & ~count[0] | data_exception;

    assign inverted_quotient = ~quotient;
    full_cla negateQ(.A(inverted_quotient), .B(32'b1), .data_result(negated_quotient), .c_in(1'b0), .c_out(dead3));

    assign flip_quotient = data_operandB[31] ^ data_operandA[31];

    assign errorless_result = flip_quotient ? negated_quotient : quotient;
    assign data_result = data_exception ? 32'b0 : errorless_result;

endmodule