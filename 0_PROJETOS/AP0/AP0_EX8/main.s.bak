
; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Esquele de um novo Projeto para Keil
; Prof. Guilherme de S. Peron	- 12/03/2018
; Prof. Marcos E. P. Monteiro	- 12/03/2018
; Prof. DaLuz           		- 25/02/2022
;---------------------------------------------------------------------------------

; Declarações EQU
; <NOME>	EQU <VALOR>
;---------------------------------------------------------------------------------

	AREA    |.text|, CODE, READONLY, ALIGN=2
	THUMB

; Se alguma função do arquivo for chamada em outro arquivo	
    EXPORT Start					; Permite chamar a função Start a partir de 
									; outro arquivo. No caso startup.s
								
; Se chamar alguma função externa	
;	IMPORT <func>          			; Permite chamar dentro deste arquivo uma função <func>
;---------------------------------------------------------------------------------

Start

		;R1 input de n no codigo
		;R2 ponteiro
		;R3 receber n da SRAM
		;R0 resultado

		; escrever o valor desejado para a SRAM ---------------------

		MOV  R1, #0

		MOV  R2, 0X0000
		MOVT R2, 0X2000

		STR  R1, [R2]

		;carregar o valor da SRAM para o R3 -------------------------

		LDR  R3, [R2]
		MOV  R0, #1

MULTIPLICA


		CMP  R3, #1

		;multiplica o resultado r0 por r3 e subtrai 1 de r3 
		;somente se r3 ainda não chegou em 1 ou menor

		MULGT  R0, R0, R3
		SUBGT R3, R3, #1

		;se r3 chegou a 1 r0 contém o fatorial correto

		BGT  MULTIPLICA

		; ----------------------------------------------------------

FIM		B FIM

; Final do código aqui ---------------------------------------------------------

    NOP
    ALIGN                       	;garante que o fim da seção está alinhada 
    END                         	;fim do arquivo
