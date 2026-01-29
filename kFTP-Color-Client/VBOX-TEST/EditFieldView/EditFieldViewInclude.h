//
//  EditFieldViewInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 24.01.2026.
//

#ifndef EditFieldViewInclude_h
#define EditFieldViewInclude_h

extern uint8_t EditFieldViewX;
extern uint8_t EditFieldViewY;
extern uint8_t EditFieldViewDX;
extern uint8_t EditFieldViewDY;
extern uint8_t EditFieldViewColor;

extern uint16_t EditFieldViewTextPoint;
extern uint8_t EditFieldViewEditText[16];
extern uint8_t EditFieldViewEditTextPos;
extern uint8_t EditFieldViewTextIsChanged;

/// H - x, L - y
/// D - dx, E - dy
/// BC - text
void EditFieldViewShow();
void EditFieldViewClose();
void EditFieldViewLoopKey();
void EditFieldViewTextCopy();
void EditFieldViewShowTextValue();
void EditFieldViewTextSave();

#endif /* EditFieldViewInclude_h */
