extern "C" {
  void start();
  void stage(int, int);
}

void setup() {
  Serial.begin(9600);
  start();
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
  flashGreen();
  stage(PLIGHT, P_RD);
  delay(500);
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
  delay(500);
  stage(PLIGHT, P_GN);
}

void flashGreen() {
  for (int i = 0; i < 5; i++) {
    stage(PLIGHT, P_GN);
    delay(200);
    stage(PLIGHT, P_OFF);
    delay(200);
  }
}

char command;

void loop() {
  while (!Serial.available()) {} //Wait for serial input
  command = Serial.read();
  if (command == 'c') {
    greenToRed();
    delay(1000);
    redToGreen();
    delay(1000); 
  }
  //command = '\0'; //Empty character
}
