/* -------------------------------------------------------------
 * Arquivo   : hexa7seg.v
 *--------------------------------------------------------------
 * Descricao : decodificador hexadecimal para 
 *             display de 7 segmentos 
 * 
 * entrada : hexa - codigo binario de 4 bits hexadecimal
 * saida   : sseg - codigo de 7 bits para display de 7 segmentos
 *
 * baseado no componente bcd7seg.v da Intel FPGA
 *--------------------------------------------------------------
 * dica de uso: mapeamento para displays da placa DE0-CV
 *              bit 6 mais significativo é o bit a esquerda
 *              p.ex. sseg(6) -> HEX0[6] ou HEX06
 *--------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     24/12/2023  1.0     Edson Midorikawa  criacao
 *--------------------------------------------------------------
 */

module hexa7seg_ASC (hexa, display);
    input      [6:0] hexa;
    output reg [6:0] display;

    /*
     *    ---
     *   | 0 |
     * 5 |   | 1
     *   |   |
     *    ---
     *   | 6 |
     * 4 |   | 2
     *   |   |
     *    ---
     *     3
     */
        
    always @(hexa)
    case (hexa)
        7'b011_0000:    display = 7'b1000000; // 0
        7'b011_0001:    display = 7'b1111001; // 1
        7'b011_0010:    display = 7'b0100100; // 2
        7'b011_0011:    display = 7'b0110000; // 3
        7'b011_0100:    display = 7'b0011001; // 4
        7'b011_0101:    display = 7'b0010010; // 5
        7'b011_0110:    display = 7'b0000010; // 6
        7'b011_0111:    display = 7'b1111000; // 7
        7'b011_1000:    display = 7'b0000000; // 8
        7'b011_1001:    display = 7'b0010000; // 9
        7'b011_1111:    display = 7'b0001110; // F, indica erro
        default: display = 7'b1111111;
    endcase
endmodule
