`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name:  SDU Imaging system testbench
// Module Name: hamming_window_tb 
// Project Name: Spectral Doppler Ultrasound Imaging System 
//////////////////////////////////////////////////////////////////////////////////
module hamming_window_tb;

   /****************************************************************************
    * Internal Signals
    ***************************************************************************/

   reg         clk;
   reg         reset;

   reg  [31:0] in_data;
   reg         in_valid;
   wire [47:0] out_data;
   wire        out_valid;

   integer i;

   /****************************************************************************
    * Generate Clock
    ***************************************************************************/

   initial begin
      clk = 1'b0;
      forever #50 clk = ~clk;
   end

   /****************************************************************************
    * Instantiate Modules
    ***************************************************************************/

   hamming_window hamming_window_0 (
      .clk (clk),
      .reset (reset),
      .in_data (in_data),
      .in_valid (in_valid),
      .out_data_F (out_data),
      .out_valid_F (out_valid)
   );

   /****************************************************************************
    * Generate Stimulus
    ***************************************************************************/

   initial begin

      @(posedge clk);

      reset = 1'b1;
      @(posedge clk);

      reset = 1'b0;
      in_data = 0;
      in_valid = 1'b0;
      repeat (3) @(posedge clk);

      for (i = 0; i < 128; i = i+1) begin
         in_data = 1;
         in_valid = 1'b1;
         @(posedge clk);
      end

      in_valid = 1'b0;
      repeat (5) @(posedge clk);

      $finish;

   end

endmodule
