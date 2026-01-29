//
//  ButtonShadowViewFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 23.01.2026.
//

#ifndef ButtonShadowViewFunctions_h
#define ButtonShadowViewFunctions_h

/// H - x, L - y
/// D - dx, E - dy
/// BC - text
void ButtonShadowViewShow() {
    push_pop(hl) {
        h = b;
        l = c;
        ButtonShadowViewTitlePoint = hl;
    }
    //- SAVE -
    a = h;
    ButtonShadowViewX = a;
    //printHexA(a = ButtonShadowViewX);
    a = l;
    ButtonShadowViewY = a;
    //printHexA(a = ButtonShadowViewY);
    a = d;
    ButtonShadowViewDX = a;
    //printHexA(a = ButtonShadowViewDX);
    a = e;
    ButtonShadowViewDY = a;
    //printHexA(a = ButtonShadowViewDY);
    //--
    a = ButtonShadowViewColor;
    c = a;
    a = vboxCLW;
    a |= vboxFRM;
    a |= vboxSDW;
    a |= vboxUMP;
    vboxOpenHLDECA();
    //
    ButtonShadowViewShowTitleBC();
}

/// Закраска кнопки
/// 0 - прямой
/// 1 - инверсный
void ButtonShadowViewSelectA() {
    push_pop(bc, de, hl) {
        b = a;
        a = ButtonShadowViewX;
        h = a;
        a = ButtonShadowViewY;
        l = a;
        a = ButtonShadowViewDX;
        d = a;
        a = ButtonShadowViewDY;
        e = a;
        //--------
        if ((a = b) == 0) {
            a = ButtonShadowViewColor;
        } else {
            a = ButtonShadowViewInvColor;
        }
        c = a;
        //----
        a = vboxFRM;
        a |= vboxUMP;
        vboxOpenHLDECA();
    }
}

void ButtonShadowViewShowTitleBC() {
    push_pop(hl, de, bc) {
        hl = ButtonShadowViewTitlePoint;
        b = 0;
        a = ButtonShadowViewDX;
        c = a;
        do {
            a = *hl;
            d = a;
            hl++;
            if (a > 0) {
                b++;
            }
            if ((a = b) >= c) {
                d = 0;
            }
        } while ((a = d) > 0);
        a = ButtonShadowViewDX;
        a -= b;
        a &= 0xFE;
        cyclic_rotate_right(a, 1);
        b = a;
        a = ButtonShadowViewX;
        a += b;
        myCharPosX = a;
        a = ButtonShadowViewY;
        a += 1;
        myCharPosY = a;
        printMyHLStr(hl = ButtonShadowViewTitlePoint);
    }
}

uint8_t ButtonShadowViewX = 0;
uint8_t ButtonShadowViewY = 0;
uint8_t ButtonShadowViewDX = 0;
uint8_t ButtonShadowViewDY = 0;

uint8_t ButtonShadowViewColor = 0xF7;
uint8_t ButtonShadowViewInvColor = 0xE2; //0xE6

uint16_t ButtonShadowViewTitlePoint = 0x0000;

#endif /* ButtonShadowViewFunctions_h */
