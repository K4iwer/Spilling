/* --------------------------------------------------------------------------
 *  Arquivo   : contador_cm_uc-PARCIAL.v
 * --------------------------------------------------------------------------
 *  Descricao : unidade de controle do componente contador_cm
 *              
 *              incrementa contagem de cm a cada sinal de tick enquanto
 *              o pulso de entrada permanece ativo
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */

module contador_cm_uc (
    input wire clock,
    input wire reset,
    input wire pulso,
    input wire tick,
    output reg zera_tick,
    output reg conta_tick,
    output reg zera_bcd,
    output reg conta_bcd,
    output reg pronto
);

    // Tipos e sinais
    reg [2:0] Eatual, Eprox; // 3 bits são suficientes para os estados

    // Parâmetros para os estados
	/* completar */
    parameter inicial      = 3'b000;
    parameter contam_menor = 3'b001;
    parameter contacm      = 3'b010;
    parameter contam_maior = 3'b011;
    parameter prox         = 3'b100;
    parameter pronto_est   = 3'b101;

    // Memória de estado
    always @(posedge clock, posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox; 
    end

    // Lógica de próximo estado
    always @(*) begin
        case (Eatual)
            inicial: Eprox = pulso ? contam_menor : inicial;
            contam_menor: Eprox = pulso ? (tick ? contacm : contam_menor) : pronto_est;
            contacm: Eprox = contam_maior;
            contam_maior: Eprox = pulso ? (tick ? prox : contam_maior) : pronto_est;
            prox: Eprox = contam_menor;
            pronto_est: Eprox = inicial;
        endcase
    end

    // Lógica de saída (Moore)
    always @(*) begin

        zera_tick = 1'b0;
        conta_tick = 1'b0;
        conta_bcd = 1'b0;
        zera_bcd = 1'b0;
        pronto = 1'b0;

        case (Eatual)
        inicial:  begin
            zera_bcd  = 1'b1;
            zera_tick = 1'b1;
        end
        contam_menor: conta_tick = 1'b1;
        contacm: begin
            conta_bcd = 1'b1;
            zera_tick = 1'b1;
        end
        contam_maior: conta_tick = 1'b1;
        prox: zera_tick = 1'b1;
        pronto_est: pronto = 1'b1;
        endcase
    end

endmodule