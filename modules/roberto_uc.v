module roberto_uc (
    input wire clock,
    input wire reset,
    input wire jogar,
    input wire pronto_medida1,
    input wire pronto_medida2,
    input wire pronto_medida3,

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
        inicial: Eprox = jogar ? medir : inicial;
        medir: 

        default: Eprox = inicial;
    endcase

end


endmodule