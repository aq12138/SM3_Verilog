`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         维瓦（昆明）电子科技有限公司
// Engineer:        于奇
// 
// Create Date:     2024/05/27 13:13:45
// Design Name:     iterator_module
// Module Name:     XC7Z035_TOP
// Project Name:    project_1
// Target Devices:  XC7Z035FFG676-2
// Tool Versions:   VIVADO2018.3
// Description:     迭代器
//                  
// Dependencies:    无
// 
// Revision:        V0.1
// Revision 0.01 - File Created
// Additional Comments: 开源代码；概不负责；
// 
//////////////////////////////////////////////////////////////////////////////////


module iterator_module(
    input  [255 :0]         i_V             ,
    input  [4223:0]         i_B             ,
    input  [31  :0]         i_j             ,
    output [255 :0]         o_V1            
);      


function [31:0] P0;
    input [31 :0] X;
begin
    P0 = X ^ {X[22:0],X[31:23]} ^ {X[14:0],X[31:15]};
end
endfunction

function [31:0] FFj;
    input [31 :0] X;
    input [31 :0] Y;
    input [31 :0] Z;
    input [31 :0] j;    
begin
    if(j<16)
        FFj = X ^ Y ^ Z;
    else 
        FFj = (X & Y) | (X & Z) | (Y & Z);
end
endfunction

function [31:0] GGj;
    input [31 :0] X;
    input [31 :0] Y;
    input [31 :0] Z;
    input [31 :0] j;    
begin
    if(j<16)
        GGj = X ^ Y ^ Z;
    else 
        GGj = (X & Y) | (~X & Z);
end
endfunction

function [31:0] Tj;
    input [31:0] j;
begin
    if(j < 16)
        Tj = 32'h79cc4519;
    else 
        Tj = 32'h7a879d8a;
end
endfunction
wire [31:0]                 w_ss1           ;
wire [31:0]                 w_ss2           ;
wire [31:0]                 w_tt1           ;
wire [31:0]                 w_tt2           ;
wire [31:0]                 w_Wj [0:67]     ;
wire [31:0]                 w_Wj_[0:63]     ;
wire [31:0]                 w_A             ;
wire [31:0]                 w_B             ;
wire [31:0]                 w_C             ;
wire [31:0]                 w_D             ;
wire [31:0]                 w_E             ;
wire [31:0]                 w_F             ;
wire [31:0]                 w_G             ;
wire [31:0]                 w_H             ;
wire [31:0]                 w_A_            ;
wire [31:0]                 w_B_            ;
wire [31:0]                 w_C_            ;
wire [31:0]                 w_D_            ;
wire [31:0]                 w_E_            ;
wire [31:0]                 w_F_            ;
wire [31:0]                 w_G_            ;
wire [31:0]                 w_H_            ;
wire [31:0]                 w_ss1_mid0      ;
wire [31:0]                 w_Tj            ;
wire [31:0]                 w_Tj_y[0:63]    ;

genvar g_Wi;
generate 
    for(g_Wi = 0 ; g_Wi < 68 ; g_Wi = g_Wi + 1)
    begin:Gen_Wj
        assign w_Wj[g_Wi] = i_B[g_Wi*32 + 31:g_Wi*32];
    end
endgenerate

assign w_Tj_y[0] = w_Tj;
assign w_Tj_y[32] = w_Tj;

genvar g_Wj;
generate 
    for(g_Wj = 0 ; g_Wj < 64 ; g_Wj = g_Wj + 1)
    begin:Gen_Wj_
        assign w_Wj_[g_Wj] = i_B[2176 + g_Wj *32 + 31:2176 + g_Wj *32];

        if(g_Wj > 0 && g_Wj <32)
            assign w_Tj_y[g_Wj] = {w_Tj[31 - g_Wj : 0],w_Tj[31:31 - (g_Wj - 1)]};
        else if(g_Wj >32)
            assign w_Tj_y[g_Wj] = {w_Tj[31 - (g_Wj - 32) : 0],w_Tj[31:31 - ((g_Wj - 32) - 1)]};
        
    end
endgenerate


assign w_H = i_V[31 :  0];
assign w_G = i_V[63 : 32];
assign w_F = i_V[95 : 64];
assign w_E = i_V[127: 96];
assign w_D = i_V[159:128];
assign w_C = i_V[191:160];
assign w_B = i_V[223:192];
assign w_A = i_V[255:224];
assign w_Tj = Tj(i_j);
assign w_ss1_mid0 = {w_A[19:0],w_A[31:20]} + w_E + w_Tj_y[i_j];


assign w_ss1 = {w_ss1_mid0[24:0],w_ss1_mid0[31:25]};
assign w_ss2 = w_ss1 ^ {w_A[19:0],w_A[31:20]};
assign w_tt1 = FFj(w_A,w_B,w_C,i_j) + w_D + w_ss2 + w_Wj_[i_j];
assign w_tt2 = GGj(w_E,w_F,w_G,i_j) + w_H + w_ss1 + w_Wj[i_j];
assign w_D_  = w_C;
assign w_C_  = {w_B[22:0],w_B[31:23]};
assign w_B_  = w_A;
assign w_A_  = w_tt1;
assign w_H_  = w_G;
assign w_G_  = {w_F[12:0],w_F[31:13]};
assign w_F_  = w_E;
assign w_E_  = P0(w_tt2);

assign o_V1 = {w_A_,w_B_,w_C_,w_D_,w_E_,w_F_,w_G_,w_H_};

endmodule
