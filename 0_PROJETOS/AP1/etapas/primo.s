
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


INFINITO

		B INFINITO

;----------------------------------------------------------------------------

; SUBROTINAS """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

PRIMO
; retorna em r0 se r1 é primo -----------------------------------------------
; os outros registradores tem seus valores restaurados ao fim da exec.
; o antigo conteudo de r0 pode ser recuperado do topo da pilha
;----------------------------------------------------------------------------

		;backup
		PUSH {R0}
		PUSH {R2-R3}

		; r2 indice usado no loop
		MOV  R2, #2

		; r3 inteiro acima da metade de r1
		UDIV R3, R1, R2
		ADD  R3, R3, #1

TESTE_DIVISIBILIDADE

		PUSH {LR}
		BL DIVISIVEL
		; r4 guarda o reultado de divisibilidade de r1 por r2

		; r1 foi divisivel por r2 
		CMP  R0, #1
		POP  {R0}
		POP  {LR}

		BEQ DIV
		BNE INDIV

INDIV
		; 1/2 chega aqui
		; isso garante que 1 nao seja validado como primo
		CMP R1, #1
		BEQ FRACASSO
		
		ADD R2, R2, #1
		CMP R2, R3
		BLE TESTE_DIVISIBILIDADE
		BGT SUCESSO

DIV

		CMP R1, R2
		BNE FRACASSO
		BEQ SUCESSO

SUCESSO
	
		MOV  R0, #1
		B BACKUP

FRACASSO
	
		MOV  R0, #0
		B BACKUP

BACKUP
		POP  {R2-R3}
		BX LR

;""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

DIVISIVEL
; retorna em r0 se r1 é divisível por r2 ------------------------------------
; os outros registradores tem seus valores restaurados ao fim da exec.
; o antigo conteudo de r0 pode ser recuperado do topo da pilha
;----------------------------------------------------------------------------

		; backup
		PUSH {R0}
		PUSH {R3-R4}

		; r2 divisão sem resto r0/r1 
		UDIV  R3, R1, R2
		; r3 o resto da divisão r0/r1
		MUL   R4, R3, R2
		SUBS  R4, R1, R4 

		; retorno em r0 depende de r3 ser 0
		MOVEQ R0, #1
		MOVNE R0, #0

		; backup
		POP {R3-R4}
		BX  LR
;---------------------------------------------------------------------------

; Final do código aqui ---------------------------------------------------------

    NOP
    ALIGN                       	;garante que o fim da seção está alinhada 
    END                         	;fim do arquivo
