//
//  ThreadsFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 23.01.2026.
//

#ifndef ThreadsFunctions_h
#define ThreadsFunctions_h

void ThreadsTickNow() {
    a = 101;
    ThreadsTickCount = a;
}

void ThreadsTick() {
    #ifdef _IS_SIMULATOR
        
    #else
    if ((a = ThreadsTickCount) >= 100) {
        a = 0;
        ThreadsTickCount = a;
        //--
        ThreadsNetUpdateState();
    } else {
        ThreadsTickCountNext();
    }
    #endif
}

void ThreadsNetUpdateState() {
    getFtpState();
    getWifiState();
    ThreadsNetNeedStateChange();
}

void ThreadsNetNeedStateChange() {
    if ((a = WiFiNetStateChange) == 1) {
        ThreadsNetNeedUpdateWiFiData();
        a = 0;
        WiFiNetStateChange = a;
    }
    if ((a = FtpNetStateChange) == 1) {
        ThreadsNetNeedUpdateFtpData();
        a = 0;
        FtpNetStateChange = a;
    }
}

// ----------------------------------
// ------------ WiFi ----------------
// ----------------------------------
void ThreadsNetNeedUpdateWiFiData() {
    getSSIDIPAddress();
    WifiStateViewShowValue();
}

void ThreadsNetNeedUpdateWiFiValue() {
    getSSIDValue();
    getSSIDIPAddress();
    getSSIDMacAddress();
    getSSIDPassword();
    // UI
    WifiStateViewShowValue();
}

void ThreadsNetPasswordUpdate() {
    setSSIDPassword();
    getSSIDPassword();
}

void ThreadsNetSsidUpdateA() {
    setSSIDNumberA();
    getSSIDValue();
}

// ----------------------------------
// ------------ Ftp  ----------------
// ----------------------------------
void ThreadsNetNeedUpdateFtpData() {
    FtpStateViewShowValue();
    //
    CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
    if (a == 1) {
        if ((a = FtpStateViewStatus) == 1) {
            updateFtpList();
            getNetFtpListNew();
        } else {
            FtpViewEmptyList();
        }
        FtpViewListUpdateUI();
    }
}

void ThreadsNetNeedUpdateFtpValue() {
    getFTPUrl();
    getFTPHomeDir();
    getFTPPort();
    getFTPUser();
    getFTPPassword();
    // UI
    FtpStateViewShowValue();
}

void ThreadsNetFtpHomeDirUpdate() {
    setFtpHomeDir();
    getFTPHomeDir();
}

void ThreadsNetFtpPasswordUpdate() {
    setFtpPassword();
    getFTPPassword();
}

void ThreadsNetFtpUserUpdate() {
    setFtpUser();
    getFTPUser();
}

void ThreadsNetFtpServerUrlUpdate() {
    setFtpServerUrl();
    getFTPUrl();
}

void ThreadsNetFtpPortUpdate() {
    setFtpPort();
    getFTPPort();
}

void NetUpdateData() {
    ThreadsNetNeedUpdateFtpValue();
    ThreadsNetNeedUpdateWiFiValue();
}

void delay50ms() {
    push_pop(bc) {
        bc = 0xFFFF;
        do {
            bc--;
            a = b;
            a |= c;
        } while (flag_nz);
    }
}

void ThreadsTickCountNext() {
    push_pop(hl) {
        hl = ThreadsTickSubCount;
        // Compare hl == 0
        a = h;
        a |= l;
        if (a == 0) {
            //-- TickCount ++
            a = ThreadsTickCount;
            a++;
            ThreadsTickCount = a;
            //-- TickSubCount = max
            hl = 0x300;
        } else {
            hl--;
        }
        ThreadsTickSubCount = hl;
    }
}

uint16_t ThreadsTickSubCount = 0x0000;
uint8_t ThreadsTickCount = 0;

#endif /* ThreadsFunctions_h */
