`timescale 1ns / 1ps
/**
 *
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that serves as the header file of the processor, which also holds the
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 *
 * Each imem and dmem modules will take 12-bit
 * memAddres and will allow for storing of 32-bit values at each memAddr.
 * Each memory module should receive a single clock.
 *
 **/

module Wrapper (
    input CLK100MHZ,
    input BTNU,
    input [15:0] SW,
    input  mux_out,
    output reg[3:0] mux_select,
    output reg [15:0] LED);
   
   


    //wrapper 
    wire clock, locked, mwe_wire, rmwe;
    wire clock_reset = BTNU;
    reg[31:0] CPU_clock_counter;
    //assign reset = BTNU;
    reg reset;
    reg mwe;
    wire[4:0] rd, rs1, rs2;
    reg[31:0] memDataIn;
    reg[8:0] memAddr; 
    wire[31:0] memDataOut, instAddr, rData, instData, regA, regB, memDataIn_wire;
    wire[8:0] memAddr_wire;
    

    //clock
    clk_wiz_1 pll(.clk_out1(clock), .reset(clock_reset), .locked(locked), .clk_in1(CLK100MHZ)); //5 mhz 

    //Go code begins here

    //Reg declarations
    reg should_read;
    reg should_write;
    reg should_reset_CPU_1;
    reg should_reset_CPU_2;
    reg should_operate_CPU;
    reg transition;
    wire data_out;
    reg analyze_player; //1 for analyzing player move, 0 for computer 
    wire[3:0] computer_move;
    reg restart;
    reg check_computer_move;
    reg write_computer_move;
    reg write_computer_move_transition;
    reg store_comp_move_in_boardArr;
    reg increment_lfsr;
    reg[31:0] deadlock_counter;
    reg should_store_mode;
    wire[3:0] computer_pass;
    reg should_end_game;
    wire player_winning;
    reg should_flicker_LED;
    reg[31:0] flicker_count;

    initial begin
        
        reset = 1'b1;
        memAddr[8:0] = 9'b0;
        mux_select = 4'b0;
        mwe = 1'b0;
        LED = 16'b0; //16
        should_read = 1'b0;
        should_write = 1'b0;
        transition = 1'b0;
        CPU_clock_counter = 32'd0;
        analyze_player = 1'b0;
        write_computer_move = 1'b0;
        check_computer_move = 1'b0;
        store_comp_move_in_boardArr = 1'b0;
        restart = 1'b0;
        should_reset_CPU_2 = 1'b0;
        increment_lfsr = 1'b0;
        deadlock_counter = 32'd0;
        should_store_mode = 1'b0;
        should_end_game = 1'b0;
        should_flicker_LED = 1'b0;
        
        //debug
    end

    //
    reg[4:0] index;
    always @(negedge clock) begin
 //---------------------------------------------------------- RESTART OPERATION --------------------------------------------------------------------------------- //
        if (SW[0] == 1 || restart == 1'b1 || SW[1] == 1) begin 
            //init values
            should_read <= 1'b0;
            mux_select <= 4'b0;
            mwe <= 1'b1;
            should_write <= 1'b0;
            transition <= 1'b0;
            CPU_clock_counter <= 32'd0;
            restart <= 1'b0;
            check_computer_move <= 1'b0;
            store_comp_move_in_boardArr <= 1'b0;
            increment_lfsr <= 1'b0;
            memAddr <= 9'd69;
            reset <= 1'b1;
            flicker_count <= 32'd0;

            if (SW[0] == 1) begin // if new piece
                analyze_player <= 1'b1;
                memDataIn <= 32'd1;
                should_end_game <= 1'b0;
                should_store_mode <= 1'b1;
            end
            else if (SW[1] == 1) begin // 1/8 chance of computer passing
                if (computer_pass == 4'd5 || computer_pass == 4'd8) begin
                    should_end_game <= 1'b1;
                    should_store_mode <= 1'b0;
                end
                else begin
                    analyze_player <= 1'b1;
                    memDataIn <= 32'd1;
                    should_end_game <= 1'b0;
                    should_store_mode <= 1'b1;
                end
            end

            else if (analyze_player == 1'b1) begin //if restart asserted and was in player mode
                analyze_player <= 1'b0;
                memDataIn <= 32'd0;
                should_end_game <= 1'b0;
                should_store_mode <= 1'b1;
            end
            else begin  //if restart asserted and was in computer mode
                analyze_player <= 1'b1;
                memDataIn <= 32'd1;
                should_end_game <= 1'b0;
                should_store_mode <= 1'b1;
            end
        end
// ------------------------------------------------------- STORE PLAYER OR COMPUTER MODE -------------------------------------------------------------- //

        if (should_store_mode == 1'b1) begin
            mwe <= 1'b0;
            should_store_mode <= 1'b0;
            memAddr <= 9'd0;
            /*
            if (analyze_player == 1'b1) begin
                should_read <= 1'b1;
                should_reset_CPU_1 <= 1'b0;
            end
            else begin
                should_read <= 1'b0;
                should_reset_CPU_1 <= 1'b1; 
            end
            */
            
            should_read <= 1'b1;
        end

 //-------------------------------------------------------------- READ HALL EFFECT ------------------------------------------------------------------- //
        else if (should_read == 1'b1) begin  
            if (memAddr[4:0] == 5'b10000) begin //if memAddr is 16 (the last place on the board), we are done
                should_read <= 1'b0;
                should_reset_CPU_1 <= 1'b1;
                mwe <= 1'b0;
                mux_select <= 4'b0;
                memAddr[4:0] <= 5'b0;
            end   
            else begin
                /*
                memAddr[4:0] <= memAddr[4:0] + 1; 
                mwe <= 1'b1; 
                //debug
                
                if (memAddr == 9'd10 || memAddr == 9'd11 || memAddr == 9'd13) begin
                    memDataIn <= 32'd1;
                end
                else begin
                    memDataIn <= 32'd0;
                end
                */
                

                memAddr[4:0] <= memAddr[4:0] + 1; 
                mwe <= 1'b1; 

                //Write data to RAM
                if (mux_out == 0) begin
                    memDataIn <= 32'd1;  
                end
                else begin
                    memDataIn <= 32'd0;  
                end
                
                

                mux_select <= mux_select + 1;
            end  
        end
 //------------------------------------------------------------ RESET CPU CYCLE 1 -------------------------------------------------------------------- //
 
        else if (should_reset_CPU_1 == 1'b1) begin 
            reset <= 1'b1;
            should_reset_CPU_1 <= 1'b0;
            should_reset_CPU_2 <= 1'b1;
        end
// ------------------------------------------------------------ RESET CPU CYCLE 2 -------------------------------------------------------------------//
        else if (should_reset_CPU_2 == 1'b1) begin 
            should_reset_CPU_2 <= 1'b0;
            should_operate_CPU <= 1'b1;
        end
// --------------------------------------------------------------- OPERATE CPU ------------------------------------------------------------------------//
        else if (should_operate_CPU == 1'b1) begin 
            reset <= 1'b0;
        
            if (CPU_clock_counter == 32'd10000000) begin // if CPU done; change value depending on number of clock cycles needed for the algorithm
                should_operate_CPU <= 1'b0;
                CPU_clock_counter <= 32'd0;
                should_write <= 1'b1;
                transition <= 1'b1;
            end
            
            
            else begin 
                CPU_clock_counter <= CPU_clock_counter + 1;
           end
           //LED[regout2[15:0]] <= 1'b1;
        end
// --------------------------------------------------------------- WRITE NEW INFO TO LED'S ----------------------------------------------------------//
        else if (should_write == 1'b1) begin  

            if (transition == 1'b1 || write_computer_move_transition == 1'b1) begin
                memAddr[8:0] <= 9'd1;  
                mwe <= 1'b0;
                index <= 0;
                transition <= 1'b0;
                write_computer_move_transition <= 1'b0;
                reset <= 1'b1;
            end
            else begin
                
                if (index == 16) begin // If writing LEDs complete
                    if (analyze_player == 1'b1) begin // if in player mode, transition to computer mode and restart
                        memAddr <= 9'd65;
                        should_write <= 1'b0;
                        mwe <= 1'b1;
                        restart <= 1'b1;
                        
                        if (deadlock_counter >= 32'd18) begin
                            memDataIn <= 32'd0;
                            deadlock_counter <= 32'd0;
                        end
                        else begin
                            memDataIn <= {28'b0, computer_move[3:0]};
                        end 
                    end
                    else if (write_computer_move == 1'b1) begin // If was writing computer move to LED, we are now finished
                        should_write <= 1'b0;
                        write_computer_move <= 1'b0;
                        analyze_player <= 1'b0;
                    end
                    else begin // If was in first part of computer mode, check move validity
                        check_computer_move <= 1'b1;
                        memAddr <= 9'd66; 
                        should_write <= 1'b0;
                        mwe <= 1'b0;
                    end
                end
                else begin //If not done, read RAM and set LED
                    if (memDataOut == 0) begin
                        LED[index] <= 1'b0; 
                    end
                    else if (memDataOut == 2) begin 
                        LED[index] <= 1'b1; //debug
                    end
                    else if (memDataOut == 1) begin
                        LED[index] <= 1'b0;
                    end
                    index <= index + 1;
                    memAddr <= memAddr + 1;
                end
            end
        end
 // ---------------------------------------------------------- CHECK COMPUTER MOVE VALIDITY -----------------------------------------------------//
        else if (check_computer_move == 1'b1) begin
            if (memDataOut == 32'd1) begin 
                restart <= 1'b1;
                check_computer_move <= 1'b0;
                analyze_player <= 1'b0;
                increment_lfsr <= 1'b1;
                deadlock_counter <= deadlock_counter + 32'd1;
            end
            else begin //move is valid
                check_computer_move <= 1'b0;
                memAddr <= 9'd65;
                mwe <= 1'b0;
                store_comp_move_in_boardArr <= 1'b1;
            end
        end
// ------------------------------------------------------------ STORE COMPUTER MOVE TO RAM (IF VALID) -----------------------------------------//
        else if (store_comp_move_in_boardArr == 1'b1) begin
            store_comp_move_in_boardArr <= 1'b0;
            memAddr <= memDataOut[8:0] + 9'd1; 
            memDataIn <= 32'd2; 
            mwe <= 1'b1; 
            write_computer_move <= 1'b1;
            write_computer_move_transition <= 1'b1;
            should_write <= 1'b1;
        end
    
// ------------------------------------------------------- END GAME -----------------------------------------------------------//
        else if (should_end_game == 1'b1) begin
            should_end_game <= 1'b0;
            if (player_winning == 1'b1) begin
                should_flicker_LED <= 1'b1;
            end
            else begin
                should_flicker_LED <= 1'b0;
            end
            LED <= 16'b0;
        end
// ------------------------------------------------------- FLICKER LED ---------------------------------------------------------//
        else if (should_flicker_LED == 1'b1) begin
            if (flicker_count == 32'd5000000) begin
                flicker_count <= 32'd0;
                if (LED == 16'b1111111111111111) begin
                    LED <= 16'b0;
                end
                else begin
                    LED <= 16'b1111111111111111;
                end
            end
            else begin
                flicker_count <= flicker_count + 32'd1;
            end
        end
    end
    
    // ADD MEMORY FILE HERE
    localparam INSTR_FILE = "C:\\Users\\sgh24\\Documents\\test_pre";

    // Main Processing Unit
    processor CPU(.clock(clock), .reset(reset),
    
    // ROM
    .address_imem(instAddr), .q_imem(instData),
    
    // Regfile
    .ctrl_writeEnable(rmwe),     .ctrl_writeReg(rd),
    .ctrl_readRegA(rs1),     .ctrl_readRegB(rs2),
    .data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
    
    // RAM
    .wren(mwe_wire), .address_dmem(memAddr_wire),
    .data(memDataIn_wire), .q_dmem(memDataOut));


    // Instruction Memory (ROM)

    ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
    InstMem(.clk(clock),
        .addr(instAddr[11:0]),
        .dataOut(instData));


    // Register File

    regfile RegisterFile(.clock(clock),
        .ctrl_writeEnable(rmwe), .ctrl_reset(reset),
        .ctrl_writeReg(rd),
        .ctrl_readRegA(rs1), .ctrl_readRegB(rs2),
        .data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB));


    wire[31:0] actual_memDataIn = should_operate_CPU ?  memDataIn_wire : memDataIn;
    wire actual_mwe = should_operate_CPU ? mwe_wire : mwe;
    wire[8:0] actual_memAddr = should_operate_CPU ? memAddr_wire : memAddr;
    
    // Processor Memory (RAM)
    RAM ProcMem(.clk(clock),
    .wEn(actual_mwe),
    .addr(actual_memAddr[8:0]),
    .dataIn(actual_memDataIn),
    .dataOut(memDataOut),
    .protect_comp_move(should_read),
    .player_winning(player_winning)); 

    //lfsr
    lfsr computer_move_gen(.CLK(clock), .RST(BTNU), .Q(computer_move), .increment_lfsr(increment_lfsr));
    lfsr computer_pass_lfsr(.CLK(clock), .RST(BTNU), .Q(computer_pass), .increment_lfsr(1'b1));



endmodule
