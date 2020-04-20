extern "C" {
  void start();
  void quicksort(byte*);
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

//Loop through array[] and print each int
void outArray(byte array[]) {
  for(int i = 0; i < 50; i++) {
  //for (int i = 0; i < 3; i++) {
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
//byte randArray[3] = {5, 3, 4};
char command;

void loop() {
  while(!Serial.available()) {}
  command = Serial.read();
  if (command == 'c') {
    generateArray(randArray);  
    outArray(randArray);
    partition(randArray, 0, 49);
    //swap(&randArray[0], &randArray[1]);
    outArray(randArray);  

    //sort(randArray);
    //outArray(randArray);

    //Serial.println(randArray[0]);
    //Serial.println(randArray[49]);

    
  }
  command = '\0';
}
