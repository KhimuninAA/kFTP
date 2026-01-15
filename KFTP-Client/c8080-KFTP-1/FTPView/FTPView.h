//
//  FTPView.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 16.09.2025.
//

#ifndef FTPView_h
#define FTPView_h

uint8_t ftpViewX = 30;
uint8_t ftpViewY = 7;
uint8_t ftpViewEX = 63;
uint8_t ftpViewEY = 25;

uint16_t ftpLabelPos = 0x0728;
uint8_t ftpLabel[] = " FTP: ";

uint8_t ftpDirList[16 * 24];
uint8_t ftpDirListNext = 0;
uint8_t ftpDirListCount = 0;
uint8_t ftpDirListIsDir = 0;

uint8_t ftpViewCurrentPos = 0;
uint8_t ftpViewEmpty16[16] = "               ";

uint8_t ftpViewDirPath[26] = "";
uint16_t ftpViewDirPathPos = 0x1822;

#endif /* FTPView_h */
