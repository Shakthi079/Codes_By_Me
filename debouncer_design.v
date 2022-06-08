module d_bounce
#(
parameter stable_time = 10
)
(clk_1Khz,data_in,data_out,valid_out);

input clk_1Khz,data_in;
output reg data_out;
output wire  valid_out;

reg data_in_previous;
reg [3:0]state;
reg [3:0]stable_cnt;

initial begin
state  = 'd0;
stable_cnt  = 'd0;
data_in_previous  = 'd0;
end

always @(posedge clk_1Khz) begin
case(state)
4'd0:begin
data_in_previous <= data_in;
state <= 'd1;
stable_cnt <= 'd0;
end

4'd1: begin
if(data_in == data_in_previous) begin
stable_cnt <= stable_cnt + 1;
state <= (stable_cnt == (stable_time))? ('d3):('d1); 
end else
state <= 'd2;
end 

4'd2: begin
data_out <= 0;
state <= 'd0;
end 

4'd3: begin
data_out <= data_in_previous;
state <= 'd0;
end
 
endcase
end

assign valid_out = (state == 2) ? (1):(0);
//assign data_out = data_in_previous;
 
endmodule
