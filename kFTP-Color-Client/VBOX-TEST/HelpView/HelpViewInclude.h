//
//  HelpViewInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef HelpViewInclude_h
#define HelpViewInclude_h

extern uint8_t HelpViewX;
extern uint8_t HelpViewY;
extern uint8_t HelpViewDX;
extern uint8_t HelpViewDY;
extern uint8_t HelpViewColor;

extern uint8_t HelpViewTitleF1[7];
extern uint8_t HelpViewTitleF2[10];
extern uint8_t HelpViewTitleF3[9];
extern uint8_t HelpViewTitleF4[9];

void HelpViewShow();
void HelpViewShowStr();

#endif /* HelpViewInclude_h */
