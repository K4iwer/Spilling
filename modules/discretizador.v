module discretizador #(
    parameter N = 12  // número de bits da entrada do sensor
) (
    input  wire            clk,
    input  wire            reset,
    input  wire            load,        // carrega novo valor quando = 1
    input  wire [N-1:0]    bits_in,     // exemplo: 001100010100
    output reg  [1:0]      saida        // saída discretizada registrada
);

    // valor convertido (wire para lógica combinacional)
    wire [15:0] valor_int;
    assign valor_int = bits_in;  // conversão automática de binário para inteiro

    // lógica combinacional da discretização
    reg [1:0] saida_calc;
    always @(*) begin
        if (valor_int <= 8)
            saida_calc = 2'b00;      // categoria 1
        else if (valor_int <= 16)
            saida_calc = 2'b01;      // categoria 2
        else if (valor_int <= 24)
            saida_calc = 2'b10;      // categoria 3
        else
            saida_calc = 2'b11;      // categoria 4
    end

    // registrador da saída
    always @(posedge clk or posedge reset) begin
        if (reset)
            saida <= 2'b00;  // Zera para categoria 1 (ou 2’b00, ajustável)
        else if (load)
            saida <= saida_calc;  // atualiza somente quando load = 1
    end

endmodule
