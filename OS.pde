//
//  OS.pde
//
//  Copyright 2011 Hicaduda. All rights reserved.
//
/*
 
 hicaduda.com || http://github.com/sgonzalez/Arduino-Sensor-System
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software in binary form, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#include <LiquidCrystal.h> // we need this library for the LCD commands
#include "Ping.h"

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(7, 8, 9, 10, 11, 12);

Ping ping = Ping(2,74,29);

const int NUMAPPS = 6;
int pressed;////For button next app
int currentApp;

long randNumber;
long cdsSensor;

void genRand() {
  randNumber = random(1000); //0 to 999
}

void getCdS() {
  cdsSensor = analogRead(1);
}

void setup() {
  lcd.begin(16, 2);               // need to specify how many columns and rows are in the LCD unit
  lcd.print("Super Cool LCD ");
  
  delay(3000);
  
  pinMode(13, INPUT); //Button
  
  randomSeed(analogRead(0)); //picks random numbers from analog pin 0
  
  genRand();
  getCdS();
  
  lcd.clear();
}

void loop() {
  pressed = digitalRead(13);
  if (pressed == HIGH) {
    pressed = 0;
    currentApp++;
    if (currentApp > NUMAPPS) currentApp = 0;
    genRand();
  } else {
    pressed = 0;
  }
  switch (currentApp) {
    case 0:
      ping.fire();
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("====Distance====");
      lcd.setCursor(0,1);
      lcd.print(" ");
      lcd.print(ping.inches());
      lcd.print("in     ");
      lcd.print(ping.centimeters());
      lcd.print("cm");
      break;
    case 1:
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("===Temperature==");
      lcd.setCursor(0,1);
      lcd.print(" ");
      //lcd.print(currentC,1);
      lcd.print("F      ");
      //lcd.print(currentF,1);
      lcd.print("C");
      break;
    case 2:
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("=Random Number==");
      lcd.setCursor(0,1);
      lcd.print(" ");
      lcd.print(randNumber);    //Three digit random number
      break;
    case 3:
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("======Time======");
      lcd.setCursor(0,1);
      lcd.print(" ");
      //lcd.print(currentC,1);  //Something like 9:24:10 AM
      break;
    case 4:
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("======Date======");
      lcd.setCursor(0,1);
      lcd.print(" ");
      //lcd.print(currentC,1);  //Something like 19/4/2011
      break;
    case 5:
      getCdS();
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("===Light Level==");
      lcd.setCursor(0,1);
      lcd.print(" ");
      lcd.print(cdsSensor/12); //Divisor may vary by CdS cell
      lcd.print("%");
      break;
  }
  
  delay(100); // gives time to ignore switch bounce, implement better system for future
}




