module formatter(
  input wire [3:0] mode
  input wire       din,
 output wire       dout
);
  assign dout = (mode == 4'b0000) ? 4'b0000 :
                (mode == 4'b0001) ? din :
                //TODO: add other modes
                                    4'b0000;
endmodule