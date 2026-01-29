//
//  ParseHelperInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 21.01.2026.
//

#ifndef ParseHelperInclude_h
#define ParseHelperInclude_h

extern uint8_t parsePageBufferNext;
extern uint8_t parsePageBufferIsCheck;

extern uint8_t parseFtpListBufferIsCheck;
extern uint8_t parseFtpListBufferNext;

extern uint8_t parseFtpFileLoadViewCheckSumState;
extern uint8_t parseFtpFileLoadViewIsNextData;
extern uint16_t ftpFileLoadCurrentPos;
extern uint8_t ftpFileDownloadDataSize;
extern uint16_t ftpFileDownloadEnd;
extern uint8_t ftpFileDownloadPropertySize;

extern uint8_t SsidListNextParserNext;
extern uint8_t SsidListNextParserCheckSumState;
extern uint8_t SsidListNextParserPos;
extern uint16_t SsidListNextParserPoint;

extern uint8_t sendHLToAParserIsOk;
extern uint8_t sendHLToAParserCheckSumState;

/// Парсинг буфера от  API метода GET_NEXT_PAGE_BUFFER
/// вх. [HL] - Куда записывать результат
/// ESP_I2S_BUFFER - буфер где лежат полученные данные
void parsePageBuffer();
/// Парсинг буфера от  API метода GET_NEXT_PAGE_BUFFER
/// вх. [HL] - Куда записывать результат
/// ESP_I2S_BUFFER - буфер где лежат полученные данные
void parsePageNewBuffer();
void parsePageNewBufferOr01Or5A();

void parseFtpListBuffer();
void checkSumFtpListBuffer();

/// Парсинг пакета с данными скачиваемого файла
void ftpFileDownloadParse();
/// Подсчет контрольной суммы
void checkSumFtpFileDownload();
/// Извлекает из A данные по размерам пакета (свойства + буфер)
/// первые 3 бита - свойства, последние 5 - данные
/// (property & 0x07) + ((data & 0x1f)<<3);
void ftpFileDownloadParseSizePackA();
/// Считаем адрес куда писать данные на диск
void ftpFileDownloadCalkDiskPosToHL();
/// Извлекает из A данные о прогрессе и Статус продолжение данных
/// первые 6 бит - прогресс.
/// последние 2 - статус продолжения. (0x80 - если еще есть данные. 0x40 - данные закончились. 0x00 - ошибка данных)
void ftpFileDownloadParseProgressAndNextA();

void SsidListNextParser();
void SsidListNextParserCheckSum();

void sendHLToAParser();
void sendHLToAParserCheckSum();

#endif /* ParseHelperInclude_h */
