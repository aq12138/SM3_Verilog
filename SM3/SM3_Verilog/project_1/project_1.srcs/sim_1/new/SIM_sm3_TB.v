`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/27 15:12:07
// Design Name: 
// Module Name: SIM_sm3_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SIM_sm3_TB();

reg clk,rst;

initial begin
    rst = 1;
    #100 @(posedge clk) rst = 0;
end


always 
begin
    clk = 0;
    #10;
    clk = 1;
    #10;
end

reg  [255:0]        ri_Original_Data    ;
reg                 ri_Original_Valid   ;
wire [255:0]        w_Encrypt_Data      ;
wire                w_Encrypt_Valid     ;


SM3_Encrypt#(
    .PARALLEL_NUM        (32                )   
)
SM3_Encrypt_u0
(
    .i_clk               (clk               ),
    .i_rst               (rst               ),

    .i_Original_Data     (ri_Original_Data  ),
    .i_Original_Valid    (ri_Original_Valid ),
    .o_Encrypt_Data      (w_Encrypt_Data    ),
    .o_Encrypt_Valid     (w_Encrypt_Valid   )
);

task sm3_input_task(input [255:0] i_data);
begin:sm3_input_task_task
    // ri_Original_Data  <= 256'd0;
    // ri_Original_Valid <= 'd0;
    // @(posedge clk);
    ri_Original_Data  <= i_data;
    ri_Original_Valid <= 'd1;
    @(posedge clk);
    ri_Original_Data  <= 256'd0;
    ri_Original_Valid <= 'd0;
    @(posedge clk);
    ri_Original_Data  <= 256'd0;
    ri_Original_Valid <= 'd0;
    // @(posedge clk);
    // ri_Original_Data  <= 256'd0;
    // ri_Original_Valid <= 'd0;
    // @(posedge clk);
    // ri_Original_Data  <= 256'd0;
    // ri_Original_Valid <= 'd0;
    // @(posedge clk);
    //     ri_Original_Data  <= 256'd0;
    // ri_Original_Valid <= 'd0;
    // @(posedge clk);
    // ri_Original_Data  <= 256'd0;
    // ri_Original_Valid <= 'd0;
    // @(posedge clk);
    // ri_Original_Data  <= 256'd0;
    // ri_Original_Valid <= 'd0;
    // @(posedge clk);
    // ri_Original_Data  <= 256'd0;
    // ri_Original_Valid <= 'd0;
    // @(posedge clk);
    //     ri_Original_Data  <= 256'd0;
    // ri_Original_Valid <= 'd0;
    // @(posedge clk);
    // ri_Original_Data  <= 256'd0;
    // ri_Original_Valid <= 'd0;
    // @(posedge clk);
    // ri_Original_Data  <= 256'd0;
    // ri_Original_Valid <= 'd0;
    // @(posedge clk);
    // ri_Original_Data  <= 256'd0;
    // ri_Original_Valid <= 'd0;
    // @(posedge clk);
    //     ri_Original_Data  <= 256'd0;
    // ri_Original_Valid <= 'd0;
    // @(posedge clk);
    // ri_Original_Data  <= 256'd0;
    // ri_Original_Valid <= 'd0;
    // @(posedge clk);
    // ri_Original_Data  <= 256'd0;
    // ri_Original_Valid <= 'd0;
    // @(posedge clk);
    
end
endtask

initial
begin
    ri_Original_Data  <= 256'd0;
    ri_Original_Valid <= 'd0;
    @(posedge clk);
    wait(!rst);
    repeat(10)@(posedge clk);;
    sm3_input_task(256'h0001020304050607_08090a0b0c0d0e0f_0001020304050607_08090a0b0c0d0e0f);
    sm3_input_task(256'h0001020304050607_08090a0b0c0d0e0f_0001020304050607_08090a0b0c0d0eff);
    // sm3_input_task(256'h0001020304050607_08090a0b0c0d0e0f_0001020304050607_08090a0b0c0d0e0f);
    // sm3_input_task(256'h0001020304050607_08090a0b0c0d0e0f_0001020304050607_08090a0b0c0d0eff);
    // sm3_input_task(256'h0001020304050607_08090a0b0c0d0e0f_0001020304050607_08090a0b0c0d0e0f);
    // sm3_input_task(256'h0001020304050607_08090a0b0c0d0e0f_0001020304050607_08090a0b0c0d0eff);
    // sm3_input_task(256'h0001020304050607_08090a0b0c0d0e0f_0001020304050607_08090a0b0c0d0e0f);
    // sm3_input_task(256'h0001020304050607_08090a0b0c0d0e0f_0001020304050607_08090a0b0c0d0eff);
    // sm3_input_task(256'h0001020304050607_08090a0b0c0d0e0f_0001020304050607_08090a0b0c0d0e0f);
    // sm3_input_task(256'h0001020304050607_08090a0b0c0d0e0f_0001020304050607_08090a0b0c0d0eff);

end


endmodule
