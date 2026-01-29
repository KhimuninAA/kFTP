//
//  FtpViewInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef FtpViewInclude_h
#define FtpViewInclude_h

extern uint8_t FtpViewX;
extern uint8_t FtpViewY;
extern uint8_t FtpViewDX;
extern uint8_t FtpViewDY;
extern uint8_t FtpViewColor;
extern uint8_t FtpViewInvColor;

extern uint8_t FtpViewTitle[6];
extern uint8_t FtpViewFilesListCount;
extern uint8_t FtpViewFilesList[16 * 23];
extern uint8_t FtpViewPath[16];
extern uint8_t FtpViewFileCurrentPos;

void FtpViewShow();
void FtpViewShowTitle();
void FtpViewShowFileList();
void FtpViewShowFileHL();
void FtpViewShowFileName();
void FtpViewShowFileSize();
void FtpViewShowFileDate();
void FtpViewShowPath();
void FtpViewKeyA();
void FtpViewFileCurrentPosUpdateA();
void FtpViewShowSelectLineA();
// A = 1 - Dir
void FtpViewShowIsDirA();
/// вых [A] - 1 директоря, 0 - файл
void FtpViewCurrentPosIsDir();
void FtpViewNetLoadAndUpdate();
void FtpViewNeedLoad();
void FtpViewLoadFile();

void FtpViewEmptyList();
void FtpViewListUpdateUI();

#endif /* FtpViewInclude_h */
