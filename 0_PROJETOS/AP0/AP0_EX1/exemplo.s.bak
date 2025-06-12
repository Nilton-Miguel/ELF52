
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
	
	;A
	MOV  R0, #65
	
	;B
	MOV  R1, #0X1B001B00
	
	;C
	MOV  R2, #0X5678
	MOVT R2, #0X1234
	
	;D
	MOV  R3, #0X0040
	MOVT R3, #0X2000
	STR  R0, [R3]
	
	;E
	MOV  R3, #0X0044
	MOVT R3, #0X2000
	STR  R1, [R3]
	
	;F
	MOV  R3, #0X0048
	MOVT R3, #0X2000
	STR  R2, [R3]
	
	;G
	ADD  R3, #4
	MOV  R4, #1
	MOVT R4, #0XF
	STR  R4, [R3]
	
	;H
	MOV  R3, #0X0046
	MOVT R3, #0X2000
	MOV  R5, #0XCD
	STRB R5, [R3]		;STRB VAI TRATAR COMO ÚNICO BYTE E SALVAR EXATAMENTE NO ENDEREÇO DO PONTEIRO
	;STR  R5, [R3]		;STR VAI TRATAR COMO UMA WORD DE 4 BYTES E ARMAZENAR EM 4 ENDEREÇOS SENDO O PONTEIRO O PRIMEIRO
	
	;I
	SUB  R3, #6
	LDR  R7, [R3]
	
	;J
	ADD  R3, #8
	LDR  R8, [R3]
	
	;K
	;MOV  R9, R8		;ENTRE REGISTRADORES POSSO MOVER 4 BYTES DIRETO PELO HARDWARE POR NÃO SER IMEDIATO
	MOV  R9, R7			;O DADO ESTÁ EM HARDWARE, NÃO ESTÁ CONTIDO NA INSTRUÇÃO EM SI, NUM ESPAÇO LIMITADO.

; Final do código aqui ---------------------------------------------------------

    NOP
    ALIGN                       	;garante que o fim da seção está alinhada 
    END                         	;fim do arquivo
