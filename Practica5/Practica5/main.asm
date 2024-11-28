
; Practica5.asm

	.def temp = r16
	.def temp2 = r17
	.def temp3 = r18
	.def mux = r19
	.def unidad = r20
	.def decena = r21
	.def centena = r22
	.def uni_aux = r23
	.def dec_aux = r24
	.def cen_aux = r25
	.def temp4 = r2
	.cseg 

	.org 0
	jmp reset

	jmp int_0

	.org $012
	jmp timer2_ovf

	.org $016
	jmp timer1_COMPA

	.org $020
	jmp timer0_ovf


reset:
	; CONFIGURACION DE PUERTOS
	ldi temp, $FB ;1111 1011
	out DDRD, temp ;Configuramos puerto D como salida, menos D2 

	ldi temp, $20 ;0010 0000 
	out DDRB, temp ;Configuramaos B5 como salida

	ldi temp, $04 
	out PORTD, temp ;Habilitamos PULL-UP en D2

	ldi temp, $03
	out PORTB, temp ; Habilitamos PULL-UP en B0 y B1 

	ldi temp, $07 ;0000 0111
	out DDRC, temp; Configuramos C0, C1, C2 como salidas		

	
	; CONFIGURACION DE TIMERS E INTERRUPCIONES
	; TIMER0_OVF
	ldi temp, $03
	out tccr0b, temp ;seleccionamos modo normal y prescaler = 64
	
	ldi temp, $01
	sts timsk0, temp ;habilitamos interrupcion por sobreflujo

	; INT0 POR FLANCOS DE SUBIDA
	ldi temp, $03
	sts EICRA, temp ;Configuramos la deteccion de flancos de subida 

	ldi temp, $01
	out EIMSK, temp ;Habilitamos el INT0 (interrupcion externa 0)

	; TIMER2_OVF		
	ldi temp, $01 
	sts TIMSK2, temp ;Configuramos timer2 por sobreflujo

	;TIMER1_COMPA
	ldi temp, $0C ;Prescaler de 256 y modo de comparacion
	sts TCCR1B, temp 

	ldi temp, $F4 ; VALOR DE COMPARACION = 62500 = $F424
	sts OCR1AH, temp ;Primero escribimos la parte alta del comparacion

	ldi temp, $24
	sts OCR1AL, temp ;Luego podemos escribir la parte baja del valor comparacion

	ldi temp, $02
	sts TIMSK1, temp ;Habilitamos modo de comparacion 


	; INICIALIZACION DE REGISTROS
	ldi unidad, 0
	ldi decena, 0
	ldi centena, 0
	ldi uni_aux, 0
	ldi dec_aux, 0
	ldi cen_aux, 0
	ldi mux, $01 ;PARA ANODO COMUN

	; CARGA EN MEM DE PROGRAMA
	ldi ZL, low(display7s*2)
	ldi ZH, high(display7s*2)
	ldi XH, $01
	ldi XL, $00

	ldi temp, $0C

lazo: 
	lpm temp2, z+ ;Carga en memoria de programa cada valor para el display
	st x+, temp2 ;Almacena los valores en memoria de datos
	dec temp
	brne lazo
	
	sei

main:	
	in temp, PINB
	andi temp, $03
	breq f_1024

	cpi temp, $01
	breq f_256

	cpi temp, $02
	breq f_64

	jmp f_32


; CAMBIO DE PRESCALER para TCCR2B
f_1024:
	ldi temp, $07
	sts TCCR2B, temp
	jmp main

f_256:
	ldi temp, $06
	sts TCCR2B, temp
	jmp main

f_64:
	ldi temp, $04
	sts TCCR2B, temp
	jmp main

f_32:
	ldi temp, $03
	sts TCCR2B, temp
	jmp main


; INTERRUPCION EXTERNA
int_0: 
	inc unidad
	cpi unidad, $0A
	breq reset_unidad
	sbi EIFR, 0
	reti

reset_unidad: 
	ldi unidad, $00
	inc decena
	cpi decena, $0A
	breq reset_decena
	sbi EIFR, 0
	reti

reset_decena:
	ldi decena, $00
	inc centena
	cpi centena, $0A
	brge error
	sbi EIFR, 0
	reti

error:
	ldi unidad, $0B
	ldi decena, $0B
	ldi centena, $0A
	sbi EIFR, 0
	reti


; MULTIPLEXEO DE LOS DISPLAYS CATODO COMUN
timer0_ovf:
	ldi temp3, $00
	out PORTC, temp3 ;Apaga displays

	cpi mux, $02
	breq mux_decena ;Caso para decena

	cpi mux, $04
	breq mux_centena

	; Caso para unidad (mux_undidad)
	mov r26, uni_aux
	ld temp3, x
	sbis PIND, 2
	cbi PIND, 2
	out PORTD, temp3
	out PORTC, mux
	ldi mux, $02
	reti

mux_decena: 
	mov r26, dec_aux
	ld temp3, x
	sbis PIND, 2
	cbi PIND, 2
	out PORTD, temp3
	out PORTC, mux
	ldi mux, $04
	reti

mux_centena: 
	mov r26, cen_aux
	ld temp3, x
	sbis PIND, 2
	cbi PIND, 2
	out PORTD, temp3
	out PORTC, mux
	ldi mux, $01
	reti


; REALIZA EL TOGGLE PARA LAS FRECUENCIAS
timer2_ovf:
	in temp2, PINB
	com temp2
	andi temp2, $20
	ori temp2, $03
	out PORTB, temp2
	reti


; REGISTRO DE COMPARACION PARA VENTANA DE 1SEG
timer1_COMPA:
	mov uni_aux, unidad
	mov dec_aux, decena
	mov cen_aux, centena
	
	ldi unidad, 0
	ldi decena, 0
	ldi centena, 0
	reti

display7s:
	.db $80, $F1, $48, $60, $31, $22, $02, $F0, $00, $20, $0A, $5B
	;     0,   1,   2,   3,   4,   5,   6,   7,   8,   9,   E,  r
	;                                                       0A, 0B


