#include "WIFIMy.h"
#include <WiFi.h>

extern EEPROMData data;

SSIDData ssidsData[MAX_ENTRIES];
bool WIFIflag = false;
uint8_t WIFIBuffer[256];
uint8_t SSIDListPos = 0;
uint8_t SSIDList_Is_Ready = 0;

void WIFIInit() {
  WiFi.mode(WIFI_STA);
}

void updateStatus() {
  if (WiFi.status() != WL_CONNECTED) {
    WIFIflag = false;
  } else {
    WIFIflag = true;
  }
}

void WIFIConnect() {
  WiFi.disconnect();
  Serial.println(data.ssid);
  Serial.println(data.ssidPass);
  WiFi.begin(String(data.ssid), String(data.ssidPass)); //String(charArray); 
  WIFIflag = false;
  int i = 0;
  while (WiFi.status() != WL_CONNECTED && i < 50) {
    delay(200);
    i++;
    Serial.print(".");
  }
  //
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("WiFi CONNECTED");
    WIFIflag = true;
  } else {
    Serial.println("WiFi CONNECTED ERROR");
    WIFIflag = false;
  }
}

void listSSID() {
  SSIDList_Is_Ready = 0;
  memset(ssidsData, 0, sizeof(ssidsData));
  int numberOfNetworks = WiFi.scanNetworks(); // Scan for networks
  //Serial.print(numberOfNetworks);
  //Serial.println(" networks found");

  if (numberOfNetworks == 0) {
    //Serial.println("No networks found.");
  } else {
    int dataCount = 0;
    for (int i = 0; i < numberOfNetworks; i++) {
      if ((dataCount < MAX_ENTRIES)&&(WiFi.RSSI(i) > -88)) {
        ssidsData[dataCount].ssid = WiFi.SSID(i);
        ssidsData[dataCount].rssi = WiFi.RSSI(i);
        char ssidCh[16];
        String newSSID = WiFi.SSID(i);
        newSSID.toUpperCase();
        strncpy(ssidCh, newSSID.c_str(), 16);
        int pos = 0;
        for(int j = 0; j < 16; j++) {
          char c = ssidCh[j];
          if (c < 0x60) {
            ssidsData[dataCount].ssidCh[pos] = c;
            pos++;
          } else if (c == 0) {
            break;
          }
        }
        if (pos == 15) {
          ssidsData[dataCount].ssidCh[pos] = 0;
        }
        dataCount++;
      }
    }

     //listSSIDToBuffer();

    //   Serial.println();
    //   Serial.println("256 byte");
    //   Serial.println();
    //   for (int i = 0; i < 256; i++) {
    //     Serial.print("0x");
    //     byte myByte = WIFIBuffer[i];
    //     if (myByte < 16) {
    //       Serial.print("0"); // Добавляем ведущий ноль
    //     }
    //     Serial.print(myByte, HEX);
    //     Serial.print(", ");
    //  }

    // int charCount = 0;
    // for (int i = 0; i < 256; i++) {
    //   if (WIFIBuffer[i]==0) {
    //     if(charCount>0) {
    //       Serial.println();
    //       charCount = 0;
    //     }
    //   } else {
    //     char c = WIFIBuffer[i];
    //     Serial.print(c);
    //     charCount++;
    //   }
    // }

    for (int i = 0; i < MAX_ENTRIES; i++) {
      if (ssidsData[i].ssidCh[0] != 0) {
        Serial.println(ssidsData[i].ssidCh);
      }
      //delay(1000);
    }

  }
  SSIDList_Is_Ready = 1;
}

void listSSIDToBuffer() {
  memset(WIFIBuffer, 0, sizeof(WIFIBuffer));
  int bufferCount = 0;
  for (int i = 0; i < MAX_ENTRIES; i++) {
    for(int j = 0; j < 16; j++) {
      WIFIBuffer[bufferCount + j] = ssidsData[i].ssidCh[j];
    }
    WIFIBuffer[bufferCount + 15] = 0;
    bufferCount += 16;
  }
  WIFIBuffer[255] = 0;

  // for (int i = 0; i < MAX_ENTRIES; i++) {
  //   if (ssidsData[i].ssidCh[0] != 0) {
  //     for(int j = 0; j < 16; j++) {
  //       if (ssidsData[i].ssidCh[j] == 0) {
  //         WIFIBuffer[bufferCount] = ssidsData[i].ssidCh[j];
  //         bufferCount++;
  //         if (bufferCount >= 256) {
  //           WIFIBuffer[255] = 0;
  //           return;
  //         }
  //         break;
  //       } else {
  //         WIFIBuffer[bufferCount] = ssidsData[i].ssidCh[j];
  //         bufferCount++;
  //         if (bufferCount >= 256) {
  //           WIFIBuffer[255] = 0;
  //           return;
  //         }
  //       }
  //     }
  //   }
  // }
}