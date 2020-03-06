module dvp_rx_top(
	input wire clk, reset,
	//CAM
	input wire dvp_pclk, dvp_href, dvp_vsync, //external pclk with freq constraint
	input wire [11:0] dvp_din,
	//VGA
	input wire [11:0] sw,
  input wire        sw_test_mode,
	output wire hsync, vsync,
	output wire [11:0] rgb
);
/*
BUFG BUFG_inst (
      .O(dvp_pclk_buf), // 1-bit output: Clock output
      .I(dvp_pclk)  // 1-bit input: Clock input
   );*/
// ------Cam controller i2c-----

wire [16:0] addr;
wire [11:0] cap_buf_data;
wire        we;
// ------Cam timing capture-----
cam_capture u_cam_capture(
  .pclk	    (dvp_pclk),
  .aresetn  (~reset),
  .vsync    (dvp_vsync),
  .href     (dvp_href),
  .din      (dvp_din),
  .addr     (addr),
  .dout     (cap_buf_data),
  .we       (we)
);

wire [16:0] raddr;
wire enb, p_tick;
wire [11:0] buf_vga_data;
// ------Frame buffer BRAM------
blk_mem_gen_0 frame_buffer(
  .clka   (dvp_pclk),
  .wea    (we),
  .addra  (addr),
  .dina   (cap_buf_data),
  .clkb   (p_tick),
  .enb    (enb),
  .addrb  (raddr), //parsed from x and y
  .doutb  (buf_vga_data) // RGB
);
// ---------VGA display---------

// register for Basys 2 8-bit RGB DAC 
reg [11:0] rgb_reg;
	
// video status output from vga_sync to tell when to route out rgb signal to DAC
wire video_on;
wire [16:0] x_frame, y_frame;
// instantiate vga_sync
// clk: 100MHz fpga clock, p_tick: 25MHz clock
// x,y: true coordinates of pixels in display, can be directly used
vga_sync u_vga_sync (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
                        .video_on(video_on), .p_tick(p_tick), .x(x_frame), .y(y_frame));

// y * 320 + x, 320 = 256 + 64
assign raddr = {y_frame[8:0], 8'b0000_0000} + {y_frame[10:0], 6'b00_0000} + x_frame;
assign enb = (video_on) && (x_frame < 320) && (y_frame < 240) ? 1 : 0; //x <=: for bram delays. FIXME: data mismatch

reg valid;
always @(posedge p_tick or posedge reset) begin
  if(reset) begin
    valid <= 0;
  end else begin
    valid <= enb; //read latency is 1
  end
end

// rgb buffer
always @(posedge clk, posedge reset) begin
  if(reset) begin
    rgb_reg <= 0;
  end else begin
    if(sw_test_mode) begin
      rgb_reg <= sw;
    end else begin
      rgb_reg <= valid ? buf_vga_data : 12'h000;
    end
  end
end

// output
assign rgb = (video_on) ? rgb_reg : 12'b0 ;

endmodule