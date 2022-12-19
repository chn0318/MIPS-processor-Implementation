`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/14 08:29:19
// Design Name: 
// Module Name: Mux32
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


module Mux32(
    input sel,
    input [31:0] in1,
    input [31:0] in0,
    output [31:0] out
    );
    
    assign out = sel ? in1 : in0;
    
endmodule