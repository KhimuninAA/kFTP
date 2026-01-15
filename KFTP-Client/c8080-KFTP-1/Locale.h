//
//  Locale.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 16.09.2025.
//

#ifndef Locale_h
#define Locale_h

#include "MyFont.h"

#include "wifiSettings/WifiSettings.h"
#include "FtpSettings/FtpSettings.h"
#include "DiskView/DiskView.h"
#include "FTPView/FTPView.h"
#include "RootViewValue/RootViewValue.h"
#include "FtpSettingsEditView/FtpSettingsEditView.h"
#include "DiskView/DiskFunctions.h"
#include "wifiSettingsEditView/wifiSettingsEditView.h"
#include "SSIDListView/SSIDListView.h"

#include "I2C/I2CFunctions.h"
#include "ESP/ESPFunctions.h"
#include "NET/NETFunctions.h"
#include "FTPView/FTPViewFunctions.h"
#include "FtpSettings/FtpSettingsFunctions.h"
#include "FtpFileLoadView/FtpFileLoadViewFunctions.h"
#include "NET/ParseHelper/ParseHelperFunctions.h"
#include "DEBUG/DEBUGFunctions.h"

uint8_t rootTimerTike = 0;

#endif /* Locale_h */
