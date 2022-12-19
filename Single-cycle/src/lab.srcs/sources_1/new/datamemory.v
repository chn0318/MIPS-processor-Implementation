`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 08:53:08
// Design Name: 
// Module Name: datamemory
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


module datamemory(
    address,
     writeData,
    readData,
     Clk,
     memWrite,
     memRead
    );
    input [31:0] address;
    input [31:0] writeData;
    input Clk;
    input memWrite;
    input memRead;
    output reg [31:0] readData;
    reg [31:0] memFile[0:63];
    initial begin
    memFile[1]=1;
    end
always @ (address or memRead or memWrite)
   begin
      if (memRead && !memWrite)
      readData = memFile[address];
   else
       readData = 0;
end
always @ (negedge Clk)
   begin
      if (memWrite)
         memFile[address] = writeData;
    end
endmodule

