extern "C" {
  void start();
  void stage(int, int);
}

void setup() {
  start();
}

const byte TLIGHT_1 = 0;
const byte TLIGHT_2 = 1;
const byte RD       = 0;
const byte RD_YE    = 1;
const byte GN       = 2;
const byte YE       = 3;

void redToGreen(int TLight) {
  stage(TLight, RD_YE);
  delay(1000);
  stage(TLight, GN);
}

void greenToRed(int TLight) {
  stage(TLight, YE);
  delay(1000);
  stage(TLight, RD);
}

void loop() {
  delay(2000);
  
  greenToRed(TLIGHT_1);
  delay(1000);
  redToGreen(TLIGHT_2);
  
  delay(2000);
  
  greenToRed(TLIGHT_2);
  delay(1000);
  redToGreen(TLIGHT_1);
}
