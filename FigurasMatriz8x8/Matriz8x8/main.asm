;matriz 8x8
;Mostrar dos figuras

	.def temp=r16
	.def cont1=r17
	.def cont2=r18
	.def cont3=r19
	.cseg
	.org $0

	ldi temp, $7F
	out ddrc, temp ;Configuramos solo C7 como entrada, los demas son salidas

	ldi temp, $80
	out portc, temp ;Habilitamos resistencias de pull-up en c7

	;Habilitamos salidas faltantes
	ldi temp, $FF
	out ddrb, temp

	ldi temp, $FF
	out ddrd, temp

main:
	in temp, pinc
	andi temp, $80 ;Si se presiona c7 muestra una figura diferente
	breq figura2

	;Sino que se mantenga mostrando una figura
	ldi zl,low(figura1_data*2)
	ldi zh, high(figura1_data*2)

	ldi temp, $08
	out portb, temp ;Enciendo fila 1 (b3)
	call encenderCol
	ldi temp, $00
	out portb, temp ;Apago fila

	ldi temp, $04
	out portb, temp ;Enciendo fila 1 (b2)
	call encenderCol
	ldi temp, $00
	out portb, temp ;Apago fila

	ldi temp, $02
	out portb, temp ;Enciendo fila 1 (b1)
	call encenderCol
	ldi temp, $00
	out portb, temp ;Apago fila

	ldi temp, $01
	out portb, temp ;Enciendo fila 1 (b0)
	call encenderCol
	ldi temp, $00
	out portb, temp ;Apago fila

	ldi temp, $08
	out portc, temp ;Enciendo fila 1 (c3)
	call encenderCol
	ldi temp, $00
	out portc, temp ;Apago fila

	ldi temp, $04
	out portc, temp ;Enciendo fila 1 (c2)
	call encenderCol
	ldi temp, $00
	out portc, temp ;Apago fila

	ldi temp, $02
	out portc, temp ;Enciendo fila 1 (c1)
	call encenderCol
	ldi temp, $00
	out portc, temp ;Apago fila

	ldi temp, $01
	out portc, temp ;Enciendo fila 1 (c0)
	call encenderCol
	ldi temp, $00
	out portc, temp ;Apago fila

	jmp main ;Vuelvo a leer entrada

encenderCol:
	lpm temp, z+
	out portd, temp
	call delay125m
	ret

figura1_data: .db $3E, $41, $92, $84, $88, $86, $81, $3E

figura2:
	ret

delay125m:
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