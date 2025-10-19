module roberto (
    input wire clock,
    input wire reset,
    input wire ligar,
    input wire echo1,
    input wire echo2,
    input wire echo3,
    output wire trigger1,
    output wire trigger2,
    output wire trigger3,
    output wire saida_serial,
    output wire pronto,
    output wire [2:0] estado // saída do estado para display 7 segmentos, ainda ta errado aqui
);

    wire s_zera_sensor;
    wire s_zera_serial;
    wire s_zera_seg;
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
    wire [2:0] s_db_estado; // passar por um hex

    roberto_fd FD (
        .clock         (clock           ),
        .zera_sensor   (s_zera_sensor   ),
        .zera_serial   (s_zera_serial   ),
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
        .db_medida1    (),
        .db_medida2    (),
        .db_medida3    (),
        .db_estado_ult ()
    );

    
    roberto_uc UC (
        .clock          (clock              ),
        .reset          (reset              ),
        .jogar          (s_ligar            ),
        .pronto_seg     (s_pronto_seg       ),
        .Q_2            (s_Q_2              ),
        .Q_3            (s_Q_3              ),
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
        .db_estado      (s_db_estado        )
    );


    // detetor de borda
    edge_detector edging (
        .clock ( clock        ),
        .reset ( reset        ),
        .sinal ( ~ligar       ), // botei negado pq os botões da FPGA são ativos em 0
        .pulso ( s_ligar      )
    );



endmodule