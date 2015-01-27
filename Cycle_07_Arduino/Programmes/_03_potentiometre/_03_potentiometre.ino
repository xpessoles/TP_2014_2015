int IOcapteur = A5;    // Déclaration de l’entrée du potentiomètre
int valeur = 0;        // Déclaration de la valeur lue

void setup() {
  Serial.begin(57600);      // ouverture du port série
}

void loop() {
  valeur = analogRead(IOcapteur); // Lecture et affectation de la valeur
  Serial.print(valeur); // Affichage de la valeur
  Serial.println();
}

