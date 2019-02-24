
#include <string.h>

int sensorPin = A0;    // select the input pin for the potentiometer

char num_dev = '0';
char temp;
int air_qual = 0;
String msg;

void setup() {
  // declare the ledPin as an OUTPUT:
  Serial.begin(9600);
  Serial.setTimeout(100);
}

void loop() {
  // read the value from the sensor 
  air_qual = analogRead(sensorPin);
  temp = Serial.read();
  if(temp != -1){
    num_dev = temp;
  }

  msg = "<a,";
  msg += String(num_dev);
  msg += ',';
  msg += String(air_qual, DEC);
  msg += '>';

  Serial.print(msg);

  delay(1000);
  
}
