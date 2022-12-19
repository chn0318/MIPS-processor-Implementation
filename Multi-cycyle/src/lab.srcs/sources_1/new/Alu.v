`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/10 10:33:36
// Design Name: 
// Module Name: Alu
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


module Alu(
    input [31:0] in1,
    input [31:0] in2,
    input [3:0] aluCtr,
    output zero,
    output [31:0] aluRes
    );
    
    reg zero;
    reg [31:0] aluRes;
    
    always @ ({aluCtr, in1, in2})
    begin
        zero = 0;
        case (aluCtr)
        4'b0010: // add
        begin
            aluRes = in1 + in2;
            if (aluRes == 0)
                zero = 1;
        end
        4'b0110: // sub
        begin
            aluRes = in1 - in2;
            if (aluRes == 0)
                zero = 1;
        end
        4'b0000: // and
        begin
            aluRes = in1 & in2;
            if (aluRes == 0)
                zero = 1;
        end
        4'b0001: // or
        begin
            aluRes = in1 | in2;
            if (aluRes == 0)
                zero = 1;
        end
        4'b1100: // nor
        begin
            aluRes = ~(in1 | in2);
            if (aluRes == 0)
                zero = 1;
        end
        4'b0111: // set on less than
        begin
            if (in1 < in2)
            begin
                aluRes = 1;
                zero = 0;
            end
            else 
            begin
                aluRes = 0;
                zero = 1;
            end
        end
        endcase
    end
    
endmodule
