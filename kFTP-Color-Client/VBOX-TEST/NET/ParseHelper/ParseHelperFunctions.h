//
//  ParseHelperFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 21.01.2026.
//

#ifndef ParseHelperFunctions_h
#define ParseHelperFunctions_h

/// Внутренняя подпрограмма для parsePageBuffer()
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

/// Парсинг буфера от  API метода GET_NEXT_PAGE_BUFFER
/// вх. [HL] - Куда записывать результат
/// ESP_I2S_BUFFER - буфер где лежат полученные данные
void parsePageNewBuffer() {
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
                //-- Next or 0x01 or 0x5A
                parsePageNewBufferOr01Or5A();
                if (a == 1) {
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
                } else {
                    a = 0;
                    parsePageBufferNext = a;
                    parsePageBufferIsCheck = a;
                }
            }
        }
    }
}

void parsePageNewBufferOr01Or5A() {
    push_pop(bc) {
        if ((a = parsePageBufferNext) == 0x01) {
            b = 1;
        } else if ((a = parsePageBufferNext) == 0x5A) {
            b = 1;
        } else {
            b = 0;
        }
        a = b;
    }
}

/// 1 byte - dnpppppp (p - pos, n - next, d - dir)
/// 2 byte - Size
/// 3 byte - Date (GGGGGGGG GGGGMMMM 000DDDDD)
/// 8 byte - Name
/// 1 byte - CheckSum
/// TO ->  'G', 'A', 'M', 'E', 'S', ' ', ' ', ' ', 0x00, 0x00, 0x01, ' ', ' ', 0x7E, 0x95, 0x1F
void parseFtpListBuffer() {
    checkSumFtpListBuffer();
    if ((a = parseFtpListBufferIsCheck) == 1) {
        push_pop(de, hl, bc) {
            de = ESP_I2S_BUFFER; // Откуда
            hl = FtpViewFilesList;     // Куда
            //Pos (Pos + Next + isDir)
            a = *de;
            a &= 0x3F;
            FtpViewFilesListCount = a; // Сохраним значение кол-ва файлов
            b = 0;
            carry_rotate_left(a, 4);
            if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
                b++;
            }
            c = a;
            hl += bc; // ftpDirList + смещение
            //Pos -> Next
            a = *de;
            a &= 0x40;
            if (a == 0x40) {
                a = 0x01;
                parseFtpListBufferNext = a;
            } else {
                a = 0x5A;
                parseFtpListBufferNext = a;
            }
            //Pos -> isDir
            a = *de;
            a &= 0x80;
            if (a == 0x80) {
                a = 1;
            } else {
                a = 0;
            }
            push_pop(hl, de) {
                de = 10;
                hl += de;
                *hl = a;
            }
            // Size
            push_pop(hl) {
                push_pop(de) {
                    de = 8;
                    hl += de;
                }
                // -> size
                de++;
                a = *de;
                *hl = a;
                de++;
                hl++;
                a = *de;
                *hl = a;
            }
            // Date (3 byte)
            push_pop(hl) {
                push_pop(de) {
                    de = 13;
                    hl += de;
                }
                de++;
                // 1
                a = *de;
                *hl = a;
                de++;
                hl++;
                // 2
                a = *de;
                *hl = a;
                de++;
                hl++;
                // 3
                a = *de;
                *hl = a;
                de++;
                hl++;
            }
            // Name
            b = 8;
            do {
                a = *de;
                *hl = a;
                de++;
                hl++;
                b--;
            } while ((a = b) > 0);
        }
    } else {
        a = 0xFF; // ERROR
        parseFtpListBufferNext = a;
    }
}

void checkSumFtpListBuffer() {
    push_pop(de, bc) {
        de = ESP_I2S_BUFFER;
        c = 0;
        b = 14;
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

/// Парсинг пакета с данными скачиваемого файла
void ftpFileDownloadParse() {
    checkSumFtpFileDownload();
    if ((a = parseFtpFileLoadViewCheckSumState) == 1) {
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
                    if ((a = parseFtpFileLoadViewIsNextData) == 0x01) {
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
                    if ((a = parseFtpFileLoadViewIsNextData) == 0x5A) {
                        hl = ftpFileDownloadEnd;
                        ordos_stop();
                    }
                }
            }
        }
    } else {
        a = 0xFF;
        parseFtpFileLoadViewIsNextData = a;
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
                parseFtpFileLoadViewCheckSumState = a;
            } else {
                a = 0;
                parseFtpFileLoadViewCheckSumState = a;
            }
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
        hl = DiskViewStartNewFile;
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

/// Извлекает из A данные о прогрессе и Статус продолжение данных
/// первые 6 бит - прогресс.
/// последние 2 - статус продолжения. (0x80 - если еще есть данные. 0x40 - данные закончились. 0x00 - ошибка данных)
void ftpFileDownloadParseProgressAndNextA() {
    push_pop(bc) {
        b = a;
        a &= 0x3F;
        LoadViewProgress = a;
        //
        a = b;
        a &= 0xC0;
        b = a;
        // --
        if ((a = b) == 0x80) {
            a = 0x01;
            parseFtpFileLoadViewIsNextData = a;
        } else if ((a = b) == 0x40) {
            a = 0x5A;
            parseFtpFileLoadViewIsNextData = a;
        } else {
            a = 0xFF;
            parseFtpFileLoadViewIsNextData = a;
            a = 0;
            parseFtpFileLoadViewCheckSumState = a;
        }
    }
}

void SsidListNextParser() {
    SsidListNextParserCheckSum();
    if ((a = SsidListNextParserCheckSumState) == 1) {
        push_pop(de, bc) {
            de = ESP_I2S_BUFFER;
            // -- [0] = 1 Проверка
            a = *de;
            if (a == 0x01) {
                de++;
                //-- POS
                a = *de;
                SsidListNextParserPos = a;
                a += 1;
                WiFiNetworksViewSSIDCount = a;
                de++;
                //-- NEXT
                a = *de;
                SsidListNextParserNext = a;
                de++;
                // Подсчет указателя
                push_pop(de, hl) {
                    hl = WiFiNetworksViewSSIDList;
                    a = SsidListNextParserPos;
                    cyclic_rotate_left(a, 4);
                    e = a;
                    d = 0;
                    hl += de;
                    SsidListNextParserPoint = hl;
                }
            } else { // Что то не так, еще раз качаем
                a = 0;
                SsidListNextParserCheckSumState = a;
            }
        }
    }
}

void SsidListNextParserCheckSum() {
    push_pop(de, bc) {
        de = ESP_I2S_BUFFER;
        b = 3;
        c = 0;
        do {
            a = *de;
            a += c;
            c = a;
            de++;
            b--;
        } while ((a = b) > 0);
        a = *de;
        if (a == c) {
            a = 1;
            SsidListNextParserCheckSumState = a;
        } else {
            a = 0;
            SsidListNextParserCheckSumState = a;
        }
    }
}

/// Ответ от платы подтверждающий правильность получения данных
/// 1 byte :  0x01 - Error; 0xA5 - Ok; 0x03 - InternalError;
/// 2 byte : Test .... 0x55
/// 3 byte : SUM
void sendHLToAParser() {
    sendHLToAParserCheckSum();
    if ((a = sendHLToAParserCheckSumState) == 1) {
        push_pop(de) {
            de = ESP_I2S_BUFFER;
            //-- Ok/Error
            a = *de;
            if (a == 0x01) {
                a = 0;
                sendHLToAParserIsOk = a;
            } else if (a == 0xA5) {
                a = 1;
                sendHLToAParserIsOk = a;
            } else {
                a = 0;
                sendHLToAParserIsOk = a;
            }
            de++;
            //-- Test
            a = *de;
            if (a != 0x55) {
                a = 0;
                sendHLToAParserIsOk = a;
            }
        }
    } else {
        a = 0;
        sendHLToAParserIsOk = a;
    }
}

void sendHLToAParserCheckSum() {
    push_pop(de, bc) {
        de = ESP_I2S_BUFFER;
        //--
        b = 2;
        c = 0;
        do {
            a = *de;
            a += c;
            c = a;
            de++;
            b--;
        } while ((a = b) > 0);
        a = *de;
        if (a == c) {
            a = 1;
            sendHLToAParserCheckSumState = a;
        } else {
            a = 0;
            sendHLToAParserCheckSumState = a;
        }
    }
}

/// Get All State
/// 1 byte : Test = 0x55
/// 2 byre : All State : WIFIConnect = 0x01; FtpConnect = 0x02;
/// 3 byte : Reserved
/// 4 byte : SUM
void getAllStatusParser() {
    getAllStatusParserCheckSum();
    if ((a = allStatusParserCheckSumState) == 1) {
        push_pop(de, bc) {
            de = ESP_I2S_BUFFER;
            // Test byte
            a = *de;
            if (a == 0x55) {
                de++;
                // -- All State
                a = *de;
                b = a;
                // -- WIFIConnect
                a = b;
                a &= 0x01;
                ThreadsNetSetWiFiStateA();
                // -- FtpConnect
                a = b;
                a &= 0x02;
                cyclic_rotate_right(a, 1);
                ThreadsNetSetFtpStateA();
                // -- End state
                de++;
                // -- Reserve
            } else {
                a = 0;
                allStatusParserCheckSumState = a;
            }
        }
    }
}

void getAllStatusParserCheckSum() {
    push_pop(de, bc) {
        de = ESP_I2S_BUFFER;
        //--
        b = 3;
        c = 0;
        do {
            a = *de;
            a += c;
            c = a;
            de++;
            b--;
        } while ((a = b) > 0);
        a = *de;
        if (a == c) {
            a = 1;
            allStatusParserCheckSumState = a;
        } else {
            a = 0;
            allStatusParserCheckSumState = a;
        }
    }
}

uint8_t allStatusParserCheckSumState = 0;

uint8_t sendHLToAParserIsOk = 0;
uint8_t sendHLToAParserCheckSumState = 0;

uint8_t SsidListNextParserNext = 0;
uint8_t SsidListNextParserCheckSumState = 0;
uint8_t SsidListNextParserPos = 0;
uint16_t SsidListNextParserPoint = 0;

uint8_t ftpFileDownloadPropertySize = 0;
uint16_t ftpFileDownloadEnd = 0;
uint8_t ftpFileDownloadDataSize = 0;
uint16_t ftpFileLoadCurrentPos = 0;
uint8_t parseFtpFileLoadViewCheckSumState = 0;
uint8_t parseFtpFileLoadViewIsNextData = 0;

uint8_t parsePageBufferNext = 0;
uint8_t parsePageBufferIsCheck = 0;

uint8_t parseFtpListBufferIsCheck = 0;
uint8_t parseFtpListBufferNext = 0;

#endif /* ParseHelperFunctions_h */
