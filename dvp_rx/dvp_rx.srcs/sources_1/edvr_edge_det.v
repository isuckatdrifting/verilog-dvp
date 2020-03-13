module edvr_edge_det #(parameter EDGE = 1'b1) (
  input clk,
  input rstn,
  input din,
 output dout_edge 
);

reg din_d1;

always @(posedge clk or negedge rstn) begin
  if(!rstn)
    din_d1 <= ~EDGE;
  else
    din_d1 <= din;
end
assign dout_edge = EDGE ? din & ~din_d1 : ~din & din_d1;

endmodule