; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Ex. timer2 contando 700ms 1x com interrup��o
; Prof. Guilherme de S. Peron	- 12/03/2018
; Prof. Marcos E. P. Monteiro	- 12/03/2018
; Prof. DaLuz           		- 25/02/2022

;################################################################################
; Configurar o timer0 para alternar um led a cada 500ms com IRQ. Modo: peri�dico
; Configurar o timer2 para ascender um led ap�s 700ms apenas uma vez com IRQ
; Modo: One Shot
;################################################################################

;################################################################################
        THUMB                        ; Instru��es do tipo Thumb-2
;################################################################################
		
; Defini��es de Valores
BIT0	EQU 2_0001
BIT1	EQU 2_0010
;################################################################################
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		

;################################################################################
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms			
		IMPORT  GPIO_Init
        IMPORT  PortN_Output
        IMPORT  PortJ_Input	
		IMPORT  Timer0A_Init
		IMPORT  Timer2A_Init
;################################################################################
; Fun��o main()
Start  		
	BL		PLL_Init				;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL		SysTick_Init
	BL		GPIO_Init				;Chama a subrotina que inicializa os GPIO
	
	LDR		R0, =36000000           ;Carrega o R0 como par�metro de entrada para o timer estourar a 450ms peri�dico
	BL		Timer0A_Init

	LDR		R0, =60000000			;Carrega o R0 como par�metro de entrada para o timer estourar ap�s 750ms one shot
	BL		Timer2A_Init

MainLoop
	B MainLoop						;Volta para o la�o principal

    ALIGN							;Garante que o fim da se��o est� alinhada 
    END								;Fim do arquivo