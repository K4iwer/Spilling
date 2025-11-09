`timescale 1ns/1ns

module roberto_tb;
    reg clock;
    reg reset;
    reg ligar;
    reg echo1;
    reg echo2;
    reg echo3;
    reg rx_serial; // Sinal para recepção serial
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

    roberto DUT (
        .clock(clock),
        .reset(reset),
        .ligar(ligar),
        .echo1(echo1),
        .echo2(echo2),
        .echo3(echo3),
        .RX(rx_serial), // Conexão para recepção serial
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
        casos_teste[0] = 1176;  // 1176us = 20cm 
        casos_teste[1] = 588;  // 588us = 10cm
        //casos_teste[2] = 4353;  // 4353us = 74cm
        //casos_teste[3] = 4399;  // 4399us = 74,79cm (arredondar para 75cm)
        // Define o período de um bit para o baud rate de 115000
        bit_period = 1_000_000_000 / 115000; // em nanosegundos

        // Valores iniciais
        clock = 0;
        reset = 1;
        ligar = 1;
        echo1 = 0;
        echo2 = 0;
        echo3 = 0;
        rx_serial = 1; // Linha de recepção inicializada em idle (nível alto)
        #20 reset = 0;  // Libera o reset após 20ns
        #100_000; // Espera 100us para início de operação do Sonar

        for (i = 0; i < 1; i = i + 1) begin
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

            enviar_palavra_serial(7'b011_0000, bit_period); // 00
            #(bit_period * 10); // Tempo entre palavras
            enviar_palavra_serial(7'b011_0001, bit_period); // 1
            #(bit_period * 10); // Tempo entre palavras
            enviar_palavra_serial(7'b011_0010, bit_period); // 2
            #(200_000_000); // espera o tempo do PMW
        end
        #100_000; 

        $display("Recepção serial concluída");

        $stop; // Finaliza a simulação
    end

    // Tarefa para enviar uma palavra no protocolo 7E1
    task enviar_palavra_serial;
        input [6:0] palavra;
        input real bit_period;
        integer j;
        begin
            // Envia bit de start (nível baixo)
            rx_serial = 0;
            #(bit_period);

            // Envia 7 bits de dados (LSB primeiro)
            for (j = 0; j < 7; j = j + 1) begin
                rx_serial = palavra[j];
                #(bit_period);
            end

            // Envia bit de paridade (paridade par)
            rx_serial = ~^palavra[6:0];
            #(bit_period);

            // Envia bit de stop (nível alto)
            rx_serial = 1;
            #(bit_period);
        end
    endtask
endmodule