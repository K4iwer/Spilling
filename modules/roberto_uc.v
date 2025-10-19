module roberto_uc (
    input wire clock,
    input wire reset,
    input wire jogar,
    input wire pronto_seg,
    input wire [1:0] Q_2,
    input wire [1:0] Q_3,
    input wire pronto_serial,
    output reg cont_2,
    output reg cont_3,
    output reg zera_2,
    output reg zera_3,
    output reg partida_tx,
    output reg medir,
    output reg zera_sensor,
    output reg zera_serial,
    output reg zera_seg,
    output reg cont_seg,
    output reg pronto,
    output reg [2:0] db_estado
);

/******************* Estados **********************/ 
parameter inicial       = 3'b000;
parameter est_medir     = 3'b001;
parameter envia         = 3'b010;
parameter proxEnvio     = 3'b011;
parameter proxSensor    = 3'b100;
parameter est_final     = 3'b101;

/******************* Variáveis de estado **********************/ 

reg [2:0] Eatual, Eprox;

/******************* Transição de estado **********************/ 

always @(posedge clock or posedge reset) begin
    if (reset)
        Eatual <= inicial;
    else
        Eatual <= Eprox; 
end

/******************* Lógica de próximo estado **********************/ 

always @* begin
    case (Eatual)
        inicial:        Eprox = jogar ? est_medir : inicial;
        est_medir:      Eprox = pronto_seg ? envia : est_medir;
        envia:          Eprox = pronto_serial ? proxEnvio : envia;
        proxEnvio:      Eprox = (Q_3 == 2'b11) ? proxSensor : envia;
        proxSensor:     Eprox = (Q_2 == 2'b10) ? est_final : envia;
        est_final:      Eprox = reset? inicial : est_final;
        default:        Eprox = inicial;
    endcase
end

/******************* Lógica de saída (Moore) **********************/ 

always @* begin
    zera_sensor = 1'b0;
    zera_serial = 1'b0;
    zera_seg = 1'b0;
    zera_2 = 1'b0;
    zera_3 = 1'b0;
    medir = 1'b0;
    partida_tx = 1'b0;
    cont_2 = 1'b0;
    cont_3 = 1'b0;
    cont_seg = 1'b0;
    pronto = 1'b0;

    case (Eatual)
        inicial: begin
            zera_sensor = 1'b1;
            zera_serial = 1'b1;
            zera_seg = 1'b1;
            zera_2 = 1'b1;
            zera_3 = 1'b1;
        end
        est_medir: begin
            medir = 1'b1;
            cont_seg = 1'b1;
        end
        envia: begin
            partida_tx = 1'b1;
        end
        proxEnvio: begin
            cont_3 = 1'b1;
        end
        proxSensor: begin
            cont_2 = 1'b1;
            zera_3 = 1'b1;
        end
        est_final: begin
            zera_2 = 1'b1;
            pronto = 1'b1;
        end
    endcase

end

/******************* Saída de depuração (estados) **********************/ 
always @* begin
    case(Eatual)
        inicial:    db_estado = 3'b000;
        est_medir:  db_estado = 3'b001;
        envia:      db_estado = 3'b010;
        proxEnvio:  db_estado = 3'b011;
        proxSensor: db_estado = 3'b100;
        est_final:  db_estado = 3'b101;
        default:    db_estado = 3'b111; // erro
    endcase
end

endmodule