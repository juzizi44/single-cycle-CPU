`timescale 1ns / 1ps
`define clock_period 20

module tb_decoder(
    );
    reg  PC; //pc的值
    reg [31:0] inst; //指令的值
    reg [31:0] rs1Value; //地址rs1的数据
    reg [31:0] rs2Value; //地址rs2的数据

    wire [ 4:0]  rs1Addr;  //地址rs1
    wire [ 4:0]  rs2Addr;  //地址rs2
    wire [ 4:0]  rdAddr;  //地址rd

    wire [31:0] aluOperand1;       // alu操作数1
    wire [31:0] aluOperand2;       // alu操作数2
    wire [31:0]  extendOffset; //跳转指令的扩展偏移

    wire [16:0]  aluControl;  //alu控制信号
    wire         MemtoReg ; //代表从数据存储器中读的读信号（若为0相当于多路选择器读的是alu的结果）
    wire         MemWrite ; //代表存储器写信号  //不一定需要，，可能是
    wire         RegWrite ;  //代表寄存器写信号
    wire         Branch ;  //代表跳转分支信号
    wire         loadStoreWidth  ; //读写宽度标志
    wire         loadSign; //Load拓展方式
    wire         PCsrc;  //直接跳转信号
    wire         PCsrc2;  //直接跳转信号
    
    decoder test(
        PC, //pc的值
        inst,
        rs1Value, //地址rs1的数据
        rs2Value, //地址rs2的数据
        rs1Addr,
        rs2Addr,
        rdAddr,  //地址rd
        
        aluOperand1,       // alu操作数1
        aluOperand2,       // alu操作数2
        extendOffset, //跳转指令的扩展偏移
        
        aluControl,  //alu控制信号
        MemtoReg , //代表从数据存储器中读的读信号（若为0相当于多路选择器读的是alu的结果）
        MemWrite , //代表存储器写信号  //不一定需要，，可能是
        RegWrite ,  //代表寄存器写信号
        Branch ,  //代表跳转分支信号
        loadStoreWidth  , //读写宽度标志
        loadSign, //Load拓展方式
        PCsrc,  //直接跳转信号
        PCsrc2  //delaySymbol 
        );

    initial begin
        #20
        inst = 32'b00000000010100000000000010010011;
    end

endmodule