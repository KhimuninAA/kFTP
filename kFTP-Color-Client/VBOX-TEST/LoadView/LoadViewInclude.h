//
//  LoadViewInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 22.01.2026.
//

#ifndef LoadViewInclude_h
#define LoadViewInclude_h

extern uint8_t LoadViewX;
extern uint8_t LoadViewY;
extern uint8_t LoadViewDX;
extern uint8_t LoadViewDY;
extern uint8_t LoadViewColor;
extern uint8_t LoadViewProgress;

extern uint8_t LoadViewLoadTitle[8];

void LoadViewShowHL();
void LoadViewShowTitleHL();
void LoadViewShowProgressA();
void LoadViewClose();

#endif /* LoadViewInclude_h */
