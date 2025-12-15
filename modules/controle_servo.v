module controle_servo (
 input wire clock,
 input wire reset,
 input wire [1:0] posicao,
 output wire controle,
 output wire db_controle
);

circuito_pwm #(	
    .conf_periodo(1_000_000),
    .largura_00(35_000), // 50_000 89_444
    .largura_01(56_450), // 66_666 75_000
    .largura_10(81_000), // 83_333 62_500
    .largura_11(110_000) // 100_00 50_000
) my_circuito_pwm (
    .clock(clock),
    .reset(reset),
    .largura(posicao),
    .pwm(controle),
    .db_pwm(db_controle)
);

endmodule