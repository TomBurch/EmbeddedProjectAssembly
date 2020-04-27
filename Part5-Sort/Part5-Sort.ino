extern "C" {
  void start();
  void quicksort(byte*, byte, byte);
  byte partition(byte*, byte, byte);
  void swap(byte*, byte*);
  void displayByte(byte);
}

void generateArray(byte randArray[]) {
  for (int i = 0; i < 50; i++) {
    byte randByte = random(0, 256);
    randArray[i] = randByte;
  }
}

void outArray(byte array[]) {
  for (int i = 0; i < 50; i++) {
    Serial.print(array[i]);
    Serial.print(", ");
  }
  Serial.print("\n");
}

void setup() {
  Serial.begin(19200);
  randomSeed(analogRead(0));
  start();
}

byte randArray[50];
char command;

void loop() {
  while (!Serial.available()) {}
  command = Serial.read();
  if (command == 'c') {
    generateArray(randArray); 
     
    outArray(randArray);
    quicksort(randArray, 0, 49);
    outArray(randArray);  

    Serial.println(randArray[0]);
    Serial.println(randArray[49]);

    displayByte(randArray[0]);
    delay(3000);
    displayByte(randArray[49]);  
    delay(3000);
    displayByte(0x00);
    Serial.println();
  }
  command = '\0';
}
