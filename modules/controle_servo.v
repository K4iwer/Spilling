module controle_servo (
 input wire clock,
 input wire reset,
 input wire [1:0] posicao,
 output wire controle,
 output wire db_controle
);

circuito_pwm #(
    .conf_periodo(1_000_000),
    .largura_000(50_000),
    .largura_001(66_666),
    .largura_010(83_333),
    .largura_011(100_000),
) my_circuito_pwm (
    .clock(clock),
    .reset(reset),
    .largura(posicao),
    .pwm(controle),
    .db_pwm(db_controle)
);

endmodule