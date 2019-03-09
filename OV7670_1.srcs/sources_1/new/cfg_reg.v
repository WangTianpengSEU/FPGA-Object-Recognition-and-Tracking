`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/04 14:15:37
// Design Name: 
// Module Name: cfg_reg
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


module cfg_reg#(
        parameter LEN =122
    )(
        input clk,  rst,
        output reg  [15:0] dout,
        output reg  m_valid,
        input m_ready
    );
    
    reg [10:0] cntr = 0 ;
     
    always @ (posedge clk)
        if (rst) cntr<=0;
        else if ( m_ready & m_valid  )
        begin 
            cntr<=cntr + 1 ;
        end  
        
    always @ (posedge clk) m_valid <= ( cntr < LEN )   ;

always @ (posedge clk)
case (cntr)
    0 :    dout <= 'h3A_04 ;
    1 :    dout <= 'h67_C0 ;
    2 :    dout <= 'h68_80 ;
    3 :    dout <= 'h11_C0 ;
    4 :    dout <= 'h01_80 ;
    5 :    dout <= 'h02_80 ;
    6 :    dout <= 'h40_B0 ;
    7 :    dout <= 'h12_04 ;
    8 :    dout <= 'h13_E7 ;
    9 :    dout <= 'h32_80 ;
    10 :   dout <= 'h17_16 ;
    11 :   dout <= 'h18_04 ;
    12 :   dout <= 'h19_02 ;
    13 :   dout <= 'h1A_7A ;
    14 :   dout <= 'h03_05 ;
    15 :   dout <= 'h0C_00 ;
    16 :   dout <= 'h3E_00 ;
    17 :   dout <= 'h70_00 ;
    18 :   dout <= 'h71_01 ;
    19 :   dout <= 'h72_11 ;
    20 :   dout <= 'h73_00 ;
    21 :   dout <= 'hA2_02 ;
    22 :   dout <= 'h7A_20 ;
    23 :   dout <= 'h7B_1C ;
    24 :   dout <= 'h7C_28 ;
    25 :   dout <= 'h7C_28 ;
    26 :   dout <= 'h7D_3C ;
    27 :   dout <= 'h7E_55 ;
    28 :   dout <= 'h7F_68 ;
    29 :   dout <= 'h80_76 ;
    30 :   dout <= 'h81_80 ;
    31 :   dout <= 'h82_88 ;
    32 :   dout <= 'h83_8F ;
    33 :   dout <= 'h84_96 ;
    34 :   dout <= 'h85_A3 ;
    35 :   dout <= 'h86_AF ;
    36 :   dout <= 'h87_C4 ;
    37 :   dout <= 'h88_D7 ;
    38 :   dout <= 'h89_E8 ;
    39 :   dout <= 'h09_00 ;
    40 :   dout <= 'h10_00 ;
    41 :   dout <= 'h0D_00 ;
    42 :   dout <= 'h14_20 ;
    43 :   dout <= 'hA5_05 ;
    44 :   dout <= 'hAB_07 ;
    45 :   dout <= 'h24_8A ;
    46 :   dout <= 'h25_73 ;
    47 :   dout <= 'h26_A5 ;
    48 :   dout <= 'h9F_78 ;
    49 :   dout <= 'hA0_68 ;
    50 :   dout <= 'hA1_03 ;
    51 :   dout <= 'hA6_DF ;
    52 :   dout <= 'hA7_DF ;
    53 :   dout <= 'hA8_F0 ;
    54 :   dout <= 'hA9_90 ;
    55 :   dout <= 'hAA_94 ;
    56 :   dout <= 'h13_E7 ;
    57 :   dout <= 'h0E_61 ;
    58 :   dout <= 'h0F_4B ;
    59 :   dout <= 'h16_02 ;
    60 :   dout <= 'h1E_27 ;
    61 :   dout <= 'h21_02 ;
    62 :   dout <= 'h22_91 ;
    63 :   dout <= 'h29_07 ;
    64 :   dout <= 'h33_0B ;
    65 :   dout <= 'h35_0B ;
    66 :   dout <= 'h37_1D ;
    67 :   dout <= 'h38_71 ;
    68 :   dout <= 'h39_2A ;
    69 :   dout <= 'h3C_78 ;
    70 :   dout <= 'h4D_40 ;
    71 :   dout <= 'h4E_20 ;
    72 :   dout <= 'h69_00 ;
    73 :   dout <= 'h6B_40 ;
    74 :   dout <= 'h74_19 ;
    75 :   dout <= 'h8D_4F ;
    76 :   dout <= 'h8E_00 ;
    77 :   dout <= 'h8F_00 ;
    78 :   dout <= 'h90_00 ;
    79 :   dout <= 'h91_00 ;
    80 :   dout <= 'h92_00 ;
    81 :   dout <= 'h96_00 ;
    82 :   dout <= 'h9A_80 ;
    83 :   dout <= 'hB0_84 ;
    84 :   dout <= 'hB1_0C ;
    85 :   dout <= 'hB2_0E ;
    86 :   dout <= 'hB3_82 ;
    87 :   dout <= 'hB8_0A ;
    88 :   dout <= 'h43_14 ;
    89 :   dout <= 'h44_F0 ;
    90 :   dout <= 'h45_34 ;
    91 :   dout <= 'h46_58 ;
    92 :   dout <= 'h47_28 ;
    93 :   dout <= 'h48_3A ;
    94 :   dout <= 'h59_88 ;
    95 :   dout <= 'h5A_88 ;
    96 :   dout <= 'h5B_44 ;
    97 :   dout <= 'h5C_67 ;
    98 :   dout <= 'h5D_49 ;
    99 :   dout <= 'h5E_0E ;
    100 :  dout <= 'h64_04 ;
    101 :  dout <= 'h65_20 ;
    102 :  dout <= 'h66_05 ;
    103 :  dout <= 'h94_04 ;
    104 :  dout <= 'h95_08 ;
    105 :  dout <= 'h6C_0A ;
    106 :  dout <= 'h6D_55 ;
    107 :  dout <= 'h4F_99 ;
    108 :  dout <= 'h50_99 ;
    109 :  dout <= 'h51_00 ;
    110 :  dout <= 'h52_28 ;
    111 :  dout <= 'h53_70 ;
    112 :  dout <= 'h54_99 ;
    113 :  dout <= 'h58_9E ;
    114 :  dout <= 'h76_E1 ;
    115 :  dout <= 'h11_01 ;
    116 :  dout <= 'h6B_40 ;
    117 :  dout <= 'h6E_11 ;
    118 :  dout <= 'h6F_9F ;
    119 :  dout <= 'h55_00 ;
    120 :  dout <= 'h56_40 ;
    121 :  dout <= 'h57_80 ;
default  dout <= 16'h57_80;
endcase
    
    
endmodule
