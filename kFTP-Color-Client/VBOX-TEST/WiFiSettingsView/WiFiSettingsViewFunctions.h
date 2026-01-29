//
//  WiFiSettingsViewFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 23.01.2026.
//

#ifndef WiFiSettingsViewFunctions_h
#define WiFiSettingsViewFunctions_h

void WiFiSettingsViewShow() {
    push_pop(bc, hl, de) {
        CurrentViewChangeAndPushIdA(a = WiFiSettingsViewId);
        //--
        a = WiFiSettingsViewX;
        h = a;
        a = WiFiSettingsViewY;
        l = a;
        a = WiFiSettingsViewDX;
        d = a;
        a = WiFiSettingsViewDY;
        e = a;
        a = WiFiSettingsViewColor;
        c = a;
        a = vboxCLW;
        a |= vboxFRM;
        a |= vboxSDW;
        a |= vboxSAV;
        a |= vboxUMP;
        vboxOpenHLDECA();
    }
    a = 0;
    WiFiSettingsViewSelectPos = a;
    WiFiSettingsViewShowTitle();
    WiFiSettingsViewShowValue();
    WiFiSettingsViewSelectLineA(a = 1);
}

void WiFiSettingsViewShowTitle() {
    push_pop(hl, bc, de) {
        // Title
        a = WiFiSettingsViewX;
        a += 7;
        myCharPosX = a;
        a = WiFiSettingsViewY;
        a += 1; //2;
        myCharPosY = a;
        printMyHLStr(hl = WiFiSettingsViewTitle);
        // LINE!!!
        a = WiFiSettingsViewX;
        a += 1;
        myCharPosX = a;
        a = WiFiSettingsViewY;
        a += 2;
        myCharPosY = a;
        a = WiFiSettingsViewDX;
        a -= 2;
        b = a;
        do {
            printMyChatA(a = 0x5F);
            b--;
        } while ((a = b) > 0);
        // SSID
        a = WiFiSettingsViewX;
        a += 2;
        b = a; // X
        myCharPosX = a;
        a = WiFiSettingsViewY;
        a += 4;
        c = a; // Y
        myCharPosY = a;
        printMyHLStr(hl = WifiStateViewTitleSSID);
        // PASS
        a = b;
        myCharPosX = a;
        a = c;
        a += 1;
        myCharPosY = a;
        printMyHLStr(hl = WiFiSettingsViewTitlePass);
        // MAC
        a = b;
        myCharPosX = a;
        a = c;
        a += 2;
        myCharPosY = a;
        printMyHLStr(hl = WiFiSettingsViewTitleMac);
        // OK
        d = 13;
        e = 3;
        a = WiFiSettingsViewX;
        a += 7;
        h = a;
        a = c;
        a += 4;
        l = a;
        if ((a = WifiStateViewSSIDIsConnected) == 0) {
            bc = WiFiSettingsViewButtonTitle;
        } else {
            bc = strOK;
        }
        ButtonShadowViewShow();
    }
}

void WiFiSettingsViewShowValue() {
    push_pop(hl, bc) {
        // SSID
        a = WiFiSettingsViewX;
        a += 8;
        b = a; // X
        myCharPosX = a;
        a = WiFiSettingsViewY;
        a += 4;
        c = a; // Y
        myCharPosY = a;
        a = 18;
        printMyHLStrLenA(hl = WifiStateViewSsidVal);
        // PASS
        a = b;
        myCharPosX = a;
        a = c;
        a += 1;
        myCharPosY = a;
        a = 18;
        printMyHLPassLenA(hl = WifiStateViewPassVal);
        // MAC
        a = b;
        myCharPosX = a;
        a = c;
        a += 2;
        myCharPosY = a;
        a = 18;
        printMyHLStrLenA(hl = WifiStateViewMacVal);
    }
}

void WiFiSettingsViewClose() {
    vboxClose();
    CurrentViewReturn();
}

void WiFiSettingsViewKeyA() {
    push_pop(hl) {
        l = a;
        if ((a = c) == 0) {
            if ((a = CurrentViewId) == WiFiSettingsViewId) {
                if ((a = l) == 0x1B) { //ESC выход
                    WiFiSettingsViewClose();
                } else if ((a = l) == 0x0D) { // Выбор
                    if ((a = WiFiSettingsViewSelectPos) == 0) { // OK
                        WiFiSettingsViewClose();
                        if ((a = WifiStateViewSSIDIsConnected) == 0) {
                            needSsidConnect();
                            ThreadsTickNow();
                        }
                    } else if ((a = WiFiSettingsViewSelectPos) == 1) { // Выбор SSID
                        WiFiNetworksViewShow();
                    } else { // Переход в редактирование
                        WiFiSettingsViewByPosBoxValue();
                        WiFiSettingsViewByPosValue();
                        EditFieldViewShow();
                        if (a == 1) { // что то изменилось
                            #ifdef _IS_SIMULATOR

                            #else
                                ThreadsNetPasswordUpdate();
                            #endif
                            WiFiSettingsViewShowValue();
                        }
                    }
                } else if ((a = l) == 0x1A) { //down
                    WiFiSettingsViewPosUpdateA(a = 0x01);
                } else if ((a = l) == 0x19) { //up
                    WiFiSettingsViewPosUpdateA(a = 0xFF);
                }
            }
        }
    }
}

/// вых [BC] -
void WiFiSettingsViewByPosValue() {
    push_pop(hl) {
        if ((a = WiFiSettingsViewSelectPos) == 2) {
            bc = WifiStateViewPassVal;
        } else {
            bc = 0;
        }        
    }
}

/// вых [HL] -
/// вых [DE]-
void WiFiSettingsViewByPosBoxValue() {
    push_pop(bc) {
        // HL
        a = WiFiSettingsViewSelectPos;
        b = a;
        a = WiFiSettingsViewY;
        a += 3;
        a += b;
        l = a;
        a = WiFiSettingsViewX;
        a += 7;
        h = a;
        // DE
        a = WiFiSettingsViewDX;
        a -= 8;
        d = a;
        a = 1;
        e = a;
    }
}

/// Рисование линии прямым или инверсным цветом
/// 0 - прямой
/// 1 - инверсный
void WiFiSettingsViewSelectLineA() {
    push_pop(bc, hl) {
        c = a;
        // 0 - Button
        if ((a = WiFiSettingsViewSelectPos) == 0) {
            ButtonShadowViewSelectA(a = c);
        } else {
            WiFiSettingsViewByPosBoxValue();
            // C
            if ((a = c) == 0) {
                a = WiFiSettingsViewColor;
            } else {
                a = WiFiSettingsViewInvColor;
            }
            c = a;
            // A
            a = vboxUMP;
            vboxOpenHLDECA();
        }
    }
}

/// Обновление позиции
/// вх[A]
/// 0 - без изменений
/// 1 - вверх
/// 0xFF - вниз
void WiFiSettingsViewPosUpdateA() {
    push_pop(bc) {
        b = a;
        if (a == 0) {
            WiFiSettingsViewSelectLineA(a = 1);
        } else {
            a = 3;
            c = a;
            WiFiSettingsViewSelectLineA(a = 0);
            a = WiFiSettingsViewSelectPos;
            a += b;
            //-- FIX
            if (a == 0xFF) {
                a = c;
                a--;
            } else if (a == c) {
                a = 0;
            }
            //--
            WiFiSettingsViewSelectPos = a;
            WiFiSettingsViewSelectLineA(a = 1);
        }
    }
}

uint8_t WiFiSettingsViewX = 11;
uint8_t WiFiSettingsViewY = 10;
uint8_t WiFiSettingsViewDX = 27;
uint8_t WiFiSettingsViewDY = 13;
uint8_t WiFiSettingsViewColor = 0x70;
uint8_t WiFiSettingsViewInvColor = 0x07;

uint8_t WiFiSettingsViewSelectPos = 0;

uint8_t WiFiSettingsViewTitle[] = "Wi-Fi settings";
uint8_t WiFiSettingsViewTitlePass[] = "Pass:";
uint8_t WiFiSettingsViewTitleMac[] =  " MAC:";
uint8_t WiFiSettingsViewButtonTitle[] = "Connect";

#endif /* WiFiSettingsViewFunctions_h */
