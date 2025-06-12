
; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Esquele de um novo Projeto para Keil
; Prof. Guilherme de S. Peron	- 12/03/2018
; Prof. Marcos E. P. Monteiro	- 12/03/2018
; Prof. DaLuz           		- 25/02/2022
;---------------------------------------------------------------------------------
	
; CHAMAR N
LED1 EQU 0X40
LED2 EQU 0X20
	
; CHAMAR F
LED3 EQU 0X10
LED4 EQU 0X1

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

MAIN

	

	BL UPDATE_LEDS
	
	B MAIN
;---------------------------------------------------------------------
UPDATE_LEDS
	
	PUSH {R6}
	
	MOV R6, R0
	AND R0, R0, #0X1F
	
	PUSH {LR}
	BL  PortF_Output
	POP {LR}
	
	MOV R0, R6

	LSR R0, R0, #5
	
	PUSH {LR}
	BL  PortN_Output
	POP {LR}
	
	POP {R6}
	
	BX LR
;---------------------------------------------------------------------

    NOP
    ALIGN                       	
    END                         	
