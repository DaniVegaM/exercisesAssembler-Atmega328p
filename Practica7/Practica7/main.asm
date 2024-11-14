	.def temp = r16
	.def cont1 = r17
	.def cont2 = r18
	.def temp2 = r19
	.cseg
	.org 0

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


	; ***************************** LETRA A
	; parte alta
	ldi temp, $4C ; Enable en 1 
	out PORTD, temp

	ldi temp, $48
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $1C ; Enable en 1
	out PORTD, temp

	ldi temp, $18
	out PORTD, temp ; Enable en 0
	call delay_20m


	; ***************************** LETRA b
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $2C ; Enable en 1
	out PORTD, temp

	ldi temp, $28
	out PORTD, temp ; Enable en 0
	call delay_20m


	; ***************************** LETRA r
	; parte alta
	ldi temp, $7C ; Enable en 1
	out PORTD, temp

	ldi temp, $78
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $2C ; Enable en 1
	out PORTD, temp

	ldi temp, $28
	out PORTD, temp ; Enable en 0
	call delay_20m


	; ***************************** LETRA a
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $1C ; Enable en 1
	out PORTD, temp

	ldi temp, $18
	out PORTD, temp ; Enable en 0
	call delay_20m


	; ***************************** LETRA h
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $8C ; Enable en 1
	out PORTD, temp

	ldi temp, $88
	out PORTD, temp ; Enable en 0
	call delay_20m 

	ldi temp, $C8
	out PORTD, temp ; Enable en 0
	call delay_20m


	; ***************************** LETRA a
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $1C ; Enable en 1
	out PORTD, temp

	ldi temp, $18
	out PORTD, temp ; Enable en 0
	call delay_20m

	; ***************************** LETRA m
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $DC ; Enable en 1
	out PORTD, temp

	ldi temp, $D8
	out PORTD, temp ; Enable en 0
	call delay_20m


	; ***************************** LETRA espacio
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

	; ***************************** LETRA R
	; parte alta
	ldi temp, $5C ; Enable en 1 
	out PORTD, temp

	ldi temp, $58
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $2C ; Enable en 1
	out PORTD, temp

	ldi temp, $28
	out PORTD, temp ; Enable en 0
	call delay_20m


	; ***************************** LETRA e
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $5C ; Enable en 1
	out PORTD, temp

	ldi temp, $58
	out PORTD, temp ; Enable en 0
	call delay_20m

	; ***************************** LETRA y
	; parte alta
	ldi temp, $7C ; Enable en 1 
	out PORTD, temp

	ldi temp, $78
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $9C ; Enable en 1
	out PORTD, temp

	ldi temp, $98
	out PORTD, temp ; Enable en 0
	call delay_20m

	; ***************************** LETRA e
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $5C ; Enable en 1
	out PORTD, temp

	ldi temp, $58
	out PORTD, temp ; Enable en 0
	call delay_20m


	; ***************************** LETRA s
	; parte alta
	ldi temp, $7C ; Enable en 1 
	out PORTD, temp

	ldi temp, $78
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $3C ; Enable en 1
	out PORTD, temp

	ldi temp, $38
	out PORTD, temp ; Enable en 0
	call delay_20m



	; ***************************** LETRA espacio
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



	; ***************************** LETRA C
	; parte alta
	ldi temp, $4C ; Enable en 1 
	out PORTD, temp

	ldi temp, $48
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $3C ; Enable en 1
	out PORTD, temp

	ldi temp, $38
	out PORTD, temp ; Enable en 0
	call delay_20m


	; ***************************** LETRA u
	; parte alta
	ldi temp, $7C ; Enable en 1 
	out PORTD, temp

	ldi temp, $78
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $5C ; Enable en 1
	out PORTD, temp

	ldi temp, $58
	out PORTD, temp ; Enable en 0
	call delay_20m
	

	; ***************************** LETRA e
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $5C ; Enable en 1
	out PORTD, temp

	ldi temp, $58
	out PORTD, temp ; Enable en 0
	call delay_20m


	; ***************************** LETRA v
	; parte alta
	ldi temp, $7C ; Enable en 1 
	out PORTD, temp

	ldi temp, $78
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $6C ; Enable en 1
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0
	call delay_20m


	; ***************************** LETRA a
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $1C ; Enable en 1
	out PORTD, temp

	ldi temp, $18
	out PORTD, temp ; Enable en 0
	call delay_20m


	; ***************************** LETRA s
	; parte alta
	ldi temp, $7C ; Enable en 1 
	out PORTD, temp

	ldi temp, $78
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $3C ; Enable en 1
	out PORTD, temp

	ldi temp, $38
	out PORTD, temp ; Enable en 0
	call delay_20m


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
	; ***************************** LETRA D
	; parte alta
	ldi temp, $4C ; Enable en 1 
	out PORTD, temp

	ldi temp, $48
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $4C ; Enable en 1
	out PORTD, temp

	ldi temp, $48
	out PORTD, temp ; Enable en 0
	call delay_20m


	; ***************************** LETRA a
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $1C ; Enable en 1
	out PORTD, temp

	ldi temp, $18
	out PORTD, temp ; Enable en 0
	call delay_20m

; ***************************** LETRA n
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $EC ; Enable en 1
	out PORTD, temp

	ldi temp, $E8
	out PORTD, temp ; Enable en 0
	call delay_20m

; ***************************** LETRA i
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $9C ; Enable en 1
	out PORTD, temp

	ldi temp, $98
	out PORTD, temp ; Enable en 0
	call delay_20m

; ***************************** LETRA e
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $5C ; Enable en 1
	out PORTD, temp

	ldi temp, $58
	out PORTD, temp ; Enable en 0
	call delay_20m

; ***************************** LETRA l
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $CC ; Enable en 1
	out PORTD, temp

	ldi temp, $C8
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
; ***************************** LETRA V
	; parte alta
	ldi temp, $5C ; Enable en 1 
	out PORTD, temp

	ldi temp, $58
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $6C ; Enable en 1
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0
	call delay_20m
; ***************************** LETRA e
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $5C ; Enable en 1
	out PORTD, temp

	ldi temp, $58
	out PORTD, temp ; Enable en 0
	call delay_20m
; ***************************** LETRA g
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $7C ; Enable en 1
	out PORTD, temp

	ldi temp, $78
	out PORTD, temp ; Enable en 0
	call delay_20m
; ***************************** LETRA a
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $1C ; Enable en 1
	out PORTD, temp

	ldi temp, $18
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
; ***************************** LETRA M
	; parte alta
	ldi temp, $4C ; Enable en 1 
	out PORTD, temp

	ldi temp, $48
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $DC ; Enable en 1
	out PORTD, temp

	ldi temp, $D8
	out PORTD, temp ; Enable en 0
	call delay_20m
; ***************************** LETRA i
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $9C ; Enable en 1
	out PORTD, temp

	ldi temp, $98
	out PORTD, temp ; Enable en 0
	call delay_20m
; ***************************** LETRA r
	; parte alta
	ldi temp, $7C ; Enable en 1 
	out PORTD, temp

	ldi temp, $78
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $2C ; Enable en 1
	out PORTD, temp

	ldi temp, $28
	out PORTD, temp ; Enable en 0
	call delay_20m
; ***************************** LETRA a
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $1C ; Enable en 1
	out PORTD, temp

	ldi temp, $18
	out PORTD, temp ; Enable en 0
	call delay_20m
; ***************************** LETRA n
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $EC ; Enable en 1
	out PORTD, temp

	ldi temp, $E8
	out PORTD, temp ; Enable en 0
	call delay_20m
; ***************************** LETRA d
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $4C ; Enable en 1
	out PORTD, temp

	ldi temp, $48
	out PORTD, temp ; Enable en 0
	call delay_20m
; ***************************** LETRA a
	; parte alta
	ldi temp, $6C ; Enable en 1 
	out PORTD, temp

	ldi temp, $68
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $1C ; Enable en 1
	out PORTD, temp

	ldi temp, $18
	out PORTD, temp ; Enable en 0
	call delay_20m



aqui: 
	ldi temp2, 6
	;*********************** Desplaza a la izquierda
despl_izq:
	; parte alta
	ldi temp, $14 ; Enable en 1 
	out PORTD, temp

	ldi temp, $10
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $84 ; Enable en 1
	out PORTD, temp

	ldi temp, $80
	out PORTD, temp ; Enable en 0
	call delay_100m
	call delay_100m
	call delay_100m
	call delay_100m
	call delay_100m

	dec temp2
	brne despl_izq

	
	ldi temp2, 6
	;*********************** Desplaza a la derecha
despl_der:
	; parte alta
	ldi temp, $14 ; Enable en 1 
	out PORTD, temp

	ldi temp, $10
	out PORTD, temp ; Enable en 0

	; parte baja
	ldi temp, $C4 ; Enable en 1
	out PORTD, temp

	ldi temp, $C0
	out PORTD, temp ; Enable en 0
	call delay_100m
	call delay_100m
	call delay_100m
	call delay_100m
	call delay_100m

	dec temp2
	brne despl_der

	jmp aqui


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