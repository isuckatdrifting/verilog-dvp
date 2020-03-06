//Function: Controls the video data output path
//Input: {pclk, mode, pixel_tdc, pixel_hist, pixel_peak}
//Output: {pixel_dvp, pixel_mipi}

/*
 * TDC array -> histogram -> peak detection -> |------| -> DVP
 *           |            |------------------> |SW MUX|
 *           |-------------------------------> |------| -> MIPI
 */

module dp_switch #(parameter DW = 16)(
  input wire pclk,
  input wire aresetn,
  input wire [4:0] mode,
  input wire [DW-1:0] pixel_tdc,
  input wire [DW-1:0] pixel_hist,
  input wire [DW-1:0] pixel_peak,
  output wire [DW-1:0] pixel_dvp//,
  //output wire [DW-1:0] pixel_mipi
);

reg [4:0] mode_reg; // [4:3] output path. 00: no output, 01: DVP, 10: MIPI, 11: both.
                    // [2:0]  input path. 000: no select, 001: TDC array, 010: Histogram, 100: Peak Detection.

wire [DW-1:0] pixel_source;
assign pixel_source = mode_reg[0] ? pixel_tdc :
                              mode_reg[1] ? pixel_hist :
                              mode_reg[2] ? pixel_peak : 'h0;

assign pixel_dvp = mode_reg[3] ? pixel_source : 'h0;
//assign pixel_mipi = mode_reg[4] ? pixel_source : 'h0;

always @(posedge pclk or negedge aresetn) begin
  if(!aresetn) begin
    mode_reg <= 5'b00_000;
  end else begin
    mode_reg <= mode;
  end
end

endmodule