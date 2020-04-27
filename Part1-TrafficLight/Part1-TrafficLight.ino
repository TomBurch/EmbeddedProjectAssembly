extern "C" {
  void start();
  void stage(int);
}

void setup() {
  start();
}

const byte RD    = 0;
const byte RD_YE = 1;
const byte GN    = 2;
const byte YE    = 3;

void redToGreen() {
  stage(RD_YE);
  delay(1000);
  stage(GN);
}

void greenToRed() {
  stage(YE);
  delay(1000);
  stage(RD);
}

void loop () {
  delay(2000);
  greenToRed();
  delay(2000);
  redToGreen();
}
