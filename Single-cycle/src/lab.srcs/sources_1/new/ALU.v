`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/31 10:15:38
// Design Name: 
// Module Name: ALU
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
/*module ALU(   
   input [31:0] input1,
   input [31:0] input2,
   input [3:0] aluCtr,
   output reg zero,
   output reg [31:0] aluRes  
);
always @ (input1 or input2 or aluCtr)
begin 
    zero=0;
    case(aluCtr)
        4'b0000:
        begin
        aluRes=input1&input2;
        end
        4'b0001:
        begin
        aluRes=input1|input2;
        end
        4'b0010:
        begin
        aluRes=input1+input2;
        end
        4'b0110:
        begin
        aluRes=input1-input2;
        end
        4'b0111:
        begin
        if(input1<input2)
            begin
            aluRes=1;
            end
        else
            begin
            aluRes=0;
            end
        end
        4'b1100:
        begin
        aluRes=~(input1|input2);    
        end
        default:
        begin
        aluRes=0;
        end
    endcase
    if(aluRes == 0)
    begin
    zero=1;
    end 
end

 
endmodule*/
module ALU(
input [31:0] input1,
input [31:0] input2,
input [3:0] aluCtr,
output reg zero,
output reg [31:0] aluRes
);
always @(input1 or input2 or aluCtr)
    begin
    case(aluCtr)
    4'b0000:
        begin
        aluRes=input1 & input2;
        if(aluRes==0) zero=1;
        else zero=0;
        end
    4'b0001:
        begin
        aluRes=input1 | input2;
        if(aluRes==0) zero=1;
        else zero=0;
        end
    4'b0010:
        begin
        aluRes=input1+input2;
        if(aluRes==0) zero=1;
        else zero=0;
        end
    4'b0011:
        begin
        aluRes=input2<<input1;
        if(aluRes==0) zero=1;
        else zero=0;
        end
    4'b0100:
        begin
        aluRes=input2>>input1;
        if(aluRes==0) zero=1;
        else zero=0;
        end
    4'b0110:
        begin
        aluRes=input1-input2;
        if(aluRes==0) zero=1;
        else zero=0;
        end
    4'b0111:
        begin
        if(input1<input2) aluRes=1;
        else aluRes=0;
        end
    4'b1100:
        begin
        aluRes=~(input1|input2);
        if(aluRes==0) zero=1;
        else zero=0;
        end
    endcase
    end
endmodule