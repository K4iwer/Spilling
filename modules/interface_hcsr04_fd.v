/* --------------------------------------------------------------------------
 *  Arquivo   : interface_hcsr04_fd-PARCIAL.v
 * --------------------------------------------------------------------------
 *  Descricao : CODIGO PARCIAL DO fluxo de dados do circuito de interface  
 *              com sensor ultrassonico de distancia
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */
 
module interface_hcsr04_fd (
    input wire         clock,
    input wire         pulso,
    input wire         zera,
    input wire         gera,
    input wire         registra,
    output wire        fim_medida,
    output wire        trigger,
    output wire        fim,
    output wire [11:0] distancia
);

    // Sinais internos
    wire [11:0] s_medida;

    // (U1) pulso de 10us (500 clocks) => 0,00001 ÷ 0,00000002 (1 clock)
    gerador_pulso #(
        .largura(500) // bruh 
    ) U1 (
        .clock ( clock   ),
        .reset ( zera    ),    // bruh
        .gera  ( gera    ),    // bruh
        .para  ( 1'b0    ),    // bruh 1'h0?
        .pulso ( trigger ),    // bruh
        .pronto(         )     // bruh aberto
    );

    // (U2) medida em cm (R=2941 clocks)
    contador_cm #(
        .R(2941), 
        .N(12)
    ) U2 (
        .clock  (clock         ),
        .reset  (zera          ), // bruh
        .pulso  (pulso         ), // bruh
        .digito2(s_medida[11:8]),
        .digito1(s_medida[7:4] ),
        .digito0(s_medida[3:0] ),
        .fim    (fim           ), // bruh
        .pronto (fim_medida    )  // bruh
    );

    // (U3) registrador
    registrador_n #(
        .N(12)
    ) U3 (
        .clock  (clock    ), 
        .clear  (zera     ), // bruh
        .enable (registra ), // bruh
        .D      (s_medida ),
        .Q      (distancia)  // bruh
    );

endmodule
