extern "C" {
  void stage_1();
  void stage_2();
  void stage_3();
  void stage_4();
}

void setup() {
  asm volatile (
    " .equ  RD_LIGHT, 0x80  \n"
    " .equ  YE_LIGHT, 0x40  \n"
    " .equ  GN_LIGHT, 0x20  \n"
    " ldi r16, RD_LIGHT + YE_LIGHT + GN_LIGHT \n"
    " out 4, r16  \n"
    " ldi r18, GN_LIGHT \n"
    " out 5, r18 \n"
    ::: "r16", "r18");
  //Serial.begin(9600);
  //Light1
}

void loop() {  
  stage_1();
  delay(1000);
  stage_2();
  delay(1000);
  stage_3();
  delay(1000);
  stage_4();
  delay(1000);
}
