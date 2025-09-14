module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
    wire [31:0] inverted_B;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    wire yay_board1, yay_board2;

    // Invert B:
    bitwise_not notB(.data_result(inverted_B), .B(data_operandB));

    // On full CLA: remember to set c_in to 0 for addition, 1 for subtraction
    wire [31:0] data_and, data_or, data_sub, data_add, shifted_left, shifted_right;

    bitwise_and AB(.data_result(data_and), .data_operandA(data_operandA), .data_operandB(data_operandB));
    bitwise_or AorB(.data_result(data_or), .data_operandA(data_operandA), .data_operandB(data_operandB));

    shift_left_logical left(.data_result(shifted_left), .ctrl_shiftamt(ctrl_shiftamt), .data_operandA(data_operandA));
    shift_right_arithmetic right(.data_result(shifted_right), .ctrl_shiftamt(ctrl_shiftamt), .data_operandA(data_operandA));

    // Addition: add A and B, c_in = 0
    // Subtraction: add A and inverted_B, c_in = 1
    full_cla addition(.data_result(data_add), .A(data_operandA), .B(data_operandB), .c_in(1'b0), .c_out(yay_board1));
    full_cla subtraction(.data_result(data_sub), .A(data_operandA), .B(inverted_B), .c_in(1'b1), .c_out(yay_board2));

    // Choose output w/ mux
    mux_8 data_out(.out(data_result), .select(ctrl_ALUopcode[2:0]), .in0(data_add), .in1(data_sub), .in2(data_and), 
        .in3(data_or), .in4(shifted_left), .in5(shifted_right), .in6(32'b0), .in7(32'b0));

    // isNotEqual
    or (isNotEqual, data_sub[31], data_sub[30], data_sub[29], data_sub[28], data_sub[27], data_sub[26], data_sub[25], data_sub[24], data_sub[23], 
        data_sub[22], data_sub[21], data_sub[20], data_sub[19], data_sub[18], data_sub[17], data_sub[16], data_sub[15], data_sub[14], data_sub[13], 
        data_sub[12], data_sub[11], data_sub[10], data_sub[9], data_sub[8], data_sub[7], data_sub[6], data_sub[5], data_sub[4], data_sub[3], 
        data_sub[2], data_sub[1], data_sub[0]);

    // Overflow
    wire w1, w2, w3, pos_ovf, neg_ovf, sum_msb, that_is_the_question;
    mux_2_shifter add_or_sub(.out(sum_msb), .select(ctrl_ALUopcode[0]), .in0(data_add[31]), .in1(data_sub[31]));
    mux_2_shifter to_B_or_not_to_B(.out(that_is_the_question), .select(ctrl_ALUopcode[0]), .in0(data_operandB[31]), .in1(inverted_B[31]));
    not (w1, data_operandA[31]);
    not (w2, that_is_the_question);
    and (pos_ovf, w1, w2, sum_msb);
    not (w3, sum_msb);
    and (neg_ovf, data_operandA[31], that_is_the_question, w3);
    or (overflow, pos_ovf, neg_ovf);

    // isLessThan
    wire w4, w5, w6, w7;
    not (w4, pos_ovf);
    and (w6, data_sub[31], w4);
    not (w5, data_sub[31]);
    and (w7, w5, neg_ovf);
    or (isLessThan, w6, w7);
    
endmodule