#include "avr/io.h"

.global del
.global displayByte
.global start

// TCCR0A, 0x44
// TCCR0B, 0x45
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
del:
  push r4

  //call stop_counter
  call start_counter

  ldi r19, 0x00
  mov ZH, r25
  mov ZL, r24

compare:
  cpi ZH, 0x00
  BRNE counter
  
  cpi ZL, 0x00
  BREQ finish

counter:
  in r18, TIFR0
  cpi r18, 0x02
  //brne counter
  ////sbrs r4, OCF0A //bit 1
  
  ////rjmp counter

  //call stop_counter
  clc
  subi ZL, 0x01
  sbci ZH, 0x00
  rjmp compare
  
finish:
  call stop_counter

  pop r4

  ret

//Registers: r18 - TCCR0 config
//           r19 - ZERO
stop_counter:
  push 28 //Y registers
  push 29
  //ldi ZH, hi8(TCCR0B)
  //ldi ZL, lo8(TCCR0B)
  //ld r18, Z
  
  //andi r18, ~((1<<CS02)|(1<<CS01)|(1<<CS00)) //Clear relevant bits
  //st Z, r18

  ldi r19, 0x00
  ldi r20, 0x02

  ldi YH, hi8(TCNT0)
  ldi YL, lo8(TCNT0)
  st Y, r19

  ldi YH, hi8(TIFR0)
  ldi YL, lo8(TIFR0)
  st Y, r20

  pop 29
  pop 28

  ret

//Registers: r18 - temp register
//           r19 - ZERO
//           r20 - COUNTS
start_counter:
  push 28
  push 29
  
  ldi r19, 0x00
  ldi r20, COUNTS
  
  ldi YH, hi8(TCCR0B) //TCCR0B = 0
  ldi YL, lo8(TCCR0B)
  st Y, r19

  ldi YH, hi8(TCCR0A) //TCCR0A = 0
  ldi YL, lo8(TCCR0A)
  st Y, r19

  ldi YH, hi8(TCNT0) //TCNT0 = 0
  ldi YL, lo8(TCNT0)
  st Y, r19

  ldi YH, hi8(OCR0A) //OCR0A = 249
  ldi YL, lo8(OCR0A)
  st Y, r20

  //ldi ZH, hi8(TCCR0A)
  //ldi ZL, lo8(TCCR0A)
  //ld r18, Z

  //andi r18, ~((1<<WGM01))
  //ori r18, 0x02 //Set to compare-match mode
  //st Z, r18

  //call continue_count

  ldi YH, hi8(TCCR0B)
  ldi YL, lo8(TCCR0B)
  ld r18, Y
  
  andi r18, ~((1<<CS02)|(1<<CS01)|(1<<CS00)) //Clear relevant bits
  ori r18, START_COUNT                       //Set prescaler to 64
  st Y, r18

  pop 29
  pop 28

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
