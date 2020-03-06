//Function: address counter for framebuffer, data transparent
module cam_capture(
  input wire        pclk,
  input wire        aresetn,
  input wire        vsync,
  input wire        href,
  input wire [11:0] din,
 output wire [16:0] addr,
 output wire [11:0] dout,
 output wire        we
);

reg [16:0] addr_reg;

assign dout = din;
assign addr = addr_reg;
assign we   = href;

always @(posedge pclk or negedge aresetn) begin
  if(!aresetn) begin
    addr_reg <= 17'b0;
  end else begin
    if(vsync) begin //a premise: vsync and href will never be high at the same time
      addr_reg <= 0;
    end
    if(href) begin
      addr_reg <= addr_reg + 1;
    end
  end
end
endmodule