//
//  MyFontInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef MyFontInclude_h
#define MyFontInclude_h

extern uint8_t myCharPosX;
extern uint8_t myCharPosY;

void printMyUTF8HLStr();
void printMyHLStr();
/// Выводит строку из HL с текущего положения
/// Длиной A. Если текст короче , то добиват до A пробелами
void printMyHLStrLenA();
/// Выводит строку из HL с текущего положения заменяя все символы *
/// Длиной A. Если текст короче , то добиват до A пробелами
void printMyHLPassLenA();
void printMyChatA();
void myCharPosXSpaceA();
void myCharPosYSpaceA();
void printMyHexA();
/// Вывести на экран значение A как десятичное число
/// A не больше 99 или 0x63
/// Если больше - ничего не выводит
void printMyAsDec99A();
/// Вывести на экран значение A как десятичное число с ведущими нулями
/// A не больше 99 или 0x63
/// Если больше - ничего не выводит
void printMyAs00Dec99A();
/// Вывести на экран значение HL как десятичное число
/// A не больше 4095 или 0x0FFF
/// Если больше - ничего не выводит
void printMyAsDec4095HL();
/// Спавнение HL и DE
/// CF=1 when DE < HL
/// CF=0 DE >= HL
void compareHlDe();

#endif /* MyFontInclude_h */
