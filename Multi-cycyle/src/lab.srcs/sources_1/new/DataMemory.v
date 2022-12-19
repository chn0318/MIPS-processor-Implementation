`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/17 09:05:23
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
    input Clk,
    input [31:0] address,
    input [31:0] writeData,
    input memWrite,
    input memRead,
    output [31:0] readData
    );
    
    reg [7:0] memFile[0:31];
    reg [31:0] readData;
    
    always @ (address or memRead)
    begin
        if (memRead)
            readData = {memFile[address+3], memFile[address+2], memFile[address+1], memFile[address]};
        else
            readData = 0;
    end        
    
    always @ (negedge Clk)
    begin
        if (memWrite)
        begin
            memFile[address] <= writeData[7:0];
            memFile[address+1] <= writeData[15:8];
            memFile[address+2] <= writeData[23:16];
            memFile[address+3] <= writeData[31:24];
        end
    end
        
endmodule
