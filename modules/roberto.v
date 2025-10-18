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
    output wire pronto
);

    wire s_zera_sensor;
    wire s_zera_serial;
    wire s_zera_seg;
    wire s_zera_2;
    wire s_cont_seg;
    wire s_cont_2;
    wire s_medir;
    wire s_zera_sensor;
    wire [1:0] s_sel_sensor1;
    wire [1:0] s_sel_sensor2;
    wire [1:0] s_sel_sensor3;
    wire s_partida_tx;
    wire s_pronto_medida1;
    wire s_pronto_medida2;
    wire s_pronto_medida3;
    wire s_ligar;
    wire s_pronto_serial;
    wire s_pronto_seg;
    wire s_pronto_2;

    roberto_fd FD (
        .clock         (clock),
        .zera_sensor   (s_zera_sensor),
        .zera_serial   (s_zera_serial),
        .zera_seg      (s_zera_seg),
        .zera_2        (s_zera_2),
        .cont_seg      (s_cont_seg),
        .cont_2        (s_cont_2),
        .medir         (s_medir),
        .echo1         (echo1),
        .echo2         (echo2),
        .echo3         (echo3),
        .sel_sens1     (s_sel_sensor1),
        .sel_sens2     (s_sel_sensor2),
        .sel_sens3     (s_sel_sensor3),
        .partida_tx    (s_partida_tx),
        .trigger1      (trigger1),
        .trigger2      (trigger2),
        .trigger3      (trigger3),
        .pronto_medida1(s_pronto_medida1),
        .pronto_medida2(s_pronto_medida2),
        .pronto_medida3(s_pronto_medida3),
        .saida_serial  (saida_serial),
        .pronto_serial (s_pronto_serial),
        .pronto_seg    (s_pronto_seg),
        .pronto_2      (s_pronto_2),
        .db_medida1    (),
        .db_medida2    (),
        .db_medida3    (),
        .db_estado_ult ()
    );

    module roberto_uc (
        .clock         (),
        .reset         (),
        .pronto_medida1(),
        .pronto_medida2(),
        .pronto_medida3(),   
        .pronto        (pronto),
    );

    // detetor de borda
    edge_detector edging (
        .clock ( clock        ),
        .reset ( reset        ),
        .sinal ( ~ligar       ), // botei negado pq os botões da FPGA são ativos em 0
        .pulso ( s_ligar      )
    );



endmodule