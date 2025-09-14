module mult_tb;

    reg signed [31:0] data_operandA;
    reg signed [31:0] data_operandB;
    reg clk, rst;

    wire signed [31:0] data_result;
    wire data_exception, data_resultRDY;

    wire [64:0] product_in, product_out, initial_input, raw_data, final_result;
    wire [31:0] cla_in, cla_out, shifted_data, subtract_data, inverted_data;
    wire [4:0] count;

    wire ctrl_add, ctrl_sub, ctrl_shift, ctrl_zeroin;

    mult test(.data_operandA(data_operandA), .data_operandB(data_operandB), .clk(clk), .rst(rst), .data_result(data_result), .data_exception(data_exception), 
        .data_resultRDY(data_resultRDY), .count(count), .product_in(product_in), .product_out(product_out), .initial_input(initial_input), 
        .raw_data(raw_data), .inverted_data(inverted_data), .final_result(final_result), .cla_in(cla_in), .cla_out(cla_out), 
        .shifted_data(shifted_data), .subtract_data(subtract_data), .ctrl_add(ctrl_add), .ctrl_sub(ctrl_sub), .ctrl_shift(ctrl_shift), .ctrl_zeroin(ctrl_zeroin));

    initial begin
        $dumpfile("Mult_Test.vcd");
        $dumpvars(0, mult_tb);
        data_operandA = -32'd8;
        data_operandB = 32'd16;
        rst = 1'b0;
        clk = 1'b0;
        #320;
        $finish;
    end

    always 
        #10 clk <= ~clk;
    always @ (posedge clk) begin
        $display("Current counter: %b", count);
        $display("Initial_input: %b", initial_input);
        $display("Product out: %b", product_out);
        $display("Raw Data (shifted by 2): %b", raw_data);
        $display("Inverted data: %b", inverted_data);
        $display("Shifted data: %b", shifted_data);
        $display("Subtract data: %b", subtract_data);
        $display("Cla_in: %b", cla_in);
        $display("Cla_out: %b", cla_out);
        $display(" ");
        $display("Ctrl Sub: %b", ctrl_sub);
        $display("Ctrl Add: %b", ctrl_add);
        $display("Ctrl Shift: %b", ctrl_shift);
        $display("Ctrl Zero In: %b", ctrl_zeroin);
        $display("Product in: %b", product_in);
        $display("--------------------------------------------------------------------");

        if (count[3] & count[2] & count[1] & count[0]) begin
            $display("Test Case: count[3 : 0] is TRUE");
            $display("data_result: %b", data_result);
            $display("Result RDY firing?", data_resultRDY);
        end


    end
endmodule