//
//  ExtFtpSettingsEditView.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 17.09.2025.
//

#ifndef ExtFtpSettingsEditView_h
#define ExtFtpSettingsEditView_h

extern uint8_t ftpSettingsEditViewX;
extern uint8_t ftpSettingsEditViewY;
extern uint8_t ftpSettingsEditViewEX;
extern uint8_t ftpSettingsEditViewEY;

extern uint16_t ftpSettingsEditViewLabelPos;
extern uint8_t ftpSettingsEditViewLabel[15];

extern uint16_t ftpSettingsEditViewIpLabelPos;
extern uint16_t ftpSettingsEditViewPortLabelPos;
extern uint16_t ftpSettingsEditViewUserLabelPos;

extern uint16_t ftpSettingsEditViewPasswordLabelPos;
extern uint8_t ftpSettingsEditViewPasswordLabel[6];

extern uint16_t ftpSettingsEditViewOkLabelPos;
extern uint8_t ftpSettingsEditViewOkLabel[7];

extern uint16_t ftpSettingsEditViewIpValPos;
extern uint16_t ftpSettingsEditViewPortValPos;
extern uint16_t ftpSettingsEditViewUserValPos;
extern uint16_t ftpSettingsEditViewPasswordValPos;
extern uint8_t ftpSettingsEditViewPasswordVal[16];

extern uint8_t ftpSettingsEditViewCurrentPos;

extern uint16_t ftpSettingsEditViewEditValuePos;
extern uint8_t ftpSettingsEditViewEditValue[24];
extern uint8_t ftpSettingsEditViewEditPos;

extern uint8_t updateFtpStatusTike;

void updateFtpStatus();
void updateFtpStatusUI();

#endif /* ExtFtpSettingsEditView_h */
