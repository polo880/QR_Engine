`timescale 1ns / 1ps

// module CORDIC_Div (y_in, x_in, clk, z_out);
// 	/// parameters
//     parameter word_SZ = 20;   // width of input and output data
// 	parameter frac_SZ = 16;
// 	localparam num_OfStage = word_SZ-3;
// 	/// input declaration
// 	input  signed [word_SZ-1:0] y_in;
// 	input  signed [word_SZ-1:0] x_in;
// 	input clk;

//     // wire [word_SZ-1:0] pos_y = y_in[word_SZ-1] ? ~y_in + 1 : y_in;
//     // wire [word_SZ-1:0] pos_x = x_in[word_SZ-1] ? ~x_in + 1 : x_in;
// 	/// output declaration
// 	output signed [word_SZ-1:0] z_out;
// 	/// generate structure to pipeline the design
// 	wire [word_SZ-1:0] y_stage_Out [num_OfStage-1:0];
// 	wire [word_SZ-1:0] z_stage_Out [num_OfStage-1:0];
// 	wire signed [word_SZ-1:0] z_in;
// 	assign z_in = 0;
// 	// Initializing first stage
// 	CorDIC_Div_SubSection subDiv(x_in,y_in,z_in,clk,z_stage_Out[0],y_stage_Out[0]);
// 	defparam subDiv.word_SZ = word_SZ, subDiv.stage = 0, subDiv.frac_SZ = frac_SZ;
// 	// Pipelining the stages
// 	genvar i;
//    generate
// 		for (i=1; i < (num_OfStage); i=i+1)
// 		begin: XYZ
// 			CorDIC_Div_SubSection subDiv(x_in,y_stage_Out[i-1],z_stage_Out[i-1],clk,z_stage_Out[i],y_stage_Out[i]);
// 			defparam subDiv.word_SZ = word_SZ, subDiv.stage = i, subDiv.frac_SZ = frac_SZ;
// 		end
//    endgenerate
// 	/// Output assign
// 	assign z_out = y_in[word_SZ-1] ^ x_in[word_SZ-1] ? !z_stage_Out[num_OfStage-1]+1 : z_stage_Out[num_OfStage-1];
// endmodule



// module CorDIC_Div_SubSection(x_in,y_in,z_in,clk,z_out,y_out);
// 	/// parameters
//    parameter word_SZ = 20;   // width of input and output data
// 	parameter frac_SZ = 16;
// 	parameter stage = 0;
// 	// Input Output declaration
// 	input signed [word_SZ-1:0] y_in;
// 	input signed [word_SZ-1:0] x_in;
// 	input signed [word_SZ-1:0] z_in;
// 	input clk;
// 	output reg signed [word_SZ-1:0] z_out;
// 	output reg signed [word_SZ-1:0] y_out;
// 	// Sign bit decider
// 	wire y_sign;
// 	assign y_sign = y_in[word_SZ-1];
// 	// shifted x calculation
// 	wire signed [word_SZ-1:0] x_shifted;
// 	assign x_shifted = x_in >>> stage;
// 	// shifted z calculation
// 	localparam firstZero = stage+1;
// 	localparam lastZero = frac_SZ - stage;
// 	wire signed [word_SZ-1:0]z_shifted = {{firstZero{1'b0}},1'b1,{lastZero{1'b0}}};
	
// 	always @(posedge clk)
// 	begin
// 		y_out <= y_sign ? y_in + x_shifted    : y_in - x_shifted;
// 		z_out <= y_sign ? z_in - z_shifted 	  : z_in + z_shifted;
// 	end
		
// endmodule

module CORDIC_Div (y_in, x_in, clk, z_out);
	/// parameters
   parameter word_SZ = 20;   // width of input and output data
	parameter frac_SZ = 16;
	localparam num_OfStage = word_SZ-3;
	/// input declaration
	input signed [word_SZ-1:0] y_in;
	input signed [word_SZ-1:0] x_in;
	input clk;
	/// output declaration
	output signed [word_SZ-1:0] z_out;
	/// generate structure to pipeline the design
	wire [word_SZ-1:0] y_stage_Out [num_OfStage-1:0];
	wire [word_SZ-1:0] z_stage_Out [num_OfStage-1:0];
	wire signed [word_SZ-1:0] z_in;
	assign z_in = 0;
	// Initializing first stage
	CorDIC_Div_SubSection subDiv(x_in,y_in,z_in,clk,z_stage_Out[0],y_stage_Out[0]);
	defparam subDiv.word_SZ = word_SZ, subDiv.stage = 0, subDiv.frac_SZ = frac_SZ;
	// Pipelining the stages
	genvar i;
   generate
		for (i=1; i < (num_OfStage); i=i+1)
		begin: XYZ
			CorDIC_Div_SubSection 
			#(.word_SZ(word_SZ), .stage(i), .frac_SZ(frac_SZ))
			subDiv(x_in,y_stage_Out[i-1],z_stage_Out[i-1],clk,z_stage_Out[i],y_stage_Out[i]);

			// defparam subDiv.word_SZ = word_SZ, subDiv.stage = i, subDiv.frac_SZ = frac_SZ;
		end
   endgenerate
	/// Output assign
	assign z_out = z_stage_Out[num_OfStage-1];
endmodule



module CorDIC_Div_SubSection(x_in,y_in,z_in,clk,z_out,y_out);
	/// parameters
   parameter word_SZ = 20;   // width of input and output data
	parameter frac_SZ = 16;
	parameter stage = 0;
	// Input Output declaration
	input signed [word_SZ-1:0] y_in;
	input signed [word_SZ-1:0] x_in;
	input signed [word_SZ-1:0] z_in;
	input clk;
	output reg signed [word_SZ-1:0] z_out;
	output reg signed [word_SZ-1:0] y_out;
	// Sign bit decider
	wire y_sign;
	assign y_sign = y_in[word_SZ-1];
	// shifted x calculation
	wire signed [word_SZ-1:0] x_shifted;
	assign x_shifted = x_in >>> stage;
	// shifted z calculation
	localparam firstZero = stage+1;
	localparam lastZero = frac_SZ - stage;
	wire signed [word_SZ-1:0]z_shifted = {{firstZero{1'b0}},1'b1,{lastZero{1'b0}}};
	
	always @(posedge clk)
	begin
		y_out <= y_sign ? y_in + x_shifted    : y_in - x_shifted;
		z_out <= y_sign ? z_in - z_shifted 	  : z_in + z_shifted;
	end
		
endmodule