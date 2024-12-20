;;;;; PRACTICA 9 Teclado matricial y PC mandan caracteres al LCD
.def temp = r16
.def cont1 = r17
.def cont2 = r18
.def temp2 = r19
.def temp3 = r20
.def temp4 = r21
.def contCaract = r22
.def offset = r23
.def tecla = r24
.def vieneDeTeclado = r25

.cseg
.org 0
jmp reset
.org $024
jmp recibiendoCaracteres
;.org $028
;jmp transmitiendoCaracteres

reset: 
	;=============CONFIGURAMOS USART============================
	ldi temp, $98
	sts UCSR0B, temp; configuramos USART RX y TX

	ldi temp, 103
	sts UBRR0L, temp ; USART con Baud rate de 9600 bps

	; ============CONFIGURAMOS DISPLAY PRIMEROO =============
	ldi temp, $FC
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
	
	ldi contCaract, 0 ; Contador de carateres
	ldi offset, $00 ; Offset para cambio de modo

	sei

main:
    ldi temp, $00 ; Portc como entrada
    out DDRC, temp

    ldi temp, $0F ;Resistencias de pull-up
    out PORTC, temp

    out DDRB, temp ; Portb como salida

    ldi temp, $00 ; Portb en ceros
    out PORTB, temp

puertoCEPuertoBS:
    nop
	nop

    in temp, PINC
    andi temp, $0F
    cpi temp, $0E
    breq tecla_00

    cpi temp, $0D
    breq tecla_04

    cpi temp, $0B
    breq tecla_08

    cpi temp, $07
    breq tecla_0C

    jmp puertoCEPuertoBS

tecla_00:
    ldi tecla, $00
    jmp leer_columnas

tecla_04:
    ldi tecla, $04
    jmp leer_columnas

tecla_08:
    ldi tecla, $08
    jmp leer_columnas

tecla_0C:
    ldi tecla, $0C
    jmp leer_columnas


leer_columnas:
    ldi temp, $00 ; Portc en ceros
    out PORTC, temp
	ldi temp, $0F ;Portc como salida
    out DDRC, temp
	
    ldi temp, $0F
    out PORTB, temp ; Resistencias de pull-up
	ldi temp, $00
    out DDRB, temp ; Portb como entrada

    nop
	nop

    in temp, PINB
    andi temp, $0F

    cpi temp, $0E
    breq tecla_mas_0

    cpi temp, $0D
    breq tecla_mas_1

    cpi temp, $0B
    breq tecla_mas_2

    cpi temp, $07
    breq tecla_mas_3

    jmp main


tecla_mas_0:
    jmp sumar_offset
    
tecla_mas_1:
    subi tecla, -$01
    jmp sumar_offset
    
tecla_mas_2:
    subi tecla, -$02
    jmp sumar_offset

tecla_mas_3:
    subi tecla, -$03
    jmp sumar_offset

sumar_offset:
    cpi tecla, $0F ;Indica que hay que cambiar de modo
    breq inc_offset

    cpi offset, 0
    breq sumar_30

    cpi offset, 1
    breq sumar_41

    cpi offset, 2
    breq sumar_50

    cpi offset, 3
    breq sumar_61

    cpi offset, 4
    breq sumar_70

sumar_30:
    subi tecla, -$30
    jmp controlLineas

sumar_41:
    subi tecla, -$41
    jmp controlLineas

sumar_50:
    subi tecla, -$50
    jmp controlLineas

sumar_61:
    subi tecla, -$61
    jmp controlLineas

sumar_70:
    subi tecla, -$70
    jmp controlLineas


inc_offset:
    cpi offset, 4
    breq reset_contador
    inc offset

	call delay_100m
	call delay_100m
	call delay_100m

    jmp main

reset_contador:
    ldi offset, 0
    jmp controlLineas

recibiendoCaracteres: ; Interrupcion para recibir desde la compu
	lds tecla, UDR0

	; Salto de linea
	cpi contCaract, 16
    breq cambiarDeLineaRx

	; Limpiar pantalla
    cpi contCaract, 32
    breq resetLCDRx

printCaracterRx:	
	mov temp3, tecla
    mov temp4, tecla

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

	inc contCaract

	reti


cambiarDeLineaRx:
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

	jmp printCaracterRx


resetLCDRx:;Funcion clear display
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

	jmp printCaracterRx


transmitiendoCaracteres: ; Interrupcion para transmitir hacia la compu
	
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

	jmp printCaracter

controlLineas:
	; Salto de linea
	cpi contCaract, 16
    breq cambiarDeLinea

	; Limpiar pantalla
    cpi contCaract, 32
    breq resetLCD

	jmp printCaracter

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

printCaracter:	
	mov temp3, tecla
    mov temp4, tecla

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
    
    call delay_100m
    call delay_100m
    call delay_100m
    call delay_100m
    call delay_100m
	inc contCaract
    jmp main

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