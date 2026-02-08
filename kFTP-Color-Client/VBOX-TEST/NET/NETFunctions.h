//
//  NETFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 21.01.2026.
//

#ifndef NETFunctions_h
#define NETFunctions_h

/// Сменить директорию
/// A - позиция
void ftpChangeDirPosA() {
    push_pop(de) {
        push_pop(hl) {
            de = ESP_I2S_BUFFER;
            *de = a;
            //
            delay5msI2C();
            i2cWaitingForAccess();
            //
            l = 32; // FTP_DIR_INDEX
            h = 1; // 1 байт
            sendCommand();
            
            delay5msI2C();
            i2cWaitingForAccess();
            busRecoveryI2C();
        }
    }
}

/// Сменить директорию вверх
void ftpChangeDirUp() {
    push_pop(de) {
        push_pop(hl) {
            delay5msI2C();
            i2cWaitingForAccess();
            //
            l = 31; // FTP_DIR_UP
            h = 0;
            sendCommand();
            
            delay5msI2C();
            i2cWaitingForAccess();
            busRecoveryI2C();
        }
    }
}

/// обновить сисок FTP файлов
void updateFtpList() {
    push_pop(hl, de) {
        //
        de = ESP_I2S_BUFFER;
        a = 20; // Получить 20 файлов
        *de = a;
        //
        a = 0;
        FtpViewFilesListCount = a;
        delay5msI2C();
        i2cWaitingForAccess();
        l = 25;
        h = 1; // Есть что передать
        sendCommand();
        
        delay5msI2C();
        i2cWaitingForAccess();
        busRecoveryI2C();
    }
}

/// Получаем список файлов и директорий в текущей папке
void getNetFtpListNew() {
    //-- Lock
    if ((a = NetIsLock) == 1) {
        return;
    }
    a = 1;
    NetIsLock = a;
    //--
    a = 0;
    parseFtpListBufferIsCheck = a;
    do {
        push_pop(hl) {
            if ((a = parseFtpListBufferIsCheck) == 1) {
                delay5msI2C();
                i2cWaitingForAccess();
                l = 36; //GET_FTP_LIST_NEXT_NEW, // 36
                h = 0;
                sendCommand();
            }
            
            delay5msI2C();
            i2cWaitingForAccess();
            l = 37; //GET_FTP_LIST_NEW, // 37
            h = 0;
            sendCommand();
            //
            delay5msI2C();
            i2cWaitingForAccess();
            l = 15;
            readNewInBuffer();
            
            parseFtpListBuffer();
        }
    } while ((a = parseFtpListBufferNext) != 0x5A);
    a = FtpViewFilesListCount;
    a++;
    FtpViewFilesListCount = a;
    //-- Lock
    a = 0;
    NetIsLock = a;
    //--
}

/// Получить текущий путь FTP
void getFtpCurrentPathNew() {
    push_pop(hl) {
        do {
            delay5msI2C();
            i2cWaitingForAccess();
            l = 38; //GET_FTP_DIR_NEW, // 38
            h = 0;
            sendCommand();
            //
            loadStringToHL(hl = FtpViewPath);
        } while ((a = parsePageBufferIsCheck) != 1);
    }
}

/// Загрузить данные (не больше 255) по адресу HL
/// вх. [HL] - Куда записывать результат
void loadStringToHL() {
    do {
        push_pop(hl) {
            // Получить новый буфер
            delay5msI2C();
            i2cWaitingForAccess();
            l = 34; //GET_NEXT_PAGE_BUFFER, // 34
            h = 0;
            sendCommand();
            //
            delay5msI2C();
            i2cWaitingForAccess();
            l = 15;
            readNewInBuffer(); //ESP_I2S_BUFFER
        }
        // Parse ESP_I2S_BUFFER
        parsePageBuffer();
    } while ((a = parsePageBufferNext) != 0x5A);
}

/// Загрузить данные (не больше 255) по адресу HL
/// вх. [HL] - Куда записывать результат
void loadNewStringToHL() {
    do {
        push_pop(hl) {
            // Получить новый буфер
            delay5msI2C();
            i2cWaitingForAccess();
            l = 47; //GET_NEXT_PAGE_BUFFER_NEW, // 47
            h = 0;
            sendCommand();
            //
            delay5msI2C();
            i2cWaitingForAccess();
            l = 15;
            readNewInBuffer(); //ESP_I2S_BUFFER
        }
        // Parse ESP_I2S_BUFFER
        parsePageNewBuffer();
        // Если нет ошибок, то следующие данные
        if ((a = parsePageBufferIsCheck) == 1) {
            push_pop(hl) {
                delay5msI2C();
                i2cWaitingForAccess();
                l = 48; //GET_NEXT_PAGE_BUFFER_NEW_INC, // 48
                h = 0;
                sendCommand();
            }
        }
    } while ((a = parsePageBufferNext) != 0x5A);
}

/// Указать какой файл скачивать
void ftpFileDownloadA() {
    push_pop(de, hl) {
        de = ESP_I2S_BUFFER;
        *de = a;
        //
        i2cWaitingForAccess();
        //
        l = 28; // FILE_DOWNLOAD
        h = 1; // 1 байт
        sendCommand();
    }
}

/// Скачать указанный файл
void ftpFileDownloadNext() {
    push_pop(hl) {
        a = 0x01;
        parseFtpFileLoadViewCheckSumState = a;
        a = 0;
        NetError = a;
        a = 10;
        NetLoopCount = a;
        do {
            // Если контрольная сумма верна просим следующий буфер
            if ((a = parseFtpFileLoadViewCheckSumState) == 0x01) {
                a = 10;
                NetLoopCount = a;
                //--
                i2cWaitingForAccess();
                l = 29;
                h = 0;
                sendCommand();
            } else {
                a = NetLoopCount;
                a--;
                NetLoopCount = a;
                if (a == 0) {
                    a = 1;
                    NetError = a;
                }
            }
            
            if ((a = NetError) == 0) {
                // Получить буфер
                //i2cWaitingForAccess();
                l = 30;
                h = 0;
                sendCommand();
                //
                //delay5msI2C();
                //i2cWaitingForAccess();
                l = 15;
                readNewInBuffer();
                
                // Распарсить буфер и пррверить контрольную сумму
                ftpFileDownloadParse();
                if ((a = parseFtpFileLoadViewCheckSumState) == 0x01) {
                    LoadViewShowProgressA(a = LoadViewProgress);
                }
            } else {
                // Error!!!!
                a = 0x5A;
                parseFtpFileLoadViewIsNextData = a;
            }
        } while ((a = parseFtpFileLoadViewIsNextData) != 0x5A);
    }
}

/// Получить текущее имя сети
void getSSIDValue() {
    push_pop(hl) {
        do {
            delay5msI2C();
            i2cWaitingForAccess();
            l = 6;
            h = 0;
            sendCommand();
            //
            loadStringToHL(hl = WifiStateViewSsidVal);
        } while ((a = parsePageBufferIsCheck) != 1);
    }
}

/// Получить IP_Address
void getSSIDIPAddress() {
    push_pop(hl) {
        do {
            delay5msI2C();
            i2cWaitingForAccess();
            l = 12;
            h = 0;
            sendCommand();
            //
            loadStringToHL(hl = WifiStateViewIpVal);
        } while ((a = parsePageBufferIsCheck) != 1);
    }
}

/// Получить WiFI пароль
void getSSIDPassword() {
    push_pop(hl) {
        do {
            delay5msI2C();
            i2cWaitingForAccess();
            l = 40; // GET_SSID_PASSWORD_NEW, // 40
            h = 0;
            sendCommand();
            //
            loadStringToHL(hl = WifiStateViewPassVal);
        } while ((a = parsePageBufferIsCheck) != 1);
    }
}

/// Запросить обновление списка сетей
void needUpdateSSIDList() {
    push_pop(hl) {
        delay5msI2C();
        i2cWaitingForAccess();
        l = 4;
        h = 0;
        sendCommand();
    }
}

/// Получить список сетей
void getSsidList() {
    push_pop(hl) {
        do {
            // Получаем данные пл пакету
            do {
                i2cWaitingForAccess();
                l = 42; //GET_SSID_NEW_LIST_NEXT, // 42
                h = 0;
                sendCommand();
                //
                //delay5msI2C();
                i2cWaitingForAccess();
                l = 6;
                readNewInBuffer();
                SsidListNextParser();
            } while ((a = SsidListNextParserCheckSumState) == 0);
            // Получаем строку с именем сети
            loadNewStringToHL(hl = SsidListNextParserPoint);
            // Просим следующий
            i2cWaitingForAccess();
            l = 46; //GET_SSID_NEW_LIST_Next_Inc, // 46
            h = 0;
            sendCommand();
        } while ((a = SsidListNextParserNext) != 0x5A);
    }
}

/// Получить статус WiFI TODO пепеделать!!!
void getWifiState() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                delay5msI2C();
                i2cWaitingForAccess();
                l = 11; // STATE_SSID, //11
                h = 0;
                sendCommand();
                //
                delay5msI2C();
                i2cWaitingForAccess();
                l = 3;
                readNewInBuffer();
                //
                a = WifiStateViewSSIDIsConnected;
                h = a;
                de = ESP_I2S_BUFFER;
                a = *de;
                a &= 0x01;
                WifiStateViewSSIDIsConnected = a;
                if(a != h){
                    a = 0x01;
                    WiFiNetStateChange = a;
                }
            }
        }
    }
}

/// Получить MAC_Address
void getSSIDMacAddress() {
    push_pop(hl) {
        do {
            delay5msI2C();
            i2cWaitingForAccess();
            l = 13;
            h = 0;
            sendCommand();
            //
            loadStringToHL(hl = WifiStateViewMacVal);
        } while ((a = parsePageBufferIsCheck) != 1);
    }
}

/// Получить статус FTP TODO пепеделать!!!
void getFtpState() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                delay5msI2C();
                i2cWaitingForAccess();
                l = 24;
                h = 0;
                sendCommand();
                //
                delay5msI2C();
                i2cWaitingForAccess();
                l = 4;
                readNewInBuffer();
                //
                a = FtpStateViewStatus;
                h = a;
                de = ESP_I2S_BUFFER;
                a = *de;
                a &= 0x01;
                FtpStateViewStatus = a;
                if(a != h){
                    a = 0x01;
                    FtpNetStateChange = a;
                }
            }
        }
    }
}

/// Подключиться в WiFi
void needSsidConnect() {
    push_pop(hl) {
        delay5msI2C();
        i2cWaitingForAccess();
        l = 10;
        h = 0;
        sendCommand();
    }
}

/// Подключиться в FTP
void needFtpConnect() {
    push_pop(hl) {
        delay5msI2C();
        i2cWaitingForAccess();
        l = 23;
        h = 0;
        sendCommand();
    }
}

/// Получить FTP URL
void getFTPUrl() {
    push_pop(hl) {
        do {
            delay5msI2C();
            i2cWaitingForAccess();
            l = 39; //GET_FTPURL_NEW, // 39
            h = 0;
            sendCommand();
            //
            loadStringToHL(hl = FtpStateViewIpValue);
        } while ((a = parsePageBufferIsCheck) != 1);
    }
}

/// Получить FTP HomeDir
void getFTPHomeDir() {
    push_pop(hl) {
        do {
            delay5msI2C();
            i2cWaitingForAccess();
            l = 41; //GET_FTP_HOMEDIR_NEW, // 41
            h = 0;
            sendCommand();
            //
            loadStringToHL(hl = FtpSettingsViewValueHomeDir);
        } while ((a = parsePageBufferIsCheck) != 1);
    }
}

/// Получить FTP Port
void getFTPPort() {
    push_pop(hl) {
        do {
            delay5msI2C();
            i2cWaitingForAccess();
            l = 43; //GET_FTP_Port_NEW, // 43
            h = 0;
            sendCommand();
            //
            loadStringToHL(hl = FtpSettingsViewValuePort);
        } while ((a = parsePageBufferIsCheck) != 1);
    }
}

/// Получить FTP User
void getFTPUser() {
    push_pop(hl) {
        do {
            delay5msI2C();
            i2cWaitingForAccess();
            l = 44; //GET_FTP_User_NEW, // 44
            h = 0;
            sendCommand();
            //
            loadStringToHL(hl = FtpSettingsViewValueUser);
        } while ((a = parsePageBufferIsCheck) != 1);
    }
}

/// Получить FTP Password
void getFTPPassword() {
    push_pop(hl) {
        do {
            delay5msI2C();
            i2cWaitingForAccess();
            l = 45; //GET_FTP_Password_NEW, // 45
            h = 0;
            sendCommand();
            //
            loadStringToHL(hl = FtpSettingsViewValuePass);
        } while ((a = parsePageBufferIsCheck) != 1);
    }
}

/// Установить имя сети по номеру в списке
/// вх. [A] - номер сети
void setSSIDNumberA() {
    push_pop(de) {
        push_pop(hl) {
            de = ESP_I2S_BUFFER;
            *de = a;
            //
            delay5msI2C();
            i2cWaitingForAccess();
            //
            l = 7; // SET_SSID
            h = 1; // 1 байт
            sendCommand();
        }
    }
}

/// Отправка 16 байт буфера из HL на плату
/// A - код операции
/// ------ Структура ---------------
/// 1 byte : Action
/// 2 byte : Next (0x01 = Next; 0x5A - Stop)
/// 3..10 bytes : Data
/// 11 byte : SUM
void sendHLToA() {
    push_pop(bc, de, hl) {
        // Calc
        sendHLActionKey = a;
        sendHLPoint = hl;
        // Send
        c = 0;
        do {
            hl = sendHLPoint;
            if ((a = c) == 1) {
                de = 8;
                hl += de;
            }
            // -- Create buffer
            de = ESP_I2S_BUFFER;
            // Action
            a = sendHLActionKey;
            *de = a;
            de++;
            // Next
            if ((a = c) == 0) {
                a = 0x01;
            } else {
                a = 0x5A;
            }
            *de = a;
            de++;
            // Data
            b = 8;
            do {
                a = *hl;
                *de = a;
                de++;
                hl++;
                b--;
            } while ((a = b) > 0);
            // SUM
            de = ESP_I2S_BUFFER;
            b = 10;
            h = 0;
            do {
                a = *de;
                a += h;
                h = a;
                de++;
                b--;
            } while ((a = b) > 0);
            a = h;
            *de = a;
            // -- Send
            push_pop(hl) {
                i2cWaitingForAccess();
                l = 49; // SET_STR16_FOR_KEY_PAGE, // 49
                h = 11;
                sendCommand();
            }
            // -- Get status
            push_pop(hl) {
                // Получаем ответ
                do {
                    i2cWaitingForAccess();
                    l = 50; // GET_STR16_FOR_KEY_PAGE_STATE, // 50
                    h = 0;
                    sendCommand();
                    //
                    i2cWaitingForAccess();
                    l = 4;
                    readNewInBuffer();
                    sendHLToAParser();
                } while ((a = sendHLToAParserCheckSumState) == 0);
                // Если ОК , то следующая операция
                if ((a = sendHLToAParserIsOk) == 1) {
                    c++;
                }
            }
            // --
        } while ((a = c) < 2);
    }
}

/// Установить WiFI пароль
void setSSIDPassword() {
    push_pop(hl) {
        hl = WifiStateViewPassVal;
        sendHLToA(a = 0); // Action_SET_SSID_PASSWORD = 0, // 0
    }
}

/// Установить FTP HomeDir
void setFtpHomeDir() {
    push_pop(hl) {
        hl = FtpSettingsViewValueHomeDir;
        sendHLToA(a = 2); // Action_SET_FTP_HomeDir, // 2
    }
}

/// Установить FTP Password
void setFtpPassword() {
    push_pop(hl) {
        hl = FtpSettingsViewValuePass;
        sendHLToA(a = 1); // Action_SET_FTP_PASSWORD, // 1
    }
}

/// Установить FTP User
void setFtpUser() {
    push_pop(hl) {
        hl = FtpSettingsViewValueUser;
        sendHLToA(a = 3); // Action_SET_FTP_ftpUser, // 3
    }
}

/// Установить FTP ServerUrl
void setFtpServerUrl() {
    push_pop(hl) {
        hl = FtpStateViewIpValue;
        sendHLToA(a = 4); // Action_SET_FTP_ServerUrl, // 4
    }
}

/// Установить FTP Port
void setFtpPort() {
    push_pop(hl) {
        hl = FtpSettingsViewValuePort;
        sendHLToA(a = 5); // Action_SET_FTP_Port, // 5
    }
}

/// Получить все статусы
void getAllStatus() {
    //-- Lock
    if ((a = NetIsLock) == 1) {
        return;
    }
    a = 1;
    NetIsLock = a;
    //--
    push_pop(hl) {
        a = 10;
        NetLoopCount = a;
        do {
            l = 51; //GET_ALL_STATE, // 51
            h = 0;
            sendCommand();
            //
            l = 5;
            readNewInBuffer();
            getAllStatusParser();
            //-- MAX LOOP
            a = NetLoopCount;
            a--;
            NetLoopCount = a;
            if (a == 0) {
                a = 1;
                allStatusParserCheckSumState = a;
            }
            //--
        } while ((a = allStatusParserCheckSumState) == 0);
    }
    //-- Lock
    a = 0;
    NetIsLock = a;
    //--
}

/// Перейти на домашную папку
void setFtpGoToHomeDir() {
    push_pop(hl) {
        l = 52; //SET_FTP_GO_HOME_DIR, // 52
        h = 0;
        sendCommand();
    }
}

uint8_t NetIsLock = 0;
/// 0 - нет ошибки;
/// 1 - превышено кол-во попыток
uint8_t NetError = 0;
uint8_t NetLoopCount = 0;

uint16_t sendHLPoint = 0x0000;
uint8_t sendHLActionKey = 0;

#endif /* NETFunctions_h */
