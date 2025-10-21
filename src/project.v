/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_intro_ii_stopwatch (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out[7:4] = '0;  // Unused outputs
  assign uio_oe = '1;  // Will use ALL bidirectional pins as outputs

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, ui_in[7:4], uio_in, 1'b0};

  // Instantiate project
  intro_2_stopwatch stopwatch_proj (
    .clk(clk),
    .n_rst(rst_n),
    .BTN(ui_in[3:0]),
    .D0_AN_0(uo_out[0]),
    .D0_AN_1(uo_out[1]),
    .D0_AN_2(uo_out[2]),
    .D0_AN_3(uo_out[3]),
    .D0_SEG(uio_out)
  );

endmodule
