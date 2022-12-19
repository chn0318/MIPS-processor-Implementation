`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/17 10:30:09
// Design Name: 
// Module Name: InstMemory
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


module InstrMemory(
    input [31:0] address,
    output [31:0] instr
    );
    
    reg [7:0] instrFile[0:63];
    
    assign instr = {instrFile[address+3], instrFile[address+2], 
        instrFile[address+1], instrFile[address]};
    
endmodule
