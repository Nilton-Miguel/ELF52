
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

	;A -------------------------------------------------------------------------
	
		MOV  R0, #10

	;B -------------------------------------------------------------------------
	
SOMA
	
		ADD  R0, R0, #5
		CMP  R0, #50
		BNE  SOMA
		
		;D ------------------------------------------------------------
		
		BL FUNC
		
		;E ------------------------------------------------------------
		
		NOP
		
		;F ------------------------------------------------------------
		
LOOP	B LOOP
		
	;C -------------------------------------------------------------------------

FUNC

		MOV  R1, R0
		CMP  R1, #50
		
		ITE  LT
		
			ADDLT  R1, #1
			MOVGE  R1, #-50
		
		BX LR

; Final do código aqui ---------------------------------------------------------

    NOP
    ALIGN                       	;garante que o fim da seção está alinhada 
    END                         	;fim do arquivo
