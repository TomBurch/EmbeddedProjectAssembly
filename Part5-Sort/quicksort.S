#include "avr/io.h"

.global quicksort

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

  mov r2, r24    //Store adr of array
  mov r3, r25
  mov r4, r22    //Store low index
  mov r5, r20    //Store high index

  cp r4, r5
  brsh NOIF      //if not (low < high), break

  call partition
  mov r6, r25    //Store partition return

  mov r22, r4    //Load quicksort parameters
  mov r20, r6
  dec r20        //p - 1
  mov r24, r2
  mov r25, r3
  call quicksort //quicksort(array, low, p - 1)

  mov r22, r6    //Load quicksort parameters
  inc r22        //p + 1
  mov r20, r5
  mov r24, r2
  mov r25, r3
  call quicksort //quicksort(array, p + 1, high)
  
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
//           - r16   - Zero
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
  push r28 //YL
  push r29 //YH
  
  ldi r16, 0x00
  mov r5, r22 //Store low index
  mov r6, r20 //Store high index
  mov r7, r24 //Store adr of array
  mov r8, r25
   
  //byte pivot = array[high];
  mov ZH, r8  //Get Adr of array
  mov ZL, r7  
  add ZL, r6  //Get Adr of array[high] 
  adc ZH, r16 
  ld r4, Z    //Load value of array[high] (pivot) 

  //byte i = low;
  mov r2, r5  //i increment

  //byte j = low
  mov r3, r5  //j increment
  
FOR:
  cp r3, r6
  brsh ENDFOR //if not (j < high index), break

  mov YH, r8  //Get Adr of array
  mov YL, r7  
  add YL, r3  //Get Adr of array[j]
  adc YH, r16 
  ld r9, Y    //Load value of array[j]

  cp r9, r4
  brsh NOSWAP //if not (array[j] < pivot), break
  
  mov XH, r8  //Get Adr of array
  mov XL, r7   
  add XL, r2  //Get Adr of array[i]
  adc XH, r16

  mov r24, XL //Move array[i] into r25:r24
  mov r25, XH
  mov r22, YL //Move array[j] into r23:r22
  mov r23, YH

  call swap   //swap(array[i], array[j])
  inc r2      //i++

NOSWAP:
  inc r3 // j++
  jmp FOR
  
ENDFOR:
  mov XH, r8  //Get Adr of array
  mov XL, r7 
  add XL, r2  //Get Adr of array[i]
  adc XH, r16
  
  mov r24, XL
  mov r25, XH
  mov r22, ZL
  mov r23, ZH 
  
  call swap   //swap(&array[i], &array[high])

  mov r25, r2 //return i

  pop r29
  pop r28
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
//Registers  - r2 - Value of byte A
//           - r3 - Value of byte B
swap:
  push r2
  push r3
  push r28    //YL
  push r29    //YH
  
  mov XH, r25 //Load address of byte A into X
  mov XL, r24
  ld r2, X    //Retrieve value of byte A

  mov YH, r23 //Load address of byte B into Y
  mov YL, r22 
  ld r3, Y    //Retrieve value of byte B

  st X, r3    //Store value of A in Adr B
  st Y, r2    //Store value of B in Adr A

  pop r29
  pop r28
  pop r3
  pop r2
  
  ret
  
