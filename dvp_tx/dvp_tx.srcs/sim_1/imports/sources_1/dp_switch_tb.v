//Function: tb for dp switch
`timescale 1ns/1ns
module dp_switch_tb();
reg pclk, aresetn;
reg [4:0] mode;
reg [15:0] pixel_tdc, pixel_hist, pixel_peak;
wire [15:0] pixel_dvp;//, pixel_mipi;

initial begin
  pclk = 0; aresetn = 0;
  #200
  aresetn = 1;
end

always #(5) pclk = ~pclk;

initial begin
  pixel_tdc = 16'h0123; pixel_hist = 16'h4567; pixel_peak = 16'h89AB;
      mode = 5'b00_000; // all off
  #220;
  #20 mode = 5'b00_001;
  #20 mode = 5'b00_010;
  #20 mode = 5'b00_100;

  #20 mode = 5'b01_001;
  #20 mode = 5'b01_010;
  #20 mode = 5'b01_100;

  #20 mode = 5'b10_001;
  #20 mode = 5'b10_010;
  #20 mode = 5'b10_100;

  #20 mode = 5'b11_001;
  #20 mode = 5'b11_010;
  #20 mode = 5'b11_100;
end
dp_switch #(.DW(16))
u_dp_switch(
  .pclk(pclk),
  .aresetn(aresetn),
  .mode(mode),
  .pixel_tdc(pixel_tdc),
  .pixel_hist(pixel_hist),
  .pixel_peak(pixel_peak),
  .pixel_dvp(pixel_dvp)//,
  //.pixel_mipi(pixel_mipi)
);

endmodule
