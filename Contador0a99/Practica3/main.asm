	;Practica 3

	.def temp = r16
	.def cont1 = r17
	.def cont2 = r18
	.def unidad = r19
	.def decena = r20
	.def mux = r21
	.def flag = r22
	.def temp2 = r23
	.def cont3 = r24
	.def temp3 = r25
	.cseg

	.org 0
	jmp reset 

	.org $020
	jmp timer0_ovf

reset:
	ldi temp, $FF
	out DDRD, temp ;Configuramos puerto D como salida

	ldi temp, $03
	out DDRC, temp; Configuramos C0 y C1 como salidas

	ldi temp, $00
	out DDRB, temp ;Configuramos PORTB como entrada 

	ldi temp, $03
	out PORTB, temp ;Configuramos B0 y B1 habilitando PULL-UP

	;Inicializamos registros extendidos
	ldi ZL, low(display7s*2)
	ldi ZH, high(display7s*2)
	ldi XL, $00
	ldi XH, $01
		
	ldi temp, $03
	out tccr0b, temp ;seleccionamos modo normal y prescaler = 64
	
	ldi temp, $01
	sts timsk0, temp ;habilitamos interrupcion por sobreflujo

	ldi unidad, $00
	ldi decena, $00
	ldi mux, $01 ;PARA ANODO COMUN
	ldi flag, $00

	sei
	ldi temp, $0A

lazo: 
	lpm temp2, z+ ;Carga en memoria de programa cada valor para el display
	st x+, temp2 ;Almacena los valores en memoria de datos
	dec temp
	brne lazo

main:	
	in temp, PINB ;Leemos botones
	andi temp, $03
	cpi temp, $03
	breq main

	in temp2, PINB ;Leemos botones
	andi temp2, $03
	cpi temp2, $01
	breq com_flag ;PORTB == $01, invierte flag

	in temp3, PINB ;Leemos botones 
	andi temp3, $03
	cpi temp3, $02		   
	breq suma_resta ;PORTB == $02, cambia valores

	jmp main

suma_resta:
	call delay_30ms
	cpi flag, $FF 
	breq decrementar
	jmp incrementar

com_flag:
	call delay_30ms
	com flag

espera: 
	call delay_30ms
	in temp2, PINB ;Leemos botones
	andi temp2, $03
	cpi temp2, $01
	breq espera
	call delay_30ms

	in temp3, PINB ;Leemos botones 
	andi temp3, $03
	cpi temp3, $02
	breq espera
	call delay_30ms
	
	jmp main

incrementar: 
	inc unidad
	cpi unidad, $0A
	breq reset_unidad
	jmp espera

reset_unidad: 
	ldi unidad, $00
	inc decena
	cpi decena, $0A
	brne espera
	ldi decena, $00
	jmp espera
	
decrementar: 
	dec unidad
	cpi unidad, $FF
	breq reset_unidad_0
	jmp espera

reset_unidad_0:
	ldi unidad, $09
	dec decena
	cpi decena, $FF
	brne espera
	ldi decena, $09
	jmp espera

delay_30ms: 
	ldi cont1, 250
lazo2_30ms: 
	ldi cont2, 200
lazo1_30ms: 
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec cont2
	brne lazo1_30ms
	dec cont1
	brne lazo2_30ms
	ret

timer0_ovf:
	ldi temp3, $00
	out PORTC, temp3 ;Apaga displays

	cpi mux, $01
	brne mux_decena ;Caso para decena

	; Caso para unidad (mux_undidad)
	mov r26, unidad
	ld temp3, x
	out PORTD, temp3
	out PORTC, mux
	ldi mux, $02
	reti

mux_decena: 
	mov r26, decena
	ld temp3, x
	out PORTD, temp3
	out PORTC, mux
	ldi mux, $01
	reti

display7s:
	.db $03, $9F, $25, $0D, $99, $49, $41, $1F, $01, $09 ;Valores para display7s anodo comun
