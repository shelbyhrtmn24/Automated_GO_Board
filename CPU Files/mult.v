module mult (
    data_operandA, data_operandB, clk, rst, data_result, data_exception, data_resultRDY
);

    input [31:0] data_operandA, data_operandB;
    input clk, rst;
    output [31:0] data_result;
    output data_exception, data_resultRDY;
    wire ctrl_sub, ctrl_add, ctrl_shift, ctrl_zeroin;

    // For mod 8 counter:
    wire [4:0] count;
    wire first_pass;
    wire adder_carryout;
    wire [64:0] product_in, product_out, initial_input, raw_data, final_result;
    wire [31:0] cla_in, cla_out, shifted_data, inverted_data, subtract_data;

    mod_sixteen_counter counter(.clk(clk), .count(count), .rst(rst));

    mult_reg running_result(.data_writeReg(product_in), .data_readReg(product_out), .write_to(1'b1), .ctrl_reset(rst), .clk(clk));

    // first_pass decides if on clock cycle 1 (count = 0000), if so, just send inputs straight into control/CLA
    assign first_pass = ~count[0] & ~count[1] & ~count[2] & ~count[3] & ~count[4]; 
    assign initial_input = {32'b0, data_operandA, 1'b0};

    // Assigns initial data if clk = 0, if not, then pulls from register
    //assign raw_data = first_pass ? initial_input : $signed(product_out)>>>2;
    assign raw_data = first_pass ? initial_input : product_out;

    // shifts data if needed, then negates shifted data and puts that in if needed, or dumps that and sends 0 based on Booth bits
    assign shifted_data = ctrl_shift ? (data_operandB<<1) : data_operandB;
    assign inverted_data = ~(shifted_data);
    assign subtract_data = ctrl_sub ? inverted_data : shifted_data;
    assign ctrl_zeroin = (~ctrl_sub) & (~ctrl_add); 
    assign cla_in = ctrl_zeroin ? 32'b0 : subtract_data;
    //assign cla_in = subtract_data;

    mult_ctrl control(.booth_bits(raw_data[2:0]), .add(ctrl_add), .sub(ctrl_sub), .shift(ctrl_shift));

    full_cla adder(.A(raw_data[64:33]), .B(cla_in), .data_result(cla_out), .c_in(ctrl_sub), .c_out(adder_carryout));

    //assign product_in = {cla_out, raw_data[32:0]};
    assign product_in = $signed({cla_out, raw_data[32:0]})>>>2;
    //assign product_in = first_pass ? initial_input : {cla_out, product_out[32:0]};

    assign data_resultRDY = count[3] & count[2] & count[1] & count[0];    
    
    //assign final_result = $signed(product_out)>>>2;
    assign final_result = product_in;
    exception_check excp(.A(final_result[64:32]), .exception(data_exception));
    assign data_result = final_result[32:1];
endmodule