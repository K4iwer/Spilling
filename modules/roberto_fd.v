module roberto_fd (
    input  wire clock,
    input  wire zera_sensor,
    input  wire zera_serial,
    input  wire medir, 
    input  wire echo1,  
    input  wire echo2,  
    input  wire echo3,  
    input  wire sel_sens1,
    input  wire sel_sens2,
    input  wire sel_sens3,
    input  wire sel_medida,
    input  wire partida_tx,
    output wire trigger1, 
    output wire trigger2, 
    output wire trigger3, 
    output wire pronto_medida1, 
    output wire pronto_medida2, 
    output wire pronto_medida3, 
    output wire saida_serial, 
    output wire pronto_serial, 
    output wire [11:0] db_medida1,
    output wire [11:0] db_medida2,
    output wire [11:0] db_medida3,
    output wire [3:0] db_estado_ult
);

    // Sinais internos
    wire [11:0] s_medida1;
    wire [11:0] s_medida2;
    wire [11:0] s_medida3;
    wire [6:0]  s_medidas_asc_1;
    wire [6:0]  s_medidas_asc_2;
    wire [6:0]  s_medidas_asc_3;
    wire [6:0]  s_entr_serial;

    /******************* Medição da distância **********************/ 

    // Sensor ultrassônico 1
    interface_hcsr04 SENSOR_ULTRASSOM_1 (
        .clock    (clock         ),
        .reset    (zera_sensor   ),
        .medir    (medir         ),
        .echo     (echo1         ),
        .trigger  (trigger1      ),
        .medida   (s_medida1     ),
        .pronto   (pronto_medida1),
        .db_medir (              ),
        .db_reset (              ),
        .db_estado(db_estado_ult )
    );

    // mux sensor 1
    mux_4x1_n #(
        .BITS(7)
    ) MUL_sens1 (
        .D3     ({3'b011, s_medida1[11:8]}),  // para converter para asc, precisa colocar 011 antes do valor
        .D2     ({3'b011, s_medida1[7:4]} ), 
        .D1     ({3'b011, s_medida1[3:0]} ),
        .D0     (7'b0100011               ),  // #
        .SEL    (sel_sens1                ),
        .MUX_OUT(s_medidas_asc_1          )
    );

    // Sensor ultrassônico 2
    interface_hcsr04 SENSOR_ULTRASSOM_2 (
        .clock    (clock         ),
        .reset    (zera_sensor   ),
        .medir    (medir         ),
        .echo     (echo2         ),
        .trigger  (trigger2      ),
        .medida   (s_medida2     ),
        .pronto   (pronto_medida2),
        .db_medir (              ),
        .db_reset (              ),
        .db_estado(db_estado_ult )
    );

    // mux sensor 2
    mux_4x1_n #(
        .BITS(7)
    ) MUL_sens2 (
        .D3     ({3'b011, s_medida2[11:8]}),  // para converter para asc, precisa colocar 011 antes do valor
        .D2     ({3'b011, s_medida2[7:4]} ), 
        .D1     ({3'b011, s_medida2[3:0]} ),
        .D0     (7'b0100011               ),  // #
        .SEL    (sel_sens2                ),
        .MUX_OUT(s_medidas_asc_2          )
    );

    // Sensor ultrassônico 3
    interface_hcsr04 SENSOR_ULTRASSOM_3 (
        .clock    (clock         ),
        .reset    (zera_sensor   ),
        .medir    (medir         ),
        .echo     (echo3         ),
        .trigger  (trigger3      ),
        .medida   (s_medida3     ),
        .pronto   (pronto_medida3),
        .db_medir (              ),
        .db_reset (              ),
        .db_estado(db_estado_ult )
    );

    // mux sensor 3
    mux_4x1_n #(
        .BITS(7)
    ) MUL_sens3 (
        .D3     ({3'b011, s_medida3[11:8]}),  // para converter para asc, precisa colocar 011 antes do valor
        .D2     ({3'b011, s_medida3[7:4]} ), 
        .D1     ({3'b011, s_medida3[3:0]} ),
        .D0     (7'b0100011               ),  // #
        .SEL    (sel_sens3                ),
        .MUX_OUT(s_medidas_asc_3          )
    );


    /******************* Transmissão Serial **********************/ 

    // mux serial
    mux_4x1_n #(
        .BITS(7)
    ) MUL_serial (
        .D3     (s_medidas_asc_1),  // para converter para asc, precisa colocar 011 antes do valor
        .D2     (s_medidas_asc_2), 
        .D1     (s_medidas_asc_3),
        .D0     (7'b0000000     ),  // #
        .SEL    (sel_medida     ),
        .MUX_OUT(s_entr_serial  )
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



    assign db_medida1 = s_medida1;
    assign db_medida2 = s_medida2;
    assign db_medida3 = s_medida3;

endmodule