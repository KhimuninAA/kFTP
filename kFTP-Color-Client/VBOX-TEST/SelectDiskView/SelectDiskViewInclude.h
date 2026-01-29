//
//  SelectDiskViewInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 21.01.2026.
//

#ifndef SelectDiskViewInclude_h
#define SelectDiskViewInclude_h

extern uint8_t SelectDiskViewX;
extern uint8_t SelectDiskViewY;
extern uint8_t SelectDiskViewDX;
extern uint8_t SelectDiskViewDY;
extern uint8_t SelectDiskViewColor;
extern uint8_t SelectDiskViewInvColor;

extern uint8_t SelectDiskViewCurrentPos;

extern uint8_t SelectDiskViewSelectTitle[7];
extern uint8_t SelectDiskViewSelectSubTitle[7];

void SelectDiskViewShow();
void SelectDiskViewKeyA();
void SelectDiskViewShowDiskList();
/// 0 - прямой
/// 1 - инверсный
void SelectDiskViewUpdateSelectA();
void SelectDiskViewSetCurrentPosA();

#endif /* SelectDiskViewInclude_h */
