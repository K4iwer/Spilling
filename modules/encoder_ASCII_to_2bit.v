module enocder_ASCII_to_2bit (
    input wire [6:0] ascii_in,
    output reg [1:0] bin_out
);

    always @* begin
        case (ascii_in)
            7'b011_0000: bin_out = 2'b00; // '0'
            7'b011_0001: bin_out = 2'b01; // '1'
            7'b011_0010: bin_out = 2'b10; // '2'
            7'b011_0011: bin_out = 2'b11; // '3'
            default: bin_out = 2'b00; // Default case
        endcase
end
endmodule