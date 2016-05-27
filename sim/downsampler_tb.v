`timescale 1ns/10ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name:  SDU Imaging system testbench
// Module Name: downsampler_tb 
// Project Name: Spectral Doppler Ultrasound Imaging System 
//////////////////////////////////////////////////////////////////////////////////

module downsampler_tb;

   /****************************************************************************
    * Internal Signals
    ***************************************************************************/

   reg         fast_clk;
   reg         slow_clk;
   reg         reset;
   reg         din_valid;
   reg  [31:0] din_re_Ff;
   reg  [31:0] din_im_Ff;
   wire [31:0] dout_re_Fs;
   wire [31:0] dout_im_Fs;

   integer i;

   /****************************************************************************
    * Generate Clocks
    ***************************************************************************/

   initial begin
      fast_clk = 1'b0;
      forever #10 fast_clk = ~fast_clk;
   end

   initial begin
      slow_clk = 1'b0;
      repeat (1) @(posedge fast_clk);
      slow_clk = 1'b1;
      forever #70 slow_clk = ~slow_clk;
   end

   /****************************************************************************
    * Instantiate Modules
    ***************************************************************************/

   downsampler downsampler_0 (
      .fast_clk   (fast_clk),
      .slow_clk   (slow_clk),
      .reset      (reset),
      .din_valid  (din_valid),
      .din_re_Ff  (din_re_Ff),
      .din_im_Ff  (din_im_Ff),
      .dout_re_Fs (dout_re_Fs),
      .dout_im_Fs (dout_im_Fs)
   );

   /****************************************************************************
    * Generate Stimulus
    ***************************************************************************/

   initial begin

      repeat (1) @(posedge fast_clk);

      reset = 1'b1;
      repeat (1) @(posedge fast_clk);

      din_valid = 1'b0;
      reset = 1'b0;
      repeat (1) @(posedge fast_clk);

      for (i = 0; i < 80; i = i+1) begin
         din_re_Ff = i;
         din_im_Ff = i;
         din_valid = 1'b1;
         repeat (1) @(posedge fast_clk);
      end

      din_valid = 1'b0;

      repeat (20) @(posedge fast_clk);

      $finish;

   end

   /****************************************************************************
    * Record Output
    ***************************************************************************/

   initial begin

      forever begin
         repeat (1) @(posedge slow_clk);
         $display("%0d %0d\n", dout_re_Fs, dout_im_Fs);
      end

   end

endmodule
