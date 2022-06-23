module top_module (
    input clk,
    input d,
    output q
);

reg t1,t2,r1,r2;

always @(posedge clk) begin
t1 <= ~t1;
r1 <= d;
end

always @(negedge clk) begin
t2 <= ~t2;
r2 <= d;
end

    assign q = (t1 == t2) ? (r2) : (r1);

endmodule
