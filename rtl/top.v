//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name:  SDU Imaging system top design
// Module Name: top 
// Project Name: Spectral Doppler Ultrasound Imaging System 
//////////////////////////////////////////////////////////////////////////////////

module top (
   input wire         fast_clk,
   input wire         slow_clk,
   input wire         reset,
   input wire  [15:0] din_re_Ff,
   input wire  [15:0] din_im_Ff,
   input wire         fir_filter_nd_Ff,
   output wire        fir_filter_rfd_Ff,
   output wire        fft_done_Fs,
   input wire         fft_unload_Fs,
   output wire        fft_dv_Fs,
   output wire [31:0] dout_re_Fs,
   output wire [31:0] dout_im_Fs
);

   /****************************************************************************
    * Internal Signals
    ***************************************************************************/

   wire [31:0] fir_filter_dout_re_Ff;
   wire        fir_filter_dout_re_valid_Ff;

   wire [31:0] fir_filter_dout_im_Ff;
   wire        fir_filter_dout_im_valid_Ff;

   wire [31:0] downsampler_dout_re_Fs;
   wire [31:0] downsampler_dout_im_Fs;
   wire        downsampler_dout_valid_Fs;

   wire [31:0] hamming_window_dout_re_Fs;
   wire        hamming_window_dout_re_valid_Fs;

   wire [31:0] hamming_window_dout_im_Fs;
   wire        hamming_window_dout_im_valid_Fs;

   reg  [31:0] hamming_window_dout_re_d1_Fs;
   reg  [31:0] hamming_window_dout_im_d1_Fs;

   wire        fft_start;

   integer count;

   /****************************************************************************
    * Module Instantiations
    ***************************************************************************/

   fir_filter fir_filter_re (
      .clk        (fast_clk),
      .sclr       (reset),
      .nd         (fir_filter_nd_Ff),
      .rfd        (fir_filter_rfd_Ff),
      .rdy        (),
      .data_valid (fir_filter_dout_re_valid_Ff),
      .din        (din_re_Ff),
      .dout       (fir_filter_dout_re_Ff)
   );

   fir_filter fir_filter_im (
      .clk        (fast_clk),
      .sclr       (reset),
      .nd         (fir_filter_nd_Ff),
      .rfd        (),
      .rdy        (),
      .data_valid (fir_filter_dout_im_valid_Ff),
      .din        (din_im_Ff),
      .dout       (fir_filter_dout_im_Ff)
   );

   downsampler downsampler_0 (
      .fast_clk      (fast_clk),
      .slow_clk      (slow_clk),
      .reset         (reset),
      .din_valid_Ff  (fir_filter_dout_re_valid_Ff),
      .din_re_Ff     (fir_filter_dout_re_Ff),
      .din_im_Ff     (fir_filter_dout_im_Ff),
      .dout_valid_Fs (downsampler_dout_valid_Fs),
      .dout_re_Fs    (downsampler_dout_re_Fs),
      .dout_im_Fs    (downsampler_dout_im_Fs)
   );

   hamming_window hamming_window_re (
      .clk         (slow_clk),
      .reset       (reset),
      .in_data     (downsampler_dout_re_Fs),
      .in_valid    (downsampler_dout_valid_Fs),
      .out_data_F  (hamming_window_dout_re_Fs),
      .out_valid_F (hamming_window_dout_re_valid_Fs)
   );

   hamming_window hamming_window_im (
      .clk         (slow_clk),
      .reset       (reset),
      .in_data     (downsampler_dout_im_Fs),
      .in_valid    (downsampler_dout_valid_Fs),
      .out_data_F  (hamming_window_dout_im_Fs),
      .out_valid_F (hamming_window_dout_im_valid_Fs)
   );

   start_gen start_gen_0 (
      .fast_clk       (slow_clk),
      .reset          (reset),
      .valid_Ff       (hamming_window_dout_re_valid_Fs),
      .start          (fft_start)
   );

   fft128 fft128_0 (
      .clk          (slow_clk),
      .sclr         (reset),
      .start        (fft_start),
      .unload       (fft_unload_Fs),
      .xn_re        (hamming_window_dout_re_d1_Fs),
      .xn_im        (hamming_window_dout_im_d1_Fs),
      .fwd_inv      (0),
      .fwd_inv_we   (0),
      .scale_sch    (0),
      .scale_sch_we (0),
      .rfd          (),
      .xn_index     (),
      .busy         (),
      .edone        (),
      .done         (fft_done_Fs),
      .dv           (fft_dv_Fs),
      .xk_index     (),
      .xk_re        (dout_re_Fs),
      .xk_im        (dout_im_Fs));

   /****************************************************************************
    * Synchronous Logic
    ***************************************************************************/

   // Delay the output of the hamming_window module by one clock cycle in order
   // to meet the timing requirements of the FFT block.
   always @(posedge slow_clk) begin
      hamming_window_dout_re_d1_Fs <= hamming_window_dout_re_Fs;
      hamming_window_dout_im_d1_Fs <= hamming_window_dout_im_Fs;
   end

endmodule
