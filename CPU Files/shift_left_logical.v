module shift_left_logical(
    data_operandA, ctrl_shiftamt, data_result
);

    input [31:0] data_operandA;
    input [4:0] ctrl_shiftamt;
    output [31:0] data_result;

    wire [31:0] w1, w2, w3, w4;

    sll_sixteen sixteen(.data_result(w1), .ctrl_shiftamt(ctrl_shiftamt[4]), .data_operandA(data_operandA));
    sll_eight eight(.data_result(w2), .ctrl_shiftamt(ctrl_shiftamt[3]), .data_operandA(w1));
    sll_four four(.data_result(w3), .ctrl_shiftamt(ctrl_shiftamt[2]), .data_operandA(w2));
    sll_two two(.data_result(w4), .ctrl_shiftamt(ctrl_shiftamt[1]), .data_operandA(w3));
    sll_one one(.data_result(data_result), .ctrl_shiftamt(ctrl_shiftamt[0]), .data_operandA(w4));
    
endmodule