//
//  VBOXFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef VBOXFunctions_h
#define VBOXFunctions_h

uint8_t vboxOpenHLDEColor = 0;
uint8_t vboxOpenHLDEAccum = 0;

/// HL верхний левый угол
/// DE нижний правый
/// C цвет
/// A как открывать
void vboxOpenHLDECA() {
    push_pop(bc, de, hl) {
    //push_pop(hl, de, bc, a) {
        vboxOpenHLDEAccum = a;
        a = c;
        vboxOpenHLDEColor = a;
        //HL Начальный адрес
        a = l;
        a &= 0x1F;
        cyclic_rotate_left(a, 3);
        l = a;
        a = h;
        a += 0xC0;
        h = a;
        //BC Размер
        b = d;
        a = e;
        cyclic_rotate_left(a, 3);
        c = a;
        //DE цвет
        d = 0x07; //0x00; //Тень
        a = vboxOpenHLDEColor;
        e = a;
        a = vboxOpenHLDEAccum;
        vboxOpen();
    }
}

void vboxClearCash() {
    push_pop(a) {
        do {
            a = vboxBLW;
            a |= vboxERA;
            a |= vboxUMP;
            vboxCall();
        } while (a == 0x00);
    }
}

/// HL верхний левый угол
/// DE нижний правый
void vboxBorderHLDE() {
    push_pop(bc) {
        //Верхняя линия
        push_pop(hl, de) {
            a = h;
            myCharPosX = a;
            a = l;
            myCharPosY = a;
            printMyChatA(a = 0xC9);
            b = 2;
            do {
                printMyChatA(a = 0xCD);
                b++;
            } while ((a = b) < d);
            printMyChatA(a = 0xBB);
        }
        // Нижняя линия
        push_pop(hl, de) {
            a = h;
            myCharPosX = a;
            a = l;
            a += e;
            a--;
            myCharPosY = a;
            printMyChatA(a = 0xC8);
            b = 2;
            do {
                printMyChatA(a = 0xCD);
                b++;
            } while ((a = b) < d);
            printMyChatA(a = 0xBC);
        }
        // Левая горизонтальная
        push_pop(hl, de) {
            a = h;
            myCharPosX = a;
            a = l;
            a++;
            myCharPosY = a;
            b = 2;
            do {
                printMyChatA(a = 0xBA);
                a = h;
                myCharPosX = a;
                a = l;
                a += b;
                myCharPosY = a;
                b++;
            } while ((a = b) < e);
        }
        // Правая горизонтальная
        push_pop(hl, de) {
            a = h;
            a += d;
            a--;
            c = a;
            myCharPosX = a;
            a = l;
            a++;
            myCharPosY = a;
            b = 2;
            do {
                printMyChatA(a = 0xBA);
                a = c;
                myCharPosX = a;
                a = l;
                a += b;
                myCharPosY = a;
                b++;
            } while ((a = b) < e);
        }
    }
}

void vboxOpenHLDE() {
    c = a;
    a = vboxCLW;
    a |= vboxUMP;
    vboxOpenHLDECA();
}

/// Загрузка драйвера VBOX, если не загружен
void validVBOX() {
    a = vboxAddr; // 0 - если там знакогенератор
    a |= a;
    if (a == 0) {
        push_pop(bc, hl) {
            ordos_sdma(hl = vboxFL);
            b = 0;
            do {
                a = 'A';
                a += b;
                ordos_wnd(); // A = Disk
                ordos_pscf();
                c = a;
                b++;
                if ((a = b) == 4) {
                    c = 1;
                }
            } while ((a = c) == 0);
            if ((a = c) == 0xFF) {
                loadVBOX();
            }
        }
    }
}

/// Загрузка
void loadVBOX() {
    ordos_rfile();
    startVboxAddr = hl;
}

void vboxOpen() {
    a |= vboxOPN;
    vboxCall();
}

void vboxClose() {
    push_pop(a) {
        a = vboxERA;
        a |= vboxUMP;
        vboxCall();
    }
}

void vboxCall() {
    push_pop(a) {
        push_pop(bc) {
            push_pop(de) {
                push_pop(hl) {
                    ordos_rnd();
                    push_pop(a) {
                        validVBOX();
                    }
                    ordos_wnd();
                }
            }
        }
    }
    a |= 0x03; //0x03; //0x01; //ADD disk
    goToVBOX();
}

uint8_t vboxFL[] = "VBOX "; // Имя файла
uint16_t vboxAddr = 0xF000;

#endif /* VBOXFunctions_h */
