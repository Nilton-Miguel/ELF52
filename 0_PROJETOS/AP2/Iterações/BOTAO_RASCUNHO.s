
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
		
	IMPORT PLL_Init
	IMPORT SysTick_Init
	IMPORT SysTick_Wait1ms
;--------------------------------------------------------------------

Start
	
	; inicializa tudo que precisa para o GPIO funcionar
	BL GPIO_Init
	
	BL PLL_Init
	BL SysTick_Init

;---------------------------------------------------------------------

	MOV R0, #0
	MOV R8, #0X03
	
	; tempo de espera 1s
	PUSH {R0}
	MOV R0, #10
	BL SysTick_Wait1ms
	POP {R0}
	
	B CONTADOR

;---------------------------------------------------------------------
SOLDADO_IDA

	BL  UPDATE_LEDS
	CMP R0, #1
	BEQ SOLDADO_VOLTA
	
	LSR R0, R0, #1
	
	; tempo de espera 1s
	PUSH {R0}
	MOV R0, #1000
	BL SysTick_Wait1ms
	POP {R0}
	
	B SOLDADO_IDA

SOLDADO_VOLTA

	BL  UPDATE_LEDS
	CMP R0, #8
	BEQ SOLDADO_IDA
	
	LSL R0, R0, #1
	
	; tempo de espera 1s
	PUSH {R0}
	MOV R0, #1000
	BL SysTick_Wait1ms
	POP {R0}
	
	B SOLDADO_VOLTA

;---------------------------------------------------------------------
CONTADOR
	
	PUSH  {R0}
	BL  PortJ_Input
	CMP R0, R8
	BEQ SEM_BORDA
	
	;------------------------------------------------
	
	PUSH {R0}
	MOV R0, #10
	BL SysTick_Wait1ms
	BL  PortJ_Input
	AND R0, #0X02
	CMP R0, #0X00
	BNE SOLTO
	
APERTADO
	
	B APERTADO

SOLTO

	POP {R0}
	
	;------------------------------------------------
	
SEM_BORDA
	
	MOV R8, R0
	POP {R0}
	;------------------------------------------------

	BL UPDATE_LEDS
	
	ADD R0, R0, #1
	
	; tempo de espera 0.5s
	PUSH {R0}
	MOV R0, #1000
	BL SysTick_Wait1ms
	POP {R0}
	
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


; retorna em r1 o 
;---------------------------------------------------------------------

    NOP
    ALIGN                       	
    END                         	
