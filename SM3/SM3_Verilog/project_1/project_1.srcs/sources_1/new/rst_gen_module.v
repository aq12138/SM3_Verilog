`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         维瓦（昆明）电子科技有限公司
// Engineer:        于奇
// 
// Create Date:     2024/05/27 13:13:45
// Design Name:     rst_gen_module
// Module Name:     XC7Z035_TOP
// Project Name:    project_1
// Target Devices:  XC7Z035FFG676-2
// Tool Versions:   VIVADO2018.3
// Description:     复位产生模块
//                  
// Dependencies:    无
// 
// Revision:        V0.1
// Revision 0.01 - File Created
// Additional Comments: 开源代码；概不负责；
// 
//////////////////////////////////////////////////////////////////////////////////

module rst_gen_module#(
    parameter       P_RST_CYCLE     =   1   
)(
    input           i_rst                   ,
    input           i_clk                   ,
    output          o_rst                   
);

reg                 ro_rst=1                ;
reg  [15 :0]         r_cnt=0                 ;

assign              o_rst = ro_rst          ;

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        r_cnt <= 'd0;
    else if(r_cnt == P_RST_CYCLE - 1 || P_RST_CYCLE == 0)
        r_cnt <= r_cnt;
    else 
        r_cnt <= r_cnt + 1;
end

always@(posedge i_clk)
begin
    if(r_cnt == P_RST_CYCLE - 1 || P_RST_CYCLE == 0)
        ro_rst <= 'd0;
    else 
        ro_rst <= 'd1;
end

endmodule
