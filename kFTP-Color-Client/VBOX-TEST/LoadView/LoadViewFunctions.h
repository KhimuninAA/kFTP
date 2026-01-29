//
//  LoadViewFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 22.01.2026.
//

#ifndef LoadViewFunctions_h
#define LoadViewFunctions_h

void LoadViewShowHL() {
    CurrentViewChangeAndPushIdA(a = LoadViewId);
    push_pop(bc, hl, de) {
        a = LoadViewX;
        h = a;
        a = LoadViewY;
        l = a;
        a = LoadViewDX;
        d = a;
        a = LoadViewDY;
        e = a;
        a = LoadViewColor;
        c = a;
        a = vboxCLW;
        a |= vboxFRM;
        a |= vboxSDW;
        a |= vboxSAV;
        a |= vboxUMP;
        vboxOpenHLDECA();
    }
    LoadViewShowTitleHL();
}

void LoadViewClose() {
    vboxClose();
    CurrentViewReturn();
}

void LoadViewShowTitleHL() {
    push_pop(bc) {
        push_pop(hl) {
            b = 0;
            do {
                a = *hl;
                c = a;
                hl++;
                b++;
                if ((a = LoadViewDX) < b) {
                    a = 0;
                    c = a;
                }
            } while ((a = c) > 0);
        }
        a = LoadViewDX;
        a -= b;
        a &= 0xFE;
        cyclic_rotate_right(a, 1);
        c = a;
        // X
        a = LoadViewX;
        a += c;
        myCharPosX = a;
        // Y
        a = LoadViewY;
        a += 1;
        myCharPosY = a;
        //
        printMyHLStr();
    }
}

void LoadViewShowProgressA() {
    push_pop(bc) {
        c = a; //Save
        //
        // X
        a = LoadViewX;
        a += 1;
        myCharPosX = a;
        // Y
        a = LoadViewY;
        a += 2;
        myCharPosY = a;
        b = 0;
        do {
            if ((a = b) < c) {
                printMyChatA(a = 0xDB);
            } else {
                printMyChatA(a = 0xB0); //0xB0 0xB1 0xB2
            }
            b++;
        } while ((a = b) < 40);
    }
}

uint8_t LoadViewX = 3;
uint8_t LoadViewY = 14;
uint8_t LoadViewDX = 42;
uint8_t LoadViewDY = 4;
uint8_t LoadViewColor = 0x70; // 0x1F;

uint8_t LoadViewProgress = 0;

uint8_t LoadViewLoadTitle[] = "Load...";

#endif /* LoadViewFunctions_h */
