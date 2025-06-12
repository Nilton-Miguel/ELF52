
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
	
		MOV  R0, #701      ; R0:  00 00 02 BD
		LSRS R1, R0, #5    ; R1:  00 00 00 15
		
		MOV  R2, #5
		LSRS R3, R0, R2    ; R3:  00 00 00 15
	;B -------------------------------------------------------------------------
	
		MOV  R5, #32067    ; R5:  00 00 7D 43
		NEG  R6, R5        ;      FF FF 82 BC COMPLEMENTO DE 1
						   ; R6:  FF FF 82 BD COMPLEMENTO DE 2
		LSRS R7, R6, #4    ; R7:  0F FF F8 2B
	;C -------------------------------------------------------------------------
		
		MOV R8, #701       ; R8:  00 00 02 BD : ... 0010 1011 1101
		ASRS R9, R8, #3    ; R9:  00 00 00 57 : ... 0000 0101 0111
	;D -------------------------------------------------------------------------
		
		MOV  R10, #32067   ; R10: 00 00 7D 43
		NEG  R11, R10	   ; R11: FF FF 82 BD : ... 1000 0010 1011 1101
		ASRS R12, R11, #5  ; R12: FF FF FC 15 : ... 1111 1100 0001 0101
	;E -------------------------------------------------------------------------
	
		MOV  R0, #255      ; R0:  00 00 00 FF
		LSLS R1, R0, #8    ; R0:  00 00 FF 00
	;F -------------------------------------------------------------------------
	
		MOV  R2, #58982    ; R2:  00 00 E6 66
		NEG  R3, R2        ; R3:  FF FF 19 9A : ... 0001 1001 1001 1010
		LSLS R4, R3, #18   ; R4:  0110 0110 0110 1000 ...
						   ; R4:  66 68 00 00
	;G -------------------------------------------------------------------------
	
		MOV  R5, #0X1234
		MOVT R5, #0XFABC   ; R5:  FA BC 12 34
		ROR  R6, R5, #10   ; R5:  1111 1010 1011 1100 0001 0010 0011 0100
						   ; R6:  1000 1101 0011 1110 1010 1111 0000 0100
						   ; R6:  8D 3E AF 04
	;H -------------------------------------------------------------------------
	
		MOV  R7, #0X4321   ; R7:  00 00 43 21 : 00 ... 0100 0011 0010 0001
		RRXS R8, R7        ; R8:  00 00 21 90 : 00 ... 0010 0001 1001 0000  + FLAG CARRY
		RRXS R9, R8        ; R9:  80 00 10 C8 : 10 ... 0001 0000 1100 1000

; Final do código aqui ---------------------------------------------------------

    NOP
    ALIGN                       	;garante que o fim da seção está alinhada 
    END                         	;fim do arquivo
