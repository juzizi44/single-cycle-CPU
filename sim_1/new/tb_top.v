`timescale 1ns / 1ps
`define clock_period 20

module tb_top(
    );
    reg CLK;
    wire [31:0] IDataOut;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [31:0] readData1;
    wire [31:0] readData2;
    wire MemtoReg;
    wire [31:0] pc;
    wire branch;
    wire zero;
    
    
    top test(
           CLK,pc,IDataOut,rs1,rs2,rd,readData1,readData2,MemtoReg,branch,zero
        );
      
    initial CLK =1'b1;
    always#(`clock_period/2) CLK=~CLK;  

endmodule