`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         维瓦（昆明）电子科技有限公司
// Engineer:        于奇
// 
// Create Date:     2024/05/27 13:13:45
// Design Name:     SM3
// Module Name:     XC7Z035_TOP
// Project Name:    project_1
// Target Devices:  XC7Z035FFG676-2
// Tool Versions:   VIVADO2018.3
// Description:     SM3加密算法
//                  
// Dependencies:    无
// 
// Revision:        V0.1
// Revision 0.01 - File Created
// Additional Comments: 开源代码；概不负责；
// 
//////////////////////////////////////////////////////////////////////////////////
/*----说明----*/
//此代码为开源代码，如有使用请注明来源
//参数PARALLEL_NUM为迭代并行数量，支持：1,2,4,8,16,32,64
//并行数量为64时：输入数据可连续输入
//并行数量为32时：输入数据需间隔1 个周期
//并行数量为16时：输入数据需间隔3 个周期
//并行数量为8 时：输入数据需间隔7 个周期
//并行数量为4 时：输入数据需间隔15个周期
//并行数量为2 时：输入数据需间隔31个周期
//并行数量为1 时：输入数据需间隔63个周期
//注：并行数量越大，计算越快，但对时序要求越高
//XC7Z035FFG676-2推荐50M时钟下并行数量为4
//其他时钟频率下的并行数量按时序报告自行测试
//模块内部流水线输出
//输出数据以o_Encrypt_Valid上升沿指示当前数据有效
//只做了初步的仿真与上板测试，如有BUG请自行修改
/*------------*/

module XC7Z035_TOP(
    input           i_clk_p             ,
    input           i_clk_n             ,
    output [3 :0]   o_led       
);

assign o_led = 4'b0001;

wire                w_clk_50MHz         ;
wire                w_rst               ;
wire                w_pll_locked        ;

reg  [255:0]        ri_Original_Data    ;
reg                 ri_Original_Valid   ;
reg  [15 :0]        r_cnt               ;

(* MARK_DEBUG = "TRUE" *)wire [255:0]        w_Encrypt_Data      ;
(* MARK_DEBUG = "TRUE" *)wire                w_Encrypt_Valid     ;

clk_wiz_0 clk_wiz_0_U0
(
    .clk_out1           (w_clk_50MHz        ),     
    .reset              (0                  ),
    .locked             (w_pll_locked       ),       
    .clk_in1_p          (i_clk_p            ),
    .clk_in1_n          (i_clk_n            )
);

rst_gen_module#(
    .P_RST_CYCLE        (100               )   
)   
rst_gen_module_u0   
(   
    .i_rst              (0                 ),
    .i_clk              (w_clk_50MHz       ),
    .o_rst              (w_rst             )
);

SM3_Encrypt#(
    .PARALLEL_NUM        (4                 )   
)
SM3_Encrypt_u0
(
    .i_clk               (w_clk_50MHz       ),
    .i_rst               (w_rst             ),

    .i_Original_Data     (ri_Original_Data  ),
    .i_Original_Valid    (ri_Original_Valid ),
    .o_Encrypt_Data      (w_Encrypt_Data    ),
    .o_Encrypt_Valid     (w_Encrypt_Valid   )
);

always@(posedge w_clk_50MHz,posedge w_rst)
begin
    if(w_rst)
        r_cnt <= 'd0;
    else if(r_cnt == 99)
        r_cnt <= 'd0;
    else 
        r_cnt <= r_cnt + 'd1;
end

always@(posedge w_clk_50MHz,posedge w_rst)
begin
    if(w_rst) begin
        ri_Original_Data  <= 'd0;
        ri_Original_Valid <= 'd0;
    end else if(r_cnt == 10) begin
        ri_Original_Data  <= 256'h0001020304050607_08090a0b0c0d0e0f_0001020304050607_08090a0b0c0d0e0f;
        ri_Original_Valid <= 'd1;
    end else if(r_cnt == 70) begin
        ri_Original_Data  <= 256'h0001020304050607_08090a0b0c0d0e0f_0001020304050607_08090a0b0c0d0e0f;
        ri_Original_Valid <= 'd1;
    end else  begin
        ri_Original_Data  <= 'd0;
        ri_Original_Valid <= 'd0;
    end
end

endmodule
