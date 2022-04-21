`timescale 1ns / 1ps
`define clock_period 20

module tb_instMem(
    );
    
    reg [31:0] IAddr;
    reg  InsMemRW;
    reg  CLK;
    wire [31:0] IDataOut;

    
    instMem test(
           IAddr,CLK,IDataOut
        );
      
      initial CLK =1'b1;
      always#(`clock_period/2) CLK=~CLK;  
      
    initial begin
        #20
        InsMemRW = 1'b1;
        IAddr = 32'h0;
        #20
        InsMemRW = 1'b1;
        IAddr = 32'h4;
        #20
        InsMemRW = 1'b1;
        IAddr = 32'h8;
    end

endmodule