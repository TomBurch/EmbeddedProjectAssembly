#include "avr/io.h"

.global start
.global displayByte

start:
  ldi r18, 0xFF
  out 0x10, r18
  ldi r19, 0x00
  out 0x11, r19

  ret

displayByte:
  out 0x11, r24

  ret
