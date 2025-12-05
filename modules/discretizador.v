module discretizador #(
    parameter N = 12  // 3 dígitos BCD: centenas, dezenas, unidades
) (
    input  wire        clk,
    input  wire        reset,
    input  wire        load,        // atualiza a saída quando = 1
    input  wire [11:0] bits_in,     // [centena][dezena][unidade]
    output reg  [1:0]  saida        // saída discretizada registrada
);

    // Separação dos três dígitos BCD (cada um com 4 bits)
    wire [3:0] centena  = bits_in[11:8];
    wire [3:0] dezena   = bits_in[7:4];
    wire [3:0] unidade  = bits_in[3:0];

    // Conversão BCD → inteiro (decimal)
    wire [15:0] valor_int;
    assign valor_int = centena * 100 + dezena * 10 + unidade;

    // Discretização combinacional
    reg [1:0] saida_calc;
    always @(*) begin
        if (valor_int <= 8)
            saida_calc = 2'b00;        // categoria 1
        else if (valor_int <= 16)
            saida_calc = 2'b01;        // categoria 2
        else if (valor_int <= 24)
            saida_calc = 2'b10;        // categoria 3
        else
            saida_calc = 2'b11;        // categoria 4
    end

    // Registrador de saída
    always @(posedge clk or posedge reset) begin
        if (reset)
            saida <= 2'b00;
        else if (load)
            saida <= saida_calc;       // atualiza somente quando load = 1
    end

endmodule
