module counter_32_tb;

    reg clk, rst;
    wire [5:0] count;

    counter_32 test(.clk(clk), .rst(rst), .count(count));

    initial begin
        clk = 0;
        #660;
        $finish;
    end

    always
        #10 clk=~clk;
    always @ (clk) begin
        #1;
        $display("%d", count);
    end

endmodule