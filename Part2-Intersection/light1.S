#include "avr/io.h"

.global stage

masks:
  .byte 0x07 //GN_1 + YE_1 + RD_1
  .byte 0x38 //GN_2 + YE_2 + RD_2

lights: 
  .byte 0x04 //RD_1
  .byte 0x06 //RD_1 + YE_1
  .byte 0x01 //GN_1
  .byte 0x02 //YE_1
  .byte 0x20 //RD_2
  .byte 0x30 //RD_2 + YE_2
  .byte 0x08 //GN_2
  .byte 0x10 //YE_2

.equ NO_STAGES, 0x04

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
  com r18             //One's complement

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
