`timescale 1ns/1ps

module top;
reg clk,rst;
wire OneHertz;
wire [2:0]w1;


initial begin
clk = 2'b0;
rst = 2'b1;
#50;
rst = 2'b0;
end

always #5 clk =  ~clk;

top_module inst(
    .clk(clk),
    .reset(rst),
    .OneHertz(OneHertz),
    .c_enable(w1)
);



endmodule 


module top_module (
    input clk,
    input reset,
    output  OneHertz,
    output [2:0] c_enable
); //
    wire  [3:0]cout1,cout2,cout3;
    wire  en1,en2,en3;

    
    bcdcount counter0 (.clk(clk),.reset(reset) ,.enable(1'b1),.Q(cout1) );
    bcdcount counter1 (.clk(clk),.reset(reset) ,.enable(en1),.Q(cout2) );
    bcdcount counter2 (.clk(clk),.reset(reset) ,.enable(en2),.Q(cout3) );


     assign en1 = (cout1 == 'd9)?(1):(0);
     assign en2 = (cout2 == 'd9 && en1 == 1 )?(1):(0);
     assign OneHertz = (cout3 == 'd9 && en2 == 1 )?(1):(0);
     
   
    assign c_enable =   {en2,en1,1'b1};

endmodule

module bcdcount  (
input clk,
input reset ,
input enable,
output reg [3:0]Q
);

always @(posedge clk) begin
if(reset)
Q <= 1'b0;
else begin
if(enable)
Q <= (Q == 9) ?(0):(Q+1);
end
end

endmodule
