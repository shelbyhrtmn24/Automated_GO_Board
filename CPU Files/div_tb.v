module div_tb;

    reg signed [31:0] data_operandA;
    reg signed [31:0] data_operandB;
    reg clk, rst;

    wire signed [31:0] data_result, negated_quotient, inverted_quotient;
    wire data_exception, data_resultRDY;
    wire [5:0] count;
    wire [63:0] register_in, register_out, initial_input, saved_output;
    wire [31:0] dividend, divisor, remainder, quotient, test_subtract;

    div test(.data_operandA(data_operandA), .data_operandB(data_operandB), .clk(clk), .rst(rst), .data_result(data_result), 
        .data_resultRDY(data_resultRDY), .data_exception(data_exception), .count(count), .register_in(register_in), .register_out(register_out), 
        .initial_input(initial_input), .saved_output(saved_output), .dividend(dividend), .divisor(divisor), .remainder(remainder), 
        .quotient(quotient), .test_subtract(test_subtract), .inverted_quotient(inverted_quotient), .negated_quotient(negated_quotient));

    initial begin
        $dumpfile("Div_Test.vcd");
        $dumpvars(0, div_tb);
        data_operandA = 32'd16;
        data_operandB = 32'd8;
        rst = 1'b0;
        clk = 1'b0;
        #660;
        $finish;
    end

    always 
        #10 clk <= ~clk;
    always @ (posedge clk) begin
        if (~count[5] & ~count[4] & ~count[3] & ~count[2] & ~count[1] & ~count[0]) begin
            $display("Operation First Pass Parameters:");
            $display("Operand A: %b", data_operandA);
            $display("Operand B: %b", data_operandB);
            $display("Dividend: %b", dividend);
            $display("Divisor: %b", divisor);
            $display("Initial Input: %b", initial_input);
            $display("--------------------------------------------------------");
            $display("");
            
        end

        $display("Count: %b", count);
        $display("register out:");
        $display("Shifted left by 1:");
        $display("%b", register_out);
        $display("%b", saved_output);
        $display("Test Sub: %b", test_subtract);
        $display("Remainder (Post test-sub): %b", remainder);
        $display("Quotient: %b", quotient);
        $display("Register in: %b", register_in);
        $display("");

        if (count[5] & ~count[4] & ~count[3] & ~count[2] & ~count[1] & ~count[0]) begin
            $display("Count = 100000");
            $display();
            $display("data_result: %b", data_result);
            $display("Result RDY firing? ", data_resultRDY);
            $display("Exception?: %b", data_exception);
        end


    end
endmodule