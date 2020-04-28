extern "C" {
  void del(unsigned int);
  void displayByte(byte);
}

void setup() {
  // put your setup code here, to run once:

}

void loop() {
  displayByte(1);
  del(1000);
  displayByte(2);
  del(1000);
}
