
`timescale 1ns/1ps

module QR_Engine (
    i_clk,
    i_rst,
    i_trig,
    i_data,
    o_rd_vld,
    o_last_data,
    o_y_hat,
    o_r
);

// IO description
input          i_clk;
input          i_rst;
input          i_trig;
input  [ 47:0] i_data;
output         o_rd_vld;
output         o_last_data;
output [159:0] o_y_hat;
output [319:0] o_r;


///reg
reg [159:0]o_y_hat;
reg [319:0]o_r;

reg [7:0]Addr_Load;
wire CE;
wire WE;
reg enable;
wire [7:0]o_sram_0;
wire [7:0]o_sram_1;
wire [7:0]o_sram_2;
wire [7:0]o_sram_3;

wire [7:0]o_sram_4;
wire [7:0]o_sram_5;
reg calculate_finish;
wire calculate_enable;
wire read_enable;
reg reading;

reg signed[47:0]REG[19:0];
reg signed[39:0]output_w[3:0];

reg [50:0]sq_h;
wire [25:0]root;
reg [25:0]div_root;

//reg next_reading;
reg [7:0]cal_ind;

reg [23:0]div_in;
wire[39:0]div_res;
reg signed[25:0]div_in_root;

reg signed[47:0]e1[3:0];

reg signed[23:0]mult_in_a_1;
reg signed[23:0]mult_in_b_1;
reg signed[47:0]mult_res_1;

reg signed[23:0]mult_in_a_2;
reg signed[23:0]mult_in_b_2;
reg signed[47:0]mult_res_2;

reg signed[23:0]mult_in_a_3;
reg signed[23:0]mult_in_b_3;
reg signed[47:0]mult_res_3;

reg signed[23:0]mult_in_a_4;
reg signed[23:0]mult_in_b_4;
reg signed[47:0]mult_res_4;

reg signed[23:0]mult_in_a_5;
reg signed[23:0]mult_in_b_5;
reg signed[47:0]mult_res_5;

reg signed[23:0]mult_in_a_6;
reg signed[23:0]mult_in_b_6;
reg signed[47:0]mult_res_6;

reg signed[23:0]mult_in_a_7;
reg signed[23:0]mult_in_b_7;
reg signed[47:0]mult_res_7;

reg signed[23:0]mult_in_a_8;
reg signed[23:0]mult_in_b_8;
reg signed[47:0]mult_res_8;

reg signed[23:0]mult_in_a_9;
reg signed[23:0]mult_in_b_9;
reg signed[47:0]mult_res_9;

reg signed[23:0]mult_in_a_10;
reg signed[23:0]mult_in_b_10;
reg signed[47:0]mult_res_10;

reg signed[23:0]mult_in_a_11;
reg signed[23:0]mult_in_b_11;
reg signed[47:0]mult_res_11;

reg signed[23:0]mult_in_a_12;
reg signed[23:0]mult_in_b_12;
reg signed[47:0]mult_res_12;

reg bit1;
reg bit2;
reg bit3;
reg bit4;
reg bit5;
reg bit6;

reg [19:0]div_in_1;
reg [19:0]div_in_2;
reg [19:0]div_in_3;
reg [19:0]div_in_4;
reg [19:0]div_in_5;
reg [19:0]div_in_6;
reg [19:0]div_in_7;
reg [19:0]div_in_8;

wire [19:0]div_res_1;
wire [19:0]div_res_2;
wire [19:0]div_res_3;
wire [19:0]div_res_4;
wire [19:0]div_res_5;
wire [19:0]div_res_6;
wire [19:0]div_res_7;
wire [19:0]div_res_8;

reg [19:0]divisor;

reg [4:0]ind;

integer i;
integer j;

wire [47:0]y_ans;
assign y_ans=(mult_res_1)+(mult_res_2)+(mult_res_3)+(mult_res_4)+(mult_res_5)+(mult_res_6)+(mult_res_7)+(mult_res_8);
wire [47:0]y_ans_i;
assign y_ans_i=(-mult_res_1)+(-mult_res_2)+(-mult_res_3)+(-mult_res_4)+(mult_res_5)+(mult_res_6)+(mult_res_7)+(mult_res_8);
//////////////////////////////////////////////////////
assign WE=(i_trig)?0:1;
assign CE=0;
assign o_last_data=read_enable&&(Addr_Load==8'd200)&&o_rd_vld;
assign o_rd_vld=(cal_ind==8'd138)?1:0;
//assign enable=1;
//assign read_enable=(Addr_Load%20)?0:1;
//assign calculate_enable=(Addr_Load%20==0&&calculate_finish)?1:0;
assign calculate_enable=(ind==20&&calculate_finish)?1:0;
assign read_enable=(reading)?1:0;

wire [14:0]root_out;
assign root=root_out<<9;

//wire [7:0]tmp;
//assign tmp=(Addr_Load%20)-1;
//always@(*)begin
//	o_y_hat={output_w[3],output_w[2],output_w[1],output_w[0]};
//	o_r={REG[7][19:0],{REG[17][43:24],REG[17][19:0]},{REG[16][43:24],REG[16][19:0]},{REG[15][43:24],REG[15][19:0]},REG[2][19:0],{REG[11][43:24],REG[11][19:0]},{REG[10][43:24],REG[10][19:0]},REG[1][19:0],{REG[5][43:24],REG[5][19:0]},REG[0][19:0]};
//end
//
always@(*)begin////div 只有3個空格 第一次sqrt也只有3個 應該會出問題
	mult_in_a_1=0;
	mult_in_b_1=0;
	mult_in_a_2=0;
	mult_in_b_2=0;
	mult_in_a_3=0;
	mult_in_b_3=0;
	mult_in_a_4=0;
	mult_in_b_4=0;

	mult_in_a_5=0;
	mult_in_b_5=0;
	mult_in_a_6=0;
	mult_in_b_6=0;
	mult_in_a_7=0;
	mult_in_b_7=0;
	mult_in_a_8=0;
	mult_in_b_8=0;

	mult_in_a_9=0;
	mult_in_b_9=0;
	mult_in_a_10=0;
	mult_in_b_10=0;
	mult_in_a_11=0;
	mult_in_b_11=0;
	mult_in_a_12=0;
	mult_in_b_12=0;	
	div_in_1=0;
	div_in_2=0;
	div_in_3=0;
	div_in_4=0;
	div_in_5=0;
	div_in_6=0;
	div_in_7=0;
	div_in_8=0;
	divisor=0;

	div_in=0;
	sq_h=0;
	//div_in_root=0;
	case (cal_ind)//為了計算root 連續多算了好幾個乘感覺可以利用sram多餘的空間存
		8'd0:begin
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
			//$display("0:%0d",$signed(REG[0][23:0]));
			//$display("0:%0d",$signed(REG[0][47:24]));
			//$display("5:%0d",$signed(REG[0][23:0]));
			//$display("5:%0d",$signed(REG[0][47:24]));
			//$display("10:%0d",$signed(REG[0][23:0]));
			//$display("10:%0d",$signed(REG[0][47:24]));
			//$display("15:%0d",$signed(REG[0][23:0]));
			//$display("15:%0d",$signed(REG[0][47:24]));
		end
		8'd1:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
			//$display("res_1:%0d",$signed(mult_res_1[46:23]));
			//$display("res_2:%0d",$signed(mult_res_2[46:23]));
			//$display("res_3:%0d",$signed(mult_res_3[46:23]));
			//$display("res_4:%0d",$signed(mult_res_4[46:23]));
			//$display("res_5:%0d",$signed(mult_res_5[46:23]));
			//$display("res_6:%0d",$signed(mult_res_6[46:23]));
			//$display("res_7:%0d",$signed(mult_res_7[46:23]));
			//$display("res_8:%0d",$signed(mult_res_8[46:23]));
			//$display("sq:%0d",$signed(sq_h));
		end
		8'd2:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
		end
		8'd3:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
		end
		8'd4:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
		end
		8'd5:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
		end
		8'd6:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
		end
		8'd7:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
		end
		8'd8:begin
			//div_in=REG[0][23:0];//real
			div_in_1=REG[0][23:4];//real
			div_in_2=REG[0][47:28];
			div_in_3=REG[5][23:4];
			div_in_4=REG[5][47:28];
			div_in_5=REG[10][23:4];
			div_in_6=REG[10][47:28];
			div_in_7=REG[15][23:4];
			div_in_8=REG[15][47:28];

			divisor=root[23:4];
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
		end
		8'd9:begin
			//div_in=REG[0][47:24];//imag//最後一次用h11
			//div_in_root=root;
			div_in_1=REG[0][23:4];//real
			div_in_2=REG[0][47:28];
			div_in_3=REG[5][23:4];
			div_in_4=REG[5][47:28];
			div_in_5=REG[10][23:4];
			div_in_6=REG[10][47:28];
			div_in_7=REG[15][23:4];
			div_in_8=REG[15][47:28];


			divisor=root[23:4];
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
		end
		8'd10:begin
			//div_in=REG[5][23:0];
			//div_in_root={REG[0],bit1,bit2,bit3,bit4,bit5,bit6};
			div_in_1=REG[0][23:4];//real
			div_in_2=REG[0][47:28];
			div_in_3=REG[5][23:4];
			div_in_4=REG[5][47:28];
			div_in_5=REG[10][23:4];
			div_in_6=REG[10][47:28];
			div_in_7=REG[15][23:4];
			div_in_8=REG[15][47:28];


			divisor=root[23:4];
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
		end
		8'd11:begin
			//div_in=REG[5][47:24];
			//div_in_root={REG[0],bit1,bit2,bit3,bit4,bit5,bit6};
			div_in_1=REG[0][23:4];//real
			div_in_2=REG[0][47:28];
			div_in_3=REG[5][23:4];
			div_in_4=REG[5][47:28];
			div_in_5=REG[10][23:4];
			div_in_6=REG[10][47:28];
			div_in_7=REG[15][23:4];
			div_in_8=REG[15][47:28];


			divisor=root[23:4];
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
		end
		8'd12:begin
			//div_in=REG[10][23:0];
			//div_in_root={REG[0],bit1,bit2,bit3,bit4,bit5,bit6};
			div_in_1=REG[0][23:4];//real
			div_in_2=REG[0][47:28];
			div_in_3=REG[5][23:4];
			div_in_4=REG[5][47:28];
			div_in_5=REG[10][23:4];
			div_in_6=REG[10][47:28];
			div_in_7=REG[15][23:4];
			div_in_8=REG[15][47:28];


			divisor=root[23:4];
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
		end
		8'd13:begin
			//div_in=REG[10][47:24];
			//div_in_root={REG[0],bit1,bit2,bit3,bit4,bit5,bit6};
			div_in_1=REG[0][23:4];//real
			div_in_2=REG[0][47:28];
			div_in_3=REG[5][23:4];
			div_in_4=REG[5][47:28];
			div_in_5=REG[10][23:4];
			div_in_6=REG[10][47:28];
			div_in_7=REG[15][23:4];
			div_in_8=REG[15][47:28];


			divisor=root[23:4];
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
		end
		8'd14:begin
			div_in_1=REG[0][23:4];//real
			div_in_2=REG[0][47:28];
			div_in_3=REG[5][23:4];
			div_in_4=REG[5][47:28];
			div_in_5=REG[10][23:4];
			div_in_6=REG[10][47:28];
			div_in_7=REG[15][23:4];
			div_in_8=REG[15][47:28];
			


			divisor=root[23:4];
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);

			
		end
		8'd15:begin
			//div_in=REG[15][47:24];
			//div_in_root={REG[0],bit1,bit2,bit3,bit4,bit5,bit6};
			div_in_1=REG[0][23:4];//real
			div_in_2=REG[0][47:28];
			div_in_3=REG[5][23:4];
			div_in_4=REG[5][47:28];
			div_in_5=REG[10][23:4];
			div_in_6=REG[10][47:28];
			div_in_7=REG[15][23:4];
			div_in_8=REG[15][47:28];


			divisor=root[23:4];
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
		end
		8'd16:begin
			//////
			div_in_1=REG[0][23:4];//real
			div_in_2=REG[0][47:28];
			div_in_3=REG[5][23:4];
			div_in_4=REG[5][47:28];
			div_in_5=REG[10][23:4];
			div_in_6=REG[10][47:28];
			div_in_7=REG[15][23:4];
			div_in_8=REG[15][47:28];


			divisor=root[23:4];
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);

			
		end
		8'd17:begin
			div_in_1=REG[0][23:4];//real
			div_in_2=REG[0][47:28];
			div_in_3=REG[5][23:4];
			div_in_4=REG[5][47:28];
			div_in_5=REG[10][23:4];
			div_in_6=REG[10][47:28];
			div_in_7=REG[15][23:4];
			div_in_8=REG[15][47:28];


			divisor=root[23:4];
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
		end
		8'd18:begin
			div_in_1=REG[0][23:4];//real
			div_in_2=REG[0][47:28];
			div_in_3=REG[5][23:4];
			div_in_4=REG[5][47:28];
			div_in_5=REG[10][23:4];
			div_in_6=REG[10][47:28];
			div_in_7=REG[15][23:4];
			div_in_8=REG[15][47:28];


			divisor=root[23:4];
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);

			

		end
		8'd19:begin
			div_in_1=REG[0][23:4];//real
			div_in_2=REG[0][47:28];
			div_in_3=REG[5][23:4];
			div_in_4=REG[5][47:28];
			div_in_5=REG[10][23:4];
			div_in_6=REG[10][47:28];
			div_in_7=REG[15][23:4];
			div_in_8=REG[15][47:28];


			divisor=root[23:4];
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
		end
		8'd20:begin
			div_in_1=REG[0][23:4];//real
			div_in_2=REG[0][47:28];
			div_in_3=REG[5][23:4];
			div_in_4=REG[5][47:28];
			div_in_5=REG[10][23:4];
			div_in_6=REG[10][47:28];
			div_in_7=REG[15][23:4];
			div_in_8=REG[15][47:28];


			divisor=root[23:4];
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[0][23:0]);
			mult_in_b_1=$signed(REG[0][23:0]);
			mult_in_a_2=$signed(REG[0][47:24]);
			mult_in_b_2=$signed(REG[0][47:24]);

			mult_in_a_3=$signed(REG[5][23:0]);
			mult_in_b_3=$signed(REG[5][23:0]);
			mult_in_a_4=$signed(REG[5][47:24]);
			mult_in_b_4=$signed(REG[5][47:24]);

			mult_in_a_5=$signed(REG[10][23:0]);
			mult_in_b_5=$signed(REG[10][23:0]);
			mult_in_a_6=$signed(REG[10][47:24]);
			mult_in_b_6=$signed(REG[10][47:24]);

			mult_in_a_7=$signed(REG[15][23:0]);
			mult_in_b_7=$signed(REG[15][23:0]);
			mult_in_a_8=$signed(REG[15][47:24]);
			mult_in_b_8=$signed(REG[15][47:24]);
			
			
			
		end
		8'd21:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
		end
		8'd22:begin
			div_in_1=REG[0][23:4];//real
			div_in_2=REG[0][47:28];
			div_in_3=REG[5][23:4];
			div_in_4=REG[5][47:28];
			div_in_5=REG[10][23:4];
			div_in_6=REG[10][47:28];
			div_in_7=REG[15][23:4];
			div_in_8=REG[15][47:28];


			divisor=root[23:4];

			

			
		end
		8'd23:begin
			div_in_1=REG[0][23:4];//real
			div_in_2=REG[0][47:28];
			div_in_3=REG[5][23:4];
			div_in_4=REG[5][47:28];
			div_in_5=REG[10][23:4];
			div_in_6=REG[10][47:28];
			div_in_7=REG[15][23:4];
			div_in_8=REG[15][47:28];


			divisor=root[23:4];

			
		end
		8'd24:begin

			
			mult_in_a_1=$signed(REG[5][43:24]);
			mult_in_b_1=$signed(e1[0][23:0]);
			mult_in_a_2=$signed(REG[5][19:0]);
			mult_in_b_2=$signed(e1[0][47:24]);
			
			mult_in_a_3=$signed(REG[5][43:24]);
			mult_in_b_3=$signed(e1[1][23:0]);
			mult_in_a_4=$signed(REG[5][19:0]);
			mult_in_b_4=$signed(e1[1][47:24]);

			mult_in_a_5=$signed(REG[5][43:24]);
			mult_in_b_5=$signed(e1[2][23:0]);
			mult_in_a_6=$signed(REG[5][19:0]);
			mult_in_b_6=$signed(e1[2][47:24]);

			mult_in_a_7=$signed(REG[5][43:24]);
			mult_in_b_7=$signed(e1[3][23:0]);
			mult_in_a_8=$signed(REG[5][19:0]);
			mult_in_b_8=$signed(e1[3][47:24]);

			mult_in_a_9=$signed(REG[10][43:24]);
			mult_in_b_9=$signed(e1[0][23:0]);
			mult_in_a_10=$signed(REG[10][19:0]);
			mult_in_b_10=$signed(e1[0][47:24]);

			mult_in_a_11=$signed(REG[10][43:24]);
			mult_in_b_11=$signed(e1[1][23:0]);
			mult_in_a_12=$signed(REG[10][19:0]);
			mult_in_b_12=$signed(e1[1][47:24]);
			
		end
		8'd25:begin

			mult_in_a_1=$signed(REG[10][43:24]);
			mult_in_b_1=$signed(e1[2][23:0]);
			mult_in_a_2=$signed(REG[10][19:0]);
			mult_in_b_2=$signed(e1[2][47:24]);

			mult_in_a_3=$signed(REG[10][43:24]);
			mult_in_b_3=$signed(e1[3][23:0]);
			mult_in_a_4=$signed(REG[10][19:0]);
			mult_in_b_4=$signed(e1[3][47:24]);

			mult_in_a_5=$signed(REG[15][43:24]);
			mult_in_b_5=$signed(e1[0][23:0]);
			mult_in_a_6=$signed(REG[15][19:0]);
			mult_in_b_6=$signed(e1[0][47:24]);

			mult_in_a_7=$signed(REG[15][43:24]);
			mult_in_b_7=$signed(e1[1][23:0]);
			mult_in_a_8=$signed(REG[15][19:0]);
			mult_in_b_8=$signed(e1[1][47:24]);

			mult_in_a_9=$signed(REG[15][43:24]);
			mult_in_b_9=$signed(e1[2][23:0]);
			mult_in_a_10=$signed(REG[15][19:0]);
			mult_in_b_10=$signed(e1[2][47:24]);

			mult_in_a_11=$signed(REG[15][43:24]);
			mult_in_b_11=$signed(e1[3][23:0]);
			mult_in_a_12=$signed(REG[15][19:0]);
			mult_in_b_12=$signed(e1[3][47:24]);

		end
		8'd26:begin
			mult_in_a_1=$signed(REG[4][23:0]);
			mult_in_b_1=$signed(e1[0][19:0]);
			mult_in_a_2=$signed(REG[9][23:0]);
			mult_in_b_2=$signed(e1[1][19:0]);

			mult_in_a_3=$signed(REG[14][23:0]);
			mult_in_b_3=$signed(e1[2][19:0]);
			mult_in_a_4=$signed(REG[19][23:0]);
			mult_in_b_4=$signed(e1[3][19:0]);
			
			mult_in_a_5=$signed(REG[4][47:24]);
			mult_in_b_5=$signed(e1[0][43:24]);
			mult_in_a_6=$signed(REG[9][47:24]);
			mult_in_b_6=$signed(e1[1][43:24]);

			mult_in_a_7=$signed(REG[14][47:24]);
			mult_in_b_7=$signed(e1[2][43:24]);
			mult_in_a_8=$signed(REG[19][47:24]);
			mult_in_b_8=$signed(e1[3][43:24]);

		end
		8'd27:begin
			mult_in_a_1=$signed(REG[4][23:0]);
			mult_in_b_1=$signed(e1[0][43:24]);
			mult_in_a_2=$signed(REG[9][23:0]);
			mult_in_b_2=$signed(e1[1][43:24]);

			mult_in_a_3=$signed(REG[14][23:0]);
			mult_in_b_3=$signed(e1[2][43:24]);
			mult_in_a_4=$signed(REG[19][23:0]);
			mult_in_b_4=$signed(e1[3][43:24]);
			
			mult_in_a_5=$signed(REG[4][47:24]);
			mult_in_b_5=$signed(e1[0][19:0]);
			mult_in_a_6=$signed(REG[9][47:24]);
			mult_in_b_6=$signed(e1[1][19:0]);

			mult_in_a_7=$signed(REG[14][47:24]);
			mult_in_b_7=$signed(e1[2][19:0]);
			mult_in_a_8=$signed(REG[19][47:24]);
			mult_in_b_8=$signed(e1[3][19:0]);
			////

		end
		8'd28:begin
			mult_in_a_1=$signed(e1[0][19:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(e1[0][43:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(e1[0][19:0]);
			mult_in_b_3=$signed(REG[1][47:24]);
			mult_in_a_4=$signed(e1[0][43:24]);
			mult_in_b_4=$signed(REG[1][23:0]);

			mult_in_a_5=$signed(e1[0][19:0]);
			mult_in_b_5=$signed(REG[2][23:0]);
			mult_in_a_6=$signed(e1[0][43:24]);
			mult_in_b_6=$signed(REG[2][47:24]);

			mult_in_a_7=$signed(e1[0][19:0]);
			mult_in_b_7=$signed(REG[2][47:24]);
			mult_in_a_8=$signed(e1[0][43:24]);
			mult_in_b_8=$signed(REG[2][23:0]);

			mult_in_a_9=$signed(e1[0][19:0]);
			mult_in_b_9=$signed(REG[3][23:0]);
			mult_in_a_10=$signed(e1[0][43:24]);
			mult_in_b_10=$signed(REG[3][47:24]);

			mult_in_a_11=$signed(e1[0][19:0]);
			mult_in_b_11=$signed(REG[3][47:24]);
			mult_in_a_12=$signed(e1[0][43:24]);
			mult_in_b_12=$signed(REG[3][23:0]);

		end
		8'd29:begin
			mult_in_a_1=$signed(e1[1][19:0]);
			mult_in_b_1=$signed(REG[6][23:0]);
			mult_in_a_2=$signed(e1[1][43:24]);
			mult_in_b_2=$signed(REG[6][47:24]);

			mult_in_a_3=$signed(e1[1][19:0]);
			mult_in_b_3=$signed(REG[6][47:24]);
			mult_in_a_4=$signed(e1[1][43:24]);
			mult_in_b_4=$signed(REG[6][23:0]);

			mult_in_a_5=$signed(e1[1][19:0]);
			mult_in_b_5=$signed(REG[7][23:0]);
			mult_in_a_6=$signed(e1[1][43:24]);
			mult_in_b_6=$signed(REG[7][47:24]);

			mult_in_a_7=$signed(e1[1][19:0]);
			mult_in_b_7=$signed(REG[7][47:24]);
			mult_in_a_8=$signed(e1[1][43:24]);
			mult_in_b_8=$signed(REG[7][23:0]);

			mult_in_a_9=$signed(e1[1][19:0]);
			mult_in_b_9=$signed(REG[8][23:0]);
			mult_in_a_10=$signed(e1[1][43:24]);
			mult_in_b_10=$signed(REG[8][47:24]);

			mult_in_a_11=$signed(e1[1][19:0]);
			mult_in_b_11=$signed(REG[8][47:24]);
			mult_in_a_12=$signed(e1[1][43:24]);
			mult_in_b_12=$signed(REG[8][23:0]);

		end
		8'd30:begin
			mult_in_a_1=$signed(e1[2][19:0]);
			mult_in_b_1=$signed(REG[11][23:0]);
			mult_in_a_2=$signed(e1[2][43:24]);
			mult_in_b_2=$signed(REG[11][47:24]);

			mult_in_a_3=$signed(e1[2][19:0]);
			mult_in_b_3=$signed(REG[11][47:24]);
			mult_in_a_4=$signed(e1[2][43:24]);
			mult_in_b_4=$signed(REG[11][23:0]);

			mult_in_a_5=$signed(e1[2][19:0]);
			mult_in_b_5=$signed(REG[12][23:0]);
			mult_in_a_6=$signed(e1[2][43:24]);
			mult_in_b_6=$signed(REG[12][47:24]);

			mult_in_a_7=$signed(e1[2][19:0]);
			mult_in_b_7=$signed(REG[12][47:24]);
			mult_in_a_8=$signed(e1[2][43:24]);
			mult_in_b_8=$signed(REG[12][23:0]);

			mult_in_a_9=$signed(e1[2][19:0]);
			mult_in_b_9=$signed(REG[13][23:0]);
			mult_in_a_10=$signed(e1[2][43:24]);
			mult_in_b_10=$signed(REG[13][47:24]);

			mult_in_a_11=$signed(e1[2][19:0]);
			mult_in_b_11=$signed(REG[13][47:24]);
			mult_in_a_12=$signed(e1[2][43:24]);
			mult_in_b_12=$signed(REG[13][23:0]);
		end
		8'd31:begin
			mult_in_a_1=$signed(e1[3][19:0]);
			mult_in_b_1=$signed(REG[16][23:0]);
			mult_in_a_2=$signed(e1[3][43:24]);
			mult_in_b_2=$signed(REG[16][47:24]);

			mult_in_a_3=$signed(e1[3][19:0]);
			mult_in_b_3=$signed(REG[16][47:24]);
			mult_in_a_4=$signed(e1[3][43:24]);
			mult_in_b_4=$signed(REG[16][23:0]);

			mult_in_a_5=$signed(e1[3][19:0]);
			mult_in_b_5=$signed(REG[17][23:0]);
			mult_in_a_6=$signed(e1[3][43:24]);
			mult_in_b_6=$signed(REG[17][47:24]);

			mult_in_a_7=$signed(e1[3][19:0]);
			mult_in_b_7=$signed(REG[17][47:24]);
			mult_in_a_8=$signed(e1[3][43:24]);
			mult_in_b_8=$signed(REG[17][23:0]);

			mult_in_a_9=$signed(e1[3][19:0]);
			mult_in_b_9=$signed(REG[18][23:0]);
			mult_in_a_10=$signed(e1[3][43:24]);
			mult_in_b_10=$signed(REG[18][47:24]);

			mult_in_a_11=$signed(e1[3][19:0]);
			mult_in_b_11=$signed(REG[18][47:24]);
			mult_in_a_12=$signed(e1[3][43:24]);
			mult_in_b_12=$signed(REG[18][23:0]);
			
		end
		8'd32:begin
		end
		8'd33:begin
			mult_in_a_1=$signed(REG[5][22:3]+REG[5][2]);
			mult_in_b_1=$signed(e1[0][19:0]);
			mult_in_a_2=$signed(REG[5][46:27]+REG[5][26]);
			mult_in_b_2=$signed(e1[0][43:24]);

			mult_in_a_3=$signed(REG[5][22:3]+REG[5][2]);
			mult_in_b_3=$signed(e1[1][19:0]);
			mult_in_a_4=$signed(REG[5][46:27]+REG[5][26]);
			mult_in_b_4=$signed(e1[1][43:24]);
			
			mult_in_a_5=$signed(REG[5][22:3]+REG[5][2]);
			mult_in_b_5=$signed(e1[2][19:0]);
			mult_in_a_6=$signed(REG[5][46:27]+REG[5][26]);
			mult_in_b_6=$signed(e1[2][43:24]);

			mult_in_a_7=$signed(REG[5][22:3]+REG[5][2]);
			mult_in_b_7=$signed(e1[3][19:0]);
			mult_in_a_8=$signed(REG[5][46:27]+REG[5][26]);
			mult_in_b_8=$signed(e1[3][43:24]);

			mult_in_a_9=$signed(REG[10][22:3]+REG[10][2]);
			mult_in_b_9=$signed(e1[0][19:0]);
			mult_in_a_10=$signed(REG[10][46:27]+REG[10][26]);
			mult_in_b_10=$signed(e1[0][43:24]);

			mult_in_a_11=$signed(REG[10][22:3]+REG[10][2]);
			mult_in_b_11=$signed(e1[1][19:0]);
			mult_in_a_12=$signed(REG[10][46:27]+REG[10][26]);
			mult_in_b_12=$signed(e1[1][43:24]);
			//div_in=REG[1][23:0];
			//div_in_root=root;
		end
		8'd34:begin
			mult_in_a_1=$signed(REG[10][19:0]);
			mult_in_b_1=$signed(e1[2][19:0]);
			mult_in_a_2=$signed(REG[10][43:24]);
			mult_in_b_2=$signed(e1[2][43:24]);

			mult_in_a_3=$signed(REG[10][19:0]);
			mult_in_b_3=$signed(e1[3][19:0]);
			mult_in_a_4=$signed(REG[10][43:24]);
			mult_in_b_4=$signed(e1[3][43:24]);

			mult_in_a_5=$signed(REG[15][19:0]);
			mult_in_b_5=$signed(e1[0][19:0]);
			mult_in_a_6=$signed(REG[15][43:24]);
			mult_in_b_6=$signed(e1[0][43:24]);

			mult_in_a_7=$signed(REG[15][19:0]);
			mult_in_b_7=$signed(e1[1][19:0]);
			mult_in_a_8=$signed(REG[15][43:24]);
			mult_in_b_8=$signed(e1[1][43:24]);

			mult_in_a_9=$signed(REG[15][19:0]);
			mult_in_b_9=$signed(e1[2][19:0]);
			mult_in_a_10=$signed(REG[15][43:24]);
			mult_in_b_10=$signed(e1[2][43:24]);

			mult_in_a_11=$signed(REG[15][19:0]);
			mult_in_b_11=$signed(e1[3][19:0]);
			mult_in_a_12=$signed(REG[15][43:24]);
			mult_in_b_12=$signed(e1[3][43:24]);
		end
		8'd35:begin
			mult_in_a_1=$signed(REG[5][43:24]);
			mult_in_b_1=$signed(e1[0][19:0]);
			mult_in_a_2=$signed(REG[5][19:0]);
			mult_in_b_2=$signed(e1[0][43:24]);
			
			mult_in_a_3=$signed(REG[5][43:24]);
			mult_in_b_3=$signed(e1[1][19:0]);
			mult_in_a_4=$signed(REG[5][19:0]);
			mult_in_b_4=$signed(e1[1][43:24]);

			mult_in_a_5=$signed(REG[5][43:24]);
			mult_in_b_5=$signed(e1[2][19:0]);
			mult_in_a_6=$signed(REG[5][19:0]);
			mult_in_b_6=$signed(e1[2][43:24]);

			mult_in_a_7=$signed(REG[5][43:24]);
			mult_in_b_7=$signed(e1[3][19:0]);
			mult_in_a_8=$signed(REG[5][19:0]);
			mult_in_b_8=$signed(e1[3][43:24]);

			mult_in_a_9=$signed(REG[10][43:24]);
			mult_in_b_9=$signed(e1[0][19:0]);
			mult_in_a_10=$signed(REG[10][19:0]);
			mult_in_b_10=$signed(e1[0][43:24]);

			mult_in_a_11=$signed(REG[10][43:24]);
			mult_in_b_11=$signed(e1[1][19:0]);
			mult_in_a_12=$signed(REG[10][19:0]);
			mult_in_b_12=$signed(e1[1][43:24]);

			//div_in=REG[6][23:0];
			//div_in_root=REG[1];
		end
		8'd36:begin
			mult_in_a_1=$signed(REG[10][43:24]);
			mult_in_b_1=$signed(e1[2][19:0]);
			mult_in_a_2=$signed(REG[10][19:0]);
			mult_in_b_2=$signed(e1[2][43:24]);

			mult_in_a_3=$signed(REG[10][43:24]);
			mult_in_b_3=$signed(e1[3][19:0]);
			mult_in_a_4=$signed(REG[10][19:0]);
			mult_in_b_4=$signed(e1[3][43:24]);

			mult_in_a_5=$signed(REG[15][43:24]);
			mult_in_b_5=$signed(e1[0][19:0]);
			mult_in_a_6=$signed(REG[15][19:0]);
			mult_in_b_6=$signed(e1[0][43:24]);

			mult_in_a_7=$signed(REG[15][43:24]);
			mult_in_b_7=$signed(e1[1][19:0]);
			mult_in_a_8=$signed(REG[15][19:0]);
			mult_in_b_8=$signed(e1[1][43:24]);

			mult_in_a_9=$signed(REG[15][43:24]);
			mult_in_b_9=$signed(e1[2][19:0]);
			mult_in_a_10=$signed(REG[15][19:0]);
			mult_in_b_10=$signed(e1[2][43:24]);

			mult_in_a_11=$signed(REG[15][43:24]);
			mult_in_b_11=$signed(e1[3][19:0]);
			mult_in_a_12=$signed(REG[15][19:0]);
			mult_in_b_12=$signed(e1[3][43:24]);
		end
		8'd37:begin//iteration 1 little error should be next state
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
		
		end
		8'd38:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
			
		end
		8'd39:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
			
		end
		8'd40:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
		end
		
		8'd41:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
		end
		8'd42:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
		end
		8'd43:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
		end
		8'd44:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
		end
		8'd45:begin
			div_in_1=REG[1][19:0];//real
			div_in_2=REG[1][43:24];
			div_in_3=REG[6][19:0];
			div_in_4=REG[6][43:24];
			div_in_5=REG[11][19:0];
			div_in_6=REG[11][43:24];
			div_in_7=REG[16][19:0];
			div_in_8=REG[16][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);

		end
		8'd46:begin
			div_in_1=REG[1][19:0];//real
			div_in_2=REG[1][43:24];
			div_in_3=REG[6][19:0];
			div_in_4=REG[6][43:24];
			div_in_5=REG[11][19:0];
			div_in_6=REG[11][43:24];
			div_in_7=REG[16][19:0];
			div_in_8=REG[16][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
		end
		8'd47:begin
			div_in_1=REG[1][19:0];//real
			div_in_2=REG[1][43:24];
			div_in_3=REG[6][19:0];
			div_in_4=REG[6][43:24];
			div_in_5=REG[11][19:0];
			div_in_6=REG[11][43:24];
			div_in_7=REG[16][19:0];
			div_in_8=REG[16][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
			
		end
		8'd48:begin//算y^
			div_in_1=REG[1][19:0];//real
			div_in_2=REG[1][43:24];
			div_in_3=REG[6][19:0];
			div_in_4=REG[6][43:24];
			div_in_5=REG[11][19:0];
			div_in_6=REG[11][43:24];
			div_in_7=REG[16][19:0];
			div_in_8=REG[16][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
			
		end
		8'd49:begin//h-Re
			div_in_1=REG[1][19:0];//real
			div_in_2=REG[1][43:24];
			div_in_3=REG[6][19:0];
			div_in_4=REG[6][43:24];
			div_in_5=REG[11][19:0];
			div_in_6=REG[11][43:24];
			div_in_7=REG[16][19:0];
			div_in_8=REG[16][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
		end
		8'd50:begin
			div_in_1=REG[1][19:0];//real
			div_in_2=REG[1][43:24];
			div_in_3=REG[6][19:0];
			div_in_4=REG[6][43:24];
			div_in_5=REG[11][19:0];
			div_in_6=REG[11][43:24];
			div_in_7=REG[16][19:0];
			div_in_8=REG[16][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
			
		end
		8'd51:begin
			div_in_1=REG[1][19:0];//real
			div_in_2=REG[1][43:24];
			div_in_3=REG[6][19:0];
			div_in_4=REG[6][43:24];
			div_in_5=REG[11][19:0];
			div_in_6=REG[11][43:24];
			div_in_7=REG[16][19:0];
			div_in_8=REG[16][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);

			
		end
		8'd52:begin
			div_in_1=REG[1][19:0];//real
			div_in_2=REG[1][43:24];
			div_in_3=REG[6][19:0];
			div_in_4=REG[6][43:24];
			div_in_5=REG[11][19:0];
			div_in_6=REG[11][43:24];
			div_in_7=REG[16][19:0];
			div_in_8=REG[16][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
		end
		8'd53:begin
			div_in_1=REG[1][19:0];//real
			div_in_2=REG[1][43:24];
			div_in_3=REG[6][19:0];
			div_in_4=REG[6][43:24];
			div_in_5=REG[11][19:0];
			div_in_6=REG[11][43:24];
			div_in_7=REG[16][19:0];
			div_in_8=REG[16][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
		end
		8'd54:begin
			div_in_1=REG[1][19:0];//real
			div_in_2=REG[1][43:24];
			div_in_3=REG[6][19:0];
			div_in_4=REG[6][43:24];
			div_in_5=REG[11][19:0];
			div_in_6=REG[11][43:24];
			div_in_7=REG[16][19:0];
			div_in_8=REG[16][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
		end
		8'd55:begin
			div_in_1=REG[1][19:0];//real
			div_in_2=REG[1][43:24];
			div_in_3=REG[6][19:0];
			div_in_4=REG[6][43:24];
			div_in_5=REG[11][19:0];
			div_in_6=REG[11][43:24];
			div_in_7=REG[16][19:0];
			div_in_8=REG[16][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
		end
		8'd56:begin
			div_in_1=REG[1][19:0];//real
			div_in_2=REG[1][43:24];
			div_in_3=REG[6][19:0];
			div_in_4=REG[6][43:24];
			div_in_5=REG[11][19:0];
			div_in_6=REG[11][43:24];
			div_in_7=REG[16][19:0];
			div_in_8=REG[16][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
		end
		8'd57:begin
			div_in_1=REG[1][19:0];//real
			div_in_2=REG[1][43:24];
			div_in_3=REG[6][19:0];
			div_in_4=REG[6][43:24];
			div_in_5=REG[11][19:0];
			div_in_6=REG[11][43:24];
			div_in_7=REG[16][19:0];
			div_in_8=REG[16][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=$signed(REG[1][23:0]);
			mult_in_b_1=$signed(REG[1][23:0]);
			mult_in_a_2=$signed(REG[1][47:24]);
			mult_in_b_2=$signed(REG[1][47:24]);

			mult_in_a_3=$signed(REG[6][23:0]);
			mult_in_b_3=$signed(REG[6][23:0]);
			mult_in_a_4=$signed(REG[6][47:24]);
			mult_in_b_4=$signed(REG[6][47:24]);

			mult_in_a_5=$signed(REG[11][23:0]);
			mult_in_b_5=$signed(REG[11][23:0]);
			mult_in_a_6=$signed(REG[11][47:24]);
			mult_in_b_6=$signed(REG[11][47:24]);

			mult_in_a_7=$signed(REG[16][23:0]);
			mult_in_b_7=$signed(REG[16][23:0]);
			mult_in_a_8=$signed(REG[16][47:24]);
			mult_in_b_8=$signed(REG[16][47:24]);
		end
		8'd58:begin
			div_in_1=REG[1][19:0];//real
			div_in_2=REG[1][43:24];
			div_in_3=REG[6][19:0];
			div_in_4=REG[6][43:24];
			div_in_5=REG[11][19:0];
			div_in_6=REG[11][43:24];
			div_in_7=REG[16][19:0];
			div_in_8=REG[16][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
		end
		8'd59:begin
			div_in_1=REG[1][19:0];//real
			div_in_2=REG[1][43:24];
			div_in_3=REG[6][19:0];
			div_in_4=REG[6][43:24];
			div_in_5=REG[11][19:0];
			div_in_6=REG[11][43:24];
			div_in_7=REG[16][19:0];
			div_in_8=REG[16][43:24];

			divisor=root;
		end
		8'd60:begin
			div_in_1=REG[1][19:0];//real
			div_in_2=REG[1][43:24];
			div_in_3=REG[6][19:0];
			div_in_4=REG[6][43:24];
			div_in_5=REG[11][19:0];
			div_in_6=REG[11][43:24];
			div_in_7=REG[16][19:0];
			div_in_8=REG[16][43:24];

			divisor=root;
		end
		8'd61:begin
			div_in_1=REG[1][19:0];//real
			div_in_2=REG[1][43:24];
			div_in_3=REG[6][19:0];
			div_in_4=REG[6][43:24];
			div_in_5=REG[11][19:0];
			div_in_6=REG[11][43:24];
			div_in_7=REG[16][19:0];
			div_in_8=REG[16][43:24];

			divisor=root;
		end
		8'd62:begin
			//div_in=REG[7][47:24];
			//div_in_root=REG[2];
		end
		8'd63:begin
			mult_in_a_1=$signed(REG[4][23:0]);
			mult_in_b_1=$signed(e1[0][19:0]);
			mult_in_a_2=$signed(REG[9][23:0]);
			mult_in_b_2=$signed(e1[1][19:0]);

			mult_in_a_3=$signed(REG[14][23:0]);
			mult_in_b_3=$signed(e1[2][19:0]);
			mult_in_a_4=$signed(REG[19][23:0]);
			mult_in_b_4=$signed(e1[3][19:0]);
			
			mult_in_a_5=$signed(REG[4][47:24]);
			mult_in_b_5=$signed(e1[0][43:24]);
			mult_in_a_6=$signed(REG[9][47:24]);
			mult_in_b_6=$signed(e1[1][43:24]);

			mult_in_a_7=$signed(REG[14][47:24]);
			mult_in_b_7=$signed(e1[2][43:24]);
			mult_in_a_8=$signed(REG[19][47:24]);
			mult_in_b_8=$signed(e1[3][43:24]);
			//div_in=REG[12][23:0];
			//div_in_root=REG[2];
		end
		8'd64:begin
			
			mult_in_a_1=$signed(REG[4][23:0]);
			mult_in_b_1=$signed(e1[0][43:24]);
			mult_in_a_2=$signed(REG[9][23:0]);
			mult_in_b_2=$signed(e1[1][43:24]);

			mult_in_a_3=$signed(REG[14][23:0]);
			mult_in_b_3=$signed(e1[2][43:24]);
			mult_in_a_4=$signed(REG[19][23:0]);
			mult_in_b_4=$signed(e1[3][43:24]);
			
			mult_in_a_5=$signed(REG[4][47:24]);
			mult_in_b_5=$signed(e1[0][19:0]);
			mult_in_a_6=$signed(REG[9][47:24]);
			mult_in_b_6=$signed(e1[1][19:0]);

			mult_in_a_7=$signed(REG[14][47:24]);
			mult_in_b_7=$signed(e1[2][19:0]);
			mult_in_a_8=$signed(REG[19][47:24]);
			mult_in_b_8=$signed(e1[3][19:0]);
		end
		8'd65:begin
			mult_in_a_1=$signed(e1[0][19:0]);
			mult_in_b_1=$signed(REG[2][23:0]);
			mult_in_a_2=$signed(e1[0][43:24]);
			mult_in_b_2=$signed(REG[2][47:24]);

			mult_in_a_3=$signed(e1[0][19:0]);
			mult_in_b_3=$signed(REG[2][47:24]);
			mult_in_a_4=$signed(e1[0][43:24]);
			mult_in_b_4=$signed(REG[2][23:0]);

			mult_in_a_5=$signed(e1[0][19:0]);
			mult_in_b_5=$signed(REG[3][23:0]);
			mult_in_a_6=$signed(e1[0][43:24]);
			mult_in_b_6=$signed(REG[3][47:24]);

			mult_in_a_7=$signed(e1[0][19:0]);
			mult_in_b_7=$signed(REG[3][47:24]);
			mult_in_a_8=$signed(e1[0][43:24]);
			mult_in_b_8=$signed(REG[3][23:0]);
			
		end
		8'd66:begin
			mult_in_a_1=$signed(e1[1][19:0]);
			mult_in_b_1=$signed(REG[7][23:0]);
			mult_in_a_2=$signed(e1[1][43:24]);
			mult_in_b_2=$signed(REG[7][47:24]);

			mult_in_a_3=$signed(e1[1][19:0]);
			mult_in_b_3=$signed(REG[7][47:24]);
			mult_in_a_4=$signed(e1[1][43:24]);
			mult_in_b_4=$signed(REG[7][23:0]);

			mult_in_a_5=$signed(e1[1][19:0]);
			mult_in_b_5=$signed(REG[8][23:0]);
			mult_in_a_6=$signed(e1[1][43:24]);
			mult_in_b_6=$signed(REG[8][47:24]);

			mult_in_a_7=$signed(e1[1][19:0]);
			mult_in_b_7=$signed(REG[8][47:24]);
			mult_in_a_8=$signed(e1[1][43:24]);
			mult_in_b_8=$signed(REG[8][23:0]);
		end
		
		8'd67:begin
			mult_in_a_1=$signed(e1[2][19:0]);
			mult_in_b_1=$signed(REG[12][23:0]);
			mult_in_a_2=$signed(e1[2][43:24]);
			mult_in_b_2=$signed(REG[12][47:24]);

			mult_in_a_3=$signed(e1[2][19:0]);
			mult_in_b_3=$signed(REG[12][47:24]);
			mult_in_a_4=$signed(e1[2][43:24]);
			mult_in_b_4=$signed(REG[12][23:0]);

			mult_in_a_5=$signed(e1[2][19:0]);
			mult_in_b_5=$signed(REG[13][23:0]);
			mult_in_a_6=$signed(e1[2][43:24]);
			mult_in_b_6=$signed(REG[13][47:24]);

			mult_in_a_7=$signed(e1[2][19:0]);
			mult_in_b_7=$signed(REG[13][47:24]);
			mult_in_a_8=$signed(e1[2][43:24]);
			mult_in_b_8=$signed(REG[13][23:0]);

		end
		8'd68:begin
			mult_in_a_1=$signed(e1[3][19:0]);
			mult_in_b_1=$signed(REG[17][23:0]);
			mult_in_a_2=$signed(e1[3][43:24]);
			mult_in_b_2=$signed(REG[17][47:24]);

			mult_in_a_3=$signed(e1[3][19:0]);
			mult_in_b_3=$signed(REG[17][47:24]);
			mult_in_a_4=$signed(e1[3][43:24]);
			mult_in_b_4=$signed(REG[17][23:0]);

			mult_in_a_5=$signed(e1[3][19:0]);
			mult_in_b_5=$signed(REG[18][23:0]);
			mult_in_a_6=$signed(e1[3][43:24]);
			mult_in_b_6=$signed(REG[18][47:24]);

			mult_in_a_7=$signed(e1[3][19:0]);
			mult_in_b_7=$signed(REG[18][47:24]);
			mult_in_a_8=$signed(e1[3][43:24]);
			mult_in_b_8=$signed(REG[18][23:0]);
		end
		8'd69:begin
			mult_in_a_1=e1[2][23:0];
			mult_in_b_1=REG[13][23:0];
			mult_in_a_2=e1[2][47:24];
			mult_in_b_2=REG[13][47:24];

			mult_in_a_3=e1[2][23:0];
			mult_in_b_3=REG[13][47:24];
			mult_in_a_4=e1[2][47:24];
			mult_in_b_4=REG[13][23:0];

			//mult_in_a_1=e1[0][23:0];
			//mult_in_b_1=REG[3][23:0];
			//mult_in_a_2=e1[0][47:24];
			//mult_in_b_2=REG[3][47:24];
			//mult_in_a_3=e1[0][23:0];
			//mult_in_b_3=REG[3][47:24];
			//mult_in_a_4=e1[0][47:24];
			//mult_in_b_4=REG[3][23:0];

			mult_in_a_5=e1[1][23:0];
			mult_in_b_5=REG[8][23:0];
			mult_in_a_6=e1[1][47:24];
			mult_in_b_6=REG[8][47:24];
			mult_in_a_7=e1[1][23:0];
			mult_in_b_7=REG[8][47:24];
			mult_in_a_8=e1[1][47:24];
			mult_in_b_8=REG[8][23:0];

			mult_in_a_9=e1[2][23:0];
			mult_in_b_9=REG[13][23:0];
			mult_in_a_10=e1[2][47:24];
			mult_in_b_10=REG[13][47:24];
			mult_in_a_11=e1[2][23:0];
			mult_in_b_11=REG[13][47:24];
			mult_in_a_12=e1[2][47:24];
			mult_in_b_12=REG[13][23:0];
		end
		8'd70:begin
			mult_in_a_1=$signed(REG[11][22:3]+REG[11][2]);
			mult_in_b_1=$signed(e1[0][19:0]);
			mult_in_a_2=$signed(REG[11][46:27]+REG[11][26]);
			mult_in_b_2=$signed(e1[0][43:24]);

			mult_in_a_3=$signed(REG[11][22:3]+REG[11][2]);
			mult_in_b_3=$signed(e1[1][19:0]);
			mult_in_a_4=$signed(REG[11][46:27]+REG[11][26]);
			mult_in_b_4=$signed(e1[1][43:24]);
			
			mult_in_a_5=$signed(REG[11][22:3]+REG[11][2]);
			mult_in_b_5=$signed(e1[2][19:0]);
			mult_in_a_6=$signed(REG[11][46:27]+REG[11][26]);
			mult_in_b_6=$signed(e1[2][43:24]);

			mult_in_a_7=$signed(REG[11][22:3]+REG[11][2]);
			mult_in_b_7=$signed(e1[3][19:0]);
			mult_in_a_8=$signed(REG[11][46:27]+REG[11][26]);
			mult_in_b_8=$signed(e1[3][43:24]);

			mult_in_a_9=$signed(REG[16][22:3]+REG[16][2]);
			mult_in_b_9=$signed(e1[0][19:0]);
			mult_in_a_10=$signed(REG[16][46:27]+REG[16][26]);
			mult_in_b_10=$signed(e1[0][43:24]);

			mult_in_a_11=$signed(REG[16][22:3]+REG[16][2]);
			mult_in_b_11=$signed(e1[1][19:0]);
			mult_in_a_12=$signed(REG[16][46:27]+REG[16][26]);
			mult_in_b_12=$signed(e1[1][43:24]);
		end
		8'd71:begin
			mult_in_a_1=$signed(REG[16][19:0]);
			mult_in_b_1=$signed(e1[2][19:0]);
			mult_in_a_2=$signed(REG[16][43:24]);
			mult_in_b_2=$signed(e1[2][43:24]);

			mult_in_a_3=$signed(REG[16][19:0]);
			mult_in_b_3=$signed(e1[3][19:0]);
			mult_in_a_4=$signed(REG[16][43:24]);
			mult_in_b_4=$signed(e1[3][43:24]);


			mult_in_a_5=$signed(REG[11][43:24]);
			mult_in_b_5=$signed(e1[0][19:0]);
			mult_in_a_6=$signed(REG[11][19:0]);
			mult_in_b_6=$signed(e1[0][43:24]);

			mult_in_a_7=$signed(REG[11][43:24]);
			mult_in_b_7=$signed(e1[1][19:0]);
			mult_in_a_8=$signed(REG[11][19:0]);
			mult_in_b_8=$signed(e1[1][43:24]);

			mult_in_a_9=$signed(REG[11][43:24]);
			mult_in_b_9=$signed(e1[2][19:0]);
			mult_in_a_10=$signed(REG[11][19:0]);
			mult_in_b_10=$signed(e1[2][43:24]);

			mult_in_a_11=$signed(REG[11][43:24]);
			mult_in_b_11=$signed(e1[3][19:0]);
			mult_in_a_12=$signed(REG[11][19:0]);
			mult_in_b_12=$signed(e1[3][43:24]);

		end
		8'd72:begin
			mult_in_a_1=$signed(REG[16][43:24]);
			mult_in_b_1=$signed(e1[0][19:0]);
			mult_in_a_2=$signed(REG[16][19:0]);
			mult_in_b_2=$signed(e1[0][43:24]);

			mult_in_a_3=$signed(REG[16][43:24]);
			mult_in_b_3=$signed(e1[1][19:0]);
			mult_in_a_4=$signed(REG[16][19:0]);
			mult_in_b_4=$signed(e1[1][43:24]);

			mult_in_a_5=$signed(REG[16][43:24]);
			mult_in_b_5=$signed(e1[2][19:0]);
			mult_in_a_6=$signed(REG[16][19:0]);
			mult_in_b_6=$signed(e1[2][43:24]);

			mult_in_a_7=$signed(REG[16][43:24]);
			mult_in_b_7=$signed(e1[3][19:0]);
			mult_in_a_8=$signed(REG[16][19:0]);
			mult_in_b_8=$signed(e1[3][43:24]);
			
			
			
		end
		8'd73:begin

			mult_in_a_1=$signed(REG[17][23:4]+REG[17][3]);
			mult_in_b_1=$signed(e1[0][23:0]);
			mult_in_a_2=$signed(REG[17][47:28]+REG[17][27]);
			mult_in_b_2=$signed(e1[0][47:24]);

			mult_in_a_3=$signed(REG[17][23:4]+REG[17][3]);
			mult_in_b_3=$signed(e1[1][23:0]);
			mult_in_a_4=$signed(REG[17][47:28]+REG[17][27]);
			mult_in_b_4=$signed(e1[1][47:24]);

			mult_in_a_5=$signed(REG[17][23:4]+REG[17][3]);
			mult_in_b_5=$signed(e1[2][23:0]);
			mult_in_a_6=$signed(REG[17][47:28]+REG[17][27]);
			mult_in_b_6=$signed(e1[2][47:24]);

			mult_in_a_7=$signed(REG[17][23:4]+REG[17][3]);
			mult_in_b_7=$signed(e1[3][23:0]);
			mult_in_a_8=$signed(REG[17][47:28]+REG[17][27]);
			mult_in_b_8=$signed(e1[3][47:24]);

			
		end
		8'd74:begin//ite2
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd75:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd76:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd77:begin//ite3
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd78:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd79:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd80:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd81:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd82:begin
			div_in_1=REG[2][19:0];//real
			div_in_2=REG[2][43:24];
			div_in_3=REG[7][19:0];
			div_in_4=REG[7][43:24];
			div_in_5=REG[12][19:0];
			div_in_6=REG[12][43:24];
			div_in_7=REG[17][19:0];
			div_in_8=REG[17][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd83:begin
			div_in_1=REG[2][19:0];//real
			div_in_2=REG[2][43:24];
			div_in_3=REG[7][19:0];
			div_in_4=REG[7][43:24];
			div_in_5=REG[12][19:0];
			div_in_6=REG[12][43:24];
			div_in_7=REG[17][19:0];
			div_in_8=REG[17][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd84:begin
			div_in_1=REG[2][19:0];//real
			div_in_2=REG[2][43:24];
			div_in_3=REG[7][19:0];
			div_in_4=REG[7][43:24];
			div_in_5=REG[12][19:0];
			div_in_6=REG[12][43:24];
			div_in_7=REG[17][19:0];
			div_in_8=REG[17][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd85:begin
			div_in_1=REG[2][19:0];//real
			div_in_2=REG[2][43:24];
			div_in_3=REG[7][19:0];
			div_in_4=REG[7][43:24];
			div_in_5=REG[12][19:0];
			div_in_6=REG[12][43:24];
			div_in_7=REG[17][19:0];
			div_in_8=REG[17][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd86:begin
			div_in_1=REG[2][19:0];//real
			div_in_2=REG[2][43:24];
			div_in_3=REG[7][19:0];
			div_in_4=REG[7][43:24];
			div_in_5=REG[12][19:0];
			div_in_6=REG[12][43:24];
			div_in_7=REG[17][19:0];
			div_in_8=REG[17][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd87:begin
			div_in_1=REG[2][19:0];//real
			div_in_2=REG[2][43:24];
			div_in_3=REG[7][19:0];
			div_in_4=REG[7][43:24];
			div_in_5=REG[12][19:0];
			div_in_6=REG[12][43:24];
			div_in_7=REG[17][19:0];
			div_in_8=REG[17][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd88:begin
			div_in_1=REG[2][19:0];//real
			div_in_2=REG[2][43:24];
			div_in_3=REG[7][19:0];
			div_in_4=REG[7][43:24];
			div_in_5=REG[12][19:0];
			div_in_6=REG[12][43:24];
			div_in_7=REG[17][19:0];
			div_in_8=REG[17][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd89:begin
			div_in_1=REG[2][19:0];//real
			div_in_2=REG[2][43:24];
			div_in_3=REG[7][19:0];
			div_in_4=REG[7][43:24];
			div_in_5=REG[12][19:0];
			div_in_6=REG[12][43:24];
			div_in_7=REG[17][19:0];
			div_in_8=REG[17][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd90:begin
			div_in_1=REG[2][19:0];//real
			div_in_2=REG[2][43:24];
			div_in_3=REG[7][19:0];
			div_in_4=REG[7][43:24];
			div_in_5=REG[12][19:0];
			div_in_6=REG[12][43:24];
			div_in_7=REG[17][19:0];
			div_in_8=REG[17][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd91:begin
			div_in_1=REG[2][19:0];//real
			div_in_2=REG[2][43:24];
			div_in_3=REG[7][19:0];
			div_in_4=REG[7][43:24];
			div_in_5=REG[12][19:0];
			div_in_6=REG[12][43:24];
			div_in_7=REG[17][19:0];
			div_in_8=REG[17][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd92:begin
			div_in_1=REG[2][19:0];//real
			div_in_2=REG[2][43:24];
			div_in_3=REG[7][19:0];
			div_in_4=REG[7][43:24];
			div_in_5=REG[12][19:0];
			div_in_6=REG[12][43:24];
			div_in_7=REG[17][19:0];
			div_in_8=REG[17][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd93:begin
			div_in_1=REG[2][19:0];//real
			div_in_2=REG[2][43:24];
			div_in_3=REG[7][19:0];
			div_in_4=REG[7][43:24];
			div_in_5=REG[12][19:0];
			div_in_6=REG[12][43:24];
			div_in_7=REG[17][19:0];
			div_in_8=REG[17][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
		end
		8'd94:begin
			div_in_1=REG[2][19:0];//real
			div_in_2=REG[2][43:24];
			div_in_3=REG[7][19:0];
			div_in_4=REG[7][43:24];
			div_in_5=REG[12][19:0];
			div_in_6=REG[12][43:24];
			div_in_7=REG[17][19:0];
			div_in_8=REG[17][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[2][23:0];
			mult_in_b_1=REG[2][23:0];
			mult_in_a_2=REG[2][47:24];
			mult_in_b_2=REG[2][47:24];

			mult_in_a_3=REG[7][23:0];
			mult_in_b_3=REG[7][23:0];
			mult_in_a_4=REG[7][47:24];
			mult_in_b_4=REG[7][47:24];

			mult_in_a_5=REG[12][23:0];
			mult_in_b_5=REG[12][23:0];
			mult_in_a_6=REG[12][47:24];
			mult_in_b_6=REG[12][47:24];

			mult_in_a_7=REG[17][23:0];
			mult_in_b_7=REG[17][23:0];
			mult_in_a_8=REG[17][47:24];
			mult_in_b_8=REG[17][47:24];
			
		end
		8'd95:begin
			div_in_1=REG[2][19:0];//real
			div_in_2=REG[2][43:24];
			div_in_3=REG[7][19:0];
			div_in_4=REG[7][43:24];
			div_in_5=REG[12][19:0];
			div_in_6=REG[12][43:24];
			div_in_7=REG[17][19:0];
			div_in_8=REG[17][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
		end
		8'd96:begin
			div_in_1=REG[2][19:0];//real
			div_in_2=REG[2][43:24];
			div_in_3=REG[7][19:0];
			div_in_4=REG[7][43:24];
			div_in_5=REG[12][19:0];
			div_in_6=REG[12][43:24];
			div_in_7=REG[17][19:0];
			div_in_8=REG[17][43:24];

			divisor=root;
		end
		8'd97:begin
			div_in_1=REG[2][19:0];//real
			div_in_2=REG[2][43:24];
			div_in_3=REG[7][19:0];
			div_in_4=REG[7][43:24];
			div_in_5=REG[12][19:0];
			div_in_6=REG[12][43:24];
			div_in_7=REG[17][19:0];
			div_in_8=REG[17][43:24];

			divisor=root;
		end
		8'd98:begin
			div_in_1=REG[2][19:0];//real
			div_in_2=REG[2][43:24];
			div_in_3=REG[7][19:0];
			div_in_4=REG[7][43:24];
			div_in_5=REG[12][19:0];
			div_in_6=REG[12][43:24];
			div_in_7=REG[17][19:0];
			div_in_8=REG[17][43:24];

			divisor=root;
		end
		8'd99:begin
			mult_in_a_1=$signed(REG[4][23:0]);
			mult_in_b_1=$signed(e1[0][47:24]);
			mult_in_a_2=$signed(REG[9][23:0]);
			mult_in_b_2=$signed(e1[1][47:24]);

			mult_in_a_3=$signed(REG[14][23:0]);
			mult_in_b_3=$signed(e1[2][47:24]);
			mult_in_a_4=$signed(REG[19][23:0]);
			mult_in_b_4=$signed(e1[3][47:24]);
			
			mult_in_a_5=$signed(REG[4][47:24]);
			mult_in_b_5=$signed(e1[0][23:0]);
			mult_in_a_6=$signed(REG[9][47:24]);
			mult_in_b_6=$signed(e1[1][23:0]);

			mult_in_a_7=$signed(REG[14][47:24]);
			mult_in_b_7=$signed(e1[2][23:0]);
			mult_in_a_8=$signed(REG[19][47:24]);
			mult_in_b_8=$signed(e1[3][23:0]);
		end
		8'd100:begin
			mult_in_a_1=$signed(REG[4][23:0]);
			mult_in_b_1=$signed(e1[0][19:0]);
			mult_in_a_2=$signed(REG[9][23:0]);
			mult_in_b_2=$signed(e1[1][19:0]);

			mult_in_a_3=$signed(REG[14][23:0]);
			mult_in_b_3=$signed(e1[2][19:0]);
			mult_in_a_4=$signed(REG[19][23:0]);
			mult_in_b_4=$signed(e1[3][19:0]);
			
			mult_in_a_5=$signed(REG[4][47:24]);
			mult_in_b_5=$signed(e1[0][43:24]);
			mult_in_a_6=$signed(REG[9][47:24]);
			mult_in_b_6=$signed(e1[1][43:24]);

			mult_in_a_7=$signed(REG[14][47:24]);
			mult_in_b_7=$signed(e1[2][43:24]);
			mult_in_a_8=$signed(REG[19][47:24]);
			mult_in_b_8=$signed(e1[3][43:24]);

			mult_in_a_9=$signed(e1[0][19:0]);
			mult_in_b_9=$signed(REG[3][23:0]);
			mult_in_a_10=$signed(e1[0][43:24]);
			mult_in_b_10=$signed(REG[3][47:24]);

			mult_in_a_11=$signed(e1[0][19:0]);
			mult_in_b_11=$signed(REG[3][47:24]);
			mult_in_a_12=$signed(e1[0][43:24]);
			mult_in_b_12=$signed(REG[3][23:0]);
		end
		8'd101:begin
			
			mult_in_a_1=$signed(REG[4][23:0]);
			mult_in_b_1=$signed(e1[0][43:24]);
			mult_in_a_2=$signed(REG[9][23:0]);
			mult_in_b_2=$signed(e1[1][43:24]);

			mult_in_a_3=$signed(REG[14][23:0]);
			mult_in_b_3=$signed(e1[2][43:24]);
			mult_in_a_4=$signed(REG[19][23:0]);
			mult_in_b_4=$signed(e1[3][43:24]);
			
			mult_in_a_5=$signed(REG[4][47:24]);
			mult_in_b_5=$signed(e1[0][19:0]);
			mult_in_a_6=$signed(REG[9][47:24]);
			mult_in_b_6=$signed(e1[1][19:0]);

			mult_in_a_7=$signed(REG[14][47:24]);
			mult_in_b_7=$signed(e1[2][19:0]);
			mult_in_a_8=$signed(REG[19][47:24]);
			mult_in_b_8=$signed(e1[3][19:0]);

			mult_in_a_9=$signed(e1[1][19:0]);
			mult_in_b_9=$signed(REG[8][23:0]);
			mult_in_a_10=$signed(e1[1][43:24]);
			mult_in_b_10=$signed(REG[8][47:24]);

			mult_in_a_11=$signed(e1[1][19:0]);
			mult_in_b_11=$signed(REG[8][47:24]);
			mult_in_a_12=$signed(e1[1][43:24]);
			mult_in_b_12=$signed(REG[8][23:0]);
		end
		8'd102:begin
			mult_in_a_1=$signed(e1[2][19:0]);
			mult_in_b_1=$signed(REG[13][23:0]);
			mult_in_a_2=$signed(e1[2][43:24]);
			mult_in_b_2=$signed(REG[13][47:24]);

			mult_in_a_3=$signed(e1[3][19:0]);
			mult_in_b_3=$signed(REG[18][23:0]);
			mult_in_a_4=$signed(e1[3][43:24]);
			mult_in_b_4=$signed(REG[18][47:24]);

			mult_in_a_5=$signed(e1[2][19:0]);
			mult_in_b_5=$signed(REG[13][47:24]);
			mult_in_a_6=$signed(e1[2][43:24]);
			mult_in_b_6=$signed(REG[13][23:0]);

			mult_in_a_7=$signed(e1[3][19:0]);
			mult_in_b_7=$signed(REG[18][47:24]);
			mult_in_a_8=$signed(e1[3][43:24]);
			mult_in_b_8=$signed(REG[18][23:0]);
		end
		8'd103:begin
		end
		8'd104:begin
			mult_in_a_1=$signed(REG[17][23:4]+REG[17][3]);
			mult_in_b_1=$signed(e1[0][19:0]);
			mult_in_a_2=$signed(REG[17][47:28]+REG[17][27]);
			mult_in_b_2=$signed(e1[0][43:24]);

			mult_in_a_3=$signed(REG[17][23:4]+REG[17][3]);
			mult_in_b_3=$signed(e1[1][19:0]);
			mult_in_a_4=$signed(REG[17][47:28]+REG[17][27]);
			mult_in_b_4=$signed(e1[1][43:24]);

			mult_in_a_5=$signed(REG[17][23:4]+REG[17][3]);
			mult_in_b_5=$signed(e1[2][19:0]);
			mult_in_a_6=$signed(REG[17][47:28]+REG[17][27]);
			mult_in_b_6=$signed(e1[2][43:24]);

			mult_in_a_7=$signed(REG[17][23:4]+REG[17][3]);
			mult_in_b_7=$signed(e1[3][19:0]);
			mult_in_a_8=$signed(REG[17][47:28]+REG[17][27]);
			mult_in_b_8=$signed(e1[3][43:24]);
		end
		8'd105:begin
			mult_in_a_1=$signed(REG[17][43:24]);
			mult_in_b_1=$signed(e1[0][19:0]);
			mult_in_a_2=$signed(REG[17][19:0]);
			mult_in_b_2=$signed(e1[0][43:24]);

			mult_in_a_3=$signed(REG[17][43:24]);
			mult_in_b_3=$signed(e1[1][19:0]);
			mult_in_a_4=$signed(REG[17][19:0]);
			mult_in_b_4=$signed(e1[1][43:24]);

			mult_in_a_5=$signed(REG[17][43:24]);
			mult_in_b_5=$signed(e1[2][19:0]);
			mult_in_a_6=$signed(REG[17][19:0]);
			mult_in_b_6=$signed(e1[2][43:24]);

			mult_in_a_7=$signed(REG[17][43:24]);
			mult_in_b_7=$signed(e1[3][19:0]);
			mult_in_a_8=$signed(REG[17][19:0]);
			mult_in_b_8=$signed(e1[3][43:24]);
		end
		8'd108:begin//ite_4
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd109:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd110:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd111:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd112:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd113:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd114:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd115:begin
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd116:begin
			div_in_1=REG[3][19:0];//real
			div_in_2=REG[3][43:24];
			div_in_3=REG[8][19:0];
			div_in_4=REG[8][43:24];
			div_in_5=REG[13][19:0];
			div_in_6=REG[13][43:24];
			div_in_7=REG[18][19:0];
			div_in_8=REG[18][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd117:begin
			div_in_1=REG[3][19:0];//real
			div_in_2=REG[3][43:24];
			div_in_3=REG[8][19:0];
			div_in_4=REG[8][43:24];
			div_in_5=REG[13][19:0];
			div_in_6=REG[13][43:24];
			div_in_7=REG[18][19:0];
			div_in_8=REG[18][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd118:begin
			div_in_1=REG[3][19:0];//real
			div_in_2=REG[3][43:24];
			div_in_3=REG[8][19:0];
			div_in_4=REG[8][43:24];
			div_in_5=REG[13][19:0];
			div_in_6=REG[13][43:24];
			div_in_7=REG[18][19:0];
			div_in_8=REG[18][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd119:begin
			div_in_1=REG[3][19:0];//real
			div_in_2=REG[3][43:24];
			div_in_3=REG[8][19:0];
			div_in_4=REG[8][43:24];
			div_in_5=REG[13][19:0];
			div_in_6=REG[13][43:24];
			div_in_7=REG[18][19:0];
			div_in_8=REG[18][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd120:begin
			div_in_1=REG[3][19:0];//real
			div_in_2=REG[3][43:24];
			div_in_3=REG[8][19:0];
			div_in_4=REG[8][43:24];
			div_in_5=REG[13][19:0];
			div_in_6=REG[13][43:24];
			div_in_7=REG[18][19:0];
			div_in_8=REG[18][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd121:begin
			div_in_1=REG[3][19:0];//real
			div_in_2=REG[3][43:24];
			div_in_3=REG[8][19:0];
			div_in_4=REG[8][43:24];
			div_in_5=REG[13][19:0];
			div_in_6=REG[13][43:24];
			div_in_7=REG[18][19:0];
			div_in_8=REG[18][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd122:begin
			div_in_1=REG[3][19:0];//real
			div_in_2=REG[3][43:24];
			div_in_3=REG[8][19:0];
			div_in_4=REG[8][43:24];
			div_in_5=REG[13][19:0];
			div_in_6=REG[13][43:24];
			div_in_7=REG[18][19:0];
			div_in_8=REG[18][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd123:begin
			div_in_1=REG[3][19:0];//real
			div_in_2=REG[3][43:24];
			div_in_3=REG[8][19:0];
			div_in_4=REG[8][43:24];
			div_in_5=REG[13][19:0];
			div_in_6=REG[13][43:24];
			div_in_7=REG[18][19:0];
			div_in_8=REG[18][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd124:begin
			div_in_1=REG[3][19:0];//real
			div_in_2=REG[3][43:24];
			div_in_3=REG[8][19:0];
			div_in_4=REG[8][43:24];
			div_in_5=REG[13][19:0];
			div_in_6=REG[13][43:24];
			div_in_7=REG[18][19:0];
			div_in_8=REG[18][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd125:begin
			div_in_1=REG[3][19:0];//real
			div_in_2=REG[3][43:24];
			div_in_3=REG[8][19:0];
			div_in_4=REG[8][43:24];
			div_in_5=REG[13][19:0];
			div_in_6=REG[13][43:24];
			div_in_7=REG[18][19:0];
			div_in_8=REG[18][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd126:begin
			div_in_1=REG[3][19:0];//real
			div_in_2=REG[3][43:24];
			div_in_3=REG[8][19:0];
			div_in_4=REG[8][43:24];
			div_in_5=REG[13][19:0];
			div_in_6=REG[13][43:24];
			div_in_7=REG[18][19:0];
			div_in_8=REG[18][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd127:begin
			div_in_1=REG[3][19:0];//real
			div_in_2=REG[3][43:24];
			div_in_3=REG[8][19:0];
			div_in_4=REG[8][43:24];
			div_in_5=REG[13][19:0];
			div_in_6=REG[13][43:24];
			div_in_7=REG[18][19:0];
			div_in_8=REG[18][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd128:begin
			div_in_1=REG[3][19:0];//real
			div_in_2=REG[3][43:24];
			div_in_3=REG[8][19:0];
			div_in_4=REG[8][43:24];
			div_in_5=REG[13][19:0];
			div_in_6=REG[13][43:24];
			div_in_7=REG[18][19:0];
			div_in_8=REG[18][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
			mult_in_a_1=REG[3][23:0];
			mult_in_b_1=REG[3][23:0];
			mult_in_a_2=REG[3][47:24];
			mult_in_b_2=REG[3][47:24];

			mult_in_a_3=REG[8][23:0];
			mult_in_b_3=REG[8][23:0];
			mult_in_a_4=REG[8][47:24];
			mult_in_b_4=REG[8][47:24];

			mult_in_a_5=REG[13][23:0];
			mult_in_b_5=REG[13][23:0];
			mult_in_a_6=REG[13][47:24];
			mult_in_b_6=REG[13][47:24];

			mult_in_a_7=REG[18][23:0];
			mult_in_b_7=REG[18][23:0];
			mult_in_a_8=REG[18][47:24];
			mult_in_b_8=REG[18][47:24];
		end
		8'd129:begin
			div_in_1=REG[3][19:0];//real
			div_in_2=REG[3][43:24];
			div_in_3=REG[8][19:0];
			div_in_4=REG[8][43:24];
			div_in_5=REG[13][19:0];
			div_in_6=REG[13][43:24];
			div_in_7=REG[18][19:0];
			div_in_8=REG[18][43:24];

			divisor=root;
			sq_h=mult_res_1+mult_res_2+mult_res_3+mult_res_4+mult_res_5+mult_res_6+mult_res_7+mult_res_8;
			enable=1;
		end
		8'd130:begin
			div_in_1=REG[3][19:0];//real
			div_in_2=REG[3][43:24];
			div_in_3=REG[8][19:0];
			div_in_4=REG[8][43:24];
			div_in_5=REG[13][19:0];
			div_in_6=REG[13][43:24];
			div_in_7=REG[18][19:0];
			div_in_8=REG[18][43:24];

			divisor=root;
		end
		8'd131:begin
			div_in_1=REG[3][19:0];//real
			div_in_2=REG[3][43:24];
			div_in_3=REG[8][19:0];
			div_in_4=REG[8][43:24];
			div_in_5=REG[13][19:0];
			div_in_6=REG[13][43:24];
			div_in_7=REG[18][19:0];
			div_in_8=REG[18][43:24];

			divisor=root;
		end
		8'd132:begin
			div_in_1=REG[3][19:0];//real
			div_in_2=REG[3][43:24];
			div_in_3=REG[8][19:0];
			div_in_4=REG[8][43:24];
			div_in_5=REG[13][19:0];
			div_in_6=REG[13][43:24];
			div_in_7=REG[18][19:0];
			div_in_8=REG[18][43:24];

			divisor=root;
		end
		8'd134:begin
			mult_in_a_1=$signed(REG[4][23:0]);
			mult_in_b_1=$signed(e1[0][19:0]);
			mult_in_a_2=$signed(REG[9][23:0]);
			mult_in_b_2=$signed(e1[1][19:0]);

			mult_in_a_3=$signed(REG[14][23:0]);
			mult_in_b_3=$signed(e1[2][19:0]);
			mult_in_a_4=$signed(REG[19][23:0]);
			mult_in_b_4=$signed(e1[3][19:0]);
			
			mult_in_a_5=$signed(REG[4][47:24]);
			mult_in_b_5=$signed(e1[0][43:24]);
			mult_in_a_6=$signed(REG[9][47:24]);
			mult_in_b_6=$signed(e1[1][43:24]);

			mult_in_a_7=$signed(REG[14][47:24]);
			mult_in_b_7=$signed(e1[2][43:24]);
			mult_in_a_8=$signed(REG[19][47:24]);
			mult_in_b_8=$signed(e1[3][43:24]);
		end
		8'd135:begin
			mult_in_a_1=$signed(REG[4][23:0]);
			mult_in_b_1=$signed(e1[0][43:24]);
			mult_in_a_2=$signed(REG[9][23:0]);
			mult_in_b_2=$signed(e1[1][43:24]);

			mult_in_a_3=$signed(REG[14][23:0]);
			mult_in_b_3=$signed(e1[2][43:24]);
			mult_in_a_4=$signed(REG[19][23:0]);
			mult_in_b_4=$signed(e1[3][43:24]);
			
			mult_in_a_5=$signed(REG[4][47:24]);
			mult_in_b_5=$signed(e1[0][19:0]);
			mult_in_a_6=$signed(REG[9][47:24]);
			mult_in_b_6=$signed(e1[1][19:0]);

			mult_in_a_7=$signed(REG[14][47:24]);
			mult_in_b_7=$signed(e1[2][19:0]);
			mult_in_a_8=$signed(REG[19][47:24]);
			mult_in_b_8=$signed(e1[3][19:0]);
		end


		default:begin
			mult_in_a_1=0;
			mult_in_b_1=0;
			mult_in_a_2=0;
			mult_in_b_2=0;
			mult_in_a_3=0;
			mult_in_b_3=0;
			mult_in_a_4=0;
			mult_in_b_4=0;

			mult_in_a_5=0;
			mult_in_b_5=0;
			mult_in_a_6=0;
			mult_in_b_6=0;
			mult_in_a_7=0;
			mult_in_b_7=0;
			mult_in_a_8=0;
			mult_in_b_8=0;

			mult_in_a_9=0;
			mult_in_b_9=0;
			mult_in_a_10=0;
			mult_in_b_10=0;
			mult_in_a_11=0;
			mult_in_b_11=0;
			mult_in_a_12=0;
			mult_in_b_12=0;
			sq_h=0;
			
		end
	endcase
end
always@(posedge i_clk or posedge i_rst)begin
    if(i_rst)begin
        Addr_Load<=0;
		calculate_finish<=0;
		reading<=0;
		ind<=0;
		bit1<=0;
		bit2<=0;
		bit3<=0;
		bit4<=0;
		bit5<=0;
		bit6<=0;
		cal_ind<=0;
		o_y_hat<=0;
		o_r<=0;
		for(j=0;j<4;j=j+1)begin
            e1[j]<=0;
        end
		for(i=0;i<20;i=i+1)begin
            REG[i]<=0;
        end
    end
    else if(i_trig)begin
		if(Addr_Load==8'd199)begin
			Addr_Load<=0;
			reading<=1;
		end
		else begin
        	Addr_Load<=Addr_Load+1;
		end
	end
	else if (calculate_enable)begin//可以考慮分開ㄌ	
		cal_ind<=cal_ind+1;
		Addr_Load<=(o_last_data)?0:Addr_Load;
		case(cal_ind)
			8'd0:REG[19]<={o_sram_5,o_sram_4,o_sram_3,o_sram_2,o_sram_1,o_sram_0};
			8'd1:begin
				//$display("in:%h",sq_h);

			end
			8'd2:begin
				//$display("sq_h",sq_h);
			end
			8'd5:begin
				//$display("REG:%h",REG[0][23:4]);
				//$display("root:%h",root[25:6]);
				//$display("REG_ori:%h",REG[0][23:0]);
				//$display("root_ori:%h",root[25:0]);
				//$display("div_in:%h",div_in_1);
				//$display("div:%h",root);

			end
			8'd6:begin
				//{REG[0],bit1,bit2,bit3,bit4,bit5,bit6}<=root;
				
			end
			//7'd7:begin
			//end
			//7'd9:
			8'd10:begin
				

				
			end
			8'd11:begin

			end
			8'd12:begin//感覺乘法器可以再少一半

				
			end
			8'd13:begin
				//$display("%h",REG[5][23:0]);
				//$display("%h",mult_res_1[46:24]>>>1);
				//$display("%h",mult_res_2[46:24]>>>1);


				//REG[0]<=root[25:6]+root[5];
				
				//e1[2][23:0]<=div_res[23:0];
			end
			8'd14:begin
			
		

				
			end
			8'd15:begin
				//e1[3][23:0]<=div_res[23:0];
			end
			8'd16:begin
				
			end
			8'd17:begin
			end
			8'd18:begin
				
			end
			8'd19:begin
			end
			8'd20:begin//r
				
			end
			8'd21:begin
				
				
			end
			8'd25:begin
				
				e1[0][23:0]<=div_res_1;
				e1[0][47:24]<=div_res_2;
				e1[1][23:0]<=div_res_3;
				e1[1][47:24]<=div_res_4;
				e1[2][23:0]<=div_res_5;
				e1[2][47:24]<=div_res_6;
				e1[3][23:0]<=div_res_7;
				e1[3][47:24]<=div_res_8;
				REG[0]<=root[25:6]+root[5];
				//$display("root:%b",root);
				

				
			end
			8'd23:begin
				//$display("e:%b",e1[0][23:0]);
				//$display("e:%b",24'h00906c);
				//$display("e:%h",e1[0][47:24]);
				//$display("e:%h",e1[1][23:0]);
				//$display("e:%h",e1[1][47:24]);
				//$display("e:%h",e1[2][23:0]);
				//$display("e:%h",e1[2][47:24]);
				//$display("e:%h",e1[3][23:0]);
				//$display("e:%h",e1[3][47:24]);
			
	
			end
			8'd27:begin
				output_w[0][19:0]<=y_ans[41:22];
				//$display("mult_res_1:%h",mult_res_1);
				//$display("mult_res_2:%h",mult_res_2);
				//$display("mult_res_3:%h",mult_res_3);
				//$display("mult_res_4:%h",mult_res_4);
				//$display("mult_res_5:%h",mult_res_5);
				//$display("mult_res_6:%h",mult_res_6);
				//$display("mult_res_7:%h",mult_res_7);
				//$display("mult_res_8:%h",mult_res_8);
		

			end
			8'd28:begin
				output_w[0][39:20]<=y_ans_i[41:22];
				///$display("mult_in_a_1:%h",mult_in_a_1);
				//$display("ans:%b",24'hfd94ba);
				//$display("mult_in_b_1:%b",mult_in_b_1);
				//$display("ans:%b",24'hfd94ba);
				
			end
			8'd29:begin
				REG[5][23:0]<=((mult_res_1[42:19])+(mult_res_2[42:19])); //沒sign可能有問題
				REG[5][47:24]<=((mult_res_3[42:19])-(mult_res_4[42:19])); 
				REG[10][23:0]<=((mult_res_5[42:19])+(mult_res_6[42:19]));
				REG[10][47:24]<=((mult_res_7[42:19])-(mult_res_8[42:19]));
				REG[15][23:0]<=((mult_res_9[42:19])+(mult_res_10[42:19]));
				REG[15][47:24]<=((mult_res_11[42:19])-(mult_res_12[42:19]));
				
				//mult_in_a_1=e1[1][19:0];
				//mult_in_b_1=REG[6][23:0];
				
			end
			8'd30:begin
				REG[5][23:0]<=REG[5][23:0]+((mult_res_1[42:19])+(mult_res_2[42:19]));
				REG[5][47:24]<=REG[5][47:24]+((mult_res_3[42:19])-(mult_res_4[42:19])); 
				REG[10][23:0]<=REG[10][23:0]+((mult_res_5[42:19])+(mult_res_6[42:19]));
				REG[10][47:24]<=REG[10][47:24]+((mult_res_7[42:19])-(mult_res_8[42:19]));
				REG[15][23:0]<=REG[15][23:0]+((mult_res_9[42:19])+(mult_res_10[42:19]));
				REG[15][47:24]<=REG[15][47:24]+((mult_res_11[42:19])-(mult_res_12[42:19]));

				
				
			end
			8'd31:begin
				REG[5][23:0]<=REG[5][23:0]+((mult_res_1[42:19])+(mult_res_2[42:19]));
				REG[5][47:24]<=REG[5][47:24]+((mult_res_3[42:19])-(mult_res_4[42:19])); 
				REG[10][23:0]<=REG[10][23:0]+((mult_res_5[42:19])+(mult_res_6[42:19]));
				REG[10][47:24]<=REG[10][47:24]+((mult_res_7[42:19])-(mult_res_8[42:19]));
				REG[15][23:0]<=REG[15][23:0]+((mult_res_9[42:19])+(mult_res_10[42:19]));
				REG[15][47:24]<=REG[15][47:24]+((mult_res_11[42:19])-(mult_res_12[42:19]));
				
				
			end
			8'd32:begin
				REG[5][23:0]<=REG[5][23:0]+((mult_res_1[42:19])+(mult_res_2[42:19]));
				REG[5][47:24]<=REG[5][47:24]+((mult_res_3[42:19])-(mult_res_4[42:19])); 
				REG[10][23:0]<=REG[10][23:0]+((mult_res_5[42:19])+(mult_res_6[42:19]));
				REG[10][47:24]<=REG[10][47:24]+((mult_res_7[42:19])-(mult_res_8[42:19]));
				REG[15][23:0]<=REG[15][23:0]+((mult_res_9[42:19])+(mult_res_10[42:19]));
				REG[15][47:24]<=REG[15][47:24]+((mult_res_11[42:19])-(mult_res_12[42:19]));
				//$display("REG[5]:%h",REG[5][23:0]);
				//$display("REG[5]:%h",REG[5][47:24]);
		
			
			end
			8'd33:begin
				REG[5][23:0]<=$signed(REG[5][22:3])+$signed(REG[5][2]);
				REG[5][47:24]<=$signed(REG[5][46:27])+$signed(REG[5][26]);
				REG[10][23:0]<=$signed(REG[10][22:3])+$signed(REG[10][2]);
				REG[10][47:24]<=$signed(REG[10][46:27])+$signed(REG[10][26]);
				REG[15][23:0]<=$signed(REG[15][22:3])+$signed(REG[15][2]);
				REG[15][47:24]<=$signed(REG[15][46:27])+$signed(REG[15][26]);
				
			end
			8'd34:begin
				{REG[1][23:0],bit1}<=($signed({REG[1][23:0],{10'd0}})-$signed(mult_res_1-mult_res_2[39:0]))>>15;//2要改成下一個clock的a
				{REG[6][23:0],bit2}<=($signed({REG[6][23:0],{10'd0}})-$signed(mult_res_3-mult_res_4[39:0]))>>15;//
				{REG[11][23:0],bit3}<=($signed({REG[11][23:0],{10'd0}})-$signed(mult_res_5-mult_res_6[39:0]))>>15;//
				{REG[16][23:0],bit4}<=($signed({REG[16][23:0],{10'd0}})-$signed(mult_res_7-mult_res_8[39:0]))>>15;//
				{REG[2][23:0],bit5}<=($signed({REG[2][23:0],{10'd0}})-$signed(mult_res_9-mult_res_10[39:0]))>>15;//
				{REG[7][23:0],bit6}<=($signed({REG[7][23:0],{10'd0}})-$signed(mult_res_11-mult_res_12[39:0]))>>15;//
				//REG[1]<=root;
				//div_root<=root;
			end
			8'd35:begin
				{REG[12][23:0],bit1}<=($signed({REG[12][23:0],{10'd0}})-$signed(mult_res_1-mult_res_2[39:0]))>>15;//
				{REG[17][23:0],bit2}<=($signed({REG[17][23:0],{10'd0}})-$signed(mult_res_3-mult_res_4[39:0]))>>15;//
				{REG[3][23:0],bit3}<=($signed({REG[3][23:0],{10'd0}})-$signed(mult_res_5-mult_res_6[39:0]))>>15;//
				{REG[8][23:0],bit4}<=($signed({REG[8][23:0],{10'd0}})-$signed(mult_res_7-mult_res_8[39:0]))>>15;//
				{REG[13][23:0],bit5}<=($signed({REG[13][23:0],{10'd0}})-$signed(mult_res_9-mult_res_10[39:0]))>>15;//
				{REG[18][23:0],bit6}<=($signed({REG[18][23:0],{10'd0}})-$signed(mult_res_11-mult_res_12[39:0]))>>15;//
				
				REG[1][23:0]<=REG[1][23:0]+bit1;
				REG[6][23:0]<=REG[6][23:0]+bit2;
				REG[11][23:0]<=REG[11][23:0]+bit3;
				REG[16][23:0]<=REG[16][23:0]+bit4;
				REG[2][23:0]<=REG[2][23:0]+bit5;
				REG[7][23:0]<=REG[7][23:0]+bit6;
				//$display("REG[1],%b",REG[1]);
				//$display("div_root,%b",div_root);

			end
			8'd36:begin
				{REG[1][47:24],bit1}<=($signed({REG[1][47:24],{10'd0}})-$signed(mult_res_1+mult_res_2[39:0]))>>15;//2要改成下一個clock的a
				{REG[6][47:24],bit2}<=($signed({REG[6][47:24],{10'd0}})-$signed(mult_res_3+mult_res_4[39:0]))>>15;//
				{REG[11][47:24],bit3}<=($signed({REG[11][47:24],{10'd0}})-$signed(mult_res_5+mult_res_6[39:0]))>>15;//
				{REG[16][47:24],bit4}<=($signed({REG[16][47:24],{10'd0}})-$signed(mult_res_7+mult_res_8[39:0]))>>15;//
				{REG[2][47:24],bit5}<=($signed({REG[2][47:24],{10'd0}})-$signed(mult_res_9+mult_res_10[39:0]))>>15;//
				{REG[7][47:24],bit6}<=($signed({REG[7][47:24],{10'd0}})-$signed(mult_res_11+mult_res_12[39:0]))>>15;//


				REG[12][23:0]<=REG[12][23:0]+bit1;
				REG[17][23:0]<=REG[17][23:0]+bit2;
				REG[3][23:0]<=REG[3][23:0]+bit3;
				REG[8][23:0]<=REG[8][23:0]+bit4;
				REG[13][23:0]<=REG[13][23:0]+bit5;
				REG[18][23:0]<=REG[18][23:0]+bit6;
			end
			8'd37:begin
				{REG[12][47:24],bit1}<=($signed({REG[12][47:24],{10'd0}})-$signed(mult_res_1+mult_res_2[39:0]))>>15;//2要改成下一個clock的a
				{REG[17][47:24],bit2}<=($signed({REG[17][47:24],{10'd0}})-$signed(mult_res_3+mult_res_4[39:0]))>>15;//
				{REG[3][47:24],bit3}<=($signed({REG[3][47:24],{10'd0}})-$signed(mult_res_5+mult_res_6[39:0]))>>15;//
				{REG[8][47:24],bit4}<=($signed({REG[8][47:24],{10'd0}})-$signed(mult_res_7+mult_res_8[39:0]))>>15;//
				{REG[13][47:24],bit5}<=($signed({REG[13][47:24],{10'd0}})-$signed(mult_res_9+mult_res_10[39:0]))>>15;//
				{REG[18][47:24],bit6}<=($signed({REG[18][47:24],{10'd0}})-$signed(mult_res_11+mult_res_12[39:0]))>>15;//
				


				REG[1][47:24]<=REG[1][47:24]+bit1;
				REG[6][47:24]<=REG[6][47:24]+bit2;
				REG[11][47:24]<=REG[11][47:24]+bit3;
				REG[16][47:24]<=REG[16][47:24]+bit4;
				REG[2][47:24]<=REG[2][47:24]+bit5;
				REG[7][47:24]<=REG[7][47:24]+bit6;

				//e1[0][23:0]<=div_res;
			end
			8'd38:begin
				REG[12][47:24]<=REG[12][47:24]+bit1;
				REG[17][47:24]<=REG[17][47:24]+bit2;
				REG[3][47:24]<=REG[3][47:24]+bit3;
				REG[8][47:24]<=REG[8][47:24]+bit4;
				REG[13][47:24]<=REG[13][47:24]+bit5;
				REG[18][47:24]<=REG[18][47:24]+bit6;
				//$display("H2[0]_i:%h",REG[1][47:24]);
				//$display("H2[1]_i:%h",REG[6][47:24]);
				//$display("H2[2]_i:%h",REG[11][47:24]);	
				//$display("H2[3]_i:%h",REG[16][47:24]);

				//$display("H2[0]_r:%h",REG[1][23:0]);
				//$display("H2[1]_r:%h",REG[6][23:0]);
				//$display("H2[2]_r:%h",REG[11][23:0]);	
				//$display("H2[3]_r:%h",REG[16][23:0]);
				//e1[0][47:24]<=div_res;
			end
			
			//7'd37:begin
				

			//end
			//7'd38:begin
				
				
			//end
			8'd39:begin
				
				

			end
			8'd40:begin
				//e1[3][23:0]<=div_res;
				//$display("mult_in_b_1:%d",mult_in_b_1);
				//$display("mult_in_a_1:%d",mult_in_a_1);
				//$display("mult_in_b_2:%d",mult_in_b_2);
				//$display("mult_in_a_2:%d",mult_in_a_2);
				
			end
			8'd41:begin
				//e1[3][47:24]<=div_res;
				//REG[11][23:0]<=REG[11][23:0]+((mult_res_1[36:13])+(mult_res_2[36:13]));
				//REG[11][47:24]<=REG[11][47:24]+((mult_res_3[36:13])-(mult_res_4[36:13])); 
				//REG[16][23:0]<=REG[16][23:0]+((mult_res_5[36:13])+(mult_res_6[36:13]));
				//REG[16][47:24]<=REG[16][47:24]+((mult_res_7[36:13])-(mult_res_8[36:13]));
				//tmp_r12<=tmp_r12+$signed(mult_res_1[34:11])+$signed(mult_res_2[34:11]);

				//output_w[1][23:0]<=output_w[1][23:0]+mult_res_1[46:24]>>>1+mult_res_2[46:24]>>>1;
				//output_w[1][47:24]<=output_w[1][47:24]+mult_res_3[46:24]>>>1+mult_res_4[46:24]>>>1;
			end
			//7'd39:
			8'd42:begin
				
			end
			8'd43:begin
				//REG[11][23:0]<=REG[11][23:0]+((mult_res_1[36:13])+(mult_res_2[36:13]));
				//REG[11][47:24]<=REG[11][47:24]+((mult_res_3[36:13])-(mult_res_4[36:13])); 
				//REG[16][23:0]<=REG[16][23:0]+((mult_res_5[36:13])+(mult_res_6[36:13]));
				//REG[16][47:24]<=REG[16][47:24]+((mult_res_7[36:13])-(mult_res_8[36:13]));
				//tmp_r12<=tmp_r12+$signed(mult_res_1[34:11])+$signed(mult_res_2[34:11]);

				//REG[11][23:0]<=REG[11][23:0]+mult_res_1[46:24]>>>1+mult_res_2[46:24]>>>1;
				//REG[11][47:24]<=REG[11][47:24]+mult_res_3[46:24]>>>1+mult_res_4[46:24]>>>1;
				//REG[16][23:0]<=mult_res_5[46:24]>>>1+mult_res_6[46:24]>>>1+mult_res_9[46:24]>>>1+mult_res_10[46:24]>>>1;
				//REG[16][47:24]<=mult_res_7[46:24]>>>1+mult_res_8[46:24]>>>1+mult_res_11[46:24]>>>1+mult_res_12[46:24]>>>1;
			end
			//7'd42:begin
			//	REG[16][23:0]<=mult_res_1[46:24]>>>1+mult_res_2[46:24]>>>1+mult_res_5[46:24]>>>1+mult_res_6[46:24]>>>1;
		//		REG[16][47:24]<=mult_res_3[46:24]>>>1+mult_res_4[46:24]>>>1+mult_res_7[46:24]>>>1+mult_res_8[46:24]>>>1;
		//	end
		//	7'd43:begin
		//		output_w[1][23:0]<=output_w[1][23:0]+mult_res_1[46:24]>>>1+mult_res_2[46:24]>>>1;
		//		output_w[1][47:24]<=output_w[1][47:24]+mult_res_3[46:24]>>>1+mult_res_4[46:24]>>>1;
		//	end
			8'd44:begin
				//$display("r23:%b",REG[11][23:0]);
				//$display("r23:%b",tmp_r12[23:0]);
				//$display("r23_ans:%b",20'h01087);

				//REG[11][23:0]<=REG[11][22:3]+REG[11][2];
				//REG[11][47:24]<=REG[11][46:27]+REG[11][26];
				//REG[16][23:0]<=REG[16][22:3]+REG[16][2];
				//REG[16][47:24]<=REG[16][46:27]+REG[16][26];
				
				//$display("REG[11]:%h",REG[11][23:0]);
				//$display("ans:%h",20'h01087);
				//$display("REG[11]:%b",REG[11][23:0]);
				//$display("ans:%b",20'h01087);
				//REG[2][23:0]<=REG[2][23:0]-mult_res_1[46:24]>>>1-mult_res_2[46:24]>>>1;
				//REG[2][47:24]<=REG[2][47:24]-mult_res_3[46:24]>>>1-mult_res_4[46:24]>>>1;
				//REG[7][23:0]<=REG[7][23:0]-mult_res_5[46:24]>>>1-mult_res_6[46:24]>>>1;
				//REG[7][47:24]<=REG[7][47:24]-mult_res_7[46:24]>>>1-mult_res_8[46:24]>>>1;
				//REG[12][23:0]<=REG[12][23:0]-mult_res_9[46:24]>>>1-mult_res_10[46:24]>>>1;
				//REG[12][47:24]<=REG[12][47:24]-mult_res_11[46:24]>>>1-mult_res_12[46:24]>>>1;
				//$display("in1_1:%h",mult_in_a_1);
				//$display("in1_2:%h",mult_in_b_1);
				//$display("in2_1:%h",mult_in_a_2);
				//$display("in2_2:%h",mult_in_b_2);
				//$display("q:%b",20'h05ea6);
				//$display("r14:%b",20'h09330);
				//$display("q_i:%b",20'h009f9);
				//$display("r14_i:%b",20'h0addd);
			end
			8'd45:begin
				//{REG[2][23:0],bit1}<=($signed({REG[2][23:0],{16'd0}})-$signed(mult_res_1-mult_res_2[39:0]))>>15;//2要改成下一個clock的a
				//{REG[7][23:0],bit2}<=($signed({REG[7][23:0],{16'd0}})-$signed(mult_res_3-mult_res_4[39:0]))>>15;//
				//{REG[12][23:0],bit3}<=($signed({REG[12][23:0],{16'd0}})-$signed(mult_res_5-mult_res_6[39:0]))>>15;//
				//{REG[17][23:0],bit4}<=($signed({REG[17][23:0],{16'd0}})-$signed(mult_res_7-mult_res_8[39:0]))>>15;//
				//{REG[3][23:0],bit5}<=($signed({REG[3][23:0],{16'd0}})-$signed(mult_res_9-mult_res_10[39:0]))>>15;//
				//{REG[8][23:0],bit6}<=($signed({REG[8][23:0],{16'd0}})-$signed(mult_res_11-mult_res_12[39:0]))>>15;//
				//tmp_r12<=$signed({REG[2][23:0],{16'd0}})-$signed(mult_res_1-mult_res_2[39:0]);
				//REG[17][23:0]<=REG[17][23:0]-mult_res_1[46:24]>>>1-mult_res_2[46:24]>>>1;
				//REG[17][47:24]<=REG[17][47:24]-mult_res_3[46:24]>>>1-mult_res_4[46:24]>>>1;
				//REG[3][23:0]<=REG[3][23:0]-mult_res_5[46:24]>>>1-mult_res_6[46:24]>>>1;
				//REG[3][47:24]<=REG[3][47:24]-mult_res_7[46:24]>>>1-mult_res_8[46:24]>>>1;
				//REG[8][23:0]<=REG[8][23:0]-mult_res_9[46:24]>>>1-mult_res_10[46:24]>>>1;
				//REG[8][47:24]<=REG[8][47:24]-mult_res_11[46:24]>>>1-mult_res_12[46:24]>>>1;
				//$display("mult1:%b",mult_res_9);
				//$display("mult32_ans:%b",40'h00366b1120);
				//$display("mult2:%b",mult_res_10[39:0]);
				//$display("mult33_ans:%b",40'h0006c5e0f5);
			end
			8'd46:begin
				//{REG[13][23:0],bit1}<=($signed({REG[13][23:0],{16'd0}})-$signed(mult_res_1-mult_res_2[39:0]))>>15;//2要改成下一個clock的a
				//{REG[18][23:0],bit2}<=($signed({REG[18][23:0],{16'd0}})-$signed(mult_res_3-mult_res_4[39:0]))>>15;//

				//{REG[2][47:24],bit3}<=($signed({REG[2][47:24],{16'd0}})-$signed(mult_res_5+mult_res_6[39:0]))>>15;//
				//{REG[7][47:24],bit4}<=($signed({REG[7][47:24],{16'd0}})-$signed(mult_res_7+mult_res_8[39:0]))>>15;//
				//{REG[12][47:24],bit5}<=($signed({REG[12][47:24],{16'd0}})-$signed(mult_res_9+mult_res_10[39:0]))>>15;//
				//{REG[17][47:24],bit6}<=($signed({REG[17][47:24],{16'd0}})-$signed(mult_res_11+mult_res_12[39:0]))>>15;//
				//REG[2][23:0]<=REG[2][23:0]+bit1;
				//REG[7][23:0]<=REG[7][23:0]+bit2;
				//REG[12][23:0]<=REG[12][23:0]+bit3;
				//REG[17][23:0]<=REG[17][23:0]+bit4;
				//REG[3][23:0]<=REG[3][23:0]+bit5;
				//REG[8][23:0]<=REG[8][23:0]+bit6;

				
				//$display("tmp_h4_0_ans:%b",24'h0132aa);
				//REG[13][23:0]<=REG[13][23:0]-mult_res_1[46:24]>>>1-mult_res_2[46:24]>>>1;
				//REG[13][47:24]<=REG[13][47:24]-mult_res_3[46:24]>>>1-mult_res_4[46:24]>>>1;
				//REG[18][23:0]<=REG[18][23:0]-mult_res_5[46:24]>>>1-mult_res_6[46:24]>>>1;
				//REG[18][47:24]<=REG[18][47:24]-mult_res_7[46:24]>>>1-mult_res_8[46:24]>>>1;
			end
			8'd47:begin
				//output_w[1][19:0]<=y_ans[41:22];
				//{REG[3][47:24],bit1}<=($signed({REG[3][47:24],{16'd0}})-$signed(mult_res_9+mult_res_10[39:0]))>>15;//
				//{REG[8][47:24],bit2}<=($signed({REG[8][47:24],{16'd0}})-$signed(mult_res_11+mult_res_12[39:0]))>>15;//
				//REG[13][23:0]<=REG[13][23:0]+bit1;
				//REG[18][23:0]<=REG[18][23:0]+bit2;
				//REG[2][47:24]<=REG[2][47:24]+bit3;
				//REG[7][47:24]<=REG[7][47:24]+bit4;
				//REG[12][47:24]<=REG[12][47:24]+bit5;
				//REG[17][47:24]<=REG[17][47:24]+bit6;
				//$display("in1_1:%h",mult_in_a_11);
				//$display("in1_2:%h",mult_in_b_11);
				//$display("in2_1:%h",mult_in_a_12);
				//$display("in2_2:%h",mult_in_b_12);
				

			end
			8'd48:begin
				//output_w[1][39:20]<=y_ans_i[41:22];
				//{REG[13][47:24],bit1}<=($signed({REG[13][47:24],{16'd0}})-$signed(mult_res_9+mult_res_10[39:0]))>>15;//
				//{REG[18][47:24],bit2}<=($signed({REG[18][47:24],{16'd0}})-$signed(mult_res_11+mult_res_12[39:0]))>>15;//
				//$display("3:%h",REG[2]);
				//$display("3:%h",REG[7]);
				//$display("3:%h",REG[12]);
				//$display("3:%h",REG[17]);


				//REG[3][47:24]<=REG[3][47:24]+bit1;
				//REG[8][47:24]<=REG[8][47:24]+bit2;
			end
			8'd49:begin
				//REG[13][47:24]<=REG[13][47:24]+bit1;
				//REG[18][47:24]<=REG[18][47:24]+bit2;
			end
			8'd50:begin//ite
				//$display("3:%h",REG[2][23:0]);
				//$display("3:%h",REG[7]);
				//$display("3:%h",REG[12]);
				//$display("3:%h",REG[17]);
				//$display("4:%h",REG[3]);
				//$display("4:%h",REG[8]);
				//$display("4:%h",REG[13]);
				//$display("4:%h",REG[18]);
			end
			8'd54:begin
				//REG[2]<=root;
				//div_root<=root;
			end
			8'd62:begin
				e1[0][23:0]<=div_res_1;
				e1[0][47:24]<=div_res_2;
				e1[1][23:0]<=div_res_3;
				e1[1][47:24]<=div_res_4;
				e1[2][23:0]<=div_res_5;
				e1[2][47:24]<=div_res_6;
				e1[3][23:0]<=div_res_7;
				e1[3][47:24]<=div_res_8;
				REG[1]<=root;
				//$display("div_res_1:%b",div_res_1);
				//$display("e[0][23:0]:%b",24'h003ac1);
			end
			8'd63:begin
				
			end
			8'd64:begin
				output_w[1][19:0]<=y_ans[41:22];
				//REG[12]<=root;
				//e1[0][47:24]<=div_res;
				
			
			end
			8'd65:begin
				output_w[1][39:20]<=y_ans_i[41:22];
				//e1[1][23:0]<=div_res;
				
			end
			8'd66:begin
				REG[11][23:0]<=((mult_res_1[36:13])+(mult_res_2[36:13])); //沒sign可能有問題
				REG[11][47:24]<=((mult_res_3[36:13])-(mult_res_4[36:13])); 
				REG[16][23:0]<=((mult_res_5[36:13])+(mult_res_6[36:13]));
				REG[16][47:24]<=((mult_res_7[36:13])-(mult_res_8[36:13]));
				//e1[1][47:24]<=div_res;

				
			end
			8'd67:begin
				REG[11][23:0]<=REG[11][23:0]+((mult_res_1[36:13])+(mult_res_2[36:13]));
				REG[11][47:24]<=REG[11][47:24]+((mult_res_3[36:13])-(mult_res_4[36:13])); 
				REG[16][23:0]<=REG[16][23:0]+((mult_res_5[36:13])+(mult_res_6[36:13]));
				REG[16][47:24]<=REG[16][47:24]+((mult_res_7[36:13])-(mult_res_8[36:13]));
			
			
			end
			8'd68:begin
				REG[11][23:0]<=REG[11][23:0]+((mult_res_1[36:13])+(mult_res_2[36:13]));
				REG[11][47:24]<=REG[11][47:24]+((mult_res_3[36:13])-(mult_res_4[36:13])); 
				REG[16][23:0]<=REG[16][23:0]+((mult_res_5[36:13])+(mult_res_6[36:13]));
				REG[16][47:24]<=REG[16][47:24]+((mult_res_7[36:13])-(mult_res_8[36:13]));
				
				
			end
			8'd69:begin
				REG[11][23:0]<=REG[11][23:0]+((mult_res_1[36:13])+(mult_res_2[36:13]));
				REG[11][47:24]<=REG[11][47:24]+((mult_res_3[36:13])-(mult_res_4[36:13])); 
				REG[16][23:0]<=REG[16][23:0]+((mult_res_5[36:13])+(mult_res_6[36:13]));
				REG[16][47:24]<=REG[16][47:24]+((mult_res_7[36:13])-(mult_res_8[36:13]));
				
				
			end
			8'd70:begin
				REG[11][23:0]<=REG[11][22:3]+REG[11][2];
				REG[11][47:24]<=REG[11][46:27]+REG[11][26];
				REG[16][23:0]<=REG[16][22:3]+REG[16][2];
				REG[16][47:24]<=REG[16][46:27]+REG[16][26];
			
			
			end
			8'd71:begin
				{REG[2][23:0],bit1}<=($signed({REG[2][23:0],{16'd0}})-$signed(mult_res_1-mult_res_2[39:0]))>>15;//2要改成下一個clock的a
				{REG[7][23:0],bit2}<=($signed({REG[7][23:0],{16'd0}})-$signed(mult_res_3-mult_res_4[39:0]))>>15;//
				{REG[12][23:0],bit3}<=($signed({REG[12][23:0],{16'd0}})-$signed(mult_res_5-mult_res_6[39:0]))>>15;//
				{REG[17][23:0],bit4}<=($signed({REG[17][23:0],{16'd0}})-$signed(mult_res_7-mult_res_8[39:0]))>>15;//
				{REG[3][23:0],bit5}<=($signed({REG[3][23:0],{16'd0}})-$signed(mult_res_9-mult_res_10[39:0]))>>15;//
				{REG[8][23:0],bit6}<=($signed({REG[8][23:0],{16'd0}})-$signed(mult_res_11-mult_res_12[39:0]))>>15;//
			end
			8'd72:begin
				{REG[13][23:0],bit1}<=($signed({REG[13][23:0],{16'd0}})-$signed(mult_res_1-mult_res_2[39:0]))>>15;//2要改成下一個clock的a
				{REG[18][23:0],bit2}<=($signed({REG[18][23:0],{16'd0}})-$signed(mult_res_3-mult_res_4[39:0]))>>15;//
				{REG[2][47:24],bit3}<=($signed({REG[2][47:24],{16'd0}})-$signed(mult_res_5+mult_res_6[39:0]))>>15;//
				{REG[7][47:24],bit4}<=($signed({REG[7][47:24],{16'd0}})-$signed(mult_res_7+mult_res_8[39:0]))>>15;//
				{REG[12][47:24],bit5}<=($signed({REG[12][47:24],{16'd0}})-$signed(mult_res_9+mult_res_10[39:0]))>>15;//
				{REG[17][47:24],bit6}<=($signed({REG[17][47:24],{16'd0}})-$signed(mult_res_11+mult_res_12[39:0]))>>15;//
				REG[2][23:0]<=REG[2][23:0]+bit1;
				REG[7][23:0]<=REG[7][23:0]+bit2;
				REG[12][23:0]<=REG[12][23:0]+bit3;
				REG[17][23:0]<=REG[17][23:0]+bit4;
				REG[3][23:0]<=REG[3][23:0]+bit5;
				REG[8][23:0]<=REG[8][23:0]+bit6;
				
			end
			8'd73:begin
				{REG[3][47:24],bit1}<=($signed({REG[3][47:24],{16'd0}})-$signed(mult_res_1+mult_res_2[39:0]))>>15;//
				{REG[8][47:24],bit2}<=($signed({REG[8][47:24],{16'd0}})-$signed(mult_res_3+mult_res_4[39:0]))>>15;//
				{REG[13][47:24],bit3}<=($signed({REG[13][47:24],{16'd0}})-$signed(mult_res_5+mult_res_6[39:0]))>>15;//
				{REG[18][47:24],bit4}<=($signed({REG[18][47:24],{16'd0}})-$signed(mult_res_7+mult_res_8[39:0]))>>15;//
				REG[13][23:0]<=REG[13][23:0]+bit1;
				REG[18][23:0]<=REG[18][23:0]+bit2;
				REG[2][47:24]<=REG[2][47:24]+bit3;
				REG[7][47:24]<=REG[7][47:24]+bit4;
				REG[12][47:24]<=REG[12][47:24]+bit5;
				REG[17][47:24]<=REG[17][47:24]+bit6;

			end
			8'd74:begin
				REG[3][47:24]<=REG[3][47:24]+bit1;
				REG[8][47:24]<=REG[8][47:24]+bit2;
				REG[13][47:24]<=REG[13][47:24]+bit3;
				REG[18][47:24]<=REG[18][47:24]+bit4;
				//{REG[3][23:0],bit1}<=($signed({REG[3][23:0],{16'd0}})-$signed(mult_res_1-mult_res_2[39:0]))>>15;//2要改成下一個clock的a
				//{REG[8][23:0],bit2}<=($signed({REG[8][23:0],{16'd0}})-$signed(mult_res_3-mult_res_4[39:0]))>>15;//
				//{REG[13][23:0],bit3}<=($signed({REG[13][23:0],{16'd0}})-$signed(mult_res_5-mult_res_6[39:0]))>>15;//
				//{REG[18][23:0],bit4}<=($signed({REG[18][23:0],{16'd0}})-$signed(mult_res_7-mult_res_8[39:0]))>>15;//

				
				
			end
			8'd75:begin
				//{REG[3][47:24],bit1}<=($signed({REG[3][47:24],{16'd0}})-$signed(mult_res_1+mult_res_2[39:0]))>>15;//
				//{REG[8][47:24],bit2}<=($signed({REG[8][47:24],{16'd0}})-$signed(mult_res_3+mult_res_4[39:0]))>>15;//
				//{REG[13][47:24],bit3}<=($signed({REG[13][47:24],{16'd0}})-$signed(mult_res_5+mult_res_6[39:0]))>>15;//
				//{REG[18][47:24],bit4}<=($signed({REG[18][47:24],{16'd0}})-$signed(mult_res_7+mult_res_8[39:0]))>>15;//

				
				//REG[3][23:0]<=REG[3][23:0]+bit1;
				//REG[8][23:0]<=REG[8][23:0]+bit2;
				//REG[13][23:0]<=REG[13][23:0]+bit3;
				//REG[18][23:0]<=REG[18][23:0]+bit4;
			end
			//7'd70:begin
				//REG[3][47:24]<=REG[3][47:24]+bit1;
				//REG[8][47:24]<=REG[8][47:24]+bit2;
				//REG[13][47:24]<=REG[13][47:24]+bit3;
				//REG[18][47:24]<=REG[18][47:24]+bit4;

				//$display("h4[0]:%h",REG[3]);
				//$display("h4[1]:%h",REG[8]);
				//$display("h4[2]:%h",REG[13]);
				//$display("h4[3]:%h",REG[18]);
			//end
			//7'd72:begin
			//	$display("res1:%h",sq_h);	
			//end
			//7'd73:begin
			//	$display("res1:%h",sq_h);
			//end
			8'd76:begin
				//REG[7]<=root;
			end
			
			//7'd78:
			//7'd79:
			8'd80:begin
				
			end
			8'd81:begin
				
			end
			8'd82:begin
				
				//$display("div_in:%h",REG[18][23:0]);
				//$display("div_in_root:%h",root);
			end
			8'd83:begin
				
				//$display("div_in:%h",REG[18][47:24]);
				//$display("div_in_root:%h",root);
			end
			8'd84:begin
				
			end
			//7'd85:
			8'd85:begin
				
			end
			8'd86:begin
				
			end
			8'd87:begin
				
			end
			8'd89:begin
				//$display("e1:%h",e1[0]);
				//$display("e2:%h",e1[1]);
				//$display("e3:%h",e1[2]);
				//$display("e4:%h",e1[3]);
			end
			8'd99:begin
				e1[0][23:0]<=div_res_1;
				e1[0][47:24]<=div_res_2;
				e1[1][23:0]<=div_res_3;
				e1[1][47:24]<=div_res_4;
				e1[2][23:0]<=div_res_5;
				e1[2][47:24]<=div_res_6;
				e1[3][23:0]<=div_res_7;
				e1[3][47:24]<=div_res_8;
				REG[2]<=root;
			end
			8'd100:begin
				
			end
			8'd101:begin
				output_w[2][19:0]<=y_ans[41:22];
				
				REG[17][23:0]<=((mult_res_9[35:12])+(mult_res_10[35:12])); //沒sign可能有問題
				REG[17][47:24]<=((mult_res_11[35:12])-(mult_res_12[35:12])); 
				
			end
			8'd102:begin
				output_w[2][39:20]<=y_ans_i[41:22];
				REG[17][23:0]<=REG[17][23:0]+((mult_res_9[35:12])+(mult_res_10[35:12])); //沒sign可能有問題
				REG[17][47:24]<=REG[17][47:24]+((mult_res_11[35:12])-(mult_res_12[35:12])); 
				
			end
			8'd103:begin
				REG[17][23:0]<=REG[17][23:0]+((mult_res_1[35:12])+(mult_res_2[35:12])+(mult_res_3[35:12])+(mult_res_4[35:12])); //沒sign可能有問題
				REG[17][47:24]<=REG[17][47:24]+((mult_res_5[35:12])-(mult_res_6[35:12])+(mult_res_7[35:12])-(mult_res_8[35:12])); 
				
			end
			8'd104:begin
				REG[17][23:0]<=$signed(REG[17][23:4])+$signed(REG[17][3]);
				REG[17][47:24]<=$signed(REG[17][47:28])+$signed(REG[17][27]);
				
			end
			8'd105:begin
				{REG[3][23:0],bit1}<=($signed({REG[3][23:0],{16'd0}})-$signed(mult_res_1-mult_res_2[39:0]))>>15;//2要改成下一個clock的a
				{REG[8][23:0],bit2}<=($signed({REG[8][23:0],{16'd0}})-$signed(mult_res_3-mult_res_4[39:0]))>>15;//
				{REG[13][23:0],bit3}<=($signed({REG[13][23:0],{16'd0}})-$signed(mult_res_5-mult_res_6[39:0]))>>15;//
				{REG[18][23:0],bit4}<=($signed({REG[18][23:0],{16'd0}})-$signed(mult_res_7-mult_res_8[39:0]))>>15;//

			end
			8'd106:begin
				{REG[3][47:24],bit1}<=($signed({REG[3][47:24],{16'd0}})-$signed(mult_res_1+mult_res_2[39:0]))>>15;//
				{REG[8][47:24],bit2}<=($signed({REG[8][47:24],{16'd0}})-$signed(mult_res_3+mult_res_4[39:0]))>>15;//
				{REG[13][47:24],bit3}<=($signed({REG[13][47:24],{16'd0}})-$signed(mult_res_5+mult_res_6[39:0]))>>15;//
				{REG[18][47:24],bit4}<=($signed({REG[18][47:24],{16'd0}})-$signed(mult_res_7+mult_res_8[39:0]))>>15;//
				REG[3][23:0]<=REG[3][23:0]+bit1;
				REG[8][23:0]<=REG[8][23:0]+bit2;
				REG[13][23:0]<=REG[13][23:0]+bit3;
				REG[18][23:0]<=REG[18][23:0]+bit4;
			end
			8'd107:begin
				REG[3][47:24]<=REG[3][47:24]+bit1;
				REG[8][47:24]<=REG[8][47:24]+bit2;
				REG[13][47:24]<=REG[13][47:24]+bit3;
				REG[18][47:24]<=REG[18][47:24]+bit4;
			end
			8'd108:begin
				//$display("h4:%h",REG[3]);
				//$display("h4:%h",REG[8]);
				//$display("h4:%h",REG[13]);
				//$display("h4:%h",REG[18]);
			end
			8'd133:begin
				e1[0][23:0]<=div_res_1;
				e1[0][47:24]<=div_res_2;
				e1[1][23:0]<=div_res_3;
				e1[1][47:24]<=div_res_4;
				e1[2][23:0]<=div_res_5;
				e1[2][47:24]<=div_res_6;
				e1[3][23:0]<=div_res_7;
				e1[3][47:24]<=div_res_8;
				REG[7]<=root;
			end
			8'd135:begin
				output_w[3][19:0]<=y_ans[41:22];
			end
			8'd136:begin
				output_w[3][39:20]<=y_ans_i[41:22];
			end
			8'd137:begin
				o_y_hat<={output_w[3],output_w[2],output_w[1],output_w[0]};
				o_r<={REG[7][19:0],{REG[17][43:24],REG[17][19:0]},{REG[16][43:24],REG[16][19:0]},{REG[15][43:24],REG[15][19:0]},REG[2][19:0],{REG[11][43:24],REG[11][19:0]},{REG[10][43:24],REG[10][19:0]},REG[1][19:0],{REG[5][43:24],REG[5][19:0]},REG[0][19:0]};

			end
			8'd138:begin
				calculate_finish<=0;
				ind<=0;
			end
			default:begin
			end
		endcase
	end
	else if(read_enable)begin
		Addr_Load<=Addr_Load+1;
		ind<=ind+1;
		REG[(ind)-1]<={o_sram_5,o_sram_4,o_sram_3,o_sram_2,o_sram_1,o_sram_0};
		calculate_finish<=1;
		
		cal_ind<=0;
	end
	else begin
		Addr_Load<=Addr_Load;
	end
end
sram_256x8 sram_0 (//一個sram 4個chanel 8x8
	.Q(o_sram_0),
	.CLK(i_clk),
	.CEN(CE),
	.WEN(WE),
	.A(Addr_Load),//address
	.D(i_data[7:0])
);
sram_256x8 sram_1 (//一個sram 4個chanel 8x8
	.Q(o_sram_1),
	.CLK(i_clk),
	.CEN(CE),
	.WEN(WE),
	.A(Addr_Load),//address
	.D(i_data[15:8])
);
sram_256x8 sram_2 (//一個sram 4個chanel 8x8
	.Q(o_sram_2),
	.CLK(i_clk),
	.CEN(CE),
	.WEN(WE),
	.A(Addr_Load),//address
	.D(i_data[23:16])
);
sram_256x8 sram_3 (//一個sram 4個chanel 8x8
	.Q(o_sram_3),
	.CLK(i_clk),
	.CEN(CE),
	.WEN(WE),
	.A(Addr_Load),//address
	.D(i_data[31:24])
);
sram_256x8 sram_4 (//一個sram 4個chanel 8x8
	.Q(o_sram_4),
	.CLK(i_clk),
	.CEN(CE),
	.WEN(WE),
	.A(Addr_Load),//address
	.D(i_data[39:32])
);
sram_256x8 sram_5 (//一個sram 4個chanel 8x8
	.Q(o_sram_5),
	.CLK(i_clk),
	.CEN(CE),
	.WEN(WE),
	.A(Addr_Load),//address
	.D(i_data[47:40])
);
DW_sqrt_pipe#(
    .width(30),
    .tc_mode(1),
    .num_stages(8),
    .stall_mode(0),
    .rst_mode(1),
    .op_iso_mode(0)
   ) 
    sqrt_pipelined
    (
    .clk(i_clk),
    .rst_n(~i_rst),
    .en(enable),
    .a(sq_h[47:18]),
    .root(root_out)
);
//DW_div_pipe #(
  //  .a_width(40),   //24+14//+root bits
 //   .b_width(26),   
//    .num_stages(5),
//	.stall_mode(0),
//    .tc_mode(1)
//    ) 
//    U1 (
//    .clk(i_clk),   
//    .rst_n(~i_rst),   
//    .en(enable),
//    .a({div_in,16'd0}),   
//    .b(div_in_root),   
//    .quotient(div_res),  
//    .divide_by_0()
//);
DW02_mult_2_stage #(
    .A_width(24),   
    .B_width(24)
    ) 
    MULT1 (
    .CLK(i_clk),   
    .A(mult_in_a_1),   
    .B(mult_in_b_1),
    .TC(1'b1),   
    .PRODUCT(mult_res_1)
);
DW02_mult_2_stage #(
    .A_width(24),   
    .B_width(24)
    ) 
    MULT2 (
    .CLK(i_clk),   
    .A(mult_in_a_2),   
    .B(mult_in_b_2),
    .TC(1'b1),   
    .PRODUCT(mult_res_2)
);
DW02_mult_2_stage #(
    .A_width(24),   
    .B_width(24)
    ) 
    MULT3 (
    .CLK(i_clk),   
    .A(mult_in_a_3),   
    .B(mult_in_b_3),
    .TC(1'b1),   
    .PRODUCT(mult_res_3)
);
DW02_mult_2_stage #(
    .A_width(24),   
    .B_width(24)
    ) 
    MULT4 (
    .CLK(i_clk),   
    .A(mult_in_a_4),   
    .B(mult_in_b_4),
    .TC(1'b1),   
    .PRODUCT(mult_res_4)
);
DW02_mult_2_stage #(
    .A_width(24),   
    .B_width(24)
    ) 
    MULT5 (
    .CLK(i_clk),   
    .A(mult_in_a_5),   
    .B(mult_in_b_5),
    .TC(1'b1),   
    .PRODUCT(mult_res_5)
);
DW02_mult_2_stage #(
    .A_width(24),   
    .B_width(24)
    ) 
    MULT6 (
    .CLK(i_clk),   
    .A(mult_in_a_6),   
    .B(mult_in_b_6),
    .TC(1'b1),   
    .PRODUCT(mult_res_6)
);
DW02_mult_2_stage #(
    .A_width(24),   
    .B_width(24)
    ) 
    MULT7 (
    .CLK(i_clk),   
    .A(mult_in_a_7),   
    .B(mult_in_b_7),
    .TC(1'b1),   
    .PRODUCT(mult_res_7)
);
DW02_mult_2_stage #(
    .A_width(24),   
    .B_width(24)
    ) 
    MULT8 (
    .CLK(i_clk),   
    .A(mult_in_a_8),   
    .B(mult_in_b_8),
    .TC(1'b1),   
    .PRODUCT(mult_res_8)
);
DW02_mult_2_stage #(
    .A_width(24),   
    .B_width(24)
    ) 
    MULT9 (
    .CLK(i_clk),   
    .A(mult_in_a_9),   
    .B(mult_in_b_9),
    .TC(1'b1),   
    .PRODUCT(mult_res_9)
);
DW02_mult_2_stage #(
    .A_width(24),   
    .B_width(24)
    ) 
    MULT10 (
    .CLK(i_clk),   
    .A(mult_in_a_10),   
    .B(mult_in_b_10),
    .TC(1'b1),   
    .PRODUCT(mult_res_10)
);
DW02_mult_2_stage #(
    .A_width(24),   
    .B_width(24)
    ) 
    MULT11 (
    .CLK(i_clk),   
    .A(mult_in_a_11),   
    .B(mult_in_b_11),
    .TC(1'b1),   
    .PRODUCT(mult_res_11)
);
DW02_mult_2_stage #(
    .A_width(24),   
    .B_width(24)
    ) 
    MULT12 (
    .CLK(i_clk),   
    .A(mult_in_a_12),   
    .B(mult_in_b_12),
    .TC(1'b1),   
    .PRODUCT(mult_res_12)
);

CORDIC_Div cordic_div_1(
  .y_in(div_in_1), 
  .x_in(divisor), 
  .clk(i_clk),
  .z_out(div_res_1)
);
CORDIC_Div cordic_div_2(
  .y_in(div_in_2), 
  .x_in(divisor), 
  .clk(i_clk),
  .z_out(div_res_2)
);
CORDIC_Div cordic_div_3(
  .y_in(div_in_3), 
  .x_in(divisor), 
  .clk(i_clk),
  .z_out(div_res_3)
);
CORDIC_Div cordic_div_4(
  .y_in(div_in_4), 
  .x_in(divisor), 
  .clk(i_clk),
  .z_out(div_res_4)
);
CORDIC_Div cordic_div_5(
  .y_in(div_in_5), 
  .x_in(divisor), 
  .clk(i_clk),
  .z_out(div_res_5)
);
CORDIC_Div cordic_div_6(
  .y_in(div_in_6), 
  .x_in(divisor), 
  .clk(i_clk),
  .z_out(div_res_6)
);
CORDIC_Div cordic_div_7(
  .y_in(div_in_7), 
  .x_in(divisor), 
  .clk(i_clk),
  .z_out(div_res_7)
);
CORDIC_Div cordic_div_8(
  .y_in(div_in_8), 
  .x_in(divisor), 
  .clk(i_clk),
  .z_out(div_res_8)
);

endmodule

//vcs -full64 -f rtl.f +v2k -R
