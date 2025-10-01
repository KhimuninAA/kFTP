//
//  ExtWifiSettings.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 16.09.2025.
//

#ifndef ExtWifiSettings_h
#define ExtWifiSettings_h

extern uint8_t wifiSettingsViewX;
extern uint8_t wifiSettingsViewY;
extern uint8_t wifiSettingsViewEX;
extern uint8_t wifiSettingsViewEY;

extern uint16_t wifiSettingsPos;
extern uint8_t wifiSettingsLabel[17];
extern uint16_t wifiSettingsSsidLabelPos;
extern uint16_t wifiSettingsIpLabelPos;
extern uint16_t wifiSettingsMacLabelPos;
extern uint8_t wifiSettingsSsidLabel[6];
extern uint8_t wifiSettingsIpLabel[6];
extern uint8_t wifiSettingsMacLabel[6];

extern uint16_t wifiSettingsSsidValPos;
extern uint8_t wifiSettingsSsidVal[20];
extern uint16_t wifiSettingsIpValPos;
extern uint8_t wifiSettingsIpVal[20];
extern uint16_t wifiSettingsMacValPos;
extern uint8_t wifiSettingsMacVal[20];

#endif /* ExtWifiSettings_h */
