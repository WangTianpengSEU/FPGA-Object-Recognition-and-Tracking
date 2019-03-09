`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/16 15:21:56
// Design Name: 
// Module Name: Motor_position_detect
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


module Motor_position_detect(

    input clk_100M,

    output [31:0]X_OUT,
    output [31:0]Y_OUT,

    input [31:0]X_coordinate_w,
    input [31:0]Y_coordinate_w
    
    );
    
    parameter X_size_mul = 2;
    parameter X_size_div = 2;
    parameter Y_size_mul = 6;
    parameter Y_size_div = 2;
    
    parameter X_pixel = 640;
    parameter Y_pixel = 480;

    parameter Div_motor = 200_000;  // 250_000 - 50_000
    parameter Rdge_X_left = 50000; //  50_000 + (Div_motor * (1024 - 640) >> 10) >> 1;
    parameter Rdge_Y_up = 50000; //  50_000 + (Div_motor * (1024 - 480) >> 10) >> 1;
    
    assign X_OUT = (Rdge_X_left + ((X_coordinate_w[9:0] * Div_motor * 26 ) >> 14));
    assign Y_OUT = (Rdge_Y_up + ((Y_coordinate_w[8:0] * Div_motor * 34) >> 14));
      

endmodule
