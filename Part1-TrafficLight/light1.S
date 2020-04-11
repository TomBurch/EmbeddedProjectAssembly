#include "avr/io.h"

.global clear_all
.global stage_1
.global stage_2
.global stage_3
.global stage_4

.equ  GN_LIGHT,   0x20  //00100000
.equ  YE_LIGHT,   0x40  //01000000
.equ  RD_LIGHT,   0x80  //10000000
.equ  GN_LIGHT_2, 0x20  //00000100
.equ  YE_LIGHT_2, 0x40  //00001000
.equ  RD_LIGHT_2, 0x10  //00010000

clear_all:
  ldi r16, 0x00
  out 5, r16
  ret

stage_1:
  mov r16, r24		    //Store parameter in r16
  ldi r17, RD_LIGHT
  ldi r18, 0x01
  in  r19, 5

  cp r16, r18         //If param == 1
  breq end_branch     //Turn on RD_LIGHT
  
  ldi r17, RD_LIGHT_2 //Otherwise, set r17 to RD_LIGHT_2  
  rjmp end_branch     //Turn on RD_LIGHT_2

  end_branch:
  add r19, r17
  out 5, r19
  
  ret

stage_2:
  ldi r18, RD_LIGHT + YE_LIGHT
  out 5, r18 
  ret

stage_3:
  ldi r18, GN_LIGHT
  out 5, r18 
  ret

stage_4:
  ldi r18, YE_LIGHT
  out 5, r18
  ret
