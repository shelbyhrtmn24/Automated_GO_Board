/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem - ROM
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem - RAM
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */

    //------------------------------------------ FETCH STAGE ----------------------------------------------
    wire [31:0] PC, next_PC, PC_plus;
    wire[31:0] FD_PC_out, FD_IR_out;
    wire PC_ovf;
    wire hazard_stall, multdiv_stall, branch_jump_taken;

    single_reg PCreg(.data_writeReg(next_PC), .data_readReg(PC), .write_to(~(multdiv_stall | hazard_stall)), .ctrl_reset(reset), .clk(~clock));
    full_cla PCadder(.A(PC), .B(32'b1), .data_result(PC_plus), .c_in(1'b0), .c_out(PC_ovf));

    assign address_imem = PC;

    single_reg FD_reg_pc(.data_writeReg(branch_jump_taken ? PC : PC_plus), .data_readReg(FD_PC_out), .write_to(~(multdiv_stall | hazard_stall)), 
        .ctrl_reset(reset), .clk(~clock));
    single_reg FD_reg_ir(.data_writeReg(branch_jump_taken ? 32'b0 : q_imem), .data_readReg(FD_IR_out), .write_to(~(multdiv_stall | hazard_stall)), 
        .ctrl_reset(reset), .clk(~clock));

    //------------------------------------------ DECODE STAGE --------------------------------------------
    wire[31:0] rs_out, rt_out, DX_PC_out, DX_IR_out, DX_IR_in, DX_A_out, DX_B_out;
    wire[4:0] rt_address, rs_address;
    wire r_type, i_type, bex, j_ii, double_mult, double_div;
    op_decoder decoder(.opcode(FD_IR_out[31:27]), .r_type(r_type), .i_type(i_type), .bex(bex), .j_ii(j_ii));

    assign rt_address = r_type ? FD_IR_out[16:12] : FD_IR_out[26:22];

    assign rs_address = j_ii ? FD_IR_out[26:22] : FD_IR_out[21:17];
    assign ctrl_readRegA = bex ? 5'd30 : rs_address;
    assign ctrl_readRegB = rt_address;
    assign DX_IR_in = (branch_jump_taken | hazard_stall) ? 32'b0 : FD_IR_out;

    single_reg DX_reg_PC(.data_writeReg(FD_PC_out), .data_readReg(DX_PC_out), .write_to(~multdiv_stall), .ctrl_reset(reset), .clk(~clock));
    single_reg DX_reg_A(.data_writeReg(data_readRegA), .data_readReg(DX_A_out), .write_to(~multdiv_stall), .ctrl_reset(reset), .clk(~clock));
    single_reg DX_reg_B(.data_writeReg(data_readRegB), .data_readReg(DX_B_out), .write_to(~multdiv_stall), .ctrl_reset(reset), .clk(~clock));
    single_reg DX_reg_IR(.data_writeReg(DX_IR_in), .data_readReg(DX_IR_out), .write_to(~multdiv_stall), .ctrl_reset(reset), .clk(~clock));

    //----------------------------------------- EXECUTE STAGE ----------------------------------------------
    wire[31:0] XM_O_temp, XM_O_in, XM_O_muldiv, XM_O_out, MW_O_in, XM_B_out, XM_IR_out, XM_IR_in, XM_IR_muldiv, data_operandB, post_bypass_B, data_operandA, 
        sign_extended_immed, ALU_out;
    wire[4:0] ALU_opcode, temp_AlU_opcode, global_opcode;
    wire[1:0] bypass_a_select, bypass_b_select;
    wire i_not_branch, dx_is_branch, dx_is_jal, dx_is_r_type;
    wire ALU_neq, ALU_lt, ALU_ovf;

    assign sign_extended_immed[16:0] = DX_IR_out[16:0];
    assign sign_extended_immed[31:17] = DX_IR_out[16] ? 15'b111111111111111 : 15'b0;    // Don't judge my implementation pls
    assign global_opcode = DX_IR_out[31:27];

    assign dx_is_r_type = !global_opcode[4] & !global_opcode[3] & !global_opcode[2] & !global_opcode[1] & !global_opcode[0];
    assign i_not_branch = (!global_opcode[4] & !global_opcode[3] & global_opcode[2] & global_opcode[0]) | (!global_opcode[4] & global_opcode[3] & !global_opcode[2] & !global_opcode[1] & !global_opcode[0]);
    assign dx_is_branch = !global_opcode[4] & !global_opcode[3] & global_opcode[1] & !global_opcode[0];
    assign dx_is_jal = !global_opcode[4] & !global_opcode[3] & !global_opcode[2] & global_opcode[1] & global_opcode[0];

    four_input_mux bypass_a(.select(bypass_a_select), .in0(DX_A_out), .in1(MW_O_in), .in2(data_writeReg), .in3(32'b0), .mux_out(data_operandA));
    four_input_mux bypass_b(.select(bypass_b_select), .in0(DX_B_out), .in1(MW_O_in), .in2(data_writeReg), .in3(32'b0), .mux_out(post_bypass_B));
    assign data_operandB = i_not_branch ? sign_extended_immed : post_bypass_B;

    // If instruction is addi, sw, or lw, then AlU_opcode is 00000 for add
    assign temp_AlU_opcode = dx_is_branch ? 5'b1 : DX_IR_out[6:2];
    assign ALU_opcode = i_not_branch ? 5'b0 : temp_AlU_opcode;

    alu full_alu(.data_operandA(data_operandA), .data_operandB(data_operandB), .ctrl_ALUopcode(ALU_opcode), .ctrl_shiftamt(DX_IR_out[11:7]), 
        .data_result(ALU_out), .isNotEqual(ALU_neq), .isLessThan(ALU_lt), .overflow(ALU_ovf));

    // Multdiv 
    wire mult_op, div_op, ctrl_mult, ctrl_div;
    wire mult_running, div_running;
    wire multdiv_RDY, multdiv_exception;
    wire [31:0] multdiv_IR_out, multdiv_A_out, multdiv_B_out, multdiv_result;

    assign mult_op = dx_is_r_type & (!DX_IR_out[6] & !DX_IR_out[5] & DX_IR_out[4] & DX_IR_out[3] & !DX_IR_out[2]);
    assign div_op = dx_is_r_type & (!DX_IR_out[6] & !DX_IR_out[5] & DX_IR_out[4] & DX_IR_out[3] & DX_IR_out[2]);

    multdiv_latch multdiv_input_latch(.in_a(data_operandA), .in_b(data_operandB), .multdiv_a(multdiv_A_out), .multdiv_b(multdiv_B_out), 
        .ctrl_mult(ctrl_mult), .ctrl_div(ctrl_div), .dx_ir(DX_IR_out), .multdiv_ir(multdiv_IR_out), .reset(reset),
        .result_RDY(multdiv_RDY), .mult_running(mult_running), .div_running(div_running), .clk(~clock), .mult_op(mult_op), .div_op(div_op));

    multdiv multdiv_unit(.data_operandA(multdiv_A_out), .data_operandB(multdiv_B_out), .ctrl_MULT(ctrl_mult), .ctrl_DIV(ctrl_div), 
        .clock(clock), .data_result(multdiv_result), .data_exception(multdiv_exception), .data_resultRDY(multdiv_RDY));     

    assign XM_O_temp = dx_is_jal ? DX_PC_out : ALU_out;
    assign XM_O_muldiv = ((mult_op & multdiv_RDY) | (div_op & multdiv_RDY)) ? multdiv_result : XM_O_temp;

    assign XM_IR_muldiv = (multdiv_RDY & (mult_op | div_op)) ? multdiv_IR_out : DX_IR_out;

    //Overflow 
    wire[31:0] XM_O_ovf;
    wire ovf;
    overflow_control ovf_unit(.global_opcode(global_opcode), .alu_opcode(DX_IR_out[6:2]), .alu_ovf(ALU_ovf), 
        .muldiv_ovf(multdiv_exception), .ovf(ovf), .xm_o_ovf(XM_O_ovf));

    assign XM_IR_in = ovf ? {XM_IR_muldiv[31:27], 5'd30, XM_IR_muldiv[21:0]} : XM_IR_muldiv;
    assign XM_O_in = ovf ? XM_O_ovf : XM_O_muldiv;
    
    single_reg XM_reg_O(.data_writeReg(XM_O_in), .data_readReg(XM_O_out), .write_to(1'b1), .ctrl_reset(reset), .clk(~clock));
    single_reg XM_reg_B(.data_writeReg(post_bypass_B), .data_readReg(XM_B_out), .write_to(1'b1), .ctrl_reset(reset), .clk(~clock));
    single_reg XM_reg_IR(.data_writeReg(XM_IR_in), .data_readReg(XM_IR_out), .write_to(1'b1), .ctrl_reset(reset), .clk(~clock));

    //------------------------------------------- MEMORY STAGE -------------------------------------------- 
    wire[31:0] MW_O_out, MW_D_in, MW_D_out, MW_IR_out, setx_target;
    wire xm_is_sw, xm_is_setx;
    wire wm_select;
    assign address_dmem = XM_O_out;
    assign xm_is_sw = !XM_IR_out[31] & !XM_IR_out[30] & XM_IR_out[29] & XM_IR_out[28] & XM_IR_out[27];
    assign data = wm_select ? data_writeReg : XM_B_out;
    assign wren = xm_is_sw;

    assign xm_is_setx = XM_IR_out[31] & !XM_IR_out[30] & XM_IR_out[29] & !XM_IR_out[28] & XM_IR_out[27];
    assign setx_target = {5'b0, XM_IR_out[26:0]};

    assign MW_O_in = xm_is_setx ? setx_target : XM_O_out;

    single_reg MW_reg_O(.data_writeReg(MW_O_in), .data_readReg(MW_O_out), .write_to(1'b1), .ctrl_reset(reset), .clk(~clock));
    single_reg MW_reg_D(.data_writeReg(q_dmem), .data_readReg(MW_D_out), .write_to(1'b1), .ctrl_reset(reset), .clk(~clock));
    single_reg MW_reg_IR(.data_writeReg(XM_IR_out), .data_readReg(MW_IR_out), .write_to(1'b1), .ctrl_reset(reset), .clk(~clock));

    //--------------------------------------- WRITEBACK STAGE --------------------------------------------- 
    wire mw_is_lw, mw_is_r_type, mw_is_addi, mw_is_jal, mw_is_setx;
    wire [4:0] writeReg_temp_addr_one;

    assign mw_is_lw = !MW_IR_out[31] & MW_IR_out[30] & !MW_IR_out[29] & !MW_IR_out[28] & !MW_IR_out[27];
    assign mw_is_r_type = !MW_IR_out[31] & !MW_IR_out[30] & !MW_IR_out[29] & !MW_IR_out[28] & !MW_IR_out[27];
    assign mw_is_addi = !MW_IR_out[31] & !MW_IR_out[30] & MW_IR_out[29] & !MW_IR_out[28] & MW_IR_out[27];
    assign mw_is_jal = !MW_IR_out[31] & !MW_IR_out[30] & !MW_IR_out[29] & MW_IR_out[28] & MW_IR_out[27];
    assign mw_is_setx = MW_IR_out[31] & !MW_IR_out[30] & MW_IR_out[29] & !MW_IR_out[28] & MW_IR_out[27];

    assign data_writeReg = mw_is_lw ? MW_D_out : MW_O_out;
    assign writeReg_temp_addr_one = mw_is_jal ? 5'd31 : MW_IR_out[26:22];
    assign ctrl_writeReg = mw_is_setx ? 5'd30 : writeReg_temp_addr_one;

    assign ctrl_writeEnable = mw_is_lw || mw_is_r_type || mw_is_addi || mw_is_jal || mw_is_setx;

    //Bypass Logic
    bypass_controls bypass_control_unit(.dx_ir(DX_IR_out), .xm_ir(XM_IR_out), .mw_ir(MW_IR_out), 
        .bypass_a_select(bypass_a_select), .bypass_b_select(bypass_b_select), .wm_select(wm_select));

    //Stall Logic - we'll see if we need to change what we pass in to find rd, rs, rt
    stall_controls stall_unit(.fd_ir(FD_IR_out), .dx_ir(DX_IR_out), .xm_ir(XM_IR_out), .mult_running(mult_running), 
        .div_running(div_running), .ctrl_mult(ctrl_mult), .ctrl_div(ctrl_div), .hazard_stall(hazard_stall), .multdiv_stall(multdiv_stall));


    //PC Controls - just input the lt signal straight from the ALU, PC controls module flips it
    wire [31:0] ctrl_PC;
    pc_controls pc_ctrl_unit(.DX_PC_out(DX_PC_out), .DX_IR_out(DX_IR_out), .DX_A_out(data_operandA), .immed(sign_extended_immed), .alult(ALU_lt), 
        .aluneq(ALU_neq), .ctrl_PC(ctrl_PC), .branch_jump_taken(branch_jump_taken));
    assign next_PC = branch_jump_taken ? ctrl_PC : PC_plus;

	/* END CODE */

endmodule
