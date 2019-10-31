/* 
Ricardo Aguiar, 17/04/2019
Cordic
input ang(z0) 0 a 360; z0 = (ang/360)*2^32;
output: sin_z0/32000; cos_z0/32000
*/

`define theta_0 32'b00100000000000000000000000000000
`define theta_1 32'b00010010111001000000010100011101
`define theta_2 32'b00001001111110110011100001011011 
`define theta_3 32'b00000101000100010001000111010100
`define theta_4 32'b00000010100010110000110101000011
`define theta_5 32'b00000001010001011101011111100001
`define theta_6 32'b00000000101000101111011000011110
`define theta_7 32'b00000000010100010111110001010101
`define theta_8 32'b00000000001010001011111001010011
`define theta_9 32'b00000000000101000101111100101110
`define theta_10 32'b00000000000010100010111110011000
`define theta_11 32'b00000000000001010001011111001100
`define theta_12 32'b00000000000000101000101111100110
`define theta_13 32'b00000000000000010100010111110011
`define theta_14 32'b00000000000000001010001011111001
`define theta_15 32'b00000000000000000101000101111101
`define theta_16 32'b00000000000000000010100010111110
`define theta_17 32'b00000000000000000001010001011111
`define theta_18 32'b00000000000000000000101000101111
`define theta_19 32'b00000000000000000000010100011000
`define theta_20 32'b00000000000000000000001010001100
`define theta_21 32'b00000000000000000000000101000110
`define theta_22 32'b00000000000000000000000010100011
`define theta_23 32'b00000000000000000000000001010001
`define theta_24 32'b00000000000000000000000000101000
`define theta_25 32'b00000000000000000000000000010100
`define theta_26 32'b00000000000000000000000000001010
`define theta_27 32'b00000000000000000000000000000101
`define theta_28 32'b00000000000000000000000000000010
`define theta_29 32'b00000000000000000000000000000001
`define theta_30 32'b00000000000000000000000000000000

module cordic (cos_z0,sin_z0,done,z0,start,clock,reset);
  
  parameter width = 16;
  // input 
  input signed [31:0] z0;
  input start;
  input clock;
  input reset;
  //output 
  output signed [width:0] cos_z0;
  output signed [width:0] sin_z0;
  output done;
  
  reg signed [width:0] sin_z0;
  reg signed [width:0] cos_z0;
  reg done;
 
  reg [5:0] i; // contador
  reg  state;
  reg signed [31:0] dz;
  reg signed [width-1:0] dx;
  reg signed [width-1:0] dy;
  reg signed [width-1:0] y;
  reg signed [width-1:0] x;
  reg signed [31:0] z;
  
  wire signed [31:0] atan_table [0:30];

  assign atan_table[00] = `theta_0; 
  assign atan_table[01] = `theta_1;
  assign atan_table[02] = `theta_2;
  assign atan_table[03] = `theta_3;
  assign atan_table[04] = `theta_4;
  assign atan_table[05] = `theta_5;
  assign atan_table[06] = `theta_6;
  assign atan_table[07] = `theta_7;
  assign atan_table[08] = `theta_8;
  assign atan_table[09] = `theta_9;
  assign atan_table[10] = `theta_10;
  assign atan_table[11] = `theta_11;
  assign atan_table[12] = `theta_12;
  assign atan_table[13] = `theta_13;
  assign atan_table[14] = `theta_14;
  assign atan_table[15] = `theta_15;
  assign atan_table[16] = `theta_16;
  assign atan_table[17] = `theta_17;
  assign atan_table[18] = `theta_18;
  assign atan_table[19] = `theta_19;
  assign atan_table[20] = `theta_20;
  assign atan_table[21] = `theta_21;
  assign atan_table[22] = `theta_22;
  assign atan_table[23] = `theta_23;
  assign atan_table[24] = `theta_24;
  assign atan_table[25] = `theta_25;
  assign atan_table[26] = `theta_26;
  assign atan_table[27] = `theta_27;
  assign atan_table[28] = `theta_28;
  assign atan_table[29] = `theta_29;
  assign atan_table[30] = `theta_30;
  
  
always @(posedge clock or posedge reset) begin
 
    if (reset) begin
        state = 1'b0;
        cos_z0 <= 0;
        sin_z0 <= 0;
        done <= 0;
        x = 0;
        y = 0;
        z = 0;
        i = 0;
    end
    else begin
        case (state)
            1'b0: begin
                if (start) begin
                  if(z0[31:30] == 2'b00 || z0[31:30] == 2'b11)begin // quadrante 0 a 89 e 270 a 360
                  	x = (32000/1.647);
                   	y = 0;
                    z = z0;
                  end else if(z0[31:30] == 2'b01)begin // quadrante 90 a 179
                  	x = -0;
                   	y = (32000/1.647);
                    z = (z0 - 32'b01000000000000000000000000000000); // sub pi/2
                   
                  end else if(z0[31:30] == 2'b10)begin // quadrante 180 a 269
                  	x = 0;
                   	y = (32000/1.647);
                    z = (z0 + 32'b01000000000000000000000000000000); //add pi/2
                   
                  end 
                  i = 0;
                  done <= 0;
                  state = 1'b1;
                end
            end
            1'b1: begin
                dx = (y >>>  i);
                dy = (x >>>  i);
                dz = atan_table[i];
                
                if ((z > 0)) begin
                    x = x - dx;
                    y = y + dy;
                    z = z - dz;
                end
                else begin
                    x = x + dx;
                    y = y - dy;
                    z = z + dz;
                end
                
                if ((i == (width - 2))) begin
                    if(z0[31:30] == 2'b10)begin // quadrante 180 a 269
                	    cos_z0 <= -x;
                        sin_z0 <= -y;                   
                    end else begin
                	    cos_z0 <= x;
                        sin_z0 <= y;
                    end
                    state = 1'b0;
                    done <= 1;
                end else begin
                    i = i + 1;
                end
            end
        endcase
    end
end

endmodule
