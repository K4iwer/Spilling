`timescale 1ns/1ns

module spilling_tb;
    reg clock;
    reg reset;
    reg ligar;
    reg echo1;
    reg echo2;
    reg echo3;
    wire trigger1;
    wire trigger2;
    wire trigger3;
    wire saida_serial;
    wire pronto;
    wire db_PWM1;
    wire db_PWM2;
    wire db_PWM3;

    parameter clockPeriod = 20; // Clock de 50MHz
    always # (clockPeriod/2) clock = ~clock;
    reg [31:0] casos_teste [0:7];
    integer i;

    // Variável para o período de um bit no protocolo 7E1
    real bit_period;

    spilling DUT (
        .clock(clock),
        .reset(reset),
        .ligar(ligar),
        .echo1(echo1),
        .echo2(echo2),
        .echo3(echo3),
        .trigger1(trigger1),
        .trigger2(trigger2),
        .trigger3(trigger3),
        .saida_serial(saida_serial),
        .pronto(pronto),
        .db_PWM1(db_PWM1),
        .db_PWM2(db_PWM2),
        .db_PWM3(db_PWM3)
    );

    initial begin
        $display("Inicio das simulacoes");
        casos_teste[0] = 411;  // 411us = 7cm, categoria 1 (00)
        casos_teste[1] = 706;  // 706us = 12cm, categoria 2 (01)
        casos_teste[2] = 1294;  // 1294us = 22cm, categoria 3 (10)
        casos_teste[3] = 1471;  // 1471us = 25cm, categoria 4 (11)
        // Define o período de um bit para o baud rate de 115000
        bit_period = 1_000_000_000 / 115200; // em nanosegundos

        // Valores iniciais
        clock = 0;
        reset = 1;
        ligar = 1;
        echo1 = 0;
        echo2 = 0;
        echo3 = 0;
        #20 reset = 0;  // Libera o reset após 20ns
        #100_000; // Espera 100us para início de operação

        for (i = 0; i < 4; i = i + 1) begin
            #(bit_period * 200);
            $display("Caso");
            #20 ligar = 1;
            #20 ligar = 0; // Liga o circuito

            wait(trigger1 == 1);
            #400_000; // tempo entre trigger e echo

            echo1 = 1; // Gera pulso Echo com largura definida no caso de teste
            echo2 = 1; // Gera pulso Echo com largura definida no caso de teste
            echo3 = 1; // Gera pulso Echo com largura definida no caso de teste
            #(casos_teste[i] * 1000);  // Converte microsegundos para nanosegundos
            echo1 = 0;
            echo2 = 0;
            echo3 = 0;

            #(bit_period * 2500);

            #(20_000_000); // espera o tempo do PMW
        end
        #100_000; 

        $stop; // Finaliza a simulação
    end

endmodule