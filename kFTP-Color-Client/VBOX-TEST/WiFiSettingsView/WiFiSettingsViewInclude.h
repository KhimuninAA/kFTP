//
//  WiFiSettingsViewInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 23.01.2026.
//

#ifndef WiFiSettingsViewInclude_h
#define WiFiSettingsViewInclude_h

extern uint8_t WiFiSettingsViewX;
extern uint8_t WiFiSettingsViewY;
extern uint8_t WiFiSettingsViewDX;
extern uint8_t WiFiSettingsViewDY;
extern uint8_t WiFiSettingsViewColor;
extern uint8_t WiFiSettingsViewInvColor;

extern uint8_t WiFiSettingsViewSelectPos;

extern uint8_t WiFiSettingsViewTitle[15];
extern uint8_t WiFiSettingsViewTitlePass[6];
extern uint8_t WiFiSettingsViewTitleMac[6];
extern uint8_t WiFiSettingsViewButtonTitle[8];

void WiFiSettingsViewShow();
void WiFiSettingsViewShowTitle();
void WiFiSettingsViewShowValue();
void WiFiSettingsViewKeyA();
void WiFiSettingsViewClose();
/// Рисование линии прямым или инверсным цветом
/// 0 - прямой
/// 1 - инверсный
void WiFiSettingsViewSelectLineA();
/// Обновление позиции
/// вх[A]
/// 0 - без изменений
/// 1 - вверх
/// 0xFF - вниз
void WiFiSettingsViewPosUpdateA();
/// вых [BC] -
void WiFiSettingsViewByPosValue();
/// вых [HL] -
/// вых [DE]-
void WiFiSettingsViewByPosBoxValue();

#endif /* WiFiSettingsViewInclude_h */
