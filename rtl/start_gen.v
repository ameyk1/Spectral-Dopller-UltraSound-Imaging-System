//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name: SDU Imaging system design
// Module Name: start_gen
// Project Name: Spectral Doppler Ultrasound Imaging System 
//////////////////////////////////////////////////////////////////////////////////
module start_gen (
   input  wire fast_clk,
   input  wire reset,
   input  wire valid_Ff,
   output wire start
);

   /****************************************************************************
    * Internal Signals
    ***************************************************************************/

   reg valid_d1_Ff;

   /****************************************************************************
    * Continuous Assignments
    ***************************************************************************/

   assign start = valid_Ff && !valid_d1_Ff;

   /****************************************************************************
    * Synchronous Logic
    ***************************************************************************/

   always @(posedge fast_clk) begin

      if (reset == 1'b1) begin
         valid_d1_Ff <= 1'b0;
      end

      else begin
         valid_d1_Ff <= valid_Ff;
      end

   end

endmodule
