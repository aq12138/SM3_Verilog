`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         维瓦（昆明）电子科技有限公司
// Engineer:        于奇
// 
// Create Date:     2024/05/27 13:13:45
// Design Name:     SM3_Encrypt
// Module Name:     XC7Z035_TOP
// Project Name:    project_1
// Target Devices:  XC7Z035FFG676-2
// Tool Versions:   VIVADO2018.3
// Description:     SM3算法模块
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
module SM3_Encrypt#(
    parameter       PARALLEL_NUM = 4        //并行线程:1,2,4,8,16,32,64
)(
    input           i_clk               ,   //输入时钟
    input           i_rst               ,   //输入复位

    input  [255:0]  i_Original_Data     ,   //输入待加密数据
    input           i_Original_Valid    ,   //输入有效
    output [255:0]  o_Encrypt_Data      ,   //输出SM3摘要
    output          o_Encrypt_Valid         //输出有效
);

localparam          P_ITERATOR_CYCLE = 64/PARALLEL_NUM;

reg  [511:0]        r_padding_data              ;
reg                 r_padding_valid             ;
reg                 r_extend_valid              ;
reg  [4223:0]       r_extend_data               ;
reg  [255 :0]       r_iterator_V[0:64]          ;    
reg  [255 :0]       ro_Encrypt_Data             ;
reg                 ro_Encrypt_Valid            ;
reg  [15  :0]       r_out_cnt                   ;
reg  [63  :0]       r_cmp_valid                 ;

wire [4223:0]       w_extend_data               ;
wire                w_extend_valid              ;
wire [255 :0]       w_iterator_in_V[0:63]       ;
wire [255 :0]       w_iteratot_out_V[0:63]      ;  

assign o_Encrypt_Data  =    ro_Encrypt_Data     ;
assign o_Encrypt_Valid =    ro_Encrypt_Valid    ;

/*----Padding-----*/
always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst) begin
        r_padding_data <= 'd0;
        r_padding_valid <= 'd0;
    end else begin 
        r_padding_data <= {i_Original_Data,1'b1,191'd0,64'd256};
        r_padding_valid <= i_Original_Valid;
    end
end

/*----Extend-----*/
Data_Extend Data_Extend_u0(
    .i_clk              (i_clk              ),
    .i_rst              (i_rst              ),
    .i_padding_data     (r_padding_data     ),
    .i_padding_valid    (r_padding_valid    ),
    .o_extend_data      (w_extend_data      ),
    .o_extend_valid     (w_extend_valid     )
);

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst) begin
        r_extend_valid <= 'd0;
        r_extend_data <= 'd0;
    end else begin
        r_extend_valid <= w_extend_valid;
        r_extend_data <= w_extend_data;
    end
end

/*----Iteration-----*/

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        r_cmp_valid[0] <= 'd0;
    else 
        r_cmp_valid[0] <= w_extend_valid;
end

genvar g_iteri;
genvar g_iterj;
generate
    for(g_iteri = 0 ; g_iteri < P_ITERATOR_CYCLE ; g_iteri = g_iteri + 1)
    begin:iterator_cycle

        assign w_iterator_in_V[g_iteri*PARALLEL_NUM] = r_iterator_V[g_iteri*PARALLEL_NUM];
        // assign w_iterator_in_V[32] = r_iterator_V[32];

    if(g_iteri != 0)
        always@(posedge i_clk,posedge i_rst)
        begin
            if(i_rst)
                r_cmp_valid[g_iteri] <= 'd0;
            else if(r_cmp_valid[g_iteri - 1])
                r_cmp_valid[g_iteri] <= 'd1;
            else 
                r_cmp_valid[g_iteri] <= 'd0;
        end
    
        for(g_iterj = 0 ; g_iterj < PARALLEL_NUM ; g_iterj = g_iterj + 1)
        begin:iterator_parallel
            iterator_module iterator_module_ux(
                .i_V             (w_iterator_in_V[g_iterj + g_iteri * PARALLEL_NUM]),
                .i_B             (r_extend_data     ),
                .i_j             (g_iterj + g_iteri * PARALLEL_NUM),
                .o_V1            (w_iteratot_out_V[g_iterj + g_iteri * PARALLEL_NUM])
            );
            if(g_iterj < PARALLEL_NUM - 1) 
                assign w_iterator_in_V[g_iterj + 1 + g_iteri * PARALLEL_NUM] = w_iteratot_out_V[g_iterj + g_iteri * PARALLEL_NUM];
        
            always@(posedge i_clk)
            begin
                    r_iterator_V[g_iterj + 1 + g_iteri * PARALLEL_NUM] <= w_iteratot_out_V[g_iterj + g_iteri * PARALLEL_NUM];
            end
        
        end
    end
endgenerate



always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        r_iterator_V[0] <= 256'h7380166f4914b2b9172442d7da8a0600_a96f30bc163138aae38dee4db0fb0e4e;
    else 
        r_iterator_V[0] <= r_iterator_V[0];
end

/*----output----*/
always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst) begin
        ro_Encrypt_Data  <= 'd0;
    end else begin
        ro_Encrypt_Data  <= w_iteratot_out_V[63] ^ r_iterator_V[0];
    end
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        ro_Encrypt_Valid <= 'd0;
    else case(P_ITERATOR_CYCLE)
        1       :ro_Encrypt_Valid <= w_extend_valid;
        2       :ro_Encrypt_Valid <= r_cmp_valid[0];
        4       :ro_Encrypt_Valid <= r_cmp_valid[2];
        8       :ro_Encrypt_Valid <= r_cmp_valid[6];
        16      :ro_Encrypt_Valid <= r_cmp_valid[14];
        32      :ro_Encrypt_Valid <= r_cmp_valid[30];
        64      :ro_Encrypt_Valid <= r_cmp_valid[62];
    endcase 
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        r_out_cnt <= 'd0;
    else if(r_out_cnt == P_ITERATOR_CYCLE - 1)
        r_out_cnt <= 'd0;
    else if(w_extend_valid | r_out_cnt)
        r_out_cnt <= r_out_cnt + 1;
    else 
        r_out_cnt <= r_out_cnt;
end


endmodule
