; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Ex4: Uso de GPIO com interrupçao
; Prof. Guilherme de S. Peron	- 12/03/2018
; Prof. Marcos E. P. Monteiro	- 12/03/2018
; Prof. DaLuz           		- 25/02/2022

;################################################################################
; Este programa espera o usuário apertar a chave USR_SW1 e/ou a chave USR_SW2.
; Caso o usuário pressione a chave USR_SW1, acenderá o LED2. Caso o usuário pressione 
; a chave USR_SW2, acenderá o LED1. Caso as duas chaves sejam pressionadas, os dois 
; LEDs acendem.
;################################################################################

;################################################################################
        THUMB                        ; Instruções do tipo Thumb-2
;################################################################################
; Definições de Valores
BIT0	EQU 2_0001
BIT1	EQU 2_0010
;################################################################################
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		
;################################################################################
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

        EXPORT Start                
									
		; IO							
		IMPORT  GPIO_Init
		IMPORT	UPDATE_LEDS
		
		; TEMPO
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms
; ---------------------------------------------------------------------------------
Start  			

	BL		GPIO_Init					
	BL      PLL_Init
	BL		SysTick_Init
	
	; r1 é a flag pedreste, 0 sem pedestre, 1 com pedetre
	MOV  R10, #0
	MOV R7, #0
	MOV R8, #0
	
	MOV  R0, #100
	BL   SysTick_Wait1ms

MAIN_LOOP

	CMP R10, #1
	BEQ ESTADO1_COM_PEDESTRE

ESTADO1_SEM_PEDESTRE

	MOV  R0, #2_1111
	BL   UPDATE_LEDS
	
	MOV  R0, #1000
	BL   SysTick_Wait1ms

	B ESTADO2

ESTADO1_COM_PEDESTRE

	MOV R7, #2_1010
	MOV R8, #0

SUBROTINA_PEDESTRE
	
	MOV R0, R7
	BL UPDATE_LEDS
	
	MOV  R0, #500
	BL   SysTick_Wait1ms
	
	NEG R7, R7
	SUB R7, #1
	
	CMP   R8, #9
	ADDLT R8, #1
	;BEQ   ESTADO2
	
	BLT   SUBROTINA_PEDESTRE
	
	; reset da flag
	MOV R10, #0

ESTADO2

	MOV  R0, #2_1110
	BL   UPDATE_LEDS
	
	MOV  R0, #6000 
	BL   SysTick_Wait1ms

ESTADO3

	MOV  R0, #2_1101
	BL   UPDATE_LEDS
	
	MOV  R0, #2000 
	BL   SysTick_Wait1ms

ESTADO4

	MOV  R0, #2_1111
	BL   UPDATE_LEDS
	
	MOV  R0, #1000 
	BL   SysTick_Wait1ms

ESTADO5

	MOV  R0, #2_1011
	BL   UPDATE_LEDS
	
	MOV  R0, #6000 
	BL   SysTick_Wait1ms

ESTADO6

	MOV  R0, #2_0111
	BL   UPDATE_LEDS
	
	MOV  R0, #2000 
	BL   SysTick_Wait1ms

	B MAIN_LOOP

    ALIGN                        		;Garante que o fim da seção está alinhada 
    END                          		;Fim do arquivo