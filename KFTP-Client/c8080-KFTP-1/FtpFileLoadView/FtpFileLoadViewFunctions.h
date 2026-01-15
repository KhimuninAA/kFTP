//
//  FtpFileLoadViewFunctions.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 01.01.2026.
//

#ifndef FtpFileLoadViewFunctions_h
#define FtpFileLoadViewFunctions_h

void showFtpFileLoadView() {
    drowRectX = (a = FtpFileLoadViewX);
    drowRectY = (a = FtpFileLoadViewY);
    drowRectEndX = (a = FtpFileLoadViewEX);
    drowRectEndY = (a = FtpFileLoadViewEY);
    drowRect();
    
    hl = FtpFileLoadViewTitlelPos;
    setPosCursor();
    hl = FtpFileLoadViewTitlel;
    printHLStr();
}

void updateProgress() {
    push_pop(hl) {
        push_pop(bc) {
            a = FtpFileLoadViewY;
            a += 1;
            h = a;
            a = FtpFileLoadViewX;
            a += 2;
            l = a;
            setPosCursor();
            h = 0;
            a = ftpFileLoadViewProgress;
            l = a;
            //
            setMyFont();
            do {
                h++;
                if ((a = h) < l) {
                    c = 0x28; //'X';
                } else {
                    c = 0x27; //' ';
                }
                push_pop(hl) {
                    printChatC();
                }
            } while ((a = h) < 40);
            setSystemFont();
        }
    }
}

void ftpFileLoadViewNeedLoad() {
    ftpFileDownload();
    
    // Считываем текущий диск и устанавливаем его
    a = diskViewDiskNum;
    ordos_wnd();
    
    // Получаем адрес куда надо начинать писать данные
    ordos_mxdsk();
    diskStartNewFile = hl;
    
    // Вызываем закачку
    ftpFileDownloadNext();
    
    // Обновляем
    updateDiskList();
    //updateRootUI();
}

void ftpFileLoadViewParce() {
    push_pop(de) {
        push_pop(hl) {
            push_pop(bc) {
                de = ESP_I2S_BUFFER;
                //addr
                a = *de;
                l = a;
                de++;
                a = *de;
                h = a;
                ftpFileLoadCurrentPos = hl;
                de++;
                //stopByte
                a = *de;
                //a &= 0x01;
                ftpFileLoadViewIsNextData = a;
                de++;
                //sum
                a = *de;
                ftpFileLoadViewCheckSum = a;
                de++;
                // PROGRESS
                a = *de;
                ftpFileLoadViewProgress = a;
                de++;
                // PAGE SIZE
                a = *de;
                if (a >= 15) {
                    a = 15;
                }
                de++;
                b = a; // SAVE PAGE SIZE in B
                // Вычесть из ftpFileLoadCurrentPos SIZE
                push_pop(hl) {
                    hl = ftpFileLoadCurrentPos;
                    a = l;
                    a -= b;
                    if (flag_c) {
                        h--;
                    }
                    l = a;
                    ftpFileLoadCurrentPos = hl;
                }
                //CHECK SUM
                push_pop(de) {
                    push_pop(bc) {
                        h = 0; //SUM!!!
                        do {
                            a = *de;
                            a += h;
                            h = a;
                            de++;
                            b--;
                        } while ((a = b) > 0);
                    }
                }
                //
                if ((a = ftpFileLoadViewCheckSum) == h) {
                    // Сумма корректная
                    if ((a = ftpFileLoadViewIsNextData) == 0) {
                        // Данных больше нет - закрываем файл!
                        ordos_stop();
                    } else {
                        // Данные корректны и еще есть - пишем
                        // DATA
                        //hl = diskStartNewFile;
                        push_pop(de) {
                            hl = ftpFileLoadCurrentPos;
                            d = h;
                            e = l;
                            hl = diskStartNewFile;
                            a = l;
                            a += e;
                            if (flag_c) {
                                h++;
                            }
                            l = a;
                            a = h;
                            a += d;
                            h = a;
                        }
                        do {
                            a = *de;
                            ordos_wdisk();
                            //SUM
                            hl++;
                            de++;
                            b--;
                        } while ((a = b) > 0);
                        //diskStartNewFile = hl;
                    }
                    // Получить следующий пакет
                    a = 0x01;
                    ftpFileLoadViewCheckSumState = a;
                    // Если считано без ошибок - то отрисовываем прогресс
                    updateProgress();
                } else {
                    // Получить пакет снова!
                    a = 0x00;
                    ftpFileLoadViewCheckSumState = a;
                }
            }
        }
    }
}

uint8_t ftpFileLoadViewIsNextData = 0;
uint16_t ftpFileLoadViewFileAddrPos = 0x0000;
uint8_t ftpFileLoadViewCheckSum = 0;
uint8_t ftpFileLoadViewCheckSumState = 0;
uint8_t ftpFileLoadViewProgress = 0;

uint8_t FtpFileLoadViewX = 10;
uint8_t FtpFileLoadViewY = 11;
uint8_t FtpFileLoadViewEX = 54;
uint8_t FtpFileLoadViewEY = 14;

uint16_t FtpFileLoadViewTitlelPos = 0x0B1D; //031B
uint8_t FtpFileLoadViewTitlel[] = " LOAD ";
uint16_t ftpFileLoadCurrentPos = 0x0000;

#endif /* FtpFileLoadViewFunctions_h */
