/*; Practica ADC con Potenciometro a)
	.equ	AtBCD0	=13		;address of tBCD0
	.equ	AtBCD2	=15	;address of tBCD1

	.def	tBCD0	=r13	;BCD value digits 1 and 0
	.def	tBCD1	=r14	;BCD value digits 3 and 2
	.def	tBCD2	=r15	;BCD value digit 4
	.def	fbinL	=r16	;binary value Low byte
	.def	fbinH	=r17	;binary value High byte
	.def	cnt16a	=r18	;loop counter
	.def	tmp16a	=r19	;temporary value

	.def temp=r20
	.def temp2=r21
	.def mux=r22

	.cseg
	.org $0
	jmp reset

	.org $020
	jmp timer0_ovf

	.org $02a
	jmp ADC_fin


// MULTIPLEXEO DE LOS DISPLAYS CATODO COMUN
timer0_ovf:
	ldi temp2, $00
	out PORTC, temp2		;Apaga displays

	cpi mux, $02
	breq mux_decena			;Caso para decena

	cpi mux, $04
	breq mux_centena

	; Caso para unidad (mux_undidad)
	ldi temp2, $0F			
	and temp2, tBCD1		;Mantenemos solo la parte baja de tBCD1 (unidad)
	mov r26, temp2			;Apuntamos xl hacia el valor de unidad
	ld temp2, x				;Cargamos en temp2 la codificacion en 7seg de unidad
	out PORTD, temp2
	sbi PORTC, 0			;C0 encendido, C1 apagado y C2 apagado
	cbi PORTC, 1
	cbi PORTC, 2
	ldi mux, $02
	reti

mux_decena: 
	lsr tBCD1                ; Desplaza 4 veces para bajar las decenas
	lsr tBCD1
	lsr tBCD1
	lsr tBCD1
	ldi temp2, $0F
	and temp2, tBCD1		;Mantenemos solo la parte alta de tBCD1 (decena)
	mov r26, temp2			;Apuntamos xl hacia el valor de decena
	ld temp2, x				;Cargamos en temp2 la codificacion en 7seg de decena
	out PORTD, temp2
	cbi PORTC, 0			;C0 apagado, C1 encendido y C2 apagado
	sbi PORTC, 1
	cbi PORTC, 2
	ldi mux, $04
	reti

mux_centena:
	ldi temp2, $0F
	and temp2, tBCD2		;Mantenemos solo la parte baaja de tBCD2 (centena)
	mov r26, temp2			;Apuntamos xl hacia el valor de centena
	ld temp2, x				;Cargamos en temp2 la codificacion en 7seg de centena
	out PORTD, temp2
	cbi PORTC, 0			;C0 apagado, C1 apagado y C2 encendido
	cbi PORTC, 1
	sbi PORTC, 2
	ldi mux, $01
	reti

reset:
	;Configuramos puertos
	ldi temp, $FB ;Segmentos de display
	out ddrd, temp

	ldi temp, $07
	out ddrc, temp ;Mux de display

	;Config para Timer0
	ldi temp, $03
	out tccr0b, temp ;seleccionamos modo normal y prescaler = 64
	
	ldi temp, $01
	sts timsk0, temp ;habilitamos interrupcion por sobreflujo

	;Inicializamos registros extendidos
	ldi ZL, low(display7s*2)
	ldi ZH, high(display7s*2)
	ldi XL, $00
	ldi XH, $01
	
	ldi temp, $0A

lazo: 
	lpm temp2, z+ ;Carga en memoria de programa cada valor para el display
	st x+, temp2 ;Almacena los valores en memoria de datos
	dec temp
	brne lazo

	;C3 será la entrada (potenciometro)
	ldi temp, $63 ;Config referencia a VCC, ajusta a izquierda y potenciometro en c3
	sts admux, temp

	ldi temp, $01
	sts DIDR0, temp ; Quitamos el bufer digital para poder iniciar conversion

	ldi temp, $EF ;Habilita ADC, inicia conversion, habilita autodisparo, interrupcion y preescaler de 128
	sts adcsra, temp

	ldi mux, $01

	sei

main:
	nop
	jmp main


ADC_fin:
	lds fbinL, adch			;Almacenamos parte alta de la lectura en binario
	;ldi fbinL, 108			;PARA PRUEBAS
	ldi fbinH, 196			;Escalon de cuantizacion
	mul fbinH, fbinL		;Multiplicamos por 196 y el resultado se guarda en r1:r0
	movw fbinL, r0			;Regresamos el resultado en fbinL(r0) y fbinH(r1)
	rcall bin2BCD16			;Transformamos a decimal
	reti

; Transformar binario a decimal de 5 digitos 
bin2BCD16:
	ldi	cnt16a,16			;Init loop counter	
	clr	tBCD2				;clear result (3 bytes)
	clr	tBCD1		
	clr	tBCD0		
	clr	ZH					;clear ZH 
bBCDx_1:lsl	fbinL			;shift input value
	rol	fbinH				;through all bytes
	rol	tBCD0		
	rol	tBCD1
	rol	tBCD2
	dec	cnt16a				;decrement loop counter
	brne bBCDx_2			;if counter not zero
	ret						;return

bBCDx_2:ldi	r30, AtBCD2 +1	;Z points to result MSB + 1
bBCDx_3:
	ld	tmp16a, -Z			;get (Z) with pre-decrement
	subi tmp16a, -$03		;add 0x03
	sbrc tmp16a, 3			;if bit 3 not clear
	st Z, tmp16a			;store back
	ld tmp16a, Z			;get (Z)
	subi tmp16a, -$30		;add 0x30
	sbrc tmp16a, 7			;if bit 7 not clear
	st Z, tmp16a			;store back
	cpi ZL, AtBCD0			;done all three?
	brne bBCDx_3			;loop again if not
	rjmp bBCDx_1

display7s:
	.db $80, $F1, $48, $60, $31, $22, $02, $F0, $00, $20*/






; Practica ADC con sensor de temperatura b)
	.equ	AtBCD0	=13		;address of tBCD0
	.equ	AtBCD2	=15	;address of tBCD1

	.def	tBCD0	=r13	;BCD value digits 1 and 0
	.def	tBCD1	=r14	;BCD value digits 3 and 2
	.def	tBCD2	=r15	;BCD value digit 4
	.def	fbinL	=r16	;binary value Low byte
	.def	fbinH	=r17	;binary value High byte
	.def	cnt16a	=r18	;loop counter
	.def	tmp16a	=r19	;temporary value

	.def temp=r20
	.def temp2=r21
	.def mux=r22

	.cseg
	.org $0
	jmp reset

	.org $020
	jmp timer0_ovf

	.org $02a
	jmp ADC_fin


// MULTIPLEXEO DE LOS DISPLAYS CATODO COMUN
timer0_ovf:
	ldi temp2, $00
	out PORTC, temp2		;Apaga displays

	cpi mux, $02
	breq mux_decena			;Caso para decena

	cpi mux, $04
	breq mux_centena

	; Caso para unidad (mux_undidad)
	lsr tBCD0                ; Desplaza 4 veces para bajar las decenas
	lsr tBCD0
	lsr tBCD0
	lsr tBCD0
	ldi temp2, $0F			
	and temp2, tBCD0		;Mantenemos solo la parte baja de tBCD1 (unidad)
	mov r26, temp2			;Apuntamos xl hacia el valor de unidad
	ld temp2, x				;Cargamos en temp2 la codificacion en 7seg de unidad
	out PORTD, temp2
	sbi PORTC, 0			;C0 encendido, C1 apagado y C2 apagado
	cbi PORTC, 1
	cbi PORTC, 2
	ldi mux, $02
	reti

mux_decena: 
	ldi temp2, $0F
	and temp2, tBCD1		;Mantenemos solo la parte alta de tBCD1 (decena)
	mov r26, temp2			;Apuntamos xl hacia el valor de decena
	ld temp2, x				;Cargamos en temp2 la codificacion en 7seg de decena
	out PORTD, temp2
	cbi PORTC, 0			;C0 apagado, C1 encendido y C2 apagado
	sbi PORTC, 1
	cbi PORTC, 2
	ldi mux, $04
	reti

mux_centena:
	lsr tBCD1                ; Desplaza 4 veces para bajar las decenas
	lsr tBCD1
	lsr tBCD1
	lsr tBCD1
	ldi temp2, $0F 
	and temp2, tBCD1		;Mantenemos solo la parte baaja de tBCD2 (centena)
	mov r26, temp2			;Apuntamos xl hacia el valor de centena
	ld temp2, x				;Cargamos en temp2 la codificacion en 7seg de centena
	out PORTD, temp2
	cbi PORTC, 0			;C0 apagado, C1 apagado y C2 encendido
	cbi PORTC, 1
	sbi PORTC, 2
	ldi mux, $01
	reti

reset:
	;Configuramos puertos
	ldi temp, $FB ;Segmentos de display
	out ddrd, temp

	ldi temp, $07
	out ddrc, temp ;Mux de display

	;Config para Timer0
	ldi temp, $03
	out tccr0b, temp ;seleccionamos modo normal y prescaler = 64
	
	ldi temp, $01
	sts timsk0, temp ;habilitamos interrupcion por sobreflujo

	;Inicializamos registros extendidos
	ldi ZL, low(display7s*2)
	ldi ZH, high(display7s*2)
	ldi XL, $00
	ldi XH, $01
	
	ldi temp, $0A

lazo: 
	lpm temp2, z+ ;Carga en memoria de programa cada valor para el display
	st x+, temp2 ;Almacena los valores en memoria de datos
	dec temp
	brne lazo

	;C3 será la entrada (potenciometro)
	ldi temp, $E3 ;Config referencia a VCC, ajusta a izquierda y potenciometro en c3
	sts admux, temp

	ldi temp, $08
	sts DIDR0, temp ; Quitamos el bufer digital para poder iniciar conversion

	ldi temp, $EF ;Habilita ADC, inicia conversion, habilita autodisparo, interrupcion y preescaler de 128
	sts adcsra, temp

	ldi mux, $01

	sei

main:
	nop
	jmp main


ADC_fin:
	lds fbinL, adch			;Almacenamos parte alta de la lectura en binario
	;ldi fbinL, 108			;PARA PRUEBAS
	ldi fbinH, 43			;Escalon de cuantizacion
	mul fbinH, fbinL		;Multiplicamos por 196 y el resultado se guarda en r1:r0
	movw fbinL, r0			;Regresamos el resultado en fbinL(r0) y fbinH(r1)
	rcall bin2BCD16			;Transformamos a decimal
	reti

; Transformar binario a decimal de 5 digitos 
bin2BCD16:
	ldi	cnt16a,16			;Init loop counter	
	clr	tBCD2				;clear result (3 bytes)
	clr	tBCD1		
	clr	tBCD0		
	clr	ZH					;clear ZH 
bBCDx_1:lsl	fbinL			;shift input value
	rol	fbinH				;through all bytes
	rol	tBCD0		
	rol	tBCD1
	rol	tBCD2
	dec	cnt16a				;decrement loop counter
	brne bBCDx_2			;if counter not zero
	ret						;return

bBCDx_2:ldi	r30, AtBCD2 +1	;Z points to result MSB + 1
bBCDx_3:
	ld	tmp16a, -Z			;get (Z) with pre-decrement
	subi tmp16a, -$03		;add 0x03
	sbrc tmp16a, 3			;if bit 3 not clear
	st Z, tmp16a			;store back
	ld tmp16a, Z			;get (Z)
	subi tmp16a, -$30		;add 0x30
	sbrc tmp16a, 7			;if bit 7 not clear
	st Z, tmp16a			;store back
	cpi ZL, AtBCD0			;done all three?
	brne bBCDx_3			;loop again if not
	rjmp bBCDx_1

display7s:
	.db $80, $F1, $48, $60, $31, $22, $02, $F0, $00, $20