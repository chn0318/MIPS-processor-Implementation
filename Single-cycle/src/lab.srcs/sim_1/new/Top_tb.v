`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/14 09:26:22
// Design Name: 
// Module Name: Top_tb
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


module Top_tb( );
reg Clk,reset;
always #50 Clk=!Clk;
Top top(.Clk(Clk),.reset(reset));
initial begin
Clk=1;
reset=1;
#25;
reset=0;
#1000;
end
endmodule
