extern "C" {
  void start();
  void stage(int, int);
}

void setup() {
  Serial.begin(9600);
  start();
}

const int TLIGHT_1 = 0;
const int TLIGHT_2 = 1;
const int PLIGHT   = 2;

void redToGreen() {
  flashGreen();
  stage(PLIGHT, 0);
  delay(500);
  stage(TLIGHT_1, 1);
  stage(TLIGHT_2, 1);
  delay(1000);
  stage(TLIGHT_1, 2);
  stage(TLIGHT_2, 2);
}

void greenToRed() {
  stage(TLIGHT_1, 3);
  stage(TLIGHT_2, 3);
  delay(1000);
  stage(TLIGHT_1, 0);
  stage(TLIGHT_2, 0);
  delay(500);
  stage(PLIGHT, 1);
}

void flashGreen() {
  for (int i = 0; i < 5; i++) {
    stage(PLIGHT, 1);
    delay(200);
    stage(PLIGHT, 2);
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
