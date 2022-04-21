`timescale 1ns / 1ps
`default_nettype none 

module top(
        input wire clk,
        
        output wire [31:0] pc,
        output wire [31:0] IDataOut,
        output wire [4:0] rs1Addr,
        output wire [4:0] rs2Addr,     
        output wire [4:0] rdAddr,     
        output wire [31:0] readData1,
        output wire [31:0] readData2,
        output wire MemtoReg,
        output wire branch,
        output wire zero
    );

//    wire [31:0] IDataOut;
    
//    wire [31:0] pc;
    
//    wire [31:0] readData1;
//    wire [31:0] readData2;
    dram dram(
        .IAddr(pc),
        .IDataOut(IDataOut)
    );
//    instMem inst_mem(
//           pc,clk,IDataOut
//        );
       
    wire [31:0] aluResult;
   

    wire RegWrite;
    wire [31:0] writeBackData;
    
    
    
    RegFile reg_file(
        .clk(clk),
        .readReg1(rs1Addr),
        .readReg2(rs2Addr),
        .writeReg(rdAddr),
        .writeData(writeBackData),
        .isWreg(RegWrite),
        .readData1(readData1),
        .readData2(readData2)
    );
     
    wire [31:0] aluOperand1;
    wire [31:0] aluOperand2;
    wire [16:0] aluControl;
//    wire zero;
     ALU alu(
       .aluControl(aluControl),
       .aluData1(aluOperand1),
       .aluData2(aluOperand2),
       .aluResult(aluResult),
       .zero(zero)
    );
   
    
    wire MemWrite;
    
    wire [1:0] loadStoreWidth;
    wire loadSign;
    wire [31:0] extendOffset;
//    wire Branch;
    wire PCsrc;
    wire PCsrc2;
//    wire [4:0] rs1Addr;
//    wire [4:0] rs2Addr;
//    wire [4:0] rdAddr;

    always@(posedge clk)
    begin
    $display("-------------------------------------------------------------------------------------------------------------------");
    $display($time);
    $display("pc: %d,IDataOut: %b, rs1Addr: %d, rs2Addr: %d, rdAddr: %d, aluOperand1??%d??aluOperand2: %d, aluResult: %d, aluControl:%b",pc,IDataOut, rs1Addr, rs2Addr, rdAddr,aluOperand1,aluOperand2, aluResult,aluControl);
    $display("readData1: %d, readData2: %d",readData1, readData2);
    $display("-----extendOffset:%d--------",extendOffset);
    end
    
    decoder decoder(
        .pc(pc),
        .inst(IDataOut),
        .rs1Value(readData1),
        .rs2Value(readData2),
        .rs1Addr(rs1Addr),
        .rs2Addr(rs2Addr),
        .rdAddr(rdAddr),
        .aluOperand1(aluOperand1),
        .aluOperand2(aluOperand2),
        .extendOffset(extendOffset),
        .aluControl(aluControl),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .RegWrite(RegWrite),
        .Branch(branch),
        .loadStoreWidth(loadStoreWidth),
        .loadSign(loadSign),
        .PCsrc(PCsrc),
        .PCsrc2(PCsrc2)
    );
    
    
    DataMEM dataMem(
        .MemToReg(MemtoReg),
        .MemWrite(MemWrite),
        .loadStoreWidth(loadStoreWidth),
        .loadSign(loadSign),
        .clk(clk),
        .memAddr(aluResult),
        .writeData(readData2),
        .writeBackData(writeBackData)
    );
    
   
    pcAdd pcAdd(
        .clk(clk),
        .zero(zero),
        .Branch(branch),
        .PCsrc(PCsrc),
        .PCsrc2(PCsrc2),
        .extendOffset(extendOffset),
        .PCout(pc)
    );


endmodule
