//
//  KeyboardFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 26.01.2026.
//

#ifndef KeyboardFunctions_h
#define KeyboardFunctions_h

void convertKeyToMyFontA() {
    push_pop(bc) {
        b = a;
        c = a;
        if ((a = keyRusAddress) == 0) { //0 лат
            // Меняем заглавные на маленькие
            if ((a = b) >= 0x41) {
                if ((a = b) < 0x5B) {
                    a = b;
                    a += 0x20;
                    c = a;
                }
            }
            // Меняем маленькие на заглавные
            if ((a = b) >= 0x61) {
                if ((a = b) < 0x7B) {
                    a = b;
                    a -= 0x20;
                    c = a;
                }
            }
        } else if ((a = keyRusAddress) == 0xFF) { // rus
            // Меняем заглавные английские на заглавные русские
            if ((a = b) >= 0x41) {
                if ((a = b) < 0x5B) {
                    a = b;
                    a += 0x3F;
                    c = a;
                    KeyboardConverRusCharC(a = 1);
                }
            }
            // Меняем маленькие английские на маленькие русские
            if ((a = b) >= 0x61) {
                if ((a = b) < 0x7B) {
                    a = b;
                    a += 0x3F;
                    c = a;
                    //
                    KeyboardConverRusCharC(a = 0);
                    // если больше "п" то + 30
                    if ((a = c) >= 0xB0) {
                        a = c;
                        a += 0x30;
                        c = a;
                    }
                }
            }
            // Ю
            d = 0x40;
            e = 0x60;
            KeyboardBOrDOrE();
            if (a == 1) {
                a = b;
                a += 0x5E;
                c = a;
            }
            // Э
            d = 0x5C;
            e = 0x7C;
            KeyboardBOrDOrE();
            if (a == 1) {
                a = b;
                a += 0x41;
                c = a;
            }
            // Ч
            d = 0x5E;
            e = 0x7E;
            KeyboardBOrDOrE();
            if (a == 1) {
                a = b;
                a += 0x39;
                c = a;
            }
            // Ш
            d = 0x5B;
            e = 0x7B;
            KeyboardBOrDOrE();
            if (a == 1) {
                a = b;
                a += 0x3D;
                c = a;
            }
            // Щ
            d = 0x5D;
            e = 0x7D;
            KeyboardBOrDOrE();
            if (a == 1) {
                a = b;
                a += 0x3C;
                c = a;
            }
            if ((a = c) >= 0xB0) {
                if ((a = c) < 0xC0) {
                    a = c;
                    a += 0x30;
                    c = a;
                }
            }
        } else {
            
        }
        a = c;
    }
}

void KeyboardBOrDOrE() {
    push_pop(hl) {
        if ((a = b) == d) {
            h = 1;
        } else if ((a = b) == e) {
            h = 1;
        } else {
            h = 0;
        }
        a = h;
    }
}

/// A - 0 происная, 1 - заглавная
/// C - Символ
void KeyboardConverRusCharC() {
    push_pop(hl, de) {
        if (a == 0) {
            a = c;
            a -= 0xA0;
            e = a;
        } else {
            a = c;
            a -= 0x80;
            e = a;
        }
        d = 0;
        hl = KeyboardRusCharConver;
        hl += de;
        a = *hl;
        a += c;
        c = a;
    }
}

uint8_t KeyboardRusCharConver[32] = {
    // А     Б     В     Г     Д     Е     Ж     З     И     Й     К     Л     М     Н     О     П
    0x00, 0x00, 0x14, 0x01, 0x01, 0x0F, 0xFD, 0x0E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    // Р     С     Т     У     Ф     Х     Ц     Ч     Ш     Щ     Ъ     Ы     Ь     Э     Ю     Я
    0x0F, 0xFF, 0xFF, 0xFF, 0xFF, 0xF1, 0xEC, 0x05, 0x03, 0xED, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
};

#endif /* KeyboardFunctions_h */
