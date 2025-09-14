module sra_four(
    data_operandA, data_result, ctrl_shiftamt
);

    input [31:0] data_operandA;
    input ctrl_shiftamt;
    output [31:0] data_result;

    mux_2_shifter mux31(.out(data_result[31]), .select(ctrl_shiftamt), .in0(data_operandA[31]), .in1(data_operandA[31]));
    mux_2_shifter mux30(.out(data_result[30]), .select(ctrl_shiftamt), .in0(data_operandA[30]), .in1(data_operandA[31]));
    mux_2_shifter mux29(.out(data_result[29]), .select(ctrl_shiftamt), .in0(data_operandA[29]), .in1(data_operandA[31]));
    mux_2_shifter mux28(.out(data_result[28]), .select(ctrl_shiftamt), .in0(data_operandA[28]), .in1(data_operandA[31]));
    mux_2_shifter mux27(.out(data_result[27]), .select(ctrl_shiftamt), .in0(data_operandA[27]), .in1(data_operandA[31]));
    mux_2_shifter mux26(.out(data_result[26]), .select(ctrl_shiftamt), .in0(data_operandA[26]), .in1(data_operandA[30]));
    mux_2_shifter mux25(.out(data_result[25]), .select(ctrl_shiftamt), .in0(data_operandA[25]), .in1(data_operandA[29]));
    mux_2_shifter mux24(.out(data_result[24]), .select(ctrl_shiftamt), .in0(data_operandA[24]), .in1(data_operandA[28]));
    mux_2_shifter mux23(.out(data_result[23]), .select(ctrl_shiftamt), .in0(data_operandA[23]), .in1(data_operandA[27]));
    mux_2_shifter mux22(.out(data_result[22]), .select(ctrl_shiftamt), .in0(data_operandA[22]), .in1(data_operandA[26]));
    mux_2_shifter mux21(.out(data_result[21]), .select(ctrl_shiftamt), .in0(data_operandA[21]), .in1(data_operandA[25]));
    mux_2_shifter mux20(.out(data_result[20]), .select(ctrl_shiftamt), .in0(data_operandA[20]), .in1(data_operandA[24]));
    mux_2_shifter mux19(.out(data_result[19]), .select(ctrl_shiftamt), .in0(data_operandA[19]), .in1(data_operandA[23]));
    mux_2_shifter mux18(.out(data_result[18]), .select(ctrl_shiftamt), .in0(data_operandA[18]), .in1(data_operandA[22]));
    mux_2_shifter mux17(.out(data_result[17]), .select(ctrl_shiftamt), .in0(data_operandA[17]), .in1(data_operandA[21]));
    mux_2_shifter mux16(.out(data_result[16]), .select(ctrl_shiftamt), .in0(data_operandA[16]), .in1(data_operandA[20]));
    mux_2_shifter mux15(.out(data_result[15]), .select(ctrl_shiftamt), .in0(data_operandA[15]), .in1(data_operandA[19]));
    mux_2_shifter mux14(.out(data_result[14]), .select(ctrl_shiftamt), .in0(data_operandA[14]), .in1(data_operandA[18]));
    mux_2_shifter mux13(.out(data_result[13]), .select(ctrl_shiftamt), .in0(data_operandA[13]), .in1(data_operandA[17]));
    mux_2_shifter mux12(.out(data_result[12]), .select(ctrl_shiftamt), .in0(data_operandA[12]), .in1(data_operandA[16]));
    mux_2_shifter mux11(.out(data_result[11]), .select(ctrl_shiftamt), .in0(data_operandA[11]), .in1(data_operandA[15]));
    mux_2_shifter mux10(.out(data_result[10]), .select(ctrl_shiftamt), .in0(data_operandA[10]), .in1(data_operandA[14]));
    mux_2_shifter mux9(.out(data_result[9]), .select(ctrl_shiftamt), .in0(data_operandA[9]), .in1(data_operandA[13]));
    mux_2_shifter mux8(.out(data_result[8]), .select(ctrl_shiftamt), .in0(data_operandA[8]), .in1(data_operandA[12]));
    mux_2_shifter mux7(.out(data_result[7]), .select(ctrl_shiftamt), .in0(data_operandA[7]), .in1(data_operandA[11]));
    mux_2_shifter mux6(.out(data_result[6]), .select(ctrl_shiftamt), .in0(data_operandA[6]), .in1(data_operandA[10]));
    mux_2_shifter mux5(.out(data_result[5]), .select(ctrl_shiftamt), .in0(data_operandA[5]), .in1(data_operandA[9]));
    mux_2_shifter mux4(.out(data_result[4]), .select(ctrl_shiftamt), .in0(data_operandA[4]), .in1(data_operandA[8]));
    mux_2_shifter mux3(.out(data_result[3]), .select(ctrl_shiftamt), .in0(data_operandA[3]), .in1(data_operandA[7]));
    mux_2_shifter mux2(.out(data_result[2]), .select(ctrl_shiftamt), .in0(data_operandA[2]), .in1(data_operandA[6]));
    mux_2_shifter mux1(.out(data_result[1]), .select(ctrl_shiftamt), .in0(data_operandA[1]), .in1(data_operandA[5]));
    mux_2_shifter mux0(.out(data_result[0]), .select(ctrl_shiftamt), .in0(data_operandA[0]), .in1(data_operandA[4]));


    
endmodule