//
//  FtpSettingsViewInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 25.01.2026.
//

#ifndef FtpSettingsViewInclude_h
#define FtpSettingsViewInclude_h

extern uint8_t FtpSettingsViewX;
extern uint8_t FtpSettingsViewY;
extern uint8_t FtpSettingsViewDX;
extern uint8_t FtpSettingsViewDY;
extern uint8_t FtpSettingsViewColor;
extern uint8_t FtpSettingsViewInvColor;

extern uint8_t FtpSettingsViewSelectPos;

extern uint8_t FtpSettingsViewTitle[13];
extern uint8_t FtpSettingsViewTitleIP[6];
extern uint8_t FtpSettingsViewTitlePort[6];
extern uint8_t FtpSettingsViewTitleHomeDir[6];
extern uint8_t FtpSettingsViewTitleUser[6];

extern uint8_t FtpSettingsViewValuePort[16];
extern uint8_t FtpSettingsViewValueUser[16];
extern uint8_t FtpSettingsViewValuePass[16];
extern uint8_t FtpSettingsViewValueHomeDir[16];

void FtpSettingsViewShow();
void FtpSettingsViewClose();
void FtpSettingsViewShowTitle();
void FtpSettingsViewShowValue();
void FtpSettingsViewByPosValue();
void FtpSettingsViewKeyA();
/// вых [HL] -
/// вых [DE]-
void FtpSettingsViewByPosBoxValue();
/// Рисование линии прямым или инверсным цветом
/// 0 - прямой
/// 1 - инверсный
void FtpSettingsViewSelectLineA();
/// Обновление позиции
/// вх[A]
/// 0 - без изменений
/// 1 - вверх
/// 0xFF - вниз
void FtpSettingsViewPosUpdateA();

#endif /* FtpSettingsViewInclude_h */
