//
//  wifiSettingsEditViewInclude.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 22.12.2025.
//

#ifndef wifiSettingsEditViewInclude_h
#define wifiSettingsEditViewInclude_h

extern uint8_t wifiSettingsEditViewCurrentPos;

extern uint8_t wifiSettingsEditViewX;
extern uint8_t wifiSettingsEditViewY;
extern uint8_t wifiSettingsEditViewEX;
extern uint8_t wifiSettingsEditViewEY;

extern uint16_t wifiSettingsEditViewLabelPos;
extern uint8_t wifiSettingsEditViewLabel[17];

extern uint16_t wifiSettingsEditViewSSIDLabelPos;
extern uint8_t wifiSettingsEditViewSSIDLabel[6];

extern uint16_t wifiSettingsEditViewSSIDPasswordLabelPos;
extern uint8_t wifiSettingsEditViewSSIDPasswordLabel[6];

extern uint16_t wifiSettingsEditViewOkLabelPos;
extern uint8_t wifiSettingsEditViewOkLabel[7];

extern uint16_t wifiSettingsEditViewSSIDValPos;
extern uint16_t wifiSettingsEditViewSSIDPasswordValPos;

extern uint8_t wifiSettingsEditViewSSIDPasswordVal[16];

extern uint16_t wifiSettingsEditViewEditValuePos;
extern uint8_t wifiSettingsEditViewEditValue[24];
extern uint8_t wifiSettingsEditViewEditPos;

extern uint8_t updateWiFiStatusTike;
extern uint8_t WiFiState;
extern uint8_t WiFiStateUpdate;

void needOpenWiFiSettingsEditView();
void showWiFiSettingsEditView();
void wifiSettingsEditViewDataUpdate();
void wifiSettingsEditViewShowValueA();
void wifiSettingsEditViewKeyA();
void wifiSettingsEditViewSelectEditField();
void wifiSettingsEditView_CopyStrFromHL();
void wifiSettingsEditViewEditField();
void wifiSettingsEditViewSetEditCursor();
void wifiSettingsEditViewSaveField();
void wifiSettingsEditViewSetValueA();
void wifiSettingsEditViewSaveEditValueToHL();
///  Обновить данные WiFi
void updateWiFiStatus();

#endif /* wifiSettingsEditViewInclude_h */
