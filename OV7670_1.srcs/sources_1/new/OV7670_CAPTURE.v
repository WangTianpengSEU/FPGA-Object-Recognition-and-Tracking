`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/04 14:20:47
// Design Name: 
// Module Name: OV7670_CAPTURE
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



module OV7670_CAPTURE (
        input rst, pclk , href , vsync,
        input [7:0] din ,
        
        output [15:0]data16,
        output reg [11:0] buff_dout,
        output reg  buff_wr,
        output reg [18:0] buff_addr

    );


    //处理输入的8位数据。
    wire  [7:0] data8 = din ;
    wire  wr8 = href ;

    //8位转16位，生成wr16,data16
    reg [7:0] t8 ;
    reg t8_valid ;
    wire wr16 ;
//    wire [15:0] data16 ;

    always @ (posedge pclk)if ( wr8  )t8 <= data8;
    always @ (posedge pclk)if ( rst | vsync ) t8_valid<=0;else if ( wr8 ) t8_valid <= ~t8_valid;

    assign wr16 = t8_valid & wr8 ;
    assign data16 = { t8[7:0] , data8[7:0] } ;

    // 16位转12位生成wr12,data12
    wire wr12 = wr16;
    wire [11:0] data12 ={  data16[15:12] ,  data16[10:7] ,  data16[4:1] } ;

    //产生写BUFFER的信号以及内容。

    //output reg [11:0] buff_dout,
    //output reg  buff_wr,
    always@ (posedge pclk)  buff_wr<= wr12 ;
    always@ (posedge pclk)  buff_dout<= data12 ;

    //生成地址， buff_addr

    //output reg [18:0] buff_addr
    reg  vsyncr ;always@(posedge pclk)vsyncr<=vsync ;
    //这一级延迟仅仅为为了改善时序。

    always@ (posedge pclk)
        if ( vsyncr | rst )buff_addr<=0;else
    if (buff_wr)buff_addr<=buff_addr+1;

    //因为最终输出给缓冲区的数据相对于摄像头的输出，已经延迟了2个周期。
    //而VSYNC只延迟了一个周期，要考察vsync是否造成时序不对应。
    //答案是 ： 因为VSYNC在HREF无效后许多周期出现，所以不必考虑！

endmodule
