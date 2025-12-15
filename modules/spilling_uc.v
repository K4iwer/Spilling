module spilling_uc (
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
    output reg zera_servos,
    output reg pronto,
    output reg zera_disc,
    output reg carrega_disc,
    output reg [3:0] db_estado
);

/******************* Estados **********************/ 
parameter inicial       = 4'b0000;
parameter est_reset     = 4'b0001; 
parameter est_medir     = 4'b0010;
parameter esp_seg       = 4'b0011;
parameter move_servos   = 4'b0100;
parameter envia         = 4'b0101;
parameter proxEnvio     = 4'b0110;
parameter proxSensor    = 4'b0111;
parameter est_final     = 4'b1000;

/******************* Variáveis de estado **********************/ 

reg [3:0] Eatual, Eprox;

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
        inicial:        Eprox = jogar ? est_reset : inicial;
        est_reset:      Eprox = est_medir;
        est_medir:      Eprox = esp_seg;
        esp_seg:        Eprox = pronto_seg ? move_servos : esp_seg;
        move_servos:    Eprox = envia;
        envia:          Eprox = pronto_serial ? proxEnvio : envia;
        proxEnvio:      Eprox = (Q_3 == 2'b11) ? proxSensor : envia;
        proxSensor:     Eprox = (Q_2 == 2'b10) ? est_final : envia;
        est_final:      Eprox = inicial;
        default:        Eprox = inicial;
    endcase
end

/******************* Lógica de saída (Moore) **********************/ 

always @(*) begin
    zera_sensor = 1'b0;
    zera_serial = 1'b0;
    zera_seg = 1'b0;
    zera_2 = 1'b0;
    zera_3 = 1'b0;
    zera_servos = 1'b0;
    medir = 1'b0;
    partida_tx = 1'b0;
    cont_2 = 1'b0;
    cont_3 = 1'b0;
    cont_seg = 1'b0;
    pronto = 1'b0;
    zera_disc = 1'b0;
    carrega_disc = 1'b0;

    case (Eatual)
        est_reset: begin
            zera_sensor = 1'b1;
            zera_serial = 1'b1;
            zera_seg = 1'b1;
            zera_2 = 1'b1;
            zera_3 = 1'b1;
            zera_servos = 1'b1;
            zera_disc = 1'b1;
        end
        est_medir: begin
            medir = 1'b1;
        end
        esp_seg: begin 
            cont_seg = 1'b1;
        end
        move_servos: begin
            carrega_disc = 1'b1;
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
        inicial:        db_estado = 4'b0000;
        reset:          db_estado = 4'b0001;
        est_medir:      db_estado = 4'b0010;
        esp_seg:        db_estado = 4'b0011;
        move_servos:    db_estado = 4'b0100;
        envia:          db_estado = 4'b0101;
        proxEnvio:      db_estado = 4'b0110;
        proxSensor:     db_estado = 4'b0111;
        est_final:      db_estado = 4'b1000;
        default:        db_estado = 4'b1111; // erro
    endcase
end

endmodule