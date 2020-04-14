#include "avr/io.h"
//#include "avr/pgmspace.h"

.global stage_1
.global stage_2
.global stage_3
.global stage_4

.global stage

.equ  GN_1, 0x01                  //00000001
.equ  YE_1, 0x02                  //00000010
.equ  RD_1, 0x04                  //00000100
.equ  GN_2, 0x08                  //00001000
.equ  YE_2, 0x10                  //00010000
.equ  RD_2, 0x20                  //00100000
.equ  MASK_1, GN_1 + YE_1 + RD_1  //00111000
.equ  MASK_2, GN_2 + YE_2 + RD_2  //00000111
.equ  NO_STAGES, 0x04

masks:
.byte 0x07
.byte 0x38

lights: 
.byte 0x04
.byte 0x06 
.byte 0x01
.byte 0x02
.byte 0x20
.byte 0x30
.byte 0x08
.byte 0x10

//Parameter r23:r24 - Light (0x00, 0x01)
//          r21:r22 - Stage (0x00 -> 0x03)
stage:
  //r18 mask
  ldi ZH, hi8(masks)
  ldi ZL, lo8(masks)
  add ZL, r24 //Index mask table by r24
  lpm r18, Z  //Store mask value in table
  com r18     //One's complement

  ldi ZH, hi8(lights)
  ldi ZL, lo8(lights)
  ldi r19, NO_STAGES
  mul r19, r24 //Offset
  add r19, r22
  add ZL, r19
  lpm r19, Z
  
  out 0x11, r19
  ret

//Parameter r23:r24 - Light (0x01, 0x02)
stage_1:
  in  r19, 0x11         //Save current light config
  ldi r16, 0x01

  cp r16, r24
  breq bank_1
  
  ldi r18, MASK_2
  com r18         //One's complement
  ldi r17, RD_2
  jmp cont

  bank_1:
  ldi r18, MASK_1
  com r18         //One's complement
  ldi r17, RD_1

  cont:
  and r19, r18  //Mask light config
  or  r19, r17  //Add new lights
  out 0x11, r19    //Apply new light config

  ret

//Parameter r23:r24 - Light (0x01 or 0x02)
stage_2:
  in  r19, 0x11          //Save current light config
  ldi r16, 0x01

  cp r16, r24
  breq bank_12
  
  ldi r18, MASK_2
  com r18         //One's complement
  ldi r17, RD_2 + YE_2
  jmp cont2

  bank_12:
  ldi r18, MASK_1
  com r18         //One's complement
  ldi r17, RD_1 + YE_1

  cont2:
  and r19, r18  //Mask light config
  or  r19, r17  //Add new lights
  out 0x11, r19    //Apply new light config

  ret

//Parameter r23:r24 - Light (0x01 or 0x02)
stage_3:
  in  r19, 0x11          //Save current light config
  ldi r16, 0x01

  cp r16, r24
  breq bank_13
  
  ldi r18, MASK_2
  com r18         //One's complement
  ldi r17, GN_2
  jmp cont3

  bank_13:
  ldi r18, MASK_1
  com r18         //One's complement
  ldi r17, GN_1

  cont3:
  and r19, r18  //Mask light config
  or  r19, r17  //Add new lights
  out 0x11, r19    //Apply new light config

  ret

//Parameter r23:r24 - Light (0x01 or 0x02)
stage_4:
  in  r19, 0x11          //Save current light config
  ldi r16, 0x01

  cp r16, r24
  breq bank_14
  
  ldi r18, MASK_2
  com r18         //One's complement
  ldi r17, YE_2
  jmp cont4

  bank_14:
  ldi r18, MASK_1
  com r18         //One's complement
  ldi r17, YE_1

  cont4:
  and r19, r18  //Mask light config
  or  r19, r17  //Add new lights
  out 0x11, r19    //Apply new light config

  ret
