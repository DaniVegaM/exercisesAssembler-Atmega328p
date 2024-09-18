;Practica 1

	.def temp=r16
	.def temp2=r17
	.def cont1=r18
	.def cont2=r19
	.def cont3=r20
	.def menu=r21
	.cseg
	.org $0

	ldi temp, $FF
	out ddrd, temp ;Se establece el puerto D como salida

	ldi temp, $00
	out ddrc, temp

	;NOTA: Las entradas del puerto C no las definimos explicitamente porque en el reset todos los puertos se establecen como entradas 

	ldi temp, $03
	out portc, temp ;Habilitamos resistencias de pull-up en el puerto C

main:
	;ldi menu, $FF
	;out portd, menu ;Se prenden todos los leds en el menu
    in temp, pinc
	call delay125m

	andi temp, $03 ;Mascara

    cpi temp, $03
    breq jumpToKitNormal

    cpi temp, $02
    breq jumpToKitDoble

    cpi temp, $01
    breq jumpToKitFueraDentro

    cpi temp, $00
    breq jumpToKitDentroFuera

    jmp main ; Que siga leyendo el boton

jumpToKitNormal:
    jmp kitNormal ; Salto absoluto a kitNormal

jumpToKitDoble:
    jmp kitDoble ; Salto absoluto a kitDoble

jumpToKitFueraDentro:
    jmp kitFueraDentro ; Salto absoluto a kitFueraDentro

jumpToKitDentroFuera:
    jmp kitDentroFuera ; Salto absoluto a kitDentroFuera

retMenu1:
	jmp main


kitNormal:
	ldi temp, $01
	out portd, temp
	call delay125m

izq:;Subrutina ocupada por kitNormal
	lsl temp
	out portd, temp
	call delay125m

	cpi temp, $80
	breq der
	jmp izq
der: ;Subrutina ocupada por kitNormal
	lsr temp
	out portd, temp
	call delay125m

	cpi temp, $01
	breq retMenu1 ;Regreso al menu
	jmp der

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

; Delay de 2seg
delay2s:
	ldi cont3, 2

lazo3_1:
	ldi cont2, 200

lazo2_1:
	ldi cont1, 250

lazo1_1:
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

kitDoble:
	ldi temp, $01
	out portd, temp
	call delay2s

izqDoble:;Subrutina ocupada por kitNormal
	lsl temp
	out portd, temp
	call delay2s

	cpi temp, $80
	breq derDoble
	jmp izqDoble

derDoble: ;Subrutina ocupada por kitNormal
	lsr temp
	out portd, temp
	call delay2s

	cpi temp, $01
	breq retMenu2 ;Regreso al menu
	jmp derDoble

retMenu2:
	jmp main


kitFueraDentro: ;La idea es dividir tira led en 2 y movemos parte izquierda y luego parte derecha
	ldi zl, low(data_fueraDentro*2)
	ldi zh, high(data_fueraDentro*2)

loop1:
	lpm temp, z+
	out portd, temp
	call delay125m
	cpi temp, $18
	breq retMenu2
	jmp loop1

data_fueraDentro: .db $81, $42, $24, $18

kitDentroFuera:;La idea es dividir tira led en 2 y movemos parte izquierda y luego parte derecha
	ldi zl, low(data_dentroFuera*2)
	ldi zh, high(data_dentroFuera*2)

loop2:
	lpm temp, z+
	out portd, temp
	call delay125m
	cpi temp, $81
	breq retMenu2
	jmp loop2

data_dentroFuera: .db $18, $24, $42, $81



