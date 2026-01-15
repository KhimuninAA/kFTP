//
//  ExtFTPView.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 16.09.2025.
//

#ifndef ExtFTPView_h
#define ExtFTPView_h

extern uint8_t ftpViewX;
extern uint8_t ftpViewY;
extern uint8_t ftpViewEX;
extern uint8_t ftpViewEY;

extern uint16_t ftpLabelPos;
extern uint8_t ftpLabel[7];

extern uint8_t ftpDirList[16 * 24];
extern uint8_t ftpDirListNext;
extern uint8_t ftpDirListCount;
extern uint8_t ftpViewCurrentPos;
extern uint8_t ftpDirListIsDir;
extern uint8_t ftpViewEmpty16[16];

extern uint8_t ftpViewDirPath[26];
extern uint16_t ftpViewDirPathPos;

#endif /* ExtFTPView_h */
