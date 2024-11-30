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

	call delay_20m

	sei

main:
	nop
	jmp main

recibiendoCaracteres:
		; ***************************** LETRA A
		lds temp4, UDR0
		cp temp3, temp4 ;Si es el mismo caracter anterior no escribo nada
		brne escriboCaracter
		reti

escriboCaracter: ;NOTA: temp3 tiene el valor de UDR0
		inc contCaract ;Contar cuantos caracteres llevo
		lds temp3, UDR0 ; Guardo el caracter actual en temp
		mov temp4, temp3 ;saco copia

		cpi contCaract, 16
		breq cambiarDeLinea

		cpi contCaract, 8
		brge despl_der


		; parte alta
		andi temp3, $F0 ;Obtengo parte alta
		ori temp3, $0C ;C (00001100)
		out PORTD, temp3

		andi temp3, $F0
		ori temp3, $08 ;8 (00001000)
		out PORTD, temp3 ; Enable en 0

		; parte baja
		andi temp4, $0F ;Obtengo parte baja
		lsl temp4
		lsl temp4
		lsl temp4
		lsl temp4
		ori temp4, $0C ;C (00001100)
		out PORTD, temp4

		andi temp4, $F0
		ori temp4, $08 ;8 (00001000)
		out PORTD, temp4 ; Enable en 0

		call delay_20m
		
		reti

cambiarDeLinea:
	;*********************** Brinco a direccion $40 del display para seleccionar Linea 2
	ldi contCaract, 16
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

	; ***************************** ESPACIO
	; parte alta
	ldi temp, $2C ; Enable en 1 
	out PORTD, temp

	ldi temp, $28
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $0C ; Enable en 1
	out PORTD, temp

	ldi temp, $08
	out PORTD, temp ; Enable en 0
	call delay_20m

	ret

despl_der:
	; parte alta
	ldi temp2, $14 ; Enable en 1 
	out PORTD, temp

	ldi temp2, $10
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp2, $84 ; Enable en 1
	out PORTD, temp

	ldi temp2, $80
	out PORTD, temp ; Enable en 0

	ret


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