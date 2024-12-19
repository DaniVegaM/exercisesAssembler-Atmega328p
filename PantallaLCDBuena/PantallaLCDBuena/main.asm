
	.def temp = r16
	.def cont1 = r17
	.def cont2 = r18
	.def temp2 = r19
	.def temp3 = r20
	.def temp4 = r21
	.def contCaract = r22
	.cseg
	.org 0
	jmp reset
	.org $024 ;Interrupcion de RX
	jmp recibiendoCaracteres

reset: 
	;=============CONFIGURAMOS USART============================
	ldi temp, $90
	sts UCSR0B, temp; configuramos USART solo RX

	ldi temp, 103
	sts UBRR0L, temp ; USART con Baud rate de 9600 bps

	; ============CONFIGURAMOS DISPLAY PRIMEROO =============
	ldi temp, $FE
	out DDRD, temp
	call delay_100m
	; *********************** FUNCION SET
	; parte alta
	ldi temp, $24 ; Enable en 1
	out PORTD, temp

	ldi temp, $20
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $84 ; Enable en 1
	out PORTD, temp

	ldi temp, $80
	out PORTD, temp ; Enable en 0
	call delay_20m

	; ********************** DISPLAY ON/OFF
	; parte alta
	ldi temp, $04 ; Enable en 1
	out PORTD, temp

	ldi temp, $00
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $E4 ; Enable en 1
	out PORTD, temp

	ldi temp, $E0
	out PORTD, temp ; Enable en 0
	call delay_20m

	; ********************** MODO SET
	; parte alta
	ldi temp, $04 ; Enable en 1
	out PORTD, temp

	ldi temp, $00
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $64 ; Enable en 1
	out PORTD, temp

	ldi temp, $60
	out PORTD, temp ; Enable en 0
	call delay_20m

	; ********************* CLEAR DISPLAY
	; parte alta
	ldi temp, $04 ; Enable en 1
	out PORTD, temp

	ldi temp, $00
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $14 ; Enable en 1
	out PORTD, temp

	ldi temp, $10
	out PORTD, temp ; Enable en 0

	ldi contCaract, 0

	call delay_20m

	sei

main:
	nop
	jmp main

cambiarDeLinea:
	;*********************** Brinco a direccion $40 del display para seleccionar Linea 2
	; parte alta
	ldi temp, $C4 ; Enable en 1 
	out PORTD, temp

	ldi temp, $C0
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $04 ; Enable en 1
	out PORTD, temp

	ldi temp, $00
	out PORTD, temp ; Enable en 0
	call delay_20m


	jmp regreso

resetLCD:;Funcion clear display
	ldi contCaract, 0
	; parte alta
	ldi temp, $04 ; Enable en 1 
	out PORTD, temp

	ldi temp, $00
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $14 ; Enable en 1
	out PORTD, temp

	ldi temp, $10
	out PORTD, temp ; Enable en 0
	call delay_20m

	jmp regreso

recibiendoCaracteres:
		; ***************************** LETRA A

		inc contCaract ;Contar cuantos caracteres llevo
		lds temp3, UDR0 ; Guardo el caracter actual en temp
		mov temp4, temp3 ;saco copia

		cpi contCaract, 16
		breq cambiarDeLinea

		cpi contCaract, 32
		breq resetLCD
regreso:

		; parte alta
		andi temp3, $F0 ;Obtengo parte alta
		ori temp3, $0C ;C (00001100)
		out PORTD, temp3

		andi temp3, $F0
		ori temp3, $08 ;8 (00001000)
		out PORTD, temp3 ; Enable en 0

		; parte baja
		andi temp4, $0F ;Obtengo parte baja
		swap temp4
		ori temp4, $0C ;C (00001100)
		out PORTD, temp4

		andi temp4, $F0
		ori temp4, $08 ;8 (00001000)
		out PORTD, temp4 ; Enable en 0

		call delay_20m
		
		reti


delay_20m:
	ldi cont1, 160
lazo2: 
	ldi cont2, 200
lazo1: 
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

delay_100m:
	call delay_20m
	call delay_20m
	call delay_20m
	call delay_20m
	call delay_20m
	ret
