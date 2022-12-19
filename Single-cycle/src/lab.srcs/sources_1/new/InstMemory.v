`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/14 08:33:33
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
module InstMemory(
    input [31:0] address,
    output [31:0] instruction
    );
    
    reg [7:0] instrFile[0:63];
     initial begin              
    instrFile[0] = 8'b00000001;
    instrFile[1] = 8'b00000000;
    instrFile[2] = 8'b00000001;
    instrFile[3] = 8'b10001100;
    instrFile[4] = 8'b00000001;
    instrFile[5] = 8'b00000000;
    instrFile[6] = 8'b00000010;
    instrFile[7] = 8'b10001100;
    instrFile[8] = 8'b00100000;
    instrFile[9] = 8'b00011000;
    instrFile[10] = 8'b00100010;
    instrFile[11] = 8'b00000000;
    instrFile[12] = 8'b00100010;
    instrFile[13] = 8'b00100000;
    instrFile[14] = 8'b01100010;
    instrFile[15] = 8'b00000000;
    instrFile[16] = 8'b00000010;
    instrFile[17] = 8'b00000000;
    instrFile[18] = 8'b10000001;
    instrFile[19] = 8'b00010000;
    instrFile[20] = 8'b00100100;
    instrFile[21] = 8'b00110000;
    instrFile[22] = 8'b10100001;
    instrFile[23] = 8'b00000000;
    instrFile[24] = 8'b00101010;
    instrFile[25] = 8'b00111000;
    instrFile[26] = 8'b00100101;
    instrFile[27] = 8'b00000000;
    instrFile[28] = 8'b00100101;
    instrFile[29] = 8'b00101000;
    instrFile[30] = 8'b10000011;
    instrFile[31] = 8'b00000000;
    instrFile[32] = 8'b00000101;
    instrFile[33] = 8'b00000000;
    instrFile[34] = 8'b00000000;
    instrFile[35] = 8'b00001000;
    instrFile[36] = 8'b00000000;
    instrFile[37] = 8'b00000000;
    instrFile[38] = 8'b00000000;
    instrFile[39] = 8'b00000000;
    instrFile[40] = 8'b00000000;
    instrFile[41] = 8'b00000000;
    instrFile[42] = 8'b00000000;
    instrFile[43] = 8'b00000000;
    end
    

    assign instruction = {instrFile[address+3], instrFile[address+2], instrFile[address+1], instrFile[address]};
    
endmodule
