//
//  MyFontFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef MyFontFunctions_h
#define MyFontFunctions_h

void printMyHexA() {
    push_pop(bc) {
        b = a;
        a &= 0xF0;
        cyclic_rotate_right(a, 4);
        if (a < 10) {
            a += 0x30;
        } else {
            a += 0x37;
        }
        printMyChatA();
        a = b;
        a &= 0x0F;
        if (a < 10) {
            a += 0x30;
        } else {
            a += 0x37;
        }
        printMyChatA();
    }
}

void printMyUTF8HLStr() {
    do {
        a = *hl;
        if (a == 0xD0) {
            hl++;
            a = *hl;
            a += 0xF0;
        } else if (a == 0xD1) {
            hl++;
            a = *hl;
            a += 0x60;
        }
        if (a > 0 ) {
            printMyChatA();
        }
        //
        a = *hl;
        hl++;
    } while (a > 0);
}

void printMyHLStr() {
    do {
        a = *hl;
        if (a > 0) {
            printMyChatA();
        }
        a = *hl;
        hl++;
    } while (a > 0);
}

/// Выводит строку из HL с текущего положения
/// Длиной A. Если текст короче , то добиват до A пробелами
void printMyHLStrLenA() {
    push_pop(bc) {
        b = a;
        c = 0;
        do {
            a = *hl;
            if (a > 0) {
                c++;
                printMyChatA();
            }
            a = *hl;
            hl++;
        } while (a > 0);
        if ((a = c) < b) {
            a = b;
            a -= c;
            b = a;
            do {
                printMyChatA(a = ' ');
                b--;
            } while ((a = b) > 0);
        }
    }
}

/// Выводит строку из HL с текущего положения заменяя все символы *
/// Длиной A. Если текст короче , то добиват до A пробелами
void printMyHLPassLenA() {
    push_pop(bc) {
        b = a;
        c = 0;
        do {
            a = *hl;
            if (a > 0) {
                c++;
                printMyChatA(a = '*');
            }
            a = *hl;
            hl++;
        } while (a > 0);
        if ((a = c) < b) {
            a = b;
            a -= c;
            b = a;
            do {
                printMyChatA(a = ' ');
                b--;
            } while ((a = b) > 0);
        }
    }
}

void printMyChatA() {
    push_pop(hl, bc, de) {
        // Char POS
        hl = FONT_8_8_RUS;
        cyclic_rotate_left(a, 3);
        b = a;
        a &= 0x07;
        a += h;
        h = a;
        a = b;
        a &= 0xF8;
        a += l;
        if (flag_c) {
            h++;
        }
        l = a;
        // Video POS
        //de = 0xC000;
        a = myCharPosY;
        a &= 0x1F;
        cyclic_rotate_left(a, 3);
        e = a;
        a = myCharPosX;
        a += 0xC0;
        d = a;
        //
        b = 8;
        do {
            a = *hl;
            *de = a;
            hl++;
            de++;
            b--;
        } while ((a = b) > 0);
        // Inc POS
        a = myCharPosX;
        a++;
        if (a >= 0x30) { //0x2F
            a = 0;
            b = a;
            // Inc Y
            a = myCharPosY;
            a++;
            if (a >= 0x20) { //0x1F
                a = 0;
            }
            myCharPosY = a;
            //
            a = b;
        }
        myCharPosX = a;
    }
}

void myCharPosXSpaceA(){
    push_pop(bc) {
        b = a;
        a = myCharPosX;
        a += b;
        myCharPosX = a;
    }
}

void myCharPosYSpaceA(){
    push_pop(bc) {
        b = a;
        a = myCharPosY;
        a += b;
        myCharPosY = a;
    }
}

/// Вывести на экран значение A как десятичное число
/// A не больше 99 или 0x63
/// Если больше - ничего не выводит
void printMyAsDec99A() {
    if (a < 0x64) {
        push_pop(bc, de) {
            b = a;
            c = a;
            d = 0;
            e = 10;
            if ((a = b) < e) {
                printMyChatA(a = ' ');
                a = b;
                a += '0';
                printMyChatA();
            } else {
                do {
                    a = b;
                    a -= e;
                    b = a;
                    d++;
                } while ((a = b) >= e);
                a = d;
                a += '0';
                printMyChatA();
                a = b;
                a += '0';
                printMyChatA();
            }
        }
    }
}

/// Вывести на экран значение A как десятичное число с ведущими нулями
/// A не больше 99 или 0x63
/// Если больше - ничего не выводит
void printMyAs00Dec99A() {
    if (a < 0x64) {
        push_pop(bc, de) {
            b = a;
            c = a;
            d = 0;
            e = 10;
            if ((a = b) < e) {
                printMyChatA(a = '0');
                a = b;
                a += '0';
                printMyChatA();
            } else {
                do {
                    a = b;
                    a -= e;
                    b = a;
                    d++;
                } while ((a = b) >= e);
                a = d;
                a += '0';
                printMyChatA();
                a = b;
                a += '0';
                printMyChatA();
            }
        }
    }
}

/// Вывести на экран значение HL как десятичное число
/// A не больше 4095 или 0x0FFF
/// Если больше - ничего не выводит
void printMyAsDec4095HL() {
    push_pop(bc, de) {
        de = 0x0FFF;
        compareHlDe();
        if (flag_nc) {
            c = 0; // Признак ведущего нуля (0 - ставить " ", а не 0)
            //1000
            de = 0x03E8;
            compareHlDe();
            if (flag_c) {
                b = 0;
                do {
                    de = 0xFC18;
                    hl += de;
                    b++;
                    de = 0x03E8;
                    compareHlDe();
                } while (flag_c);
                a = b;
                a += '0';
                printMyChatA();
                c = 1;
            } else {
                printMyChatA(a = ' ');
            }
            //0100
            de = 0x0064;
            compareHlDe();
            if (flag_c) {
                b = 0;
                do {
                    de = 0xFF9C;
                    hl += de;
                    b++;
                    de = 0x0064;
                    compareHlDe();
                } while (flag_c);
                a = b;
                a += '0';
                printMyChatA();
                c = 1;
            } else {
                if ((a = c) == 0) {
                    printMyChatA(a = ' ');
                } else {
                    printMyChatA(a = '0');
                }
            }
            //0010
//            de = 0x000A;
//            compareHlDe();
//            if (flag_c) {
//                b = 0;
//                do {
//                    de = 0xFFF6;
//                    hl += de;
//                    b++;
//                    de = 0x000A;
//                    compareHlDe();
//                } while (flag_c);
//                a = b;
//                a += '0';
//                printMyChatA();
//            } else {
//                printMyChatA(a = '0');
//            }
            a = l;
            if ((a = l) >= 10) {
                b = 0;
                do {
                    a = l;
                    a -= 10;
                    l = a;
                    b++;
                } while ((a = l) >= 10);
                a = b;
                a += '0';
                printMyChatA();
                c = 1;
            } else {
                if ((a = c) == 0) {
                    printMyChatA(a = ' ');
                } else {
                    printMyChatA(a = '0');
                }
            }
            //0001
            a = l;
            a += '0';
            printMyChatA();
        }
    }
}

/// Спавнение HL и DE
/// CF=1 when DE < HL
/// CF=0 DE >= HL
void compareHlDe() {
    a = d;
    a ^= h;
    if (flag_p) {
    } else {
        a ^= d;
        if (flag_m) {
            return;
        }
        set_flag_c();
        return;
    }
    a = e;
    a -= l; //0x95
    a = d;
    //a -= h; //0x9C
    //asm{ SBB h };
    carry_sub(a, h);
    return;
}

uint8_t myCharPosX = 0;
uint8_t myCharPosY = 0;

#endif /* MyFontFunctions_h */
