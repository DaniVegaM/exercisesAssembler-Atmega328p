#include <avr/io.h>
#define F_CPU 16000000UL
#include <util/delay.h>
#include <string.h>
#include <avr/eeprom.h>
#include <avr/interrupt.h>
#include <ctype.h>
#include "figuras.h"

// Definiciones de las filas
#define R1 PB0
#define R2 PB1
#define R3 PB2
#define R4 PB3
#define R5 PB4
#define R6 PB5
#define R7 PD2
#define R8 PD3

// Definiciones de las columnas
#define C1 PC0
#define C2 PC1
#define C3 PC2
#define C4 PC3
#define C5 PC4
#define C6 PC5
#define C7 PD4
#define C8 PD5

#define RESPONSE_BUFFER_SIZE 128
char responseBuffer[RESPONSE_BUFFER_SIZE];  // Buffer para almacenar la respuesta del ESP8266

char mensajeLeidoEEPROM[32];
uint16_t direccionInicial = 0;         


// Función para configurar los pines como entrada o salida
void setup_pins() {
    DDRD |= (1<<1);                         // PD1 como salida (TX)
    DDRD &= ~(1<<0);                        // PD0 como entrada (RX)

	// Configura las filas como salidas
	DDRB |= (1 << R1) | (1 << R2) | (1 << R3) | (1 << R4) | (1 << R5) | (1 << R6);
	DDRD |= (1 << R7) | (1 << R8);

	// Configura las columnas como salidas
	DDRC |= (1 << C1) | (1 << C2) | (1 << C3) | (1 << C4) | (1 << C5) | (1 << C6);
	DDRD |= (1 << C7) | (1 << C8);

    // Configura led de conexion wfi exitosa
    DDRD |= (1 << 6);
}

// Función para apagar todas las filas y columnas
void clear_matrix() {
	// Apaga todas las filas
	PORTB &= ~((1 << R1) | (1 << R2) | (1 << R3) | (1 << R4) | (1 << R5) | (1 << R6));
	PORTD &= ~((1 << R7) | (1 << R8));

	// Apaga todas las columnas
	PORTC &= ~((1 << C1) | (1 << C2) | (1 << C3) | (1 << C4) | (1 << C5) | (1 << C6));
	PORTD &= ~((1 << C7) | (1 << C8));  // Activas con lógica normal

	_delay_ms(1); // Espera un momento para que se apaguen
}

// Función para activar una fila
void activate_row(uint8_t row) {
	clear_matrix(); // Asegúrate de apagar todo antes
	switch (row) {
		case 0: PORTB |= ~(1 << R1); PORTD |= 0xFF; break;
		case 1: PORTB |= ~(1 << R2); PORTD |= 0xFF; break;
		case 2: PORTB |= ~(1 << R3); PORTD |= 0xFF; break;
		case 3: PORTB |= ~(1 << R4); PORTD |= 0xFF; break;
		case 4: PORTB |= ~(1 << R5); PORTD |= 0xFF; break;
		case 5: PORTB |= ~(1 << R6); PORTD |= 0xFF; break;
		case 6: PORTD |= ~(1 << R7); PORTB |= 0xFF; break;
		case 7: PORTD |= ~(1 << R8); PORTB |= 0xFF; break;
		default: break;
	}
}

// Función para activar columnas (por lógica inversa)
void activate_columns(uint8_t cols) {
	PORTC = (cols & 0b00111111);  // Configura las primeras 6 columnas
	PORTD = (PORTD & 0b00001111) | ((cols & 0b11000000) >> 2);

}

void print_figure(const uint8_t *figure) {
	for (uint8_t i = 0; i < 8; i++) {
		activate_row(i);
		activate_columns(figure[i]);
		_delay_ms(1);
	}
}

void scroll_figure(const uint8_t *figure) {
    uint8_t scrolled_figure[8];
    for (int8_t shift = 7; shift >= -7; shift--) {
        for (uint8_t i = 0; i < 8; i++) {
            if (shift >= 0) {
                scrolled_figure[i] = figure[i] << shift;
            } else {
                scrolled_figure[i] = figure[i] >> -shift;
            }
        }
		for (size_t i = 0; i < 3; i++)
		{
        	print_figure(scrolled_figure);
		}
		
    }
}

void mandarCadenaAMatriz(const char *mensaje) {
    uint8_t caracter[8];
    uint8_t indiceCaracter;
    while(*mensaje != '\0') { //Se leera la cadena completa
        if(*mensaje >= 'A' && *mensaje <= 'Z') { //Si es una letra
            indiceCaracter = *mensaje - 'A';
            memcpy(caracter, figureOfCharacters[indiceCaracter], 8);
            scroll_figure(caracter);

            // _delay_ms(500);
        } else if(*mensaje >= '0' && *mensaje <= '9') { //Si es un número
            indiceCaracter = *mensaje - '0';
            memcpy(caracter, figureOfNumbers[indiceCaracter], 8);
            scroll_figure(caracter);

            // _delay_ms(500);
        } else if(*mensaje == ' ') { // Si es un espacio
            uint8_t espacio[8] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
            scroll_figure(espacio);
            // _delay_ms(500);
        } else if(*mensaje >= '!' && *mensaje <= '/'){
            indiceCaracter = *mensaje - '!';
            memcpy(caracter, figureOfSpecialCharacters[indiceCaracter], 8);
            scroll_figure(caracter);

            // _delay_ms(500);
        } else{
			mensaje++;
			continue;
        }
        mensaje++;
    }
}

void convertirAMayusculas(char *cadena) {
    while (*cadena) {
        if (islower(*cadena)) {
            *cadena = toupper(*cadena);
        }
        cadena++;
    }
}

 void leerCadenaEEPROM(char *buffer, uint16_t direccionInicial) {
     uint16_t direccion = direccionInicial;
     while (1) {
         char c = eeprom_read_byte((uint8_t *)direccion);
         if (c == '\0') break;
         buffer[direccion - direccionInicial] = c;
         direccion++;
     }
     buffer[direccion - direccionInicial] = '\0'; // Finalizar cadena
 }

void escribirByteEEPROM(uint16_t direccion, uint8_t dato) {
    //Esperamos a que EEPROM este lista
    while (EECR & (1 << EEPE));

    EEAR = direccion;
    EEDR = dato;

    EECR |= (1 << EEMPE); //Habilitar escritura
    EECR |= (1 << EEPE); //Iniciar escritura
}

void guardarCadenaEEPROM(const char *cadena, uint16_t direccionInicial) {
    uint16_t direccion = direccionInicial;
    while (*cadena) {
        escribirByteEEPROM(direccion, *cadena);
        cadena++;
        direccion++;
    }
    // Guardar el carácter nulo al final
    escribirByteEEPROM(direccion, '\0');
}

/*************************************************************************
Librería UART para ATmega328p
*************************************************************************/

void UART_init(void);                       // Inicializar UART
unsigned char UART_read(void);             // Leer un byte recibido
void UART_write(unsigned char);            // Enviar un byte
void UART_write_txt(char*);                // Enviar una cadena de texto


void UART_init(void)
{
    UCSR0A = (0<<TXC0)|(0<<U2X0)|(0<<MPCM0);
    UCSR0B = (1<<RXCIE0)|(0<<TXCIE0)|(0<<UDRIE0)|(1<<RXEN0)|(1<<TXEN0)|(0<<UCSZ02)|(0<<TXB80);
    UCSR0C = (0<<UMSEL01)|(0<<UMSEL00)|(0<<UPM01)|(0<<UPM00)|(0<<USBS0)|(1<<UCSZ01)|(1<<UCSZ00)|(0<<UCPOL0);
    UBRR0 = 103;                            // Configurar baudrate a 9600 para 16 MHz
    // UBRR0 = 8;                            // Configurar baudrate a 9600 para 16 MHz
}

unsigned char UART_read(void)
{
    if(UCSR0A & (1<<7))                     // Si hay un byte recibido
        return UDR0;                        // Devolver byte recibido
    else
        return 0;
}

void UART_write(unsigned char caracter)
{
    while(!(UCSR0A & (1<<5)));              // Esperar a que el registro UDR0 esté vacío
    UDR0 = caracter;                        // Enviar el byte
}

void UART_write_txt(char* cadena)
{
    while(*cadena != 0x00)                  // Mientras no se alcance el fin de la cadena
    {
        UART_write(*cadena);               // Enviar caracter por caracter
        cadena++;                           // Incrementar el puntero
    }
}

/*************************************************************************
Código principal para comunicación con el ESP8266
*************************************************************************/

void sendATCommand(char* command)
{
    UART_write_txt(command);                // Enviar el comando AT
    UART_write('\r');                       // Enviar retorno de carro
    UART_write('\n');                       // Enviar nueva línea
}

void blinkLEDWifi(void)
{
	PORTD |= (1 << PD6);                        // Encender un LED
    _delay_ms(100);                             // Esperar respuesta
    PORTD &= ~(1 << PD6);                        // Apagar el LED
    _delay_ms(100);                             // Esperar respuesta
	
    PORTD |= (1 << PD6);                        // Encender un LED
    _delay_ms(100);                             // Esperar respuesta
    PORTD &= ~(1 << PD6);                        // Apagar el LED
    _delay_ms(100);                             // Esperar respuesta
    
    PORTD |= (1 << PD6);                        // Encender un LED
    _delay_ms(100);                             // Esperar respuesta
    PORTD &= ~(1 << PD6);                        // Apagar el LED
    _delay_ms(100);                             // Esperar respuesta
    
    PORTD |= (1 << PD6);                        // Encender un LED
    _delay_ms(100);                             // Esperar respuesta
    PORTD &= ~(1 << PD6);                        // Apagar el LED
    _delay_ms(100);                             // Esperar respuesta

}

void blinkLEDQuick(void)
{
	PORTD |= (1<<6);                        // Encender un LED
	_delay_ms(80);                             // Esperar respuesta
	PORTD &= ~(1<6);                        // Apagar el LED
	_delay_ms(80);                             // Esperar respuesta
	
	PORTD |= (1<<6);                        // Encender un LED
	_delay_ms(80);                             // Esperar respuesta
	PORTD &= ~(1<6);                        // Apagar el LED
	_delay_ms(80);                             // Esperar respuesta
	
	PORTD |= (1<<6);                        // Encender un LED
	_delay_ms(80);                             // Esperar respuesta
	PORTD &= ~(1<6);                        // Apagar el LED
	_delay_ms(80);                        // Esperar un poco

	PORTD |= (1<<6);                        // Encender un LED
	_delay_ms(80);                             // Esperar respuesta
	PORTD &= ~(1<6);                        // Apagar el LED
	_delay_ms(80);                             // Esperar respuesta
	
	PORTD |= (1<<6);                        // Encender un LED
	_delay_ms(80);                             // Esperar respuesta
	PORTD &= ~(1<6);                        // Apagar el LED
	_delay_ms(80);                             // Esperar respuesta
	
	PORTD |= (1<<6);                        // Encender un LED
	_delay_ms(80);                             // Esperar respuesta
	PORTD &= ~(1<6);                        // Apagar el LED
	_delay_ms(80);                        // Esperar un poco
}

void readResponse(void)
{
    memset(responseBuffer, 0, RESPONSE_BUFFER_SIZE);  // Limpiar el buffer
    char* ptr = responseBuffer;                // Apuntar al inicio del buffer

    for (int i = 0; i < RESPONSE_BUFFER_SIZE - 1; i++)
    {
        unsigned char data = UART_read();
        if (data != 0)
        {
			*ptr = data;                              // Almacenar el byte recibido
            ptr++;
            if (data == '$')  {                      // Terminar si se recibe nueva línea
                	break;
			}
        }
        _delay_ms(1);                                 // Pequeña espera entre lecturas
    }
}

void eliminarPatron(char *cadena) {
    char *posicion = cadena;
    while ((posicion = strstr(posicion, "+IPD,")) != NULL) {
        char *inicio = posicion;
        posicion += 5; // Saltar "+IPD,"

        // Avanzar sobre los dígitos de 'n'
        while (isdigit(*posicion)) {
            posicion++;
        }

        if (*posicion == ',') {
            posicion++; // Saltar la coma

            // Avanzar sobre los dígitos de 'm'
            while (isdigit(*posicion)) {
                posicion++;
            }

            if (*posicion == ':') {
                posicion++; // Saltar los dos puntos

                // Mover el contenido después del patrón para sobrescribirlo
                memmove(inicio, posicion, strlen(posicion) + 1);
                continue;
            }
        }

        posicion = inicio + 1; // Avanzar un carácter y continuar la búsqueda
    }

    // Eliminar saltos de línea y retornos de carro
    char *src = cadena, *dst = cadena;
    while (*src) {
        if (*src != '\n' && *src != '\r') {
            *dst++ = *src;
        }
        src++;
    }
    *dst = '\0'; // Asegurar que la cadena esté terminada en nulo
}

void configurarWifi() {
    sendATCommand("AT+CWMODE=2");            
    _delay_ms(100);
    sendATCommand("AT+CIPMUX=1");
    _delay_ms(100);
    sendATCommand("AT+CIPSERVER=1,80");
    _delay_ms(100);

    sendATCommand("AT+CWSAP=\"ESP\",\"123456789\",1,3");
    _delay_ms(2000);
	
	blinkLEDWifi();                   
}

ISR(USART_RX_vect)
{
    // blinkLEDQuick();
    readResponse();

    if(responseBuffer != NULL && strstr(responseBuffer, "IPD") != NULL){
        eliminarPatron(responseBuffer);

        convertirAMayusculas(responseBuffer);
        guardarCadenaEEPROM(responseBuffer, direccionInicial);
        _delay_ms(1);

        leerCadenaEEPROM(mensajeLeidoEEPROM, 0);
        _delay_ms(1);
    }
}

int main(void)
{
    setup_pins(); // Configurar pines
	UART_init(); // Inicializar UART
    _delay_ms(1000); 
    
    configurarWifi(); // Configurar el módulo ESP8266

	sei(); // Habilitar interrupciones globales

    while (1)
    {		
        if(mensajeLeidoEEPROM != NULL){
            leerCadenaEEPROM(mensajeLeidoEEPROM, 0);
            mandarCadenaAMatriz(mensajeLeidoEEPROM);
			UART_write_txt(mensajeLeidoEEPROM);
        } else{
            mandarCadenaAMatriz("EMPTY");
        }                        // Esperar antes de enviar el siguiente comando
    }
}