#include "FTPClient.h"

FTPClient::FTPClient() {
  ftpDataConnected = false;
}

void FTPClient::addFolder(int index) {
  FtpFileData tempData = ftpFiles[index];
  strcat(chDir, tempData.name.c_str());
  strcat(chDir, "/");
}

void FTPClient::ftpConnect() {
  ftpClientResponseOldCode = 0;
  uint16_t numPort = (uint16_t)strtoul(data.ftpPort, NULL, 10);
  if (!ftpClient.connect(data.ftpServerUrl, numPort)) {
    Serial.println("C connection failed");
    return;
  }
  Serial.println("C FTP connected");
  getStatus();
}

void FTPClient::ftpQuit() {
  ftpClient.println(F("QUIT"));
  ftpClient.stop();
  Serial.println(F("C Connection closed"));
  ftpDataConnected = false;
}

bool FTPClient::getFtpDataConnected() {
  return ftpDataConnected;
}

void FTPClient::getStatus() {
  ftpClientResponse.clear();

  unsigned long _m = millis();
  while (!ftpClient.available() && millis() < _m + timeout) delay(1);

  while (ftpClient.available()) {
    char c = ftpClient.read();
    if (c == '\n' || c == '\r') {
      ftpClientResponse.trim();
      ftpClientResponseCode = atoi(ftpClientResponse.c_str());
    } else {
      ftpClientResponse += c;
    }
  }
  seek227Code();
  if (ftpClientResponseOldCode != ftpClientResponseCode) {
    ftpClientResponseOldCode = ftpClientResponseCode;
    Serial.print(F("C "));
    Serial.println(ftpClientResponse);
    needActionByChangeCode();
  }
}

void FTPClient::seek227Code() {
    if ((ftpClientResponseCode == 227)) {
    int index = ftpClientResponse.indexOf(',');
    if (index >= 0) {
      int index1 = ftpClientResponse.indexOf(',', index + 1);
      int index2 = ftpClientResponse.indexOf(',', index1 + 1);
      int indexD1 = ftpClientResponse.indexOf(',', index2 + 1);
      int indexDE1 = ftpClientResponse.indexOf(',', indexD1 + 1);
      String dSrt = ftpClientResponse.substring(indexD1 + 1, indexDE1);
      int indexDE2 = ftpClientResponse.indexOf(')', indexDE1 + 1);
      String dSrt2 = ftpClientResponse.substring(indexDE1 + 1, indexDE2);

      int lo = dSrt2.toInt();
      int hi = dSrt.toInt();
      hi = hi << 8;
      hi += lo;
      ftpDataPort = hi;
      ftpDataClientConnect();
    }
  }
}

void FTPClient::needActionByChangeCode() {
    if (ftpClientResponseCode == 220) {
      sendAuthenticationUsername();
    }
    if (ftpClientResponseCode == 331) {
      sendAuthenticationPassword();
    }
    if (ftpClientResponseCode == 230) {
      setPassiveMode();
    }
}

void FTPClient::ftpDataClientConnect() {
  ftpDataClient.stop();
  if (ftpDataClient.connect(data.ftpServerUrl, ftpDataPort)) { //, timeout
    Serial.println(F("C Data connection established"));
    ftpDataConnected = true;
  } else {
    ftpDataConnected = false;
  }
}

void FTPClient::sendAuthenticationUsername() {
  ftpClient.print(F("USER "));
  ftpClient.println(data.ftpUser);
  getStatus();
}

void FTPClient::sendAuthenticationPassword() {
  ftpClient.print(F("PASS "));
  ftpClient.println(data.ftpPass);
  getStatus();
}

void FTPClient::setPassiveMode() {
  //ftpClient.println(PSTR("PASV"));
  ftpClient.println("PASV");
  getStatus();
}

bool FTPClient::activeConnect() {
  if (ftpClient.connected() == true) {
    return true;
  } else {
    ftpConnect();
    if (ftpClient.connected() == true) {
      return true;
    }
    Serial.println(F("C ReConnect Error!!!"));
  }
  return false;
}

//Sets the transfer mode
void FTPClient::setTransferMode(TransferModeType type) {
  if (activeConnect() == false) {
    return;
  }
  if (type == ASCII) {
    ftpClient.println(F("Type A"));
  } else if (type == BINARY) {
    ftpClient.println(F("Type I"));
  }
  getStatus();

  setPassiveMode();
}

bool FTPClient::reconnectDataConnect() {
  ftpDataClientConnect();
  return ftpDataClient.connected();
}

bool FTPClient::activeDataConnect() {
  if (ftpDataClient.connected() == true) {
    return true;
  } else {
    int reconnectCount = 0;
    bool isConnect = false;
    do {
      delay(10);
      isConnect = reconnectDataConnect();
      reconnectCount++;
    }while(!isConnect && reconnectCount < 5);
    if (isConnect) {
      return true;
    }
    
    Serial.println(F("C ReDataConnect Error!!!"));
  }
  return false;
}

bool FTPClient::isCodeError() {
  int codeLen = floor(log10(abs(ftpClientResponseCode))) + 1;
  if (codeLen == 3) {
    int first = ftpClientResponseCode;
    while (first >= 10) {
      first /= 10;
    }
    if (first == 5) {
      return true;
    }
  }
  return false;
}

bool FTPClient::changeDir(char * dir) {
  if (activeConnect() == false) {
    return false;
  }
  ftpClient.print(F("CWD "));
  ftpClient.println(dir);

  do {
    getStatus();
  }while(ftpClientResponseCode != 250 && !isCodeError());

  if (isCodeError() == true) {
    return false;
  } else {
    return true;
  }
}

void FTPClient::updateFtpList() {
  // Очистить список и интедкс

  if (activeConnect() == false) {
    return;
  }

  setTransferMode(BINARY);

  ftpClient.print(F("MLSD "));
  ftpClient.println(chDir);
  getStatus();

  if (activeDataConnect() == false) {
    return;
  }

  ftpFilesCount = 0;
  unsigned long _m = millis();
  while( !ftpDataClient.available() && millis() < _m + timeout) delay(1);

  while(ftpDataClient.available()) {
    if( ftpFilesCount < maxFilesInList ) {
      String fileDataStr = ftpDataClient.readStringUntil('\n');
      FtpFileData ftpFileData = FtpFileDataHelper::parse(fileDataStr);
      if (ftpFileData.isHidden == false) {
        Serial.println(ftpFileData.name);
        ftpFiles[ftpFilesCount] = ftpFileData;
        ftpFilesCount++;
      }
    }
  }
}

uint8_t FTPClient::downloadFile(int index) {
  if (activeConnect() == false) {
    return 0;
  }

  changeDir(chDir);

  setTransferMode(BINARY);

  strncpy(tempName, ftpFiles[index].name.c_str(), 16);
  fileDownloadData.downloadData.fileSize = (uint16_t)ftpFiles[index].size;
  fileDownloadData.downloadData.pageSize = bytesPageCount;

  ftpClient.print(F("RETR "));
  ftpClient.println(tempName);
  getStatus();

  if (activeDataConnect() == false) {
    return 0;
  }

  uint16_t addr = 0;
  fileDownloadData.downloadData.addr = addr;

  unsigned long _m = millis();
  while( !ftpDataClient.available() && millis() < _m + timeout) delay(1);

  return 1;
}

void FTPClient::downloadFileUpdateSum() {
  byte sum = 0;
  for(int i = 0; i < bytesPageCount; i++) {
    sum += (byte)fileDownloadData.downloadData.buffer[i];
  }
  fileDownloadData.downloadData.sum = sum;

  float progress = 41 * ( ((float)fileDownloadData.downloadData.addr) / ((float)fileDownloadData.downloadData.fileSize) );
  fileDownloadData.downloadData.progress = (byte)progress;
}

uint8_t FTPClient::downloadFileNext() {
  if (ftpDataClient.available()) {
    ftpDataClient.readBytes(fileDownloadData.downloadData.buffer, bytesPageCount);
    fileDownloadData.downloadData.addr += (uint16_t)bytesPageCount;
    fileDownloadData.downloadData.stopByte = 1;
    downloadFileUpdateSum();
    return 1;
  } else {
    memset(fileDownloadData.downloadData.buffer, 0, sizeof(fileDownloadData.downloadData.buffer));
    fileDownloadData.downloadData.stopByte = 90; //(0x5A)
    downloadFileUpdateSum();
    return 0;
  }
}

void FTPClient::changeDirByIndex(int index) {
  strncpy(tempName, ftpFiles[index].name.c_str(), 23);
  strcat(chDir, tempName);
  strcat(chDir, "/");
}

void FTPClient::changeDirUp() {
  int length = strlen(chDir);
  Serial.println("length : ");
  Serial.println(length);
  length -= 2; // Remove last "/+0"
  int index = 0;
  for (int i = length; i > 0 ; i--) {
    char c = chDir[i];
    if (c == '/') {
      index = i;
      break;
    }
  }
  Serial.println("index : ");
  Serial.println(index);
  if (index > 0) {
    index += 1;
    strncpy(tempName, chDir + 0, index);
    tempName[index] = '\0';
    strncpy(chDir, tempName, 127);
  }
  Serial.println(chDir);
}