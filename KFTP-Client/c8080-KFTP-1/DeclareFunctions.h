//
//  DeclareFunctions.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 17.09.2025.
//

#ifndef DeclareFunctions_h
#define DeclareFunctions_h

extern uint8_t drowRectX;
extern uint8_t drowRectY;
extern uint8_t drowRectEndX;
extern uint8_t drowRectEndY;

//Обьявление функций
void clearScreen();
void drowRect();
void setMyFont();
void setSystemFont();

void showWiFiView();
void diskView();
void ftpView();

void showHelpStr();

void updateRootUI();
void updateRootDataUI();

void updateDiskList();
void showDiskList();
void showDiskApp();
void diskViewKeyA();
void showDiskDir();
void showDiskDriveName();

void showFtpSettingsEditView();
void needOpenFTPSettingsEditView();
void ftpSettingsEditViewKeyA();
void ftpSettingsEditViewDataUpdate();
void ftpSettingsEditViewShowValueA();
void ftpSettingsEditViewEditField();
void ftpSettingsEditViewSelectEditField();
void ftpSettingsEditViewSaveField();
void ftpSettingsEditView_CopyStrFromHL();
void ftpSettingsEditViewSetEditCursor();
void ftpSettingsEditViewSetValueA();
void ftpSettingsEditViewSaveEditValueToHL();
void keyboardEvent();
void clearWiFiViewValData();
void updateWiFiViewValData();

#endif /* DeclareFunctions_h */
