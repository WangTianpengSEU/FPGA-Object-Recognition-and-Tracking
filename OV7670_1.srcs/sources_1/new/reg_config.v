`timescale 1ns / 1ps
//camera中寄存器的配置程序
 module reg_config(clk_25M,
                  i2c_sclk,
                  i2c_sdat,
                  reset,
						reg_index,
						config_step,
						clock_20k,
						reg_conf_done);
     input clk_25M;
     input reset;
	  output reg_conf_done;
     output i2c_sclk;
	  output [8:0] reg_index; 
     output [1:0] config_step;	  
     inout i2c_sdat;
	  output clock_20k;
    
     reg clock_20k;
     reg [15:0]clock_20k_cnt;
     reg [1:0]config_step;
     reg [8:0]reg_index;
     reg [23:0]i2c_data;
     reg [15:0]reg_data;
     reg start;
	  reg reg_conf_done_reg;
    
     i2c_com u1(.clock_i2c(clock_20k),
               .reset(reset),
               .ack(ack),
               .i2c_data(i2c_data),
               .start(start),
               .tr_end(tr_end),
               .i2c_sclk(i2c_sclk),
               .i2c_sdat(i2c_sdat));

assign reg_conf_done=reg_conf_done_reg;
//产生i2c控制时钟-20khz    
always@(posedge clk_25M)   
begin
   if(reset)
      begin
        clock_20k<=0;
        clock_20k_cnt<=0;
      end
   else if(clock_20k_cnt<625)
      clock_20k_cnt<=clock_20k_cnt+1'b1;
   else
      begin
         clock_20k<=!clock_20k;
         clock_20k_cnt<=0;
      end
end

////iic寄存器配置过程控制    
always@(posedge clock_20k)    
begin
   if(reset) begin
       config_step<=0;
       start<=0;
       reg_index<=0;
		 reg_conf_done_reg<=0;
   end
   else begin
       if(reg_index<169) begin                     //一共配置165个寄存器       
             case(config_step)
             0:begin
               i2c_data<={8'h42,reg_data};       //OV7670 IIC Device address is 0x42   
               start<=1;
               config_step<=1;
               end
             1:begin
               if(tr_end) begin                  //IIC发送结束  
 					    start<=0;
                   config_step<=2;
                 end
               end
             2:begin
                 reg_index<=reg_index+1'b1;
                 config_step<=0;
               end
             endcase
          end
		 else
         reg_conf_done_reg<=1'b1;	 
     end
 end

	

////OV7670需要配置的寄存器值 24Mhz input clock 30fps PCLK=24Mhz  			
always@(reg_index)   
 begin
    case(reg_index)
// 0  :    reg_data <= 16'hff01;
//    1  :    reg_data <= 16'h1280;
//    //UXGA reg configure
//    2  :    reg_data <= 16'hff00; 
//    3  :    reg_data <= 16'h2cff;  
//    4  :    reg_data <= 16'h2edf;   
//    5  : reg_data    <=    16'hff01;
//    6  : reg_data    <= 16'h3c32;
//    //
//    7  : reg_data    <= 16'h1100;
//    8  : reg_data    <= 16'h0902;
//    9  : reg_data    <= 16'h04D8;
//    10 : reg_data    <= 16'h13E5;
//    11 : reg_data    <= 16'h1448;
//    //
//    12 : reg_data    <= 16'h2C0C;
//    13 : reg_data    <= 16'h3378;
//    14 : reg_data    <= 16'h3A33;
//    15 : reg_data    <= 16'h3BFB;
//    16 : reg_data    <= 16'h3E00;
//    //
//    17 : reg_data    <= 16'h4311;
//    18 : reg_data    <= 16'h1610;          
//    19 : reg_data    <= 16'h3992;     
//    20 : reg_data    <= 16'h35DA;
//    21 : reg_data    <= 16'h221A;
//    //
//    22 : reg_data    <= 16'h37C3;
//    23 : reg_data    <= 16'h2300;
//    24 : reg_data    <= 16'h34C0;
//    25 : reg_data    <= 16'h361A;
//    26 : reg_data    <= 16'h0688;
//    //
//    27 : reg_data    <= 16'h07C0;
//    28 : reg_data    <= 16'h0D87;
//    29 : reg_data    <= 16'h0E41;
//    30 : reg_data    <= 16'h4C00;
//    31 : reg_data    <= 16'h4800;
//    //
//    32 : reg_data    <= 16'h5B00;
//    33 : reg_data    <= 16'h4203;
//    34 : reg_data    <= 16'h4A81;
//    35 : reg_data    <= 16'h2199;
//    36 : reg_data    <= 16'h2440;
//    //
//    37 : reg_data    <= 16'h2538;
//    38 : reg_data    <= 16'h2682;          
//    39 : reg_data    <= 16'h5C00;
//    40 : reg_data    <= 16'h6300;
//    41 : reg_data    <= 16'h4600;
//    //
//    42 : reg_data    <= 16'h0C3C;
//    43 : reg_data    <= 16'h6170;
//    44 : reg_data    <= 16'h6280;
//    45 : reg_data    <= 16'h7C05;
//    46 : reg_data    <= 16'h2080;
//    //
//    47 : reg_data    <= 16'h2830;
//    48 : reg_data    <= 16'h6C00;
//    49 : reg_data    <= 16'h6D80;
//    50 : reg_data    <= 16'h6E00;
//    51 : reg_data    <= 16'h7002;
//    //
//    52 : reg_data    <= 16'h7194;
//    53 : reg_data    <= 16'h73C1;
//    54 : reg_data    <= 16'h3D34;
//    55 : reg_data    <= 16'h5A57;
//    56 : reg_data    <= 16'h1200;//UXGA 1600*1200
//       //     
//    57 : reg_data    <= 16'h1711;
//    58 : reg_data    <= 16'h1875;
//    59 : reg_data    <= 16'h1901;
//    60 : reg_data    <= 16'h1A97;
//    61 : reg_data    <= 16'h3236;
//    //
//    62 : reg_data    <= 16'h030F;
//    63 : reg_data    <= 16'h3740;
//    64 : reg_data    <= 16'h4FCA;
//    65 : reg_data    <= 16'h50A8;
//    66 : reg_data    <= 16'h5A23;
//    //
//    67 : reg_data    <= 16'h6D00;
//    68 : reg_data    <= 16'h6D38;
//    69 : reg_data    <= 16'hFF00;
//    70 : reg_data    <= 16'hE57F;
//    71 : reg_data    <= 16'hF9C0;
//    //
//    72 : reg_data    <= 16'h4124;
//    73 : reg_data    <= 16'hE014;
//    74 : reg_data    <= 16'h76FF;
//    75 : reg_data    <= 16'h33A0;
//    76 : reg_data    <= 16'h4220;
//    //
//    77 : reg_data    <= 16'h4318;
//    78 : reg_data    <= 16'h4C00;
//    79 : reg_data    <= 16'h87D5;
//    80 : reg_data    <= 16'h883F;
//    81 : reg_data    <= 16'hD703;
//    //
//    82 : reg_data    <= 16'hD910;
//    83 : reg_data    <= 16'hD382;
//    84 : reg_data    <= 16'hC808;
//    85 : reg_data    <= 16'hC980;
//            86 :    reg_data    <=    16'h7C00;
//    //
//    87  :    reg_data    <=    16'h7D00;
//    88  :    reg_data    <=    16'h7C03;
//    89  :    reg_data    <=    16'h7D48;
//    90  :    reg_data    <=    16'h7D48;
//    91  :    reg_data    <=    16'h7C08;
//    //
//    92  :    reg_data    <=    16'h7D20;
//    93  :    reg_data    <=    16'h7D10;
//    94  :    reg_data    <=    16'h7D0E;
//    95  :    reg_data    <=    16'h9000;
//    96  :    reg_data    <=    16'h910E;
//    //
//    97  :    reg_data    <=    16'h911A;
//    98  :    reg_data    <=    16'h9131;
//    99  :    reg_data    <=    16'h915A;
//    100 :reg_data    <=    16'h9169;
//    101 :reg_data    <=    16'h9175;
//    //
//    102 :    reg_data    <=    16'h917E;
//    103 :    reg_data    <=    16'h9188;
//    104 :    reg_data    <=    16'h918F;
//    105 :    reg_data    <=    16'h9196;     
//    106 :    reg_data    <=    16'h91A3;
//    //
//    107 :    reg_data    <= 16'h91AF;
//    108 :    reg_data    <= 16'h91C4;
//    109 :    reg_data    <= 16'h91D7;
//    110 :    reg_data    <= 16'h91E8;
//    111 :    reg_data    <= 16'h9120;
//       //     
//    112 :    reg_data    <=    16'h9200;
//    113 :    reg_data    <=    16'h9306;
//    114 :    reg_data    <=    16'h93E3;
//    115 :    reg_data    <=    16'h9305;
//    116 :    reg_data    <=    16'h9305;
//    //
//    117 :    reg_data    <=    16'h9300;
//    118 :    reg_data    <=    16'h9304;
//    119 :    reg_data    <=    16'h9300;
//    120 :    reg_data    <=    16'h9300;
//    121 :    reg_data    <=    16'h9300;
//    //
//    122 :    reg_data    <= 16'h9300;
//    123 : reg_data    <=    16'h9300;
//    124 : reg_data    <=    16'h9300;             
//    125 : reg_data    <=    16'h9300;
//    126 : reg_data    <=    16'h9600;
//    //
//    127 : reg_data    <=    16'h9708;
//    128 : reg_data    <=    16'h9719;
//    129 : reg_data    <=    16'h9702;
//    130 : reg_data    <=    16'h970C;               
//    131 : reg_data    <=    16'h9724;
//    //
//    132 : reg_data    <=    16'h9730;
//    133 : reg_data    <=    16'h9728;
//    134 : reg_data    <=    16'h9726;
//    135 : reg_data    <=    16'h9702;
//    136 : reg_data    <=    16'h9798;
//    //
//    137 : reg_data    <=    16'h9780;
//    138 : reg_data    <=    16'h9700;
//    139 : reg_data    <=    16'h9700;
//    140 : reg_data    <=    16'hC3EF;
//    141 : reg_data    <=    16'hA400;
//    //
//    142 : reg_data    <=    16'hA800;
//    143 : reg_data    <=    16'hC511;
//    144 : reg_data    <=    16'hC651;
//    145 :    reg_data    <=    16'hBF80;
//    146 :    reg_data    <= 16'hC710;
//    //
//    147 :    reg_data    <= 16'hB666;
//    148 :    reg_data    <= 16'hB8A5;
//    149 :    reg_data    <= 16'hB764;
//    150 :    reg_data    <= 16'hB97C;
//    151 :    reg_data    <= 16'hB3AF;
//    //
//    152 :    reg_data    <= 16'hB497;
//    153 :    reg_data    <= 16'hB5FF;
//    154 :    reg_data    <= 16'hB0C5;
//    155 :    reg_data    <= 16'hB194;
//    156 :    reg_data    <= 16'hB20F;
//    //
//    157 :    reg_data    <= 16'hC45C;
//    158 :    reg_data    <= 16'hC0C8;
//    159 :    reg_data    <= 16'hC196;
//    160 :    reg_data    <= 16'h8C00;
//    161 :    reg_data    <= 16'h863D;
//    //
//    162 :    reg_data    <= 16'h5000;
//    163 :    reg_data    <= 16'h5190;
//    164 :    reg_data    <= 16'h522C;
//    165 :    reg_data    <= 16'h5300;
//    166 :    reg_data    <= 16'h5400;
//       //     
//    167 :    reg_data    <= 16'h5588;
//    168 :    reg_data    <= 16'h5A90;  
//    169 :    reg_data    <= 16'h5B2C;  
//    170 :    reg_data    <= 16'h5C05;
//       171 :   reg_data    <= 16'hD302; //auto设置要小心
//    //
//    172 :    reg_data    <=    16'hC3ED;
//    173 :    reg_data    <=    16'h7F00;
//    174 :    reg_data    <=    16'hDA09;
//    175 :    reg_data    <=    16'hE51F;
//    176 :    reg_data    <=    16'hE167;
//    //
//    177 :    reg_data    <= 16'hE000;
//    178 : reg_data    <=    16'hDD7F;
//    179 : reg_data    <=    16'h0500;
//       //RGB565 reg configure
//    180 : reg_data    <=    16'hFF00;
//    181 : reg_data    <=    16'hDA09;
//    //
//    182 : reg_data    <=    16'hD703;
//    183 : reg_data    <=    16'hDF02;
//    184 : reg_data    <=    16'h33A0;
//    185 : reg_data    <=    16'h3C00;               
//    186 : reg_data    <=    16'hE167;
//    //
//    187 : reg_data    <=    16'hFF01;
//    188 : reg_data    <=    16'hE000;
//    189 : reg_data    <=    16'hE100;
//    190 : reg_data    <=    16'hE500;
//    191 : reg_data    <=    16'hD700;
//    //
//    192 : reg_data    <=    16'hDA00;
//    193 : reg_data    <=    16'hE000;
    
       
	 //0  :    reg_data <= 16'h1206;   //复位，VGA，RGB565 (00:YUV,04:RGB)(8x全局复位)
	 0  :    reg_data <= 16'h1204; //复位，VGA，RGB565 (00:YUV,04:RGB)(8x全局复位)
	 1  :    reg_data <= 16'h40f0;   //RGB565, 00-FF(d0)（YUV下要改01-FE(80)）
	 2  :    reg_data <= 16'h3a04;   //TSLB(TSLB[3], COM13[0])00:YUYV, 01:YVYU, 10:UYVY(CbYCrY), 11:VYUY
	 3  : 	reg_data	<=	16'h3dc8;	//COM13(TSLB[3], COM13[0])00:YUYV, 01:YVYU, 10:UYVY(CbYCrY), 11:VYUY
	 4  : 	reg_data	<= 16'h1e37;	//默认01，Bit[5]水平镜像，Bit[4]竖直镜像
	 5  : 	reg_data	<= 16'h6b00;	//旁路PLL倍频；0x0A：关闭内部LDO；0x00：
	// 5  : 	reg_data	<= 16'h6b0a;	//旁路PLL倍频；0x0A：关闭内部LDO；0x00：	
	 6  : 	reg_data	<= 16'h32b6;	//HREF 控制(80)
	 7  : 	reg_data	<= 16'h1713;	//HSTART 输出格式-行频开始高8位(11) 
	 8  : 	reg_data	<= 16'h1801;	//HSTOP  输出格式-行频结束高8位(61)
	 9  : 	reg_data	<= 16'h1902;	//VSTART 输出格式-场频开始高8位(03)
	 10 : 	reg_data	<= 16'h1a7a;	//VSTOP  输出格式-场频结束高8位(7b)
	 11 : 	reg_data	<= 16'h030a;	//VREF	帧竖直方向控制(00)
	 12 : 	reg_data	<= 16'h0c00;	//DCW使能 禁止(00)
//	 13 : 	reg_data	<= 16'h0c00;	//DCW使能 禁止(00)
	 13 : 	reg_data	<= 16'h3e00;	//PCLK分频00 Normal，10（1分频）,11（2分频）,12（4分频）,13（8分频）14（16分频）
	 14 : 	reg_data	<= 16'h703a;	//00:Normal, 80:移位1, 00:彩条, 80:渐变彩条   7000
	 //15 : 	reg_data	<= 16'h7180;	//00:Normal, 00:移位1, 80:彩条, 80：渐变彩条  7100
	 15 : 	reg_data	<= 16'h7135;	//00:Normal, 00:移位1, 80:彩条, 80：渐变彩条  7100
	 16 : 	reg_data	<= 16'h7211;	//默认 水平，垂直8抽样(11)        
	 17 : 	reg_data	<= 16'h7300;	//DSP缩放时钟分频00 Normal，10（1分频）,11（2分频）,12（4分频）,13（8分频）14（16分频） 
	 18 : 	reg_data	<= 16'ha202;	//默认 像素始终延迟
	 19 : 	reg_data	<= 16'h1180;	//内部工作时钟设置，直接使用外部时钟源(80)   change from 80 to 81
	 20 : 	reg_data	<= 16'h7a20;
	 21 : 	reg_data	<= 16'h7b1c;
	 22 : 	reg_data	<= 16'h7c28;
	 23 : 	reg_data	<= 16'h7d3c;
	 24 : 	reg_data	<= 16'h7e55;
	 25 : 	reg_data	<= 16'h7f68;
	 26 : 	reg_data	<= 16'h8076;
	 27 : 	reg_data	<= 16'h8180;
	 28 : 	reg_data	<= 16'h8288;
	 29 : 	reg_data	<= 16'h838f;
	 30 : 	reg_data	<= 16'h8496;
	 31 : 	reg_data	<= 16'h85a3;
	 32 : 	reg_data	<= 16'h86af;
	 33 : 	reg_data	<= 16'h87c4;
	 34 : 	reg_data	<= 16'h88d7;
	 35 : 	reg_data	<= 16'h89e8;
	 36 : 	reg_data	<= 16'h13e0;          
	 37 : 	reg_data	<= 16'h0000;
	 38 : 	reg_data	<= 16'h1000;
	 39 : 	reg_data	<= 16'h0d00;
	 40 : 	reg_data	<= 16'h1428;	//
	 41 : 	reg_data	<= 16'ha505;
	 42 : 	reg_data	<= 16'hab07;
	 43 : 	reg_data	<= 16'h2475;
	 44 : 	reg_data	<= 16'h2563;
	 45 : 	reg_data	<= 16'h26a5;
	 46 : 	reg_data	<= 16'h9f78;
	 47 : 	reg_data	<= 16'ha068;
	 48 : 	reg_data	<= 16'ha103;
	 49 : 	reg_data	<= 16'ha6df;
	 50 : 	reg_data	<= 16'ha7df;
	 51 : 	reg_data	<= 16'ha8f0;
	 52 : 	reg_data	<= 16'ha990;
	 53 : 	reg_data	<= 16'haa94;
	 54 : 	reg_data	<= 16'h13ef;	
	 55 : 	reg_data	<= 16'h0e61;
	 56 : 	reg_data	<= 16'h0f4b;
	 57 : 	reg_data	<= 16'h1602;
	 58 : 	reg_data	<= 16'h2102;
	 59 : 	reg_data	<= 16'h2291;
	 60 : 	reg_data	<= 16'h2907;
	 61 : 	reg_data	<= 16'h330b;
	 62 : 	reg_data	<= 16'h350b;
	 63 : 	reg_data	<= 16'h371d;
	 64 : 	reg_data	<= 16'h3871;
	 65 : 	reg_data	<= 16'h392a;
	 66 : 	reg_data	<= 16'h3c78;
	 67 : 	reg_data	<= 16'h4d40;
	 68 : 	reg_data	<= 16'h4e20;
	 69 : 	reg_data	<= 16'h6900;
	 70 : 	reg_data	<= 16'h7419;
	 71 : 	reg_data	<= 16'h8d4f;
	 72 : 	reg_data	<= 16'h8e00;
	 73 : 	reg_data	<= 16'h8f00;
	 74 : 	reg_data	<= 16'h9000;
	 75 : 	reg_data	<= 16'h9100;
	 76 : 	reg_data	<= 16'h9200;
	 77 : 	reg_data	<= 16'h9600;
	 78 : 	reg_data	<= 16'h9a80;
	 79 : 	reg_data	<= 16'hb084;
	 80 : 	reg_data	<= 16'hb10c;
	 81 : 	reg_data	<= 16'hb20e;
	 82 : 	reg_data	<= 16'hb382;
	 83 : 	reg_data	<= 16'hb80a;
    84  :	reg_data	<=	16'h4314;
	 85  :	reg_data	<=	16'h44f0;
	 86  :	reg_data	<=	16'h4534;
	 87  :	reg_data	<=	16'h4658;
	 88  :	reg_data	<=	16'h4728;
	 89  :	reg_data	<=	16'h483a;
	 90  :	reg_data	<=	16'h5988;
	 91  :	reg_data	<=	16'h5a88;
	 92  :	reg_data	<=	16'h5b44;
	 93  :	reg_data	<=	16'h5c67;
	 94  :	reg_data	<=	16'h5d49;
	 95  :	reg_data	<=	16'h5e0e;
	 96  :	reg_data	<=	16'h6404;
	 97  :	reg_data	<=	16'h6520;
	 98  :	reg_data	<=	16'h6605;
	 99  :	reg_data	<=	16'h9404;
	 100 :	reg_data	<=	16'h9508;
	 101 :	reg_data	<=	16'h6c0a;
	 102 :	reg_data	<=	16'h6d55;
	 103 :	reg_data	<=	16'h4f80;	 
	 104 :	reg_data	<=	16'h5080;
	 105 :	reg_data	<= 16'h5100;
	 106 :	reg_data	<= 16'h5222;
	 107 :	reg_data	<= 16'h535e;
	 108 :	reg_data	<= 16'h5480;
	 109 :	reg_data	<= 16'h0903;	 
	 110 :	reg_data	<=	16'h6e11;
	 111 :	reg_data	<=	16'h6f9f;
	 112 :	reg_data	<=	16'h5500;
	 113 :	reg_data	<=	16'h5640;
	 114 :	reg_data	<=	16'h5740;
	 115 :	reg_data	<=	16'h6a40;
	 116 :	reg_data	<=	16'h0140;
	 117 :	reg_data	<=	16'h0240; 
	 118 :	reg_data	<=	16'h13e7;
	 119 :	reg_data	<=	16'h1500;    //HSYNC
	 120 :	reg_data	<= 16'h589e;
	 121 : 	reg_data	<=	16'h4108;
	 122 : 	reg_data	<=	16'h3f00;             
	 123 : 	reg_data	<=	16'h7505;
	 124 : 	reg_data	<=	16'h76e1;
	 125 : 	reg_data	<=	16'h4c00;
	 126 : 	reg_data	<=	16'h7701;
	 127 : 	reg_data	<=	16'h4b09;
	 128 : 	reg_data	<=	16'hc9f0;                  //16'hc960;
	 129 : 	reg_data	<=	16'h4138;
	 130 : 	reg_data	<=	16'h3411;
//	 131 : 	reg_data	<=	16'h3b02;
	 131 : 	reg_data	<=	16'h3b0a;
	 132 : 	reg_data	<=	16'ha489;
	 133 : 	reg_data	<=	16'h9600;
	 134 : 	reg_data	<=	16'h9730;
	 135 : 	reg_data	<=	16'h9820;
	 136 : 	reg_data	<=	16'h9930;
	 137 : 	reg_data	<=	16'h9a84;
	 138 : 	reg_data	<=	16'h9b29;
	 139 : 	reg_data	<=	16'h9c03;
	 140 : 	reg_data	<=	16'h9d4c;
	 141 : 	reg_data	<=	16'h9e3f;
	 142 : 	reg_data	<=	16'h7804;
	 143 :	reg_data	<=	16'h7901;
	 144 :	reg_data	<= 16'hc8f0;
	 145 :	reg_data	<= 16'h790f;
	 146 :	reg_data	<= 16'hc800;
	 147 :	reg_data	<= 16'h7910;
	 148 :	reg_data	<= 16'hc87e;
	 149 :	reg_data	<= 16'h790a;
	 150 :	reg_data	<= 16'hc880;
	 151 :	reg_data	<= 16'h790b;
	 152 :	reg_data	<= 16'hc801;
	 153 :	reg_data	<= 16'h790c;
	 154 :	reg_data	<= 16'hc80f;
	 155 :	reg_data	<= 16'h790d;
	 156 :	reg_data	<= 16'hc820;
	 157 :	reg_data	<= 16'h7909;
	 158 :	reg_data	<= 16'hc880;
	 159 :	reg_data	<= 16'h7902;
	 160 :	reg_data	<= 16'hc8c0;
	 161 :	reg_data	<= 16'h7903;
	 162 :	reg_data	<= 16'hc840;
	 163 :	reg_data	<= 16'h7905;
	 164 :	reg_data	<= 16'hc830; 
	 165 :	reg_data	<= 16'h7926;
	 166 :	reg_data	<= 16'h2a00;  
	 167 :	reg_data	<= 16'h2b00; 	 
	 168 :	reg_data	<= 16'h9300;   
	 default:reg_data <= 16'h0000;
    endcase      
end	 



endmodule


