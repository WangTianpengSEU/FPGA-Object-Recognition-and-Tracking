`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/04 14:14:55
// Design Name: 
// Module Name: cfg_ov7670
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


module cfg_ov7670(

        output       OV7670_SIOC,
        inout        OV7670_SIOD,
        output       OV7670_RESET,
        output       OV7670_PWDN,
        output       OV7670_XCLK,
        input        CLK25M ,rst ,
        output       ERROR
    );

    assign OV7670_RESET = 1'b1 ;

    assign OV7670_PWDN = 1'b0 ;

    pullup up (OV7670_SIOD);

    wire clk = CLK25M ;

    //reg[1:0] c ;always @ (posedge clk) c<=c+1;
    assign OV7670_XCLK = CLK25M ;  //25M clock out

    wire vio_key = 0 ;
    parameter [7:0] par_camera_address = 8'h42;
    wire [7:0]camera_address = par_camera_address ;
    //wire err ;
    /*
    ILA_wrapper ILA (
       .clk( clk ),
       .probe0( OV7670_SIOC ),
       .probe1( OV7670_SIOD ),
       .probe_out0( vio_key ),
       .probe_out1(  camera_address ),
       .probe_in0(err)
       );
     */
    wire [15:0 ] cfg_d16 ;
    wire valid , ready ;

    cfg_reg I_CFG_REG  (
                .clk( clk ) ,
                .rst(rst) ,
                .dout( cfg_d16  ) ,
                .m_valid( valid ) ,
                .m_ready( ready )
            );

    SCCB_sender I_SCCB_sender(
                    .clk( clk ),
                    .rst(srt),
                    .siod( OV7670_SIOD ),
                    .sioc( OV7670_SIOC ),
                    .ready( ready ),
                    .valid( valid  ),
                    .id( camera_address  ),
                    .sub_addr( cfg_d16[15:8] ),
                    .value( cfg_d16[7:0]  ),
                    .error( ERROR )
                );

endmodule
