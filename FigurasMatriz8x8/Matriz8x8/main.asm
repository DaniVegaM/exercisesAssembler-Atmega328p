;matriz 8x8
;Mostrar dos figuras

	.def temp=r16
	.def cont1=r17
	.def cont2=r18
	.def cont3=r19
	.def temp2=r20
	.def tempx=r21
	.def tempy=r22
	.cseg
	.org $0

	ldi temp, $0F
	out ddrc, temp ;Configuramos solo C5 como entrada, los demas son salidas

	ldi temp, $20
	out portc, temp ;Habilitamos resistencias de pull-up en c5

	;Habilitamos salidas faltantes
	ldi temp, $0F
	out ddrb, temp

	ldi temp, $FF
	out ddrd, temp

main:
	in temp, pinc
	andi temp, $20 ;Si se presiona c5 muestra una figura diferente
	breq figura2

	ldi zl,low(figura1_data*2)
	ldi zh, high(figura1_data*2)
	ldi temp, $01
	jmp encenderMatriz

figura2:
	ldi zl,low(figura2_data*2)
	ldi zh, high(figura2_data*2)
	ldi temp, $01

encenderMatriz:

	mov temp2, temp
	com temp
	out portd, temp ;Enciendo cada columna (Puerto D)

	call encenderFil ;Enciendo fila
	ldi temp, $00
	out portd, temp ;Apago columna

	mov temp, temp2
	lsl temp

	cpi temp, $80
	breq main

	jmp encenderMatriz

encenderFil:
	lpm xl, zl
	lpm xh, zh
	inc z

	out portb, xl
	out portc, xh
	call delay125m
	ret

figura1_data: .db $3E, $41, $92, $84, $88, $86, $81, $3E
figura2_data: .db $81, $18, $3C, $7E, $72, $52, $5E, $81

delay125m:
	ldi cont3, 10

lazo3:
	ldi cont2, 10

lazo2:
	ldi cont1, 16

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
	ret