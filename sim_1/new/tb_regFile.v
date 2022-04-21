`timescale 1ns / 1ps
`define clock_period 20

module tb_regFile(
    );
    
    reg [4:0] readReg1;
    reg [4:0] readReg2;
    reg clk;
    reg [4:0] writeReg;
    reg [31:0] writeData;
    reg isWreg;
    wire [31:0] readData1;
    wire [31:0] readData2;

    
    RegFile test(
           clk,readReg1,readReg2,writeReg,writeData,isWreg,readData1,readData2
        );
      
      initial clk =1'b1;
      always#(`clock_period/2) clk=~clk;  
      
initial begin
    #20
    isWreg = 1'b1;
    writeReg = 4'h1;
    writeData = 32'hd1;
    #20
    isWreg = 1'b1;
    writeReg = 4'h2;
    writeData = 32'hd2;
    #20
    isWreg = 1'b0;
    readReg1 = 4'h1;
    readReg2 = 4'h1;
    #20
    isWreg = 1'b0;
    readReg1 = 4'h2;
    readReg2 = 4'h2;
    #20
    isWreg = 1'b1;
    writeReg = 4'h6;
    writeData = 32'hd3;
    #20
    isWreg = 1'b0;
    readReg1 = 4'h5;
    readReg2 = 4'h6;

end

endmodule