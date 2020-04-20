#include "avr/io.h"

.global start
.global sort
.global displayByte

start:
  ldi r17, 0xFF //Set all DDRF ports to output
  out 0x10, r17
  ldi r18, 0x00 //Turn all lights off
  out 0x11, r18

  ret

//sort:

//Parameters - r23:r24 - Input byte
//
//Registers  - 
//
displayByte:
  out 0x11, r24

  ret
  
