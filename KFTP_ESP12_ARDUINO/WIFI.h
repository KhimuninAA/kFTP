#ifndef WIFI_H_
#define WIFI_H_

#include <WString.h>
#include "EEPROMStore.h"

#define CONNECT_MAX_WAIT 50000
#define MAX_ENTRIES 16

struct SSIDData {
  String ssid;
  char ssidCh[16];
  int32_t rssi;
};

void WIFIInit();
void listSSID();
void WIFIConnect();
void updateStatus();
void listSSIDToBuffer();

#endif