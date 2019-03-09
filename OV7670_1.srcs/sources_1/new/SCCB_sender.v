`timescale 1ns/1ns

module SCCB_TEST ;
    reg clk  = 0 ;
    always #5 clk = ~clk ;

    wire siod , sioc , ready ;
    reg valid ;

    reg [7:0] id,sub_addr,value ;

    pullup r1 (siod);

    SCCB_sender UT(
                    .clk( clk ),
                    .siod( siod ),
                    .sioc( sioc ),
                    .ready( ready ),
                    .valid( valid  ),
                    .id( id  ),
                    .sub_addr( sub_addr ),
                    .value( value  )
                );


    task send_cmd ;
        input [7:0] id_i,sub_addr_i,value_i ;
        begin
            id = id_i;
            sub_addr=sub_addr_i;
            value=value_i;
            valid=1;
            @(posedge clk);
            while(~ready)begin @(posedge clk);  end ;
            valid=0;
            @(posedge clk);
        end
    endtask


    initial begin
        valid=0;
        clk=0;
        @(posedge clk );
        send_cmd(1,2,3);
        send_cmd(1,'h55,'haa);
    end

endmodule

module SCCB_sender(
        input       clk,rst,
        inout       siod,
        output  reg   sioc,
        output  reg  ready = 0,
        input        valid,
        input [7:0] id,sub_addr,value,
        output reg error
    );

    reg [20:0] cntr  = 0 ;

    always @ (posedge clk) // valid有效时开始
        if (0==cntr)
            cntr <= valid ;
    /// begin if (valid )cntr <=  1 ;end  //valid ;
        else
        begin
            if ( 31 == cntr[20:11] ) cntr <= 0 ;  else cntr <= cntr + 1 ;
        end

    // 32  *  2 * k =  64 *1024 = 64k


    always @ (posedge clk) ready <=  (cntr == 0) && (valid ==1) ; //告诉上位机数据已经取走

    reg [7:0]idr,addr,val;//锁存要发送的数据
    always @(posedge clk)if ( ( cntr == 0 ) && ( valid == 1 ) ) idr   <=  id ;
    always @(posedge clk)if ( ( cntr == 0 ) && ( valid == 1 ) ) addr  <=  sub_addr ;
    always @(posedge clk)if ( ( cntr == 0 ) && ( valid == 1 ) ) val   <=  value ;

    reg SIOD_EN ; // 发送使能 为0则是输入

    always @ (posedge clk)

    case  ( cntr[20:11] )

        0: sioc <= 1 ;

        1: case (cntr[10:9])
            2'b00:  sioc <= 1 ;
            2'b01:  sioc <= 1 ;
            2'b10:  sioc <= 1 ;
            2'b11:  sioc <= 0 ;
        endcase

        29:
        case (cntr[10:9])
            2'b00:  sioc <= 0 ;
            2'b01:  sioc <= 1 ;
            2'b10:  sioc <= 1 ;
            2'b11:  sioc <= 1 ;
        endcase
        30,31: sioc <= 1 ;

        default
        case (cntr[10:9])
            2'b00:  sioc <= 0 ;
            2'b01:  sioc <= 1 ;
            2'b10:  sioc <= 1 ;
            2'b11:  sioc <= 0 ;
        endcase

    endcase

    //SIOD_EN
    always @ (posedge clk) //在三个DONOT-CARE 状态设置为输入状态
    case  (cntr[20:11])
        10,19,28 :SIOD_EN <=0 ;
        default SIOD_EN<=1;
    endcase

    reg SIOD_DAT ;//SIOD_DAT


    always @(posedge clk) //对应的SIOD的输出
    case (cntr[20:11])
        0:SIOD_DAT<=1;
        1:SIOD_DAT<=0;

        2:SIOD_DAT<=idr[7] ;
        3:SIOD_DAT<=idr[6] ;
        4:SIOD_DAT<=idr[5] ;
        5:SIOD_DAT<=idr[4] ;
        6:SIOD_DAT<=idr[3] ;
        7:SIOD_DAT<=idr[2] ;
        8:SIOD_DAT<=idr[1] ;
        9:SIOD_DAT<=idr[0] ;

        11:SIOD_DAT<=addr[7] ;
        12:SIOD_DAT<=addr[6] ;
        13:SIOD_DAT<=addr[5];
        14:SIOD_DAT<=addr[4];
        15:SIOD_DAT<=addr[3];
        16:SIOD_DAT<=addr[2];
        17:SIOD_DAT<=addr[1];
        18:SIOD_DAT<=addr[0];

        20:SIOD_DAT<=val[7] ;
        21:SIOD_DAT<=val[6] ;
        22:SIOD_DAT<=val[5] ;
        23:SIOD_DAT<=val[4] ;
        24:SIOD_DAT<=val[3] ;
        25:SIOD_DAT<=val[2] ;
        26:SIOD_DAT<=val[1] ;
        27:SIOD_DAT<=val[0] ;

        29:SIOD_DAT<=0;
        30:SIOD_DAT<=1;

        default SIOD_DAT<=1;

    endcase

    reg [31:0] dr ; //采用串行移位方式。

    always @ (posedge clk)
    if (rst)dr <=32'hffff_ffff ;else 
        if ( (cntr == 0) && (valid ==1 ) )
            dr <= {   2'b10,   id,1'bx, 	sub_addr,1'bx,     value, 1'bx,  3'b011    };
        else if ( cntr[10:0] == 0 ) dr <={dr[30:0],1'b1};

    assign siod = ( SIOD_EN ) ? dr[31] : 'BZ ;

    //  assign siod = ( SIOD_EN ) ? SIOD_DAT : 'BZ ;


    always @ (posedge clk)
        if (cntr[10:9] == 2'b01  )
        case(cntr[20:11])
            1: error<=0;
            10,19,28 :error <= error | siod ;
        endcase

endmodule
