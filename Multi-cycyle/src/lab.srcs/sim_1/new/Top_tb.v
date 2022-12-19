`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/01 10:34:39
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


module Top_tb(

    );
    
    reg clk, reset;
    always #50 clk = !clk;
    
    Top top(.clk(clk), .reset(reset));
    
    initial begin
        $readmemh("C:/Users/wangz/Documents/Projects/Archlabs/lab06/code.txt", top.instrMem.instrFile);
        $readmemh("C:/Users/wangz/Documents/Projects/Archlabs/lab06/data.txt", top.dataMem.memFile);
        clk = 1;
        reset = 1;
        #25 reset = 0;
    end
    
endmodule
