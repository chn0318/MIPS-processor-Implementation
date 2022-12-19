`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/30 09:03:40
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
    input clk,
    input reset
    );
    
    // Pipeline stage registers
    // IF/ID
    reg [31:0] IFID_pcPlus4, IFID_instr;
    wire [4:0] IFID_INSTRS = IFID_instr[25:21], IFID_INSTRT = IFID_instr[20:16],
        IFID_INSTRD = IFID_instr[15:11];
    wire BRANCH;
    
    // ID/EX
    reg [31:0] IDEX_readData1, IDEX_readData2, IDEX_immSext;
    reg [4:0] IDEX_instrRs, IDEX_instrRt, IDEX_instrRd;
    reg [8:0] IDEX_ctrl;
    wire [1:0] IDEX_ALUOP = IDEX_ctrl[7:6];
    wire IDEX_REGDST = IDEX_ctrl[8], IDEX_ALUSRC= IDEX_ctrl[5], 
        IDEX_BRANCH = IDEX_ctrl[4], IDEX_MEMREAD = IDEX_ctrl[3], 
        IDEX_MEMWRITE = IDEX_ctrl[2], IDEX_REGWRITE = IDEX_ctrl[1],
        IDEX_MEMTOREG = IDEX_ctrl[0];
        
    // EX/EM
    reg [31:0] EXMEM_aluRes, EXMEM_writeData;
    reg [4:0] EXMEM_dstReg;
    reg [4:0] EXMEM_ctrl;
    reg EXMEM_zero;
    wire EXMEM_BRANCH = EXMEM_ctrl[4], EXMEM_MEMREAD = EXMEM_ctrl[3],
        EXMEM_MEMWRITE = EXMEM_ctrl[2], EXMEM_REGWRITE = EXMEM_ctrl[1],
        EXMEM_MEMTOREG = EXMEM_ctrl[0];
        
    // MEM/WB
    reg [31:0] MEMWB_readData, MEMWB_aluRes;
    reg [4:0] MEMWB_dstReg;
    reg [1:0] MEMWB_ctrl;
    wire MEMWB_REGWRITE = MEMWB_ctrl[1], MEMWB_MEMTOREG = MEMWB_ctrl[0];
    
    // Hazard detection
    wire STALL = IDEX_MEMREAD & 
        (IDEX_instrRt == IFID_INSTRS | IDEX_instrRt == IFID_INSTRT);
    
    // Stage settings
    // Instruction Fetch Stage
    reg [31:0] PC;
    wire [31:0] PC_PLUS_4, BRANCH_ADDR, NEXT_PC, IF_INSTR;
    assign PC_PLUS_4 = PC + 4;
    Mux32 nextPCMux(.in0(PC_PLUS_4), .in1(BRANCH_ADDR), .out(NEXT_PC),
        .sel(BRANCH));
    InstrMemory instrMem(.address(PC), .instr(IF_INSTR));
    
    always @ (posedge clk)
    begin
        if (!STALL)
        begin
            IFID_pcPlus4 <= PC_PLUS_4;
            IFID_instr <= IF_INSTR;
            PC <= NEXT_PC;
        end
        if (BRANCH)
            IFID_instr <= 0; // flush
    end
    
    // Decode Stage
    wire [8:0] CTRL_OUT;
    Ctrl mainCtrl(.opCode(IFID_instr[31:26]), .regDst(CTRL_OUT[8]), 
        .aluOp(CTRL_OUT[7:6]), .aluSrc(CTRL_OUT[5]), .branch(CTRL_OUT[4]),
        .memRead(CTRL_OUT[3]), .memWrite(CTRL_OUT[2]), .regWrite(CTRL_OUT[1]),
        .memToReg(CTRL_OUT[0]));
    
    wire [31:0] READ_DATA_1, READ_DATA_2, REG_WRITE_DATA;
    Registers regs(.Clk(clk), .readReg1(IFID_INSTRS), .readReg2(IFID_INSTRT), 
        .writeReg(MEMWB_dstReg), .writeData(REG_WRITE_DATA), 
        .regWrite(MEMWB_REGWRITE), .reset(reset), .readData1(READ_DATA_1), 
        .readData2(READ_DATA_2));
    
    wire [31:0] IMM_SEXT;
    Signext sext(.in(IFID_instr[15:0]), .out(IMM_SEXT));
    wire [31:0] IMM_SEXT_SHIFT = IMM_SEXT << 2;
    assign BRANCH_ADDR = IMM_SEXT_SHIFT + IFID_pcPlus4;
    assign BRANCH = (READ_DATA_1 == READ_DATA_2) & CTRL_OUT[4];
    
    always @ (posedge clk)
    begin
        IDEX_ctrl <= STALL ? 0 : CTRL_OUT;
        IDEX_readData1 <= READ_DATA_1;
        IDEX_readData2 <= READ_DATA_2;
        IDEX_immSext <= IMM_SEXT;
        IDEX_instrRs <= IFID_INSTRS;
        IDEX_instrRt <= IFID_INSTRT;
        IDEX_instrRd <= IFID_INSTRD;
    end
    
    // Forwarding Unit
    wire FWD_EX_A = 
        EXMEM_REGWRITE & EXMEM_dstReg != 0 & EXMEM_dstReg == IDEX_instrRs;
    wire FWD_EX_B = 
        EXMEM_REGWRITE & EXMEM_dstReg != 0 & EXMEM_dstReg == IDEX_instrRt;
    wire FWD_MEM_A = 
        MEMWB_REGWRITE & MEMWB_dstReg != 0 & 
        !(EXMEM_REGWRITE & EXMEM_dstReg != 0 & EXMEM_dstReg != IDEX_instrRs) &
        MEMWB_dstReg == IDEX_instrRs;
    wire FWD_MEM_B = 
        MEMWB_REGWRITE & MEMWB_dstReg != 0 & 
        !(EXMEM_REGWRITE & EXMEM_dstReg != 0 & EXMEM_dstReg != IDEX_instrRt) &
        MEMWB_dstReg == IDEX_instrRt;
        
    // Execution Stage
    wire [31:0] ALU_SRC_A = FWD_EX_A ? EXMEM_aluRes : 
        FWD_MEM_A ? REG_WRITE_DATA : IDEX_readData1;
    wire [31:0] ALU_SRC_B = IDEX_ALUSRC ? IDEX_immSext : FWD_EX_B ? EXMEM_aluRes :
        FWD_EX_B ? EXMEM_aluRes : FWD_MEM_B ? REG_WRITE_DATA : IDEX_readData2;
    wire [31:0] MEM_WRITE_DATA = FWD_EX_B ? EXMEM_aluRes :
        FWD_EX_B ? EXMEM_aluRes : FWD_MEM_B ? REG_WRITE_DATA : IDEX_readData2;
         
    wire [3:0] ALU_CTRL_OUT;
    ALUCtr aluCtr(.funct(IDEX_immSext[5:0]), .aluOp(IDEX_ALUOP), 
        .aluCtrOut(ALU_CTRL_OUT));
    
    wire [31:0] ALU_RES;
    wire ZERO;
    Alu alu(.in1(ALU_SRC_A), .in2(ALU_SRC_B), .aluCtr(ALU_CTRL_OUT), .zero(ZERO),
        .aluRes(ALU_RES));
        
    wire [4:0] DST_REG;
    Mux5 dstRegMux(.in0(IDEX_instrRt), .in1(IDEX_instrRd), .sel(IDEX_REGDST),
        .out(DST_REG));
        
    always @ (posedge clk)
    begin
        EXMEM_ctrl <= IDEX_ctrl[4:0];
        EXMEM_zero <= ZERO;
        EXMEM_aluRes <= ALU_RES;
        EXMEM_writeData <= MEM_WRITE_DATA;
        EXMEM_dstReg <= DST_REG;
    end
    
    // Memory Stage
    wire [31:0] MEM_READ_DATA;
    DataMemory dataMem(.Clk(clk), .address(EXMEM_aluRes), 
        .writeData(EXMEM_writeData), .memRead(EXMEM_MEMREAD), 
        .memWrite(EXMEM_MEMWRITE), .readData(MEM_READ_DATA));
        
    always @ (posedge clk)
    begin
        MEMWB_ctrl <= EXMEM_ctrl[1:0];
        MEMWB_readData <= MEM_READ_DATA;
        MEMWB_aluRes <= EXMEM_aluRes;
        MEMWB_dstReg <= EXMEM_dstReg;
    end
    
    // Write Back Stage
    Mux32 writeDataMux(.in1(MEMWB_readData), .in0(MEMWB_aluRes), 
        .sel(MEMWB_MEMTOREG), .out(REG_WRITE_DATA));
        
    always @ (reset)
    begin
        PC = 0;
        IFID_pcPlus4 = 0;
        IFID_instr = 0;
        IDEX_instrRs = 0;
        IDEX_readData1 = 0;
        IDEX_readData2 = 0;
        IDEX_immSext = 0;
        IDEX_instrRt = 0;
        IDEX_instrRd = 0;
        IDEX_ctrl = 0;
        EXMEM_aluRes = 0;
        EXMEM_writeData = 0;
        EXMEM_dstReg = 0;
        EXMEM_ctrl = 0;
        EXMEM_zero = 0;
        MEMWB_readData = 0;
        MEMWB_aluRes = 0;
        MEMWB_dstReg = 0;
        MEMWB_ctrl = 0;
    end
    
endmodule
