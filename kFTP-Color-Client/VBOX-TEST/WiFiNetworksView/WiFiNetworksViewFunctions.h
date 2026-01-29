//
//  WiFiNetworksViewFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 24.01.2026.
//

#ifndef WiFiNetworksViewFunctions_h
#define WiFiNetworksViewFunctions_h

void WiFiNetworksViewShow() {
    CurrentViewChangeAndPushIdA(a = WiFiNetworksViewId);
    push_pop(bc, hl, de) {
        a = WiFiNetworksViewX;
        h = a;
        a = WiFiNetworksViewY;
        l = a;
        a = WiFiNetworksViewDX;
        d = a;
        a = WiFiNetworksViewDY;
        e = a;
        a = WiFiNetworksViewColor;
        c = a;
        a = vboxCLW;
        a |= vboxFRM;
        a |= vboxSDW;
        a |= vboxSAV;
        a |= vboxUMP;
        vboxOpenHLDECA();
    }
    WiFiNetworksViewShowTitle();
    WiFiNetworksViewUpdateList();
}

void WiFiNetworksViewUpdateList() {
    WiFiNetworksViewSelectLineA(a = 0);
    #ifdef _IS_SIMULATOR

    #else
        WiFiNetworksViewClearData();
        needUpdateSSIDList();
        getSsidList();
        WiFiNetworksViewFixData();
    #endif
    WiFiNetworksViewShowList();
    a = 0;
    WiFiNetworksViewSelectPos = a;
    WiFiNetworksViewSelectLineA(a = 1);
}

void WiFiNetworksViewFixData() {
    push_pop(hl, bc, de) {
        hl = WiFiNetworksViewSSIDList;
        de = 16;
        b = 16;
        do {
            a = *hl;
            if (a == 0) {
                a = '-';
                *hl = a;
            }
            hl += de;
            b--;
        } while ((a = b) > 0);
    }
}

void WiFiNetworksViewShowTitle() {
    push_pop(hl, bc, de) {
        // Title
        a = WiFiNetworksViewX;
        a += 3;
        myCharPosX = a;
        a = WiFiNetworksViewY;
        a += 1; //2;
        myCharPosY = a;
        printMyHLStr(hl = WiFiNetworksViewTitle);
        // LINE!!!
        a = WiFiNetworksViewX;
        a += 1;
        myCharPosX = a;
        a = WiFiNetworksViewY;
        a += 2;
        myCharPosY = a;
        a = WiFiNetworksViewDX;
        a -= 2;
        b = a;
        do {
            printMyChatA(a = 0x5F);
            b--;
        } while ((a = b) > 0);
    }
}

void WiFiNetworksViewClose() {
    vboxClose();
    CurrentViewReturn();
}

void WiFiNetworksViewKeyA() {
    push_pop(hl) {
        l = a;
        if ((a = c) == 0) {
            if ((a = CurrentViewId) == WiFiNetworksViewId) {
                if ((a = l) == 0x1B) { //ESC выход
                    WiFiNetworksViewClose();
                } else if ((a = l) == 0x0D) { // Выбор
                    WiFiNetworksViewClose();
                    //--
                    #ifdef _IS_SIMULATOR
                        WiFiNetworksViewCopySSIDForSimulator();
                    #else
                        ThreadsNetSsidUpdateA(a = WiFiNetworksViewSelectPos);
                    #endif
                    WiFiSettingsViewShowValue();
                    //--
                } else if ((a = l) == 0x1A) { //down
                    WiFiNetworksViewPosUpdateA(a = 0x01);
                } else if ((a = l) == 0x19) { //up
                    WiFiNetworksViewPosUpdateA(a = 0xFF);
                }
            }
        }
    }
}

void WiFiNetworksViewCopySSIDForSimulator() {
    push_pop(hl, bc, de) {
        hl = WiFiNetworksViewSSIDList;
        a = WiFiNetworksViewSelectPos;
        a &= 0x0F;
        cyclic_rotate_left(a, 4);
        e = a;
        d = 0;
        hl += de;
        de = WifiStateViewSsidVal;
        //-- Copy
        b = 16;
        c = 0; // is 0 exist
        do {
            a = *hl;
            *de = a;
            if (a == 0) {
                c = 1;
            }
            hl++;
            de++;
            b--;
        } while ((a = b) > 0);
        //-- if stop byte (0)
        if ((a = c) == 0) {
            de--;
            a = 0;
            *de = a;
        }
    }
}

void WiFiNetworksViewClearData() {
    push_pop(hl, bc) {
        hl = WiFiNetworksViewSSIDList;
        b = 0xFF;
        do {
            *hl = 0;
            hl++;
            b--;
        } while ((a = b) > 0);
    }
}

void WiFiNetworksViewShowList() {
    push_pop(hl, bc, de) {
        hl = WiFiNetworksViewSSIDList;
        c = 0;
        //
        a = WiFiNetworksViewX;
        a += 2;
        d = a; // X
        a = WiFiNetworksViewY;
        a += 5;
        e = a; // Y
        //
        do {
            //--
            a = e;
            a += c;
            myCharPosY = a;
            a = d;
            myCharPosX = a;
            //--
            b = 16;
            do {
                printMyChatA(a = *hl);
                hl++;
                b--;
            } while ((a = b) > 0);
            c++;
        } while ((a = WiFiNetworksViewSSIDCount) >= c);
        // Crean
        a = WiFiNetworksViewSSIDCount;
        c = a;
        a = 16; // Максимальное число строк
        a -= c;
        if (a > 0) { // До добавляем пустые строки
            b = a;
            //--
            a = WiFiNetworksViewSSIDCount;
            a += e;
            e = a;
            //--
            h = 0;
            do {
                //--
                a = e;
                a += h;
                myCharPosY = a;
                a = d;
                myCharPosX = a;
                //--
                c = 16;
                do {
                    printMyChatA(a = ' ');
                    c--;
                } while ((a = c) > 0);
                b--;
                h++;
            } while ((a = b) > 0);
        }
    }
}

/// Обновление позиции
/// вх[A]
/// 0 - без изменений
/// 1 - вверх
/// 0xFF - вниз
void WiFiNetworksViewPosUpdateA() {
    push_pop(bc) {
        b = a;
        if (a == 0) {
            WiFiNetworksViewSelectLineA(a = 1);
        } else {
            a = WiFiNetworksViewSSIDCount;
            c = a;
            WiFiNetworksViewSelectLineA(a = 0);
            if ((a = c) == 0) { // нет ни одной записи
                a = 0;
                WiFiNetworksViewSelectPos = a;
            } else { // если есть хоть одна запись
                a = WiFiNetworksViewSelectPos;
                a += b;
                //-- FIX
                if (a == 0xFF) {
                    a = c;
                    a--;
                } else if (a == c) {
                    a = 0;
                }
                //--
                WiFiNetworksViewSelectPos = a;
            }
            WiFiNetworksViewSelectLineA(a = 1);
        }
    }
}

/// Рисование линии прямым или инверсным цветом
/// 0 - прямой
/// 1 - инверсный
void WiFiNetworksViewSelectLineA() {
    push_pop(bc, hl, de) {
        c = a;
        //--
        a = WiFiNetworksViewSelectPos;
        b = a;
        //--
        a = WiFiNetworksViewX;
        a += 1;
        h = a; // X
        a = WiFiNetworksViewY;
        a += 5;
        a += b;
        l = a; // Y
        //--
        a = WiFiNetworksViewDX;
        a -= 2;
        d = a;
        e = 1;
        //--
        if ((a = c) == 0) {
            a = WiFiNetworksViewColor;
        } else {
            a = WiFiNetworksViewInvColor;
        }
        c = a;
        //--
        a = vboxUMP;
        vboxOpenHLDECA();
    }
}

uint8_t WiFiNetworksViewX = 14; //21;
uint8_t WiFiNetworksViewY = 3;
uint8_t WiFiNetworksViewDX = 20;
uint8_t WiFiNetworksViewDY = 23;
uint8_t WiFiNetworksViewColor = 0x70;
uint8_t WiFiNetworksViewInvColor = 0x07;

uint8_t WiFiNetworksViewSelectPos = 0;

uint8_t WiFiNetworksViewTitle[] = "Wi-Fi Networks";

#ifdef _IS_SIMULATOR
    uint8_t WiFiNetworksViewSSIDCount = 14;
    uint8_t WiFiNetworksViewSSIDList[16*16] = {
        0x44, 0x49, 0x52, 0x45, 0x43, 0x54, 0x2D, 0x4C, 0x30, 0x5B, 0x42, 0x44, 0x5D, 0x53, 0x4C, 0x00,
        0x4B, 0x56, 0x31, 0x35, 0x31, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x4D, 0x47, 0x54, 0x53, 0x5F, 0x47, 0x50, 0x4F, 0x4E, 0x5F, 0x44, 0x44, 0x31, 0x35, 0x00, 0x00,
        0x4D, 0x47, 0x54, 0x53, 0x5F, 0x47, 0x50, 0x4F, 0x4E, 0x5F, 0x39, 0x30, 0x36, 0x39, 0x00, 0x00,
        0x41, 0x45, 0x52, 0x4F, 0x4C, 0x49, 0x4E, 0x4B, 0x44, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x4D, 0x47, 0x54, 0x53, 0x5F, 0x47, 0x50, 0x4F, 0x4E, 0x5F, 0x36, 0x34, 0x36, 0x30, 0x00, 0x00,
        0x4D, 0x54, 0x53, 0x5F, 0x47, 0x50, 0x4F, 0x4E, 0x5F, 0x39, 0x33, 0x32, 0x41, 0x46, 0x38, 0x00,
        0x4D, 0x47, 0x54, 0x53, 0x5F, 0x47, 0x50, 0x4F, 0x4E, 0x5F, 0x39, 0x41, 0x36, 0x32, 0x00, 0x00,
        0x42, 0x45, 0x45, 0x4C, 0x49, 0x4E, 0x45, 0x2D, 0x52, 0x4F, 0x55, 0x54, 0x45, 0x52, 0x45, 0x00,
        0x54, 0x4F, 0x54, 0x4F, 0x52, 0x4F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x50, 0x4F, 0x4B, 0x45, 0x4D, 0x4F, 0x4E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x4B, 0x45, 0x45, 0x4E, 0x45, 0x54, 0x49, 0x43, 0x2D, 0x35, 0x35, 0x35, 0x32, 0x00, 0x00, 0x00,
        0x4B, 0x31, 0x35, 0x39, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x4B, 0x54, 0x31, 0x35, 0x39, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };
#else
    uint8_t WiFiNetworksViewSSIDCount = 0;
    uint8_t WiFiNetworksViewSSIDList[16*16] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };
#endif

#endif /* WiFiNetworksViewFunctions_h */
