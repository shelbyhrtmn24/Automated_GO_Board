module four_input_mux (
    mux_out, select, in0, in1, in2, in3
);

    input[31:0] in0, in1, in2, in3;
    input[1:0] select;
    output[31:0] mux_out;
    wire[31:0] top_choice, bottom_choice;

    assign top_choice = select[0] ? in1 : in0;
    assign bottom_choice = select[0] ? in3 : in2;
    assign mux_out = select[1] ? bottom_choice : top_choice; 
    
endmodule