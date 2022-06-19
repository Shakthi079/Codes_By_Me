module top_module (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

genvar i;
generate
for(i = 0;i<8;i=i+1) begin : genv
    edd edd_inst(.clk(clk),.in(in[i]),.out(pedge[i]));
end
endgenerate
        
endmodule

module edd(
input clk,
input in,
output  out    
);
reg [1:0]s = 0;    
localparam idle = 0,zero_det = 1,one_det = 2;   

always @(posedge clk) begin
    case(s)
        idle: s = (in == 0) ? ('d1):('d0);
        zero_det: s = (in == 0) ? ('d1):('d2);
        one_det : s = (in == 1) ? ('d0):('d1);
    endcase
end
    

assign out = (s==one_det )? (1):(0);
    
endmodule
