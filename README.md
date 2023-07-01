# single-cycle-CPU
## 本次课程设计完成以下工作
a)	实现了RISC-V架构RV32I指令集的CPU，频率为55.6MHZ，并通过了RISC-V官方指令集测试。该CPU实现了RV32I指令集47条指令中的除CSR、ECALL等操作系统相关指令外所有的用户程序指令，一共37条，理论上可以运行任何没有中断与异常的程序。

b)	编译了RISC-V GNU Compiler Toolchain并在Spike模拟器上运行了C程序；

c)	将C程序编译为机器码写入COE文件，在Vivado行为仿真中正确运行。

d)	编写单独的RISC-V汇编程序来调用C语言程序，解决栈指针非法访问的问题。
## 设计图
- 设计思路
  
![image](https://github.com/juzizi44/single-cycle-CPU/blob/master/design.png)

- vidado导出
  
![image](https://github.com/juzizi44/single-cycle-CPU/blob/master/vivado_CPU.png)

## 模块设计：
总共分为7个模块，分别是：instMem（指令寄存器）、PcAdd （控制PC跳转）、ALU（算数逻辑单元）、DataMem（数据存储器）、RegFile（寄存器）、Top（顶层模块）、Decode（译码器）
### instMem
指令寄存器，用来保存指令，我们设置存储单元宽度为8位。当执行一条指令时，会把指令从指令寄存器取出，传入译码器。后期为完成附加题更改为dram。
- **输入信号：**
IAddr	指令地址
CLK	时钟
- **输出信号：**
IDataOut	指令值

### PcAdd 
根据不同指令的不同控制信号，计算下一个PC的值，即NextPc的值。我们考虑了如下3种情况：
针对B型指令（控制信号为zero和Branch），将pc值设为当前值加上符号位扩展的偏移offset；
针对jal指令（控制信号为PCsrc），亦是将pc值设为当前值加上符号位扩展的偏移offset；
针对jalr指令（控制信号为PCsrc2），将pc值设为x[rs1] + sign-extend(offset)
- **输入信号：**
CLK	时钟
zero	从alu传出的标志
Branch	分支信号
	PCsrc	jal直接跳转信号
PCsrc2	jalr直接跳转信号
extendOffset	扩展好的offset
curPC	当前指令的地址
- **输出信号：**
nextPC	新指令地址

### ALU
算数逻辑单元，对两个输入的操作数依据控制信号进行计算。我们设计的运算包含：add加、sub减、slt小于置位、sltu无符号小于置位、and与、or或、xor异或、sll逻辑左移、srl逻辑右移、sra算术右移、beq相等分支、bne不等分支、blt小于分支、bge大于等于分支、bltu无符号小于分支、bgeu无符号大于等于分支、lui高位立即数加载。共计17种。
- **输入信号：**
aluControl	Alu控制信号
aluData1	第一个操作数
aluData2	第二个操作数
- **输出信号：**
aluResult	返回的结果
zero	辅助跳转标志

### DataMem
数据存储器，根据控制信号对数据存储器进行读或者写操作。
LB,LH,LW,LBU,LHU,SB,SH,SW这几类指令的存取会分为字、字节、半字、有符号、无符号的情况，所以我们针对此问题设计了读写宽度标志信号和load拓展方式信号，以控制不同情况的存取。
- **输入信号：**
MemToReg	选择读结果，来自ALU还是数据存储器
MemWrite	写控制信号
loadStoreWidth	读写宽度标志
loadSign	Load拓展方式
CLK	时钟
memAddr	操作的地址
writeData	操作数据
- **输出信号：**
writeBackData	数据选择器最终输出结果

### RegFile
寄存器组，通过控制单元输出的控制信号，进行相对应的读或写操作。时钟到来时，寄存器会根据译码器输出的rs1和rs2的地址直接读出相应两个数据，传回译码器（不论是什么指令，都会传回去这两个值）。译码器译码后，会根据不同情况选择是否给出寄存器写信号。这里和课上讲的结构不太一样。
课上讲的结构是把寄存器读出的值传给ALU。我们的是先把寄存器的值传给译码器，因为给ALU的值可能是立即数，可能是寄存器值，也可能是PC值等，于是把这几个可能的值都给译码器，然后让译码器来选择给ALU哪个值。
- **输入信号：**
clk	时钟
readReg1	rs寄存器地址(读取)
readReg2	rt寄存器地址(读取)
writeReg	写入的地址
writeData	写入的数据
RegWrite	写使能信号
- **输出信号：**
readData1	rs读出的数据
readData2	rt读出的数据

### Top
顶层设计模块，负责将CPU各模块连接起来。
###  Decode
译码器包含的内容比较多。
a.	译码器读取指令后，会对指令进行如下分割。
b.	根据以下情况对指令进行分类
- alu操作种类（add、sub、slt、xor、beq...)
- 指令类型（RISUJB）
- rs1、rs2、rd、imm、shamt、extendoffset是否存在
- loadstore相关：字长、半字、字节读写，有无符号拓展
- 第一操作数是否为pc
c.	分好类后，不同的类别会有不同的输出信号和输出数据。
（我们的译码器与课堂讲述的模型存在一定的差异，译码器输入端会直接传入从寄存器中获取的rs1及rs2的值，译码后根据不同的指令情况，会直接传出alu的两个操作数）。
d.	控制信号图
 
- **输入信号：**
w_PC	pc的值
inst	指令的值
rs1Value	地址rs1的数据
rs2Value	地址rs2的数据
- **输出信号：**
rs1Addr		地址rs1
rs2Addr	地址rs2
rdAddr	地址rd
rs2Value	地址rs2的数据
aluOperand1	alu操作数1
aluOperand2	alu操作数2
extendOffset	跳转指令的扩展偏移
aluControl	alu控制信号
MemtoReg	从数据存储器中读的读信号
MemWrite	存储器写信号
RegWrite	寄存器写信号
Branch	跳转分支信号
loadStoreWidth	读写宽度标志
loadSign	Load拓展方式
PCsrc	jal跳转信号
PCsrc2	jalr跳转信号

