module tx_serial_7E1 (
    input clock,
    input reset,
    input partida,
    input [6:0] dados_ascii,
    output saida_serial,
    output pronto,
    output db_partida,
    output db_saida_serial,
    output [3:0] db_estado
);

    wire       s_reset        ;
    wire       s_zera         ;
    wire       s_conta        ;
    wire       s_carrega      ;
    wire       s_desloca      ;
    wire       s_tick         ;
    wire       s_fim          ;
    wire       s_saida_serial ;

	 // sinais reset e partida (ativos em alto - GPIO)
    assign s_reset   = reset;
	 
    // fluxo de dados
    tx_serial_7N1_fd U1_FD (
        .clock        ( clock          ),
        .reset        ( s_reset        ),
        .zera         ( s_zera         ),
        .conta        ( s_conta        ),
        .carrega      ( s_carrega      ),
        .desloca      ( s_desloca      ),
        .dados_ascii  ( dados_ascii    ),
        .saida_serial ( s_saida_serial ),
        .fim          ( s_fim          )
    );


    // unidade de controle
    tx_serial_uc U2_UC (
        .clock     ( clock        ),
        .reset     ( s_reset      ),
        .partida   ( partida      ),
        .tick      ( s_tick       ),
        .fim       ( s_fim        ),
        .zera      ( s_zera       ),
        .conta     ( s_conta      ),
        .carrega   ( s_carrega    ),
        .desloca   ( s_desloca    ),
        .pronto    ( pronto       ),
        .db_estado ( db_estado    )
    );

    // gerador de tick
    // fator de divisao para 9600 bauds (5208=50M/9600) 13 bits
    // fator de divisao para 115.200 bauds (434=50M/115200) 9 bits
    contador_m #(
        .M(434),               // bruh 50 MHz / 434 == 115200 
        .N(9)                  // bruh 2 ^ 9
     ) U3_TICK ( 
        .clock   ( clock  ),
        .zera_as ( 1'b0   ),
        .zera_s  ( s_zera ),
        .conta   ( 1'b1   ),
        .Q       (        ),
        .fim     ( s_tick ),
        .meio    (        )
    );


    // saida serial
    assign saida_serial = s_saida_serial;

    // depuracao
    assign db_partida      = partida;
    assign db_saida_serial = s_saida_serial;

endmodule
