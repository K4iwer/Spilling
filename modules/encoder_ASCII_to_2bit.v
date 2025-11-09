module encoder_ASCII_to_2bit (
    input [6:0] ASCII_in,
    output [1:0] bin_out
);

assign bin_out =    (ASCII_in == 7'B011_0000) ? 2'b00 :
                    (ASCII_in == 7'B011_0001) ? 2'b01 :
                    (ASCII_in == 7'B011_0010) ? 2'b10 :
                    (ASCII_in == 7'B011_0011) ? 2'b11 :
                    2'b00;                        
endmodule