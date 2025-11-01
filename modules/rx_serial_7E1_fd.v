/* --------------------------------------------------------------------------
 *  Arquivo   : rx_serial_8N1_fd.v
 * --------------------------------------------------------------------------
 *  Descricao : fluxo de dados do circuito de recepcao serial assincrona
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *     Data        Versao  Autor              Descricao
 *     15/10/2024  5.0     Augusto Vaccarelli conversao para receptor
 *     29/10/2024  5.1     Edson Midorikawa   revisao do codigo
 * --------------------------------------------------------------------------
 */ 
 
 module rx_serial_7E1_fd (
    input        clock      ,
    input        reset      ,
    input        zera       ,
    input        conta      ,
    input        registra   ,
    input        carrega    ,
    input        desloca    ,
    input        RX         ,
    input        erro       ,
    output [6:0] dados_ascii,
    output       fim,
    output       par_ok
);

    wire [9:0] s_saida;
    wire bit_paridade;
    wire [6:0] dados7;

    // extração dos dados seriais
    // SDDDDDDDDSR
  
    // Instanciação do deslocador_n
    deslocador_n #(
        .N(10) 
    ) DESL (
        .clock          ( clock   ),
        .reset          ( reset   ),
        .carrega        ( carrega ),
        .desloca        ( desloca ),
        .entrada_serial ( RX      ), 
        .dados          ( 10'h3FF ), // dados com valor 0x3FF
        .saida          ( s_saida )
    );
    
    // Instanciação do contador_m
    contador_m #(
        .M(10),
        .N(4)
    ) CONT (
        .clock   (clock),
        .zera_as (reset),
        .zera_s  (zera ),
        .conta   (conta),
        .Q       (     ), // (desconectada)
        .fim     (fim  ),
        .meio    (     )  // (desconectada)
    );
     
    assign dados7 = (erro ? 7'b011_1111 : s_saida[7:1]);
    assign bit_paridade = s_saida[8];
    assign par_ok = ((^dados7) == bit_paridade);
    

    registrador_n #(
        .N(7)
    ) REG (
        .clock  ( clock        ),
        .clear  ( reset        ),
        .enable ( registra     ),
        .D      ( dados7       ),
        .Q      ( dados_ascii  )
);
    
endmodule
