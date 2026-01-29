//
//  DiskViewInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef DiskViewInclude_h
#define DiskViewInclude_h

extern uint8_t DiskViewX;
extern uint8_t DiskViewY;
extern uint8_t DiskViewDX;
extern uint8_t DiskViewDY;
extern uint8_t DiskViewColor;
extern uint8_t DiskViewInvColor;
extern uint8_t DiskViewDiskNum;
extern uint8_t DiskViewDirCount;
extern uint16_t DiskViewDirBufer;
extern uint8_t DiskViewFileCurrentPos;
extern uint16_t DiskViewStartNewFile;

extern uint8_t DiskViewTitle[9];
extern uint8_t DiskViewDirRootTitle[3];

void DiskViewShow();
void DiskViewShowTitle();
void DiskViewUpdateDir();
void DiskViewShowDir();
void DiskViewKeyA();
/// Обновление позиции
/// вх[A]
/// 0 - без изменений
/// 1 - вверх
/// 0xFF - вниз
void DiskViewFileCurrentPosUpdateA();
/// Рисование линии прямым или инверсным цветом
/// 0 - прямой
/// 1 - инверсный
void DiskViewShowSelectLineA();
void DiskViewNextDiskNum();
void DiskViewSetDiskNumA();
void DiskViewUpdateDiskTitle();
void DiskViewUpdateDateAndUI();

#endif /* DiskViewInclude_h */
