module decoder_32_tb (
    select, out
);
    input [4:0] select;
    output [31:0] out;

    reg enable;

    decoder_32 test(.enable(enable), .select(select), .out(out));
    integer i;
    assign select = i;
    initial begin
        assign enable = 1'b0;
        for (i=0; i<32; i=i+1) begin
            #20;
            $display("En:%b, Select:%b, Out:%b", enable, select, out);
        end
        assign enable = 1'b1;
        $display("i=%d", i);
        for (i=0; i<32; i=i+1) begin
            #20;
            $display("En:%b, Select:%b, Out:%b", enable, select, out);
        end
        $finish;
    end

endmodule