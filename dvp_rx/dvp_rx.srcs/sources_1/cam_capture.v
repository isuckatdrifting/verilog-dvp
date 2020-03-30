//Function: address counter for framebuffer, data transparent
module cam_capture(
  input wire        pclk,
  input wire        aresetn,
  input wire        vsync,
  input wire        href,
  input wire [11:0] din,
  input wire        orientation, //0: normal, 1: transposed
 output wire [16:0] addr,
 output wire [11:0] dout,
 output wire        we
);

reg [16:0] addr_reg;
wire [16:0] addr_hard_wire;

assign dout = din;
assign addr = orientation ? addr_hard_wire : addr_reg;
assign we   = orientation ? vsync : href;

reg [16:0] stream_counter, atom_counter;
wire hsync_fall_edge, vsync_fall_edge;

// EDGE: 0 for falling edge, 1 for rising edge
edvr_edge_det #(.EDGE(0)) edvr_edge_det_hsync(.clk(pclk), .rstn(aresetn), .din(href), .dout_edge(hsync_fall_edge));
edvr_edge_det #(.EDGE(0)) edvr_edge_det_vsync(.clk(pclk), .rstn(aresetn), .din(vsync),.dout_edge(vsync_fall_edge));

always @(posedge pclk or negedge aresetn) begin
  if(!aresetn) begin
    addr_reg <= 17'b0;
    stream_counter <= 0;
    atom_counter <= 0;
  end else begin
    if(!orientation) begin //Normal Encoding
      if(vsync) begin //a premise: vsync and href will never be high at the same time
        addr_reg <= 0;
        stream_counter <= 0;
      end
      if(href) begin
        addr_reg <= addr_reg + 1; 
      end
      if(hsync_fall_edge) begin
        stream_counter <= stream_counter + 1;
        atom_counter <= 0; // clean up counter within a stream
      end
    end else begin // Jump encoding
      if(href) begin
        addr_reg <= 0;
        atom_counter <= 0;
        stream_counter <= 0;
      end
      if(vsync) begin //address remapping in column-first mode
        atom_counter <= atom_counter + 1;
      end
      if(vsync_fall_edge) begin
        stream_counter <= stream_counter + 1;
        atom_counter <= 0; // clean up counter within a stream
      end
    end
  end
end

// hard wire addr in col mode: addr = atom * 320 + stream number.
assign addr_hard_wire = {atom_counter[8:0], 8'b0000_0000} + {atom_counter[10:0], 6'b00_0000} + stream_counter;
endmodule