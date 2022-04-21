`timescale 1ns / 1ps
module tb_ALU(

    );
    reg [16:0] aluControl;
    reg [31:0] aluData1;
    reg [31:0] aluData2;
    wire [31:0] aluResult;
    wire zero;
    
    ALU test1(
           aluControl,aluData1,aluData2,aluResult,zero
        );
    initial begin

    #20
    // add
    aluControl =  17'b00000000000000001 ;  
    aluData1 = 32'd1;
    aluData2 = 32'd3;
    
    #20
    // sub
    aluControl = 17'b00000000000000010;  
    aluData1 = 32'd7;
    aluData2 = 32'd2;
    
    #20
    // slt -10 > -11 = 0
    aluControl = 17'b00000000000000100;  
    aluData1 = 32'b11111111111111111111111111110110;
    aluData2 = 32'b11111111111111111111111111110101;
        
    #20
   // sltu  3 < 4 = 1
   aluControl = 17'b00000000000001000 ;  
   aluData1 = 32'd3;
   aluData2 = 32'd4;
    
    #20
    // sltu  1 >= 2 = 0
    aluControl = 17'b00000000000001000 ;  
    aluData1 = 32'd5;
    aluData2 = 32'd5;
    
    #20
    // and  15 and 5c = 14
    aluControl =  17'b00000000000010000;  
    aluData1 = 32'b0010101;
    aluData2 = 32'b1011100;
    
    #20
    // or  15 or 5c = 5d
    aluControl =  17'b00000000000100000;  
    aluData1 = 32'b0010101;
    aluData2 = 32'b1011100;
    
    #20
    // xor  15 xor 5c = 49
    aluControl =  17'b00000000001000000;  
    aluData1 = 32'b0010101;
    aluData2 = 32'b1011100;
    
    #20
    // sll  5c << 1 = B8
    aluControl = 17'b00000000010000000;  
    aluData1 = 32'b1011100;
    aluData2 = 32'b1;
    
    #20
    // sll  c0000000 << 2 = 0 
    aluControl =  17'b00000000010000000;  
    aluData1 = {2'b11,{30{1'b0}}};
    aluData2 = 32'b10;
    
    #20
    // srl  15 >> 2 = 5
    aluControl =  17'b00000000100000000;  
    aluData1 = 32'b0010101;
    aluData2 = 32'b10;
    
    #20
    // sra  11000000000000000000000000000000 >> 2 = 11110000000000000000000000000000(F000 0000)
    aluControl =  17'b00000001000000000 ;  
    aluData1 = {2'b11,{30{1'b0}}};
    aluData2 = 32'b10;
    
    #20
    // beq   zero=1 相等
    aluControl = 17'b00000010000000000;  
    aluData1 = 32'b1;
    aluData2 = 32'b1;
    
    #20
    // beq   zero=0 不等
    aluControl = 17'b00000010000000000;  
    aluData1 = 32'b10;
    aluData2 = 32'b0;


  #20
    // bne  zero=1  不等
    aluControl =  17'b00000100000000000;  
    aluData1 = 32'b10;
    aluData2 = 32'b0;

  #20
    // bne  zero=0 相等
    aluControl =  17'b00000100000000000;  
    aluData1 = 32'b1;
    aluData2 = 32'b1;

  #20
    // blt  zero=1  小于
    aluControl = 17'b00001000000000000;  
    aluData1 = 32'b0;
    aluData2 = 32'b10;

  #20
    // blt zero=0  大于
    aluControl =17'b00001000000000000;  
    aluData1 = 32'b10;
    aluData2 = 32'b0;

  #20
    // bge  zero=1  大于
    aluControl =  17'b00010000000000000;  
    aluData1 = 32'b10;
    aluData2 = 32'b0;

  #20
    // bge  zero=1 等于
    aluControl =  17'b00010000000000000;  
    aluData1 = 32'b10;
    aluData2 = 32'b10;

  #20
    // bge  zero=0 小于
    aluControl =  17'b00010000000000000;  
    aluData1 = 32'b0;
    aluData2 = 32'b10;

  #20
    // bltu  zero=1 小于
    aluControl =  17'b00100000000000000;  
    aluData1 = 32'b0;
    aluData2 = 32'b10;

  #20
    // bltu  zero=0 大于
    aluControl =  17'b00100000000000000;  
    aluData1 = 32'b10;
    aluData2 = 32'b0;

  #20
    // bgeu  zero=1  大于
    aluControl = 17'b01000000000000000;  
    aluData1 = 32'b10;
    aluData2 = 32'b0;

  #20
    // bgeu  zero=1  等于
    aluControl = 17'b01000000000000000;  
    aluData1 = 32'b10;
    aluData2 = 32'b10;

  #20
    // bgeu  zero=0  小于
    aluControl = 17'b01000000000000000;  
    aluData1 = 32'b0;
    aluData2 = 32'b10;


  #20
    // lui  zero=0 aluResult=2
    aluControl =  17'b10000000000000000 ;  
    aluData1 = 32'b10;
    aluData2 = 32'b10;
end
    
endmodule