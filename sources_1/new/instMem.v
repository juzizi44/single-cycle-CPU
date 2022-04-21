`timescale 1ns / 1ps

module instMem(
        input wire [31:0] IAddr,
        input wire CLK,
        output wire [31:0] IDataOut
    );

    reg [7:0] rom[0:1500]; 
    
   
     initial 
     begin
         $readmemb("C:\\Users\\fsq\\project_1\\project_1.srcs\\inst_test1.txt", rom);
     end
    
//    always@(posedge CLK)
//    begin
//      $display("iaddr: %d inst; %h",IAddr, IDataOut);
//    end

     assign IDataOut[7:0] = rom[IAddr];
     assign IDataOut[15:8] = rom[IAddr + 1];
     assign IDataOut[23:16] = rom[IAddr + 2];
     assign IDataOut[31:24] = rom[IAddr + 3];
//    always@(posedge CLK)
//    begin
//        begin
//                IDataOut[7:0] <= rom[IAddr];
//                IDataOut[15:8] <= rom[IAddr + 1];
//                IDataOut[23:16] <= rom[IAddr + 2];
//                IDataOut[31:24] <= rom[IAddr + 3];
//        end 

////        IDataOut[7:0] = rom[IAddr];
////        IDataOut[15:8] = rom[IAddr + 1];
////        IDataOut[23:16] = rom[IAddr + 2];
////        IDataOut[31:24] = rom[IAddr + 3];
//        $display("iaddr: %d inst; %h",IAddr, IDataOut);

//    end
    
endmodule