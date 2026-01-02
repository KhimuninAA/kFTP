//
//  WifiSettings.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 16.09.2025.
//

#ifndef WifiSettings_h
#define WifiSettings_h

uint8_t wifiSettingsViewX = 0x00;
uint8_t wifiSettingsViewY = 0x01;
uint8_t wifiSettingsViewEX = 29;
uint8_t wifiSettingsViewEY = 6;
uint16_t wifiSettingsPos = 0x0108;
uint8_t wifiSettingsLabel[] = " WI-FI SETTINGS ";
uint8_t wifiSettingsSsidLabel[] = "SSID:";
uint8_t wifiSettingsIpLabel[] = "IP  :";
uint8_t wifiSettingsMacLabel[] = "MAC :";

uint16_t wifiSettingsSsidLabelPos = 0x0202;
uint16_t wifiSettingsIpLabelPos = 0x0302;
uint16_t wifiSettingsMacLabelPos = 0x0402;

uint16_t wifiSettingsSsidValPos = 0x0208;
uint8_t wifiSettingsSsidVal[16] = "K159";
uint16_t wifiSettingsIpValPos = 0x0308;
uint8_t wifiSettingsIpVal[16] = "-";
uint16_t wifiSettingsMacValPos = 0x0408;
uint8_t wifiSettingsMacVal[18] = "-";

uint8_t wifiSettingsEmpty18[18] = "                 ";

#endif /* WifiSettings_h */
