
/*---------------Laboratorio Digital-------------------------------------
 * Arquivo   : contador_m.v
 *-----------------------------------------------------------------------
 * Descricao : contador binario, modulo m, com parametros 
 *             M (modulo do contador) e N (numero de bits),
 *             sinais para clear assincrono (zera_as) e sincrono (zera_s)
 *             e saidas de fim e meio de contagem
 *             
 *-----------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     30/01/2024  1.0     Edson Midorikawa  criacao
 *-----------------------------------------------------------------------
 */

module contador_m #(parameter M=100, N=7)
(
    input  wire          clock,
    input  wire          zera_as,
    input  wire          zera_s,
    input  wire          conta,
    output reg  [N-1:0]  Q,
    output reg           fim,
    output reg           meio
);

  always @(posedge clock or posedge zera_as) begin
    if (zera_as) begin
      Q    <= 0;
      fim  <= 0;
      meio <= 0;
    end 
    else begin
      if (zera_s) begin
        Q    <= 0;
        fim  <= 0;
        meio <= 0;
      end 
      else if (conta) begin
        if (Q == M-1)
          Q <= 0;
        else
          Q <= Q + 1'b1;

        // Atualiza as saídas de forma síncrona
        fim  <= (Q == M-1);
        meio <= (Q == (M/2 - 1));
      end
      else begin
        // Mantém os valores se nada acontece
        fim  <= 0;
        meio <= 0;
      end
    end
  end

endmodule
