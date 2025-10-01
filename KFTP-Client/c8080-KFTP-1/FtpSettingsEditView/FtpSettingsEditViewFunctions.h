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

#endif /* FtpSettingsEditViewFunctions_h */
