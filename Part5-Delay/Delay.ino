#include "avr/io.h"

extern "C" {
  void del(unsigned int);
  void displayByte(byte);
  void start();
  //
  void init();
  void set_prescaler();
  void reset_count();
  void compare();
  void assem_delay(unsigned int);
}

void setup() {
  start();
}

int seconds = 1;

void flash() {
  displayByte(seconds);
  seconds++;
}

void loop() {
  assem_delay(1000);
  flash();
}
