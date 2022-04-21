`timescale 1ns / 1ps
module pcAdd(
        input clk,               //时钟
        input zero,   //从alu传出的标志
        input Branch,   //分支信号
        input PCsrc,  //jal直接跳转信号
        input PCsrc2 , //jalr直接跳转信号
        input [31:0] extendOffset,  //扩展好的offset
//        input reg[31:0] curPC,  //当前指令的地址
        output [31:0] PCout  //新指令地址
    );
    
    reg[31:0] nextPC;
    
    initial begin
        nextPC <= 32'h80000000; // riscv-tests 指令地址从h80000000开始
    end
    
    
    
    always@(posedge clk )
    begin
        $display("PCsrc: %d，PCsrc2：%d, zero && Branch:%d",PCsrc,PCsrc2,zero && Branch);
        $display("nextPC: %d, extendOffset:%d,PCsrc:%d",nextPC,extendOffset,PCsrc);
        if(PCsrc) 
            begin 
                nextPC = nextPC + extendOffset;
            end
        else if(PCsrc2) 
            begin 
                nextPC = extendOffset;
            end
        else if(zero && Branch)
            begin 
                nextPC = nextPC + extendOffset;
            end
        else
            begin
                nextPC = nextPC + 4;
            end
    end
    
    assign PCout = nextPC;
endmodule
