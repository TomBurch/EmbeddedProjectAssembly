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

void interRdToGn(int TLight) {
  stage(TLight, T_RD);
  delay(1000);
  stage(TLight, T_RD_YE);
  delay(1000);
  stage(TLight, T_GN);
}

void interGnToRd(int TLight) {
  stage(TLight, T_GN);
  delay(1000);
  stage(TLight, T_YE);
  delay(1000);
  stage(TLight, T_RD);
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
  Serial.begin(9600);
  start();
}

char command;

void loop() {
  while (!Serial.available()) { //Wait for serial input
    interGnToRd(TLIGHT_1);
    interRdToGn(TLIGHT_2);
    delay(1000);          //Traffic flowing, TLight_2
    interGnToRd(TLIGHT_2);
    interRdToGn(TLIGHT_1);
    delay(1000);          //Traffic flowing, TLight_1
  } 
  command = Serial.read();
  if (command == 'c') {
    changePLight();
    delay(1000);
  }
  command = '\0'; //Empty character
}
