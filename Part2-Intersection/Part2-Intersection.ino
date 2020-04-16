extern "C" {
  void start();
  void stage(int, int);
}

void setup() {
  start();
}

const int TLIGHT_1 = 0;
const int TLIGHT_2 = 1;

void redToGreen(int TLight) {
  stage(TLight, 0);
  delay(1000);
  stage(TLight, 1);
  delay(1000);
  stage(TLight, 2);
}

void greenToRed(int TLight) {
  stage(TLight, 2);
  delay(1000);
  stage(TLight, 3);
  delay(1000);
  stage(TLight, 0);
}

void loop() {
  greenToRed(TLIGHT_1);
  //delay(500);
  redToGreen(TLIGHT_2);
  delay(1000);
  greenToRed(TLIGHT_2);
  //delay(500);
  redToGreen(TLIGHT_1);
  delay(1000);
}
