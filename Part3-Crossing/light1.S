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
  .byte ~(GN_1 + YE_1 + RD_1) //Compliment
  .byte ~(GN_2 + YE_2 + RD_2)
  .byte ~(P_GN + P_RD)
  .byte 0x00

lights: 
  .byte RD_1
  .byte RD_1 + YE_1
  .byte GN_1
  .byte YE_1
  .byte RD_2
  .byte RD_2 + YE_2
  .byte GN_2
  .byte YE_2

//Registers - r17 - Outputs
//            r18 - Starting light config
start:
    ldi r17, RD_1 + YE_1 + GN_1 + RD_2 + YE_2 + GN_2 + P_GN + P_RD
    out 0x10, r17
    ldi r18, GN_1 + RD_2 + P_RD
    out 0x11, r18

    ret

//Parameters - r23:r24 - Light (0x00, 0x01)
//             r21:r22 - Stage (0x00 -> 0x03)
//
//Registers  - r17 - light config
//             r18 - mask
//             r19 - light
stage:
  in r17, 0x11        //Store light config
  
  ldi ZH, hi8(masks)  //Load masks table into Z
  ldi ZL, lo8(masks)
  add ZL, r24         //Index mask table by r24 (light param)
  lpm r18, Z          //Store mask value

  ldi ZH, hi8(lights) //Load lights table into Z
  ldi ZL, lo8(lights)
  ldi r19, NO_STAGES
  mul r19, r24        //Offset = NO_STAGES * light param
  mov r19, r0         //Store result of mul in r19
  add r19, r22        //Add stage param to offset
  add ZL, r19         //Index light table by r19
  lpm r19, Z          //Store light value

  and r17, r18        //Mask light config
  or  r17, r19        //Add new lights 
  out 0x11, r17       //Apply new light config
  
  ret
