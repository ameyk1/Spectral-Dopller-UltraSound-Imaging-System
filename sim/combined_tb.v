`timescale 1ns/10ps


//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name:  SDU Imaging system
// Module Name: combined_tb 
// Project Name: Spectral Doppler Ultrasound Imaging System 
//////////////////////////////////////////////////////////////////////////////////

module combined_tb;

   /****************************************************************************
    * Internal Signals
    ***************************************************************************/

   reg         clk;
   reg         reset;

   reg  [15:0] din_re;
   reg  [15:0] din_im;

   reg         fir_filter_nd;

   wire        fft_done;
   reg         fft_unload;
   wire        fft_dv;

   wire [31:0] dout_re;
   wire [31:0] dout_im;

   integer     i;
   integer     count;

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

   top top_0 (
      .clk           (clk),
      .reset         (reset),
      .din_re        (din_re),
      .din_im        (din_im),
      .fir_filter_nd (fir_filter_nd),
      .fft_done      (fft_done),
      .fft_unload    (fft_unload),
      .fft_dv        (fft_dv),
      .dout_re       (dout_re),
      .dout_im       (dout_im)
   );

   /****************************************************************************
    * Generate Stimulus
    ***************************************************************************/

   initial begin

      @(posedge clk);

      // Pulse the reset signal.
      reset = 1'b1;
      @(posedge clk);

      din_re = 0;
      din_im = 0;
      fir_filter_nd = 1'b0;
      fft_unload = 1'b0;

      reset = 1'b0;
      @(posedge clk);

      // The output data vector is not valid until the core has received the
      // same number of input data samples as the filter has coefficients.
      // Initialize the filter.
      for (i = 0; i < 106; i = i+1) begin
         din_re = 0;
         din_im = 0;
         fir_filter_nd = 1'b1;
         @(posedge clk);
      end

      // Now send in the real data.
      for (i = 0; i < 128; i = i+1) begin
         din_re = (i == 0)? 32 : 0;
         din_im = 0;
         fir_filter_nd = 1'b1;
         @(posedge clk);
      end

      // Flush out the rest of the answer.
      for (i = 0; i < 43; i = i+1) begin
         din_re = 0;
         din_im = 0;
         fir_filter_nd = 1'b1;
         @(posedge clk);
      end

      fir_filter_nd = 1'b0;

      // Wait for the FFT done signal to be asserted.
      while (fft_done === 1'b0)
         @(posedge clk);

      // Pulse unload to unload the data.
      fft_unload = 1'b1;
      @(posedge clk);

      fft_unload = 1'b0;

      while (fft_dv === 1'b0)
         @(posedge clk);

      while (fft_dv === 1'b1)
         repeat (1) @(posedge clk);

      repeat (20) @(posedge clk);

      $finish;

   end

   /****************************************************************************
    * Record Output
    ***************************************************************************/

   initial begin

      count = 0;

      while (fft_dv !== 1'b1) begin
         repeat (1) @(posedge clk);
      end

      $write("[");
      while (count < 128) begin
         if (count < 127)
            $write("%0d + %0d*1i; ", $signed(dout_re), $signed(dout_im));
         else
            $write("%0d + %0d*1i", $signed(dout_re), $signed(dout_im));
         count = count + 1;
         repeat (1) @(posedge clk);
      end
      $write("]");

   end

endmodule
