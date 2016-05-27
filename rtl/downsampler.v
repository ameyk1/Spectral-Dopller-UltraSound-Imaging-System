//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name:  SDU Imaging system design
// Module Name: downsampler
// Project Name: Spectral Doppler Ultrasound Imaging System 
//////////////////////////////////////////////////////////////////////////////////

module downsampler (
   input wire        fast_clk,
   input wire        slow_clk,
   input wire        reset,
   input wire        din_valid_Ff,
   input wire [31:0] din_re_Ff,
   input wire [31:0] din_im_Ff,
   output reg        dout_valid_Fs,
   output reg [31:0] dout_re_Fs,
   output reg [31:0] dout_im_Fs
);

   /****************************************************************************
    * Internal Signals
    ***************************************************************************/

   reg [2:0]  count_Ff;

   reg        din_valid_captured_Ff;
   reg [31:0] din_re_captured_Ff;
   reg [31:0] din_im_captured_Ff;

   /****************************************************************************
    * Synchronous Logic
    ***************************************************************************/

   always @(posedge fast_clk) begin

      if (reset == 1'b1) begin
         count_Ff <= 0;
      end

      else begin

         if (din_valid_Ff == 1'b1) begin
            if (count_Ff == 6)
               count_Ff <= 0;
            else
               count_Ff <= count_Ff + 1;
         end

      end // else: !if(reset == 1'b1)

   end // always @ (posedge fast_clk)

   always @(posedge fast_clk) begin

      if (reset == 1'b1) begin
         din_valid_captured_Ff <= 1'b0;
      end

      else begin

         if (count_Ff == 0) begin
            din_valid_captured_Ff <= din_valid_Ff;
            din_re_captured_Ff <= din_re_Ff;
            din_im_captured_Ff <= din_im_Ff;
         end

      end

   end // always @ (posedge fast_clk)

   always @(posedge slow_clk) begin

      dout_valid_Fs <= din_valid_captured_Ff;
      dout_re_Fs <= din_re_captured_Ff;
      dout_im_Fs <= din_im_captured_Ff;

   end // always @ (posedge slow_clk)

endmodule
