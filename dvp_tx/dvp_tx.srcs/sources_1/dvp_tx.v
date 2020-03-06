module dvp_tx(
  input wire         clk,
  input wire         aresetn,
  output wire        dvp_vsync,
  output wire        dvp_hsync,
  output wire        dvp_pclk,
  output wire [11:0] dvp_data,
  output wire  [1:0] led
);

//-----Dummy Configurator------
wire [31:0] h_pad_left, h_pad_right, vsync_width, v_pad_up, v_pad_down, video_h, video_v;
// in px
assign video_h = 320; 
assign h_pad_left = 0; 
assign h_pad_right = 1728; 
// in lines
assign video_v = 240; 
assign vsync_width = 1; 
assign v_pad_up = 7; 
assign v_pad_down = 16; //2048px, 14336px, 32768px

reg frame_en;
reg [11:0] data_pixel;
reg [1:0] indicator;
reg [31:0] delay_counter; //delay 1s = 1e8 cycles at 100M.
assign led = indicator;
always@(posedge clk or negedge aresetn) begin
  if(!aresetn) begin
    frame_en <= 0;
    data_pixel <= 12'h000;
    indicator <= 2'b00;
    delay_counter <= 0;
  end else begin
    indicator[0] <= 1;
    if(delay_counter < 100000000) begin
      delay_counter <= delay_counter + 1;
    end else begin
      frame_en <= 1; indicator[1] <= 1;
      data_pixel <= data_pixel + 1; //Dummy configs
    end
  end
end

//-----Transmitting controller-----
dvp_controller #(.DW(12))
u_dvp_controller(
  .pclk       (clk),
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
  .data_bus   (dvp_data)
);

endmodule