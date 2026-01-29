//
//  WifiStateViewInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef WifiStateViewInclude_h
#define WifiStateViewInclude_h

extern uint8_t WifiStateViewX;
extern uint8_t WifiStateViewY;
extern uint8_t WifiStateViewDX;
extern uint8_t WifiStateViewDY;
extern uint8_t WifiStateViewColor;

extern uint8_t WifiStateViewSSIDIsConnected;

extern uint8_t WifiStateViewTitleSSID[7]; //6
extern uint8_t WifiStateViewTitleIP[7]; //6
extern uint8_t WifiStateViewTitle[8];

extern uint8_t WifiStateViewSsidVal[16];
extern uint8_t WifiStateViewIpVal[16];
extern uint8_t WifiStateViewPassVal[16];
extern uint8_t WifiStateViewMacVal[18];

void WifiStateViewShow();
void WifiStateViewShowTitle();
void WifiStateViewShowValue();
void WifiStateViewNetAndUIUpdate();

#endif /* WifiStateViewInclude_h */
