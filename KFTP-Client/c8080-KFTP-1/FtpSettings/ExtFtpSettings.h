//
//  ExtFtpSettings.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 16.09.2025.
//

#ifndef ExtFtpSettings_h
#define ExtFtpSettings_h

extern uint8_t ftpSettingsViewX;
extern uint8_t ftpSettingsViewY;
extern uint8_t ftpSettingsViewEX;
extern uint8_t ftpSettingsViewEY;

extern uint16_t ftpSettingsLabelPos;
extern uint8_t ftpSettingsLabel[15];

extern uint16_t ftpSettingsIpLabelPos;
extern uint8_t ftpSettingsIpLabel[4];
extern uint16_t ftpSettingsPortLabelPos;
extern uint8_t ftpSettingsPortLabel[6];
extern uint16_t ftpSettingsUserLabelPos;
extern uint8_t ftpSettingsUserLabel[6];
extern uint16_t ftpSettingsStatusLabelPos;
extern uint8_t ftpSettingsStatusLabel[8];

extern uint16_t ftpSettingsIpValuePos;
extern uint8_t ftpSettingsIpValue[16];

extern uint16_t ftpSettingsPortValuePos;
extern uint8_t ftpSettingsPortValue[6];

extern uint16_t ftpSettingsStatusValuePos;
extern uint8_t ftpSettingsStatusValue[12];
extern uint8_t ftpSettingsStateVal;
extern uint8_t ftpSettingsStateChange;
extern uint8_t ftpSettingsStatus0[12];
extern uint8_t ftpSettingsStatus1[12];

extern uint16_t ftpSettingsUserValuePos;
extern uint8_t ftpSettingsUserValue[16];

#endif /* ExtFtpSettings_h */
