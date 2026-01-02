//
//  SSIDListViewInclude.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 22.12.2025.
//

#ifndef SSIDListViewInclude_h
#define SSIDListViewInclude_h

extern uint8_t SSIDListViewX;
extern uint8_t SSIDListViewY;
extern uint8_t SSIDListViewEX;
extern uint8_t SSIDListViewEY;

extern uint16_t SSIDListViewTitlePos;
extern uint8_t SSIDListViewTitle[12];

extern uint8_t SSIDList[256];
extern uint8_t SSIDListCount;
extern uint8_t SSIDListViewCurrentPos;
extern uint8_t SSIDListNext;
///

void needOpenSSIDListView();
void showSSIDListView();
void SSIDListViewDataUpdate();
void setSSIDPosCursorC();
void SSIDListViewShowValueA();
void SSIDListViewKeyA();

#endif /* SSIDListViewInclude_h */
