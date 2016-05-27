`timescale 1ns/10ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name:  SDU Imaging system testbench
// Module Name: fft128_tb 
// Project Name: Spectral Doppler Ultrasound Imaging System 
//////////////////////////////////////////////////////////////////////////////////
module fft128_tb;

   /****************************************************************************
    * Internal Signals
    ***************************************************************************/

   reg         clk;
   reg         sclr;

   reg         start;
   reg         unload;
   reg [31:0]  xn_re;
   reg [31:0]  xn_im;
   reg         fwd_inv;
   reg         fwd_inv_we;
   reg [13:0]  scale_sch;
   reg         scale_sch_we;

   wire        rfd;
   wire [6:0]  xn_index;
   wire        busy;
   wire        edone;
   wire        done;
   wire        dv;
   wire [6:0]  xk_index;
   wire [31:0] xk_re;
   wire [31:0] xk_im;

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

   fft128 fft128_0 (
      .clk (clk), // input clk
      .sclr (sclr), // input sclr
      .start (start), // input start
      .unload(unload), // input unload
      .xn_re (xn_re), // input [15 : 0] xn_re
      .xn_im (xn_im), // input [15 : 0] xn_im
      .fwd_inv (fwd_inv), // input fwd_inv
      .fwd_inv_we (fwd_inv_we), // input fwd_inv_we
      .scale_sch (scale_sch), // input [13 : 0] scale_sch
      .scale_sch_we (scale_sch_we), // input scale_sch_we
      .rfd (rfd), // ouput rfd
      .xn_index (xn_index), // ouput [6 : 0] xn_index
      .busy (busy), // ouput busy
      .edone (edone), // ouput edone
      .done (done), // ouput done
      .dv (dv), // ouput dv
      .xk_index (xk_index), // ouput [6 : 0] xk_index
      .xk_re (xk_re), // ouput [15 : 0] xk_re
      .xk_im (xk_im)); // ouput [15 : 0] xk_im

   /****************************************************************************
    * Generate Stimulus
    ***************************************************************************/

   initial begin

      @(posedge clk);

      // Pulse the reset signal.
      sclr = 1'b1;
      @(posedge clk);

      start = 1'b0;
      unload = 1'b0;
      fwd_inv = 1'b0;
      fwd_inv_we = 1'b0;
      scale_sch = 0;
      scale_sch_we = 1'b0;

      sclr = 1'b0;
      @(posedge clk);

      repeat (3) @(posedge clk);

      fwd_inv = 1'b1;
      fwd_inv_we = 1'b1;

      scale_sch = 0;
      scale_sch_we = 1'b0;

      @(posedge clk);

      fwd_inv_we = 1'b0;
      scale_sch_we = 1'b0;

      start = 1'b1;
      @(posedge clk);

      start = 1'b0;

      for (i = 0; i < 128; i = i+1) begin

         if (i < 5)
            xn_re = 32'h00010000;
         else
            xn_re = 0;

         xn_im = 0;

         @(posedge clk);

      end

      // Wait for the done signal to be asserted.
      while (done === 1'b0)
         @(posedge clk);

      // Pulse unload to unload the data.
      unload = 1'b1;
      @(posedge clk);

      unload = 1'b0;

      while (dv === 1'b0)
         @(posedge clk);

      for (i = 0; i < 128; i = i+1) begin

         $write("%0d, ", $signed(xk_re));
         @(posedge clk);

      end

      repeat (10) @(posedge clk);
      $finish;

   end

endmodule
