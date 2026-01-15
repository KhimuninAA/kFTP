//
//  FtpFileLoadViewInclude.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 01.01.2026.
//

#ifndef FtpFileLoadViewInclude_h
#define FtpFileLoadViewInclude_h

extern uint8_t ftpFileLoadViewIsNextData;
extern uint8_t ftpFileLoadViewCheckSum;
extern uint8_t ftpFileLoadViewCheckSumState;
extern uint8_t ftpFileLoadViewProgress;

extern uint8_t FtpFileLoadViewX;
extern uint8_t FtpFileLoadViewY;
extern uint8_t FtpFileLoadViewEX;
extern uint8_t FtpFileLoadViewEY;

extern uint16_t FtpFileLoadViewTitlelPos;
extern uint8_t FtpFileLoadViewTitlel[7];
extern uint16_t ftpFileLoadCurrentPos;

void showFtpFileLoadView();
void ftpFileLoadViewNeedLoad();
void ftpFileLoadViewParce();
void updateProgress();

#endif /* FtpFileLoadViewInclude_h */
