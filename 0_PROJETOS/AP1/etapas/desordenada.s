
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

RAM_LISTA_ALEATORIOS   EQU 0X20000400
RAM_LISTA_PRIMOS	   EQU 0X20000500

; Se alguma função do arquivo for chamada em outro arquivo	
    EXPORT Start					; Permite chamar a função Start a partir de 
									; outro arquivo. No caso startup.s
								
; Se chamar alguma função externa	
;	IMPORT <func>          			; Permite chamar dentro deste arquivo uma função <func>
;---------------------------------------------------------------------------------

Start
	
	; set dos ponteiros
	LDR  R0, =ROM_LISTA_ALEATORIOS
	LDR  R1, =RAM_LISTA_ALEATORIOS
	LDR  R2, =ROM_TAMPA
	
	; R4 é o contador de aleatórios
	; R5 é o contador de primos
	MOV  R4, #0
	MOV  R5, #0

;----------------------------------------------------------------------

; carregar da ROM para a RAM todos os bytes aleatórios
LOOP_CARREGAMENTO

	; trago da ROM para o r3
	; jogo pra SRAM do r3
	LDRB R3, [R0]
	STRB R3, [R1]
	
	ADD  R4, #1
	
	ADD  R0, R0, #1
	ADD  R1, R1, #1
	
	CMP  R0, R2
	
	BNE LOOP_CARREGAMENTO

	;SRAM está carregada com a lista de aleatórios desde a 0x20000400
;----------------------------------------------------------------------

	; reset dos ponteiros
	LDR R2, =RAM_LISTA_ALEATORIOS
	LDR R3, =RAM_LISTA_PRIMOS
	
;----------------------------------------------------------------------

; checar byte a byte se é primo, 
; se for escrever pra lista de primos na RAM
CHECAGEM

	LDRB R1, [R2]
	BL PRIMO
	CMP R0, #1
	POP {R0}
	
	SUB  R4, #1
	
	ADDEQ   R5, #1
	STRBEQ  R1, [R3]
	ADDEQ   R3, #1
	ADD     R2, #1
	
	CMP R4, #0
	
	BGT CHECAGEM
	
;----------------------------------------------------------------------

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

;CARREGA_ROM é um apelido para uma posição da memória
ROM_LISTA_ALEATORIOS
		
		; na ROM após a gravação do código de máquina vem a gravação desses números
		; CARREGA_ROM é o endereço do primeiro endereço de ROM que guarda os 
		DCB 2, 5, 15, 16, 18, 19, 22, 65, 40, 7, 77, 103, 3, 6, 4, 1

; ROM_TAMPA é o primeiro endereço que não faz parte da lista
ROM_TAMPA
		
		DCB 69

; Final do código aqui ---------------------------------------------------------

    NOP
    ALIGN                       	;garante que o fim da seção está alinhada 
    END                         	;fim do arquivo
