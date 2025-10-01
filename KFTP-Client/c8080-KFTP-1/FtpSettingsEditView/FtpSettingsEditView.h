//
//  FtpSettingsEditView.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 17.09.2025.
//

#ifndef FtpSettingsEditView_h
#define FtpSettingsEditView_h

uint8_t ftpSettingsEditViewX = 14;
uint8_t ftpSettingsEditViewY = 4;
uint8_t ftpSettingsEditViewEX = 50;
uint8_t ftpSettingsEditViewEY = 20;

uint16_t ftpSettingsEditViewLabelPos = 0x0418;
uint8_t ftpSettingsEditViewLabel[] = " FTP SETTINGS ";

uint16_t ftpSettingsEditViewIpLabelPos = 0x0713;
uint16_t ftpSettingsEditViewPortLabelPos = 0x0911;
uint16_t ftpSettingsEditViewUserLabelPos = 0x0B11;

uint16_t ftpSettingsEditViewPasswordLabelPos = 0x0D11;
uint8_t ftpSettingsEditViewPasswordLabel[] = "PASS:";

uint16_t ftpSettingsEditViewOkLabelPos = 0x101D;
uint8_t ftpSettingsEditViewOkLabel[] = "  OK  ";

uint16_t ftpSettingsEditViewIpValPos = 0x0719;
uint16_t ftpSettingsEditViewPortValPos = 0x0919;
uint16_t ftpSettingsEditViewUserValPos = 0x0B19;
uint16_t ftpSettingsEditViewPasswordValPos = 0x0D19;
uint8_t ftpSettingsEditViewPasswordVal[16] = "ESP8266";

uint8_t ftpSettingsEditViewCurrentPos = 0;

uint16_t ftpSettingsEditViewEditValuePos = 0x0000;
uint8_t ftpSettingsEditViewEditValue[24] = "";
uint8_t ftpSettingsEditViewEditPos = 0;

#endif /* FtpSettingsEditView_h */
