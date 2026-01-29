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
  //ftpHomeDir
  EEPROM.get(addr, data.ftpHomeDir);
  addr += sizeof(data.ftpHomeDir);

  EEPROMStoreEmptyFix();
}

void EEPROMStoreEmptyFix() {
  uint8_t byte = 0;
  //-- ftpHomeDir
  byte = data.ftpHomeDir[0];
  if (byte == 0xFF) {
    data.ftpHomeDir[0] = '/';
    data.ftpHomeDir[1] = 0;
  }
  //-- ftpServerUrl
  byte = data.ftpServerUrl[0];
  if (byte == 0xFF) {
    data.ftpServerUrl[0] = '-';
    data.ftpServerUrl[1] = 0;
  }
  //-- ftpPort
  byte = data.ftpPort[0];
  if (byte == 0xFF) {
    data.ftpPort[0] = '2';
    data.ftpPort[1] = '1';
    data.ftpPort[2] = 0;
  }
  //-- ftpUser
  byte = data.ftpUser[0];
  if (byte == 0xFF) {
    data.ftpUser[0] = '-';
    data.ftpUser[1] = 0;
  }
  //-- ftpPass
  byte = data.ftpPass[0];
  if (byte == 0xFF) {
    data.ftpPass[0] = '-';
    data.ftpPass[1] = 0;
  }
  //-- ssid
  byte = data.ssid[0];
  if (byte == 0xFF) {
    data.ssid[0] = '-';
    data.ssid[1] = 0;
  }
  //-- ssidPass
  byte = data.ssidPass[0];
  if (byte == 0xFF) {
    data.ssidPass[0] = '-';
    data.ssidPass[1] = 0;
  }
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
  //ftpHomeDir
  EEPROM.put(addr, data.ftpHomeDir);
  addr += sizeof(data.ftpHomeDir);
  //SAVE!
  EEPROM.commit();
}