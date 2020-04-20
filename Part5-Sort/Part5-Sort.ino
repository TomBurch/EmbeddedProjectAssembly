extern "C" {
  start();
}

void generateArray(byte randArray[]) {
  for (int i = 0; i < 50; i++) {
    byte randByte = random(0, 256);
    randArray[i] = randByte;
  }
}

void setup() {
  Serial.begin(9600);
  randomSeed(analogRead(0));
  start();
}

byte randArray[50];
char command;

void loop() {
  while(!Serial.available()) {}
  command = Serial.read();
  if (command == 'c') {
    generateArray(randArray);
  }
  command = '\0';
}
