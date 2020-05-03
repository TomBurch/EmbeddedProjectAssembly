#include "avr/io.h"

.global start
.global quicksort
.global partition
.global swap
.global displayByte

.equ ZERO, 0x00

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

//Parameters - r25:r24 - Adr of array
//           -     r22 - low index
//           -     r20 - high index
//
//Registers  - r3:r2 - Adr of array
//           -    r4 - low index
//           -    r5 - high index
//           -    r6 - partition ret value
quicksort:
  push r2
  push r3
  push r4
  push r5
  push r6

  mov r2, r24
  mov r3, r25
  mov r4, r22
  mov r5, r20 // Store parameters

  cp r4, r5
  brsh NOIF   // if not (low < high), break

  call partition
  mov r6, r25 // Store partition return

  mov r22, r4
  mov r20, r6
  dec r20
  mov r24, r2
  mov r25, r3 // Load quicksort parameters
  call quicksort

  mov r22, r6
  inc r22
  mov r20, r5
  mov r24, r2
  mov r25, r3 // Load quicksort parameters
  call quicksort
  
NOIF: 
  pop r6
  pop r5
  pop r4
  pop r3
  pop r2
  
  ret

//Parameters - r25:r24 - Adr of array
//           -     r22 - low index
//           -     r20 - high index
//
//Registers  - r2    - i increment
//           - r3    - j increment
//           - r4    - pivot
//           - r5    - low index
//           - r6    - high index
//           - r8:r7 - Adr of array
//           - r9    - Array[j]
//           - r16   - ZERO
//
//Returns    - r25 - i increment
partition:  
  push r2
  push r3
  push r4
  push r5
  push r6
  push r7
  push r8
  push r9
  push r16
  push r28 //Y
  push r29 //Y
  
  ldi r16, ZERO
  mov r5, r22
  mov r6, r20
  mov r7, r24
  mov r8, r25
   
  //byte pivot = array[high];
  mov ZH, r8
  mov ZL, r7  // Get Adr of array
  add ZL, r6
  adc ZH, r16 // Get Adr of high index 
  ld  r4, Z   // Store value of high index (pivot) 

  //byte i = low;
  mov r2, r5  // i increment

  //byte j = low
  mov r3, r5  // j increment
  
FOR:
  cp r3, r6
  brsh ENDFOR // if not (j < high index), break

  mov YH, r8
  mov YL, r7  // Get Adr of array
  add YL, r3
  adc YH, r16 // Get Adr of array[j]
  ld  r9, Y   // Store value of array[j]

  cp  r9, r4
  brsh NOSWAP // if not (array[j] < pivot), break
  
  mov XH, r8
  mov XL, r7  // Get Adr of array
  add XL, r2  // Get Adr of array[i]
  adc XH, r16

  mov r24, XL
  mov r25, XH
  mov r22, YL
  mov r23, YH

  call swap
  inc r2 // i++

NOSWAP:
  inc r3 // j++
  JMP FOR
ENDFOR:
  mov XH, r8
  mov XL, r7 // Get Adr of array
  add XL, r2 // Get Adr of array[i]
  adc XH, r16
  
  mov r24, XL
  mov r25, XH
  mov r22, ZL
  mov r23, ZH // swap(&array[i], &array[high]
  call swap

  mov r25, r2

  pop r29 //Y
  pop r28 //Y
  pop r16
  pop r9
  pop r8
  pop r7
  pop r6
  pop r5
  pop r4
  pop r3
  pop r2
  
  ret

//Parameters - r25:r24 - Adr of byte A
//           - r23:r22 - Adr of byte B
//
//Registers  - r16 - Value of byte A
//           - r17 - Value of byte B
swap:
  push r16
  push r17
  push r28 //Y
  push r29 //Y
  
  mov XH, r25
  mov XL, r24
  ld r16, X // Retrieve value of byte A

  mov YH, r23
  mov YL, r22
  ld r17, Y // Retrieve value of byte B

  st X, r17 // Store value of A in Adr B
  st Y, r16 // Store value of B in Adr A

  pop r29 //Y
  pop r28 //Y
  pop r17
  pop r16
  
  ret
  
