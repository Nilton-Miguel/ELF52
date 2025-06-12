
; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Esquele de um novo Projeto para Keil
; Prof. Guilherme de S. Peron	- 12/03/2018
; Prof. Marcos E. P. Monteiro	- 12/03/2018
; Prof. DaLuz           		- 25/02/2022
;---------------------------------------------------------------------------------

; Declara��es EQU
; <NOME>	EQU <VALOR>
;---------------------------------------------------------------------------------

	AREA    |.text|, CODE, READONLY, ALIGN=2
	THUMB

; Se alguma fun��o do arquivo for chamada em outro arquivo	
    EXPORT Start					; Permite chamar a fun��o Start a partir de 
									; outro arquivo. No caso startup.s
								
; Se chamar alguma fun��o externa	
;	IMPORT <func>          			; Permite chamar dentro deste arquivo uma fun��o <func>
;---------------------------------------------------------------------------------

Start
		
		MOV  R0, 0XFF07
		MOV  R1, #10
		MOV  R2, #2
		MOV  R3, #0XDD38
		MOV  R4, #0XC731
		
		BL DIVISIVEL
		
		MOV  R1, #11
		MOV  R2, #3
		
		BL DIVISIVEL
		
		NOP

DIVISIVEL
; retorna em r0 se r1 � divis�vel por r2 ------------------------------------
; os outros registradores tem seus valores restaurados ao fim da exec.
; o antigo conteudo de r0 pode ser recuperado do topo da pilha
;----------------------------------------------------------------------------

		; backup
		PUSH {R0}
		PUSH {R3-R4}

		; r2 divis�o sem resto r0/r1 
		UDIV  R3, R1, R2
		; r3 o resto da divis�o r0/r1
		MUL   R4, R3, R2
		SUBS  R4, R1, R4 

		; retorno em r0 depende de r3 ser 0
		MOVEQ R0, #1
		MOVNE R0, #0
		
		; backup
		POP {R3-R4}
		BX  LR

;---------------------------------------------------------------------------

; Final do c�digo aqui ---------------------------------------------------------

    NOP
    ALIGN                       	;garante que o fim da se��o est� alinhada 
    END                         	;fim do arquivo
