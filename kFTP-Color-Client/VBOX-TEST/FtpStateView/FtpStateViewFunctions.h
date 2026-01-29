//
//  FtpStateViewFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef FtpStateViewFunctions_h
#define FtpStateViewFunctions_h

void FtpStateViewShow() {
    push_pop(hl, de) {
        a = FtpStateViewX;
        h = a;
        a = FtpStateViewY;
        l = a;
        a = FtpStateViewDX;
        d = a;
        a = FtpStateViewDY;
        e = a;
        a = FtpStateViewColor;
        vboxOpenHLDE();
        vboxBorderHLDE();
        FtpStateViewShowTitle();
        FtpStateViewShowValue();
    }
}

void FtpStateViewShowTitle() {
    push_pop(hl, bc) {
        // TITLE
        a = FtpStateViewX;
        b = a;
        a = FtpStateViewDX;
        a += b;
        a -= 6; //len Title
        myCharPosX = a;
        a = FtpStateViewY;
        myCharPosY = a;
        printMyHLStr(hl = FtpViewTitle);
        // IP
        a = FtpStateViewX;
        a += 1;
        myCharPosX = a;
        a = FtpStateViewY;
        a += 1;
        myCharPosY = a;
        printMyHLStr(hl = FtpStateViewIpTitle);
        // STATUS
        a = FtpStateViewX;
        a += 1;
        myCharPosX = a;
        a = FtpStateViewY;
        a += 2;
        myCharPosY = a;
        printMyHLStr(hl = FtpStateViewStateTitle);
    }
}

void FtpStateViewShowValue() {
    push_pop(hl) {
        //IP
        a = FtpStateViewX;
        a += 5;
        myCharPosX = a;
        a = FtpStateViewY;
        a += 1;
        myCharPosY = a;
        a = 16;
        printMyHLStrLenA(hl = FtpStateViewIpValue);
        // STATUS
        FtpStateViewShowStatus();
    }
}

void FtpStateViewShowStatus() {
    push_pop(hl, bc, de) {
        if ((a = FtpStateViewStatus) == 0) {
            hl = FtpStateViewStatus0;
            a = FtpStateViewColor;
            c = a;
        } else {
            hl = FtpStateViewStatus1;
            a = FtpStateViewConnectColor;
            c = a;
        }
        a = FtpStateViewX;
        a += 9;
        d = a; // X
        myCharPosX = a;
        a = FtpStateViewY;
        a += 2;
        e = a; // Y
        myCharPosY = a;
        printMyHLStrLenA(a = 14);
        //COLOR BOX
        h = d;
        l = e;
        d = 14;
        e = 1;        
        a = 0;
        vboxOpenHLDECA();
    }
}

uint8_t FtpStateViewX = 0;
uint8_t FtpStateViewY = 0;
uint8_t FtpStateViewDX = 24;
uint8_t FtpStateViewDY = 4;
#ifdef _IS_STATUSBAR_BW
    uint8_t FtpStateViewColor = 0x07; //0x5f; //0x67; 07
    uint8_t FtpStateViewConnectColor = 0x02; //0x52;
#else
    uint8_t FtpStateViewColor = 0x5f; //0x67; 07
    uint8_t FtpStateViewConnectColor = 0x52;
#endif

uint8_t FtpStateViewIpTitle[] =    "IP:";
uint8_t FtpStateViewStateTitle[] = "Status:";
uint8_t FtpStateViewIpValue[16] = "0.0.0.0";

uint8_t FtpStateViewStatus = 0;
uint8_t FtpStateViewStatus0[] = "DISCONNECT"; //a = 14
uint8_t FtpStateViewStatus1[] = "CONNECT"; //a = 14

#endif /* FtpStateViewFunctions_h */
