#ifndef EEPROM_STORE_H_
#define EEPROM_STORE_H_

struct EEPROMData {
  char ftpServerUrl[16];
  char ftpPort[6];
  char ftpUser[16];
  char ftpPass[16];
  char ssid[16];
  char ssidPass[16];
};

void EEPROMStoreInit();
void EEPROMStoreLoad();
void EEPROMStoreSave();

#endif