                `timescale 1ns / 1ps
        //////////////////////////////////////////////////////////////////////////////////
        // Company: 
        // Engineer: 
        // 
        // Create Date: 2018/07/19 13:01:33
        // Design Name: 
        // Module Name: VGA
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
        
        
        module VGA(
        input vga_clk,
        output vga_hs,
        output vga_vs,
        output [3:0]VGA_R,
        output [3:0]VGA_G,
        output [3:0]VGA_B,
        output reg hsync_de,
        output reg vsync_de,
        output reg[10 : 0] x_cnt,
        output reg[9 : 0] y_cnt,
                
        input key1 //按键 key1
        );
        
        wire [4:0] vga_r;
        wire [5:0] vga_g;
        wire [4:0] vga_b;
        
        assign VGA_R = vga_r[4:1];
        assign VGA_G = vga_g[5:2];
        assign VGA_B = vga_b[4:1];
        //-----------------------------------------------------------//
        // 水平扫描参数的设定 1024*768 60Hz VGA
        //-----------------------------------------------------------//
        //        parameter LinePeriod =1344; //行周期数
        //        parameter H_SyncPulse=136; //行同步脉冲（Sync a）
        //        parameter H_BackPorch=160; //显示后沿（Back porch b）
        //        parameter H_ActivePix=1024; //显示时序段（Display interval c）
        //        parameter H_FrontPorch=24; //显示前沿（Front porch d）
        //        parameter Hde_start=296;
        //        parameter Hde_end=1320;
        //-----------------------------------------------------------//
        // 垂直扫描参数的设定 1024*768 60Hz VGA
        //-----------------------------------------------------------//
        //        parameter FramePeriod =806; //列周期数
        //        parameter V_SyncPulse=6; //列同步脉冲（Sync o）
        //        parameter V_BackPorch=29; //显示后沿（Back porch p）
        //        parameter V_ActivePix=768; //显示时序段（Display interval q）
        //        parameter V_FrontPorch=3; //显示前沿（Front porch r）
        //        parameter Vde_start=35;
        //        parameter Vde_end=803;
        //-----------------------------------------------------------//
//-----------------------------------------------------------//
        // 水平扫描参数的设定640*480 VGA 60FPS_25MHz
        //-----------------------------------------------------------//
        parameter LinePeriod =800;            //行周期数
        parameter H_SyncPulse=96;             //行同步脉冲（Sync a）
        parameter H_BackPorch=48 ;            //显示后沿（Back porch b）
        parameter H_ActivePix=640;            //显示时序段（Display interval c）
        parameter H_FrontPorch=16;            //显示前沿（Front porch d）
        
        parameter Hde_start=144;
        parameter Hde_end=784;
        //-----------------------------------------------------------//
        // 垂直扫描参数的设定640*480 VGA
        //-----------------------------------------------------------//
        parameter FramePeriod =525;           //列周期数
        parameter V_SyncPulse=2;              //列同步脉冲（Sync o）
        parameter V_BackPorch=33 ;             //显示后沿（Back porch p）
        parameter V_ActivePix=480;            //显示时序段（Display interval q）
        parameter V_FrontPorch=10;             //显示前沿（Front porch r）
        
        parameter Vde_start=35;
        parameter Vde_end=515;
        
        reg[10 : 0] x_cnt;
        reg[9 : 0] y_cnt;
        reg[15 : 0] grid_data_1;
        reg[15 : 0] grid_data_2;
        reg[15 : 0] bar_data;
        reg[3 : 0] vga_dis_mode;
        reg[4 : 0] vga_r_reg;
        reg[5 : 0] vga_g_reg;
        reg[4 : 0] vga_b_reg;
        reg hsync_r;
        reg vsync_r;
        
        reg [15:0] key1_counter; //按键检测寄存器
        //----------------------------------------------------------------
        ////////// 水平扫描计数
        //----------------------------------------------------------------
        always @ (posedge vga_clk)
        if(1'b0) x_cnt <= 1;
        else if(x_cnt == LinePeriod) x_cnt <= 1;
        else x_cnt <= x_cnt+ 1;
        //----------------------------------------------------------------
        ////////// 水平扫描信号 hsync,hsync_de 产生
        //----------------------------------------------------------------
        always @ (posedge vga_clk)
        begin
        if(1'b0) hsync_r <= 1'b1;
        else if(x_cnt == 1) hsync_r <= 1'b0; //产生 hsync 信号
        else if(x_cnt == H_SyncPulse) hsync_r <= 1'b1;
        if(1'b0) hsync_de <= 1'b0;
        else if(x_cnt == Hde_start) hsync_de <= 1'b1; //产生 hsync_de 信号
        else if(x_cnt == Hde_end) hsync_de <= 1'b0;
        end
        //----------------------------------------------------------------
        ////////// 垂直扫描计数
        //----------------------------------------------------------------
        always @ (posedge vga_clk)
        if(1'b0) y_cnt <= 1;
        else if(y_cnt == FramePeriod) y_cnt <= 1;
        else if(x_cnt == LinePeriod) y_cnt <= y_cnt+1;
        //----------------------------------------------------------------
        ////////// 垂直扫描信号 vsync, vsync_de 产生
        //----------------------------------------------------------------
        always @ (posedge vga_clk)
        begin
        if(1'b0) vsync_r <= 1'b1;
        else if(y_cnt == 1) vsync_r <= 1'b0; //产生 vsync 信号
        else if(y_cnt == V_SyncPulse) vsync_r <= 1'b1;
        if(1'b0) vsync_de <= 1'b0;
        else if(y_cnt == Vde_start) vsync_de <= 1'b1; //产生 vsync_de 信号
        else if(y_cnt == Vde_end) vsync_de <= 1'b0;
        end
        //----------------------------------------------------------------
        ////////// 格子测试图像产生
        //----------------------------------------------------------------
        always @(negedge vga_clk)
        begin
        if ((x_cnt[4]==1'b1) ^ (y_cnt[4]==1'b1)) //产生格子 1 图像
        grid_data_1<= 16'h0000;
        else
        grid_data_1<= 16'hffff;
        if ((x_cnt[6]==1'b1) ^ (y_cnt[6]==1'b1)) //产生格子 2 图像
        grid_data_2<=16'h0000;
        else
        grid_data_2<=16'hffff;
        end
        //----------------------------------------------------------------
        ////////// 彩色条测试图像产生
        //----------------------------------------------------------------
        always @(negedge vga_clk)
        begin
        if (x_cnt==300) bar_data<= 16'hf800;
        else if (x_cnt==420) bar_data<= 16'h07e0;
        else if (x_cnt==540) bar_data<=16'h001f;
        else if (x_cnt==660) bar_data<=16'hf81f;
        else if (x_cnt==780) bar_data<=16'hffe0;
        else if (x_cnt==900) bar_data<=16'h07ff;
        else if (x_cnt==1020) bar_data<=16'hffff;
        else if (x_cnt==1140) bar_data<=16'hfc00;
        else if (x_cnt==1260) bar_data<=16'h0000;
        end
        //----------------------------------------------------------------
        ////////// VGA 图像选择输出
        //----------------------------------------------------------------
        //LCD 数据信号选择
        always @(negedge vga_clk)
        if(1'b0) begin
        vga_r_reg<=0;
        vga_g_reg<=0;
        vga_b_reg<=0;
        end
        else
        case(vga_dis_mode)
        4'b0000:begin
        vga_r_reg<=0; //VGA 显示全黑
        vga_g_reg<=0;
        vga_b_reg<=0;
        end
        4'b0001:begin
        vga_r_reg<=5'b11111; //VGA 显示全白
        vga_g_reg<=6'b111111;
        vga_b_reg<=5'b11111;
        end
        4'b0010:begin
        vga_r_reg<=5'b11111; //VGA 显示全红
        vga_g_reg<=0;
        vga_b_reg<=0;
        end
        4'b0011:begin
        vga_r_reg<=0; //VGA 显示全绿
        vga_g_reg<=6'b111111;
        vga_b_reg<=0;
        end
        4'b0100:begin
        vga_r_reg<=0; //VGA 显示全蓝
        vga_g_reg<=0;
        vga_b_reg<=5'b11111;
        end
        4'b0101:begin
        vga_r_reg<=grid_data_1[15:11]; // VGA 显示方格 1
        vga_g_reg<=grid_data_1[10:5];
        vga_b_reg<=grid_data_1[4:0];
        end
        4'b0110:begin
        vga_r_reg<=grid_data_2[15:11]; // VGA 显示方格 2
        vga_g_reg<=grid_data_2[10:5];
        vga_b_reg<=grid_data_2[4:0];
        end
        4'b0111:begin
        vga_r_reg<=x_cnt[6:2]; //VGA 显示水平渐变色
        vga_g_reg<=x_cnt[6:1];
        vga_b_reg<=x_cnt[6:2];
        end
        4'b1000:begin
        vga_r_reg<=y_cnt[6:2]; //VGA 显示垂直渐变色
        vga_g_reg<=y_cnt[6:1];
        vga_b_reg<=y_cnt[6:2];
        end
        4'b1001:begin
        vga_r_reg<=x_cnt[6:2]; //VGA 显示红水平渐变色
        vga_g_reg<=0;
        vga_b_reg<=0;
        end
        4'b1010:begin
        vga_r_reg<=0; //VGA 显示绿水平渐变色
        vga_g_reg<=x_cnt[6:1];
        vga_b_reg<=0;
        end
        4'b1011:begin
        vga_r_reg<=0; //VGA 显示蓝水平渐变色
        vga_g_reg<=0;
        vga_b_reg<=x_cnt[6:2];
        end
        4'b1100:begin
        vga_r_reg<=bar_data[15:11]; //VGA 显示彩色条
        vga_g_reg<=bar_data[10:5];
        vga_b_reg<=bar_data[4:0];
        end
        default:begin
        vga_r_reg<=5'b11111; //VGA 显示全白
        vga_g_reg<=6'b111111;
        vga_b_reg<=5'b11111;
        end
        endcase;
        assign vga_hs = hsync_r;
        assign vga_vs = vsync_r;
        assign vga_r = (hsync_de & vsync_de)?vga_r_reg:5'b00000;
        assign vga_g = (hsync_de & vsync_de)?vga_g_reg:6'b000000;
        assign vga_b = (hsync_de & vsync_de)?vga_b_reg:5'b00000;
        
        //pll pll_inst
        //(// Clock in ports
        //.CLK_IN1(fpga_gclk), // IN
        //.CLK_OUT1(CLK_OUT1), // 21.175Mhz for 640x480(60hz)
        //.CLK_OUT2(CLK_OUT2), // 40.0Mhz for 800x600(60hz)
        //.CLK_OUT3(CLK_OUT3), // 65.0Mhz for 1024x768(60hz)
        //.CLK_OUT4(CLK_OUT4), // 108.0Mhz for 1280x1024(60hz)
        //.RESET(0), // reset input
        //.LOCKED(LOCKED)); // OUT
        
        
        // INST_TAG_END ------ End INSTANTIATI
        //按钮处理程序
        
        always @(posedge vga_clk)
        begin
        if (key1==1'b0) //如果按钮没有按下，寄存器为 0
        key1_counter<=0;
        else if ((key1==1'b1)& (key1_counter<=16'hc350))//如果按钮按下并按下时间少于 1ms,计数
        key1_counter<=key1_counter+1'b1;
        if (key1_counter==16'hc349) begin //一次按钮有效，改变显示模式
        if(vga_dis_mode==4'b1101)
        vga_dis_mode<=4'b0000;
        else
        vga_dis_mode<=vga_dis_mode+1'b1;
        end
        end
        endmodule