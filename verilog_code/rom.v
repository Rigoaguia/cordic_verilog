// ROM(0 a 360 angulo input - ang_input0a360.list).

module rom (
   address , // Address
   data    , // Data 
   read_en , // Read 
   ce        // Enable
);
  input [9:0] address;
  output [31:0] data; 
  input read_en; 
  input ce; 
             
  reg [31:0] mem [0:360] ;  
        
  assign data = (ce && read_en) ? mem[address] : 32'b0;
  
  initial begin
    $readmemb("ang_input0a360.list", mem); 
  end
  
endmodule
