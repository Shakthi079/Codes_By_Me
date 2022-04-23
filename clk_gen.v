`timescale 1ns / 1ps

module clk_gen_non_int();
parameter d_width = 16;
parameter cnt_max = 10;
parameter clk1_div = 10;

reg clk_1Ghz;
wire clk_out;

initial begin
clk_1Ghz <= 0;
end

always  #1 clk_1Ghz  <=  !clk_1Ghz;

clk_gen clk_gen_inst_1Ghz_to_80Mhz
(
.clk(clk_1Ghz),
.clk_out(clk_out)
);
endmodule


module clk_gen
#(
parameter d_width = 16,
parameter N_div = 2,
parameter div1 = 25,
parameter div2 = 2
)
(
input clk,
output clk_out
);

reg [(d_width-1):0]cnt = 0;
reg [(d_width-1):0]cnt2  = 0;
reg clk_25 = 0;
reg clk_25_by_2 = 0;

always @(posedge clk) begin
cnt <= (cnt == (div1-1)) ? (0):(cnt + 1);
if(!cnt)
clk_25  <= !clk_25; 
end

always @(posedge clk_25) begin
cnt2 <= (cnt2 == (div2-1)) ? (0):(cnt2 + 1);
if(!cnt2)
clk_25_by_2  <= !clk_25_by_2;
end

assign clk_out = clk_25_by_2;

endmodule
