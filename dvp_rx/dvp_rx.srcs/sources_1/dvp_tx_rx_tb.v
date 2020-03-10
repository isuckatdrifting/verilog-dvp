module dvp_tx_rx_tb();
// -----------Arty A7-------- -> -----------Basys3-----------
// DVP Dummy config -> DVP TX -> DVP RX -> Framebuffer -> VGA

//-----DVP TX-----
reg arm_pclk, aresetn, frame_en;
reg [11:0] data_pixel;
reg [31:0] h_pad_left, h_pad_right, vsync_width, v_pad_up, v_pad_down, video_h, video_v;
wire dvp_vsync, dvp_hsync, dvp_pclk;
wire [11:0] dvp_data;

initial begin
  arm_pclk = 0; aresetn = 0; frame_en = 0;
  #200
  aresetn = 1;
  #2000
  frame_en = 1;
end

initial begin
  // in px
  video_h = 320; h_pad_left = 0; h_pad_right = 1728; 
  // in lines
  video_v = 240; vsync_width = 1; v_pad_up = 7; v_pad_down = 16; //2048px, 14336px, 32768px
end
//FIXME: config clock and data clock are the same for now.
always #(5) arm_pclk = ~arm_pclk; 

wire [31:0] h_count, v_count;
wire [2:0] bar_select;
wire [3:0] data_pixel_r, data_pixel_g, data_pixel_b;
assign bar_select = h_count < 40 ? 0:
                    h_count < 80 ? 1:
                    h_count < 120 ? 2:
                    h_count < 160 ? 3:
                    h_count < 200 ? 4:
                    h_count < 240 ? 5:
                    h_count < 280 ? 6: 7;

// R G B Select Color
// 0 0 0   0    Black
// 0 0 1   1    Blue
// 0 1 0   2    Green
// 0 1 1   3    Turquoise
// 1 0 0   4    Red
// 1 0 1   5    Purple
// 1 1 0   6    Yellow
// 1 1 1   7    White
assign data_pixel_r = (bar_select == 4 || bar_select == 5 || bar_select == 6 || bar_select == 7) ? 4'hf : 0;
assign data_pixel_g = (bar_select == 2 || bar_select == 3 || bar_select == 6 || bar_select == 7) ? 4'hf : 0;
assign data_pixel_b = (bar_select == 1 || bar_select == 3 || bar_select == 5 || bar_select == 7) ? 4'hf : 0;

wire hline_prefetch; reg sram_ren = 0; reg [15:0] sram_h_count = 0;
always @(posedge arm_pclk) begin
  if(hline_prefetch) begin
    sram_ren <= 1;
  end
  if(sram_ren) begin
    data_pixel = {data_pixel_r, data_pixel_g, data_pixel_b};
    sram_h_count <= sram_h_count + 1;
  end
  if(sram_h_count == video_h - 1) begin
    sram_ren <= 0;
    sram_h_count <= 0;
  end
end

dvp_controller #(.DW(12))
u_dvp_controller(
  .pclk       (arm_pclk),
  .aresetn    (aresetn),
  .frame_en   (frame_en),
  .data_pixel (data_pixel),
  .h_pad_left (h_pad_left),
  .h_pad_right(h_pad_right),
  .v_pad_up   (v_pad_up),
  .v_pad_down (v_pad_down),
  .vsync_width(vsync_width),
  .video_h    (video_h),
  .video_v    (video_v),
  .vsync      (dvp_vsync),
  .hsync      (dvp_hsync),
  .pixel_clk  (dvp_pclk),
  .data_bus   (dvp_data),
  .hline_prefetch(hline_prefetch),
  .h_count    (h_count),
  .v_count    (v_count)
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
  .dvp_href (dvp_hsync),  //FIXME: use href
  .dvp_vsync(dvp_vsync),
	.dvp_din  (dvp_data),
	//VGA
  .sw_test_mode (sw_test_mode),
	.hsync    (vga_hsync), 
  .vsync    (vga_vsync),
	.rgb      (vga_rgb)
);
endmodule