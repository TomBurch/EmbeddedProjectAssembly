extern "C" {
  void start();
  void sort(byte*);
  void swap(byte*, byte*);
  void displayByte(byte);
}

void generateArray(byte randArray[]) {
  for (int i = 0; i < 50; i++) {
    byte randByte = random(0, 256);
    randArray[i] = randByte;
  }
}

//Loop through array[] and print each int
void outArray(byte array[]) {
  for(int i = 0; i < 50; i++) {
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
    swap(&randArray[0], &randArray[1]);
    outArray(randArray);  

    //sort(randArray);
    //outArray(randArray);

    //Serial.println(randArray[0]);
    //Serial.println(randArray[49]);

    
  }
  command = '\0';
}
