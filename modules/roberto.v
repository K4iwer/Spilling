module roberto (
    input wire clock,
    input wire reset,
    input wire ligar,
    input wire echo1,
    input wire echo2,
    input wire echo3,
    input wire sel_med1,
    input wire sel_med2,
    input wire sel_med_or_rx,
    input wire RX,
    output wire trigger1,
    output wire trigger2,
    output wire trigger3,
    output wire saida_serial,
    output wire pronto,
    output wire [6:0] db_estado,
    // output wire [6:0] db_ult,
    output wire [6:0] db_hex1,
    output wire [6:0] db_hex2,
    output wire [6:0] db_hex3
);

    wire s_zera_sensor;
    wire s_zera_serial;
    wire s_zera_seg;
    wire s_zera_recepcao;
    wire s_cont_2;
    wire [1:0] s_Q_2;
    wire s_zera_2;
    wire s_cont_3;
    wire [1:0] s_Q_3;
    wire s_zera_3;
    wire s_cont_seg;
    wire s_medir;
    wire s_partida_tx;
    wire s_ligar;
    wire s_pronto_serial;
    wire s_pronto_seg;
    wire [3:0]  s_db_estado; // passar por um hex
    wire [3:0]  s_db_ult;    // passar por um hex
    wire [11:0] s_db_medida_out; 
    wire [11:0] s_db_medida1; 
    wire [11:0] s_db_medida2; 
    wire [11:0] s_db_medida3;
    wire [6:0] db_medida1,
    wire [6:0] db_medida2,
    wire [6:0] db_medida3
    wire [6:0] s_db_entrada_serial_1;
    wire [6:0] s_db_entrada_serial_2;
    wire [6:0] s_db_entrada_serial_3;
    wire [6:0] s_dado_recebido_1;
    wire [6:0] s_dado_recebido_2;
    wire [6:0] s_dado_recebido_3;
    wire [6:0]  s_recpcao_serial;
    wire        s_pronto_recepcao;
    wire [1:0]  s_Q_recepcao; 
    wire        s_cont_recepcao;

    roberto_fd FD (
        .clock         (clock           ),
        .zera_sensor   (s_zera_sensor   ),
        .zera_serial   (s_zera_serial   ),
        .zera_recpcao  (s_zera_recpcao  ),
        .cont_seg      (s_cont_seg      ),
        .zera_seg      (s_zera_seg      ),
        .cont_2        (s_cont_2        ),
        .Q_2           (s_Q_2           ),
        .zera_2        (s_zera_2        ),
        .Q_3           (s_Q_3           ),
        .cont_3        (s_cont_3        ),
        .zera_3        (s_zera_3        ),
        .medir         (s_medir         ),
        .echo1         (echo1           ),
        .echo2         (echo2           ),
        .echo3         (echo3           ),
        .partida_tx    (s_partida_tx    ),
        .trigger1      (trigger1        ),
        .trigger2      (trigger2        ),
        .trigger3      (trigger3        ),
        .saida_serial  (saida_serial    ),
        .pronto_serial (s_pronto_serial ),
        .pronto_seg    (s_pronto_seg    ),
        .RX            (RX              ),
        .recepcao_serial(s_recpcao_serial ),
        .Q_recepcao    (s_Q_recepcao    ),
        .pronto_recepcao(s_pronto_recepcao ),
        .cont_recepcao (s_cont_recepcao ),
        .db_medida1    (s_db_medida1    ),
        .db_medida2    (s_db_medida2    ),
        .db_medida3    (s_db_medida3    )
        // .db_estado_ult (s_db_ult        )
    );

    
    roberto_uc UC (
        .clock          (clock              ),
        .reset          (reset              ),
        .jogar          (s_ligar            ),
        .pronto_seg     (s_pronto_seg       ),
        .Q_2            (s_Q_2              ),
        .Q_3            (s_Q_3              ),
        .Q_recepcao     (s_Q_recepcao       ),
        .pronto_recepcao (s_pronto_recepcao  ),
        .cont_recepcao  (s_cont_recepcao    ),
        .pronto_serial  (s_pronto_serial    ),
        .cont_2         (s_cont_2           ),
        .cont_3         (s_cont_3           ),
        .zera_2         (s_zera_2           ),
        .zera_3         (s_zera_3           ),
        .partida_tx     (s_partida_tx       ),
        .medir          (s_medir            ),
        .zera_sensor    (s_zera_sensor      ),
        .zera_serial    (s_zera_serial      ),
        .zera_seg       (s_zera_seg         ),
        .cont_seg       (s_cont_seg         ),
        .pronto         (pronto             ),
        .dado_recebido_1(s_dado_recebido_1  ),
        .dado_recebido_2(s_dado_recebido_2  ),
        .dado_recebido_3(s_dado_recebido_3  ),
        .db_estado      (s_db_estado        )
    );


    // detetor de borda
    edge_detector edging (
        .clock ( clock        ),
        .reset ( reset        ),
        .sinal ( ~ligar       ), // botei negado pq os botões da FPGA são ativos em 0
        .pulso ( s_ligar      )
    );

    // hexa estado UC
    hexa7seg HEX_EST ( 
        .hexa    ( s_db_estado ), 
        .display ( db_estado   )
    );

    // // hexa estado ultrassom
    // hexa7seg HEX_ULT ( 
    //     .hexa    ( s_db_ult ), 
    //     .display ( db_ult   )
    // );

    // hexa medida1
    hexa7seg HEX_Medida1 ( 
        .hexa    ( s_db_medida_out[11:8] ), 
        .display ( db_medida1        )
    );

    // hexa medida2
    hexa7seg HEX_Medida2 ( 
        .hexa    ( s_db_medida_out[7:4] ), 
        .display ( db_medida2       )
    );

    // hexa medida3
    hexa7seg HEX_Medida3 ( 
        .hexa    ( s_db_medida_out[3:0] ), 
        .display ( db_medida3       )
    );

    // hexa recepcao serial 1
    hexa7seg_ASC HEX_serial_1 ( 
        .hexa    ( s_dado_recebido_1 ), 
        .display ( db_entrada_serial_1)
    );

    // hexa recepcao serial 2
    hexa7seg_ASC HEX_serial_2 ( 
        .hexa    ( s_dado_recebido_2 ), 
        .display ( db_entrada_serial_2)
    );

    // hexa recepcao serial 3
    hexa7seg_ASC HEX_serial_3 ( 
        .hexa    ( s_dado_recebido_3 ), 
        .display ( db_entrada_serial_3)
    );

    // mux serial
    mux_4x1_n #(
        .BITS(12)
    ) MUL_serial (
        .D3     (12'b000000000000    ),
        .D2     (s_db_medida3        ), 
        .D1     (s_db_medida2        ),
        .D0     (s_db_medida1        ),
        .SEL    ({sel_med2,sel_med1} ),
        .MUX_OUT(s_db_medida_out     )
    );

    assign db_hex1 = sel_med_or_rx ? db_medida1 : db_entrada_serial_1;
    assign db_hex2 = sel_med_or_rx ? db_medida2 : db_entrada_serial_2;
    assign db_hex3 = sel_med_or_rx ? db_medida3 : db_entrada_serial_3;

endmodule