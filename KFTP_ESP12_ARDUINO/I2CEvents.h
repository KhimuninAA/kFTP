#ifndef I2C_EVENTS_H_
#define I2C_EVENTS_H_

#include <WString.h>
#include "EEPROMStore.h"
#include "WIFI.h"
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
  GET_NEXT_PAGE_BUFFER, // 34
  GET_FTP_LIST_NEXT, // 35
  GET_FTP_LIST_NEXT_NEW, // 36
  GET_FTP_LIST_NEW, // 37
  GET_FTP_DIR_NEW, // 38
  GET_FTPURL_NEW, // 39
  GET_SSID_PASSWORD_NEW, // 40
  GET_FTP_HOMEDIR_NEW, // 41
  GET_SSID_NEW_LIST_NEXT, // 42
  GET_FTP_Port_NEW, // 43
  GET_FTP_User_NEW, // 44
  GET_FTP_Password_NEW, // 45
  GET_SSID_NEW_LIST_Next_Inc, // 46
  GET_NEXT_PAGE_BUFFER_NEW, // 47
  GET_NEXT_PAGE_BUFFER_NEW_INC, // 48
  SET_STR16_FOR_KEY_PAGE, // 49
  GET_STR16_FOR_KEY_PAGE_STATE, // 50
  GET_ALL_STATE, // 51
  SET_FTP_GO_HOME_DIR, // 52
};

struct ReceiveData {
  REQUEST_TYPE type;
  char buffer[50];
  int count;
};

enum Str16DataAction_TYPE {
  Action_NONE = -1,
  Action_SET_SSID_PASSWORD = 0, // 0
  Action_SET_FTP_PASSWORD, // 1
  Action_SET_FTP_HomeDir, // 2
  Action_SET_FTP_ftpUser, // 3
  Action_SET_FTP_ServerUrl, // 4
  Action_SET_FTP_Port, // 5
};

struct ReceiveStr16Data {
  int key;
  uint8_t next;
  char buffer[16];
  //0x01 - Error; 0xA5 - Ok; 0x03 - InternalError;
  uint8_t state;
};

extern EEPROMData data;
extern bool WIFIflag;
extern SSIDData ssidsData[MAX_ENTRIES];
extern char WIFIBuffer[256];
extern uint8_t SSIDListPos;
extern uint8_t SSIDListCount;
extern uint8_t SSIDList_Is_Ready;
extern bool receiveOn;
extern bool i2cBusy;
extern FTPClient ftpClientA;
extern uint8_t ftpFilesCount;
extern FtpFileData ftpFiles[20];

void receiveEvent(int howMany);
void requestEvent();
void receiveExec();

void createSsidNewNexBuffer();
void createRequestBufferFrom(String str);

void setBusy(bool busy);

void str16DataExec();

#endif