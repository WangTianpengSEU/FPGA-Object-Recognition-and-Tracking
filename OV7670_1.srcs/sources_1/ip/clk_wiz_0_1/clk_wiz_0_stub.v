// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.2 (win64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
// Date        : Wed Aug 08 02:09:20 2018
// Host        : DESKTOP-AI64EI3 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               H:/Desktop/OV7670_XY_ok1/OV7670_1/OV7670_1.srcs/sources_1/ip/clk_wiz_0_1/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk_in1, clk_out1, clk_out2, clk_out3, clk_out4)
/* synthesis syn_black_box black_box_pad_pin="clk_in1,clk_out1,clk_out2,clk_out3,clk_out4" */;
  input clk_in1;
  output clk_out1;
  output clk_out2;
  output clk_out3;
  output clk_out4;
endmodule
