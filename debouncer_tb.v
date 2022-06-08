`timescale 1ns/1ps

module top();
reg clk,tb_d_i,clk_hf;
wire tb_d_o,tb_valid_out_o;

initial begin
clk = 1'b0;
clk_hf = 1'b0;
tb_d_i = 1'b0;
end

//wire clk_out_by_3;
always #5 clk = ~clk;

d_bounce #(10) dut(.clk_1Khz(clk),.data_in(tb_d_i),.data_out(tb_d_o),.valid_out(tb_valid_out_o));

initial begin
repeat(40) begin
#10 tb_d_i = ~tb_d_i;
end
tb_d_i = 1'b1;
#220;
repeat(40) begin
#10 tb_d_i = ~tb_d_i;
end

//repeat(3) begin
//tb_d_i = 1'b0;
//#220;

repeat(40) begin
#10 tb_d_i = ~tb_d_i;
end
tb_d_i = 1'b0;
#100;

repeat(3) begin
tb_d_i = 1'b0;
#220;
tb_d_i = 1'b1;
#220;
end

$finish();
end


endmodule

