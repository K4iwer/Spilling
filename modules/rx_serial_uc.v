module rx_serial_uc ( 
    input            clock,
    input            reset,
    input            tick,
    input            fim,
    input            RX,
    input            par_ok,
    output reg       registra,
    output reg       zera,
    output reg       zera_tick,
    output reg       conta,
    output reg       carrega,
    output reg       desloca,
    output reg       pronto,
    output reg [3:0] db_estado,
    output reg       erro
);

    // Estados da FSM
    parameter inicial     = 4'b0000; 
    parameter preparacao  = 4'b0001;
    parameter espera      = 4'b0010; 
    parameter recepcao    = 4'b0011;
    parameter registrar   = 4'b0100;
    parameter final_rx    = 4'b0101;

    reg [3:0] Eatual, Eprox;

    // Atualiza estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    // Lógica de próximo estado (combinacional)
    always @(*) begin
        case (Eatual)
            inicial    : Eprox = RX ? inicial : preparacao;
            preparacao : Eprox = espera;
            espera     : Eprox = tick ? recepcao : (fim ? registrar : espera);
            recepcao   : Eprox = espera;        
            registrar  : Eprox = final_rx;
            final_rx   : Eprox = inicial;
            default    : Eprox = inicial;
        endcase
    end

    // Lógica de saída síncrona
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            zera      <= 1'b1;
            registra  <= 1'b0;
            erro      <= 1'b0;
            carrega   <= 1'b0;
            desloca   <= 1'b0;
            conta     <= 1'b0;
            zera_tick <= 1'b0;
            pronto    <= 1'b0;
            db_estado <= 4'b0000;
        end else begin
            // Saídas default
            zera      <= 1'b0;
            registra  <= 1'b0;
            erro      <= 1'b0;
            carrega   <= 1'b0;
            desloca   <= 1'b0;
            conta     <= 1'b0;
            zera_tick <= 1'b0;
            pronto    <= 1'b0;

            // Definição por estado
            case(Eatual)
                inicial: begin
                    zera <= 1'b1;
                end
                preparacao: begin
                    carrega   <= 1'b1;
                    zera_tick <= 1'b1;
                end
                espera: begin
                    // nenhuma saída ativa
                end
                recepcao: begin
                    desloca <= 1'b1;
                    conta   <= 1'b1;
                end
                registrar: begin
                    registra <= 1'b1;
                    if (~par_ok) erro <= 1'b1;
                end
                final_rx: begin
                    pronto <= 1'b1;
                end
            endcase

            // Saída de depuração
            case(Eatual)
                inicial    : db_estado <= 4'b0000;
                preparacao : db_estado <= 4'b0001;
                espera     : db_estado <= 4'b0010;
                recepcao   : db_estado <= 4'b0011;
                registrar  : db_estado <= 4'b0100;
                final_rx   : db_estado <= 4'b1111;
                default    : db_estado <= 4'b1110;
            endcase
        end
    end

endmodule
