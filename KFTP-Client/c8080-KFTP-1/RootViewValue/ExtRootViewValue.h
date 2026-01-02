//
//  ExtRootViewValue.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 17.09.2025.
//

#ifndef ExtRootViewValue_h
#define ExtRootViewValue_h

const int rootViewCurrentDiskView = 0x00;
const int rootViewCurrentFTPView = 0x01;
const int rootViewCurrentFTPSettingsEditView = 0x02;
const int rootViewCurrentWiFiSettingsEditView = 0x03;
const int rootSSIDListView = 0x04;

extern uint8_t rootViewCurrentView;

extern uint16_t rootViewHelpStrPos;
extern uint8_t rootViewHelpStr[62];

extern uint8_t rootViewOldKey;

#endif /* ExtRootViewValue_h */
