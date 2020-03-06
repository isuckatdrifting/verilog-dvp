module dvp_rx_top_tb();
reg clk, reset;
reg [11:0] sw;
wire hsync, vsync;
wire [11:0] rgb;

initial begin
  clk = 0; reset = 1; sw = 12'h001;
  #200 reset = 0;
end

always #5 clk = ~clk; //100M

dvp_rx_top u_dvp_rx_top(
  .clk(clk),
  .reset(reset),
  .sw(sw),
  .hsync(hsync),
  .vsync(vsync),
  .rgb(rgb)
);

endmodule
