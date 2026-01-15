//
//  ParseHelperFunctions.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 12.01.2026.
//

#ifndef ParseHelperFunctions_h
#define ParseHelperFunctions_h

/// Парсинг буфера от  API метода GET_NEXT_PAGE_BUFFER
/// вх. [HL] - Куда записывать результат
/// ESP_I2S_BUFFER - буфер где лежат полученные данные
void parsePageBuffer() {
    checkSumPageBuffer();
    if ((a = parsePageBufferIsCheck) == 1) {
        push_pop(de) {
            push_pop(bc) {
                de = ESP_I2S_BUFFER;
                // pageNum
                de++;
                // pageSize
                a = *de;
                b = a;
                de++;
                // next
                a = *de;
                parsePageBufferNext = a;
                de++;
                // buffer
                push_pop(de) {
                    do {
                        a = *de;
                        *hl = a;
                        de++;
                        hl++;
                        b--;
                    } while ((a = b) > 0);
                }
            }
        }
    } else {
        a = 0x5A;
        parsePageBufferNext = a;
    }
}

void checkSumPageBuffer() {
    push_pop(de) {
        push_pop(bc) {
            de = ESP_I2S_BUFFER;
            c = 0; // c == Check SUM
            // pageNum
            a = *de;
            a += c;
            c = a;
            de++;
            // pageSize
            a = *de;
            b = a;
            a += c;
            c = a;
            de++;
            // next
            a = *de;
            a += c;
            c = a;
            de++;
            // buffer
            do {
                a = *de;
                a += c;
                c = a;
                de++;
                b--;
            } while ((a = b) > 0);
            // sum
            a = *de;
            if (a == c) {
                a = 1;
                parsePageBufferIsCheck = a;
            } else {
                a = 0;
                parsePageBufferIsCheck = a;
            }
        }
    }
}

uint8_t parsePageBufferNext = 0;
uint8_t parsePageBufferIsCheck = 0;

// ESP_I2S_BUFFER
void parseFtpListBuffer() {
    checkSumFtpListBuffer();
    if ((a = parseFtpListBufferIsCheck) == 1) {
        push_pop(de) {
            push_pop(bc) {
                push_pop(hl) {
                    de = ESP_I2S_BUFFER;
                    hl = ftpDirList;
                    //-- Pos
                    a = *de;
                    a &= 0x3F;
                    ftpDirListCount = a;
                    b = 0;
                    carry_rotate_left(a, 4);
                    if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
                        b++;
                    }
                    c = a;
                    hl += bc; // ftpDirList + смещение
                    //-- Next
                    a = *de;
                    a &= 0x40;
                    if (a == 0x40) {
                        a = 0x01;
                        ftpDirListNext = a;
                    } else {
                        a = 0x5A;
                        ftpDirListNext = a;
                    }
                    //-- Dir
                    a = *de;
                    a &= 0x80;
                    if (a == 0x80) {
                        a = 1;
                        ftpDirListIsDir = a;
                    } else {
                        a = 0;
                        ftpDirListIsDir = a;
                    }
                    //-- SIZE
                    de++;
                    sizeFtpListBuffer();
                    //-- NAME
                    a = ' ';
                    *hl = a;
                    hl++;
                    b = 9;
                    do {
                        a = *de;
                        if (a == 0x00) {
                            a = ' ';
                        }
                        *hl = a;
                        hl++;
                        de++;
                        b--;
                    } while ((a = b) > 0);
                }
            }
        }
    } else {
        a = 0xFF; // ERROR
        ftpDirListNext = a;
    }
}

// HL - point File
// DE - point size
void sizeFtpListBuffer() {
    push_pop(hl) {
        b = 10;
        do {
            hl++;
            b--;
        } while ((a = b) > 0);
        // -- Separator
        a = ' ';
        *hl = a;
        hl++;
        // --
        if ((a = ftpDirListIsDir) == 1) {
            de++;
            de++;
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
            a = 0;
            *hl = a;
            hl++;
        } else {
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
            a = 0;
            *hl = a;
            hl++;
        }
    }
}

// ESP_I2S_BUFFER
// diskStartNewFile
void checkSumFtpListBuffer() {
    push_pop(de) {
        push_pop(bc) {
            de = ESP_I2S_BUFFER;
            c = 0;
            b = 12;
            do {
                a = *de;
                a += c;
                c = a;
                de++;
                b--;
            } while ((a = b) > 0);
            // SUM
            a = *de;
            if (a == c) {
                a = 1;
                parseFtpListBufferIsCheck = a;
            } else {
                a = 0;
                parseFtpListBufferIsCheck = a;
            }
        }
    }
}

/// Парсинг пакета с данными скачиваемого файла
void ftpFileDownloadParse() {
    checkSumFtpFileDownload();
    if ((a = ftpFileLoadViewCheckSumState) == 1) {
        push_pop(de) {
            push_pop(hl) {
                push_pop(bc) {
                    de = ESP_I2S_BUFFER;
                    // -- SIZE
                    a = *de;
                    ftpFileDownloadParseSizePackA();
                    de++;
                    // -- ADDRESS
                    a = *de;
                    l = a;
                    de++;
                    a = *de;
                    h = a;
                    ftpFileLoadCurrentPos = hl;
                    de++;
                    // -- PROGRESS AND NEXT
                    a = *de;
                    ftpFileDownloadParseProgressAndNextA();
                    de++;
                    // -- DATA
                    // Если контрольная сумма совпала и есть статус что данные есть - пишем на диск
                    if ((a = ftpFileLoadViewIsNextData) == 0x01) {
                        ftpFileDownloadCalkDiskPosToHL();
                        a = ftpFileDownloadDataSize;
                        b = a;
                        do {
                            a = *de;
                            ordos_wdisk();
                            de++;
                            hl++;
                            b--;
                        } while ((a = b) > 0);
                        ftpFileDownloadEnd = hl;
                    }
                    // Если контрольная сумма совпала и статус что данные закончились - закрываем файл
                    if ((a = ftpFileLoadViewIsNextData) == 0x5A) {
                        hl = ftpFileDownloadEnd;
                        ordos_stop();
                    }
                }
            }
        }
    } else {
        a = 0xFF;
        ftpFileLoadViewIsNextData = a;
    }
}

/// Считаем адрес куда писать данные на диск
void ftpFileDownloadCalkDiskPosToHL() {
    push_pop(de) {
        // получаем адрес пакета
        hl = ftpFileLoadCurrentPos;
        // вычитаем длину пакета данных
        a = ftpFileDownloadDataSize;
        e = a;
        a = l;
        a -= e;
        if (flag_c) {
            h--;
        }
        l = a;
        // прибавляем к точке начала файла на диске
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
        // В HL адрес записи, полученных данных, на диск
    }
}

/// Подсчет контрольной суммы
void checkSumFtpFileDownload() {
    push_pop(de) {
        push_pop(bc) {
            de = ESP_I2S_BUFFER;
            a = *de;
            ftpFileDownloadParseSizePackA();
            a = ftpFileDownloadPropertySize;
            b = a;
            a = ftpFileDownloadDataSize;
            a += b;
            b = a;
            //
            c = 0;
            do {
                a = *de;
                a += c;
                c = a;
                de++;
                b--;
            } while ((a = b) > 0);
            //
            a = *de;
            if (a == c) {
                a = 1;
                ftpFileLoadViewCheckSumState = a;
            } else {
                a = 0;
                ftpFileLoadViewCheckSumState = a;
            }
        }
    }
}

/// Извлекает из A данные о прогрессе и Статус продолжение данных
/// первые 6 бит - прогресс.
/// последние 2 - статус продолжения. (0x80 - если еще есть данные. 0x40 - данные закончились. 0x00 - ошибка данных)
void ftpFileDownloadParseProgressAndNextA() {
    push_pop(bc) {
        b = a;
        a &= 0x3F;
        ftpFileLoadViewProgress = a;
        //
        a = b;
        a &= 0xC0;
        b = a;
        // --
        if ((a = b) == 0x80) {
            a = 0x01;
            ftpFileLoadViewIsNextData = a;
        } else if ((a = b) == 0x40) {
            a = 0x5A;
            ftpFileLoadViewIsNextData = a;
        } else {
            a = 0xFF;
            ftpFileLoadViewIsNextData = a;
            a = 0;
            ftpFileLoadViewCheckSumState = a;
        }
    }
}

/// Извлекает из A данные по размерам пакета (свойства + буфер)
/// первые 3 бита - свойства, последние 5 - данные
/// (property & 0x07) + ((data & 0x1f)<<3);
void ftpFileDownloadParseSizePackA() {
    push_pop(bc) {
        b = a;
        a &= 0x07;
        ftpFileDownloadPropertySize = a;
        a = b;
        a &= 0xF8;
        carry_rotate_right(a, 3);
        ftpFileDownloadDataSize = a;
    }
}

uint8_t ftpFileDownloadPropertySize = 0;
uint8_t ftpFileDownloadDataSize = 0;
uint8_t parseFtpListBufferIsCheck = 0;
uint8_t ftpFileDownloadIsCheck = 0;
uint16_t ftpFileDownloadEnd = 0;

#endif /* ParseHelperFunctions_h */
