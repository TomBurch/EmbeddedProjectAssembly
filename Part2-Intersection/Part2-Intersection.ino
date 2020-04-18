extern "C" {
  void start();
  void stage(int, int);
}

void setup() {
  start();
}

const byte TLIGHT_1 = 0;
const byte TLIGHT_2 = 1;
const byte T_RD     = 0;
const byte T_RD_YE  = 1;
const byte T_GN     = 2;
const byte T_YE     = 3;

void redToGreen(int TLight) {
  stage(TLight, T_RD);
  delay(1000);
  stage(TLight, T_RD_YE);
  delay(1000);
  stage(TLight, T_GN);
}

void greenToRed(int TLight) {
  stage(TLight, T_GN);
  delay(1000);
  stage(TLight, T_YE);
  delay(1000);
  stage(TLight, T_RD);
}

void loop() {
  greenToRed(TLIGHT_1);
  redToGreen(TLIGHT_2);
  delay(2000);          //Traffic flowing, TLight_2
  greenToRed(TLIGHT_2);
  redToGreen(TLIGHT_1);
  delay(2000);          //Traffic flowing, TLight_1
}
