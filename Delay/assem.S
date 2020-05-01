#include "avr/io.h"

.global assem_delay
.global start
.global displayByte

.equ COUNTS,       250 - 1 // 250 * 4us = 1ms
.equ START_COUNT, 0x03

//Parameters: 25:24 - Num of ms
//
assem_delay:
  call init
  call set_prescaler

  mov ZH, r25
  mov ZL, r24

cycle:
  cpi ZH, 0x00
  BRNE comparison
  
  cpi ZL, 0x00
  BREQ finish

comparison:
  call compare
  call reset_count
  
  clc
  subi ZL, 0x01
  sbci ZH, 0x00
  rjmp cycle

finish:
  call init //Stop the count

  ret

//Registers: r18 - TIFR1 (Interrupt Flag Register)
//
compare:

counter:
  lds r18, TIFR0
  sbrs r18, OCF0A //bit 1
  rjmp counter

ret

//Set all registers to 0
init:
  ldi r19, 0x00
  
  sts TCCR0B, r19 
  sts TCCR0A, r19
  sts TCNT0, r19

  ret

set_prescaler:
  ldi r20, COUNTS

  sts OCR0A, r20

  lds r18, TCCR0B
  
  andi r18, ~((1<<CS02)|(1<<CS01)|(1<<CS00)) //Clear relevant bits
  ori r18, START_COUNT                       //Set prescaler to 64
  sts TCCR0B, r18

  ret

reset_count:
  ldi r19, 0x00
  ldi r20, 0x02

  sts TCNT0, r19

  sts TIFR0, r20 //Set TIFR1 to 2 (64 prescaler)

  ret

start:
  ldi r18, 0xFF //Set all DDRF ports to output
  out 0x10, r18
  ldi r19, 0x00 //Turn all lights off
  out 0x11, r19

  ret

//Parameters - r24 - Input byte
//
displayByte:
  out 0x11, r24

  ret
