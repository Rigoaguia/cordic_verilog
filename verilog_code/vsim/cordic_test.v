/* 
Ricardo Aguiar, 17/04/2019
Cordic Teste - input(Rom - 0 a 360 graus) , saída: sin e cos.
input ang(z0) 0 a 360; z0 = (ang/360)*2^32;
output: sin_z0/32000; cos_z0/32000
*/

module cordic_test(sin,cos,reset,clk,z);
  parameter width = 16;
  output signed [width:0]sin;
  output signed [width:0]cos;
  output signed [31:0]z;
  input reset;
  input clk;
 
  wire done;
  reg signed [31:0]z0;
  reg signed [width:0] sin;
  reg signed [width:0] cos;
  reg signed [31:0]z;
  wire signed [width:0] sin_z0;
  wire signed [width:0] cos_z0;
  reg [9:0] address;
  wire [31:0] data; 
  reg read_en; 
  reg ce; 
  reg start;
  
  // alg. cordic
  cordic sine_cos(.cos_z0(cos_z0),.sin_z0(sin_z0),.done(done),.z0(z0),.start(start),.clock(clk),.reset(reset));
  // Rom contendo os angulos de entrada
  rom romf (.address(address), .data(data), .read_en(read_en), .ce(ce));
  always@(posedge clk or posedge reset) begin
    if(reset)begin 
	  start <= 0;
   	end else begin 
	  read_en <= 1;
      ce <= 1;
      z0 <= data;
      start <= 1;
    end     
  end
  
  always@(cos_z0 or sin_z0)begin
  	if(address < 360)begin
        address <= address +1;
    end else begin
        address <= 0;
    end 
    if(done == 1)begin
      	cos <= cos_z0;
   		sin <= sin_z0;
      	z <= z0;
    end else begin
    	cos <= 0;
   		sin <= 0;
      	z <= 0;
    end
  end
  
endmodule
