//
//  main.c
//  VBOX-TEST
//
//  Created by Алексей Химунин on 15.01.2026.
//

#include <cmm.h>
#include "Include.h"

extern uint16_t startVboxAddr;

extern uint8_t strOK[3];
extern uint8_t strWarning[9];
extern uint8_t strUtf8[20];
extern uint8_t strError[7];

void goToVBOX() __address(0x0106);

void mainStart();
void KeyboardEventA();

asm{
    org 0x00F0
}

///App Name
uint8_t appName[] = {'K','F','T','P','-','C','$',' '};

asm{
    //Start
    DB 0x00, 0x01
    //Len
    DB 0x00, 0x32
    //Reserved
    DB 0x00, 0x00, 0x00, 0x00
}

void main(){
    sp = 0x6FFF;
//    nop();
//    nop();
//    nop();
    mainStart();
}

///Exec VBOX
uint8_t jmpToVBOX = 0xc3;
uint16_t startVboxAddr = 0x0000;

void mainStart() {
    hl = 0;
    setPosCursor();
    a = 0;
    NetIsLock = a;
    
    initI2C();
    vboxClearCash();
    
    HelpViewShow();
    FtpStateViewShow();
    WifiStateViewShow();
    FtpViewShow();
    DiskViewShow();
    
    CurrentViewChangeIdA(a = FtpViewId);
    
    #ifdef _IS_SIMULATOR

    #else
        NetUpdateData();
        ThreadsTickNow();
    #endif
    
    for(;;) {
        //ThreadsTick();
        #ifdef _IS_SIMULATOR
            getKeyboardCharA();
            KeyboardEventA();
        #else
            getKeyboardStateA();
            if (a == 0xFF) {
                getKeyboardCodeA();
                KeyboardEventA();
            } else {
                ThreadsTick();
            }
        #endif
    }

}

void KeyboardEventA() {
    push_pop(bc) {
        b = a; //Save
        if ((a = b) == 0x03) { //F4
            vboxClearCash();
            ordos_start();
        } else if ((a = b) == 0x02) { //F3 Open FTP settings
            CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
            if (a == 1) {
                FtpSettingsViewShow();
            }
        } else if ((a = b) == 0x01) { //F2 Open WiFi settings
            CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
            if (a == 1) {
                WiFiSettingsViewShow();
            }
        }
        
        c = 0;
        if ((a = CurrentViewId) == DiskViewId) {
            DiskViewKeyA(a = b);
            c = 1;
        } else if ((a = CurrentViewId) == FtpViewId) {
            FtpViewKeyA(a = b);
            c = 1;
        } else if ((a = CurrentViewId) == SelectDiskViewId) {
            SelectDiskViewKeyA(a = b);
            c = 1;
        } else if ((a = CurrentViewId) == WiFiSettingsViewId) {
            WiFiSettingsViewKeyA(a = b);
            c = 1;
        } else if ((a = CurrentViewId) == WiFiNetworksViewId) {
            WiFiNetworksViewKeyA(a = b);
            c = 1;
        } else if ((a = CurrentViewId) == FtpSettingsViewId) {
            FtpSettingsViewKeyA(a = b);
            c = 1;
        }
    }
}

#include "Functions.h"

uint8_t strOK[] = "Ok";
uint8_t strError[] = "Error!";
uint8_t strWarning[] = "Warning!";
uint8_t strUtf8[] = {0xd0 ,0x9f ,0xd1 ,0x80 ,0xd0 ,0xb8 ,0xd0 ,0xb2 ,0xd0 ,0xb5 ,0xd1 ,0x82 ,0x20 ,0xd0 ,0x9c ,0xd0 ,0xb8 ,0xd1 ,0x80 , 0x00}; //"Привет Мир!"
//echo "Привет Мир" | xxd -p | sed 's/\(..\)/0x&, /g; s/, $//;'

asm(" savebin \"test.ORD\", 0x00f0, 0x3210");
