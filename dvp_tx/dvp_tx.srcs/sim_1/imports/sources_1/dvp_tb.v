//Function: tb for dvp controller
`timescale 1ns/1ns
module dvp_tb();
reg pclk, aresetn, frame_en;
reg [15:0] data_pixel;
reg [31:0] frame_hfp, frame_hbp, frame_vfp, frame_vbp, video_h, video_v;
wire vsync, hsync, pixel_clk;
wire [15:0] data_bus;

initial begin
  pclk = 0; aresetn = 0; frame_en = 0;
  #200
  aresetn = 1;
  #2000
  frame_en = 1;
end

initial begin
  frame_hfp = 100; frame_hbp = 100; frame_vfp = 80; frame_vbp = 80;
  video_h = 800; video_v = 600;
end

always #(5) pclk = ~pclk;

dvp_controller #(.DW(16))
u_dvp_controller(
  .pclk       (pclk),
  .aresetn    (aresetn),
  .frame_en   (frame_en),
  .data_pixel (data_pixel),
  .frame_hfp  (frame_hfp),
  .frame_hbp  (frame_hbp),
  .frame_vfp  (frame_vfp),
  .frame_vbp  (frame_vbp),
  .video_h    (video_h),
  .video_v    (video_v),
  .vsync      (vsync),
  .hsync      (hsync),
  .pixel_clk  (pixel_clk),
  .data_bus   (data_bus)
);

endmodule