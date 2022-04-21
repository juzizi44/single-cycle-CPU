`timescale 1ns / 1ps
`include "riscv.h"
module decoder(                      // 译码级
    input  wire [31:0] pc, //pc的值
    input  wire [31:0] inst, //指令的值
    input  wire [31:0] rs1Value, //地址rs1的数据
    input  wire [31:0] rs2Value, //地址rs2的数据

    output wire [ 4:0]  rs1Addr,  //地址rs1
    output wire [ 4:0]  rs2Addr,  //地址rs2
    output wire [ 4:0]  rdAddr,  //地址rd

    output wire [31:0] aluOperand1,       // alu操作数1
    output wire [31:0] aluOperand2,       // alu操作数2
    output wire [31:0]  extendOffset, //跳转指令的扩展偏移

    output wire [16:0]  aluControl,  //alu控制信号
    output wire         MemtoReg, //代表从数据存储器中读的读信号（若为0相当于多路选择器读的是alu的结果）
    output wire         MemWrite, //代表存储器写信号  //不一定需要，，可能是
    output wire         RegWrite,  //代表寄存器写信号
    output wire         Branch,  //代表跳转分支信号
    output wire [ 1:0]  loadStoreWidth, //读写宽度标志
    output wire         loadSign, //Load拓展方式
    output wire         PCsrc,  //直接跳转信号
    output wire         PCsrc2  //直接跳转信号
);
	

    wire [ 6:0] opcode_7;     
    wire [ 4:0] rd_5;        
    wire [ 4:0] rs1_5;    
    wire [ 4:0] rs2_5;      
    wire [ 2:0] funct_3;     
    wire [ 6:0] funct_7;    
    wire [11:0] imm_12;     
    wire [ 6:0] imm_7;   
    wire [ 4:0] imm_5;      
    wire [19:0] imm_20;      

    assign opcode_7   = inst[ 6: 0];
    assign rd_5       = inst[11: 7];
    assign rs1_5      = inst[19:15];
    assign rs2_5      = inst[24:20];
    assign funct_3    = inst[14:12];
    assign funct_7    = inst[31:25];
    assign imm_12     = inst[31:20];
    assign imm_7      = inst[31:25];
    assign imm_5      = inst[11:7 ];
    assign imm_20     = inst[31:12];

    assign rs1Addr = rs1_5 ; 
    assign rs2Addr = rs2_5 ;

    wire inst_LUI    , inst_AUIPC;
    wire inst_LB     , inst_LH    , inst_LW    , inst_LBU ;
    wire inst_LHU    , inst_SB    , inst_SH    , inst_SW  ;
    wire inst_ADDI   , inst_SLTI  , inst_SLTIU , inst_XORI;
    wire inst_ORI    , inst_ANDI  , inst_SLLI  , inst_SRLI;
    wire inst_SRAI   , inst_ADD   , inst_SUB   , inst_SLL ;
    wire inst_SLT    , inst_SLTU  , inst_XOR   , inst_SRL ;
    wire inst_SRA    , inst_OR    , inst_AND   ;
    wire inst_JAL    , inst_JALR  ;
    wire inst_BEQ    , inst_BNE   , inst_BLT   , inst_BGE , inst_BLTU , inst_BGEU ;


    assign inst_LUI      = (opcode_7 == 7'b0110111);
    assign inst_AUIPC    = (opcode_7 == 7'b0010111);

    assign inst_LB       = (funct_3 == `FUNCT3_LB )   & (opcode_7 == `OP_LOAD);
    assign inst_LH       = (funct_3 == `FUNCT3_LH )   & (opcode_7 == `OP_LOAD);
    assign inst_LW       = (funct_3 == `FUNCT3_LW )   & (opcode_7 == `OP_LOAD);
    assign inst_LBU      = (funct_3 == `FUNCT3_LBU)   & (opcode_7 == `OP_LOAD);
    assign inst_LHU      = (funct_3 == `FUNCT3_LHU)   & (opcode_7 == `OP_LOAD);
    assign inst_SB       = (funct_3 == `FUNCT3_SB )   & (opcode_7 == `OP_STORE);
    assign inst_SH       = (funct_3 == `FUNCT3_SH )   & (opcode_7 == `OP_STORE);
    assign inst_SW       = (funct_3 == `FUNCT3_SW )   & (opcode_7 == `OP_STORE);

    assign inst_JAL      = (opcode_7 == `OP_JAL);
    assign inst_JALR     = (opcode_7 == `OP_JALR);

    assign inst_ADDI     = (funct_3 == `FUNCT3_ADDI)  & (opcode_7 == `OP_OP_IMM);
    assign inst_SLTI     = (funct_3 == `FUNCT3_SLTI)  & (opcode_7 == `OP_OP_IMM);
    assign inst_SLTIU    = (funct_3 == `FUNCT3_SLTIU) & (opcode_7 == `OP_OP_IMM);
    assign inst_XORI     = (funct_3 == `FUNCT3_XORI ) & (opcode_7 == `OP_OP_IMM);
    assign inst_ORI      = (funct_3 == `FUNCT3_ORI  ) & (opcode_7 == `OP_OP_IMM);
    assign inst_ANDI     = (funct_3 == `FUNCT3_ANDI ) & (opcode_7 == `OP_OP_IMM);

    assign inst_SLLI     = (funct_3 == `FUNCT3_SLLI ) & (opcode_7 == `OP_OP_IMM) & (funct_7 == 7'b0000000);
    assign inst_SRLI     = (funct_3 == `FUNCT3_SRLI ) & (opcode_7 == `OP_OP_IMM) & (funct_7 == 7'b0000000);
    assign inst_SRAI     = (funct_3 == `FUNCT3_SRAI ) & (opcode_7 == `OP_OP_IMM) & (funct_7 == 7'b0100000);

    assign inst_ADD      = (funct_3 == `FUNCT3_ADD  ) & (opcode_7 == `OP_OP    ) & (funct_7 == 7'b0000000);
    assign inst_SUB      = (funct_3 == `FUNCT3_SUB  ) & (opcode_7 == `OP_OP    ) & (funct_7 == 7'b0100000);
    assign inst_SLL      = (funct_3 == `FUNCT3_SLL  ) & (opcode_7 == `OP_OP    ) & (funct_7 == 7'b0000000);
    assign inst_SLT      = (funct_3 == `FUNCT3_SLT  ) & (opcode_7 == `OP_OP    ) & (funct_7 == 7'b0000000);
    assign inst_SLTU     = (funct_3 == `FUNCT3_SLTU ) & (opcode_7 == `OP_OP    ) & (funct_7 == 7'b0000000);
    assign inst_XOR      = (funct_3 == `FUNCT3_XOR  ) & (opcode_7 == `OP_OP    ) & (funct_7 == 7'b0000000);
    assign inst_SRL      = (funct_3 == `FUNCT3_SRL  ) & (opcode_7 == `OP_OP    ) & (funct_7 == 7'b0000000);
    assign inst_SRA      = (funct_3 == `FUNCT3_SRA  ) & (opcode_7 == `OP_OP    ) & (funct_7 == 7'b0100000);
    assign inst_OR       = (funct_3 == `FUNCT3_OR   ) & (opcode_7 == `OP_OP    ) & (funct_7 == 7'b0000000);
    assign inst_AND      = (funct_3 == `FUNCT3_AND  ) & (opcode_7 == `OP_OP    ) & (funct_7 == 7'b0000000);
    
    assign inst_BEQ      = (funct_3 == `FUNCT3_BEQ )   & (opcode_7 == `OP_BRANCH );
    assign inst_BNE      = (funct_3 == `FUNCT3_BNE )   & (opcode_7 == `OP_BRANCH );
    assign inst_BLT      = (funct_3 == `FUNCT3_BLT )   & (opcode_7 == `OP_BRANCH );
    assign inst_BGE      = (funct_3 == `FUNCT3_BGE )   & (opcode_7 == `OP_BRANCH );
    assign inst_BLTU     = (funct_3 == `FUNCT3_BLTU )   & (opcode_7 == `OP_BRANCH );
    assign inst_BGEU     = (funct_3 == `FUNCT3_BGEU )   & (opcode_7 == `OP_BRANCH );

   

    wire alu_add, alu_sub, alu_slt, alu_sltu;
    wire alu_and, alu_or , alu_xor, alu_sll ;
    wire alu_srl, alu_sra, alu_lui          ;

    wire alu_beq;   /*相等分支*/
    wire alu_bne;   /*不相等分支*/
    wire alu_blt;   /*小于时分支*/
    wire alu_bge;   /*大于等于时分支*/
    wire alu_bltu;  /*无符号时小于分支*/
    wire alu_bgeu;  /*无符号大于等于分支*/

    assign alu_add =  inst_ADDI  | inst_ADD   | inst_LB            // 加法
                    | inst_LH    | inst_LW    | inst_LBU
                    | inst_LHU   | inst_SB    | inst_SH
                    | inst_SW    | inst_AUIPC | inst_JAL
                    | inst_JALR   ;
    assign alu_sub  = inst_SUB                 ;                         // 减法
    assign alu_slt  = inst_SLT   | inst_SLTI ;                        // 有符号小于置位
    assign alu_sltu = inst_SLTU  | inst_SLTIU;                        // 无符号小于置位
    assign alu_and  = inst_AND   | inst_ANDI ;                       // 逻辑与
                                   
    assign alu_or   = inst_OR    | inst_ORI   ;                      // 逻辑或
  
    assign alu_xor  = inst_XOR   | inst_XORI ;                        // 逻辑异或
    assign alu_sll  = inst_SLL   | inst_SLLI ;                        // 逻辑左移
    assign alu_srl  = inst_SRL   | inst_SRLI ;                        // 逻辑右移
    assign alu_sra  = inst_SRA   | inst_SRAI ;                        // 算术右移
    assign alu_lui  = inst_LUI   ;                                      // 高位加载
    assign alu_beq    =  inst_BEQ  ;
    assign alu_bne    =  inst_BNE  ;
    assign alu_blt    =  inst_BLT  ;
    assign alu_bge    =  inst_BGE  ;
    assign alu_bltu   =  inst_BLTU ;
    assign alu_bgeu   =  inst_BGEU ;




    wire RType;     // R-type
    wire IType;     // I-type
    wire SType;     // S-type
    wire UType;     // U-type
    wire JType;     // J-type
    wire BType;     // B-type   
 
  
    assign RType        = inst_ADD   | inst_SUB
                            | inst_SLL   | inst_SLT   | inst_SLTU
                            | inst_XOR   | inst_SRL   | inst_SRA
                            | inst_OR    | inst_AND  ;

    assign IType        = inst_LB    | inst_LH    | inst_LW
                            | inst_LBU   | inst_LHU   | inst_ADDI
                            | inst_SLTI  | inst_SLTIU | inst_XORI
                            | inst_ORI   | inst_ANDI  | inst_SLLI
                            | inst_SRLI  | inst_SRAI;

    assign SType        = inst_SB    | inst_SH    | inst_SW;

    assign UType        = alu_lui       | inst_AUIPC ;

    assign JType        = inst_JAL   | inst_JALR  ;
    assign BType        = inst_BEQ   | inst_BNE  | inst_BLT  | inst_BGE  |  inst_BLTU  | inst_BGEU ;
    

    wire rs1Exist;      // rs1存在
    wire rs2Exist;      // rs2存在
    wire rdExist;       // rd存在
    wire immExist;      // imm存在
    wire shamtExist;      // shamt存在

    wire exOffExist;    // extendOffset存在


    assign rs1Exist    = RType  | IType  | SType;

    assign rs2Exist    = RType | BType;
	
    assign rdExist     = RType  | IType  | UType | JType ;

    assign immExist    = IType  | SType  | UType | JType;

    assign shamtExist   =  inst_SLLI  | inst_SRLI  | inst_SRAI ;

    assign exOffExist  = BType | inst_JAL | inst_JALR ;
    

    wire        widthB;             // 字节读写
    wire        widthH;             // 半字读写
    wire        widthW;             // 字长读写

    assign MemtoReg         = inst_LB | inst_LH | inst_LW | inst_LBU | inst_LHU;
    assign MemWrite        = inst_SB | inst_SH | inst_SW ;

    assign loadSign     = ~(inst_LBU | inst_LHU);   //lbu 和 lhu 是无符号的

    assign widthB       = inst_LB | inst_LBU | inst_SB;

    assign widthH       = inst_LH | inst_LHU | inst_SH;

    assign widthW       = inst_LW | inst_SW;

    assign loadStoreWidth   = {{2{widthB}} & 2'b00}
                                | {{2{widthH}} & 2'b01}
                                | {{2{widthW}} & 2'b11};

    wire operand1PC;    // 第一操作数为PC的指令

    assign operand1PC   = JType | inst_AUIPC;
    
 
    wire [31:0] imm_32;               // 立即数

    assign imm_32             = {{32{IType & ~shamtExist    }} & {{20{inst[31]}},  imm_12            }}
                                | {{32{ shamtExist   }} & {{27{1'b0}}, rs2_5  }

    
                                | {{32{SType    }} & {{20{inst[31]}}, {imm_7, imm_5   }}}
                                | {{32{inst_LUI  }} & {    imm_20, 12'd0                       }}
                                | {{32{inst_AUIPC}} & {    imm_20, 12'd0                       }}
								| {{32{JType    }} & {    32'd4		      }}};


    assign rdAddr          = {{5{rdExist}} & rd_5};

    always@(*)
    begin
//    $display($time);
    $display("rdExist: %d, rd: %d, inst_ADDI: %d",rdExist, rd_5, inst_ADDI);
    $display("opcode_7: %b, funct_3: %b,inst_JAL:%d",opcode_7, funct_3,inst_JAL);
    end

    assign aluControl       = { alu_lui ,
                                alu_bgeu,
                                alu_bltu,
                                alu_bge ,
                                alu_blt ,
                                alu_bne ,
                                alu_beq ,
                                alu_sra ,
                                alu_srl ,
                                alu_sll ,
                                alu_xor ,
                                alu_or  ,
                                alu_and ,
                                alu_sltu,
                                alu_slt ,
                                alu_sub ,        
                                alu_add};
 

    assign aluOperand1     = {{32{ operand1PC  }} &  pc   }
                                | {{32{~(operand1PC)     }} &  rs1Value };
                               
                               

    assign aluOperand2     = {{32{ rs2Exist    }} &  rs2Value }
                                | {{32{ immExist    }} &  imm_32      };

    wire [31:0] ofs;
    assign ofs = {{20{inst[31]}},  imm_12 } + rs1Value;
 
    assign extendOffset    = {  {32{BType     }} & {{19{inst[31]}}, {inst[7],inst[30:25],inst[11:8],1'b0 }}} 
                             | {{32{inst_JAL   }} & {{11{inst[31]}}, {inst[31],inst[19:12],inst[20],inst[30:21],1'b0 }}} 
                             | {{32{inst_JALR  }} & ofs };

    assign Branch =  BType  ;
    assign RegWrite = rdExist ;
    assign PCsrc = inst_JAL ;
    assign PCsrc2 = inst_JALR ;

endmodule
