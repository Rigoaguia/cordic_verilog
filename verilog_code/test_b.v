module test_b;
  reg clk,reset;
  wire signed [16:0] cos;
  wire signed [16:0] sin;
  wire  [31:0]z0;
  
 
  cordic_test  cordic2 (.cos(cos),.sin(sin),.clk(clk),.reset(reset),.z(z0));
  
  initial begin
    
   // $dumpfile("dump.vcd");
   // $dumpvars(1,test);
    
    clk = 1'b0;
    reset = 1'b1;
    #10 reset = 1'b0;
    #800
	$finish;
  end
 
  always@(cos)begin
    $display($time, ,  "cos:",cos, ,"sen:",sin,,"z:",z0);
  end
  
  always #5 clk = ~clk;
  
  
endmodule
