module roberto_fd (
    input  wire clock,
    input  wire zera_sensor,
    input  wire zera_serial,
    input  wire zera_recpcao,
    input  wire zera_seg,
    input  wire zera_2,
    input  wire zera_servos,
    input  wire cont_seg,
    input  wire cont_2,
    input  wire medir, 
    input  wire echo1,  
    input  wire echo2,  
    input  wire echo3,  
    input  wire partida_tx,
    input  wire zera_3,
    input  wire cont_3,
    input  wire RX,
    input  wire cont_recepcao,
    input  wire carrega_reg_1,
    input  wire carrega_reg_1,
    input  wire carrega_reg_1,
    output wire [6:0] recepcao_serial, // mudar pra saída do mux
    output wire pronto_recepcao,  
    output wire [1:0] Q_3,
    output wire trigger1, 
    output wire trigger2, 
    output wire trigger3,  
    output wire saida_serial, 
    output wire pronto_serial, 
    output wire pronto_seg, 
    output wire [1:0] Q_2,
    output wire [1:0] Q_recepcao,
    output wire [6:0] db_dado_recebido_1,
    output wire [6:0] db_dado_recebido_2,
    output wire [6:0] db_dado_recebido_3,
    output wire PWM1,
    output wire PWM2,
    output wire PWM3,
    output wire [11:0] db_medida1,
    output wire [11:0] db_medida2,
    output wire [11:0] db_medida3
    // output wire [3:0] db_estado_ult
);

    // Sinais internos
    wire [11:0] s_medida1;
    wire [11:0] s_medida2;
    wire [11:0] s_medida3;
    wire [6:0]  s_medidas_asc_1;
    wire [6:0]  s_medidas_asc_2;
    wire [6:0]  s_medidas_asc_3;
    wire [6:0]  s_entr_serial;
    wire [1:0]  s_Q_2;
    wire [1:0]  s_Q_3;
    wire [1:0] s_posicao_servo_1;
    wire [1:0] s_posicao_servo_2;
    wire [1:0] s_posicao_servo_3;
    wire [1:0] s_Q_recepcao;
    wire [6:0] s_dado_recebido_1;
    wire [6:0] s_dado_recebido_2;
    wire [6:0] s_dado_recebido_3;

    /******************* Medição da distância **********************/ 

    // Sensor ultrassônico 1
    interface_hcsr04 SENSOR_ULTRASSOM_1 (
        .clock    (clock         ),
        .reset    (zera_sensor   ),
        .medir    (medir         ),
        .echo     (echo1         ),
        .trigger  (trigger1      ),
        .medida   (s_medida1     ),
        .pronto   (              ),
        .db_medir (              ),
        .db_reset (              ),
        .db_estado( )
    );

    // mux sensor 1
    mux_4x1_n #(
        .BITS(7)
    ) MUL_sens1 (
        .D3     (7'b0100011),  // para converter para asc, precisa colocar 011 antes do valor
        .D2     ({3'b011, s_medida1[3:0]}   ), 
        .D1     ({3'b011, s_medida1[7:4]}   ),
        .D0     ({3'b011, s_medida1[11:8]}  ),  // #
        .SEL    (s_Q_3                      ),
        .MUX_OUT(s_medidas_asc_1            )
    );

    // Sensor ultrassônico 2
    interface_hcsr04 SENSOR_ULTRASSOM_2 (
        .clock    (clock         ),
        .reset    (zera_sensor   ),
        .medir    (medir         ),
        .echo     (echo2         ),
        .trigger  (trigger2      ),
        .medida   (s_medida2     ),
        .pronto   (              ),
        .db_medir (              ),
        .db_reset (              ),
        .db_estado( )
    );

    // mux sensor 2
    mux_4x1_n #(
        .BITS(7)
    ) MUL_sens2 (
        .D3     (7'b0100011                 ),  // para converter para asc, precisa colocar 011 antes do valor
        .D2     ({3'b011, s_medida2[3:0]}   ), 
        .D1     ({3'b011, s_medida2[7:4]}   ),
        .D0     ({3'b011, s_medida2[11:8]}  ),  // #
        .SEL    (s_Q_3                      ),
        .MUX_OUT(s_medidas_asc_2            )
    );

    // Sensor ultrassônico 3
    interface_hcsr04 SENSOR_ULTRASSOM_3 (
        .clock    (clock         ),
        .reset    (zera_sensor   ),
        .medir    (medir         ),
        .echo     (echo3         ),
        .trigger  (trigger3      ),
        .medida   (s_medida3     ),
        .pronto   (              ),
        .db_medir (              ),
        .db_reset (              ),
        .db_estado( )
    );

    // mux sensor 3
    mux_4x1_n #(
        .BITS(7)
    ) MUL_sens3 (
        .D3     (7'b0100011                 ),  // para converter para asc, precisa colocar 011 antes do valor
        .D2     ({3'b011, s_medida3[3:0]}   ), 
        .D1     ({3'b011, s_medida3[7:4]}   ),
        .D0     ({3'b011, s_medida3[11:8]}  ),  // #
        .SEL    (s_Q_3                      ),
        .MUX_OUT(s_medidas_asc_3            )
    );


    /******************* Transmissão Serial **********************/ 

    // mux serial
    mux_4x1_n #(
        .BITS(7)
    ) MUL_serial (
        .D3     (7'b0000000         ),
        .D2     (s_medidas_asc_3    ), 
        .D1     (s_medidas_asc_2    ),
        .D0     (s_medidas_asc_1    ),
        .SEL    (s_Q_2              ),
        .MUX_OUT(s_entr_serial      )
    );

    // Saída serial
    tx_serial_7E1 SERIAL(
        .clock          (clock        ),
        .reset          (zera_serial  ),
        .partida        (partida_tx   ),
        .dados_ascii    (s_entr_serial),
        .saida_serial   (saida_serial ),
        .pronto         (pronto_serial),
        .db_partida     (             ),
        .db_saida_serial(             ),
        .db_estado      (             )
    );

    /**************** Recepção Serial **********************/

    // Receptor serial 7E1
    rx_serial_7E1 RECEPCAO_SERIAL (
        .clock       (clock             ),
        .reset       (zera_recpcao      ),
        .RX          (RX                ),
        .dados_ascii (recepcao_serial    ), // não usado
        .pronto      (pronto_recepcao   ), // não usado
        .db_dados    (             ), // não usado
        .db_estado   (             )  // não usado
    );

    /******************* Registradores **********************/

    // Reg de recepção serial 1
    registrador_n #(
        .N(7)
    ) recepcao_serial_1 (
        .clock   ( clock              ),
        .clear   ( zera_recpcao       ),
        .enable  ( carrega_reg_1      ),
        .D       ( recepcao_serial     ),
        .Q       ( s_dado_recebido_1    )
    );

    // Reg de recepção serial 2
    registrador_n #(
        .N(7)
    ) recepcao_serial_2 (
        .clock   ( clock              ),
        .clear   ( zera_recpcao       ),
        .enable  ( carrega_reg_2      ),
        .D       ( recepcao_serial     ),
        .Q       ( s_dado_recebido_2    )
    );

    // Reg de recepção serial 3
    registrador_n #(
        .N(7)
    ) recepcao_serial_3 (
        .clock   ( clock              ),
        .clear   ( zera_recpcao       ),
        .enable  ( carrega_reg_3      ),
        .D       ( recepcao_serial     ),
        .Q       ( s_dado_recebido_3    )
    );

    /******************* Contadores **********************/ 
    // Contador até 3 pra recepção serial
    contador_m #(
        .M(4),
        .N(2)
    ) contador_ate_3_recepcao (
        .clock  (clock          ),
        .zera_as(               ),
        .zera_s (zera_recpcao   ),
        .conta  (cont_recepcao  ),
        .Q      (s_Q_recepcao   ), 
        .fim    (               ),
        .meio   (               )
    );
    
    // Contador de 1 segundo
    contador_m #(
        .M(1_000_000),  // 50_000_000
        .N(20)           // 26
    ) contador_segundos (
        .clock  (clock     ),
        .zera_as(          ),
        .zera_s (zera_seg  ),
        .conta  (cont_seg  ),
        .Q      (          ), 
        .fim    (pronto_seg),
        .meio   (          )
    );

    // Contador até 2 
    contador_m #(
        .M(3),
        .N(2)
    ) contador_ate_2 (
        .clock  (clock     ),
        .zera_as(          ),
        .zera_s (zera_2    ),
        .conta  (cont_2    ),
        .Q      (s_Q_2     ), 
        .fim    (          ),
        .meio   (          )
    );

    // Contador até 3
    contador_m #(
        .M(4),
        .N(2)
    ) contador_ate_3 (
        .clock  (clock     ),
        .zera_as(          ),
        .zera_s (zera_3    ),
        .conta  (cont_3    ),
        .Q      (s_Q_3     ), 
        .fim    (          ),
        .meio   (          )
    );

    /******************* Encoders **********************/ 

    encoder_ASCII_to_2bit encoder_para_motor_1 (
        .ASCII_in(s_dado_recebido_1),
        .bin_out (s_posicao_servo_1)
    );

    encoder_ASCII_to_2bit encoder_para_motor_2 (
        .ASCII_in(s_dado_recebido_2),
        .bin_out (s_posicao_servo_2)
    );

    encoder_ASCII_to_2bit encoder_para_motor_3 (
        .ASCII_in(s_dado_recebido_3),
        .bin_out (s_posicao_servo_3)
    );

    /******************* Controlares de motor **********************/ 

    controle_servo motor_1 (
        .clock      (clock),
        .reset      (zera_servos),
        .posicao    (s_posicao_servo_1),
        .controle   (PWM1),
        .db_controle()
    );

    controle_servo motor_2 (
            .clock      (clock),
            .reset      (zera_servos),
            .posicao    (s_posicao_servo_2),
            .controle   (PWM2),
            .db_controle()
        );
    
    controle_servo motor_3 (
            .clock      (clock),
            .reset      (zera_servos),
            .posicao    (s_posicao_servo_3),
            .controle   (PWM3),
            .db_controle()
        );
    assign Q_2 = s_Q_2;
    assign Q_3 = s_Q_3;
    assign Q_recepcao = s_Q_recepcao;
    // assign carrega_reg_1 = pronto_recepcao & (s_Q_recepcao == 2'b00);
    // assign carrega_reg_2 = pronto_recepcao & (s_Q_recepcao == 2'b01);
    // assign carrega_reg_3 = pronto_recepcao & (s_Q_recepcao == 2'b10);
    assign db_medida1 = s_medida1;
    assign db_medida2 = s_medida2;
    assign db_medida3 = s_medida3;
    assign db_dado_recebido_1 = s_dado_recebido_1;
    assign db_dado_recebido_2 = s_dado_recebido_2;
    assign db_dado_recebido_3 = s_dado_recebido_3;

endmodule