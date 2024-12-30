;;;;; PRACTICA 9 Teclado matricial y PC mandan caracteres al LCD
	.def temp = r16
	.def temp2 = r17
	.def temp3 = r18
	.def cont1 = r19				; Contador1 para delay
	.def cont2 = r20				; Contador2 para delay
	.def contCaract = r21			; Registro para contar caracteres impresos
	.def offset = r22				; Valor de offset para modos del teclado matricial
	.def tecla = r23				; Valor a imprimir

	.cseg
	.org 0
	jmp reset
	.org $024
	jmp recibiendoCaracteres

reset: 
	;=============CONFIGURAMOS USART============================
	ldi temp, $98
	sts UCSR0B, temp				; configuramos USART RX

	ldi temp, 103
	sts UBRR0L, temp 				; USART con Baud rate de 9600 bps

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
	
	ldi contCaract, 0 				; Contador de carateres inicia en ceros
	ldi offset, $00 				; Offset para cambio de modo inicia en cero

	sei								; Habilitamos interrupcion global

main:
    ldi temp, $00 					; Portc como entrada
    out DDRC, temp
    ldi temp, $0F 					; Resistencias de pull-up
    out PORTC, temp

    out DDRB, temp 					; Portb como salida
    ldi temp, $00 					; Portb en ceros
    out PORTB, temp

puertoCEPuertoBS:					; Portc como entrada y Portb como salida
    nop								; Tiempo para que el buffer se limpie
	nop

    in temp, PINC					; Leemos Portc, mantenemos solo la parte baja y salto condicional para cargar un valor
    andi temp, $0F					
    
	cpi temp, $0E
    breq tecla_00

    cpi temp, $0D
    breq tecla_04

    cpi temp, $0B
    breq tecla_08

    cpi temp, $07
    breq tecla_0C

    jmp puertoCEPuertoBS			; Si no se presiona ningun boton se repite la sub-rutina

tecla_00:
    ldi tecla, $00					; Carga 0 a tecla y vamos a leer las columas
    jmp leer_columnas

tecla_04:
    ldi tecla, $04					; Carga 4 a tecla y vamos a leer las columas
    jmp leer_columnas

tecla_08:
    ldi tecla, $08					; Carga 8 a tecla y vamos a leer las columas
    jmp leer_columnas

tecla_0C:
    ldi tecla, $0C					; Carga C a tecla y vamos a leer las columas
    jmp leer_columnas


leer_columnas:						; Portb como entrada y Portc como salida
    ldi temp, $00 					; Portc en ceros
    out PORTC, temp
	ldi temp, $0F 					; Portc como salida
    out DDRC, temp
	
    ldi temp, $0F					; Resistencias de pull-up
    out PORTB, temp 				
	ldi temp, $00					; Portb como entrada
    out DDRB, temp 					

    nop								; Tiempo para que el buffer se limpie
	nop

    in temp, PINB					; Leemos Portb, mantenemos solo la parte baja y salto condicional para sumar un valor
    andi temp, $0F

    cpi temp, $0E
    breq tecla_mas_0

    cpi temp, $0D
    breq tecla_mas_1

    cpi temp, $0B
    breq tecla_mas_2

    cpi temp, $07
    breq tecla_mas_3

    jmp main						; Regreso a main para volver a leer botones del teclado


tecla_mas_0:
    jmp sumar_offset				; Tecla mantiene su valor y salto a sumar el offset del modo actual
    
tecla_mas_1:
    subi tecla, -$01				; Suma 1 a tecla y salto a sumar el offset del modo actual
    jmp sumar_offset
    
tecla_mas_2:
    subi tecla, -$02				; Suma 2 a tecla y salto a sumar el offset del modo actual
    jmp sumar_offset

tecla_mas_3:
    subi tecla, -$03				; Suma 2 a tecla y continua a sumar el offset del modo actual


sumar_offset:
    cpi tecla, $0F 					; Si se presiona la ultima tecla del teclado, salto para cambiar de modo
    breq inc_offset

									; Dependiendo del offset se hace un salto para sumar un valor a tecla
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
    subi tecla, -$30				; Suma 30 a tecla y salto a control de lienas del el LCD
    jmp controlLineas

sumar_41:
    subi tecla, -$41				; Suma 41 a tecla y salto a control de lienas del el LCD
    jmp controlLineas

sumar_50:
    subi tecla, -$50				; Suma 50 a tecla y salto a control de lienas del el LCD
    jmp controlLineas

sumar_61:
    subi tecla, -$61				; Suma 61 a tecla y salto a control de lienas del el LCD
    jmp controlLineas

sumar_70:
    subi tecla, -$70				; Suma 70 a tecla y salto a control de lienas del el LCD
    jmp controlLineas


inc_offset:							; Subrutina para incrementar en 1 el offset
    cpi offset, 4					; Si el contador llegar a 4, salto a reinicarlo
    breq reset_contador
    inc offset
									; Delay de 300ms como antirebote del boton del teclado
	call delay_100m
	call delay_100m
	call delay_100m

    jmp main

reset_contador:
    ldi offset, 0
    jmp controlLineas

recibiendoCaracteres: 				; Interrupcion para recibir caracter desde la compu
	lds tecla, UDR0

	cpi contCaract, 16				; Salto de linea en el LCD
    breq cambiarDeLineaRx

    cpi contCaract, 32				; Limpiar pantalla del LCD
    breq resetLCDRx

printCaracterRx:					; Subrutina para imprimir caracter en LCD 
	mov temp2, tecla
    mov temp3, tecla

    ; parte alta
    andi temp2, $F0 				; Obtenemos parte alta
    ori temp2, $0C 					; Concatenamos $0C 
    out PORTD, temp2 ; Enable en 1

    andi temp2, $F0
    ori temp2, $08 					; Concatenamos $08 
    out PORTD, temp2 ; Enable en 0

    ; parte baja
    andi temp3, $0F 				; Obtenemos parte baja
	swap temp3
    ori temp3, $0C 					; Concatenamos $0C 
    out PORTD, temp3 ; Enable en 1

    andi temp3, $F0
    ori temp3, $08 					; Concatenamos $08 
    out PORTD, temp3 ; Enable en 0

    call delay_20m

	inc contCaract					; Incrementar contador de caracteres

	reti


cambiarDeLineaRx: 					; Subrutina para cambiar a direccion $40 del LCD y seleccionar linea 2
	
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


resetLCDRx:							; Subrutina para funcion 'clear display' en LCD
	ldi contCaract, 0				; Reinicia contador de caracteres

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

	
cambiarDeLinea: 					; Subrutina para cambio a direccion $40 del LCD y seleccionar Linea 2
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
	mov temp2, tecla
    mov temp3, tecla

	sts UDR0, tecla ; Imprime en la terminal del PC

    ; parte alta
    andi temp2, $F0 ;Obtengo parte alta
    ori temp2, $0C ;C (00001100)
    out PORTD, temp2

    andi temp2, $F0
    ori temp2, $08 ;8 (00001000)
    out PORTD, temp2 ; Enable en 0

    ; parte baja
    andi temp3, $0F ;Obtengo parte baja
	swap temp3
    ori temp3, $0C ;C (00001100)
    out PORTD, temp3

    andi temp3, $F0
    ori temp3, $08 ;8 (00001000)
    out PORTD, temp3 ; Enable en 0

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