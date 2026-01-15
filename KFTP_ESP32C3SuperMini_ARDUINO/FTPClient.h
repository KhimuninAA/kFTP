#ifndef FTP_CLIENT_H_
#define FTP_CLIENT_H_

#include <Arduino.h> 
#include <WiFi.h>
#include "EEPROMStore.h"
#include "FtpFileData.h"

extern EEPROMData data;

class FTPClient {
  private:
  int16_t ftpClientResponseOldCode;
  String ftpClientResponse;
  int16_t ftpClientResponseCode;
  int ftpDataPort;
  bool ftpDataConnected = false;
  enum TransferModeType {ASCII, BINARY};
  char chDir[128] = "/ORION/";
  char tempName[128];

  void seek227Code();
  void needActionByChangeCode();
  void ftpDataClientConnect();
  void sendAuthenticationUsername();
  void sendAuthenticationPassword();
  void setPassiveMode();
  bool activeConnect();
  void setTransferMode(TransferModeType type);
  bool activeDataConnect();
  bool reconnectDataConnect();
  bool isCodeError();
  void downloadFileUpdateSum();

  public:
  WiFiClient ftpClient;
  uint16_t timeout = 1000;
  WiFiClient ftpDataClient;
  uint8_t maxFilesInList = 16;

  FtpFileData ftpFiles[20];
  uint8_t ftpFilesCount = 0;
  UnionFtpFileDownloadData fileDownloadData;
  int bytesPageCount = 8; //16 (ошибка в последних 3-х байтах)

  FTPClient();
  void ftpConnect();
  void ftpQuit();
  void getStatus();
  bool getFtpDataConnected();
  void updateFtpList();
  void addFolder(int index);
  uint8_t downloadFile(int index);
  uint8_t downloadFileNext();
  bool changeDir(char * dir);
  void changeDirByIndex(int index);
  void changeDirUp();
};

#endif