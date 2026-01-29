//
//  ThreadsInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 23.01.2026.
//

#ifndef ThreadsInclude_h
#define ThreadsInclude_h

extern uint8_t ThreadsTickCount;
extern uint16_t ThreadsTickSubCount;

void ThreadsTick();
void ThreadsTickNow();
void ThreadsTickCountNext();

void ThreadsNetUpdateState();
void ThreadsNetNeedStateChange();
void NetUpdateData();

void ThreadsNetNeedUpdateWiFiData();
void ThreadsNetNeedUpdateWiFiValue();
void ThreadsNetPasswordUpdate();
void ThreadsNetSsidUpdateA();

void ThreadsNetNeedUpdateFtpData();
void ThreadsNetNeedUpdateFtpValue();

void ThreadsNetFtpHomeDirUpdate();
void ThreadsNetFtpPasswordUpdate();
void ThreadsNetFtpUserUpdate();
void ThreadsNetFtpServerUrlUpdate();
void ThreadsNetFtpPortUpdate();

void delay50ms();

#endif /* ThreadsInclude_h */
