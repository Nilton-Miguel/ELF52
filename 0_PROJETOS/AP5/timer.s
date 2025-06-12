; timer.s
; Desenvolvido para a placa EK-TM4C1294XL
; Uso de TIMER com interrupção ...
; Prof. Guilherme de S. Peron	- 06/04/2018
; Prof. Marcos E. P. Monteiro	- 06/04/2018
; Prof. DaLuz           		- 25/02/2022

;################################################################################
        THUMB                        ; Instruções do tipo Thumb-2
;################################################################################
; Definições de Valores
SYSCTL_RCGCTIMER_R		EQU		0x400FE604
SYSCTL_PRTIMER_R        EQU     0x400FEA04
RCGC_TIMER0         	EQU		2_00000001
RCGC_TIMER2         	EQU		2_00000100
; Definições dos Timers = Timer 0
TIMER0_CFG_R			EQU		0x40030000
TIMER0_TAMR_R       	EQU		0x40030004
TIMER0_TBMR_R       	EQU		0x40030008
TIMER0_CTL_R        	EQU		0x4003000C
TIMER0_SYNC_R       	EQU		0x40030010
TIMER0_IMR_R        	EQU		0x40030018
TIMER0_RIS_R        	EQU		0x4003001C
TIMER0_MIS_R        	EQU		0x40030020
TIMER0_ICR_R        	EQU		0x40030024
TIMER0_TAILR_R      	EQU		0x40030028
TIMER0_TBILR_R      	EQU		0x4003002C
TIMER0_TAMATCHR_R   	EQU		0x40030030
TIMER0_TBMATCHR_R   	EQU		0x40030034
TIMER0_TAPR_R       	EQU		0x40030038
TIMER0_TBPR_R       	EQU		0x4003003C
TIMER0_TAPMR_R      	EQU		0x40030040
TIMER0_TBPMR_R      	EQU		0x40030044
TIMER0_TAR_R        	EQU		0x40030048
TIMER0_TBR_R        	EQU		0x4003004C
TIMER0_TAV_R        	EQU		0x40030050
TIMER0_TBV_R        	EQU		0x40030054
TIMER0_RTCPD_R      	EQU		0x40030058
TIMER0_TAPS_R       	EQU		0x4003005C
TIMER0_TBPS_R       	EQU		0x40030060
TIMER0_DMAEV_R      	EQU		0x4003006C
TIMER0_ADCEV_R      	EQU		0x40030070
TIMER0_PP_R         	EQU		0x40030FC0
TIMER0_CC_R         	EQU		0x40030FC8
; Definições dos Timers = Timer 2
TIMER2_CFG_R            EQU		0x40032000
TIMER2_TAMR_R           EQU		0x40032004
TIMER2_TBMR_R           EQU		0x40032008
TIMER2_CTL_R            EQU		0x4003200C
TIMER2_SYNC_R           EQU		0x40032010
TIMER2_IMR_R            EQU		0x40032018
TIMER2_RIS_R            EQU		0x4003201C
TIMER2_MIS_R            EQU		0x40032020
TIMER2_ICR_R            EQU		0x40032024
TIMER2_TAILR_R          EQU		0x40032028
TIMER2_TBILR_R          EQU		0x4003202C
TIMER2_TAMATCHR_R       EQU		0x40032030
TIMER2_TBMATCHR_R       EQU		0x40032034
TIMER2_TAPR_R           EQU		0x40032038
TIMER2_TBPR_R           EQU		0x4003203C
TIMER2_TAPMR_R          EQU		0x40032040
TIMER2_TBPMR_R          EQU		0x40032044
TIMER2_TAR_R            EQU		0x40032048
TIMER2_TBR_R            EQU		0x4003204C
TIMER2_TAV_R            EQU		0x40032050
TIMER2_TBV_R            EQU		0x40032054
TIMER2_RTCPD_R          EQU		0x40032058
TIMER2_TAPS_R           EQU		0x4003205C
TIMER2_TBPS_R           EQU		0x40032060
TIMER2_DMAEV_R          EQU		0x4003206C
TIMER2_ADCEV_R          EQU		0x40032070
TIMER2_PP_R             EQU		0x40032FC0
TIMER2_CC_R             EQU		0x40032FC8

;BITS para configurar os timers:
TIMER_CFG_32_BIT      	EQU		0x00000000  ;configurar timer para modo 32-bits,
											;controlado pelos bits 1:0 de GPTMTAMR e GPTMTBMR
TIMER_CTL_TAEN			EQU		0x00000001  ;GPTM TimerA Enable
TIMER_IMR_TATOIM		EQU		0x00000001  ;GPTM TimerA Time-Out Interrupt Mask
TIMER_ICR_TATOCINT		EQU		0x00000001  ;GPTM TimerA Time-Out Raw Interrupt
TIMER_TAILR_TAILRL_M	EQU		0x0000FFFF  ;GPTM TimerA Interval Load Register Low
TIMER_TAMR_TAMR_PERIOD	EQU		0x00000002	;Modo Periódico
TIMER_TAMR_TAMR_ONESHOT EQU		0x00000001	;Modo One-Shot	
	
; Definições do NVIC
NVIC_EN0_R				EQU		0xE000E100  ;IRQ 0 a 31 Set Enable Register
NVIC_EN0_INT19			EQU		0x00080000  ;Habilitar interruptção
NVIC_PRI4_R				EQU		0xE000E410  ;IRQ 16 a 19 Priority Register
NVIC_PRI5_R				EQU		0xE000E414  ;IRQ 20 a 23 Priority Register
	
;################################################################################
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Timer0A_Init     			;Permite chamar Timer0A_Init de outro arquivo
		EXPORT Timer0A_Handler   			;ISR para o Timer0A
        EXPORT Timer2A_Init     			;Permite chamar Timer2A_Init de outro arquivo
		EXPORT Timer2A_Handler   			;ISR para o Timer2A
		IMPORT PortN_Output
			
		IMPORT PortN_Invertepino0
		IMPORT PortN_Invertepino1
;################################################################################

;################################################################################
; Função Timer2A_Init
; Parâmetro de entrada: R0 com o valor de recarga
;                       Levando-se em conta um clock de 80MHz
; Parâmetro de saída: Não tem
;################################################################################
Timer2A_Init
; 0) habilita o clock para o timer2:
    LDR 	R1, =SYSCTL_RCGCTIMER_R			;carrega o endereço do registrador em R1
    LDR		R2, [R1]                    	;lê o conteúdo do registrador e coloca em R2 para fazer o OR abaixo
    ORR		R2, R2, #RCGC_TIMER2			;escrita amigável               
    STR		R2, [R1]						;atualiza o registrador                  
; 1) esperar o hw ligar:    
	LDR     R3, =SYSCTL_PRTIMER_R			;Carrega o endereço do PRTIMER para esperar o timer ficar online
EsperaTimer2A
	LDR     R1, [R3]						;Lê da memória o conteúdo do endereço do registrador
	MOV     R2, #2_100						;Seta o bit correspondentes ao timer2 para fazer a comparação
    TST     R1, R2							;Testa o R1 com R2 fazendo R1 & R2
    BEQ     EsperaTimer2A				    ;Se o flag Z=1, volta para o laço. Senão continua executando
; 2) desabilitar o timer para poder configurar:
	LDR		R1, =TIMER2_CTL_R				;Carrega o endereço do CTL para poder desabilitar
    LDR		R2, [R1]                    	;lê o conteúdo do registrador e coloca em R2 para fazer o OR abaixo
    ORR		R2, R2, #2_1					;escrita amigável               
    STR		R2, [R1]						;atualiza o registrador
; 3) modo de 32 bits:	
	LDR		R1, =TIMER2_CFG_R				;Carrega o endereço do CFG para poder desabilitar
    LDR		R2, [R1]                    	;lê o conteúdo do registrador e coloca em R2 para fazer o OR abaixo
    ORR		R2, R2, #2_000					;escrita amigável               
    STR		R2, [R1]						;atualiza o registrador
; 4) modo one shot
	LDR		R1, =TIMER2_TAMR_R				;Carrega o endereço do TAMR para modo one shot
    LDR		R2, [R1]                    	;lê o conteúdo do registrador e coloca em R2 para fazer o OR abaixo
    ORR		R2, R2, #2_10					;escrita amigável               
    STR		R2, [R1]						;atualiza o registrador
; 5) Carregar valor da contagem recebido em R0
    LDR		R1, =TIMER2_TAILR_R         	;R1 = &TIMER2_TAILR_R (ponteiro)
    SUB		R0, R0, #1                  	;R0 = R0 - 1 (contar de R0 até 0)
    STR		R0, [R1]                    	;atualiza o regitrador	
; 6) Sem preescaler, deixar o GPTMTAPR zerado
    LDR		R1, =TIMER2_TAPR_R         		;R1 = &TIMER2_TAPR_R (ponteiro)
    MOV		R0, #0x0000                		;R0 = 0x00
    MOVT	R0, #0x0000                		;R0 = 0x00
    STR		R0, [R1]                    	;atualiza o regitrador	
; 7) Utilizar o Timer_2_A - limpar o flag
	LDR		R1, =TIMER2_ICR_R				;Carrega o endereço do Registrador
    LDR		R2, [R1]                    	;lê o conteúdo do registrador e coloca em R2 para fazer o OR abaixo
    ORR		R2, R2, #2_1					;escrita amigável               
    STR		R2, [R1]						;atualiza o registrador
; 8) ligar a interrupção de timeout
    LDR		R1, =TIMER2_IMR_R           	;R1 = &TIMER2_IMR_R (pointeiro)
    LDR		R2, =0x00000001       			;R2 = 2_1
    STR		R2, [R1]                    	;[R1] = R2
; 8.b) setar a interrupção 23 no NVIC para prio2
    LDR		R1, =NVIC_PRI5_R            	;R1 = &NVIC_PRI5_R (pointeiro)
    MOV		R0, #4
	LSL 	R0, R0, #29						;NVIC_PRI5_R = 4 << 29;
    STR		R0, [R1]                    	;[R1] = R2	
; 8.c) habilitar interrupção 23 no NVIC
    LDR		R1, =NVIC_EN0_R             	;R1 = &NVIC_EN0_R (pointeiro)
	LDR		R0, =0x00000000					;R0 = 0;
	MOV 	R0, #1							;bit = 1 
	LSL 	R0, R0, #23						;habilita int 23
    STR		R0, [R1]                    	;[R1] = R2
; 9) habilitar timer2A
    LDR		R1, =TIMER2_CTL_R           	;R1 = &TIMER0_CTL_R (pointeiro)
    LDR		R2, [R1]                    	;R2 = [R1] = TIMER0_CTL_R (valor)
    ORR		R2, R2, #2_1     				;R2 = R2 | 2_1 (setar o bit de enable)
    STR		R2, [R1]                    	;[R1] = R2

	BX		LR

;################################################################################
; Timer2A_Handler
; Rotina de tratamento de Interrupção
;################################################################################
Timer2A_Handler
; acknowledge para o timeout timer0A
	LDR		R1, =TIMER2_ICR_R           	;R1 = &TIMER0_ICR_R (ponteiro)
    LDR		R0, =TIMER_ICR_TATOCINT     	;R0 = TIMER_ICR_TATOCINT (valor)
    STR		R0, [R1]                    	;[R1] = R0
; pisca LED
	PUSH	{LR}
	BL		PortN_Invertepino1				;Chama a rotina que faz um toggle no led
    POP		{PC}              				;retorno da interrupção	

;################################################################################
; Função Timer0A_Init
; Parâmetro de entrada: R0 com o valor de recarga
;                       Levando-se em conta um clock de 80MHz
; Parâmetro de saída: Não tem
;################################################################################
Timer0A_Init
; 0) ativa o clock para o Timer0
    LDR 	R1, =SYSCTL_RCGCTIMER_R     	;carrega o endereço em R1
    LDR		R2, [R1]                    	;lê o conteúdo e coloca em R2 para fazer o OR abaixo
    ORR		R2, R2, #RCGC_TIMER0               
    STR		R2, [R1]                  
    NOP
    NOP 
    NOP
    NOP    
; 1) desabilita timer0A durante a config
    LDR		R1, =TIMER0_CTL_R           	;R1 = &TIMER0_CTL_R (ponteiro)
    LDR		R2, [R1]                    	;R2 = [R1] = TIMER0_CTL_R (value)
    BIC		R2, R2, #TIMER_CTL_TAEN     	;R2 = R2&~TIMER_CTL_TAEN (limpa o bit de enable)
    STR		R2, [R1]
; 2) configurar para o modo 32 bits
    LDR		R1, =TIMER0_CFG_R           	;R1 = &TIMER0_CFG_R (ponteiro)
    LDR		R2, =TIMER_CFG_32_BIT       	;R2 = TIMER_CFG_32_BIT (valor)
    STR		R2, [R1]                    	;[R1] = R2    
; 3) configurar para modo periódico
    LDR		R1, =TIMER0_TAMR_R          	;R1 = &TIMER0_TAMR_R (ponteiro)
    LDR		R2, =TIMER_TAMR_TAMR_PERIOD 	;R2 = TIMER_TAMR_TAMR_PERIOD (valor)
    STR		R2, [R1]                    	;[R1] = R2
; 4) valor de recarga que está no R0 como parâmetro
    LDR		R1, =TIMER0_TAILR_R         	;R1 = &TIMER0_TAILR_R (pointer)
    SUB		R0, R0, #1                  	;R0 = R0 - 1 (counts down from R0 to 0)
    STR		R0, [R1]                    	;[R1] = R0	
; 5) prescale não usado em 32 bits
; 6) limpar o flag de timeout do timer0A 
    LDR		R1, =TIMER0_ICR_R           	;R1 = &TIMER0_ICR_R (ponteiro)
    LDR		R2, =TIMER_ICR_TATOCINT     	;R2 = TIMER_ICR_TATOCINT (valor)
    STR		R2, [R1]                    	;[R1] = R2 
; 7) ligar a interrupção de timeout
    LDR		R1, =TIMER0_IMR_R           	;R1 = &TIMER0_IMR_R (pointeiro)
    LDR		R2, =TIMER_IMR_TATOIM       	;R2 = TIMER_IMR_TATOIM (valor)
    STR		R2, [R1]                    	;[R1] = R2
; 8) setar a interrupção 19 no NVIC para prio2
    LDR		R1, =NVIC_PRI4_R            	;R1 = &NVIC_PRI4_R (pointeiro)
    LDR		R2, [R1]                    	;R2 = [R1] = NVIC_PRI4_R (valor)
    AND		R2, R2, #0x00FFFFFF         	;R2 = R2&0x00FFFFFF (limpar a prioridade da interrupção 19)
    ORR		R2, R2, #0x40000000         	;R2 = R2|0x40000000 (prioridade da interrupção 19 está nos bits 31-29)
    STR		R2, [R1]                    	;[R1] = R2	
; 9) habilitar interrupção 19 no NVIC
    LDR		R1, =NVIC_EN0_R             	;R1 = &NVIC_EN0_R (pointeiro)
    LDR		R2, =NVIC_EN0_INT19         	;R2 = NVIC_EN0_INT19 (interrupção 19 habilitada) (valor)
    STR		R2, [R1]                    	;[R1] = R2
; 10) habilitar timer0A
    LDR		R1, =TIMER0_CTL_R           	;R1 = &TIMER0_CTL_R (pointeiro)
    LDR		R2, [R1]                    	;R2 = [R1] = TIMER0_CTL_R (valor)
    ORR		R2, R2, #TIMER_CTL_TAEN     	;R2 = R2|TIMER_CTL_TAEN (setar o bit de enable)
    STR		R2, [R1]                    	;[R1] = R2

	BX		LR
	
;################################################################################
; Timer0A_Handler
; Rotina de tratamento de Interrupção
;################################################################################
Timer0A_Handler
; acknowledge para o timeout timer0A
	LDR		R1, =TIMER0_ICR_R           	;R1 = &TIMER0_ICR_R (ponteiro)
    LDR		R0, =TIMER_ICR_TATOCINT     	;R0 = TIMER_ICR_TATOCINT (valor)
    STR		R0, [R1]                    	;[R1] = R0
; pisca LED
	PUSH	{LR}
	BL		PortN_Invertepino0				;Chama a rotina que faz um toggle no led
    POP		{PC}              				;retorno da interrupção	
	
    ALIGN                           		;garante que o fim da seção está alinhada 
    END                             		;fim do arquivo