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
	jmp reset ; vamos a reset

	.org $020
	jmp timer0_ovf ;Habilitamos timer de overflow

reset:
	ldi temp, $FF
	out DDRD, temp ;Configuramos puerto D como salida

	ldi temp, $03
	out DDRC, temp; Configuramos C0 y C1 como salidas

	;Nota: Aqui solo habilitamos pull up porque recuerda que en el reset por default todos son entradas
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

	ldi temp, $0A ;Cuenta 10 sobreflujos?
lazo: 
	lpm temp2, z+ ;Carga en memoria de programa cada valor para el display
	st x+, temp2 ;Almacena los valores en memoria de datos
	dec temp
	brne lazo

	;sei ;habilita interrupcion global

main: 
	cpi flag, $00 
	brne decrementar

	in temp, PINB ;Leemos botones
	cpi temp, $02 
	breq incrementar ;PORTB == $02, incrementa

	in temp, PINB ;Leemos botones
	cpi temp, $01 
	breq com_flag ;PORTB == $01, invierte flag

	sei

	jmp main

com_flag: 
	;call delay_30ms
	com flag
	jmp main

espera: ;Espera a que B sea igual a uno, es decir, que se solto el boton
	in temp, PINB ;Leemos el boton
	cpi temp, $03 ;Verificamos si ambos botones estan presionados
	breq espera 
	ret
	;call delay_30ms

incrementar: 
	;call delay_30ms
	inc unidad
	call espera
	cpi unidad, $0A
	brne main
	call reset_unidad
	jmp main

reset_unidad: 
	ldi unidad, $00
	inc decena
	cpi decena, $0A
	brne main
	ldi decena, $00
	jmp main
	
decrementar: 
	;call delay_30ms
	dec unidad
	call espera
	cpi unidad, $FF
	brne main
	call reset_unidad_0
	jmp main

reset_unidad_0:
	ldi unidad, $09
	dec decena
	cpi decena, $FF
	brne main
	ldi decena, $09
	jmp main

delay_30ms: 
	ldi cont1, 200

lazo2: 
	ldi cont2, 250

lazo1: 
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
	brne lazo1
	dec cont1
	brne lazo2
	ret

delay_1ms: 
	ldi cont3, 10

lazo3_1:
	ldi cont2, 10

lazo2_1:
	ldi cont1, 16

lazo1_1:
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
	brne lazo1_1
	dec cont2
	brne lazo2_1
	dec cont3
	brne lazo3_1
	ret


timer0_ovf:	
	ldi temp, $00
	out PORTC, temp ;Apaga displays

	cpi mux, $01
	brne mux_decena ;Caso para decena

	; Caso para unidad (mux_undidad)
	mov r26, unidad
	ld temp, x
	out PORTD, temp
	out PORTC, mux
	;call delay_1ms
	ldi mux, $02
	reti

mux_decena: 
	mov r26, decena
	ld temp, x
	out PORTD, temp
	out PORTC, mux
	;call delay_1ms
	ldi mux, $01
	reti

display7s:
	.db $03, $9F, $25, $0D, $99, $49, $41, $1F, $01, $09 ;Valores para display7s anodo comun
