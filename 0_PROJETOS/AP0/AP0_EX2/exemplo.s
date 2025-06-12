
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
	
	;A ------------------------------------------------------------
	
		MOV  R0, #0XF0
		ANDS R0, R0, #2_01010101 ;0X55
	;B ------------------------------------------------------------
	
		MOV  R1, #2_11001100 ;0XCC
		ANDS R1, R1, #2_00110011 ;0X33
	;C ------------------------------------------------------------
	
		MOV  R2, #2_10000000 ;0X80
		ORRS R2, #2_00110111 ;0X37
	;D ------------------------------------------------------------
	
		MOV  R4, #0XABCD
		MOVT R4, #0XABCD
		MOV  R5, #0X0000
		MOVT R5, #0XFFFF
		
		ANDS R3, R4, R5
		BICS R6, R4, R5 ;ANDS VAI SALVAR OS MSB E BICS OS LSB

; Final do código aqui ---------------------------------------------------------

    NOP
    ALIGN                       	;garante que o fim da seção está alinhada 
    END                         	;fim do arquivo
