//
//  wifiSettingsEditViewFunctions.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 22.12.2025.
//

#ifndef wifiSettingsEditViewFunctions_h
#define wifiSettingsEditViewFunctions_h

void needOpenWiFiSettingsEditView() {
    push_pop(hl) {
        if ((a = rootViewCurrentView) != rootViewCurrentWiFiSettingsEditView) { //Если уже открыты настройки - не открываем
            if ((a = rootViewCurrentView) != rootViewCurrentFTPSettingsEditView) { //Если открыта настройка WiFi тоже не открываем
                
                a = rootViewCurrentWiFiSettingsEditView;
                rootViewCurrentView = a;
                
                a = 2;
                wifiSettingsEditViewCurrentPos = a;
                
                showDiskList(); //Сбросить выделение строки
                showWiFiSettingsEditView();
                wifiSettingsEditViewDataUpdate();
            }
        }
    }
}

void showWiFiSettingsEditView() {
    drowRectX = (a = wifiSettingsEditViewX);
    drowRectY = (a = wifiSettingsEditViewY);
    drowRectEndX = (a = wifiSettingsEditViewEX);
    drowRectEndY = (a = wifiSettingsEditViewEY);
    drowRect();
    
    hl = wifiSettingsEditViewLabelPos;
    setPosCursor();
    hl = wifiSettingsEditViewLabel;
    printHLStr();
    
    hl = wifiSettingsEditViewSSIDLabelPos;
    setPosCursor();
    hl = wifiSettingsEditViewSSIDLabel;
    printHLStr();
    
    hl = wifiSettingsEditViewSSIDPasswordLabelPos;
    setPosCursor();
    hl = wifiSettingsEditViewSSIDPasswordLabel;
    printHLStr();
    
    hl = wifiSettingsEditViewOkLabelPos;
    setPosCursor();
    hl = wifiSettingsEditViewOkLabel;
    printHLStr();
}

void wifiSettingsEditViewDataUpdate() {
    if ((a = rootViewCurrentView) != rootViewCurrentWiFiSettingsEditView) {
        return;
    }
    
    push_pop(bc) {
        b = 0;
        do {
            a = 0x00;
            inverceAddress = a;
            
            if ((a = wifiSettingsEditViewCurrentPos) == b) {
                a = 0xFF;
                inverceAddress = a;
            }
            
            a = b;
            wifiSettingsEditViewShowValueA();
            
            a = 0x00;
            inverceAddress = a;
            
            b++;
            a = b;
            a -= 5;
        } while (flag_nz);
    }
}

void wifiSettingsEditViewShowValueA() {
    if (a == 0) {
        hl = wifiSettingsEditViewSSIDValPos;
        setPosCursor();
        
        hl = wifiSettingsSsidVal;
        printHLStr();
    } else if (a == 1) {
        hl = wifiSettingsEditViewSSIDPasswordValPos;
        setPosCursor();
        
        hl = wifiSettingsEditViewSSIDPasswordVal;
        printHLStr();
    } else if (a == 2) {
        hl = wifiSettingsEditViewOkLabelPos;
        setPosCursor();
        hl = wifiSettingsEditViewOkLabel;
        printHLStr();
    }
}

void wifiSettingsEditViewKeyA() {
    push_pop(hl) {
        l = a;
        if ((a = rootViewCurrentView) == rootViewCurrentWiFiSettingsEditView) {
            a = l;
            if (a == 0x1B) { //ESC выход из настройки
                a = rootViewCurrentDiskView; // переходим на список файлов на диске
                rootViewCurrentView = a;
                
                updateRootUI();
                updateRootDataUI();
            } else {
                if (a == 0x1A) { //down
                    a = wifiSettingsEditViewCurrentPos;
                    a++;
                    if (a == 3) {
                        a = 0;
                    }
                    wifiSettingsEditViewCurrentPos = a;
                } else if (a == 0x19) { //up
                    a = wifiSettingsEditViewCurrentPos;
                    if (a == 0) {
                        a = 2;
                    } else {
                        a--;
                    }
                    wifiSettingsEditViewCurrentPos = a;
                } else if (a == 0x0D) { //Enter
                    if ((a = wifiSettingsEditViewCurrentPos) == 2) { // Нажатие на кнопку ОК
                        
                        //Пробуем подключиться в WiFi
                        needSsidConnect();
                        
                        a = rootViewCurrentDiskView; // переходим на список файлов на диске
                        rootViewCurrentView = a;
                        
                        updateRootUI();
                        updateRootDataUI();
                    } else {
                        wifiSettingsEditViewSelectEditField();
                    }
                }
            }
        }
    }
}

void wifiSettingsEditViewSelectEditField() {
    a = wifiSettingsEditViewCurrentPos;
    if (a == 1) {
        hl = wifiSettingsEditViewSSIDPasswordValPos;
        wifiSettingsEditViewEditValuePos = hl;
        setPosCursor();
        
        push_pop(hl) {
            hl = wifiSettingsEditViewSSIDPasswordVal;
            wifiSettingsEditView_CopyStrFromHL();
        }
    } else {
        // открыть список доступных сетей
        needOpenSSIDListView();
        return;
    }
    wifiSettingsEditViewEditField();
}

void wifiSettingsEditView_CopyStrFromHL() {
    push_pop(de) {
        push_pop(bc) {
            de = wifiSettingsEditViewEditValue;
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
                    wifiSettingsEditViewEditPos = a;
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

void wifiSettingsEditViewEditField() {
    hl = wifiSettingsEditViewEditValuePos;
    setPosCursor();
    
    a = 0xFF;
    inverceAddress = a;
    
    hl = wifiSettingsEditViewEditValue;
    printHLStr();
    
    wifiSettingsEditViewSetEditCursor();
    push_pop(bc) {
        b = 0;
        do {
            getKeyboardCharA();
            
            if (a == 0x1B) { // выход из редактирования без сохранения
                b = 1;
            } else if (a == 0x0D) { // Сохранить и выйти из редактирования
                b = 1;
                wifiSettingsEditViewSaveField();
            } else if (a >= 0x20) {
                if (a < 0x7F) { //Ввод символа
                    c = a;
                    // Если достигли предела - то перемещаем курсор на 1 назад
                    a = wifiSettingsEditViewEditPos;
                    if (a >= 15) {
                        a--;
                    }
                    wifiSettingsEditViewEditPos = a;
                    
                    //Сохраняем символ
                    a = c;
                    wifiSettingsEditViewSetValueA();
                    a = wifiSettingsEditViewEditPos;
                    a++;
                    wifiSettingsEditViewEditPos = a;
                    wifiSettingsEditViewSetEditCursor();
                } else if (a == 0x7F) { //Забой... (удаление символа)
                    if ((a = wifiSettingsEditViewEditPos) > 0) {
                        a--;
                        wifiSettingsEditViewEditPos = a;
                        wifiSettingsEditViewSetEditCursor();
                        a = ' ';
                        wifiSettingsEditViewSetValueA();
                    }
                }
            }
            
            a = b;
            a -= 1;
        } while (flag_nz);
    }
    
    a = 0x00;
    inverceAddress = a;
    
    showWiFiSettingsEditView();
    wifiSettingsEditViewDataUpdate();
}

void wifiSettingsEditViewSetEditCursor() {
    push_pop(hl) {
        hl = wifiSettingsEditViewEditValuePos;
        a = wifiSettingsEditViewEditPos;
        a += l;
        l = a;
        setPosCursor();
    }
}

void wifiSettingsEditViewSaveField() {
    a = wifiSettingsEditViewCurrentPos;
    if (a == 1) {
        hl = wifiSettingsEditViewSSIDPasswordVal;
    }
    wifiSettingsEditViewSaveEditValueToHL();
}

void wifiSettingsEditViewSetValueA() {
    push_pop(hl) {
        push_pop(bc) {
            b = a;
            //Сохраним символ в wifiSettingsEditViewEditValue
            hl = wifiSettingsEditViewEditValue;
            a = wifiSettingsEditViewEditPos;
            a += l;
            l = a;
            if (flag_c) {
                h++;
            }
            *hl = b;
            //Отрисуем символ на экране
            wifiSettingsEditViewSetEditCursor();
            a = b;
            printChatA();
            wifiSettingsEditViewSetEditCursor();
        }
    }
}

void wifiSettingsEditViewSaveEditValueToHL() {
    push_pop(de) {
        push_pop(bc) {
            de = wifiSettingsEditViewEditValue;
            a = wifiSettingsEditViewEditPos;
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
    setSSIDPasswordValue();
    setSSIDPasswordValue();
    //getSSIDPasswordValue();
}

///  Обновить данные WiFi
void updateWiFiStatus() {
    a = updateWiFiStatusTike;
    if (a < 240) {
        a++;
        updateWiFiStatusTike = a;
        return;
    }
    a = 0;
    updateWiFiStatusTike = a;
    //
    getSSIDState();
    if ((a = WiFiStateUpdate) == 0x01) {
        a = 0x00;
        WiFiStateUpdate = a;
        getSSIDIPAddress();
        getSSIDMacAddress();
        //
        clearWiFiViewValData();
        updateWiFiViewValData();
    }
}

#endif /* wifiSettingsEditViewFunctions_h */
