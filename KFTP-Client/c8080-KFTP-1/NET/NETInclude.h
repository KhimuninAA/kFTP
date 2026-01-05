//
//  NETInclude.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 24.12.2025.
//

#ifndef NETInclude_h
#define NETInclude_h

/// Получаем список сетей
void getSSIDList();
/// Получить текущее имя сети
void getSSIDValue();
/// Запросить обновление списка сетей
void needUpdateSSIDList();
/// Подключиться в WiFi
void needSsidConnect();
/// Отправить пароль wifi
void setSSIDPasswordValue();
/// Получить пароль wifi
void getSSIDPasswordValue();
/// Установить имя сети по номеру в списке
/// вх. [A] - номер сети
void setSSIDNumberA();
/// Получить IP_Address
void getSSIDIPAddress();
/// Получить MAC_Address
void getSSIDMacAddress();
/// Получить STATE_SSID
void getSSIDState();

/// Получить FTP URL
void getFTPUrl();
/// Отправить FTP URL
void setFTPUrl();
/// Получить FTP User
void getFTPUser();
/// Отправить FTP User
void setFTPUser();
/// Получить FTP Password
void getFTPPassword();
/// Отправить FTP Password
void setFTPPassword();
/// Получить FTP Port
void getFTPPort();
/// Отправить FTP Port
void setFTPPort();

/// Подключиться в FTP
void needFtpConnect();
/// Получить статус FTP
void getFtpState();
/// обновить сисок FTP файлов
void updateFtpList();
/// Получаем список файлов и директорий в текущей папке
void getFtpList();

/// Указать какой файл скачивать
void ftpFileDownload();
/// Скачать указанный файл
void ftpFileDownloadNext();

/// Сменить директорию
void ftpChangeDirPos();
/// Сменить директорию вверх
void ftpChangeDirUp();
    
#endif /* NETInclude_h */
