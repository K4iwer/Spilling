`timescale 1ns/1ns

module roberto_tb;
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


    parameter clockPeriod = 20; // Clock de 50MHz
    always # (clockPeriod/2) clock = ~clock;
    reg [31:0] casos_teste [0:7];
    integer i;

    roberto DUT (
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
        .pronto(pronto)
    );

    initial begin
        $display("Inicio das simulacoes");
        casos_teste[0] = 5882;  // 5882us = 100cm 
        casos_teste[1] = 5899;  // 5899us = 100,29cm (truncar para 100cm)
        casos_teste[2] = 4353;  // 4353us = 74cm
        casos_teste[3] = 4399;  // 4399us = 74,79cm (arredondar para 75cm)

        // Valores iniciais
        clock = 0;
        reset = 1;
        ligar = 1;
        echo1 = 0;
        echo2 = 0;
        echo3 = 0;
        #20 reset = 0;  // Libera o reset após 20ns
        #100_000; // Espera 100us para início de operação do Sonar

        for (i = 0; i < 4; i = i + 1) begin
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
            wait(pronto == 1); // Espera final do ciclo
        end

        ligar = 1;
        #100_000; // espera 100us antes de finalizar 
        $stop;
    end

endmodule