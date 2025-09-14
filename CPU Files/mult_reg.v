module mult_reg (
    data_writeReg, data_readReg, write_to, ctrl_reset, clk
);

    input [64:0] data_writeReg;
    input write_to, ctrl_reset, clk;
    output [64:0] data_readReg;

    genvar i;
    generate
        for (i=0; i<65; i=i+1) begin
            dffe_ref dff(.d(data_writeReg[i]), .clk(clk), .clr(ctrl_reset), .en(write_to), .q(data_readReg[i]));
        end
    endgenerate
    
endmodule