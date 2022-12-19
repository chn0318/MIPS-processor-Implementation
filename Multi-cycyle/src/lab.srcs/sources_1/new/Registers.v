`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/17 08:07:54
// Design Name: 
// Module Name: Registers
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


module Registers(
    input Clk,
    input [25:21] readReg1,
    input [20:16] readReg2,
    input [4:0] writeReg,
    input [31:0] writeData,
    input regWrite,
    input reset,
    output [31:0] readData1,
    output [31:0] readData2
    );
    
    reg [31:0] readData1;
    reg [31:0] readData2;
    
    reg [31:0] regFile[0:31];
    always @ (readReg1 or readReg2)
    begin
        if (readReg1)
            readData1 = regFile[readReg1];
        else 
            readData1 = 0;
        if (readReg2)
            readData2 = regFile[readReg2];
        else 
            readData2 = 0;
    end
    
    always @ (negedge Clk)
    begin
        if (regWrite)
            regFile[writeReg] <= writeData;
    end
    
    reg [5:0] cnt;
    always @ (reset)
    begin
        for (cnt = 0; cnt < 32; cnt=cnt+1)
            regFile[cnt] <= 0;
    end
        
endmodule
