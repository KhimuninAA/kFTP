//
//  FtpSettingsViewFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 25.01.2026.
//

#ifndef FtpSettingsViewFunctions_h
#define FtpSettingsViewFunctions_h

void FtpSettingsViewShow() {
    push_pop(bc, hl, de) {
        CurrentViewChangeAndPushIdA(a = FtpSettingsViewId);
        //--
        a = FtpSettingsViewX;
        h = a;
        a = FtpSettingsViewY;
        l = a;
        a = FtpSettingsViewDX;
        d = a;
        a = FtpSettingsViewDY;
        e = a;
        a = FtpSettingsViewColor;
        c = a;
        a = vboxCLW;
        a |= vboxFRM;
        a |= vboxSDW;
        a |= vboxSAV;
        a |= vboxUMP;
        vboxOpenHLDECA();
    }
    a = 0;
    FtpSettingsViewSelectPos = a;
    FtpSettingsViewShowTitle();
    FtpSettingsViewShowValue();
    FtpSettingsViewSelectLineA(a = 1);
}

void FtpSettingsViewClose() {
    vboxClose();
    CurrentViewReturn();
}

void FtpSettingsViewShowTitle() {
    push_pop(hl, bc, de) {
        // Title
        a = FtpSettingsViewX;
        a += 7;
        myCharPosX = a;
        a = FtpSettingsViewY;
        a += 1; //2;
        myCharPosY = a;
        printMyHLStr(hl = FtpSettingsViewTitle);
        // LINE!!!
        a = FtpSettingsViewX;
        a += 1;
        myCharPosX = a;
        a = FtpSettingsViewY;
        a += 2;
        myCharPosY = a;
        a = FtpSettingsViewDX;
        a -= 2;
        b = a;
        do {
            printMyChatA(a = 0x5F);
            b--;
        } while ((a = b) > 0);
        // IP
        a = FtpSettingsViewX;
        a += 2;
        b = a; // X
        myCharPosX = a;
        a = FtpSettingsViewY;
        a += 4;
        c = a; // Y
        myCharPosY = a;
        printMyHLStr(hl = FtpSettingsViewTitleIP);
        // PORT
        a = b;
        myCharPosX = a;
        a = c;
        a += 1;
        myCharPosY = a;
        printMyHLStr(hl = FtpSettingsViewTitlePort);
        // USER
        a = b;
        myCharPosX = a;
        a = c;
        a += 2;
        myCharPosY = a;
        printMyHLStr(hl = FtpSettingsViewTitleUser);
        // PASS
        a = b;
        myCharPosX = a;
        a = c;
        a += 3;
        myCharPosY = a;
        printMyHLStr(hl = WiFiSettingsViewTitlePass);
        // HOME dir
        a = b;
        myCharPosX = a;
        a = c;
        a += 4;
        myCharPosY = a;
        printMyHLStr(hl = FtpSettingsViewTitleHomeDir);
        // Button
        if ((a = FtpStateViewStatus) == 0) {
            bc = WiFiSettingsViewButtonTitle;
        } else {
            bc = strOK;
        }
        
        d = 13;
        e = 3;
        a = FtpSettingsViewX;
        a += 7;
        h = a;
        a = FtpSettingsViewY;
        a += 10;
        l = a;
        ButtonShadowViewShow();
    }
}

void FtpSettingsViewShowValue() {
    push_pop(hl, bc) {
        // IP
        a = FtpSettingsViewX;
        a += 8;
        b = a; // X
        myCharPosX = a;
        a = FtpSettingsViewY;
        a += 4;
        c = a; // Y
        myCharPosY = a;
        a = 18;
        printMyHLStrLenA(hl = FtpStateViewIpValue);
        // PORT
        a = b;
        myCharPosX = a;
        a = c;
        a += 1;
        myCharPosY = a;
        a = 18;
        printMyHLStrLenA(hl = FtpSettingsViewValuePort);
        // USER
        a = b;
        myCharPosX = a;
        a = c;
        a += 2;
        myCharPosY = a;
        a = 18;
        printMyHLStrLenA(hl = FtpSettingsViewValueUser);
        // PASS
        a = b;
        myCharPosX = a;
        a = c;
        a += 3;
        myCharPosY = a;
        a = 18;
        printMyHLPassLenA(hl = FtpSettingsViewValuePass);
        // HOME DIR
        a = b;
        myCharPosX = a;
        a = c;
        a += 4;
        myCharPosY = a;
        a = 18;
        printMyHLStrLenA(hl = FtpSettingsViewValueHomeDir);
    }
}

/// вых [BC] -
void FtpSettingsViewByPosValue() {
    if ((a = FtpSettingsViewSelectPos) == 1) {
        bc = FtpStateViewIpValue;
    } else if ((a = FtpSettingsViewSelectPos) == 2) {
        bc = FtpSettingsViewValuePort;
    } else if ((a = FtpSettingsViewSelectPos) == 3) {
        bc = FtpSettingsViewValueUser;
    } else if ((a = FtpSettingsViewSelectPos) == 4) {
        bc = FtpSettingsViewValuePass;
    } else if ((a = FtpSettingsViewSelectPos) == 5) {
        bc = FtpSettingsViewValueHomeDir;
    } else {
        bc = 0;
    }
}

/// вых [HL] -
/// вых [DE]-
void FtpSettingsViewByPosBoxValue() {
    push_pop(bc) {
        // HL
        a = FtpSettingsViewSelectPos;
        b = a;
        a = FtpSettingsViewY;
        a += 3;
        a += b;
        l = a;
        a = FtpSettingsViewX;
        a += 7;
        h = a;
        // DE
        a = FtpSettingsViewDX;
        a -= 8;
        d = a;
        a = 1;
        e = a;
    }
}

/// Обновление позиции
/// вх[A]
/// 0 - без изменений
/// 1 - вверх
/// 0xFF - вниз
void FtpSettingsViewPosUpdateA() {
    push_pop(bc) {
        b = a;
        if (a == 0) {
            FtpSettingsViewSelectLineA(a = 1);
        } else {
            a = 6;
            c = a;
            FtpSettingsViewSelectLineA(a = 0);
            a = FtpSettingsViewSelectPos;
            a += b;
            b = a;
            //-- FIX
            if ((a = b) == 0xFF) {
                a = c;
                a--;
            } else if ((a = b) == c) {
                a = 0;
            }
            //--
            FtpSettingsViewSelectPos = a;
            FtpSettingsViewSelectLineA(a = 1);
        }
    }
}

/// Рисование линии прямым или инверсным цветом
/// 0 - прямой
/// 1 - инверсный
void FtpSettingsViewSelectLineA() {
    push_pop(bc, hl) {
        c = a;
        // 0 - Button
        if ((a = FtpSettingsViewSelectPos) == 0) {
            ButtonShadowViewSelectA(a = c);
        } else {
            FtpSettingsViewByPosBoxValue();
            // C
            if ((a = c) == 0) {
                a = FtpSettingsViewColor;
            } else {
                a = FtpSettingsViewInvColor;
            }
            c = a;
            // A
            a = vboxUMP;
            vboxOpenHLDECA();
        }
    }
}

void FtpSettingsViewKeyA() {
    push_pop(hl) {
        l = a;
        if ((a = c) == 0) {
            if ((a = CurrentViewId) == FtpSettingsViewId) {
                if ((a = l) == 0x1B) { //ESC выход
                    FtpSettingsViewClose();
                } else if ((a = l) == 0x0D) { // Выбор
                    if ((a = FtpSettingsViewSelectPos) == 0) { // OK
                        WiFiSettingsViewClose();
                        if ((a = FtpStateViewStatus) == 0) {
                            needFtpConnect();
                            ThreadsTickNow();
                        }
                    } else { // Переход в редактирование
                        FtpSettingsViewByPosBoxValue();
                        FtpSettingsViewByPosValue();
                        EditFieldViewShow();
                        if (a == 1) { // что то изменилось
                            if ((a = FtpSettingsViewSelectPos) == 5) {
                                ThreadsNetFtpHomeDirUpdate();
                            } else if ((a = FtpSettingsViewSelectPos) == 3) {
                                ThreadsNetFtpUserUpdate();
                            } else if ((a = FtpSettingsViewSelectPos) == 4) {
                                ThreadsNetFtpPasswordUpdate();
                            } else if ((a = FtpSettingsViewSelectPos) == 1) { // IP
                                ThreadsNetFtpServerUrlUpdate();
                            } else if ((a = FtpSettingsViewSelectPos) == 2) { // PORT
                                ThreadsNetFtpPortUpdate();
                            }
                            FtpSettingsViewShowValue();
                        }
                    }
                } else if ((a = l) == 0x1A) { //down
                    FtpSettingsViewPosUpdateA(a = 0x01);
                } else if ((a = l) == 0x19) { //up
                    FtpSettingsViewPosUpdateA(a = 0xFF);
                }
            }
        }
    }
}

uint8_t FtpSettingsViewX = 11;
uint8_t FtpSettingsViewY = 9;
uint8_t FtpSettingsViewDX = 27;
uint8_t FtpSettingsViewDY = 15;
uint8_t FtpSettingsViewColor = 0x70;
uint8_t FtpSettingsViewInvColor = 0x07;

uint8_t FtpSettingsViewSelectPos = 1; //0

uint8_t FtpSettingsViewTitle[] = "FTP settings";
uint8_t FtpSettingsViewTitleIP[] =      "  IP:";
uint8_t FtpSettingsViewTitlePort[] =    "Port:";
uint8_t FtpSettingsViewTitleHomeDir[] = "Home:";
uint8_t FtpSettingsViewTitleUser[] = "User:";

uint8_t FtpSettingsViewValuePort[16] = "21";
uint8_t FtpSettingsViewValueUser[16] = "-";
uint8_t FtpSettingsViewValuePass[16] = "-";
uint8_t FtpSettingsViewValueHomeDir[16] = "/";

#endif /* FtpSettingsViewFunctions_h */
