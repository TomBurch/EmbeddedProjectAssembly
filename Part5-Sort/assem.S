#include "avr/io.h"

.global start
.global displayByte

//Registers - r18 - Outputs
//          - r19 - Starting light config
start:
  ldi r18, 0xFF //Set all DDRF ports to output
  out 0x10, r18
  ldi r19, 0x00 //Turn all lights off
  out 0x11, r19

  ret

//Parameters - r24 - Byte to display
//
displayByte:
  out 0x11, r24

  ret
