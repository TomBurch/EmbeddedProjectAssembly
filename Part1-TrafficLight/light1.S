#include "avr/io.h"

.global clear_all
.global stage_1
.global stage_2
.global stage_3
.global stage_4

.equ  GN_1, 0x20                  //00100000
.equ  YE_1, 0x40                  //01000000
.equ  RD_1, 0x80                  //10000000
.equ  GN_2, 0x04                  //00000100
.equ  YE_2, 0x08                  //00001000
.equ  RD_2, 0x10                  //00010000
.equ  MASK_1, GN_1 + YE_1 + RD_1  //11100000
.equ  MASK_2, GN_2 + YE_2 + RD_2  //00011100

clear_all:
  ldi r16, 0x00
  out 5, r16
  ret

//Parameter r23:r24 - Light (0x01, 0x02)
stage_1:
  in  r19, 5          //Save current light config
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
  out 5, r19    //Apply new light config

  ret

//Parameter r23:r24 - Light (0x01 or 0x02)
stage_2:
  in  r19, 5          //Save current light config
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
  out 5, r19    //Apply new light config

  ret

//Parameter r23:r24 - Light (0x01 or 0x02)
stage_3:
  in  r19, 5          //Save current light config
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
  out 5, r19    //Apply new light config

  ret

//Parameter r23:r24 - Light (0x01 or 0x02)
stage_4:
  in  r19, 5          //Save current light config
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
  out 5, r19    //Apply new light config

  ret
