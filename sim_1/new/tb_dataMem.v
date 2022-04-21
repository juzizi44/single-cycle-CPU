`timescale 1ns / 1ps
`define clock_period 20

module tb_dataMem(
    );
    
    reg MemToReg; //选择读结果，来自ALU还是数据存储器
    reg MemWrite; //写控制信号，为1时写
    reg [1:0]loadStoreWidth ;
    reg loadSign;
    reg CLK;
    reg [31:0] memAddr;  //操作的地址
    reg [31:0] writeData;
    wire [31:0] writeBackData;  //数据选择器最终输出结果

    
    DataMEM test(
           MemToReg,MemWrite,loadStoreWidth,loadSign,CLK,memAddr,writeData,writeBackData
        );
      
      initial CLK =1'b1;
      always#(`clock_period/2) CLK=~CLK;  

initial begin
    #20   
   // writeBackData=memAddr=32'h13 字节
    MemToReg = 1'b0;
    MemWrite = 1'b1;
    memAddr = 32'h13;
    writeData = 32'ha1;     //1010 0001
    loadStoreWidth =2'b00;

    #20
//读    writeBackData=1010 0001  字节
    MemToReg = 1'b1;
    MemWrite = 1'b0;
    memAddr = 32'h13;
    loadStoreWidth =2'b00;
    loadSign =1'b0;

    #20   
   // writeBackData=memAddr=32'h11 半字长
    MemToReg = 1'b0;
    MemWrite = 1'b1;
    memAddr = 32'h11;
    writeData = 32'ha1a1;     //1010 0001 1010 0001
    loadStoreWidth =2'b01;

    #20
//读  writeBackData=1010 0001 1010 0001 （前面补1）
    MemToReg = 1'b1;
    MemWrite = 1'b0;
    memAddr = 32'h11;
    loadStoreWidth =2'b01;
    loadSign =1'b1;

    #20   
   // writeBackData=memAddr=32'h12
    MemToReg = 1'b0;
    MemWrite = 1'b1;
    memAddr = 32'h12;
    writeData = 32'ha1a1a1;    
    loadStoreWidth =2'b11;

    #20
//读   writeBackData=32'ha1a1a1
    MemToReg = 1'b1;
    MemWrite = 1'b0;
    memAddr = 32'h12;
    loadStoreWidth =2'b11;
    loadSign =1'b0;
end

endmodule