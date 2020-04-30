#include "avr/io.h"
//https://gyazo.com/5cfec7f22a7216b49b74bf7690f03fac
extern "C" {
  void del(unsigned int);
  void displayByte(byte);
  void start();
}

void setup() {

  start();

  //TCCR1A = 0;
  //TCCR1B = 0;
  //TCNT1 = 0;

  //OCR1A = 31250; // compare match register 16MHz/256/2Hz
  //TCCR1B |= (1 << CS12); // 256 prescaler
}

int seconds = 1;
//ISR(TIMER1_COMPA_vect) // timer compare interrupt service routine
void flash() {
  //TCNT1 = 0;
  //TIFR1 = 2;
  displayByte(seconds);
  seconds++;
}

void loop() {
  //while ((TIFR1 & 2) == 0) {}
  del(60000);
  flash();
  
  //displayByte(1);
  //del(1000);
  //displayByte(2);
  //del(1000);
}
