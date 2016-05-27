//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name:  SDU Imaging system design
// Module Name: hamming_coeff_lut
// Project Name: Spectral Doppler Ultrasound Imaging System 
//////////////////////////////////////////////////////////////////////////////////
module hamming_coeff_lut (
   input wire [6:0] addr,
   output reg [15:0] coeff
);

   always @(*) begin
      case(addr)
         7'd0: coeff = 5243;
         7'd1: coeff = 5280;
         7'd2: coeff = 5390;
         7'd3: coeff = 5574;
         7'd4: coeff = 5831;
         7'd5: coeff = 6161;
         7'd6: coeff = 6561;
         7'd7: coeff = 7033;
         7'd8: coeff = 7573;
         7'd9: coeff = 8182;
         7'd10: coeff = 8858;
         7'd11: coeff = 9598;
         7'd12: coeff = 10401;
         7'd13: coeff = 11266;
         7'd14: coeff = 12190;
         7'd15: coeff = 13170;
         7'd16: coeff = 14205;
         7'd17: coeff = 15291;
         7'd18: coeff = 16427;
         7'd19: coeff = 17609;
         7'd20: coeff = 18835;
         7'd21: coeff = 20101;
         7'd22: coeff = 21405;
         7'd23: coeff = 22743;
         7'd24: coeff = 24112;
         7'd25: coeff = 25508;
         7'd26: coeff = 26929;
         7'd27: coeff = 28370;
         7'd28: coeff = 29828;
         7'd29: coeff = 31301;
         7'd30: coeff = 32783;
         7'd31: coeff = 34271;
         7'd32: coeff = 35762;
         7'd33: coeff = 37253;
         7'd34: coeff = 38738;
         7'd35: coeff = 40216;
         7'd36: coeff = 41682;
         7'd37: coeff = 43132;
         7'd38: coeff = 44563;
         7'd39: coeff = 45972;
         7'd40: coeff = 47355;
         7'd41: coeff = 48709;
         7'd42: coeff = 50030;
         7'd43: coeff = 51315;
         7'd44: coeff = 52562;
         7'd45: coeff = 53766;
         7'd46: coeff = 54926;
         7'd47: coeff = 56037;
         7'd48: coeff = 57098;
         7'd49: coeff = 58106;
         7'd50: coeff = 59058;
         7'd51: coeff = 59953;
         7'd52: coeff = 60787;
         7'd53: coeff = 61559;
         7'd54: coeff = 62267;
         7'd55: coeff = 62909;
         7'd56: coeff = 63484;
         7'd57: coeff = 63991;
         7'd58: coeff = 64427;
         7'd59: coeff = 64792;
         7'd60: coeff = 65085;
         7'd61: coeff = 65306;
         7'd62: coeff = 65453;
         7'd63: coeff = 65527;
         7'd64: coeff = 65527;
         7'd65: coeff = 65453;
         7'd66: coeff = 65306;
         7'd67: coeff = 65085;
         7'd68: coeff = 64792;
         7'd69: coeff = 64427;
         7'd70: coeff = 63991;
         7'd71: coeff = 63484;
         7'd72: coeff = 62909;
         7'd73: coeff = 62267;
         7'd74: coeff = 61559;
         7'd75: coeff = 60787;
         7'd76: coeff = 59953;
         7'd77: coeff = 59058;
         7'd78: coeff = 58106;
         7'd79: coeff = 57098;
         7'd80: coeff = 56037;
         7'd81: coeff = 54926;
         7'd82: coeff = 53766;
         7'd83: coeff = 52562;
         7'd84: coeff = 51315;
         7'd85: coeff = 50030;
         7'd86: coeff = 48709;
         7'd87: coeff = 47355;
         7'd88: coeff = 45972;
         7'd89: coeff = 44563;
         7'd90: coeff = 43132;
         7'd91: coeff = 41682;
         7'd92: coeff = 40216;
         7'd93: coeff = 38738;
         7'd94: coeff = 37253;
         7'd95: coeff = 35762;
         7'd96: coeff = 34271;
         7'd97: coeff = 32783;
         7'd98: coeff = 31301;
         7'd99: coeff = 29828;
         7'd100: coeff = 28370;
         7'd101: coeff = 26929;
         7'd102: coeff = 25508;
         7'd103: coeff = 24112;
         7'd104: coeff = 22743;
         7'd105: coeff = 21405;
         7'd106: coeff = 20101;
         7'd107: coeff = 18835;
         7'd108: coeff = 17609;
         7'd109: coeff = 16427;
         7'd110: coeff = 15291;
         7'd111: coeff = 14205;
         7'd112: coeff = 13170;
         7'd113: coeff = 12190;
         7'd114: coeff = 11266;
         7'd115: coeff = 10401;
         7'd116: coeff = 9598;
         7'd117: coeff = 8858;
         7'd118: coeff = 8182;
         7'd119: coeff = 7573;
         7'd120: coeff = 7033;
         7'd121: coeff = 6561;
         7'd122: coeff = 6161;
         7'd123: coeff = 5831;
         7'd124: coeff = 5574;
         7'd125: coeff = 5390;
         7'd126: coeff = 5280;
         7'd127: coeff = 5243;
      endcase

   end

endmodule
