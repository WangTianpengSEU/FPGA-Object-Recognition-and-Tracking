`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    flash_ddr_vga 
//////////////////////////////////////////////////////////////////////////////////
module ov7670_vga(
   input clk100M,

	//Camera接口信号
	output camera_xclk,             //cmos externl clock
	
	output camera_pwdn,
	output camera_rst,
	input camera_pclk,              //cmos pxiel clock
    input camera_href,              //cmos hsync refrence
	input camera_vsync,             //cmos vsync
	input [7:0] camera_data,        //cmos data
	output i2c_sclk,                //cmos i2c clock
	inout i2c_sdat,	              //cmos i2c data
	
//	 //VGA的接口信号 
    input key1,
    input key_mode,
	output [3:0]            vga_r,
    output [3:0]            vga_g,
    output [3:0]            vga_b,
    output                  vga_hs,
    output                  vga_vs,
    
    input key2,
    input [1:0]Judge_mode,
    input ledmode,
    
    output reg[15:0]led,
        
    output reg PWM_X_w,
    output reg PWM_Y_w

		
    );
    
                   // 脉宽增加上舵机向上，减小上舵机向下
                   // 脉宽减小下舵机向左，增加下舵机向右
                   
                   parameter Initial_count_motor1 = 50_000_000;
                   parameter Initial_count_motor2 = 100_000_000;
                   reg [31:0]Initial_count = 0;
    wire PWM_X;
    wire PWM_Y;

    wire clk50M;
    wire vga_clk;
    wire clk12_5M;
    wire clk_ram;
    wire [15:0]Camera_data_out;
    wire [15:0]vga_data;
    wire [10:0] x_cnt;
    wire[9:0] y_cnt;
    wire hsync_de;
    wire vsync_de;
    wire [3:0]VGA_R;
    wire [3:0]VGA_G;
    wire [3:0]VGA_B;
    wire [16:0]addra;
    wire [16:0]addrb;
    wire [15:0]pixel_data;
    wire pixel_valid;
    
    wire [31:0]X_coordinate_w;
    wire [31:0]Y_coordinate_w;
    wire [31:0]Target_num_w;
    wire [31:0]X_target_ave_estimate_w;
    wire [31:0]Y_target_ave_estimate_w;
    wire [31:0]Target_num_estimate_w;
    wire [31:0]X_count_w;
    wire [31:0]Y_count_w;
    wire VS_flag_w;
    wire VS_flag_change_w;
    wire HS_flag_w;
    
    wire [31:0]X_OUT;
    wire [31:0]Y_OUT;
    
    wire Waiting_flag_w;  //阈值判断，控制电机转或停止

    assign camera_xclk=vga_clk;
    assign camera_pwdn = 0;
    assign camera_rst = 1'b1;
    assign vga_r = (key_mode)? VGA_R : vga_data[14:11];
    assign vga_g = (key_mode)? VGA_G : vga_data[9:6];
    assign vga_b = (key_mode)? VGA_B : vga_data[4:1];
    
    always@(clk100M)
        begin
            led[15:8] <= (ledmode == 0)? X_coordinate_w[9:2] : 0;
            led[7:0] <= (ledmode == 0)? Y_coordinate_w[9:2] : 0;
        end
        
        always@(posedge clk100M)
            begin
                if(Initial_count <= Initial_count_motor1)
                    begin
                        PWM_X_w <= (Waiting_flag_w == 1) ? PWM_X_w : PWM_X;
                        PWM_Y_w <= 0;
                        Initial_count <= Initial_count + 1;
                    end
                else if(Initial_count > Initial_count_motor1 && Initial_count <= Initial_count_motor2)
                    begin
                        PWM_X_w <= 0;
                        PWM_Y_w <= (Waiting_flag_w == 1) ? PWM_Y_w : PWM_Y;
                        Initial_count <= Initial_count + 1;
                    end
                else
                    begin
                        PWM_X_w <= (Waiting_flag_w == 1) ? PWM_X_w : PWM_X;
                        PWM_Y_w <= (Waiting_flag_w == 1) ? PWM_Y_w : PWM_Y;
                        Initial_count <= Initial_count;
                    end
            end
    
        clk_wiz_0 clk_wiz_0
           (
           // Clock in ports
            .clk_in1(clk100M),      // input clk_in1
            // Clock out ports
            .clk_out1(clk50M),     // output clk_out1
            .clk_out2(vga_clk),     // output clk_out2
            .clk_out3(clk12_5M),     // output clk_out3
            .clk_out4(clk_ram));    // output clk_out4
        
            
        cfg_ov7670  I_CFG_OV7670 (
            .OV7670_SIOC( i2c_sclk ),
            .OV7670_SIOD( i2c_sdat ),
            .OV7670_RESET(  ),
            .OV7670_PWDN(  ),
            .OV7670_XCLK(  ),
            .CLK25M( vga_clk ) ,
            .rst( 1'b0 ) ,
            .ERROR()
            );
                                    
    
        DATA_processing DATA_processing(
        
            .camera_pclk(camera_pclk),
            .data(pixel_data),
            .clk_ram(clk_ram),
            .vga_clk(vga_clk),
            .clk12_5M(clk12_5M),
            .camera_href(camera_href),
            .camera_vsync(camera_vsync),
            .camera_data(camera_data),
            .x_cnt(x_cnt),
            .y_cnt(y_cnt),
            .hsync_de(hsync_de),
            .vsync_de(vsync_de),
            .Camera_data_out(Camera_data_out),
            .vga_data(vga_data),
            .addra(addra),
            .addrb(addrb),
            
            .key2(key2),
            .Judge_mode(Judge_mode)
            );

        VGA VGA(
            .vga_clk(vga_clk),
            .vga_hs(vga_hs),
            .vga_vs(vga_vs),
            .VGA_R(VGA_R),
            .VGA_G(VGA_G),
            .VGA_B(VGA_B),
            .hsync_de(hsync_de),
            .vsync_de(vsync_de),
            .x_cnt(x_cnt),
            .y_cnt(y_cnt),
            .key1(key1) //按键 key1
            );
            
        Coordinate_calculate Coordinate_calculate(
            
                .clk100M(clk100M),
                .clk12_5M(clk12_5M),
                
                .Camera_data_out(Camera_data_out),
                .camera_href(camera_href),
                .camera_vsync(camera_vsync),
                .camera_pclk(camera_pclk),
                
                .Judge_mode(Judge_mode),
                
                .X_coordinate_w(X_coordinate_w),
                .Y_coordinate_w(Y_coordinate_w),
                .Target_num_w(Target_num_w),
                .X_target_ave_estimate_w(X_target_ave_estimate_w),
                .Y_target_ave_estimate_w(Y_target_ave_estimate_w),
                .Target_num_estimate_w(Target_num_estimate_w),
                
                .Waiting_flag_w(Waiting_flag_w),
                
	            .X_count_w(X_count_w), // input wire [31:0]  probe9 
                .Y_count_w(Y_count_w), // input wire [31:0]  probe10 
                .VS_flag_w(VS_flag_w), // input wire [0:0]  probe11 
                .VS_flag_change_w(VS_flag_change_w), // input wire [0:0]  probe12 
                .HS_flag_w(HS_flag_w) // input wire [0:0]  probe13
                
                );
            
    Moter_X Moter_X(
                        
                        .clk_100M(clk100M),
                        .X_coordinate(X_OUT),
                        
                        .PWM(PWM_X)
                    
                        );
                
                Motor_Y Motor_Y(
                        
                        .clk_100M(clk100M),
                        .Y_coordinate(Y_OUT),
            
                        .PWM(PWM_Y)
                    
                        );
                        
                Motor_position_detect Motor_position_detect_1(
                        
                        .clk_100M(clk100M),
            
                        .X_coordinate_w(X_coordinate_w),
                        .Y_coordinate_w(Y_coordinate_w),
                        .X_OUT(X_OUT),
                        .Y_OUT(Y_OUT)
                        
                        );
            
//            ila_0 your_instance_name (
//                .clk(clk12_5M), // input wire clk
            
            
//                .probe0(camera_href), // input wire [0:0]  probe0  
//                .probe1(camera_vsync), // input wire [0:0]  probe1 
//                .probe2(Camera_data_out), // input wire [15:0]  probe2 
//                .probe3(X_coordinate_w), // input wire [31:0]  probe3 
//                .probe4(Y_coordinate_w), // input wire [31:0]  probe4 
//                .probe5(Target_num_w), // input wire [31:0]  probe5 
//                .probe6(X_target_ave_estimate_w), // input wire [31:0]  probe6 
//                .probe7(Y_target_ave_estimate_w), // input wire [31:0]  probe7 
//                .probe8(Target_num_estimate_w), // input wire [31:0]  probe8
//	            .probe9(X_count_w), // input wire [31:0]  probe9 
//                .probe10(Y_count_w), // input wire [31:0]  probe10 
//                .probe11(VS_flag_w), // input wire [0:0]  probe11 
//                .probe12(VS_flag_change_w), // input wire [0:0]  probe12 
//                .probe13(HS_flag_w) // input wire [0:0]  probe13
//            );

endmodule
