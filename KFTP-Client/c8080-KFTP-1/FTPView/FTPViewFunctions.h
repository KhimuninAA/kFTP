//
//  FTPViewFunctions.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 28.12.2025.
//

#ifndef FTPViewFunctions_h
#define FTPViewFunctions_h

void needUpdateFtpList() {
    i2cWaitingForAccess();
    updateFtpList();
    i2cWaitingForAccess();
    getFtpList();
    
//    a = ftpDirListCount;
//    if (a >= 16) {
//        a = 16;
//        ftpDirListCount = a;
//    }
    
    a = 0;
    ftpViewCurrentPos = a;
    
    ftpViewDataUpdate();
}

void clearView() {
    push_pop(hl) {
        push_pop(bc) {
            b = 15;
            //
            a = ftpDirListCount;
            c = a; //0;
            // Отнять от B
            a = b;
            a -= c;
            b = a;
            //--
            do {
                ftpViewPosCursorC();
                hl = ftpViewEmpty16; //wifiSettingsEmpty18;
                printHLStr();
                b--;
                c++;
            } while ((a = b) > 0);
        }
    }
}

/// Обновить на экране текущий путь на FTP
void updateCurrentPath() {
    push_pop(hl, bc) {
        hl = ftpViewDirPath;
        b = 25;
        c = 0; // признак что нужно проставить пробелы
        do {
            a = *hl;
            if (a == 0) {
                c = 1;
            }
            if ((a = c) == 1) {
                a = ' ';
                *hl = a;
            }
            hl++;
            b--;
        } while ((a = b) > 0);
        // Если был признак простановки пробелов, ставим в конце 0
        if ((a = c) == 1) {
            a = 0;
            *hl = a;
        }
        setPosCursor(hl = ftpViewDirPathPos);
        printHLStr(hl = ftpViewDirPath);
    }
}

void ftpViewDataUpdate() {
    push_pop(bc) {
        b = 0;
        a = ftpDirListCount;
        c = a;
        do {
            a = 0x00;
            inverceAddress = a;
            
            if ((a = rootViewCurrentView) == rootViewCurrentFTPView) {
                if ((a = ftpViewCurrentPos) == b) {
                    a = 0xFF;
                    inverceAddress = a;
                }
            }
            
            a = b;
            ftpViewShowValueA();
            
            a = 0x00;
            inverceAddress = a;
            
            b++;
            c--;
        } while ((a = c) > 0);
    }
    clearView();
}

void ftpViewShowValueA() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                de = 16;
                c = a;
                ftpViewPosCursorC();
                hl = ftpDirList;
                if ((a = c) > 0) {
                    do {
                        hl += de;
                        c--;
                    } while (flag_nz);
                }
                //hl = ftpLabel;
                printHLStr();
            }
        }
    }
}

void ftpViewPosCursorC() {
    push_pop(hl) {
        a = ftpViewY;
        a += 1;
        a += c;
        h = a;
        a = ftpViewX;
        a += 3;
        l = a;
        setPosCursor();
    }
}

void ftpViewKeyA() {
    push_pop(hl) {
        l = a;
        if ((a = rootViewCurrentView) == rootViewCurrentFTPView) {
            a = l;
            if (a == 0x09) { // TAB - Change to local disk
                a = rootViewCurrentDiskView; // переходим на список файлов на диске
                rootViewCurrentView = a;
                ftpViewDataUpdate();
                showDiskList();
            } else {
                a = ftpDirListCount;
                h = a;
                a = l;
                if (a == 0x1A) { //down
                    a = ftpViewCurrentPos;
                    a++;
                    if (a == h) {
                        a = 0;
                    }
                    ftpViewCurrentPos = a;
                } else if (a == 0x19) { //up
                    a = ftpViewCurrentPos;
                    if (a == 0) {
                        a = h;
                        a--;
                    } else {
                        a--;
                    }
                    ftpViewCurrentPos = a;
                } else if (a == 0x0D) { //Enter
                    ftpViewCurrentPosIsDir();
                    if ((a = ftpDirListIsDir) == 1) {
                        if ((a = ftpViewCurrentPos) == 0) {
                            ftpChangeDirUp();
                        } else {
                            ftpChangeDirPos();
                        }
                        getFtpCurrentPath();
                        needUpdateFtpList();
                        updateCurrentPath();
                    } else {
                        loadSelectFile();
                    }
                } else if (a == 0x34) { // C (COPY)
                    ftpViewCurrentPosIsDir();
                    if ((a = ftpDirListIsDir) == 0) {
                        loadSelectFile();
                    }
                } else if (a == 'R') { // R (Refresh)
                    getFtpCurrentPath();
                    needUpdateFtpList();
                    updateCurrentPath();
                }
            }
        }
    }
}

void loadSelectFile() {
    showFtpFileLoadView();
    ftpFileLoadViewNeedLoad();
    updateDiskList();
    updateRootUI();
    showDiskList();
}

/// from ESP_I2S_BUFFER
/// to ftpDirList
/// count ftpDirListCount
/// next ftpDirListNext
void parceBufferToFile() {
    de = ESP_I2S_BUFFER;
    // (0) - порядковый номер Должен быть == ftpDirListCount + 1
    a = ftpDirListCount;
//    b = a;
//    a = *de;
//    if (a != b) {
//        a = 0x5A;
//        ftpDirListNext = a;
//        return;
//    }
    hl = ftpDirList;
    b = 0;
    carry_rotate_left(a, 4);
    if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
        b++;
    }
    c = a;
    hl += bc; // ftpDirList + смещение
//    a = ftpDirListCount;
//    a ++;
//    ftpDirListCount = a;
    // (1) - Флаг окончания пакета. Если 1 - то продолжаем. Любой другой - СТОП!
    de++;
    a = *de;
    ftpDirListNext = a;
    if (a != 0x5A) {
        a = ftpDirListCount;
        a ++;
        ftpDirListCount = a;
    }
//    if (a == 0x01) {
//        a = 1;
//        ftpDirListNext = a;
//    } else {
//        a = 0;
//        ftpDirListNext = a;
//        return;
//    }
    // (2) - Флаг директоии
    de++;
    a = *de;
    a &= 0x01;
    ftpDirListIsDir = a;
    if (a == 0) {
        a = ' ';
        *hl = a;
    } else {
        a = ' '; //'>';
        *hl = a;
    }
    hl++;
    // (3-4) - размер файла
    de++;
    parceSizeFileInBuffer();
    // (5-) Имя файла/директории
    b = 9;
    do {
        a = *de;
        if (a == 0x00) {
            a = ' ';
        }
        *hl = a;
        if ((a = b) == 1) {
            a = ' ';
            *hl = a;
        }
        de++;
        hl++;
        b--;
    } while (flag_nz);
}

/// HL - result string
/// DE - 2 byte size
void parceSizeFileInBuffer() {
    push_pop(hl) {
        push_pop(bc) {
            bc = 9;
            hl += bc; // смещаем указатель на позицию с размеров файла
            a = ' ';
            *hl = a;
            hl++;
            // Размер
            if ((a = ftpDirListIsDir) == 0) {
                a = *de;
                a &= 0xF0;
                cyclic_rotate_right(a, 4);
                convert4bitToCharA();
                *hl = a;
                hl++;
                a = *de;
                a &= 0x0F;
                convert4bitToCharA();
                *hl = a;
                hl++;
                de++;
                
                a = *de;
                a &= 0xF0;
                cyclic_rotate_right(a, 4);
                convert4bitToCharA();
                *hl = a;
                hl++;
                a = *de;
                a &= 0x0F;
                convert4bitToCharA();
                *hl = a;
                hl++;
                de++;
            } else {
                a = ' ';
                *hl = a;
                hl++;
                a = 'D';
                *hl = a;
                hl++;
                a = 'I';
                *hl = a;
                hl++;
                a = 'R';
                *hl = a;
                hl++;
                de++;
                de++;
            }
            //
            a = 0;
            *hl = a; // End char string
        }
    }
}

void ftpViewCurrentPosIsDir() {
    push_pop(hl) {
        push_pop(bc) {
            hl = ftpDirList;
            a = ftpViewCurrentPos;
            b = 0;
            carry_rotate_left(a, 4);
            if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
                b++;
            }
            c = a;
            hl += bc;
            // + 12 (DIR)
            bc = 12;
            hl += bc;
            a = *hl;
            if (a == 'D') {
                a = 1;
            } else {
                a = 0;
            }
            ftpDirListIsDir = a;
        }
    }
}

#endif /* FTPViewFunctions_h */
