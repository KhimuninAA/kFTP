#ifndef I2C_EVENTS_H_
#define I2C_EVENTS_H_

#include <WString.h>
#include "EEPROMStore.h"
#include "WIFIMy.h"
#include "FTPClient.h"

enum REQUEST_TYPE {
  NONE = -1,
  GET_FILE = 0,
  GET_SETTINGS, //1
  GET_FTPURL, //2
  SET_FTPURL, //3
  UPDATE_SSIDList, //4
  GET_SSIDList, //5
  GET_SSID, //6
  SET_SSID, //7
  GET_SSID_PASSWORD, //8
  SET_SSID_PASSWORD, //9
  CONNECT_SSID, //10
  STATE_SSID, //11
  GET_IP_Address, //12
  GET_MAC_Address, //13
  GET_SSIDList_Is_Ready, //14
  GET_I2C_Busy, //15
  GET_FTP_Port, // 16
  SET_FTP_Port, // 17
  GET_FTP_User, // 18
  SET_FTP_User, // 19
  GET_FTP_Password, // 20
  SET_FTP_Password, // 21
  ESP_Restart, // 22
  FTP_CONNECT, // 23
  GET_FTP_STATE, // 24
  UPDATE_FTP_LIST, // 25
  GET_FTP_LIST, // 26
  FTP_PATH_ADD_DIR_BY_INDEX, //27
  FILE_DOWNLOAD, // 28
  FILE_DOWNLOAD_LOAD_NEXT, // 29
  FILE_DOWNLOAD_GET_NEXT, // 30
  FTP_DIR_UP, // 31
  FTP_DIR_INDEX, // 32
  GET_FTP_DIR, // 33
};

struct ReceiveData {
  REQUEST_TYPE type;
  char buffer[50];
  int count;
};

extern EEPROMData data;
extern bool WIFIflag;
extern SSIDData ssidsData[MAX_ENTRIES];
extern char WIFIBuffer[256];
extern uint8_t SSIDListPos;
extern uint8_t SSIDList_Is_Ready;
extern bool receiveOn;
extern bool i2cBusy;
extern FTPClient ftpClientA;
extern uint8_t ftpFilesCount;
extern FtpFileData ftpFiles[20];

void receiveEvent(int howMany);
void requestEvent();
void receiveExec();

void setBusy(bool busy);

#endif