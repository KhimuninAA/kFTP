//
//  FtpSettings.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 16.09.2025.
//

#ifndef FtpSettings_h
#define FtpSettings_h

uint8_t ftpSettingsViewX = 30;
uint8_t ftpSettingsViewY = 1;
uint8_t ftpSettingsViewEX = 63; //54;
uint8_t ftpSettingsViewEY = 6;

uint16_t ftpSettingsLabelPos = 0x0127;
uint8_t ftpSettingsLabel[] = " FTP SETTINGS ";

//ip
uint16_t ftpSettingsIpLabelPos = 0x0220;
uint8_t ftpSettingsIpLabel[] = "IP:";
//port
uint16_t ftpSettingsPortLabelPos = 0x0234;
uint8_t ftpSettingsPortLabel[] = "PORT:";
//user
uint16_t ftpSettingsUserLabelPos = 0x0320;
uint8_t ftpSettingsUserLabel[] = "USER:";
//status
uint16_t ftpSettingsStatusLabelPos = 0x0420;
uint8_t ftpSettingsStatusLabel[] = "STATUS:";

uint16_t ftpSettingsIpValuePos = 0x0224;
uint8_t ftpSettingsIpValue[16] = "100.100.100.100";

uint16_t ftpSettingsPortValuePos = 0x023A;
uint8_t ftpSettingsPortValue[6] = "21";

uint16_t ftpSettingsStatusValuePos = 0x0428;
uint8_t ftpSettingsStatusValue[12] = "DISCONNECT";

uint16_t ftpSettingsUserValuePos = 0x0326;
uint8_t ftpSettingsUserValue[16] = "ESP8266";

#endif /* FtpSettings_h */
