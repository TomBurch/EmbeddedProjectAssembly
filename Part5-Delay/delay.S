#include "avr/io.h"

.global assem_delay

.equ COUNTS, 250 - 1 //250 * 4us = 1ms
.equ PRESCALER, 0x03 //Prescaler of 64

//Description: Repeats a 1ms delay x times using Timer0
//
//Parameters:  25:24 - Num of ms to delay
//
assem_delay:
  call clear_registers
  call start_timer

  mov ZH, r25          //Store ms param in Z register (as it's 16 bit)
  mov ZL, r24

cycle:
  cpi ZH, 0x00         //Check if ZH == 0
  BRNE timer           //If not, branch to comparison
  
  cpi ZL, 0x00         //Check if ZL == 0
  BREQ finish          //If both ZH and ZL are 0, delay is finished

timer:
  call wait_for_timer
  call reset_count
  
  clc                  //Clear carry before subtraction
  subi ZL, 0x01        //Subtract 1 from ZL
  sbci ZH, 0x00        //Subtract carry from ZH
  rjmp cycle           //Jump to start of cycle

finish:
  call clear_registers

  ret

//Description: Clears TCCR0A, TCCR0B (Timer Counter Control Registers)
//             and TCNT0 (Timer/Counter Register)
//
//Registers: r19 - Zero
//
clear_registers:
  ldi r19, 0x00
  
  sts TCCR0B, r19 
  sts TCCR0A, r19
  sts TCNT0, r19

  ret

//Description: Sets OCR0A to 250 and the prescaler to 64,
//             beginning a 1ms delay
//
//Registers: r20 - COUNTS
//           r18 - TCCR0B (Timer/Counter Control Register B)
start_timer:
  ldi r20, COUNTS
  sts OCR0A, r20  //Set Output Compare Register A to COUNTS

  lds r18, TCCR0B                            //Get TCCR0B
  andi r18, ~((1<<CS02)|(1<<CS01)|(1<<CS00)) //Clear prescaler bits
  ori r18, PRESCALER                         //Set prescaler to 64
  sts TCCR0B, r18                            //Apply new prescaler, starting the timer

  ret

//Description: Waits until the OCF0A bit of TIFR0 is set, 
//             indicating that Timer0 has finished
//
//Registers: r18 - TIFR0 (Timer Interrupt Flag Register)
//
wait_for_timer:

wait:
  lds r18, TIFR0  //Get TIFR0
  sbrs r18, OCF0A //When OCF0A (bit 1 of TIFR0) is 1, timer is finished
  rjmp wait

ret

//Description: Clears the TCNT0 and OCF0A to prepare
//             for another cycle
//
//Registers: r19 - Zero
//           r20 - Two
reset_count:
  ldi r19, 0x00
  ldi r20, 0x02

  sts TCNT0, r19 //Sets the counter to 0
  sts TIFR0, r20 //Sets the OCF0A (Output Compare A Match Flag) to 1, clearing it

  ret
