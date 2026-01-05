//ESP12
#include <Wire.h>

#include "EEPROMStore.h"
#include "I2CEvents.h"
#include "WIFI.h"
#include "FTPClient.h"

FTPClient ftpClientA = FTPClient();

#define SLAVE_ADDRESS 0x8
const int busyPin = 14;

void requestEvent();
void receiveEvent(int numBytes);

void setup() {
  setBusy(true);

  Serial.begin(115200);

  Wire.pins(D2, D1);
  Wire.begin(0x12); 

  Wire.setClockStretchLimit(1500);
  Wire.setClock(10000L);

  //Wire.setClockStretchLimit(1500);
  //Wire.setClock(40000L); 

  Wire.onReceive(receiveEvent); /* регистрируем полученное событие */
  Wire.onRequest(requestEvent);

  pinMode(busyPin, OUTPUT);

  WIFIInit();
  EEPROMStoreInit();

  EEPROMStoreLoad();
  //listSSID();
  setBusy(false);
}

bool receiveOn = false;
bool i2cBusy = false;

void loop() {
  if (receiveOn == true) {
    receiveOn = false;
    receiveExec();
  }
  delay(1); 
}

void setBusy(bool busy) {
  if (busy == true) {
    digitalWrite(busyPin, HIGH);
  } else {
    digitalWrite(busyPin, LOW);
  }
}
