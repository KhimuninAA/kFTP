//
//  DiskViewFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef DiskViewFunctions_h
#define DiskViewFunctions_h

void DiskViewShow() {
    a = DiskViewX;
    h = a;
    a = DiskViewY;
    l = a;
    a = DiskViewDX;
    d = a;
    a = DiskViewDY;
    e = a;
    a = DiskViewColor;
    vboxOpenHLDE();
    vboxBorderHLDE();
    DiskViewShowTitle();
    
    //DEBUG!!!
    DiskViewSetDiskNumA(a = 'B');
}

void DiskViewShowTitle() {
    a = DiskViewX;
    a++;
    myCharPosX = a;
    a = DiskViewY;
    myCharPosY = a;
    printMyHLStr(hl = DiskViewTitle);
}

void DiskViewUpdateDir() {
    push_pop(hl) {
        a = DiskViewDiskNum;
        ordos_wnd();
        hl = DiskViewDirBufer;
        ordos_dirm();
        DiskViewDirCount = a;
    }
}

void DiskViewShowDir() {
    push_pop(hl, bc, de) {
        //-----
        a = DiskViewX;
        a += 2;
        d = a; // X
        a = DiskViewY;
        a += 3;
        e = a; // Y
        //-----
        a = d;
        myCharPosX = a;
        a = e;
        a--;
        myCharPosY = a;
        printMyHLStr(hl = DiskViewDirRootTitle);
        //-----
        if ((a = DiskViewDirCount) >= 1) {
            hl = DiskViewDirBufer;
            b = 0;
            do {
                a = d;
                myCharPosX = a;
                a = e;
                a += b;
                myCharPosY = a;
                c = 8;
                do {
                    printMyChatA(a = *hl);
                    hl++;
                    c--;
                } while ((a = c) > 0);
                hl++;
                hl++;
                hl++;
                hl++;
                hl++;
                hl++;
                hl++;
                hl++;
                b++;
                a = DiskViewDirCount;
                a--;
            } while (a >= b);
        }
        // show empty rows
        a = DiskViewDirCount;
        b = a;
        // PosY
        a = e;
        a += b;
        e = a;
        //
        a = DiskViewDY;
        a -= 4;
        a -= b;
        b = a;
        c = 0;
        do {
            a = d;
            myCharPosX = a;
            a = e;
            a += c;
            myCharPosY = a;
            //
            a = DiskViewDX;
            a -= 3;
            h = a;
            do {
                printMyChatA(a = ' ');
                h--;
            } while ((a = h) > 0);
            b--;
            c++;
        } while ((a = b) > 0);
    }
}

void DiskViewKeyA() {
    push_pop(hl) {
        l = a;
        if ((a = CurrentViewId) == DiskViewId) {
            if ((a = l) == 0x09) { //0x09 TAB
                CurrentViewChangeIdA(a = FtpViewId);
            } else {
                if ((a = l) == 0x1A) { //down
                    DiskViewFileCurrentPosUpdateA(a = 0x01);
                } else if ((a = l) == 0x19) { //up
                    DiskViewFileCurrentPosUpdateA(a = 0xFF);
                } else if ((a = l) == 0x0D) { //Enter
                    if ((a = DiskViewFileCurrentPos) == 0) { // Смена диска
                        DiskViewNextDiskNum();
                    } else { // Закачка на FTP
                        
                    }
                } else if ((a = l) == 'D') { //  Показать выбор диска
                    SelectDiskViewShow();
                }
            }
        }
    }
}

void DiskViewNextDiskNum() {
    a = DiskViewDiskNum;
    a++;
    if (a == 'E') {
        a = 'A';
    }
    DiskViewSetDiskNumA();
}

void DiskViewSetDiskNumA() {
    DiskViewDiskNum = a;
    DiskViewShowSelectLineA(a = 0);
    a = 0;
    DiskViewFileCurrentPos = a;
    DiskViewUpdateDiskTitle();
    DiskViewUpdateDateAndUI();
}

void DiskViewUpdateDateAndUI() {
    DiskViewUpdateDir();
    DiskViewShowDir();
    if ((a = CurrentViewId) == DiskViewId) {
        DiskViewShowSelectLineA(a = 1);
    }
}

void DiskViewUpdateDiskTitle() {
    a = DiskViewX;
    a += 7;
    myCharPosX = a;
    a = DiskViewY;
    myCharPosY = a;
    printMyChatA(a = DiskViewDiskNum);
}

/// Обновление позиции
/// вх[A]
/// 0 - без изменений
/// 1 - вверх
/// 0xFF - вниз
void DiskViewFileCurrentPosUpdateA() {
    push_pop(bc) {
        b = a;
        if (a == 0) {
            DiskViewShowSelectLineA(a = 1);
        } else {
            a = DiskViewDirCount;
            a += 1;
            c = a;
            DiskViewShowSelectLineA(a = 0);
            a = DiskViewFileCurrentPos;
            a += b;
            //
            if (a == 0xFF) {
                a = c;
                a--;
            } else if (a == c) {
                a = 0;
            }
            DiskViewFileCurrentPos = a;
            DiskViewShowSelectLineA(a = 1);
        }
    }
}

/// Рисование линии прямым или инверсным цветом
/// 0 - прямой
/// 1 - инверсный
void DiskViewShowSelectLineA() {
    push_pop(bc, hl, de) {
        c = a;
        // HL
        a = DiskViewFileCurrentPos;
        b = a;
        a = DiskViewY;
        a += 2;
        a += b;
        l = a;
        a = DiskViewX;
        a += 1;
        h = a;
        // DE
        a = DiskViewDX;
        a -= 2;
        d = a;
        a = 1;
        e = a;
        // C
        if ((a = c) == 0) {
            a = DiskViewColor;
        } else {
            a = DiskViewInvColor;
        }
        c = a;
        // A
        a = vboxUMP;
        vboxOpenHLDECA();
    }
}

uint8_t DiskViewX = 28;
uint8_t DiskViewY = 4;
uint8_t DiskViewDX = 20;
uint8_t DiskViewDY = 25;
uint8_t DiskViewColor = 0x1F;
uint8_t DiskViewInvColor = 0xF1;

uint8_t DiskViewDiskNum = 'B';
uint8_t DiskViewDirCount = 0;
uint16_t DiskViewDirBufer = 0x0000;
uint8_t DiskViewFileCurrentPos = 0;

uint16_t DiskViewStartNewFile = 0x0000;

uint8_t DiskViewDirRootTitle[] = "..";
uint8_t DiskViewTitle[] = {0xB5, 'D', 'i', 's', 'k', ':', 'A', 0xC6, '\0'};

#endif /* DiskViewFunctions_h */
