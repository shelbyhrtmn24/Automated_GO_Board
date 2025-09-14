module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;
	// Decoder buses, each wire controls enable signals for individual register
	wire [31:0] write_to, read_froma, read_fromb;
	// Register outputs
	wire [31:0] out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15, 
		out16, out17, out18, out19, out20, out21, out22, out23, out24, out25, out26, out27, out28, out29, out30, out31;

	// Decode write address, create 32 bit ctrl_writeEnable bus
	decoder_32 write_decode(.out(write_to), .select(ctrl_writeReg), .enable(ctrl_writeEnable));
	
	// Decode read addresses, set up 64 total tristates data_readRegA and B at the end
	decoder_32 read_a(.out(read_froma), .select(ctrl_readRegA), .enable(1'b1));
	decoder_32 read_b(.out(read_fromb), .select(ctrl_readRegB), .enable(1'b1));
	
	// Genvar 31 registers, wire in controls
	single_reg reg1(.data_writeReg(data_writeReg), .data_readReg(out1), .write_to(write_to[1]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg2(.data_writeReg(data_writeReg), .data_readReg(out2), .write_to(write_to[2]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg3(.data_writeReg(data_writeReg), .data_readReg(out3), .write_to(write_to[3]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg4(.data_writeReg(data_writeReg), .data_readReg(out4), .write_to(write_to[4]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg5(.data_writeReg(data_writeReg), .data_readReg(out5), .write_to(write_to[5]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg6(.data_writeReg(data_writeReg), .data_readReg(out6), .write_to(write_to[6]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg7(.data_writeReg(data_writeReg), .data_readReg(out7), .write_to(write_to[7]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg8(.data_writeReg(data_writeReg), .data_readReg(out8), .write_to(write_to[8]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg9(.data_writeReg(data_writeReg), .data_readReg(out9), .write_to(write_to[9]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg10(.data_writeReg(data_writeReg), .data_readReg(out10), .write_to(write_to[10]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg11(.data_writeReg(data_writeReg), .data_readReg(out11), .write_to(write_to[11]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg12(.data_writeReg(data_writeReg), .data_readReg(out12), .write_to(write_to[12]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg13(.data_writeReg(data_writeReg), .data_readReg(out13), .write_to(write_to[13]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg14(.data_writeReg(data_writeReg), .data_readReg(out14), .write_to(write_to[14]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg15(.data_writeReg(data_writeReg), .data_readReg(out15), .write_to(write_to[15]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg16(.data_writeReg(data_writeReg), .data_readReg(out16), .write_to(write_to[16]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg17(.data_writeReg(data_writeReg), .data_readReg(out17), .write_to(write_to[17]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg18(.data_writeReg(data_writeReg), .data_readReg(out18), .write_to(write_to[18]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg19(.data_writeReg(data_writeReg), .data_readReg(out19), .write_to(write_to[19]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg20(.data_writeReg(data_writeReg), .data_readReg(out20), .write_to(write_to[20]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg21(.data_writeReg(data_writeReg), .data_readReg(out21), .write_to(write_to[21]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg22(.data_writeReg(data_writeReg), .data_readReg(out22), .write_to(write_to[22]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg23(.data_writeReg(data_writeReg), .data_readReg(out23), .write_to(write_to[23]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg24(.data_writeReg(data_writeReg), .data_readReg(out24), .write_to(write_to[24]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg25(.data_writeReg(data_writeReg), .data_readReg(out25), .write_to(write_to[25]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg26(.data_writeReg(data_writeReg), .data_readReg(out26), .write_to(write_to[26]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg27(.data_writeReg(data_writeReg), .data_readReg(out27), .write_to(write_to[27]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg28(.data_writeReg(data_writeReg), .data_readReg(out28), .write_to(write_to[28]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg29(.data_writeReg(data_writeReg), .data_readReg(out29), .write_to(write_to[29]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg30(.data_writeReg(data_writeReg), .data_readReg(out30), .write_to(write_to[30]), .ctrl_reset(ctrl_reset), .clk(clock));
	single_reg reg31(.data_writeReg(data_writeReg), .data_readReg(out31), .write_to(write_to[31]), .ctrl_reset(ctrl_reset), .clk(clock));

	// Make register 0: the literal 0 register
	single_reg reg0(.data_writeReg(32'b0), .data_readReg(out0), .write_to(write_to[0]), .ctrl_reset(ctrl_reset), .clk(clock));

	// Tri-state buffers for reads
	tristate_buffer A0(.in(out0), .oe(read_froma[0]), .out(data_readRegA));
	tristate_buffer A1(.in(out1), .oe(read_froma[1]), .out(data_readRegA));
	tristate_buffer A2(.in(out2), .oe(read_froma[2]), .out(data_readRegA));
	tristate_buffer A3(.in(out3), .oe(read_froma[3]), .out(data_readRegA));
	tristate_buffer A4(.in(out4), .oe(read_froma[4]), .out(data_readRegA));
	tristate_buffer A5(.in(out5), .oe(read_froma[5]), .out(data_readRegA));
	tristate_buffer A6(.in(out6), .oe(read_froma[6]), .out(data_readRegA));
	tristate_buffer A7(.in(out7), .oe(read_froma[7]), .out(data_readRegA));
	tristate_buffer A8(.in(out8), .oe(read_froma[8]), .out(data_readRegA));
	tristate_buffer A9(.in(out9), .oe(read_froma[9]), .out(data_readRegA));
	tristate_buffer A10(.in(out10), .oe(read_froma[10]), .out(data_readRegA));
	tristate_buffer A11(.in(out11), .oe(read_froma[11]), .out(data_readRegA));
	tristate_buffer A12(.in(out12), .oe(read_froma[12]), .out(data_readRegA));
	tristate_buffer A13(.in(out13), .oe(read_froma[13]), .out(data_readRegA));
	tristate_buffer A14(.in(out14), .oe(read_froma[14]), .out(data_readRegA));
	tristate_buffer A15(.in(out15), .oe(read_froma[15]), .out(data_readRegA));
	tristate_buffer A16(.in(out16), .oe(read_froma[16]), .out(data_readRegA));
	tristate_buffer A17(.in(out17), .oe(read_froma[17]), .out(data_readRegA));
	tristate_buffer A18(.in(out18), .oe(read_froma[18]), .out(data_readRegA));
	tristate_buffer A19(.in(out19), .oe(read_froma[19]), .out(data_readRegA));
	tristate_buffer A20(.in(out20), .oe(read_froma[20]), .out(data_readRegA));
	tristate_buffer A21(.in(out21), .oe(read_froma[21]), .out(data_readRegA));
	tristate_buffer A22(.in(out22), .oe(read_froma[22]), .out(data_readRegA));
	tristate_buffer A23(.in(out23), .oe(read_froma[23]), .out(data_readRegA));
	tristate_buffer A24(.in(out24), .oe(read_froma[24]), .out(data_readRegA));
	tristate_buffer A25(.in(out25), .oe(read_froma[25]), .out(data_readRegA));
	tristate_buffer A26(.in(out26), .oe(read_froma[26]), .out(data_readRegA));
	tristate_buffer A27(.in(out27), .oe(read_froma[27]), .out(data_readRegA));
	tristate_buffer A28(.in(out28), .oe(read_froma[28]), .out(data_readRegA));
	tristate_buffer A29(.in(out29), .oe(read_froma[29]), .out(data_readRegA));
	tristate_buffer A30(.in(out30), .oe(read_froma[30]), .out(data_readRegA));
	tristate_buffer A31(.in(out31), .oe(read_froma[31]), .out(data_readRegA));

	tristate_buffer B0(.in(out0), .oe(read_fromb[0]), .out(data_readRegB));
	tristate_buffer B1(.in(out1), .oe(read_fromb[1]), .out(data_readRegB));
	tristate_buffer B2(.in(out2), .oe(read_fromb[2]), .out(data_readRegB));
	tristate_buffer B3(.in(out3), .oe(read_fromb[3]), .out(data_readRegB));
	tristate_buffer B4(.in(out4), .oe(read_fromb[4]), .out(data_readRegB));
	tristate_buffer B5(.in(out5), .oe(read_fromb[5]), .out(data_readRegB));
	tristate_buffer B6(.in(out6), .oe(read_fromb[6]), .out(data_readRegB));
	tristate_buffer B7(.in(out7), .oe(read_fromb[7]), .out(data_readRegB));
	tristate_buffer B8(.in(out8), .oe(read_fromb[8]), .out(data_readRegB));
	tristate_buffer B9(.in(out9), .oe(read_fromb[9]), .out(data_readRegB));
	tristate_buffer B10(.in(out10), .oe(read_fromb[10]), .out(data_readRegB));
	tristate_buffer B11(.in(out11), .oe(read_fromb[11]), .out(data_readRegB));
	tristate_buffer B12(.in(out12), .oe(read_fromb[12]), .out(data_readRegB));
	tristate_buffer B13(.in(out13), .oe(read_fromb[13]), .out(data_readRegB));
	tristate_buffer B14(.in(out14), .oe(read_fromb[14]), .out(data_readRegB));
	tristate_buffer B15(.in(out15), .oe(read_fromb[15]), .out(data_readRegB));
	tristate_buffer B16(.in(out16), .oe(read_fromb[16]), .out(data_readRegB));
	tristate_buffer B17(.in(out17), .oe(read_fromb[17]), .out(data_readRegB));
	tristate_buffer B18(.in(out18), .oe(read_fromb[18]), .out(data_readRegB));
	tristate_buffer B19(.in(out19), .oe(read_fromb[19]), .out(data_readRegB));
	tristate_buffer B20(.in(out20), .oe(read_fromb[20]), .out(data_readRegB));
	tristate_buffer B21(.in(out21), .oe(read_fromb[21]), .out(data_readRegB));
	tristate_buffer B22(.in(out22), .oe(read_fromb[22]), .out(data_readRegB));
	tristate_buffer B23(.in(out23), .oe(read_fromb[23]), .out(data_readRegB));
	tristate_buffer B24(.in(out24), .oe(read_fromb[24]), .out(data_readRegB));
	tristate_buffer B25(.in(out25), .oe(read_fromb[25]), .out(data_readRegB));
	tristate_buffer B26(.in(out26), .oe(read_fromb[26]), .out(data_readRegB));
	tristate_buffer B27(.in(out27), .oe(read_fromb[27]), .out(data_readRegB));
	tristate_buffer B28(.in(out28), .oe(read_fromb[28]), .out(data_readRegB));
	tristate_buffer B29(.in(out29), .oe(read_fromb[29]), .out(data_readRegB));
	tristate_buffer B30(.in(out30), .oe(read_fromb[30]), .out(data_readRegB));
	tristate_buffer B31(.in(out31), .oe(read_fromb[31]), .out(data_readRegB));

endmodule
