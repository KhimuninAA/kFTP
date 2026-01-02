//
//  FtpSettingsFunctions.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 01.01.2026.
//

#ifndef FtpSettingsFunctions_h
#define FtpSettingsFunctions_h

void showFtpView() {
    drowRectX = (a = ftpSettingsViewX);
    drowRectY = (a = ftpSettingsViewY);
    drowRectEndX = (a = ftpSettingsViewEX);
    drowRectEndY = (a = ftpSettingsViewEY);
    drowRect();
    
    hl = ftpSettingsLabelPos;
    setPosCursor();
    hl = ftpSettingsLabel;
    printHLStr();
    
    hl = ftpSettingsStatusLabelPos;
    setPosCursor();
    hl = ftpSettingsStatusLabel;
    printHLStr();
    
    hl = ftpSettingsIpLabelPos;
    setPosCursor();
    hl = ftpSettingsIpLabel;
    printHLStr();
    
    hl = ftpSettingsPortLabelPos;
    setPosCursor();
    hl = ftpSettingsPortLabel;
    printHLStr();
    
    hl = ftpSettingsUserLabelPos;
    setPosCursor();
    hl = ftpSettingsUserLabel;
    printHLStr();
    
    //Value
    hl = ftpSettingsIpValuePos;
    setPosCursor();
    hl = ftpSettingsIpValue;
    printHLStr();
    
    hl = ftpSettingsPortValuePos;
    setPosCursor();
    hl = ftpSettingsPortValue;
    printHLStr();
    
    hl = ftpSettingsUserValuePos;
    setPosCursor();
    hl = ftpSettingsUserValue;
    printHLStr();
    
    updateFtpViewStatusText();
    updateFtpViewValData();
}

void clearFtpViewValData() {
    hl = ftpSettingsStatusValuePos;
    setPosCursor();
    hl = wifiSettingsEmpty18;
    printHLStr();
}

void updateFtpViewValData() {
    hl = ftpSettingsStatusValuePos;
    setPosCursor();
    hl = ftpSettingsStatusValue;
    printHLStr();
}

void updateFtpViewStatusText() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                
                if ((a = ftpSettingsStateVal) == 0x00) {
                    hl = ftpSettingsStatus0;
                } else {
                    hl = ftpSettingsStatus1;
                }
                
                de = ftpSettingsStatusValue;
                //Copy *hl to *de
                b = 12;
                do {
                    a = *hl;
                    *de = a;
                    if ((a = b) == 1) {
                        a = 0;
                        *de = a;
                    }
                    de++;
                    hl++;
                    b--;
                } while ((a = b) > 0);
            }
        }
    }
}

#endif /* FtpSettingsFunctions_h */
