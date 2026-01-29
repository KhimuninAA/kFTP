#ifndef FTP_CLIENT_H_
#define FTP_CLIENT_H_

#include <Arduino.h> 
#include <ESP8266WiFi.h>
#include "EEPROMStore.h"
#include "FtpFileData.h"

extern EEPROMData data;

class FTPClient {
  private:
  int16_t ftpClientResponseOldCode;
  String ftpClientResponse;
  int16_t ftpClientResponseCode;

  String ftpClientResponses[5];
  int ftpClientResponsesCount = 0;

  int ftpDataPort;
  bool ftpDataConnected = false;
  enum TransferModeType {ASCII, BINARY};
  char chDir[128] = "/ORION/";
  char tempName[128];
  float progressCount = 40;

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
  void downloadFileUpdateSum(bool isNext);
  void showRes();
  void parseStatus();

  public:
  WiFiClient ftpClient;
  uint16_t timeout = 1000;
  WiFiClient ftpDataClient;
  uint8_t maxFilesInList = 13;

  FtpFileData ftpFiles[20];
  uint8_t ftpFilesCount = 0;
  UnionFtpFileDownloadData fileDownloadData;
  int bytesPageCount = 8; //16 (ошибка в последних 3-х байтах)
  int bytesPropertyCount = 4;

  FTPClient();
  void ftpConnect();
  void ftpQuit();
  void getStatus();
  bool getFtpDataConnected();
  void updateFtpList(uint8_t fileCount);
  void addFolder(int index);
  uint8_t downloadFile(int index);
  uint8_t downloadFileNext();
  bool changeDir(char * dir);
  void changeDirByIndex(int index);
  void changeDirUp();
  String getCurrentFolder();
  String getCurrentFolderNew();
};

#endif