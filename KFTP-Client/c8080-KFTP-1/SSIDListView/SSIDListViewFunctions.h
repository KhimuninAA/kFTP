//
//  SSIDListViewFunctions.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 22.12.2025.
//

#ifndef SSIDListViewFunctions_h
#define SSIDListViewFunctions_h

void SSIDFixBuffer();

void needOpenSSIDListView() {
    push_pop(hl) {
        if ((a = rootViewCurrentView) != rootSSIDListView) { //Если уже открыто окно - не открываем
            a = rootSSIDListView;
            rootViewCurrentView = a;
            
            a = 0;
            SSIDListViewCurrentPos = a;
            
            showSSIDListView();
            SSIDListViewDataUpdate();
        }
    }
}

void SSIDListGetCount() {
    push_pop(hl) {
        push_pop(bc) {
            push_pop(de) {
                a = 0;
                SSIDListCount = a;
                de = 16;
                
                b = 16;
                hl = SSIDList;
                do {
                    a = *hl;
                    if (a > 0) {
                        a = SSIDListCount;
                        a++;
                        SSIDListCount = a;
                    }
                    hl += de;
                    b--;
                } while (flag_nz);
            }
        }
    }
}

void setSSIDPosCursorC() {
    push_pop(hl) {
        a = SSIDListViewY;
        a += 2;
        a += c;
        h = a;
        a = SSIDListViewX;
        a += 3;
        l = a;
        setPosCursor();
    }
}

void showSSIDListView() {
    drowRectX = (a = SSIDListViewX);
    drowRectY = (a = SSIDListViewY);
    drowRectEndX = (a = SSIDListViewEX);
    drowRectEndY = (a = SSIDListViewEY);
    drowRect();
    
    hl = SSIDListViewTitlePos;
    setPosCursor();
    hl = SSIDListViewTitle;
    printHLStr();
    
    i2cWaitingForAccess();
    needUpdateSSIDList();
    i2cWaitingForAccess();
    getSSIDList();
    
    SSIDFixBuffer();
    
    // Получить кол-во сетей
    SSIDListGetCount();
}

void SSIDFixBuffer() {
    push_pop(bc) {
        push_pop(de) {
            push_pop(hl) {
                hl = SSIDList;
                de = 15;
                hl += de;
                de = 16;
                b = 16;
                do {
                    a = 0;
                    *hl = a;
                    hl += de;
                    b--;
                } while (flag_nz);
            }
        }
    }
}

void SSIDListViewDataUpdate() {
    if ((a = rootViewCurrentView) != rootSSIDListView) {
        return;
    }
    
    push_pop(bc) {
        b = 0;
        do {
            a = 0x00;
            inverceAddress = a;
            
            if ((a = SSIDListViewCurrentPos) == b) {
                a = 0xFF;
                inverceAddress = a;
            }
            
            a = b;
            SSIDListViewShowValueA();
            
            a = 0x00;
            inverceAddress = a;
            
            b++;
            a = SSIDListCount;
            a -= b;
            //a = b;
            //a -= SSIDListCount;
        } while (flag_nz);
    }
}

void SSIDListViewShowValueA() {
    push_pop(hl) {
        push_pop(de) {
            de = 16;
            c = a;
            setSSIDPosCursorC();
            hl = SSIDList;
            if ((a = c) > 0) {
                do {
                    hl += de;
                    c--;
                } while (flag_nz);
            }
            printHLStr();
        }
    }
}

void SSIDListViewKeyA() {
    push_pop(hl) {
        l = a;
        if ((a = rootViewCurrentView) == rootSSIDListView) {
            a = l;
            if (a == 0x1B) { //ESC выход из настройки
                a = rootViewCurrentDiskView; // переходим на список файлов на диске
                rootViewCurrentView = a;
                
                updateRootUI();
                updateRootDataUI();
                needOpenWiFiSettingsEditView();
            } else {
                a = SSIDListCount;
                h = a;
                a = l;
                if (a == 0x1A) { //down
                    a = SSIDListViewCurrentPos;
                    a++;
                    if (a == h) {
                        a = 0;
                    }
                    SSIDListViewCurrentPos = a;
                } else if (a == 0x19) { //up
                    a = SSIDListViewCurrentPos;
                    if (a == 0) {
                        a = h;
                        a--;
                    } else {
                        a--;
                    }
                    SSIDListViewCurrentPos = a;
                } else if (a == 0x0D) { //Enter
                    // Надо отправить на ESP
                    a = SSIDListViewCurrentPos;
                    
                    // Отправляем index на ESP
                    setSSIDNumberA();
                    // Подождем
                    
                    getSSIDValue();
                    
                    // закрываем
                    a = rootViewCurrentDiskView; // переходим на список файлов на диске
                    rootViewCurrentView = a;
                    
                    updateRootUI();
                    updateRootDataUI();
                    needOpenWiFiSettingsEditView();
                }
            }
        }
    }
}

#endif /* SSIDListViewFunctions_h */
