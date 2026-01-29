//
//  ButtonShadowViewInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 23.01.2026.
//

#ifndef ButtonShadowViewInclude_h
#define ButtonShadowViewInclude_h

extern uint8_t ButtonShadowViewX;
extern uint8_t ButtonShadowViewY;
extern uint8_t ButtonShadowViewDX;
extern uint8_t ButtonShadowViewDY;

extern uint8_t ButtonShadowViewColor;
extern uint8_t ButtonShadowViewInvColor;
extern uint16_t ButtonShadowViewTitlePoint;

void ButtonShadowViewShow();
void ButtonShadowViewShowTitleBC();
/// Закраска кнопки
/// 0 - прямой
/// 1 - инверсный
void ButtonShadowViewSelectA();

#endif /* ButtonShadowViewInclude_h */
