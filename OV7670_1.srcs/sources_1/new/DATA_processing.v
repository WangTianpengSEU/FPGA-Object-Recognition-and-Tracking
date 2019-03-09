`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/29 10:53:39
// Design Name: 
// Module Name: DATA_processing
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


module DATA_processing(

    input camera_pclk,
    input [15:0]data,
    input clk_ram,
    input vga_clk,
    input clk12_5M,
    input camera_href,
    input camera_vsync,
    input [7:0]camera_data,
    input [10:0] x_cnt,
    input [9:0] y_cnt,
    input hsync_de,
    input vsync_de,
    output reg [15:0]Camera_data_out,
    output [15:0]vga_data,
    output [16:0]addra,
    output [16:0]addrb,
    
    input key2,
    input [1:0]Judge_mode
    
    );
    
    parameter Hde_start=144;
    parameter Vde_start=35;
   
    reg Camera_flag = 0;
    reg [7:0]camera_data_r = 0;
    reg [9:0]VS_count = 0;
    wire [16:0]addra;
    reg [8:0]addra_y = 0;
    reg [9:0]addra_x = 0;
    wire [16:0]addrb;
    reg flag_hs = 0;
    reg flag_vga_hs = 0;
    reg flag_vga_vs = 0;
    reg [9:0]addrb_x = 0;
    reg [8:0]addrb_y = 0;
    reg [15:0]data_mark = 0;
    
    reg Judge_threshold_r0 = 0;
    reg Judge_threshold_r1 = 0;
    reg Judge_threshold_r2 = 0;
    reg Judge_threshold_r3 = 0;
//    reg Judge_threshold_r4 = 0;
//    reg Judge_threshold_r5 = 0;
//    reg Judge_threshold_r6 = 0;
//    reg Judge_threshold_r7 = 0;
    reg Judge_threshold = 0;
    
    
    assign addra = {addra_y[8:1],addra_x[9:1]};
    assign addrb = {addrb_y[8:1],addrb_x[9:1]};
    
//        // G > 1.3*R  G > 1.2*B   Suitable for green ball
//    if({1'b0,Camera_data_out[9:5]} > ((42 * Camera_data_out[14:10])>>5) && {1'b0,Camera_data_out[9:5]} > ((38 * Camera_data_out[4:0])>>5))
//    Judge_threshold_r2 <= 1;
//    else
//    Judge_threshold_r2 <= 0;

//      // R > 1.5*B  R < 2.3*B  R > G  R < 1.2*G Suitable for YELLOW ball
//      if({1'b0,Camera_data_out[14:10]} > ((3 * Camera_data_out[4:0])>>1) && 
//      {1'b0,Camera_data_out[14:10]} < ((74 * Camera_data_out[4:0])>>5) &&
//        {1'b0,Camera_data_out[14:10]} > (32*(Camera_data_out[9:5])>>5) &&
//      {1'b0,Camera_data_out[14:10]} < ((38*(Camera_data_out[9:5]))>>5))       
//      Judge_threshold_r0 <= 1;
//      else
//      Judge_threshold_r0 <= 0;

    
  always@(posedge camera_pclk)
      begin
             // G > 1.3*R  G > 1.2*B   Suitable for green ball
        if({1'b0,Camera_data_out[9:5]} > ((42 * Camera_data_out[14:10])>>5) && {1'b0,Camera_data_out[9:5]} > ((38 * Camera_data_out[4:0])>>5))
          Judge_threshold_r0 <= 1;
          else
          Judge_threshold_r0 <= 0;
      // R > 1.5*B  R < 2.3*B  R > G  R < 1.2*G Suitable for YELLOW ball
              if({1'b0,Camera_data_out[14:10]} > ((3 * Camera_data_out[4:0])>>1) && 
              {1'b0,Camera_data_out[14:10]} < ((74 * Camera_data_out[4:0])>>5) &&
                {1'b0,Camera_data_out[14:10]} > (32*(Camera_data_out[9:5])>>5) &&
              {1'b0,Camera_data_out[14:10]} < ((38*(Camera_data_out[9:5]))>>5))       
              Judge_threshold_r1 <= 1;
              else
              Judge_threshold_r1 <= 0;
        
        case(Judge_mode)
        2'b00: Judge_threshold <= Judge_threshold_r0;
        2'b01: Judge_threshold <= Judge_threshold_r0;
        2'b10: Judge_threshold <= Judge_threshold_r1;
        2'b11: Judge_threshold <= Judge_threshold_r1;
        endcase 
        
            if(key2 && Judge_threshold)
               begin
                   data_mark <= 16'b0_11111_00000_00000;
               end
           else
               begin
                   data_mark <= Camera_data_out;
               end
        end
            
    always@(posedge camera_pclk)
        begin
            if(camera_href == 1)
                begin
                    Camera_flag <= ~Camera_flag;
                end
            else
                begin
                    Camera_flag <= 0;
                end
                
            camera_data_r <= camera_data;

            if(Camera_flag == 1)
                begin
                    Camera_data_out <= {camera_data_r,camera_data};
                end
            else
                begin
                    Camera_data_out <= Camera_data_out;
                end
        end

        always@(posedge clk12_5M)
            begin
                if(camera_vsync == 1 && VS_count < 10)
                    begin
                        VS_count <= VS_count + 1;
                    end
                else if(camera_vsync == 1 && VS_count == 10)
                    begin
                        addra_x <= 0;
                        addra_y <= 0;
                        VS_count <= VS_count + 1;
                    end
                else if(camera_vsync == 1 && VS_count > 10)
                    begin
                        VS_count <= VS_count;
                    end
                else if(camera_href == 1)
                    begin
                        addra_x <= addra_x + 1;
                        VS_count <= 0;
                        flag_hs <= 0;
                    end
                else if(camera_href == 0 && flag_hs == 0)
                    begin
                        flag_hs <= 1;
                        addra_y <= addra_y + 1;
                        addra_x <= 0;
                    end
                else
                    begin
                        addra_y <= addra_y;
                    end
            end
            
       always@(posedge vga_clk)
           begin
               if(vsync_de == 0)
                   begin
                       flag_vga_hs <= 0;
                       addrb_x <= 0;
                       addrb_y <= 0;
                   end
               else if(vsync_de == 1 && hsync_de == 0 && flag_vga_hs == 0)
                   begin
                       flag_vga_hs <= 1;
                       addrb_y <= addrb_y + 1;
                       addrb_x <= 0;
                   end
               else if(vsync_de == 1 && hsync_de == 1)
                   begin
                       flag_vga_hs <= 0;
                       addrb_x <= addrb_x + 1;
                   end
               else
                   begin
                       addrb_y <= addrb_y;
                       addrb_x <= addrb_x;
                       flag_vga_hs <= flag_vga_hs;
                   end
           end
        

        
        blk_mem_gen_0 your_instance_name (
          .clka(clk12_5M),    // input wire clka
          .wea(camera_href),      // input wire [0 : 0] wea
          .addra(addra),  // input wire [16 : 0] addra
          .dina(data_mark),    // input wire [15 : 0] dina
          .clkb(vga_clk),    // input wire clkb
          .addrb(addrb),  // input wire [16 : 0] addrb
          .doutb(vga_data)  // output wire [15 : 0] doutb
        );
endmodule
