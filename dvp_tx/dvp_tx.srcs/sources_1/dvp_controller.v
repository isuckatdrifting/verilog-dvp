//Function: generate dvp sync interface according to dvp standard 
//Input: {pclk, pixel data, config[frame_hfp, frame_hbp, frame_vfp, frame_vbp, video_h, video_v]}
//Output: {vsync, hsync, pixel_clk, data_bus}

module dvp_controller #(parameter DW = 16)(
  input  wire          pclk,
  input  wire          aresetn,
  input  wire          frame_en,
  input  wire [DW-1:0] data_pixel,
  input  wire   [31:0] h_pad_left,
  input  wire   [31:0] h_pad_right,
  input  wire   [31:0] v_pad_up,
  input  wire   [31:0] v_pad_down,
  input  wire   [31:0] vsync_width,
  input  wire   [31:0] video_h,
  input  wire   [31:0] video_v,
  output wire          vsync,
  output wire          hsync,
  output wire          pixel_clk,
  output wire [DW-1:0] data_bus
);

reg [31:0] h_count, v_count;

assign hsync = (h_count >= h_pad_left && h_count < h_pad_left + video_h) && (v_count >= v_pad_up && v_count < v_pad_up + video_v) ? 1 : 0;
assign vsync = (v_count < vsync_width) ? 1 : 0;
assign pixel_clk = frame_en ? pclk : 0; // pixel clk is active no matter hsync is high or low
assign data_bus = hsync ? data_pixel : 'h0; // FIXME: may need fifo before, rather than this transparent style

always @(posedge pclk or negedge aresetn) begin
  if(!aresetn) begin
    h_count <= 0;
    v_count <= 0;
  end else begin
    if(frame_en) begin
      h_count <= h_count + 1;
      if(h_count == h_pad_left + video_h + h_pad_right - 1) begin
        h_count <= 0;
        if(v_count == vsync_width + v_pad_up + video_v + v_pad_down - 1) begin
          v_count <= 0;
        end else begin
          v_count <= v_count + 1;
        end
      end
    end
  end
end

endmodule