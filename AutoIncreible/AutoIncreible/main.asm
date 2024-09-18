;Programa de Auto Increible Kit Normal

	.def temp = r16
	.def cont1 = r17
	.def cont2 = r18
	.def cont3 = r19
	.cseg
	.org 0

	ldi temp, $ff
	out DDRD, temp ; configuramos puerto D como salida
	
	ldi temp, $01
	out PORTD, temp ; Resistencias de pull-up
	call delay_125m
	
izq:
	lsl temp
	out PORTD, temp
	call delay_125m
	cpi temp, $80
	brne izq
der: 
	lsr temp
	out PORTD, temp
	call delay_125m
	cpi temp, $01
	brne der
	jmp izq

delay_125m:
	ldi cont3, 5

lazo3:
	ldi cont2, 200

lazo2:
	ldi cont1, 200

lazo1:
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
	ret