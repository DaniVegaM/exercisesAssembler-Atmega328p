;Ejemplo 1: Queremos que B5 prenda cada 1 segundos aprox

.def temp=r16
.def cont=r17
.cseg

;Cada vez que se haga un reset
.org $0
jmp reset

.org $020 ;Es de acuerdo con la tabla de vectores, cuando ocurre una sobreflujo (overflow) el programa se va a esta linea
jmp timer0_ovf ;cada vez que ocurre una interrupción por sobreflujo del Timer0, se debe saltar a la subrutina llamada timer0_ovf.

;Aquí comienza nuestro programa
reset:
	ldi temp, $20
	out ddrb,temp ;Establecemos B5 como salida
	
	;El timer será modo normal, ya que despues del reset el registro ya se pone en 0 que es modo normal
	;Le vamos a cargar $05 porque propusimos preescaler de 1024 y en la tabla dice que eso es $05

	ldi temp, $05
	out tccr0b, temp ;Seleccionamos N (preescaler) = 1024 y modo normal

	ldi temp, $01
	sts timsk0, temp ;Habilitamos interrupcion por sobreflujo

	ldi cont, 30
	sei ;Habilita interrupcion global

main: ;Lazo infinito para que haga algo en lo que llega la interrupcion
	nop
	nop
	jmp main

timer0_ovf:
	dec cont
	breq toggle ;Si el contador llega a 0 se hace un toggle
	reti ;Para regresar interrupcion

toggle: ;Rutina que cambia el estado del led de encendido a apagado y apagado a encendido
	in temp, pinb
	com temp
	andi temp, $20
	out portb, temp
	ldi cont, 30
	reti
	