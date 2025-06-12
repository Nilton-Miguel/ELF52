
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
		
		CMP R0, #9
		
	;C -------------------------------------------------------------------------
	
		ITTE GE
		
			MOVGE R1, #50
			ADDGE R2, R1, #32
			MOVLT R3, #75
	
	;D -------------------------------------------------------------------------
	
		CMP R0, #11
		
		ITTE GE
		
			MOVGE R4, #50
			ADDGE R5, R4, #32
			MOVLT R6, #75

; Final do código aqui ---------------------------------------------------------

    NOP
    ALIGN                       	;garante que o fim da seção está alinhada 
    END                         	;fim do arquivo
