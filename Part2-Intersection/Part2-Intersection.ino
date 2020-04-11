extern "C" {
  void stage_1(int);
  void stage_2(int);
  void stage_3(int);
  void stage_4(int);
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
    " out 0x11, r18 \n"
    ::: "r16", "r18");
  //Serial.begin(9600);
  //Light1
}

const int TLight_1 = 1;
const int TLight_2 = 2;

void loop() {
  delay(1000);  
  stage_3(1);
  delay(1000);
  stage_4(1);
  delay(1000);
  stage_1(1);

  delay(1000);

  stage_1(2);
  delay(1000);
  stage_2(2);
  delay(1000);
  stage_3(2);

  delay(1000);

  stage_3(2);
  delay(1000);
  stage_4(2);
  delay(1000);
  stage_1(2);
  
  delay(1000);

  stage_1(1);
  delay(1000);
  stage_2(1);
  delay(1000);
  stage_3(1);
}
