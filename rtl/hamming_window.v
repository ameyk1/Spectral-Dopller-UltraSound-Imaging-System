//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name:  SDU Imaging system design
// Module Name: hamming_window
// Project Name: Spectral Doppler Ultrasound Imaging System 
//////////////////////////////////////////////////////////////////////////////////

module hamming_window (
   input wire               clk,
   input wire               reset,
   input wire signed [31:0] in_data,
   input wire               in_valid,
   output reg signed [31:0] out_data_F,
   output reg               out_valid_F
);

   /****************************************************************************
    * Internal Signals
    ***************************************************************************/

   // The current index into the coefficient LUT.
   reg [6:0] addr_F;

   // The output from the coefficient LUT.
   wire [15:0] coeff;

   // The product of the input data and the coefficient.
   reg signed [47:0] product;

   /****************************************************************************
    * Module Instantiations
    ***************************************************************************/

   hamming_coeff_lut lut (
      .addr (addr_F),
      .coeff (coeff)
   );

   /****************************************************************************
    * Asynchronous Logic
    ***************************************************************************/

   always @(*) begin
      product = in_data * $signed({1'b0, coeff});
   end

   /****************************************************************************
    * Synchronous Logic
    ***************************************************************************/

   always @(posedge clk) begin

      if (reset) begin
         addr_F <= 0;
         out_data_F <= 0;
         out_valid_F <= 1'b0;
      end

      else begin

         if (in_valid) begin
            addr_F <= addr_F + 1'b1;
            out_data_F <= $signed(product) >>> 16;
            out_valid_F <= 1'b1;
         end

         else begin
            addr_F <= addr_F;
            out_data_F <= out_data_F;
            out_valid_F <= 1'b0;
         end

      end

   end

endmodule
