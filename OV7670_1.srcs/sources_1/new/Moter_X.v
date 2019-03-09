`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/16 13:45:46
// Design Name: 
// Module Name: Moter_X
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



module Moter_X(
        
        input clk_100M,
        input [31:0]X_coordinate,
        
        output reg PWM
    
        );
        
        parameter angle_min_num = 50_000;
        parameter angle_mid_num = 150_000;
        parameter angle_max_num = 250_000;
        parameter angle_period_num = 300_000;
        parameter clk_PWM_num_half = 500_000;  //100HZ
        parameter clk_PWM_num = clk_PWM_num_half + clk_PWM_num_half;  
        
        reg clk_PWM = 0;
        reg [31:0]clk_PWM_count = 0;
        reg [31:0]angle_count = angle_mid_num;
        reg [31:0]angle_count_c = 0;
        reg [31:0]PWM_count = 0;
        
        reg [31:0]Add_speed_K = 0;
        reg [31:0]Sub_speed_K = 0;
        
        reg [4:0]Add_P_parameter = 7;  //右移
        reg [4:0]Sub_P_parameter = 7;  //右移        
        parameter Error_rank_1 = ((55*(angle_max_num - angle_min_num)) >> 7);
        parameter Error_rank_2 = ((angle_max_num - angle_min_num) >> 3);
        parameter Error_rank_3 = ((angle_max_num - angle_min_num) >> 4);
        parameter P_ratio_1 = 8;
        parameter P_ratio_2 = 8;
        parameter P_ratio_3 = 9;        
        parameter P_ratio_4 = 10;        
        parameter X_error_threshold = (3*(angle_max_num - angle_min_num) >> 6);
        reg [31:0]X_error = 0;
              
        always@(posedge clk_100M)
            begin
                X_error <= (X_coordinate > angle_min_num) ? (X_coordinate - angle_min_num) : (angle_min_num - X_coordinate);
                if(X_error > Error_rank_1)
                    begin
                        Add_P_parameter <= P_ratio_1;
                        Sub_P_parameter <= P_ratio_1;
                    end
                else if(X_error > Error_rank_2)
                    begin
                        Add_P_parameter <= P_ratio_2;
                        Sub_P_parameter <= P_ratio_2;
                    end
                else if(X_error > Error_rank_3)
                    begin
                        Add_P_parameter <= P_ratio_3;
                        Sub_P_parameter <= P_ratio_3;
                    end
                else 
                    begin
                        Add_P_parameter <= P_ratio_4;
                        Sub_P_parameter <= P_ratio_4;
                    end
            end

        
        always@(posedge clk_100M)
            begin
                if(clk_PWM_count < clk_PWM_num_half)
                    begin
                        clk_PWM_count <= clk_PWM_count + 1;
                        clk_PWM <= 0;
                    end
                else if(clk_PWM_count < clk_PWM_num)
                    begin
                        clk_PWM_count <= clk_PWM_count + 1;
                        clk_PWM <= 1;
                    end
                else
                    begin
                        clk_PWM_count <= 0;
                    end
            end
            
            always@(posedge clk_PWM)
                begin
                if(X_error > X_error_threshold)
                    begin
                    if(X_coordinate <= angle_mid_num)
                        begin
                           angle_count <= (angle_count > (angle_min_num + Sub_speed_K)) ? (angle_count - Sub_speed_K) : angle_count; //加法还是减法要根据实际调整
                        end
                    else
                        begin
                           angle_count <= (angle_count < angle_max_num) ? (angle_count + Add_speed_K) : angle_count; //加法还是减法要根据实际调整
                        end
                    end
                else
                    begin
                        angle_count <= angle_count;
                    end
                end
                
            always@(posedge clk_100M)
                begin
                    Add_speed_K <= (X_coordinate > angle_mid_num) ? ((3 * (X_coordinate - angle_mid_num)) >> Add_P_parameter) : 0;
                    Sub_speed_K <= (X_coordinate <= angle_mid_num) ?  ((3 * (angle_mid_num - X_coordinate)) >> Sub_P_parameter) : 0;
                end
                
            
            always@(posedge clk_100M)
                    begin
                        if(PWM_count < angle_count)
                            begin
                                PWM <= 1;
                                PWM_count <= PWM_count + 1;
                            end
                        else if(PWM_count < angle_period_num)
                            begin
                                PWM <= 0;
                                PWM_count <= PWM_count + 1;
                            end
                        else
                            begin
                                PWM_count <= 0;
                            end
                        
                    end
                    
    endmodule
