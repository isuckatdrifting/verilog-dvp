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
  input  wire   [31:0] sync_width, // frame_sync_width
  input  wire   [31:0] video_h,
  input  wire   [31:0] video_v,
  input  wire          orientation, // 0 - normal by default, 1 - transposed frame (switch h/v, and indexing)
  input  wire   [31:0] sample,
  output wire          vsync,
  output wire          hsync,
  output wire          pixel_clk,
  output wire [DW-1:0] data_bus,
  output wire          stream_prefetch,
  output wire   [31:0] s_count, // sample count
  output wire   [31:0] h_count, // horizontal count
  output wire   [31:0] v_count // vertical count
);

localparam SRAM_RD_DELAY = 1;
reg [31:0] lv0_count, lv1_count, lv2_count;
wire lv1_sync, lv2_sync;
wire [31:0] lv1_pad_front, lv1_length, lv1_pad_end, lv2_pad_front, lv2_length, lv2_pad_end;
//input assign
assign lv1_pad_front  = orientation ? v_pad_up    : h_pad_left;
assign lv1_length     = orientation ? video_v     : video_h;
assign lv1_pad_end    = orientation ? v_pad_down  : h_pad_right;
assign lv2_pad_front  = orientation ? h_pad_left  : v_pad_up;
assign lv2_length     = orientation ? video_h     : video_v;
assign lv2_pad_end    = orientation ? h_pad_right : v_pad_down;

//internal assign
assign stream_prefetch = (lv1_count >= lv1_pad_front + lv1_length + lv1_pad_end - 1 - SRAM_RD_DELAY) // - 1 for the data frontend to trigger the sram cs
                          && (lv2_count >= lv2_pad_front - 1 && lv2_count < lv2_pad_front + lv2_length - 1) ? 1 : 0; //promopt prefetch at the previous line end
assign lv1_sync = (lv1_count >= lv1_pad_front && lv1_count < lv1_pad_front + lv1_length) 
                    && (lv2_count >= lv2_pad_front && lv2_count < lv2_pad_front + lv2_length) ? 1 : 0;
assign lv2_sync = (lv2_count < sync_width) ? 1 : 0;

//output assign
assign pixel_clk = frame_en ? pclk : 0; // pixel clk is active no matter hsync is high or low
assign data_bus = lv1_sync ? data_pixel : 'h0; // FIXME: may need fifo before, rather than this transparent style
assign hsync = orientation ? lv2_sync : lv1_sync;
assign vsync = orientation ? lv1_sync : lv2_sync;
assign s_count = lv0_count;
assign h_count = orientation ? lv2_count : lv1_count;
assign v_count = orientation ? lv1_count : lv2_count;

always @(posedge pclk or negedge aresetn) begin
  if(!aresetn) begin
    lv0_count <= 0;
    lv1_count <= 0;
    lv2_count <= 0;
  end else begin
    if(frame_en) begin
      if(lv0_count == sample - 1) begin //stacked counter
        lv0_count <= 0;
        if(lv1_count == lv1_pad_front + lv1_length + lv1_pad_end - 1) begin
          lv1_count <= 0;
          if(lv2_count == lv2_pad_front + lv2_length + lv2_pad_end - 1) begin
            lv2_count <= 0;
          end else begin
            lv2_count <= lv2_count + 1;
          end
        end else begin
          lv1_count <= lv1_count + 1;
        end
      end else begin
        lv0_count <= lv0_count + 1;
      end
    end else begin // Clean up the counters if not displaying or switching modes
      lv0_count <= 0;
      lv1_count <= 0;
      lv2_count <= 0;
    end
  end
end

endmodule