#include "avr/io.h"

.global start
.global sort
.global swap
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
displayByte:
  out 0x11, r24

  ret

sort:

  ret

//Parameters - r25:r24 - Adr of byte A
//           - r23:r22 - Adr of byte B
//
//Registers  - r16 - Value of byte A
//           - r17 - Value of byte B
swap:
  mov XH, r25
  mov XL, r24
  ld r16, X // Retrieve value of byte A

  mov YH, r23
  mov YL, r22
  ld r17, Y // Retrieve value of byte B

  st X, r17 // Store value of A in Adr B
  st Y, r16 // Store value of B in Adr A
  
  ret
  
