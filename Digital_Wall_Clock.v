`timescale 1ns/1ps

module top;
reg clk,rst;
//wire [7:0]ss_out;

wire [7:0] hh;
wire [7:0] mm;
wire [7:0] ss;
wire pm;

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
    .ena(1'b1),
    . pm( pm),
    . hh(hh),
    . mm(mm),
    . ss(ss)
    ); 

endmodule 


module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
    
wire [7:0]SS_out;
wire [7:0]MM_out;
wire MM_en;
wire  HH_en;
wire  pm_en;

reg [3:0]HH_lb;
reg [3:0]HH_ub;
reg [3:0]state1;

reg  pm_reg;
   
 
SS_cnt #(.BCD_L1(9),.BCD_L2(5)) SS_cnt_inst  (.clk(clk),.reset(reset) ,.ena(ena),.ss(SS_out) );
SS_cnt #(.BCD_L1(9),.BCD_L2(5)) MM_cnt_inst (.clk(clk),.reset(reset) ,.ena(MM_en),.ss(MM_out) );


always @(posedge clk) begin
if(reset) begin
HH_lb <= 'h2;
HH_ub <= 'h1;
state1 <= 0;
end else begin

case(state1)
'd0: begin
     if(HH_en) begin
     HH_lb <= 1;
     HH_ub <=  0;
     state1 <= 1;
     end
     end
     
 'd1: begin
     if(HH_en) begin
     HH_lb <= (HH_lb == 'd9) ?(0):(HH_lb + 1);
     HH_ub <=  (HH_lb == 'd9) ?(1):(0);
     state1 <= (HH_lb == 'd9) ?(2):(1);
     end
     end
         
'd2: begin
     if(HH_en) begin
     HH_lb <= (HH_lb == 'd2) ?(1):(HH_lb + 1);
     HH_ub <=  (HH_lb == 'd2) ?(0):(1);
     state1 <= (HH_lb == 'd2) ?(1):(2);
     end
     end
endcase
end
end


always @(posedge clk) begin
if(reset) begin
pm <= 0;
end else begin
pm <= (pm_en) ? (~pm) : (pm);
end
end

assign  hh = {HH_ub,HH_lb}; 
assign  ss = SS_out; 
assign  mm = MM_out; 

assign  pm_en = ( hh == 'h11 && mm == 'h59 && ss == 'h59 ) ?(1):(0); 
assign MM_en =  (SS_out == 'h59) ? (1):(0);
assign HH_en =  (MM_out == 'h59 && SS_out == 'h59 ) ? (1):(0); 

endmodule

module SS_cnt
#(
parameter BCD_L1 = 9,
parameter BCD_L2 = 5
)
(
    input clk,
    input reset,
    input ena,
    output [7:0] ss); 

reg [3:0]ss_reg_lb;
reg [3:0]ss_reg_ub;
reg [3:0]state;
wire ss_ub_en;

always @(posedge clk) begin : SS_LowerBit
if(reset)
ss_reg_lb <= 'd0;
else begin
if(ena)
ss_reg_lb <= (ss_reg_lb == BCD_L1) ?(0):(ss_reg_lb + 1);
end
end

assign ss_ub_en = (ss_reg_lb == BCD_L1) ? (1):(0);

always @(posedge clk) begin : SS_UpperBit
if(reset)
ss_reg_ub <= 'd0;
else begin
if(ss_ub_en && ena)
ss_reg_ub <= (ss_reg_ub == BCD_L2) ?(0):(ss_reg_ub + 1);
end
end

assign  ss = {ss_reg_ub , ss_reg_lb};

endmodule

