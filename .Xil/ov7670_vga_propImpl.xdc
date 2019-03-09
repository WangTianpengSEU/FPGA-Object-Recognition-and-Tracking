set_property SRC_FILE_INFO {cfile:h:/Desktop/OV7670_XY_ok1/OV7670_1/OV7670_1.srcs/sources_1/ip/clk_wiz_0_1/clk_wiz_0.xdc rfile:../OV7670_1.srcs/sources_1/ip/clk_wiz_0_1/clk_wiz_0.xdc id:1 order:EARLY scoped_inst:clk_wiz_0/inst} [current_design]
set_property SRC_FILE_INFO {cfile:H:/Desktop/OV7670_XY_ok1/OV7670_1/OV7670_1.srcs/constrs_1/new/ov7670_1.xdc rfile:../OV7670_1.srcs/constrs_1/new/ov7670_1.xdc id:2} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:56 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.10000000000000001
set_property src_info {type:XDC file:2 line:22 export:INPUT save:INPUT read:READ} [current_design]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets camera_pclk_IBUF]
