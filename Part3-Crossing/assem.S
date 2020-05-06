#include "avr/io.h"

.global start
.global stage

.equ GN_1, 0x01
.equ YE_1, 0x02
.equ RD_1, 0x04
.equ GN_2, 0x08
.equ YE_2, 0x10
.equ RD_2, 0x20
.equ P_GN, 0x40
.equ P_RD, 0x80
.equ NO_STAGES, 0x04

masks:
  .byte ~(GN_1 + YE_1 + RD_1)
  .byte ~(GN_2 + YE_2 + RD_2)
  .byte ~(P_GN + P_RD)
  .byte 0x00 //Fill table to even number of columns

lights: 
  .byte RD_1
  .byte RD_1 + YE_1
  .byte GN_1
  .byte YE_1
  .byte RD_2
  .byte RD_2 + YE_2
  .byte GN_2
  .byte YE_2
  .byte P_RD
  .byte P_GN
  .byte 0x00 //Lights off
  .byte 0x00 //Fill table to even number of columns

//Registers - r18 - Outputs
//            r19 - Starting light config
start:
  ldi r18, RD_1 + YE_1 + GN_1 + RD_2 + YE_2 + GN_2 + P_GN + P_RD
  out 0x10, r18               //Set output lights
  ldi r19, GN_1 + GN_2 + P_RD
  out 0x11, r19               //Turn starting lights on

  ret

//Parameters - r24 - Light (0x00 -> 0x02)
//             r22 - Stage (0x00 -> 0x03)
//
//Registers  - r2 - light config
//             r3 - mask
//             r16 - light
stage:
  push r2
  push r3
  push r16

  ldi r16, NO_STAGES

  ldi ZH, hi8(lights) //Load lights table into Z
  ldi ZL, lo8(lights)
  
  mul r16, r24        //Offset = NO_STAGES * light param
  mov r16, r0         //Store result of mul in r16
  add r16, r22        //Offset = Offset + stage param
  add ZL, r16         //Offset address by value in r16
  lpm r16, Z          //Store light value from offset address

  ldi ZH, hi8(masks)  //Load address of masks into Z
  ldi ZL, lo8(masks)
  add ZL, r24         //Index mask table by r24 (light param)
  lpm r3, Z           //Store mask value from offset address

  in r2, 0x11         //Store current light config
  and r2, r3          //Mask light config
  or  r2, r16         //Add new lights 
  out 0x11, r2        //Apply new light config

  pop r16
  pop r3
  pop r2
  
  ret
