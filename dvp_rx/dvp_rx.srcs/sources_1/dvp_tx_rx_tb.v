`timescale 1ns/1ns
module dvp_tx_rx_tb();
// -----------Arty A7-------- -> -----------Basys3-----------
// DVP Dummy config -> DVP TX -> DVP RX -> Framebuffer -> VGA

//-----DVP TX-----
reg arm_pclk, aresetn;
reg orientation_input = 1; //0: Normal, 1: Column First
wire dvp_vsync, dvp_hsync, dvp_pclk;
wire [11:0] dvp_data;

initial begin
  arm_pclk = 0; aresetn = 0;
  #200
  aresetn = 1;
end
always #5 arm_pclk = ~arm_pclk;

dvp_tx u_dvp_tx(
  .clk(arm_pclk),
  .aresetn(aresetn),
  .orientation_input(orientation_input),
  .dvp_vsync(dvp_vsync),
  .dvp_hsync(dvp_hsync),
  .dvp_pclk(dvp_pclk),
  .orientation(orientation),
  .dvp_data(dvp_data),
  .led()
);
//-----DVP RX-----

reg rx_clk; reg sw_test_mode;
wire vga_hsync, vga_vsync;
wire [11:0] vga_rgb;

initial begin
  rx_clk = 0; sw_test_mode = 0;
end

always #5 rx_clk = ~rx_clk;
dvp_rx_top u_dvp_rx_top(
	.clk      (rx_clk),
  .reset    (~aresetn),
	//CAM
	.dvp_pclk (dvp_pclk), 
  .dvp_href (dvp_hsync),
  .dvp_vsync(dvp_vsync),
	.dvp_din  (dvp_data),
  .dvp_orientation(orientation),
	//VGA
  .sw_test_mode (sw_test_mode),
	.hsync    (vga_hsync), 
  .vsync    (vga_vsync),
	.rgb      (vga_rgb)
);
endmodule