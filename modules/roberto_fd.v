module roberto_fd (
    input  wire clock,
    input  wire zera_sensor,
    input  wire medir, 
    input  wire echo1,  
    input  wire echo2,  
    input  wire echo3,  
    output wire trigger1, 
    output wire trigger2, 
    output wire trigger3, 
    output wire pronto_medida1, 
    output wire pronto_medida2, 
    output wire pronto_medida3, 
    output wire [11:0] db_medida1,
    output wire [11:0] db_medida2,
    output wire [11:0] db_medida3,
    output wire [3:0] db_estado_ult
);

    // Sinais internos
    wire [11:0] s_medida1;
    wire [11:0] s_medida2;
    wire [11:0] s_medida3;

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

    assign db_medida1 = s_medida1;
    assign db_medida2 = s_medida2;
    assign db_medida3 = s_medida3;

endmodule