//
//  ExternParams.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 16.09.2025.
//

#ifndef ExternParams_h
#define ExternParams_h

extern uint16_t systemFontAddress;
extern uint8_t myFont[72]; // 56
extern uint8_t rootTimerTike;

#include "wifiSettings/ExtWifiSettings.h"
#include "FtpSettings/ExtFtpSettings.h"
#include "DiskView/ExtDiskView.h"
#include "DiskView/ExtDiskFunctions.h"
#include "FTPView/ExtFTPView.h"
#include "RootViewValue/ExtRootViewValue.h"
#include "FtpSettingsEditView/ExtFtpSettingsEditView.h"
#include "wifiSettingsEditView/wifiSettingsEditViewInclude.h"
#include "SSIDListView/SSIDListViewInclude.h"
#include "I2C/I2CInclude.h"
#include "ESP/ESPInclude.h"
#include "NET/NETInclude.h"
#include "FTPView/FTPViewInclude.h"
#include "FtpSettings/FtpSettingsInclude.h"
#include "FtpFileLoadView/FtpFileLoadViewInclude.h"
#include "NET/ParseHelper/ParseHelperInclude.h"
#include "DEBUG/DEBUGInclude.h"

#endif /* ExternParams_h */

