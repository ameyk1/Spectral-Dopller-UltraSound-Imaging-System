`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name:  SDU Imaging system testbench
// Module Name: fir_filter_tb 
// Project Name: Spectral Doppler Ultrasound Imaging System 
//////////////////////////////////////////////////////////////////////////////////
module fir_filter_tb;

   /****************************************************************************
    * Internal Signals
    ***************************************************************************/

   reg         clk;
   reg         sclr;

   wire        rfd;
   reg         nd;
   wire        rdy;
   wire        data_valid;
   reg         data_valid_F;
   reg         data_valid_F_d2;

   reg  [15:0] din;
   wire [31:0] dout;

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

   fir_filter fir_filter_0 (
      .clk  (clk),
      .sclr (sclr),
      .nd   (nd),
      .rfd  (rfd),
      .rdy  (rdy),
      .data_valid (data_valid),
      .din  (din),
      .dout (dout)
   );

   /****************************************************************************
    * Generate Stimulus
    ***************************************************************************/

   initial begin

      @(posedge clk);

      // Pulse the reset signal.
      sclr = 1'b1;
      @(posedge clk);

      nd = 1'b0;
      din = 0;

      sclr = 1'b0;
      @(posedge clk);

      // The output data vector is not valid until the core has received the
      // same number of input data samples as the filter has coefficients.
      // Initialize the filter.
      for (i = 0; i < 107; i = i+1) begin
         din = 0;
         nd = 1'b1;
         @(posedge clk);
      end

      // Now send in the real data.
      for (i = 0; i < 128; i = i+1) begin
         din = (i == 1)? 1 : 0;
         nd = 1'b1;
         @(posedge clk);
      end

      // Flush out the rest of the answer.
      for (i = 0; i < 43; i = i+1) begin
         din = 0;
         nd = 1'b1;
         @(posedge clk);
      end

      nd = 1'b0;
      repeat (20) @(posedge clk);

      $finish;

   end

   /****************************************************************************
    * Synchronous Logic
    ***************************************************************************/

   always @(posedge clk) begin

      data_valid_F <= data_valid;
      data_valid_F_d2 <= data_valid_F;

      if (data_valid_F_d2 === 1'b1) begin
         $write("%0d, ", $signed(dout));
      end

   end

endmodule
