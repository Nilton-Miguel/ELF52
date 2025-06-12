; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Ex. timer2 contando 700ms 1x com interrupção
; Prof. Guilherme de S. Peron	- 12/03/2018
; Prof. Marcos E. P. Monteiro	- 12/03/2018
; Prof. DaLuz           		- 25/02/2022

;################################################################################
; Configurar o timer0 para alternar um led a cada 500ms com IRQ. Modo: periódico
; Configurar o timer2 para ascender um led após 700ms apenas uma vez com IRQ
; Modo: One Shot
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
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms			
		IMPORT  GPIO_Init
        IMPORT  PortN_Output
        IMPORT  PortJ_Input	
		IMPORT  Timer0A_Init
		IMPORT  Timer2A_Init
;################################################################################
; Função main()
Start  		
	BL		PLL_Init				;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL		SysTick_Init
	BL		GPIO_Init				;Chama a subrotina que inicializa os GPIO
	
	LDR		R0, =36000000           ;Carrega o R0 como parâmetro de entrada para o timer estourar a 450ms periódico
	BL		Timer0A_Init

	LDR		R0, =60000000			;Carrega o R0 como parâmetro de entrada para o timer estourar após 750ms one shot
	BL		Timer2A_Init

MainLoop
	B MainLoop						;Volta para o laço principal

    ALIGN							;Garante que o fim da seção está alinhada 
    END								;Fim do arquivo