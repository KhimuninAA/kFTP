//
//  VBOXInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef VBOXInclude_h
#define VBOXInclude_h

/// Открыть окно
#define vboxOPN 0x80;
/// Очистка окна для Open
#define vboxCLW 0x40;
/// Рамка для Open
#define vboxFRM 0x20;
/// Тень для Open
#define vboxSDW 0x10;
/// Блокировка овосстановления окна для CLOSE
#define vboxBLW 0x10;
/// Сохранить окно в файле для Open
#define vboxSAV 0x08;
/// Стереть файл для CLOSE
#define vboxERA 0x08;
/// Распаковка знакогенератора (Самоуничтожение)
#define vboxUMP 0x04;

/// HL верхний левый угол
/// DE нижний правый
void vboxBorderHLDE();

extern uint8_t vboxFL[6];
extern uint16_t vboxAddr;

/// Загрузка драйвера VBOX, если не загружен
void validVBOX();
/// Загрузка
void loadVBOX();
void vboxOpen();
void vboxCall();
void vboxClose();
void vboxOpenHLDE();
void vboxClearCash();
/// HL верхний левый угол
/// DE нижний правый
/// C цвет
/// A как открывать
void vboxOpenHLDECA();

#endif /* VBOXInclude_h */
