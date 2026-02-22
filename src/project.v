/*
 * Copyright (c) 2024 Nancy Anderson
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_nlanderso_range_finder (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // // All output pins must be assigned. If not used, assign to 0.
  // assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  // assign uio_out = 0;
  // assign uio_oe  = 0;

  // // List all unused inputs to prevent warnings
  wire _unused = &{ena, uio_in[7:2], 1'b0};

//   assign uio_in[7:2] = 6'b0;
//   assign uio_out[6:0] = 7'b0;
  assign uio_oe = 8'h80;
  assign uio_out[6:0] = 7'b0;

  RangeFinder  #(8) rf (.data_in(ui_in), .clock(clk), .reset(~rst_n), .go(uio_in[0]), 
                       .finish(uio_in[1]), .range(uo_out), .error(uio_out[7]));

endmodule