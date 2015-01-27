int led = 13;
void setup() {                
    pinMode(led, OUTPUT);  
    Serial.begin(57600);   
}
void loop() {
  digitalWrite(led, HIGH);
  delay(1000); 
  Serial.print(“JOUR \n"); 
  digitalWrite(led, LOW); 
  delay(1000);
  Serial.print(“NUIT \n");
}

