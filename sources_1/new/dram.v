`timescale 1ns / 1ps

module dram(
    input        [31:0] IAddr,
    output wire [31:0] IDataOut
    );
    wire [31:0] instr;
//    assign IDataOut = (rst)?instr:32'b0;
    assign IDataOut = instr;
    dist_mem_gen_0 mem(.a(IAddr[11:2]),.spo(instr)); //IPºË

endmodule