#include "avr/io.h"

.global stage_1
.global stage_2
.global stage_3
.global stage_4

.equ  GN_LIGHT,   0x20 //00100000
.equ  YE_LIGHT,   0x40 //01000000
.equ  RD_LIGHT,   0x80 //10000000
.equ  GN_LIGHT_2, 0x10 //00000100
.equ  YE_LIGHT_2, 0x10 //00001000
.equ  RD_LIGHT_2, 0x10 //00010000

stage_1:

  ldi r18, RD_LIGHT
  out 5, r18
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
