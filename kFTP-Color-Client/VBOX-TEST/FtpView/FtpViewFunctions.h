//
//  FtpViewFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef FtpViewFunctions_h
#define FtpViewFunctions_h

void FtpViewShow() {
    push_pop(bc, hl, de) {
        a = FtpViewX;
        h = a;
        a = FtpViewY;
        l = a;
        a = FtpViewDX;
        d = a;
        a = FtpViewDY;
        e = a;
        a = FtpViewColor;
        vboxOpenHLDE();
        vboxBorderHLDE();
        FtpViewShowTitle();
        
        #ifdef _IS_SIMULATOR
            FtpViewShowFileList();
            FtpViewShowPath();
            a = 0;
            FtpViewFileCurrentPos = a;
            FtpViewShowSelectLineA(a = 1);
        #else
            FtpViewNetLoadAndUpdate();
        #endif
    }
}

void FtpViewShowTitle() {
    a = FtpViewX;
    a++;
    myCharPosX = a;
    a = FtpViewY;
    myCharPosY = a;
    printMyHLStr(hl = FtpViewTitle);
}

void FtpViewShowFileList() {
    push_pop(bc, de, hl) {
        b = 0;
        a = FtpViewFilesListCount;
        hl = FtpViewFilesList;
        c = a;
        do {
            a = FtpViewY;
            a += 2;
            a += b;
            myCharPosY = a;
            FtpViewShowFileHL();
            // HL + 16 next file
            a = 16;
            a += l;
            l = a;
            if (flag_c) {
                h++;
            }
            b++;
        } while ((a = b) < c);
        // Заполнить пустыми строками
        a = FtpViewX;
        a += 1;
        d = a; // X
        a = FtpViewY;
        a += 2;
        e = a; // Y
        //--
        a = FtpViewFilesListCount;
        b = a;
        // PosY
        a = e;
        a += b;
        e = a;
        //
        a = FtpViewDY;
        a -= 4;
        a -= b;
        b = a;
        c = 0;
        do {
            a = d;
            myCharPosX = a;
            a = e;
            a += c;
            myCharPosY = a;
            //
            a = FtpViewDX;
            a -= 3;
            h = a;
            do {
                printMyChatA(a = ' ');
                h--;
            } while ((a = h) > 0);
            b--;
            c++;
        } while ((a = b) > 0);
    }
}

void FtpViewShowFileHL() {
    push_pop(bc, hl) {
        if ((a = b) == 0) {
            FtpViewShowFileName();
        } else {
            FtpViewShowFileName();
            FtpViewShowFileSize();
            FtpViewShowFileDate();
        }
    }
}

// A = 1 - Dir
void FtpViewShowIsDirA() {
    push_pop(bc) {
        b = a;
        a = FtpViewX;
        a += 1;
        myCharPosX = a;
        if ((a = b) == 1) {
            printMyChatA(a = 0x1F); //0x10
        } else {
            printMyChatA(a = ' ');
        }
    }
}

void FtpViewShowFileName() {
    // X pos
    a = FtpViewX;
    a += 2;
    myCharPosX = a;
    //
    b = 8;
    do {
        printMyChatA(a = *hl);
        hl++;
        b--;
    } while ((a = b) > 0);
}

void FtpViewShowFileSize() {
    push_pop(bc, de) {
        // X pos
        a = FtpViewX;
        a += 11;
        myCharPosX = a;
        //
        a = *hl;
        d = a;
        hl++;
        a = *hl;
        e = a;
        hl++;
        a = *hl;
        hl++;
        if (a == 0x00) {
            push_pop(hl) {
                h = 0; // файл для Орион
                if ((a = d) == 0xFF) {
                    if ((a = e) == 0xFF) {
                        h = 1; // Файл слишком большой для Орион
                    }
                }
                if ((a = h) == 0) { // Показываем размер
                    //hl = 0x0400;
                    //compareHlDe();
                    if ((a = d) < 4) { // < 1024 в байтах //flag_c
                        push_pop(hl) {
                            h = d;
                            l = e;
                            printMyAsDec4095HL();
                        }
                    } else { // В Кб
                        a = d;
                        a &= 0xFC;
                        cyclic_rotate_right(a, 2);
                        printMyAsDec99A();
                        printMyChatA(a = 'K');
                        printMyChatA(a = 'b');
                    }
                } else { // Файл слишком большой
                    printMyChatA(a = ' ');
                    printMyChatA(a = 'B');
                    printMyChatA(a = 'I');
                    printMyChatA(a = 'G');
                }
            }
            FtpViewShowIsDirA(a = 0);
        } else {
            printMyChatA(a = ' ');
            printMyChatA(a = ' ');
            printMyChatA(a = ' ');
            printMyChatA(a = ' ');
            FtpViewShowIsDirA(a = 1);
        }
    }
}

void FtpViewShowFileDate() {
    push_pop(bc, de) {
        // X pos
        a = FtpViewX;
        a += 16;
        myCharPosX = a;
        //
        hl++;
        hl++;
        //--
        //GGGGGGGG GGGGMMMM 000DDDDD
        a = *hl;
        cyclic_rotate_right(a, 4);
        c = a;
        hl++;
        a = *hl;
        b = a;
        //Year
        a = c;
        a &= 0xF0;
        d = a;
        a = b;
        a &= 0xF0;
        cyclic_rotate_right(a, 4);
        a += d;
        e = a;
        a = c;
        a &= 0x0F;
        d = a;
        push_pop(hl) {
            h = d;
            l = e;
            printMyAsDec4095HL();
        }
        //Mount
        printMyChatA(a = '-');
        a = b;
        a &= 0x0F;
        printMyAs00Dec99A();
        hl++;
        //Day
        printMyChatA(a = '-');
        a = *hl;
        a &= 0x1F;
        hl++;
        printMyAs00Dec99A();
    }
}

void FtpViewShowPath() {
    push_pop(bc, de, hl) {
        a = FtpViewX;
        b = a;
        a = FtpViewDX;
        a += b;
        a -= 19;
        myCharPosX = a;
        a = FtpViewY;
        myCharPosY = a;
        de = FtpViewPath;
        printMyChatA(a = 0xB5);
        b = 16;
        c = 0;
        do {
            a = *de;
            de++;
            if (a == 0) {
                c = 1;
            }
            h = a;
            if ((a = c) == 0) {
                printMyChatA(a = h);
            } else {
                printMyChatA(a = ' ');
            }
            b--;
        } while ((a = b) > 0);
        printMyChatA(a = 0xC6);
    }
}

/// Обновление позиции
/// вх[A]
/// 0 - без изменений
/// 1 - вверх
/// 0xFF - вниз
void FtpViewFileCurrentPosUpdateA() {
    push_pop(bc) {
        b = a;
        if (a == 0) {
            FtpViewShowSelectLineA(a = 1);
        } else {
            a = FtpViewFilesListCount;
            c = a;
            FtpViewShowSelectLineA(a = 0);
            a = FtpViewFileCurrentPos;
            a += b;
            //
            if (a == 0xFF) {
                a = c;
                a--;
            } else if (a == c) {
                a = 0;
            }
            FtpViewFileCurrentPos = a;
            FtpViewShowSelectLineA(a = 1);
        }
    }
}

/// Рисование линии прямым или инверсным цветом
/// 0 - прямой
/// 1 - инверсный
void FtpViewShowSelectLineA() {
    push_pop(bc) {
        c = a;
        // HL
        a = FtpViewFileCurrentPos;
        b = a;
        a = FtpViewY;
        a += 2;
        a += b;
        l = a;
        a = FtpViewX;
        a += 1;
        h = a;
        // DE
        a = FtpViewDX;
        a -= 2;
        d = a;
        a = 1;
        e = a;
        // C
        if ((a = c) == 0) {
            a = FtpViewColor;
        } else {
            a = FtpViewInvColor;
        }
        c = a;
        // A
        a = vboxUMP;
        vboxOpenHLDECA();
    }
}

void FtpViewKeyA() {
    push_pop(hl) {
        l = a;
        if ((a = CurrentViewId) == FtpViewId) {
            if ((a = l) == 0x09) { //0x09 TAB
                CurrentViewChangeIdA(a = DiskViewId);
            } else {
                if ((a = l) == 0x1A) { //down
                    FtpViewFileCurrentPosUpdateA(a = 0x01);
                } else if ((a = l) == 0x19) { //up
                    FtpViewFileCurrentPosUpdateA(a = 0xFF);
                } else if ((a = l) == 0x0D) { //Enter
                    if ((a = FtpViewFileCurrentPos) == 0) { // Dir UP
                        ftpChangeDirUp();
                        FtpViewNetLoadAndUpdate();
                    } else {
                        FtpViewCurrentPosIsDir();
                        if (a == 1) { // Enter Dir
                            //FtpViewShowSelectLineA(a = 0); // TODO надо убрать...
                            ftpChangeDirPosA(a = FtpViewFileCurrentPos);
                            FtpViewNetLoadAndUpdate();
                        } else { // Load file
                            FtpViewLoadFile();
                        }
                    }
                } else if ((a = l) == 'R') { // Обновление папки
                    FtpViewNetLoadAndUpdate();
                } else if ((a = l) == 'C') { // загрузка файла
                    FtpViewCurrentPosIsDir();
                    if (a == 0) { // Проверим что это файл
                        FtpViewLoadFile();
                    }
                } else if ((a = l) == 'H') { // Перейти в домашную папку
                    ThreadsNetFtpGoToHomeDir();
                }
            }
        }
    }
}

void FtpViewLoadFile() {
    LoadViewShowHL(hl = LoadViewLoadTitle);
    #ifdef _IS_SIMULATOR
        push_pop(bc) {
            b = 0;
            do {
                LoadViewShowProgressA(a = b);
                c = 1;
                do {
                    delay50ms();
                    c--;
                } while ((a = c) > 0);
                b++;
            } while ((a = b) < 40);
            LoadViewClose();
            DiskViewUpdateDateAndUI();
        }
    #else
        FtpViewNeedLoad();
        LoadViewClose();
        DiskViewUpdateDateAndUI();
    #endif
}

void FtpViewNeedLoad() {
    ftpFileDownloadA(a = FtpViewFileCurrentPos);
    
    // Считываем текущий диск и устанавливаем его
    a = DiskViewDiskNum;
    ordos_wnd();
    
    // Получаем адрес куда надо начинать писать данные
    ordos_mxdsk();
    DiskViewStartNewFile = hl;
    
    // Вызываем закачку
    ftpFileDownloadNext();
}

void FtpViewNetLoadAndUpdate() {
    FtpViewShowSelectLineA(a = 0);
    getFtpCurrentPathNew();
    if ((a = FtpStateViewStatus) == 1) {
        updateFtpList();
        getNetFtpListNew();
    }
    a = 0;
    FtpViewFileCurrentPos = a;
    FtpViewShowFileList();
    FtpViewShowPath();
    FtpViewShowSelectLineA(a = 1);
}

void FtpViewCurrentPosIsDir() {
    push_pop(hl, bc) {
        hl = FtpViewFilesList;
        //--
        a = FtpViewFileCurrentPos;
        a &= 0x3F;
        b = 0;
        carry_rotate_left(a, 4);
        if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
            b++;
        }
        c = a;
        //-- Смещаем на позицию файла
        hl += bc;
        //-- Смещаем на признак директории
        bc = 10;
        hl += bc;
        //--
        a = *hl;
    }
}

void FtpViewEmptyList() {
    push_pop(hl) {
        a = 1;
        FtpViewFilesListCount = a;
        a = 0;
        FtpViewFileCurrentPos = a;
        hl = FtpViewFilesList;
        //--
        *hl = '.';
        hl++;
        *hl = '.';
        hl++;
        //--
        *hl = ' ';
        hl++;
        *hl = ' ';
        hl++;
        *hl = ' ';
        hl++;
        *hl = ' ';
        hl++;
        *hl = ' ';
        hl++;
        *hl = ' ';
        hl++;
    }
    //--
    FtpViewListUpdateUI();
}

void FtpViewListUpdateUI() {
    FtpViewShowSelectLineA(a = 0);
    a = 0;
    FtpViewFileCurrentPos = a;
    FtpViewShowPath();
    FtpViewShowFileList();
    FtpViewShowSelectLineA(a = 1);
}

uint8_t FtpViewX = 0;
uint8_t FtpViewY = 4;
uint8_t FtpViewDX = 28;
uint8_t FtpViewDY = 25;
uint8_t FtpViewColor = 0x1F;
uint8_t FtpViewInvColor = 0xF1;

uint8_t FtpViewTitle[] = {0xB5, 'F', 'T', 'P', 0xC6, '\0'}; //"\x12" + "FTP";
uint8_t FtpViewPath[16] = "/Orion/TEST/";

uint8_t FtpViewFileCurrentPos = 0;
// GGGGGGGG GGGGMMMM 000DDDDD          0x7D55
// Дата: ГОД (4095)12b  МЕСЯЦ(15) 4b ДЕНЬ (31) 5b
#ifdef _IS_SIMULATOR
    uint8_t FtpViewFilesListCount = 7;
    uint8_t FtpViewFilesList[16 * 23] = {
        '.', '.', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
        'f', 'i', 'l', 'e', '.', 'T', 'X', 'T', 0x00, 0xCF, 0x00, ' ', ' ', 0x7E, 0xA5, 0x0C, // -00-12
        'S', 'o', 'f', 't', ' ', ' ', ' ', ' ', 0x00, 0x00, 0x01, ' ', ' ', 0x7E, 0x95, 0x1F, // -00-31
        'V', 'C', '$', ' ', ' ', ' ', ' ', ' ', 0x0E, 0x00, 0x00, ' ', ' ', 0x7C, 0x85, 0x17, // -00-23
        'M', '1', '2', '8', '_', '2', '$', ' ', 0x08, 0xC0, 0x00, ' ', ' ', 0x7D, 0x55, 0x1F, // -00-31
        'G', 'A', 'M', 'E', 'S', ' ', ' ', ' ', 0x00, 0x00, 0x01, ' ', ' ', 0x7E, 0x95, 0x1F, // -00-31
        'S', 'A', 'B', 'O', 'T', '1', '$', ' ', 0x90, 0x20, 0x00, ' ', ' ', 0x7E, 0x95, 0x1F, // -00-31
};
#else
    uint8_t FtpViewFilesListCount = 1;
    uint8_t FtpViewFilesList[16 * 23] = {
        '.', '.', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
};
#endif

#endif /* FtpViewFunctions_h */
