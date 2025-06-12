
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
	
	; inicializa tudo que precisa
	BL GPIO_Init
	BL PLL_Init
	BL SysTick_Init

;---------------------------------------------------------------------
	
	; r8 guarda o estado do ciclo anterior dos botoes
	MOV R8,  #0X03
	
	; r9 pro contador
	MOV R9,  #0
	
	; r10 pro passeio
	MOV R10, #8
	
	; r11: primeiro endereco na ROM com o array de velocidades
	LDR R11, =ROM_VELOCIDADES
	
	; tempo de espera pra garantir inicializacao correta
	PUSH {R0}
	MOV R0, #100
	BL SysTick_Wait1ms
	POP {R0}
	
	; contador: modo padrao
	B CONTADOR

;---------------------------------------------------------------------
SOLDADO_IDA
	
	; checa o botao no comeco do ciclo
	BL UPDATE_BOTAO
	
	; acende os LEDs
	MOV R0, R10
	BL  UPDATE_LEDS
	
	; checa se ja chegou no D4 e pula pra volta se sim
	CMP R10, #1
	BEQ SOLDADO_VOLTA
	
	; se nao chegou ainda, desloca pra direita
	LSR R10, R10, #1
	
	; tempo de espera, que ele ve no ponteiro pra ROM
	PUSH {R0}
	LDRH R0, [R11]
	BL SysTick_Wait1ms
	POP {R0}
	
	; chama o proximo ciclo
	B SOLDADO_IDA

SOLDADO_VOLTA
	
	; checa o botao no comeco do ciclo
	BL UPDATE_BOTAO
	
	; acende os LEDs
	MOV R0, R10
	BL  UPDATE_LEDS
	
	; checa se ja chegou no D1 e pula pra ida se sim
	CMP R10, #8
	BEQ SOLDADO_IDA
	
	; se nao chegou ainda, desloca pra esquerda
	LSL R10, R10, #1
	
	; tempo de espera, que ele ve no ponteiro pra ROM 
	PUSH {R0}
	LDRH R0, [R11]
	BL SysTick_Wait1ms
	POP {R0}
	
	; chama o proximo ciclo
	B SOLDADO_VOLTA

;---------------------------------------------------------------------
CONTADOR

	; contador nao checa overflow, porque so ter 4 bits garante
	; que a contagem seja ciclica
	
	; checa o botao no comeco do ciclo
	BL UPDATE_BOTAO
	
	; acende os LEDs
	MOV R0, R9
	BL UPDATE_LEDS
	
	; r9 armazena o valor atual da contagem, um incremento de 1
	ADD R9, R9, #1
	
	; tempo de espera, que ele ve no ponteiro pra ROM 
	PUSH {R0}
	LDRH R0, [R11]
	BL SysTick_Wait1ms
	POP {R0}
	
	; chama o proximo ciclo
	B CONTADOR
	
;---------------------------------------------------------------------

UPDATE_LEDS
; assume o valor a ser convertido em LEDs no r0-----------------------
;---------------------------------------------------------------------

	PUSH {R6-R7}
	
	; r0: o numero completo
	
	; r6: bit 0, mascarado
	MOV R6, R0
	AND R6, R6, #1
	
	; r7: bit 1, mascarado
	MOV R7, R0
	AND R7, R7, #2
	LSL R7, R7, #3
	
	; r6 tem o exato argumento pra PortF_Output, por causa dessa soma
	ADD R6, R6, R7
	
	; logo depois de mascarar e somar, chamar o port f
	PUSH {R0}
	MOV R0, R6
	PUSH {LR}
	BL PortF_Output
	POP {LR}
	POP {R0}
	
	; ---------------------------------------------------------------
	
	; pro port N so precisa de deslocamento para a direita
	
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

UPDATE_BOTAO
; assume o estado anterior do botao esta em r8 -----------------------
;---------------------------------------------------------------------
	
	; joga pra r0 a leitura atual
	; joga pro r8 o que sera a anterior no proximo ciclo
	PUSH  {LR}
	BL  PortJ_Input
	POP {LR}
	
	; compara o estado desse ciclo com o ciclo anterior
	; essa comparacao dar diferente sugere que houve 
	; borda em algum dos botoes
	
	CMP R0, R8
	MOV R8, R0
	; se nao houve borda, va direto pra saida
	BEQ SAIDA
	
	; fluxograma do teste dos botoes
	;
	; 1.   deteccao de alguma borda
	; 2.   esperar o periodo de debouncing
	; 3.   isolar os dois bits dos botoes
	; 4.   testar se botao de velocidade esta apertado
	; 4.1. se sim, rodar subrotina de mudanca velocidade
	; 5.   testar se botao de modo esta apertado
	; 5.1. se sim, rodar subrotina de mudanca de modo
	; 6.   fim

BORDA 
	
	; esperar um periodo de debouncing
	MOV R0, #10
	PUSH  {LR}
	BL SysTick_Wait1ms
	POP {LR}
	
	; checar de novo
	PUSH  {LR}
	BL  PortJ_Input
	POP {LR}
	MOV R2, R0
	
	; isolamos por mascaras os bits dos 2 botoes em registradores separados
	; VELOCIDADE
	AND R0, #0X02
	; MODO
	AND R2, #0X01

TESTE_VELOCIDADE
	CMP R0, #0X00
	BEQ SW2_VELOCIDADE_APERTADO 

TESTE_MODO
	CMP R2, #0X00
	BEQ SW1_MODO_APERTADO 
	B   SAIDA

; subrotina de mudanca de modo
SW1_MODO_APERTADO
	
	; testes para saber de qual subrotina a mudanca de estado foi chamada
	; para saber para qual modo ele precisa mudar
	
	; testa se veio de soldado ida, se sim, vai para contador
	LDR   R0, =SOLDADO_VOLTA
	CMP   LR, R0
	LDRLT LR, =CONTADOR
	BLT SAIDA
	
	; testa se veio de soldado volta, se sim, vai para contador
	LDR   R0, =CONTADOR
	CMP   LR, R0
	LDRLT LR, =CONTADOR
	BLT SAIDA
	
	; testa se veio de contador, se sim, vai para soldado ida
	LDR   LR, =SOLDADO_IDA
	B SAIDA

; subrotina de mudanca de velocidade
SW2_VELOCIDADE_APERTADO
	
	; se foi pedida uma mudanca de velocidade, avanca o ponteiro na ROM
	; dois enderecos, se chegou no primeiro endereco que nao seja da lista
	; o ponteiro volta para o inicio e recomeca o ciclo
	ADD    R11, #2
	LDR    R0, =ROM_TAMPA
	CMP    R11, R0
	LDREQ  R11, =ROM_VELOCIDADES
	
	B TESTE_MODO

SAIDA

	BX  LR
;---------------------------------------------------------------------

; lista de possiveis velocidades na ROM
ROM_VELOCIDADES

	DCW 500, 1000, 100

; primeiro valor que nao seja uma velocidade
ROM_TAMPA

	DCW 69
;---------------------------------------------------------------------
    NOP
    ALIGN                       	
    END                         	
