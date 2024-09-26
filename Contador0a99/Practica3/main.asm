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

	ldi temp, $03 
	out PORTB, temp ;Configuramos B0 y B1 como entrada habilitando PULL-UP

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
	jmp main

timer0_ovf:	
	in temp, PINB ;Leemos botones
	andi temp, $01 
	breq com_flag ;PORTB == $01, invierte flag

	in temp, PINB ;Leemos botones
	andi temp, $02
	breq suma_resta ;PORTB == $02, cambia valores

	in temp, PINB ;Leemos botones
	andi temp, $03
	brne timer0_ovf ;PORTB == $02, cambia valores

prueba:
	ldi temp, $05
	out portd, temp
	ldi temp, $03
	out portc, temp
	call delay_30ms
	ret

suma_resta:
	cpi flag, $00 
	brne decrementar
	breq incrementar

com_flag: 
	call delay_30ms
	com flag
	call espera
	jmp timer0_ovf

espera: ;Espera a que B sea igual a uno, es decir, que se solto el boton
	jmp muxeo
	in temp, PINB ;Leemos el boton
	andi temp, $01 ;Verificamos si botones estan presionados
	breq espera 

	in temp, PINB ;Leemos el boton	
	andi temp, $02 ;Verificamos si botones estan presionados
	breq espera 

	in temp, PINB ;Leemos el boton
	andi temp, $03 ;Verificamos si botones estan presionados
	breq espera 
	
	call delay_30ms
	
	jmp timer0_ovf

incrementar: 
	call delay_30ms
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
	call delay_30ms
	dec unidad
	cpi unidad, $00
	breq reset_unidad_0
	jmp espera

reset_unidad_0:
	ldi unidad, $0A
	dec decena
	cpi decena, $00
	brne espera
	ldi decena, $0A
	jmp espera

delay_30ms: 
	ldi cont1, 200
lazo2_30ms: 
	ldi cont2, 250
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

delay_1ms: 
	ldi cont3, 10
lazo3_1ms:
	ldi cont2, 10
lazo2_1ms:
	ldi cont1, 16
lazo1_1ms:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec cont1
	brne lazo1_1ms
	dec cont2
	brne lazo2_1ms
	dec cont3
	brne lazo3_1ms
	ret

muxeo:
	ldi temp, $00
	out PORTC, temp ;Apaga displays
	call delay_1ms

	cpi mux, $01
	brne mux_decena ;Caso para decena

	; Caso para unidad (mux_undidad)
	mov r26, unidad
	ld temp, x
	out PORTD, temp
	out PORTC, mux
	call delay_1ms
	ldi mux, $02
	reti

mux_decena: 
	mov r26, decena
	ld temp, x
	out PORTD, temp
	out PORTC, mux
	call delay_1ms
	ldi mux, $01
	reti

display7s:
	;.db $03, $9F, $25, $0D, $99, $49, $41, $1F, $01, $09 ;Valores para display7s anodo comun
	.db $03, $9F, $25, $03, $9F, $25, $03, $9F, $25, $03 ;Valores para display7s anodo comun
