//
//  HelpViewFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef HelpViewFunctions_h
#define HelpViewFunctions_h

void HelpViewShow() {
    a = HelpViewX;
    h = a;
    a = HelpViewY;
    l = a;
    a = HelpViewDX;
    d = a;
    a = HelpViewDY;
    e = a;
    a = HelpViewColor;
    vboxOpenHLDE();
    HelpViewShowStr();
}

void HelpViewShowStr() {
    a = HelpViewX;
    a++;
    myCharPosX = a;
    a = HelpViewY;
    a++;
    myCharPosY = a;
    printMyHLStr(hl = HelpViewTitleF1);
    
    myCharPosXSpaceA(a = 5);
    printMyHLStr(hl = HelpViewTitleF2);
    
    myCharPosXSpaceA(a = 5);
    printMyHLStr(hl = HelpViewTitleF3);
    
    myCharPosXSpaceA(a = 5);
    printMyHLStr(hl = HelpViewTitleF4);
}

uint8_t HelpViewX = 0;
uint8_t HelpViewY = 29;
uint8_t HelpViewDX = 48;
uint8_t HelpViewDY = 3;
#ifdef _IS_STATUSBAR_BW
    uint8_t HelpViewColor = 0x07;
#else
    uint8_t HelpViewColor = 0x5f; //0x67;
#endif

uint8_t HelpViewTitleF1[] = "F1: ..";
uint8_t HelpViewTitleF2[] = "F2: Wi-Fi";
uint8_t HelpViewTitleF3[] = "F3: FTP ";
uint8_t HelpViewTitleF4[] = "F4: Quit";

#endif /* HelpViewFunctions_h */
