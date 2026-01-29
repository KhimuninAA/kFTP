//
//  WiFiNetworksViewInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 24.01.2026.
//

#ifndef WiFiNetworksViewInclude_h
#define WiFiNetworksViewInclude_h

extern uint8_t WiFiNetworksViewX;
extern uint8_t WiFiNetworksViewY;
extern uint8_t WiFiNetworksViewDX;
extern uint8_t WiFiNetworksViewDY;
extern uint8_t WiFiNetworksViewColor;
extern uint8_t WiFiNetworksViewInvColor;

extern uint8_t WiFiNetworksViewSelectPos;

extern uint8_t WiFiNetworksViewTitle[15];
extern uint8_t WiFiNetworksViewSSIDList[16*16];
extern uint8_t WiFiNetworksViewSSIDCount;

void WiFiNetworksViewShow();
void WiFiNetworksViewKeyA();
void WiFiNetworksViewClose();
void WiFiNetworksViewShowTitle();
void WiFiNetworksViewShowList();
/// Обновление позиции
/// вх[A]
/// 0 - без изменений
/// 1 - вверх
/// 0xFF - вниз
void WiFiNetworksViewPosUpdateA();
/// Рисование линии прямым или инверсным цветом
/// 0 - прямой
/// 1 - инверсный
void WiFiNetworksViewSelectLineA();
void WiFiNetworksViewCopySSIDForSimulator();
void WiFiNetworksViewUpdateList();
void WiFiNetworksViewClearData();
void WiFiNetworksViewFixData();

#endif /* WiFiNetworksViewInclude_h */
