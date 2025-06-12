
; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Esquele de um novo Projeto para Keil
; Prof. Guilherme de S. Peron	- 12/03/2018
; Prof. Marcos E. P. Monteiro	- 12/03/2018
; Prof. DaLuz           		- 25/02/2022
;---------------------------------------------------------------------------------

	AREA    |.text|, CODE, READONLY, ALIGN=2
	THUMB

    EXPORT Start					
									
	IMPORT GPIO_Init            
	IMPORT PortF_Output			
	IMPORT PortJ_Input
	IMPORT PortN_Output
;--------------------------------------------------------------------

Start
	
	; inicializa tudo que precisa para o GPIO funcionar
	BL GPIO_Init

;---------------------------------------------------------------------

	MOV R0, #0
	B CONTADOR

;---------------------------------------------------------------------
SOLDADO_IDA

	BL  UPDATE_LEDS
	CMP R0, #1
	BEQ SOLDADO_VOLTA
	
	LSR R0, R0, #1
	
	B SOLDADO_IDA

SOLDADO_VOLTA

	BL  UPDATE_LEDS
	CMP R0, #8
	BEQ SOLDADO_IDA
	
	LSL R0, R0, #1
	
	B SOLDADO_VOLTA

;---------------------------------------------------------------------
CONTADOR

	BL UPDATE_LEDS
	
	ADD R0, R0, #1
	
	B CONTADOR
	
;---------------------------------------------------------------------

UPDATE_LEDS
; ASSUMIR NÚMERO A S REPRESENTAR NO R0
	
	PUSH {R6-R7}
	
	; PARA O PORT F
	
	; r0 é o número completo
	
	; r6 é o bit 0
	MOV R6, R0
	AND R6, R6, #1
	
	; r7 é o bit 1
	MOV R7, R0
	AND R7, R7, #2
	LSL R7, R7, #3
	
	; r6 tem o exato argumento pra PortF_Output
	ADD R6, R6, R7
	
	PUSH {R0}
	MOV R0, R6
	PUSH {LR}
	BL PortF_Output
	POP {LR}
	POP {R0}
	
	; ---------------------------------------------------------------
	
	MOV R6, R0
	AND R6, R6, #0X0F
	LSR R6, R6, #2
	
	PUSH {R0, LR}
	MOV R0, R6
	BL PortN_Output
	POP {R0, LR}
	
	POP {R6-R7}
	
	BX LR
;---------------------------------------------------------------------

    NOP
    ALIGN                       	
    END                         	
