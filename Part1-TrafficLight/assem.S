#include "avr/io.h"

.global start
.global stage

.equ GN, 0x01
.equ YE, 0x02
.equ RD, 0x04

lights:
  .byte RD
  .byte RD + YE
  .byte GN
  .byte YE

//Registers  - r18 - Outputs
//             r19 - Starting light config
start:
  ldi r18, RD + YE + GN
  out 0x10, r18         //Set output lights
  ldi r19, GN
  out 0x11, r19         //Turn green light on

  ret

//Parameters - r24 - Stage (0x00 -> 0x03)
//
//Registers  - r2  - light config
//
stage:
  push r2
  
  ldi ZH, hi8(lights) //Load address of lights into Z
  ldi ZL, lo8(lights)
  add ZL, r24         //Offset address by value in r24
  lpm r2, Z           //Store value from offset address

  out 0x11, r2        //Apply new lights
  
  pop r2

  ret
