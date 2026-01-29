//
//  CurrentViewFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 21.01.2026.
//

#ifndef CurrentViewFunctions_h
#define CurrentViewFunctions_h

void CurrentViewChangeAndPushIdA() {
    push_pop(bc) {
        b = a;
        // Save old Id
        CurrentViewPushCurrentId();
        //
        a = b;
        CurrentViewSetIdA();
    }
}

void CurrentViewChangeIdA() {
    push_pop(bc) {
        b = a;
        // Save new
        a = b;
        CurrentViewSetIdA();
    }
}

void CurrentViewSetIdA() {
    CurrentViewId = a;
    
    if ((a = CurrentViewReturnIdPos) == 0) {
        if ((a = CurrentViewId) == DiskViewId) {
            FtpViewShowSelectLineA(a = 0);
            DiskViewShowSelectLineA(a = 1);
        } else if ((a = CurrentViewId) == FtpViewId) {
            FtpViewShowSelectLineA(a = 1);
            DiskViewShowSelectLineA(a = 0);
        } else if ((a = CurrentViewId) == SelectDiskViewId) {
            FtpViewShowSelectLineA(a = 0);
            DiskViewShowSelectLineA(a = 0);
        } else if ((a = CurrentViewId) == LoadViewId) {
            FtpViewShowSelectLineA(a = 0);
            DiskViewShowSelectLineA(a = 0);
        } else if ((a = CurrentViewId) == WiFiSettingsViewId) {
            FtpViewShowSelectLineA(a = 0);
            DiskViewShowSelectLineA(a = 0);
        } else if ((a = CurrentViewId) == FtpSettingsViewId) {
            FtpViewShowSelectLineA(a = 0);
            DiskViewShowSelectLineA(a = 0);
        }
    }
}

void CurrentViewPushCurrentId() {
    push_pop(de, hl) {
        hl = CurrentViewReturnIds;
        // Add delta
        d = 0;
        a = CurrentViewReturnIdPos;
        e = a;
        a++;
        CurrentViewReturnIdPos = a;
        hl += de;
        // Save current ID
        a = CurrentViewId;
        *hl = a;
    }
}

// Return A - ID
void CurrentViewPopId() {
    if ((a = CurrentViewReturnIdPos) > 0) {
        // Decriment
        a = CurrentViewReturnIdPos;
        a--;
        CurrentViewReturnIdPos = a;
        //--
        e = a;
        d = 0;
        hl = CurrentViewReturnIds;
        hl += de;
        a = *hl;
    } else {
        a = CurrentViewId;
    }
}

void CurrentViewReturn() {
    CurrentViewPopId();
    CurrentViewChangeIdA();
}

/// вых [A] 1 - если активное окно DiskView или FtpView
/// 0 - если любое другое
void CurrentViewDiskOrFtpViewByIdA() {
    push_pop(bc) {
        b = a;
        if ((a = b) == DiskViewId) {
            a = 1;
            CurrentViewDiskOrFtpViewFocus = a;
        } else if ((a = b) == FtpViewId) {
            a = 1;
            CurrentViewDiskOrFtpViewFocus = a;
        } else {
            a = 0;
            CurrentViewDiskOrFtpViewFocus = a;
        }
    }
    a =  CurrentViewDiskOrFtpViewFocus;
}

uint8_t CurrentViewDiskOrFtpViewFocus = 0;

uint8_t CurrentViewReturnIds[16];
uint8_t CurrentViewReturnIdPos = 0;
uint8_t CurrentViewId = FtpViewId;
uint8_t FtpNetStateChange = 0;
uint8_t WiFiNetStateChange = 0;

#endif /* CurrentViewFunctions_h */
