`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/06 15:58:20
// Design Name: 
// Module Name: Coordinate_calculate
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


module Coordinate_calculate(

    input clk100M,
    input clk12_5M,
    
    input [15:0]Camera_data_out,
    input camera_href,
    input camera_vsync,
    input camera_pclk,
    
    input [1:0]Judge_mode,
    
    output [31:0]X_count_w,
    output [31:0]Y_count_w,
    output VS_flag_w,
    output VS_flag_change_w,
    output HS_flag_w,

    output [31:0]X_coordinate_w,
    output [31:0]Y_coordinate_w,
    output [31:0]Target_num_w,
    output [31:0]X_target_ave_estimate_w,
    output [31:0]Y_target_ave_estimate_w,
    output [31:0]Target_num_estimate_w,
    output Waiting_flag_w
    
    
    );
    parameter X_num = 640;
    parameter Y_num = 480;
    parameter Target_min_judge_green = 80;//像素计数阈值最小
    parameter Target_min_judge_yellow = 7;//像素计数阈值最小
    wire [31:0]Target_min_judge;
    
    parameter Area_edge_X = 100;
    parameter Area_edge_Y = 80;
    
    reg[31:0]X_coordinate = 0;
    reg[31:0]Y_coordinate = 0;
    
    reg [31:0]X_target_Sum = 0;
    wire [63:0]X_target_ave;
    reg [31:0]Y_target_Sum = 0;
    wire [63:0]Y_target_ave;
    reg [31:0]Target_num = 1;    //除数不能为0

    reg [31:0]X_target_Sum_estimate = 0;
    wire [63:0]X_target_ave_estimate_div;
    wire [31:0]X_target_ave_estimate;
    reg [31:0]Y_target_Sum_estimate = 0;
    wire [63:0]Y_target_ave_estimate_div;
    wire [31:0]Y_target_ave_estimate;
    reg [31:0]Target_num_estimate = 1;    //除数不能为0
    
    reg [31:0]Target_count = 1;
    
    wire [1:0]Video_state;
    reg VS_flag = 0;
    reg HS_flag = 0;
    reg Judge_threshold = 0;
    reg [31:0]X_count = 0;
    reg [31:0]Y_count = 0;
    reg VS_flag_change= 0;
    
    reg [31:0]Edge_X_left = 0;
    reg [31:0]Edge_X_right = 0;
    reg [31:0]Edge_Y_up = 0;
    reg [31:0]Edge_Y_down = 0;
    reg flag_edge_ok = 0;
    reg Waiting_flag = 0;

    assign X_target_ave_estimate = X_target_ave_estimate_div[63:32];
    assign Y_target_ave_estimate = Y_target_ave_estimate_div[63:32];    
    assign Video_state = {camera_href,camera_vsync};
    
    assign Target_min_judge = (Judge_mode == 2'b00 || Judge_mode == 2'b01)? Target_min_judge_green : Target_min_judge_yellow;
    assign X_coordinate_w = (Waiting_flag == 0) ? X_coordinate : 320;
    assign Y_coordinate_w = (Waiting_flag == 0) ? Y_coordinate : 240;
    assign Target_num_w = Target_num;
    assign X_target_ave_estimate_w = X_target_ave_estimate;
    assign Y_target_ave_estimate_w = Y_target_ave_estimate;
    assign Target_num_estimate_w = Target_num_estimate;

        assign X_count_w = X_count;
        assign Y_count_w = Y_count;
        assign VS_flag_w = VS_flag;
        assign VS_flag_change_w = VS_flag_change;
        assign HS_flag_w = HS_flag;
        
        assign Waiting_flag_w = Waiting_flag;

    always@(posedge clk12_5M)
        begin
            case(Video_state)
                2'b10:  //数据有效
                    begin
                        X_count <= X_count + 1; 
                        HS_flag <= 0;
                        VS_flag_change <= 0;
                        
                        case(Judge_mode)
                        // G > 1.3*R  G > 1.2*B   Suitable for green ball
                            2'b00: Judge_threshold <= ({1'b0,Camera_data_out[9:5]} > ((44 * Camera_data_out[14:10])>>5) && 
                                   {1'b0,Camera_data_out[9:5]} > ((38 * Camera_data_out[4:0])>>5)) ? 1 : 0; 
                        // G > 1.3*R  G > 1.2*B   Suitable for green ball
                            2'b01: Judge_threshold <= ({1'b0,Camera_data_out[9:5]} > ((43 * Camera_data_out[14:10])>>5) && 
                                   {1'b0,Camera_data_out[9:5]} > ((38 * Camera_data_out[4:0])>>5)) ? 1 : 0; 
                        // R > 1.5*B  R < 2.3*B  R > G  R < 1.2*G Suitable for YELLOW ball
                            2'b10: Judge_threshold <= 
                                   ({1'b0,Camera_data_out[14:10]} > ((3 * Camera_data_out[4:0])>>1) && 
                                   {1'b0,Camera_data_out[14:10]} < ((74 * Camera_data_out[4:0])>>5) &&
                                   {1'b0,Camera_data_out[14:10]} > (32*(Camera_data_out[9:5])>>5)   &&
                                   {1'b0,Camera_data_out[14:10]} < ((38*(Camera_data_out[9:5]))>>5)) ? 1 : 0; 
                        // R > 1.5*B  R < 2.3*B  R > G  R < 1.2*G Suitable for YELLOW ball
                                       2'b11: Judge_threshold <= 
                                              ({1'b0,Camera_data_out[14:10]} > ((3 * Camera_data_out[4:0])>>1) && 
                                              {1'b0,Camera_data_out[14:10]} < ((74 * Camera_data_out[4:0])>>5) &&
                                              {1'b0,Camera_data_out[14:10]} > (32*(Camera_data_out[9:5])>>5)   &&
                                              {1'b0,Camera_data_out[14:10]} < ((38*(Camera_data_out[9:5]))>>5)) ? 1 : 0; 
                        endcase
                        
                           
                        Edge_X_left <= (X_target_ave_estimate > Area_edge_X) ? (X_target_ave_estimate - Area_edge_X) : 0;
                        Edge_X_right <= (X_target_ave_estimate + Area_edge_X >= X_num) ? X_num : (X_target_ave_estimate + Area_edge_X) ;
                        Edge_Y_up <= (Y_target_ave_estimate > Area_edge_Y) ? (Y_target_ave_estimate - Area_edge_Y) : 0;
                        Edge_Y_down <= (Y_target_ave_estimate + Area_edge_Y >= Y_num) ? Y_num : (Y_target_ave_estimate + Area_edge_Y) ;
                        
                        flag_edge_ok <= (X_count < Edge_X_right && X_count > Edge_X_left && Y_count < Edge_Y_down && Y_count > Edge_Y_up) ? 1 : 0;
                        
                        if(VS_flag == 0 && Judge_threshold == 1)
                            begin
                                X_target_Sum_estimate <= X_target_Sum_estimate + X_count;
                                Y_target_Sum_estimate <= Y_target_Sum_estimate + Y_count;
                                Target_num_estimate <= Target_num_estimate + 1;
                            end
                        else if(VS_flag == 1 && Judge_threshold == 1 && flag_edge_ok == 1)
                            begin
                                X_target_Sum <= X_target_Sum + X_count;
                                Y_target_Sum <= Y_target_Sum + Y_count;
                                Target_num <= Target_num + 1;
                                Target_count <= Target_num;
                            end
                        else
                            begin
                                X_target_Sum <= X_target_Sum;
                                Y_target_Sum <= Y_target_Sum;
                                Target_num <= Target_num;
                                X_target_Sum_estimate <= X_target_Sum_estimate;
                                Y_target_Sum_estimate <= Y_target_Sum_estimate;
                                Target_num_estimate <= Target_num_estimate;
                            end
                    end
                2'b00:  //行同步
                    begin
                        X_count <= 0;
                        flag_edge_ok <= 0;
                    
                        if(HS_flag == 0)
                            begin
                                Y_count <= Y_count + 1;
                                HS_flag <= 1;
                            end
                        else
                            begin
                                Y_count <= Y_count;
                                HS_flag <= HS_flag;
                            end
                    end
                2'b01,2'b11:  //场同步
                    begin
                    
                        VS_flag_change <= 1;                
                        HS_flag <= 0;
                        X_count <= 0;
                        Y_count <= 0;  
                        flag_edge_ok <= 0;                      
                        
                        X_target_Sum <= 0;
                        Y_target_Sum <= 0;
                        Target_num <= 1;    //除数不能为0
                        Waiting_flag <= (Target_count < Target_min_judge)? 1 : 0;  //如果记录目标像素数量小于阈值 则启动等待标志

                        if(VS_flag == 1 && VS_flag_change == 0)  //仅仅执行一次，防止VS_flag切换导致的两个都执行
                            begin
                                X_target_Sum_estimate <= 0;
                                Y_target_Sum_estimate <= 0;
                                Target_num_estimate <= 1;    //除数不能为0
                                
                                X_coordinate <= (X_target_ave[63:32] == 0)? X_coordinate : X_target_ave[63:32];
                                Y_coordinate <= (Y_target_ave[63:32] == 0)? Y_coordinate : Y_target_ave[63:32];
                            end
                        else
                            begin
                                X_target_Sum_estimate <= X_target_Sum_estimate;
                                Y_target_Sum_estimate <= Y_target_Sum_estimate;
                                Target_num_estimate <= Target_num_estimate;    //除数不能为0
                                
                                X_coordinate <= X_coordinate;
                                Y_coordinate <= Y_coordinate;                                    
                            end
                    
                        if(VS_flag_change == 0)
                            begin
                                VS_flag <= ~VS_flag;
                            end
                        else
                            begin
                                VS_flag <= VS_flag;
                            end
                    end
            endcase    
        end

            DIV_32_32 Divider_32_32_1 (
              .aclk(clk100M),                                      // input wire aclk
              .s_axis_divisor_tvalid(1'b1),    // input wire s_axis_divisor_tvalid
              .s_axis_divisor_tdata(Target_num_estimate),      // input wire [31 : 0] s_axis_divisor_tdata
              .s_axis_dividend_tvalid(1'b1),  // input wire s_axis_dividend_tvalid
              .s_axis_dividend_tdata(X_target_Sum_estimate),    // input wire [31 : 0] s_axis_dividend_tdata
              .m_axis_dout_tvalid(),          // output wire m_axis_dout_tvalid
              .m_axis_dout_tdata(X_target_ave_estimate_div)            // output wire [63 : 0] m_axis_dout_tdata
            );

            DIV_32_32 Divider_32_32_2 (
              .aclk(clk100M),                                      // input wire aclk
              .s_axis_divisor_tvalid(1'b1),    // input wire s_axis_divisor_tvalid
              .s_axis_divisor_tdata(Target_num_estimate),      // input wire [31 : 0] s_axis_divisor_tdata
              .s_axis_dividend_tvalid(1'b1),  // input wire s_axis_dividend_tvalid
              .s_axis_dividend_tdata(Y_target_Sum_estimate),    // input wire [31 : 0] s_axis_dividend_tdata
              .m_axis_dout_tvalid(),          // output wire m_axis_dout_tvalid
              .m_axis_dout_tdata(Y_target_ave_estimate_div)            // output wire [63 : 0] m_axis_dout_tdata
            );

            DIV_32_32 Divider_32_32_3 (
              .aclk(clk100M),                                      // input wire aclk
              .s_axis_divisor_tvalid(1'b1),    // input wire s_axis_divisor_tvalid
              .s_axis_divisor_tdata(Target_num),      // input wire [31 : 0] s_axis_divisor_tdata
              .s_axis_dividend_tvalid(1'b1),  // input wire s_axis_dividend_tvalid
              .s_axis_dividend_tdata(X_target_Sum),    // input wire [31 : 0] s_axis_dividend_tdata
              .m_axis_dout_tvalid(),          // output wire m_axis_dout_tvalid
              .m_axis_dout_tdata(X_target_ave)            // output wire [63 : 0] m_axis_dout_tdata
            );

            DIV_32_32 Divider_32_32_4 (
              .aclk(clk100M),                                      // input wire aclk
              .s_axis_divisor_tvalid(1'b1),    // input wire s_axis_divisor_tvalid
              .s_axis_divisor_tdata(Target_num),      // input wire [31 : 0] s_axis_divisor_tdata
              .s_axis_dividend_tvalid(1'b1),  // input wire s_axis_dividend_tvalid
              .s_axis_dividend_tdata(Y_target_Sum),    // input wire [31 : 0] s_axis_dividend_tdata
              .m_axis_dout_tvalid(),          // output wire m_axis_dout_tvalid
              .m_axis_dout_tdata(Y_target_ave)            // output wire [63 : 0] m_axis_dout_tdata
            );
              

endmodule
