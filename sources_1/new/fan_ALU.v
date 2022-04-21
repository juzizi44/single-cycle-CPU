module ALU (
    input wire [16:0] aluControl,
    input wire [31:0] aluData1,     //第一个操作数
    input wire [31:0] aluData2,     //第二个操作数
    output reg [31:0] aluResult ,  //返回的结果
    output reg zero //辅助跳转标志
);
    
    wire [31:0] addSubResult;  //加减
    reg [31:0] sltResult;  //小于置位操作
    wire [31:0] sltuResult;  //无符号小于置位操作
    wire [31:0] andResult;  //与
    wire [31:0] orResult;  //或
    wire [31:0] xorResult;  //异或
    wire [31:0] sllResult;  //逻辑左移
    wire [31:0] srlResult;  // 逻辑右移操作
    wire [31:0] sraResult;  // 算术右移操作
    wire [31:0] beqResult;  //相等时分支
    wire [31:0] bneResult;  //不相等时分支
    wire [31:0] bltResult;  //小于时分支
    wire [31:0] bgeResult;  //大于等于时分支
    wire [31:0] bltuResult;  //无符号小于时分支
    wire [31:0] bgeuResult;  //无符号大于等于时分支
    wire [31:0] luiResult;  // 高位立即数加载

    wire c_add;
    assign c_add = aluControl[0];


    wire [31:0] adderData1;  // 加法操作数1
    wire [31:0] adderData2;  // 加法操作数2
    wire        adderCin;     // 加法进位输入
    wire[32:0]  adderResult;   // 加法结果  注意是33位
    wire        adderCout;      // 加法进位输出
    

    assign adderData1 = aluData1;
    assign adderData2 = c_add ? aluData2 : ~aluData2;  //不是加法 默认做减



    assign adderCin = ~c_add;  // 加法进位输入
    assign adderResult = adderData1 + adderData2 + adderCin;  
    assign adderCout = adderResult[32];  //加法进位输出（结果的第33位）
    assign addSubResult = adderResult[31:0];  //最终结果是低32位


//    assign sltResult[31:1] = 31'd0;
//    assign sltResult[0] = ((aluData1[31]==0 && aluData2[31]==1) || adderResult[31]==0) ? 0 : 1;

    always @(*) begin
        sltResult[31:1] <= 31'd0;
        if (aluData1[31]==0 && aluData2[31]==1) 
            sltResult[0] <= 0;
        else if (aluData1[31]==1 && aluData2[31]==0)
            sltResult[0] <= 1;
        else if (adderResult[31]==1)
            sltResult[0] <= 1;
        else if (adderResult[31]==0)
            sltResult[0] <= 0;
        else
            sltResult[0] <= 0;
    end

    assign sltuResult  = {31'd0,~adderCout};  //无符号数的小于置位




    assign sllResult = ($unsigned(aluData1)) << aluData2[4:0]; //x[rs2]的低 5 位代表移动位数，其高位则被忽略
    assign srlResult = ($unsigned(aluData1)) >> aluData2[4:0];
    assign sraResult = (($signed(aluData1)) >>> aluData2[4:0]);

   

    assign andResult = aluData1 & aluData2;
    assign orResult = aluData1 | aluData2;
    assign xorResult = aluData1 ^ aluData2;
    assign orResult = aluData1 | aluData2;
    assign luiResult  =  aluData2;

    

    assign beqResult=(($signed(aluData1))== ($signed(aluData2))? {31{1'b1}}: {32{1'b0}}); 
    assign bneResult=(($signed(aluData1))!= ($signed(aluData2))? {31{1'b1}}: {32{1'b0}});   
    assign bltResult=(($signed(aluData1)) < ($signed(aluData2))? {31{1'b1}}: {32{1'b0}});
    assign bgeResult=(($signed(aluData1))>= ($signed(aluData2))? {31{1'b1}}: {32{1'b0}});   
    assign bltuResult=(($unsigned(aluData1)) < ($unsigned(aluData2))?  {32{1'b1}}: {32{1'b0}});
    assign bgeuResult=(($unsigned(aluData1)) >= ($unsigned(aluData2))?  {32{1'b1}}: {32{1'b0}});



    always @(*) begin
        aluResult = 0; zero = 0;
        case(aluControl)
            17'b00000000000000001 : aluResult = addSubResult;
            17'b00000000000000010 : aluResult = addSubResult;
            17'b00000000000000100 : aluResult = sltResult;
            17'b00000000000001000 : aluResult = sltuResult;
            17'b00000000000010000 : aluResult = andResult;
            17'b00000000000100000 : aluResult = orResult;
            17'b00000000001000000 : aluResult = xorResult;
            17'b00000000010000000 : aluResult = sllResult;
            17'b00000000100000000 : aluResult = srlResult;
            17'b00000001000000000 : aluResult = sraResult;
            17'b00000010000000000 : zero = beqResult[0];
            17'b00000100000000000 : zero = bneResult[0]; 
            17'b00001000000000000 : zero = bltResult[0]; 
            17'b00010000000000000 : zero = bgeResult[0]; 
            17'b00100000000000000 : zero = bltuResult[0]; 
            17'b01000000000000000 : zero = bgeuResult[0]; 
            17'b10000000000000000 : aluResult = luiResult; 
        endcase
    end
    
endmodule