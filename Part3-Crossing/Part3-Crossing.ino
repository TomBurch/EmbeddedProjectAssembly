extern "C" {
  void start();
  void stage(int, int);
}

const byte TLIGHT_1 = 0;
const byte TLIGHT_2 = 1;
const byte PLIGHT   = 2;
const byte T_RD     = 0;
const byte T_RD_YE  = 1;
const byte T_GN     = 2;
const byte T_YE     = 3;
const byte P_RD     = 0;
const byte P_GN     = 1;
const byte P_OFF    = 2;

void redToGreen() {
  stage(TLIGHT_1, T_RD_YE);
  stage(TLIGHT_2, T_RD_YE);
  delay(1000);
  stage(TLIGHT_1, T_GN);
  stage(TLIGHT_2, T_GN);
}

void greenToRed() {
  stage(TLIGHT_1, T_YE);
  stage(TLIGHT_2, T_YE);
  delay(1000);
  stage(TLIGHT_1, T_RD);
  stage(TLIGHT_2, T_RD);
}

void flashGreen() {
  for (int i = 0; i < 5; i++) {
    stage(PLIGHT, P_GN);
    delay(200);
    stage(PLIGHT, P_OFF);
    delay(200);
  }
}

void changePLight() {
  stage(PLIGHT, P_GN);
  delay(2000);
  flashGreen();
  stage(PLIGHT, P_RD);
}

void setup() {
  Serial.begin(19200);
  start();
}

char command;

void loop() {
  while (!Serial.available()) {} //Wait for serial input
  command = Serial.read();
  if (command == 'c') {
    greenToRed();
    delay(1000);
    changePLight();
    delay(1000);
    redToGreen();
  }
  command = '\0'; //Empty character
}
