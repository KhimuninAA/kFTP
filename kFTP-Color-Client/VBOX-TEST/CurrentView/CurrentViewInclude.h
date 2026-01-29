//
//  CurrentViewInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 21.01.2026.
//

#ifndef CurrentViewInclude_h
#define CurrentViewInclude_h

const uint8_t DiskViewId = 0x01;
const uint8_t FtpViewId = 0x02;
const uint8_t SelectDiskViewId = 0x03;
const uint8_t LoadViewId = 0x04;
const uint8_t WiFiSettingsViewId = 0x05;
const uint8_t EditFieldViewId = 0x06;
const uint8_t WiFiNetworksViewId = 0x07;
const uint8_t FtpSettingsViewId = 0x08;

extern uint8_t CurrentViewId;
extern uint8_t CurrentViewReturnIds[16];
extern uint8_t CurrentViewReturnIdPos;

extern uint8_t FtpNetStateChange;
extern uint8_t WiFiNetStateChange;
extern uint8_t CurrentViewDiskOrFtpViewFocus;

void CurrentViewChangeAndPushIdA();
void CurrentViewChangeIdA();
void CurrentViewSetIdA();
void CurrentViewReturn();
/// вых [A] 1 - если активное окно DiskView или FtpView
/// 0 - если любое другое
void CurrentViewDiskOrFtpViewByIdA();
void CurrentViewPushCurrentId();
// Return A - ID
void CurrentViewPopId();

#endif /* CurrentViewInclude_h */
