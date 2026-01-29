//
//  FtpStateViewInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef FtpStateViewInclude_h
#define FtpStateViewInclude_h

extern uint8_t FtpStateViewX;
extern uint8_t FtpStateViewY;
extern uint8_t FtpStateViewDX;
extern uint8_t FtpStateViewDY;
extern uint8_t FtpStateViewColor;
extern uint8_t FtpStateViewConnectColor;

extern uint8_t FtpStateViewIpTitle[4];
extern uint8_t FtpStateViewStateTitle[8];
extern uint8_t FtpStateViewIpValue[16];

extern uint8_t FtpStateViewStatus0[11];
extern uint8_t FtpStateViewStatus1[8];
extern uint8_t FtpStateViewStatus;

void FtpStateViewShow();
void FtpStateViewShowTitle();
void FtpStateViewShowValue();
void FtpStateViewShowStatus();

#endif /* FtpStateViewInclude_h */
