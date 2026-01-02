//
//  NETFunctions.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 24.12.2025.
//

#ifndef NETFunctions_h
#define NETFunctions_h

/// Получаем список сетей
void getSSIDList() {
    // Получить ответ
    // Ответ ESP_I2S_BUFFER
    // SSIDList буфер заполнения
    push_pop(bc) {
        do {
            //
            delay5msI2C();
            i2cWaitingForAccess();
            l = 5;
            h = 0;
            sendCommand();
            //
            delay5msI2C();
            i2cWaitingForAccess();
            l = 22;
            readNewInBuffer();
            push_pop(a) {
                push_pop(de) {
                    push_pop(hl) {
                        de = ESP_I2S_BUFFER;
                        a = *de; // позиция
                        carry_rotate_left(a, 4);
                        c = a;
                        // смещаем адрес буфера на 16 * на позицию
                        b = 0;
                        hl = SSIDList;
                        hl += bc;
                        //
                        de++;
                        a = *de; // flag
                        SSIDListNext = a;
                        de++;
                        // copy 16 byte
                        b = 16;
                        do {
                            a = *de;
                            *hl = a;
                            de++;
                            hl++;
                            b--;
                        } while (flag_nz);
                    }
                }
            }
            a = SSIDListNext;
        } while (a != 0);
    }
}

/// Получить текущее имя сети
void getSSIDValue() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                delay5msI2C();
                i2cWaitingForAccess();
                l = 6;
                h = 0;
                sendCommand();
                
                delay5msI2C();
                
                i2cWaitingForAccess();
                l = 26;
                readNewInBuffer();
                
                de = ESP_I2S_BUFFER;
                hl = wifiSettingsSsidVal;
                b = 16;
                do {
                    a = *de;
                    *hl = a;
                    de++;
                    hl++;
                    b--;
                } while (flag_nz);
            }
        }
    }
}

/// Получить пароль wifi
void getSSIDPasswordValue() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                delay5msI2C();
                i2cWaitingForAccess();
                l = 8;
                h = 0;
                sendCommand();
                
                delay5msI2C();
                
                i2cWaitingForAccess();
                l = 26;
                readNewInBuffer();
                
                de = ESP_I2S_BUFFER;
                hl = wifiSettingsEditViewSSIDPasswordVal;
                b = 16;
                do {
                    a = *de;
                    if(a==0xFF){
                        a = 0x00;
                    }
                    *hl = a;
                    de++;
                    hl++;
                    b--;
                } while (flag_nz);
            }
        }
    }
}

/// Отправить пароль wifi
void setSSIDPasswordValue() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                de = wifiSettingsEditViewSSIDPasswordVal;
                hl = ESP_I2S_BUFFER;
                b = 16;
                c = 0;
                do {
                    a = *de;
                    if ((a = c) == 1) {
                        a = 0xFF;
                    } else if((a = *de) == 0) {
                        c = 1;
                        a = 0x00;
                    }
                    *hl = a;
                    de++;
                    hl++;
                    b--;
                } while (flag_nz);
                
                delay5msI2C();
                i2cWaitingForAccess();
                l = 9;
                h = 16;
                sendCommand();
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

/// Получить IP_Address
void getSSIDIPAddress() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                delay5msI2C();
                i2cWaitingForAccess();
                l = 12;
                h = 0;
                sendCommand();
                //
                delay5msI2C();
                i2cWaitingForAccess();
                l = 26;
                readNewInBuffer();
                //
                de = ESP_I2S_BUFFER;
                hl = wifiSettingsIpVal;
                b = 16;
                do {
                    a = *de;
                    if(a==0xFF){
                        a = 0x00;
                    }
                    *hl = a;
                    de++;
                    hl++;
                    b--;
                } while (flag_nz);
            }
        }
    }
}

/// Получить MAC_Address
void getSSIDMacAddress() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                delay5msI2C();
                i2cWaitingForAccess();
                l = 13;
                h = 0;
                sendCommand();
                //
                delay5msI2C();
                i2cWaitingForAccess();
                l = 26;
                readNewInBuffer();
                //
                de = ESP_I2S_BUFFER;
                hl = wifiSettingsMacVal;
                b = 18;
                do {
                    a = *de;
                    if(a==0xFF){
                        a = 0x00;
                    }
                    *hl = a;
                    de++;
                    hl++;
                    b--;
                } while (flag_nz);
            }
        }
    }
}

/// Получить STATE_SSID
void getSSIDState() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                delay5msI2C();
                i2cWaitingForAccess();
                l = 11;
                h = 0;
                sendCommand();
                //
                delay5msI2C();
                i2cWaitingForAccess();
                l = 4;
                readNewInBuffer();
                //
                a = WiFiState;
                h = a;
                de = ESP_I2S_BUFFER;
                a = *de;
                a &= 0x01;
                WiFiState = a;
                if(a != h){
                    a = 0x01;
                    WiFiStateUpdate = a;
                }
            }
        }
    }
}

/// FTP

/// Получить FTP URL
void getFTPUrl() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                delay5msI2C();
                i2cWaitingForAccess();
                l = 2;
                h = 0;
                sendCommand();
                //
                delay5msI2C();
                i2cWaitingForAccess();
                l = 26;
                readNewInBuffer();
                //
                de = ESP_I2S_BUFFER;
                hl = ftpSettingsIpValue;
                b = 16;
                do {
                    a = *de;
                    if(a==0xFF){
                        a = 0x00;
                    }
                    *hl = a;
                    de++;
                    hl++;
                    b--;
                } while (flag_nz);
            }
        }
    }
}

/// Отправить FTP URL
void setFTPUrl() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                de = ftpSettingsIpValue;
                hl = ESP_I2S_BUFFER;
                b = 16;
                c = 0;
                do {
                    a = *de;
                    if ((a = c) == 1) {
                        a = 0xFF;
                    } else if((a = *de) == 0) {
                        c = 1;
                        a = 0x00;
                    }
                    *hl = a;
                    de++;
                    hl++;
                    b--;
                } while (flag_nz);
                
                delay5msI2C();
                i2cWaitingForAccess();
                l = 3;
                h = 16;
                sendCommand();
            }
        }
    }
}

/// Получить FTP User
void getFTPUser() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                delay5msI2C();
                i2cWaitingForAccess();
                l = 18;
                h = 0;
                sendCommand();
                //
                delay5msI2C();
                i2cWaitingForAccess();
                l = 26;
                readNewInBuffer();
                //
                de = ESP_I2S_BUFFER;
                hl = ftpSettingsUserValue;
                b = 16;
                do {
                    a = *de;
                    if(a==0xFF){
                        a = 0x00;
                    }
                    *hl = a;
                    de++;
                    hl++;
                    b--;
                } while (flag_nz);
            }
        }
    }
}

/// Отправить FTP User
void setFTPUser() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                de = ftpSettingsUserValue;
                hl = ESP_I2S_BUFFER;
                b = 16;
                c = 0;
                do {
                    a = *de;
                    if ((a = c) == 1) {
                        a = 0xFF;
                    } else if((a = *de) == 0) {
                        c = 1;
                        a = 0x00;
                    }
                    *hl = a;
                    de++;
                    hl++;
                    b--;
                } while (flag_nz);
                
                delay5msI2C();
                i2cWaitingForAccess();
                l = 19;
                h = 16;
                sendCommand();
            }
        }
    }
}

/// Получить FTP Password
void getFTPPassword() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                delay5msI2C();
                i2cWaitingForAccess();
                l = 20;
                h = 0;
                sendCommand();
                //
                delay5msI2C();
                i2cWaitingForAccess();
                l = 26;
                readNewInBuffer();
                //
                de = ESP_I2S_BUFFER;
                hl = ftpSettingsEditViewPasswordVal;
                b = 16;
                do {
                    a = *de;
                    if(a==0xFF){
                        a = 0x00;
                    }
                    *hl = a;
                    de++;
                    hl++;
                    b--;
                } while (flag_nz);
            }
        }
    }
}

/// Отправить FTP Password
void setFTPPassword() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                de = ftpSettingsEditViewPasswordVal;
                hl = ESP_I2S_BUFFER;
                b = 16;
                c = 0;
                do {
                    a = *de;
                    if ((a = c) == 1) {
                        a = 0xFF;
                    } else if((a = *de) == 0) {
                        c = 1;
                        a = 0x00;
                    }
                    *hl = a;
                    de++;
                    hl++;
                    b--;
                } while (flag_nz);
                
                delay5msI2C();
                i2cWaitingForAccess();
                l = 21;
                h = 16;
                sendCommand();
            }
        }
    }
}

/// Получить FTP Port
void getFTPPort() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                delay5msI2C();
                i2cWaitingForAccess();
                l = 16;
                h = 0;
                sendCommand();
                //
                delay5msI2C();
                i2cWaitingForAccess();
                l = 10;
                readNewInBuffer();
                //
                de = ESP_I2S_BUFFER;
                hl = ftpSettingsPortValue;
                b = 6;
                do {
                    a = *de;
                    if(a==0xFF){
                        a = 0x00;
                    }
                    *hl = a;
                    de++;
                    hl++;
                    b--;
                } while (flag_nz);
            }
        }
    }
}

/// Отправить FTP Port
void setFTPPort() {
    push_pop(hl) {
        push_pop(de) {
            push_pop(bc) {
                de = ftpSettingsPortValue;
                hl = ESP_I2S_BUFFER;
                b = 6;
                c = 0;
                do {
                    a = *de;
                    if ((a = c) == 1) {
                        a = 0xFF;
                    } else if((a = *de) == 0) {
                        c = 1;
                        a = 0x00;
                    }
                    *hl = a;
                    de++;
                    hl++;
                    b--;
                } while (flag_nz);
                
                delay5msI2C();
                i2cWaitingForAccess();
                l = 17;
                h = 6;
                sendCommand();
            }
        }
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

/// Получить статус FTP
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
                a = ftpSettingsStateVal;
                h = a;
                de = ESP_I2S_BUFFER;
                a = *de;
                a &= 0x01;
                ftpSettingsStateVal = a;
                if(a != h){
                    a = 0x01;
                    ftpSettingsStateChange = a;
                }
            }
        }
    }
}

/// обновить сисок FTP файлов
void updateFtpList() {
    push_pop(hl) {
        a = 0;
        ftpDirListCount = a;
        delay5msI2C();
        i2cWaitingForAccess();
        l = 25;
        h = 0;
        sendCommand();
    }
}

void convert4bitToCharA() {
    if (a < 10) {
        a += 0x30;
    } else {
        a += 0x37;
    }
}

/// Получаем список файлов и директорий в текущей папке
void getFtpList() {
    // Получить ответ
    // Ответ ESP_I2S_BUFFER
    // ftpDirList буфер заполнения
    push_pop(bc) {
        do {
            //
            delay5msI2C();
            i2cWaitingForAccess();
            l = 26;
            h = 0;
            sendCommand();
            //
            delay5msI2C();
            i2cWaitingForAccess();
            l = 26;
            readNewInBuffer();
            push_pop(a) {
                push_pop(de) {
                    push_pop(hl) {
                        parceBufferToFile();
                    }
                }
            }
            a = ftpDirListNext;
        } while (a == 1);
    }
}

/// Указать какой файл скачивать
void ftpFileDownload() {
    push_pop(de) {
        push_pop(hl) {
            de = ESP_I2S_BUFFER;
            a = ftpViewCurrentPos;
            *de = a;
            //
            delay5msI2C();
            i2cWaitingForAccess();
            //
            l = 28; // FILE_DOWNLOAD
            h = 1; // 1 байт
            sendCommand();
        }
    }
}

/// Скачать указанный файл
void ftpFileDownloadNext() {
    push_pop(hl) {
        a = 0x01;
        ftpFileLoadViewCheckSumState = a;
        do {
            // Если контрольная сумма верна просим следующий буфер
            if ((a = ftpFileLoadViewCheckSumState) == 0x01) {
                delay5msI2C();
                i2cWaitingForAccess();
                l = 29;
                h = 0;
                sendCommand();
            }
            
            // Получить буфер
            delay5msI2C();
            i2cWaitingForAccess();
            l = 30;
            h = 0;
            sendCommand();
            //
            delay5msI2C();
            i2cWaitingForAccess();
            l = 15; //(12) //26; (20)
            readNewInBuffer();
            
            // Распарсить буфер и пррверить контрольную сумму
            ftpFileLoadViewParce();
            
        } while ((a = ftpFileLoadViewIsNextData) == 1);
    }
}

#endif /* NETFunctions_h */
