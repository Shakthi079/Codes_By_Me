module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
); 
    reg [511:0]D;
    wire [511:0]comp_out;
    
    always @(posedge clk) begin
        if(load)
          D <=  data;   
        else
         D <=  comp_out;  
    end    
assign q = D;

    LUT LUT_0(.d_i({D[1],D[0],1'b0}),.d_o(comp_out[0]));
    LUT LUT_511(.d_i({1'b0,D[511],D[510]}),.d_o(comp_out[511]));
    
genvar i;

generate 
    for(i = 1;i<511;i = i+1) begin:gen
        LUT LUT_inst(.d_i({D[i+1],D[i],D[i-1]}),.d_o(comp_out[i]));
    end
endgenerate    
    
endmodule


module LUT
    (
        input [2:0]d_i,
        output d_o  
    );
    assign d_o = (d_i[2] & d_i[1] & (~d_i[0]) ) +  (d_i[2] & (~d_i[1]) & d_i[0] ) +  ((~d_i[2]) & d_i[1]) + ((~d_i[2]) & (~d_i[1]) & d_i[0] ) ;          
endmodule    
