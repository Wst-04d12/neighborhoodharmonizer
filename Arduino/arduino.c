const int digitalOutputPin = 8;
const int analogInputPin = 14;

void setup()
{
 pinMode(digitalOutputPin, OUTPUT);
 pinMode(analogInputPin, INPUT);
}
void loop()
{
  if (analogRead(analogInputPin) >= 600)
  {
    delay(397);
    digitalWrite(digitalOutputPin, HIGH);
    delay(133);
    digitalWrite(digitalOutputPin, LOW);
  }
}
