//
//  NETInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 21.01.2026.
//

#ifndef NETInclude_h
#define NETInclude_h

extern uint16_t sendHLPoint;
extern uint8_t sendHLActionKey;

/// Сменить директорию
/// A - позиция
void ftpChangeDirPosA();
/// Сменить директорию вверх
void ftpChangeDirUp();
/// обновить сисок FTP файлов
void updateFtpList();
/// Получаем список файлов и директорий в текущей папке
void getNetFtpListNew();
/// Получить текущий путь FTP
void getFtpCurrentPathNew();
/// Загрузить данные (не больше 255) по адресу HL
/// вх. [HL] - Куда записывать результат
void loadStringToHL();
/// Загрузить данные (не больше 255) по адресу HL
/// вх. [HL] - Куда записывать результат
void loadNewStringToHL();
/// Указать какой файл скачивать
void ftpFileDownloadA();
/// Скачать указанный файл
void ftpFileDownloadNext();

/// Отправка 16 байт буфера из HL на плату
/// A - код операции
void sendHLToA();

///---------------
///--            WiFI      ---
///---------------

/// Получить текущее имя сети
void getSSIDValue();
/// Получить IP_Address
void getSSIDIPAddress();
/// Получить MAC_Address
void getSSIDMacAddress();
/// Получить WiFI пароль
void getSSIDPassword();
/// Получить статус WiFI TODO пепеделать!!!
void getWifiState();
/// Запросить обновление списка сетей
void needUpdateSSIDList();
/// Получить список сетей
void getSsidList();

/// Установить WiFI пароль
void setSSIDPassword();
/// Установить имя сети по номеру в списке
/// вх. [A] - номер сети
void setSSIDNumberA();

///---------------
///--            FTP       ---
///---------------

/// Получить статус FTP TODO пепеделать!!!
void getFtpState();
/// Получить FTP URL
void getFTPUrl();
/// Получить FTP HomeDir
void getFTPHomeDir();
/// Получить FTP Port
void getFTPPort();
/// Получить FTP User
void getFTPUser();
/// Получить FTP Password
void getFTPPassword();

/// Установить FTP HomeDir
void setFtpHomeDir();
/// Установить FTP Password
void setFtpPassword();
/// Установить FTP User
void setFtpUser();
/// Установить FTP ServerUrl
void setFtpServerUrl();
/// Установить FTP Port
void setFtpPort();

///---------------
///--     Connect       ---
///---------------

/// Подключиться в WiFi
void needSsidConnect();
/// Подключиться в FTP
void needFtpConnect();

#endif /* NETInclude_h */
