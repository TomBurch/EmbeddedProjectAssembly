extern "C" {
  void stage_1();
  void stage_2();
  void stage_3();
  void stage_4();
}

void setup {
  asm volatile (
    ".equ GN, 0x01          \n"
    ".equ YE, 0x02          \n"
    ".equ RD, 0x04          \n"
    "ldi r16, RD + YE + GN  \n"
    "out 0x10, r16          \n"
    "ldi r18, GN            \n"
    "out 0x11, r18          \n"
    ::: "r16", "r18");
}

void loop {
  stage_3();
  delay(1000);
  stage_4();
  delay(1000);
  stage_1();
  
  delay(1000);

  stage_1();
  delay(1000);
  stage_2();
  delay(1000);
  stage_3();
  
  delay(1000):
}
