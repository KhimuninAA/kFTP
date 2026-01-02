//
//  wifiSettingsEditView.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 22.12.2025.
//

#ifndef wifiSettingsEditView_h
#define wifiSettingsEditView_h

uint8_t wifiSettingsEditViewCurrentPos = 0;

uint8_t wifiSettingsEditViewX = 14;
uint8_t wifiSettingsEditViewY = 4;
uint8_t wifiSettingsEditViewEX = 50;
uint8_t wifiSettingsEditViewEY = 15;

uint16_t wifiSettingsEditViewLabelPos = 0x0418;
uint8_t wifiSettingsEditViewLabel[] = " WI-FI SETTINGS ";

uint16_t wifiSettingsEditViewSSIDLabelPos = 0x0711;
uint8_t wifiSettingsEditViewSSIDLabel[] = "SSID:";

uint16_t wifiSettingsEditViewSSIDPasswordLabelPos = 0x0911;
uint8_t wifiSettingsEditViewSSIDPasswordLabel[] = "PASS:";

uint16_t wifiSettingsEditViewOkLabelPos = 0x0B1D;
uint8_t wifiSettingsEditViewOkLabel[] = "  OK  ";

uint16_t wifiSettingsEditViewSSIDValPos = 0x0719;
uint16_t wifiSettingsEditViewSSIDPasswordValPos = 0x0919;

uint8_t wifiSettingsEditViewSSIDPasswordVal[16] = "---";

uint16_t wifiSettingsEditViewEditValuePos = 0x0000;
uint8_t wifiSettingsEditViewEditValue[24] = "";
uint8_t wifiSettingsEditViewEditPos = 0;

uint8_t updateWiFiStatusTike = 0;
uint8_t WiFiState = 0;
uint8_t WiFiStateUpdate = 1;

#endif /* wifiSettingsEditView_h */
