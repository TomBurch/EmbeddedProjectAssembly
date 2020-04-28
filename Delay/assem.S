#include "avr/io.h"

.global del
.global displayByte
.global start

// TCCR0A, 0x44
// TTCR0B, 0x45
// TCNT0, 0x46
// OCR0A, 0x47
// TIFR0, 0x35
//
// TISMSK0, 0x6E

.equ PRESCALER,     64     // 16 MHz / 64 = 4us
.equ COUNTS,       250 - 1 // 250 * 4us = 1ms
.equ STOP_COUNT,  0x00
.equ START_COUNT, 0x03

//Parameters: 25:24 - Num of ms
//
//Registers: r4  - TIFR0
//           r19 - ZERO
//           r20 - COUNTS
del:
  push r4

  call stop_counter
  call start_counter

  ldi r19, 0x00
  ldi r20, COUNTS
  mov ZH, r25
  mov ZL, r24

compare:
  cpi ZH, ZERO
  BRNE counter
  
  cpi ZL, ZERO
  BREQ finish

counter:
  in r4, TIFR0
  sbrs r4, OCF0A //bit 1

  rjmp counter
  
  clc //Clear carry
  sub ZL, 0x01
  sbc ZH, 0x00
  rjmp compare
  
finish:
  call stop_counter

  pop r4

  ret

//Registers: r18 - TCCR0 config
//
stop_counter:
  in r18, TCCR0                              //Get current TCCR0 config
  andi r18, ~((1<<CS02)|(1<<CS01)|(1<<CS00)) //Clear relevant bits
  out TCCR0, r18                             //Output with cleared bits

  ret

//Registers: r18 - temp register
//           r19 - ZERO
//           r20 - COUNTS
start_counter:
  ldi r19, 0x00
  ldi r20, COUNTS
  
  out TCNT0, r19
  out OCR0A, r20
  call continue_count

  in r18, TCCR0                              //Get current TCCR0 config
  andi r18, ~((1<<CS02)|(1<<CS01)|(1<<CS00)) //Clear relevant bits
  or r18, START_COUNT                        //Set prescaler to 64
  out TCCR0, r18                             //Output with new prescaler, which starts the count

  ret

continue_count:
  ldi r18, (1<<OCF0A) //Clear the Output Compare Match Flag
  out TIFR0, r18      //Output with cleared flag

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
