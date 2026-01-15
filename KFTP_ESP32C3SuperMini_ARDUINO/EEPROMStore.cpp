#include "EEPROMStore.h"
#include <EEPROM.h>

EEPROMData data;

void EEPROMStoreInit() {
  EEPROM.begin(sizeof(data));
}

void EEPROMStoreLoad() {
  int addr = 0;
  //Server
  EEPROM.get(addr, data.ftpServerUrl);
  addr += sizeof(data.ftpServerUrl);
  //Port
  EEPROM.get(addr, data.ftpPort);
  addr += sizeof(data.ftpPort);
  //User
  EEPROM.get(addr, data.ftpUser);
  addr += sizeof(data.ftpUser);
  //Pass
  EEPROM.get(addr, data.ftpPass);
  addr += sizeof(data.ftpPass);
  //ssid
  EEPROM.get(addr, data.ssid);
  addr += sizeof(data.ssid);
  //ssidPass
  EEPROM.get(addr, data.ssidPass);
  addr += sizeof(data.ssidPass);
}

void EEPROMStoreSave() {
  int addr = 0;
  //Server
  EEPROM.put(addr, data.ftpServerUrl);
  addr += sizeof(data.ftpServerUrl);
  //Port
  EEPROM.put(addr, data.ftpPort);
  addr += sizeof(data.ftpPort);
  //User
  EEPROM.put(addr, data.ftpUser);
  addr += sizeof(data.ftpUser);
  //Pass
  EEPROM.put(addr, data.ftpPass);
  addr += sizeof(data.ftpPass);
    //ssid
  EEPROM.put(addr, data.ssid);
  addr += sizeof(data.ssid);
  //ssidPass
  EEPROM.put(addr, data.ssidPass);
  addr += sizeof(data.ssidPass);

  //SAVE!
  EEPROM.commit();
}