//
//  Monitor.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 16.09.2025.
//

#ifndef monitor_h
#define monitor_h

///ячейка, в которой хранится начальный адрес знакогенератора
extern uint16_t fontAddress __address(0xF3D1);
///ячейка, хранящая признак прямого (00Н) вывода (светлые символы на темном фоне) или инверсного (0FFH) вывода (темные символы на светлом фоне)
extern uint16_t inverceAddress __address(0xF3D3);

///-----* Функции Монитора *-------
///Вывод на экран HEX из регистра A
void printHexA() __address(0xF815);
///Вывод символа на экран из регистра A
void printChatA() __address(0xF80F);
///Вывод символа на экран из регистра С
void printChatC() __address(0xF809);
///ЗАПИСЬ БАЙТА В ДОП. СТРАНИЦУ HL — АДРЕСА — N СТРАНИЦЫ (0-3) C — ЗАПИСЫВАЕМЫЙ БАЙТ
void writeByteInOtherMem() __address(0xF839);
///УСТАНОВКА КУРСОРА ВХ. Н — НОМЕР СТРОКИ — Y L — НОМЕР ПОЗИЦИИ — X
void setPosCursor() __address(0xF83C);
///ЗАПРОС ПОЛОЖЕНИЯ КУРСОРА Н - НОМЕР СТРОКИ - Y , L - НОМЕР ПОЗИЦИИ - X
void getPosCursor() __address(0xF81E);
///ВЫВОД НА ЭКРАН СООБЩЕНИЯ ВХ.: HL- - АДРЕС НАЧАЛА КОНЕЧНЫЙ БАЙТ - 00Н
void printHLStr() __address(0xF818);

///ВВОД C СИМВОЛА С КЛАВИАТУРЫ А - ВВЕДЕННЫЙ СИМВОЛ
void getKeyboardCharA() __address(0xF803);
///ОПРОС СОСТОЯНИЯ КЛАВИАТУРЫ А = 00Н - НЕ НАЖАТА , А = 0FFH - НАЖАТА
void getKeyboardStateA() __address(0xF812);
///ВВОД КОДА НАЖАТОЙ КЛАВИШИ А = 0FFH - НЕ НАЖАТА А = 0FEH - РУС/ЛАТ ИНАЧЕ - КОД КЛАВИШИ
void getKeyboardCodeA() __address(0xF81B);

#endif /* monitor_h */
