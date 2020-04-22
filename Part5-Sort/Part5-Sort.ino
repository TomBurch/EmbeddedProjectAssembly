extern "C" {
  void start();
  void quicksort(byte*, byte, byte);
  void partition(byte*, byte, byte);
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
     
    outArray(randArray);
    delay(2000);
    quicksort(randArray, 0, 49);
    delay(2000);
    outArray(randArray);  

    Serial.println(randArray[0]);
    Serial.println(randArray[49]);

    displayByte(randArray[0]);
    delay(3000);
    displayByte(randArray[49]);  
    delay(3000);
  
    Serial.println();
  }
  command = '\0';
}
