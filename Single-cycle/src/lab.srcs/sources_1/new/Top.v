`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 11:33:49
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(
    input Clk,
    input reset
    );
    
    reg [31:0] PC;
    wire [31:0] INST;
    wire REG_DST, JUMP, BRANCH, MEM_READ, MEM_TO_REG, MEM_WRITE, ALU_SRC, REG_WRITE;
    wire [1:0] ALU_OP;      
    InstMemory instMem(.address(PC), .instruction(INST));
    
    Ctr mainCtr(.opCode(INST[31:26]), 
                 .regDst(REG_DST),
                 .jump(JUMP),
                 .branch(BRANCH),
                 .memRead(MEM_READ),
                 .memToReg(MEM_TO_REG),
                 .aluOp(ALU_OP),
                 .memWrite(MEM_WRITE), 
                 .aluSrc(ALU_SRC), 
                 .regWrite(REG_WRITE));

    
    wire [4:0] WRITE_REG;
    wire [31:0] READ_DATA_1, READ_DATA_2, REG_WRITE_DATA;
    Mux5 writeRegMux(.sel(REG_DST), .in1(INST[15:11]), .in0(INST[20:16]), .out(WRITE_REG));
    Registers regs(.Clk(Clk),
                   .readReg1(INST[25:21]), 
                   .readReg2(INST[20:16]), 
                   .writeReg(WRITE_REG),
                   .writeData(REG_WRITE_DATA) , 
                   .reset(reset), 
                   .regWrite(REG_WRITE),
                   .readData1(READ_DATA_1), 
                   .readData2(READ_DATA_2));

    wire [31:0] IMM_SEXT, ALU_SRC_B, ALU_RESULT;
    wire [3:0] ALU_CTR_OUT;
    wire ZERO;
    signext Signext(.inst(INST[15:0]), .data(IMM_SEXT));
    
    ALUctr aluCtr(.Funct(INST[5:0]), .ALUOp(ALU_OP), .aluCtrOut(ALU_CTR_OUT));
    
    Mux32 aluSrcMux(.sel(ALU_SRC), .in1(IMM_SEXT), .in0(READ_DATA_2),.out(ALU_SRC_B));
  
    ALU alu(.input1(READ_DATA_1), 
            .input2(ALU_SRC_B), 
            .aluCtr(ALU_CTR_OUT),
            .zero(ZERO), 
            .aluRes(ALU_RESULT));
    

    wire [31:0] MEM_READ_DATA;
    datamemory dataMem(.Clk(Clk), 
                       .address(ALU_RESULT),
                       .writeData(READ_DATA_2),
                       .memWrite(MEM_WRITE), 
                       .memRead(MEM_READ), 
                       .readData(MEM_READ_DATA));
   
    Mux32 regWriteMux(.sel(MEM_TO_REG), .in1(MEM_READ_DATA), .in0(ALU_RESULT), .out(REG_WRITE_DATA)); 
    wire [31:0] PC_PLUS_4, BRANCH_ADDR, SEL_BRANCH_ADDR, JUMP_ADDR, NEXT_PC, SEXT_SHIFT;
    assign PC_PLUS_4 = PC + 4;
    assign JUMP_ADDR = {PC_PLUS_4[31:28], INST[25:0] << 2};
    assign SEXT_SHIFT = IMM_SEXT << 2;
    assign BRANCH_ADDR = PC_PLUS_4 + SEXT_SHIFT;
  
  
    Mux32 branchMux(.sel(BRANCH & ZERO), .in1(BRANCH_ADDR), .in0(PC_PLUS_4), .out(SEL_BRANCH_ADDR));
    Mux32 jumpMux(.sel(JUMP), .in1(JUMP_ADDR), .in0(SEL_BRANCH_ADDR), .out(NEXT_PC));

    always @ (posedge Clk)
    begin
        if (reset)
            PC <= 0;
        else
            PC <= NEXT_PC;
    end
    
endmodule