//
//  FtpSettingsEditViewFunctions.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 18.09.2025.
//

#ifndef FtpSettingsEditViewFunctions_h
#define FtpSettingsEditViewFunctions_h

void ftpSettingsEditViewShowValueA() {
    if (a == 0) {
        hl = ftpSettingsEditViewIpValPos;
        setPosCursor();
        
        hl = ftpSettingsIpValue;
        printHLStr();
    } else if (a == 1) {
        hl = ftpSettingsEditViewPortValPos;
        setPosCursor();
        
        hl = ftpSettingsPortValue;
        printHLStr();
    } else if (a == 2) {
        hl = ftpSettingsEditViewUserValPos;
        setPosCursor();
        
        hl = ftpSettingsUserValue;
        printHLStr();
    } else if (a == 3) {
        hl = ftpSettingsEditViewPasswordValPos;
        setPosCursor();
        
        hl = ftpSettingsEditViewPasswordVal;
        printHLStr();
    } else if (a == 4) {
        hl = ftpSettingsEditViewOkLabelPos;
        setPosCursor();
        hl = ftpSettingsEditViewOkLabel;
        printHLStr();
    }
}

void ftpSettingsEditViewSaveField() {
    a = ftpSettingsEditViewCurrentPos;
    if (a == 0) {
        hl = ftpSettingsIpValue;
    } else if (a == 1) {
        hl = ftpSettingsPortValue;
    } else if (a == 2) {
        hl = ftpSettingsUserValue;
    } else if (a == 3) {
        hl = ftpSettingsEditViewPasswordVal;
    }
    ftpSettingsEditViewSaveEditValueToHL();
    //Save ESP
    a = ftpSettingsEditViewCurrentPos;
    if (a == 0) {
        setFTPUrl();
    } else if (a == 1) {
        setFTPPort();
    } else if (a == 2) {
        setFTPUser();
    } else if (a == 3) {
        setFTPPassword();
    }
}

void ftpSettingsEditViewKeyA() {
    push_pop(hl) {
        l = a;
        if ((a = rootViewCurrentView) == rootViewCurrentFTPSettingsEditView) {
            a = l;
            if (a == 0x1B) { //ESC выход из настройки
                a = rootViewCurrentDiskView; // переходим на список файлов на диске
                rootViewCurrentView = a;
                
                updateRootUI();
                updateRootDataUI();
            } else {
                if (a == 0x1A) { //down
                    a = ftpSettingsEditViewCurrentPos;
                    a++;
                    if (a == 5) {
                        a = 0;
                    }
                    ftpSettingsEditViewCurrentPos = a;
                } else if (a == 0x19) { //up
                    a = ftpSettingsEditViewCurrentPos;
                    if (a == 0) {
                        a = 4;
                    } else {
                        a--;
                    }
                    ftpSettingsEditViewCurrentPos = a;
                } else if (a == 0x0D) { //Enter
                    /// и подключиться к FTP
                    needFtpConnect();
                    ///
                    if ((a = ftpSettingsEditViewCurrentPos) == 4) { // Нажатие на кнопку ОК
                        a = rootViewCurrentDiskView; // переходим на список файлов на диске
                        rootViewCurrentView = a;
                        
                        updateRootUI();
                        updateRootDataUI();
                    } else {
                        ftpSettingsEditViewSelectEditField();
                    }
                }
            }
        }
    }
}

void updateFtpStatus() {
    a = updateFtpStatusTike;
    if (a < 240) {
        a++;
        updateFtpStatusTike = a;
        return;
    }
    a = 0;
    updateFtpStatusTike = a;
    //
    getFtpState();
    //
    updateFtpStatusUI();
}

void updateFtpStatusUI() {
    if ((a = ftpSettingsStateChange) == 0x01) {
        a = 0x00;
        ftpSettingsStateChange = a;
        
        updateFtpViewStatusText();
        //
        clearFtpViewValData();
        updateFtpViewValData();
        
        // Получаем каталог
        if ((a = ftpSettingsStateVal) == 0x01) {
            needUpdateFtpList();
        }
    }
}

#endif /* FtpSettingsEditViewFunctions_h */
