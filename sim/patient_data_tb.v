`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name:  SDU Imaging system testbench
// Module Name: patient_data_tb 
// Project Name: Spectral Doppler Ultrasound Imaging System 
//////////////////////////////////////////////////////////////////////////////////
module patient_data_tb;

   /****************************************************************************
    * Internal Signals
    ***************************************************************************/

   reg         fast_clk;
   reg         slow_clk;
   reg         reset;

   reg  [15:0] din_re_Ff;
   reg  [15:0] din_im_Ff;

   reg         fir_filter_nd_Ff;
   wire        fir_filter_rfd_Ff;

   wire        fft_done_Fs;
   reg         fft_unload_Fs;
   wire        fft_dv_Fs;

   wire [31:0] dout_re_Fs;
   wire [31:0] dout_im_Fs;

   integer input_file;
   integer j;
   integer i;
   integer count;
   integer column;

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
      forever #210 slow_clk = ~slow_clk;
   end

   /****************************************************************************
    * Module Instantiations
    ***************************************************************************/

   top top_0 (
      .fast_clk          (fast_clk),
      .slow_clk          (slow_clk),
      .reset             (reset),
      .din_re_Ff         (din_re_Ff),
      .din_im_Ff         (din_im_Ff),
      .fir_filter_nd_Ff  (fir_filter_nd_Ff),
      .fir_filter_rfd_Ff (fir_filter_rfd_Ff),
      .fft_done_Fs       (fft_done_Fs),
      .fft_unload_Fs     (fft_unload_Fs),
      .fft_dv_Fs         (fft_dv_Fs),
      .dout_re_Fs        (dout_re_Fs),
      .dout_im_Fs        (dout_im_Fs)
   );

   /****************************************************************************
    * Generate Stimulus
    ***************************************************************************/

   initial begin

      @(posedge fast_clk);

      // Pulse the reset signal.
      reset = 1'b1;
      @(posedge fast_clk);

      din_re_Ff = 0;
      din_im_Ff = 0;
      fir_filter_nd_Ff = 1'b0;
      fft_unload_Fs = 1'b0;

      input_file = $fopen("../matlab/input_data.txt", "r");

      repeat(9) @(posedge fast_clk);

      reset = 1'b0;
      @(posedge fast_clk);

      // The output of the FIR filter is not valid until the core has received
      // the same number of input data samples as the filter has coefficients.
      // Initialize the filter by sending in zeroes.
      for (i = 0; i < 106; i = i+1) begin

         din_re_Ff = 0;
         din_im_Ff = 0;
         fir_filter_nd_Ff = 1'b1;
         @(posedge fast_clk);

         // Wait for rfd to be asserted.
         while (fir_filter_rfd_Ff !== 1'b1)
            @(posedge fast_clk);

      end

      // Send in enough patient data to perform 10 FFTs.
      for (j = 0; j < 10; j = j+1) begin

         fir_filter_nd_Ff = 1'b0;
         repeat (100) @(posedge fast_clk);

         // Send in the patient data samples.
         for (i = 0; i < 896; i = i+1) begin

            $fscanf(input_file, "%08h", {din_re_Ff, din_im_Ff});
            fir_filter_nd_Ff = 1'b1;
            @(posedge fast_clk);

            // Wait for rfd to be asserted.
            while (fir_filter_rfd_Ff !== 1'b1)
               @(posedge fast_clk);

         end

         fir_filter_nd_Ff = 1'b0;

         // Wait for the FFT done signal to be asserted.
         while (fft_done_Fs === 1'b0)
            @(posedge slow_clk);

         // Pulse unload to unload the data.
         fft_unload_Fs = 1'b1;
         @(posedge slow_clk);

         fft_unload_Fs = 1'b0;

         // Wait for the output data from the FFT to be valid.
         while (fft_dv_Fs === 1'b0)
            @(posedge slow_clk);

         // Wait until the output data from the FFT is no longer valid.
         while (fft_dv_Fs === 1'b1)
            repeat (1) @(posedge slow_clk);

      end // for (j = 0; j < 10; j = j+1)

      repeat (20) @(posedge slow_clk);

      $finish;

   end

   /****************************************************************************
    * Record Output Data
    ***************************************************************************/

   initial begin

      column = 0;

      // Display the FFT output data in MATLAB-friendly format.
      forever begin

         count = 0;

         while (fft_dv_Fs !== 1'b1) begin
            repeat (1) @(posedge slow_clk);
         end

         $write("hw_fft_col%0d = [", column);
         while (count < 128) begin
            if (count < 127)
               $write("%0d + %0d*1i; ", $signed(dout_re_Fs), $signed(dout_im_Fs));
            else
               $write("%0d + %0d*1i", $signed(dout_re_Fs), $signed(dout_im_Fs));
            count = count + 1;
            repeat (1) @(posedge slow_clk);
         end
         $write("];");

         $write("\n\n");

         column = column + 1;

      end

   end

endmodule
