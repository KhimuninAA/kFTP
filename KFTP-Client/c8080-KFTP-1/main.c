//
//  main.c
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 16.09.2025.
//

#include <cmm.h>
#include "ORDOS.h"
#include "Monitor.h"
#include "ExternParams.h"
#include "DeclareFunctions.h"

#define _DEBUG

asm{
    org 0x00F0
}

///App Name
uint8_t appName[] = {'K','F','T','P','$',' ',' ',' '};

asm{
    //Start
    DB 0x00, 0x01
    //Len
    DB 0x00, 0x20
    //Reserved
    DB 0x00, 0x00, 0x00, 0x00
}

void main(){
    updateDiskList();
    initI2C();
    ///
    
    /// WiFI
    //delay5msI2C(); delay5msI2C();
    getSSIDValue();
    //delay5msI2C(); delay5msI2C();
    getSSIDPasswordValue();
    
    /// FTP
    //delay5msI2C(); delay5msI2C();
    getFTPUrl();
    //delay5msI2C(); delay5msI2C();
    getFTPUser();
    //delay5msI2C(); delay5msI2C();
    getFTPPassword();
    //delay5msI2C(); delay5msI2C();
    getFTPPort();
    getFtpCurrentPath();
    
    ///
    updateRootUI();
    
    updateRootDataUI();
    
    //Бесконечный цикл. Что бы увидеть результат
    for (;;) {
        getKeyboardStateA();
        if (a == 0xFF) {
            // Если клавиша нажата - вызываем обработчик
            keyboardEvent();
        } else {
            a = rootTimerTike;
            if (a >= 240) {
                a = 0;
                rootTimerTike = a;
                if ((a = rootViewCurrentView) == rootViewCurrentDiskView) {
                    updateWiFiStatus();
                    updateFtpStatus();
                }
            } else {
                a++;
                rootTimerTike = a;
            }
        }
    }
}

void keyboardEvent() {
    getKeyboardCodeA();
    l = a; //Save key
    if ((a = rootViewOldKey) != l) {
        a = l; //Load key
        rootViewOldKey = a;
        push_pop(hl) {
            a = l; //Load key
            if (a != 0xFF) {
                /// Hot ley
                if (a == 0x03) { //F4 quit ordos
                    ordos_start();
                } else if (a == 0x02) { //F3 Open FTP settings
                    needOpenFTPSettingsEditView();
                } else if (a == 0x01) { //F2 Open WiFi settings
                    needOpenWiFiSettingsEditView();
                }
                
                /// View's
                if ((a = rootViewCurrentView) == rootViewCurrentDiskView) { // Local disk
                    a = l; //Load key
                    diskViewKeyA();
                    showDiskList(); //Refresh
                } else if ((a = rootViewCurrentView) == rootViewCurrentFTPView) { // FTP Dir
                    a = l; //Load key
                    ftpViewKeyA();
                    ftpViewDataUpdate();
                } else if ((a = rootViewCurrentView) == rootViewCurrentFTPSettingsEditView) {
                    a = l; //Load key
                    ftpSettingsEditViewKeyA();
                    ftpSettingsEditViewDataUpdate();
                } else if ((a = rootViewCurrentView) == rootViewCurrentWiFiSettingsEditView) {
                    a = l; //Load key
                    wifiSettingsEditViewKeyA();
                    wifiSettingsEditViewDataUpdate();
                } else if ((a = rootViewCurrentView) == rootSSIDListView) {
                    a = l; //Load key
                    SSIDListViewKeyA();
                    SSIDListViewDataUpdate();
                }
                //printHexA();
            }
        }
    }
}

void updateRootDataUI() {
    showDiskList();
}

void updateRootUI() {
    a = 0x00;
    inverceAddress = a;
    clearScreen();
    
    a = 0x00;
    inverceAddress = a;
    showWiFiView();
    a = 0x00;
    inverceAddress = a;
    showFtpView();
    a = 0x00;
    inverceAddress = a;
    diskView();
    a = 0x00;
    inverceAddress = a;
    ftpView();
    
    showHelpStr();
}

void ftpView() {
    drowRectX = (a = ftpViewX);
    drowRectY = (a = ftpViewY);
    drowRectEndX = (a = ftpViewEX);
    drowRectEndY = (a = ftpViewEY);
    drowRect();
    
    hl = ftpLabelPos;
    setPosCursor();
    hl = ftpLabel;
    printHLStr();
    
    updateCurrentPath();
}

void diskView() {
    drowRectX = (a = diskViewX);
    drowRectY = (a = diskViewY);
    drowRectEndX = (a = diskViewEX);
    drowRectEndY = (a = diskViewEY);
    drowRect();
    
    hl = diskViewLabelPos;
    setPosCursor();
    hl = diskViewLabel;
    printHLStr();
}

void showWiFiView() {
    drowRectX = (a = wifiSettingsViewX);
    drowRectY = (a = wifiSettingsViewY);
    drowRectEndX = (a = wifiSettingsViewEX);
    drowRectEndY = (a = wifiSettingsViewEY);
    drowRect();
    
    hl = wifiSettingsPos;
    setPosCursor();
    hl = wifiSettingsLabel;
    printHLStr();
    
    hl = wifiSettingsSsidLabelPos;
    setPosCursor();
    hl = wifiSettingsSsidLabel;
    printHLStr();
    
    hl = wifiSettingsIpLabelPos;
    setPosCursor();
    hl = wifiSettingsIpLabel;
    printHLStr();
    
    hl = wifiSettingsMacLabelPos;
    setPosCursor();
    hl = wifiSettingsMacLabel;
    printHLStr();
    
    hl = wifiSettingsSsidValPos;
    setPosCursor();
    hl = wifiSettingsSsidVal;
    printHLStr();
    
    updateWiFiViewValData();
}

void clearWiFiViewValData() {
    hl = wifiSettingsIpValPos;
    setPosCursor();
    hl = wifiSettingsEmpty18;
    printHLStr();
    
    hl = wifiSettingsMacValPos;
    setPosCursor();
    hl = wifiSettingsEmpty18;
    printHLStr();
}

void updateWiFiViewValData() {
    hl = wifiSettingsIpValPos;
    setPosCursor();
    hl = wifiSettingsIpVal;
    printHLStr();
    
    hl = wifiSettingsMacValPos;
    setPosCursor();
    hl = wifiSettingsMacVal;
    printHLStr();
}

void clearScreen() {
    c = 0x1B;
    printChatC();
    c = 0x45;
    printChatC();
}

void drowRect() {
    setMyFont();
    
    //h = y
    a = drowRectY;
    h = a;
    
    do {
        //l = x
        a = drowRectX;
        l = a;
        
        push_pop(hl) {
            setPosCursor();
        }
        
        do {
            if ((a = drowRectY) == h) {
                c = 0x26;
                if ((a = drowRectX) == l) {
                    c = 0x21;
                }
                if ((a = drowRectEndX)-- == l) {
                    c = 0x23;
                }
            } else if ((a = drowRectEndY)-- == h) {
                c = 0x26;
                if ((a = drowRectX) == l) {
                    c = 0x22;
                }
                if ((a = drowRectEndX)-- == l) {
                    c = 0x24;
                }
            } else {
                c = 0x20;
                if ((a = drowRectX) == l) {
                    c = 0x25;
                }
                if ((a = drowRectEndX)-- == l) {
                    c = 0x25;
                }
            }
            
            push_pop(hl) {
                printChatC();
            }
            
            a = drowRectEndX;
            l++;
            a -= l;
        } while (flag_nz);
        
        a = drowRectEndY;
        h++;
        a -= h;
    } while (flag_nz);
    
    setSystemFont();
}

void setMyFont() {
    push_pop(hl) {
        hl = fontAddress;
        systemFontAddress = hl;
        hl = &myFont;
        fontAddress = hl;
    }
}

void setSystemFont() {
    push_pop(hl) {
        hl = systemFontAddress;
        fontAddress = hl;
    }
}

uint8_t drowRectX = 0x00;
uint8_t drowRectY = 0x00;
uint8_t drowRectEndX = 0x00;
uint8_t drowRectEndY = 0x00;

uint16_t systemFontAddress = 0x0000;

void updateDiskList() {
    a = diskViewDiskNum;
    ordos_wnd();
    hl = startListBufer;
    ordos_dirm();
    diskViewListCount = a;
}

void showDiskList() {
    b = 0;
    showDiskDriveName();
    showDiskDir();
    hl = diskViewListNamePos;
    
    if ((a = diskViewListCount) == 0) {
        return;
    }
    
    do {
        setPosCursor();
        a = b;
        push_pop(hl) {
            showDiskApp();
        };
        
        h++;
        b++;
        a = diskViewListCount;
        a -= b;
    } while (flag_nz);
}

void showDiskDriveName() {
    push_pop(hl) {
        hl = diskViewDriveNamePos;
        setPosCursor();
        a = diskViewDiskNum;
        printChatA();
    }
}

void showDiskDir() {
    push_pop(hl) {
        hl = diskViewListDirPos;
        setPosCursor();
        hl = diskViewListDirLabel;
        push_pop(bc) {
            a = 0;
            inverceAddress = a;
            if ((a = diskViewCurrPos) == 0) {
                if ((a = rootViewCurrentView) == rootViewCurrentDiskView) {
                    a = 0xFF;
                    inverceAddress = a;
                }
            }
            printHLStr();
            a = 0;
            inverceAddress = a;
        }
    }
}

///A - count app
void showDiskApp() {
    push_pop(bc) {
        
        c = a;
        carry_rotate_left(a, 4);
        hl = startListBufer;
        a += l;
        l = a;
        if (flag_c) {
            h++;
        }
        
        a = 0x00;
        inverceAddress = a;
        
        if ((a = diskViewCurrPos)-- == c) {
            if ((a = rootViewCurrentView) == rootViewCurrentDiskView) {
                a = 0xFF;
                inverceAddress = a;
            }
        }
    
        a = ' ';
        printChatA();
        b = 0;
        
        do {
            a = *hl;
            printChatA();
            hl++;
            b++;
            a = 8;
            a -= b;
        } while (flag_nz);
        a = ' ';
        printChatA();
    };
    a = 0x00;
    inverceAddress = a;
}

void diskViewKeyA() {
    push_pop(bc) {
        b = a;
        
        if (a == 0x1A) { //down
            a = diskViewListCount;
            c = a;
            if ( (a = diskViewCurrPos) < c  ) {
                a++;
                diskViewCurrPos = a;
            }
        } else if (a == 0x19) { //up
            if ( (a = diskViewCurrPos) > 0 ) {
                a--;
                diskViewCurrPos = a;
            }
        } else if (a == 0x0D) { //Enter
            if ((a = diskViewCurrPos) == 0) { // Change drive
                a = diskViewDiskNum;
                if (a == 'B') {
                    a = 'C';
                } else if (a == 'C') {
                    a = 'D';
                } else if (a == 'D') {
                    a = 'B';
                }
                diskViewDiskNum = a;
                diskView();
                updateDiskList();
            } else { // Upload file to FTP
                
            }
        } else if (a == 0x09) { //TAB
            a = rootViewCurrentFTPView; // переходим на список файлов FTP
            rootViewCurrentView = a;
            // Сбросить выделение строки на диске
            showDiskList();
            // Выделить текущую позицию на FTP
            ftpViewDataUpdate();
        }
    }
}

void showHelpStr() {
    push_pop(hl) {
        hl = rootViewHelpStrPos;
        setPosCursor();
        hl = rootViewHelpStr;
        printHLStr();
    }
}

void showFtpSettingsEditView() {
    drowRectX = (a = ftpSettingsEditViewX);
    drowRectY = (a = ftpSettingsEditViewY);
    drowRectEndX = (a = ftpSettingsEditViewEX);
    drowRectEndY = (a = ftpSettingsEditViewEY);
    drowRect();
    
    hl = ftpSettingsEditViewLabelPos;
    setPosCursor();
    hl = ftpSettingsEditViewLabel;
    printHLStr();
    
    hl = ftpSettingsEditViewIpLabelPos;
    setPosCursor();
    hl = ftpSettingsIpLabel;
    printHLStr();
    
    hl = ftpSettingsEditViewPortLabelPos;
    setPosCursor();
    hl = ftpSettingsPortLabel;
    printHLStr();
    
    hl = ftpSettingsEditViewUserLabelPos;
    setPosCursor();
    hl = ftpSettingsUserLabel;
    printHLStr();
    
    hl = ftpSettingsEditViewPasswordLabelPos;
    setPosCursor();
    hl = ftpSettingsEditViewPasswordLabel;
    printHLStr();
    
    hl = ftpSettingsEditViewOkLabelPos;
    setPosCursor();
    hl = ftpSettingsEditViewOkLabel;
    printHLStr();
}

void needOpenFTPSettingsEditView() {
    push_pop(hl) {
        if ((a = rootViewCurrentView) != rootViewCurrentFTPSettingsEditView) { //Если уже открыты настройки - не открываем
            if ((a = rootViewCurrentView) != rootViewCurrentWiFiSettingsEditView) { //Если открыта настройка WiFi тоже не открываем
                
                a = rootViewCurrentFTPSettingsEditView;
                rootViewCurrentView = a;
                a = 4;
                ftpSettingsEditViewCurrentPos = a;
                
                showDiskList(); //Сбросить выделение строки
                showFtpSettingsEditView();
                ftpSettingsEditViewDataUpdate();
            }
        }
    }
}

void ftpSettingsEditViewSelectEditField() {
    a = ftpSettingsEditViewCurrentPos;
    if (a == 0) {
        hl = ftpSettingsEditViewIpValPos;
        ftpSettingsEditViewEditValuePos = hl;
        setPosCursor();
        
        push_pop(hl) {
            hl = ftpSettingsIpValue;
            ftpSettingsEditView_CopyStrFromHL();
        }
    } else if (a == 1) {
        hl = ftpSettingsEditViewPortValPos;
        ftpSettingsEditViewEditValuePos = hl;
        setPosCursor();
        
        push_pop(hl) {
            hl = ftpSettingsPortValue;
            ftpSettingsEditView_CopyStrFromHL();
        }
    } else if (a == 2) {
        hl = ftpSettingsEditViewUserValPos;
        ftpSettingsEditViewEditValuePos = hl;
        setPosCursor();
        
        push_pop(hl) {
            hl = ftpSettingsUserValue;
            ftpSettingsEditView_CopyStrFromHL();
        }
    } else if (a == 3) {
        hl = ftpSettingsEditViewPasswordValPos;
        ftpSettingsEditViewEditValuePos = hl;
        setPosCursor();
        
        push_pop(hl) {
            hl = ftpSettingsEditViewPasswordVal;
            ftpSettingsEditView_CopyStrFromHL();
        }
    }
    ftpSettingsEditViewEditField();
}

void ftpSettingsEditViewSaveEditValueToHL() {
    push_pop(de) {
        push_pop(bc) {
            de = ftpSettingsEditViewEditValue;
            a = ftpSettingsEditViewEditPos;
            c = a;
            b = 0;
            do {
                a = *de;
                *hl = a;
                hl++;
                de++;
                b++;
                a = b;
                a -= c;
            } while (flag_nz);
            *hl = 0;
        }
    }
}

void ftpSettingsEditView_CopyStrFromHL() {
    push_pop(de) {
        push_pop(bc) {
            de = ftpSettingsEditViewEditValue;
            b = 0;
            c = 0;
            do {
                a = *hl;
                *de = a;
                if ((a = b) == 22) {
                    a = 0;
                    *de = a;
                } else if ((a = c) == 1) {
                    a = ' ';
                    *de = a;
                } else if ((a = *de) == 0) {
                    c = 1;
                    a = ' ';
                    *de = a;
                    a = b;
                    ftpSettingsEditViewEditPos = a;
                }
                
                hl ++;
                de++;
                b++;
                a = b;
                a -= 23;
            } while (flag_nz);
        }
    }
}

void ftpSettingsEditViewEditField() {
    hl = ftpSettingsEditViewEditValuePos;
    setPosCursor();
    
    a = 0xFF;
    inverceAddress = a;
    
    hl = ftpSettingsEditViewEditValue;
    printHLStr();
    
    ftpSettingsEditViewSetEditCursor();
    push_pop(bc) {
        b = 0;
        do {
            getKeyboardCharA();
            
            if (a == 0x1B) { // выход из редактирования без сохранения
                b = 1;
            } else if (a == 0x0D) { // Сохранить и выйти из редактирования
                b = 1;
                ftpSettingsEditViewSaveField();
            } else if (a >= 0x20) {
                if (a < 0x7F) { //Ввод символа
                    c = a;
                    // Если достигли предела - то перемещаем курсор на 1 назад
                    a = ftpSettingsEditViewEditPos;
                    if (a >= 15) {
                        a--;
                    }
                    ftpSettingsEditViewEditPos = a;
                    
                    //Сохраняем символ
                    a = c;
                    ftpSettingsEditViewSetValueA();
                    a = ftpSettingsEditViewEditPos;
                    a++;
                    ftpSettingsEditViewEditPos = a;
                    ftpSettingsEditViewSetEditCursor();
                } else if (a == 0x7F) { //Забой... (удаление символа)
                    if ((a = ftpSettingsEditViewEditPos) > 0) {
                        a--;
                        ftpSettingsEditViewEditPos = a;
                        ftpSettingsEditViewSetEditCursor();
                        a = ' ';
                        ftpSettingsEditViewSetValueA();
                    }
                }
            }
            
            a = b;
            a -= 1;
        } while (flag_nz);
    }
    
    a = 0x00;
    inverceAddress = a;
    
    showFtpSettingsEditView();
    ftpSettingsEditViewDataUpdate();
}

void ftpSettingsEditViewSetValueA() {
    push_pop(hl) {
        push_pop(bc) {
            b = a;
            //Сохраним символ в ftpSettingsEditViewEditValue
            hl = ftpSettingsEditViewEditValue;
            a = ftpSettingsEditViewEditPos;
            a += l;
            l = a;
            if (flag_c) {
                h++;
            }
            *hl = b;
            //Отрисуем символ на экране
            ftpSettingsEditViewSetEditCursor();
            a = b;
            printChatA();
            ftpSettingsEditViewSetEditCursor();
        }
    }
}

void ftpSettingsEditViewSetEditCursor() {
    push_pop(hl) {
        hl = ftpSettingsEditViewEditValuePos;
        a = ftpSettingsEditViewEditPos;
        a += l;
        l = a;
        setPosCursor();
    }
}

void ftpSettingsEditViewDataUpdate() {
    if ((a = rootViewCurrentView) != rootViewCurrentFTPSettingsEditView) {
        return;
    }
    
    push_pop(bc) {
        b = 0;
        do {
            a = 0x00;
            inverceAddress = a;
            
            if ((a = ftpSettingsEditViewCurrentPos) == b) {
                a = 0xFF;
                inverceAddress = a;
            }
            
            a = b;
            ftpSettingsEditViewShowValueA();
            
            a = 0x00;
            inverceAddress = a;
            
            b++;
            a = b;
            a -= 5;
        } while (flag_nz);
    }
}

#include "FtpSettingsEditView/FtpSettingsEditViewFunctions.h"
#include "wifiSettingsEditView/wifiSettingsEditViewFunctions.h"
#include "SSIDListView/SSIDListViewFunctions.h"
#include "Locale.h"

asm(" savebin \"test.ORD\", 0x00f0, 0x200f"); //0xBff
