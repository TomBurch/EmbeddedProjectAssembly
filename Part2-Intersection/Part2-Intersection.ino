extern "C" {
  void stage(int, int);
}

void setup() {
  asm volatile (
    " .equ  GN_1, 0x01  \n"
    " .equ  YE_1, 0x02  \n"
    " .equ  RD_1, 0x04  \n"
    " .equ  GN_2, 0x08  \n"
    " .equ  YE_2, 0x10  \n"
    " .equ  RD_2, 0x20  \n"  
    " ldi r16, RD_1 + YE_1 + GN_1 + RD_2 + YE_2 + GN_2  \n"
    " out 0x10, r16  \n"
    " ldi r18, GN_1 + RD_2  \n"
    //"ldi r18, GN_1 + RD_1 + YE_1 \n"
    " out 0x11, r18 \n"
    ::: "r16", "r18");
}

const int TLIGHT_1 = 0;
const int TLIGHT_2 = 1;

void loop() {
  stage(TLIGHT_1, 2);
  delay(1000);
  stage(TLIGHT_1, 3);
  delay(1000);
  stage(TLIGHT_1, 0);
  
  delay(1000);

  stage(TLIGHT_2, 0);
  delay(1000);
  stage(TLIGHT_2, 1);
  delay(1000);
  stage(TLIGHT_2, 2);

  delay(1000);

  stage(TLIGHT_2, 2);
  delay(1000);
  stage(TLIGHT_2, 3);
  delay(1000);
  stage(TLIGHT_2, 0);
  
  delay(1000);

  stage(TLIGHT_1, 0);
  delay(1000);
  stage(TLIGHT_1, 1);
  delay(1000);
  stage(TLIGHT_1, 2);
  
  delay(1000);
}
