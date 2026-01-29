//
//  SelectDiskViewFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 21.01.2026.
//

#ifndef SelectDiskViewFunctions_h
#define SelectDiskViewFunctions_h

void SelectDiskViewShow() {
    CurrentViewChangeAndPushIdA(a = SelectDiskViewId);
    push_pop(bc, hl, de) {
        a = SelectDiskViewX;
        h = a;
        a = SelectDiskViewY;
        l = a;
        a = SelectDiskViewDX;
        d = a;
        a = SelectDiskViewDY;
        e = a;
        a = SelectDiskViewColor;
        c = a;
        a = vboxCLW;
        a |= vboxFRM;
        a |= vboxSDW;
        a |= vboxSAV;
        a |= vboxUMP;
        vboxOpenHLDECA();
        
        a = DiskViewDiskNum;
        a -= 'A';
        SelectDiskViewCurrentPos = a;
        
        SelectDiskViewShowDiskList();
        SelectDiskViewUpdateSelectA(a = 1);
    }
}

void SelectDiskViewShowDiskList() {
    push_pop(bc) {
        // Title
        a = SelectDiskViewY;
        a += 1;
        myCharPosY = a;
        a = SelectDiskViewX;
        a += 4;
        myCharPosX = a;
        printMyHLStr(hl = SelectDiskViewSelectTitle);
        // SubTitle
        a = SelectDiskViewY;
        a += 2;
        myCharPosY = a;
        a = SelectDiskViewX;
        a += 4;
        myCharPosX = a;
        printMyHLStr(hl = SelectDiskViewSelectSubTitle);
        // LINE!!!
        a = SelectDiskViewX;
        a += 1;
        myCharPosX = a;
        a = SelectDiskViewY;
        a += 3;
        myCharPosY = a;
        a = SelectDiskViewDX;
        a -= 2;
        b = a;
        do {
            printMyChatA(a = 0x5F);
            b--;
        } while ((a = b) > 0);
        // Disk List
        a = SelectDiskViewY;
        a += 6;
        myCharPosY = a;
        a = SelectDiskViewX;
        a += 2;
        myCharPosX = a;
        b = 0;
        do {
            a = b;
            a += 'A';
            printMyChatA();
            myCharPosXSpaceA(a = 2);
            b++;
        } while ((a = b) < 4);
    }
}

/// 0 - прямой
/// 1 - инверсный
void SelectDiskViewUpdateSelectA() {
    push_pop(bc, hl, de) {
        c = a;
        // HL
        a = SelectDiskViewCurrentPos;
        b = a;
        a = SelectDiskViewX;
        a += 1;
        h = a;
        if ((a = b) > 0) {
            do {
                a = h;
                a += 3;
                h = a;
                b--;
            } while ((a = b) > 0);
        }
        a = SelectDiskViewY;
        a += 5;
        l = a;
        // DE
        a = 3;
        d = a;
        a = 3;
        e = a;
        // C
        if ((a = c) == 0) {
            a = SelectDiskViewColor;
        } else {
            a = SelectDiskViewInvColor;
        }
        c = a;
        // A
        a = vboxUMP;
        vboxOpenHLDECA();
    }
}

void SelectDiskViewSetCurrentPosA() {
    push_pop(bc) {
        b = a;
        SelectDiskViewUpdateSelectA(a = 0);
        a = b;
        SelectDiskViewCurrentPos = a;
        SelectDiskViewUpdateSelectA(a = 1);
    }
}

void SelectDiskViewKeyA() {
    push_pop(hl) {
        l = a;
        if ((a = CurrentViewId) == SelectDiskViewId) {
            if ((a = l) == 0x1B) { //ESC выход
                vboxClose();
                CurrentViewReturn();
            } else if ((a = l) == 0x0D) { // Выбор диска
                vboxClose();
                CurrentViewReturn();
                a = SelectDiskViewCurrentPos;
                a += 'A';
                DiskViewSetDiskNumA();
            } else if ((a = l) == 0x18) { // Вправл
                a = SelectDiskViewCurrentPos;
                a++;
                if (a == 4) {
                    a = 0;
                }
                SelectDiskViewSetCurrentPosA();
            } else if ((a = l) == 0x08) { // Влево
                a = SelectDiskViewCurrentPos;
                if (a == 0) {
                    a = 3;
                } else {
                    a--;
                }
                SelectDiskViewSetCurrentPosA();
            }
        }
    }
}

uint8_t SelectDiskViewX = 17;
uint8_t SelectDiskViewY = 12;
uint8_t SelectDiskViewDX = 14;
uint8_t SelectDiskViewDY = 9;
uint8_t SelectDiskViewColor = 0x70; //0x1F;
uint8_t SelectDiskViewInvColor = 0x20; //0x2E;

uint8_t SelectDiskViewCurrentPos = 0;

uint8_t SelectDiskViewSelectTitle[7] = "Choose";
uint8_t SelectDiskViewSelectSubTitle[7] = "drive:";

#endif /* SelectDiskViewFunctions_h */
