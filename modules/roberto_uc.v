module roberto_uc (
    input wire clock,
    input wire reset,
    input wire jogar,
    input wire pronto_seg,
    input wire [1:0] pronto_2,
    input wire pronto_medida1,
    input wire pronto_medida2,
    input wire pronto_medida3,
    input wire saida_serial,
    output wire partida_tx,
    output wire [1:0] sel_sens1,
    output wire [1:0] sel_sens2,
    output wire [1:0] sel_sens3,
    output wire medir,
    output wire zera_sensor,
    output wire zera_serial,
    output wire zera_seg,
    output wire zera_2,
    output wire db_estado
);

/******************* Estados **********************/ 
parameter inicial       = 3'b000;
parameter medir         = 3'b001;
parameter envia         = 3'b010;
parameter aguarda1seg   = 3'b011;
parameter incrementa    = 3'b100;
parameter final         = 3'b101;

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
        inicial:        Eprox = jogar ? medir : inicial;
        medir:          Eprox = pronto_seg ? envia : medir;
        envia:          Eprox = aguarda1seg;
        aguarda1seg:    Eprox = (pronto_2 == 2'b10) ? final : incrementa;
        incrementa:     Eprox = envia;
        final:          Eprox = inicial;
        default: Eprox = inicial;
    endcase
end

/******************* Lógica de saída (Moore) **********************/ 

always @* begin
    zera_sensor = 1'b0;
    zera_serial = 1'b0;
    zera_seg = 1'b0;
    zera_2 = 1'b0;
    medir = 1'b0;
    sel_sens1 = 1'b0;
    sel_sens2 = 1'b0;
    sel_sens3 = 1'b0;
    partida_tx = 1'b0;
    
    case (Eatual)
    medir: 


    endcase

end

/******************* Saída de depuração (estados) WIP **********************/ 


endmodule