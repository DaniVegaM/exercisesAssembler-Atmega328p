; Practica PWM

	.def temp=r16
	.def cte=r17
	.def cont3=r18
	.def cont2=r19
	.def cont1=r20
	.cseg
	.org $0

	ldi temp, $03
	out portc, temp ; Habilitamos pull up (c0 y c1)

	ldi temp, $40
	out ddrd,temp ;Habilitamos salida (d6)

	ldi temp, $83
	out tccr0a, temp

	ldi temp, $03
	out tccr0b, temp

	ldi temp, 127
	out ocr0a, temp //Registro de comparacion

	ldi cte, 5 //Incrementos de 5

main:
	;Leemos boton
	in temp, pinc
	andi temp, $03
	brne bajarBrillo

	call delay_100m
aumentarBrillo:
	in temp,ocr0a

	add temp, cte ;Aumentamos
	out ocr0a, temp

	jmp main

bajarBrillo:
	in temp,ocr0a

	sub temp, cte ;Decrementamos
	out ocr0a, temp

	jmp main


delay_100m:
	ldi cont3,4
lazo3: ldi cont2, 200
lazo2: ldi cont1, 200
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
	nop
	dec cont1
	brne lazo1
	dec cont2
	brne lazo2
	dec cont3
	brne lazo3
