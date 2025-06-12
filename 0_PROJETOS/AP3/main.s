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

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>
		IMPORT  GPIO_Init
        IMPORT  PortN_Output
        IMPORT  PortJ_Input
;################################################################################
; Função main()
Start  			
	BL		GPIO_Init					;Chama a subrotina que inicializa os GPIO

MainLoop
	CMP		R4, #1						;Passou pela IRQ?
	BEQ		IRQAtivada					;Sim: ==> Tratar o retorno da IRQ
	B		MainLoop					;Volta para o laço principal	
IRQAtivada
	CMP		R5,#3						;Botão pressionado SW1 Brd Subida
	BEQ		FF_Reset					;
	CMP		R5,#2						;Botão pressionado SW2 Brd descida
	BEQ		FF_Set						;
	B		MainLoop					;outros casos de botões não tratar
FF_Set	
	MOV		R4,#0						;Flag=0
	MOV		R0,#2						;Led ON
	BL		PortN_Output				;Liga Led
	B		MainLoop
FF_Reset
	MOV		R4,#0						;Flag=0
	MOV		R0,#1						;Led OFF
	BL		PortN_Output				;Desliga Led
	B		MainLoop

    ALIGN                        		;Garante que o fim da seção está alinhada 
    END                          		;Fim do arquivo