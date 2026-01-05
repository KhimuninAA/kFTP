//
//  FTPViewInclude.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 28.12.2025.
//

#ifndef FTPViewInclude_h
#define FTPViewInclude_h

void needUpdateFtpList();
void clearView();
void ftpViewDataUpdate();
void ftpViewShowValueA();
void ftpViewPosCursorC();
void ftpViewKeyA();

void parceBufferToFile();
/// HL - result string
/// DE - 2 byte size
void parceSizeFileInBuffer();
void ftpViewCurrentPosIsDir();
void loadSelectFile();

#endif /* FTPViewInclude_h */
