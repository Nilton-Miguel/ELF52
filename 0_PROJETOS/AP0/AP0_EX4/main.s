
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

	;A -------------------------------------------------------------------------
	
		MOV  R0, #101      ; R0:  00 00 00 65
		ADDS R0, R0, #253  ; R0:  00 00 01 62

	;B -------------------------------------------------------------------------
	
		MOV  R1, #1500      ; R1:  00 00 05 DC
		MOV  R2, #40543     ; R2:  00 00 9E 5F
		ADD  R3, R1, R2     ; R3:  00 00 A4 3B
	
	;C -------------------------------------------------------------------------
	
		MOV  R4, #340
		SUBS R5, R4, #123   ; R5:  00 00 00 D9
	
	;D -------------------------------------------------------------------------
		
		MOV  R6, #1000
		SUBS R7, R6, #2000	; R7:  FF FF FC 18
	
	;E -------------------------------------------------------------------------
	
		MOV R8, #54378      ; R8:  00 00 D4 6A
		MOV R9, #4									
							;         0000 0000 1101 0100 0110 1010
							;         0000 0011 0101 0001 1010 1000
							;         0    3    5    1    A    8
	
		MUL R9, R8, R9      ; R9:  00 03 51 A8
		
		; OPERA��O SIMILAR A 2 SHIFTS PARA A ESQUERDA
	
	;F -------------------------------------------------------------------------
	
		MOV  R10, 0X3344
		MOVT R10, 0X1122
		
		MOV  R11, 0X2211
		MOVT R11, 0X4433
		
		UMULL R0, R1, R11, R10   ; ALTA  R1: 04 90 81 B5 
								 ; BAIXA R0: F4 A0 6F 84
	
	;G -------------------------------------------------------------------------
	
		MOV  R2, 0X7560
		MOVT R2, 0XFFFF
		
		MOV  R3, #1000 

		SDIV R4, R2, R3          ; -35488 / 1000 =  -35
		
								 ; 00 00 00 23      +35
								 ; FF FF FF DC
								 ; FF FF FF DD      -35

	
	;H -------------------------------------------------------------------------
	
		MOV  R5, 0X7560
		MOVT R5, 0XFFFF

		UDIV R6, R5, R3          ; 4294931808 / 1000 = 4 294 931
								
								 ; 00 41 89 13

; Final do c�digo aqui ---------------------------------------------------------

    NOP
    ALIGN                       	;garante que o fim da se��o est� alinhada 
    END                         	;fim do arquivo
