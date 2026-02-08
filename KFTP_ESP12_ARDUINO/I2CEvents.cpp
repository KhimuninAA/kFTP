#include "I2CEvents.h"
#include <ESP8266WiFi.h>
#include <Wire.h>
#include "WIFI.h"

//struct 
ReceiveData receiveData = {NONE, ""};
uint8_t ftpListPos = 0;
RequestBufferData requestBufferData = {0,0,0,""};
ReceiveStr16Data str16Data;

byte ssidListBuffer[20];
byte ssidNexBuffer[10];

/// 1 byte : Action
/// 2 byte : Next (0x01 = Next; 0x5A - Stop)
/// 3..10 bytes : Data
/// 11 byte : SUM
void str16DataParser() {
  Serial.println("str16DataParser");
  uint8_t sum = 0;
  for(int i = 0; i < 10; i++) {
    sum += (uint8_t)receiveData.buffer[i];
  }
  uint8_t getSum = (uint8_t)receiveData.buffer[10];
  if (getSum == sum) {
    uint8_t next = (uint8_t)receiveData.buffer[1];
    str16Data.next = next;
    str16Data.state = 0xA5;
    int dAddr = 0;
    if (next == 0x01) {
      dAddr = 0;
    } else if (next == 0x5A) {
      dAddr = 8;
    } else {
      str16Data.state = 0x01;
      return;
    }
    str16Data.key = (int)receiveData.buffer[0];
    for(int i = 0; i < 8; i++) {
      str16Data.buffer[dAddr + i] = receiveData.buffer[2 + i];
    }
  } else {
    str16Data.state = 0x01;
  }
}

// Ответ от платы подтверждающий правильность получения данных
// 1 byte :  0x01 - Error; 0xA5 - Ok; 0x03 - InternalError;
// 2 byte : Test .... 0x55
// 3 byte : SUM
void createstr16DataState() {
  //
  if ((str16Data.state == 0xA5) && (str16Data.next == 0x5A)) {
    str16DataExec();
  }
  //
  memset(ssidNexBuffer, 0, sizeof(ssidNexBuffer));
  uint8_t sum = 0;
  // State
  ssidNexBuffer[0] = str16Data.state;
  sum += str16Data.state;
  // Test
  ssidNexBuffer[1] = 0x55;
  sum += 0x55;
  // SUM
  ssidNexBuffer[2] = sum;
  // Exec
}

void str16DataExec() {
  Str16DataAction_TYPE actionType = static_cast<Str16DataAction_TYPE>(str16Data.key);
  switch (actionType) {
    case Action_SET_SSID_PASSWORD:
      for (int i = 0; i <= 15; i++) {
        data.ssidPass[i] = str16Data.buffer[i];
      }
      data.ssidPass[15] = 0;
      EEPROMStoreSave();
      break;
    case Action_SET_FTP_PASSWORD:
      for (int i = 0; i <= 15; i++) {
        data.ftpPass[i] = str16Data.buffer[i];
      }
      data.ftpPass[15] = 0;
      EEPROMStoreSave();
      break;
    case Action_SET_FTP_HomeDir:
      for (int i = 0; i <= 15; i++) {
        data.ftpHomeDir[i] = str16Data.buffer[i];
      }
      data.ftpHomeDir[15] = 0;
      EEPROMStoreSave();
      break;
    case Action_SET_FTP_ftpUser:
      for (int i = 0; i <= 15; i++) {
        data.ftpUser[i] = str16Data.buffer[i];
      }
      data.ftpUser[15] = 0;
      EEPROMStoreSave();
      break;
    case Action_SET_FTP_ServerUrl:
      for (int i = 0; i <= 15; i++) {
        data.ftpServerUrl[i] = str16Data.buffer[i];
      }
      data.ftpServerUrl[15] = 0;
      EEPROMStoreSave();
      break;
    case Action_SET_FTP_Port:
      for (int i = 0; i <= 5; i++) {
        data.ftpPort[i] = str16Data.buffer[i];
      }
      data.ftpPort[5] = 0;
      EEPROMStoreSave();
      break;
    default:
      break;
  }
  memset(str16Data.buffer, 0, sizeof(str16Data.buffer));
  str16Data.key = -1;
  str16Data.next = 0;
  //str16Data.state = 0;
}

/// Get All State
/// 1 byte : Test = 0x55
/// 2 byre : All State : WIFIConnect = 0x01; FtpConnect = 0x02;
/// 3 byte : Reserved
/// 4 byte : SUM
void createAllStateBuffer() {
  memset(ssidNexBuffer, 0, sizeof(ssidNexBuffer));
  uint8_t sum = 0;
  // -- Test byte 0x55
  ssidNexBuffer[0] = 0x55;
  sum += ssidNexBuffer[0];
  // -- All State
  uint8_t all_state = 0x00;
  if(WIFIflag==true){
    all_state |= 0x01; // 1 bit
  }
  if (ftpClientA.getFtpDataConnected() == true) {
    all_state |= 0x02; // 2 bit
  }
  ssidNexBuffer[1] = all_state;
  sum += ssidNexBuffer[1];
  // -- Reserved
  ssidNexBuffer[2] = 0x00;
  sum += ssidNexBuffer[2];
  // -- SUM
  ssidNexBuffer[3] = sum;

}

void createSsidNewNexBuffer() {
  memset(ssidNexBuffer, 0, sizeof(ssidNexBuffer));
  uint8_t sum = 0;
  // -- 1 = 1
  ssidNexBuffer[0] = 0x01;
  sum += 0x01;
  // -- Pos
  ssidNexBuffer[1] = SSIDListPos;
  sum += SSIDListPos;
  // -- Next
  uint8_t nextByte = 0x5A; //90 (0x5A) Stop!
  if (SSIDListPos < (SSIDListCount - 1)) {
    nextByte = 0x01;
  }
  ssidNexBuffer[2] = nextByte;
  sum += nextByte;
  // -- SUM
  ssidNexBuffer[3] = sum;
  // -- 
  char tempSsidName[16];
  int pos = 0;
  int ssidCount = ssidsData[SSIDListPos].ssid.length();
  const char* ssidNameOrig = ssidsData[SSIDListPos].ssid.c_str();
  // --

  for (int i = 0; i < ssidCount; i++) {
    uint8_t c = ssidNameOrig[i];
    if (c < 0x80) {
      tempSsidName[pos] = c;
      pos ++;
    } else if (c == 0xD0) {
      i++;
      uint8_t utC = ssidNameOrig[i];
      utC -= 0x10;
      tempSsidName[pos] = utC;
      pos ++;
    } else if (c == 0xD1) {
      i++;
      uint8_t utC = ssidNameOrig[i];
      utC += 0x60;
      tempSsidName[pos] = utC;
      pos ++;
    }
    if (pos >= 15) {
      break;
    }
  }
  if (pos >= 15) {
    tempSsidName[15] = 0;
  } else {
    tempSsidName[pos] = 0;
  }
  String tempSsidStr = String(tempSsidName);
  createRequestBufferFrom(tempSsidStr);
}

void createSsidListBuffer() {
  memset(ssidListBuffer, 0, sizeof(ssidListBuffer));
  ssidListBuffer[0] = SSIDListPos;
  if(SSIDListPos >= 15) {
    ssidListBuffer[1] = 0;
  }else{
    ssidListBuffer[1] = 1;
  }
  for(int i=0; i < 15 ;i++){
    ssidListBuffer[2 + i] = ssidsData[SSIDListPos].ssidCh[i];
  }
}

// ФТП буфер с контрольной суммой из структуры новый
void createFtpFileDataBufferB(FtpFileData data) {
  memset(ssidListBuffer, 0, sizeof(ssidListBuffer));
  uint8_t sum = 0;
  //-- Pos
  uint8_t firstByte = ftpListPos;
  firstByte &= 0x3F;
  //-- Next
  if((ftpListPos + 1) != ftpClientA.ftpFilesCount) {
    firstByte += 0x40; //(7bit)
  }
  //-- Dir
  if(data.isDir == true) {
    firstByte += 0x80; //(8bit)
  }
  ssidListBuffer[0] = firstByte;
  sum += firstByte;
  //-- Size
  uint16_t size16 = (uint16_t)data.size;
  if (data.size > 65535) {
    size16 = 0xFFFF;
  }
  ssidListBuffer[1] = (uint8_t)((size16&0xFF00) >> 8); //(size16 >> 8) && 0xFF;
  sum += ssidListBuffer[1];
  ssidListBuffer[2] = (uint8_t)(size16&0x00FF); //size16 && 0xFF;
  sum += ssidListBuffer[2];
  //-- Date 3 byte (GGGGGGGG GGGGMMMM 000DDDDD)
  uint8_t date1 = 0;
  uint8_t date2 = 0;
  uint8_t date3 = 0;
  //....................
  if (data.date.length() >= 8) {
    //"20171211171525"
    String date = data.date.substring(0, 8);
    //"20171211"
    //Serial.println(date);
    uint16_t gggg = (uint16_t)date.substring(0, 4).toInt();
    date1 = (uint8_t)((gggg&0x0FF0) >> 4);
    date2 = (uint8_t)((gggg&0x000F) << 4);
    uint8_t mm = (uint8_t)date.substring(4, 6).toInt();
    mm = mm&0x0F;
    date2 += mm;
    date3 = (uint8_t)date.substring(6, 8).toInt();
    date3 = date3&0x3F;
  }
  //....................
  ssidListBuffer[3] = date1;
  sum += date1;
  ssidListBuffer[4] = date2;
  sum += date2;
  ssidListBuffer[5] = date3;
  sum += date3;
  //-- Name
  char ftpFileNameChars[16];
  strncpy(ftpFileNameChars, data.name.c_str(), 16); //data.orionName().c_str()
  int pos = 0;
  uint8_t utfC = 0;
  for(int i=0; i < 16 ;i++) {
    char c = ftpFileNameChars[i];
    if (c < 0x80) {
      ssidListBuffer[6 + pos] = c;
      sum += (uint8_t)c;
      pos++;
    } else if (c == 0xD0) {
      i++;
      utfC = (uint8_t)ftpFileNameChars[i];
      utfC -= 0x10;
      ssidListBuffer[6 + pos] = utfC;
      sum += utfC;
      pos++;
    } else if (c == 0xD1) { 
      i++;
      utfC = (uint8_t)ftpFileNameChars[i];
      utfC += 0x60;
      ssidListBuffer[6 + pos] = utfC;
      sum += utfC;
      pos++;
    }
    if (pos > 7) {
      //ssidListBuffer[6 + pos] = 0x00;
      //sum += 0x00;
      break;
    }
  }
  //-- SUM
  ssidListBuffer[14] = sum;
}

// ФТП буфер с контрольной суммой из структуры
void createFtpFileDataBufferA(FtpFileData data) {
  memset(ssidListBuffer, 0, sizeof(ssidListBuffer));
  uint8_t sum = 0;
  //-- Pos
  uint8_t firstByte = ftpListPos;
  firstByte &= 0x3F;
  //-- Next
  if((ftpListPos + 1) != ftpClientA.ftpFilesCount) {
    firstByte += 0x40; //(7bit)
  }
  //-- Dir
  if(data.isDir == true) {
    firstByte += 0x80; //(8bit)
  }
  ssidListBuffer[0] = firstByte;
  sum += firstByte;
  //-- Size
  uint16_t size16 = (uint16_t)data.size;
  ssidListBuffer[1] = (uint8_t)((size16&0xFF00) >> 8); //(size16 >> 8) && 0xFF;
  sum += ssidListBuffer[1];
  ssidListBuffer[2] = (uint8_t)(size16&0x00FF); //size16 && 0xFF;
  sum += ssidListBuffer[2];
  //-- Name
  char ftpFileNameChars[16];
  strncpy(ftpFileNameChars, data.orionName().c_str(), 16);
  int pos = 0;
  for(int i=0; i < 16 ;i++) {
    char c = ftpFileNameChars[i];
    if (c < 0x60) {
      ssidListBuffer[3 + pos] = c;
      sum += (uint8_t)c;
      pos++;
      if (pos > 7) {
        ssidListBuffer[3 + pos] = 0x00;
        sum += 0x00;
        break;
      }
    }
  }
  //-- SUM
  ssidListBuffer[12] = sum;
}

// ФТП буфер из структуры
void createFtpFileDataBuffer(FtpFileData data) {
  memset(ssidListBuffer, 0, sizeof(ssidListBuffer));
  // POSITION - 0
  ssidListBuffer[0] = ftpListPos;
  // STOP BYTE - 1
  if(ftpListPos < ftpClientA.ftpFilesCount) { // (ftpListPos >= (ftpClientA.ftpFilesCount - 1))
    ssidListBuffer[1] = 1;
  }else{
    ssidListBuffer[1] = 90; //(0x5A)
  }
  // IsDir - 2
  if(data.isDir == true) {
    ssidListBuffer[2] = 1;
  }else{
    ssidListBuffer[2] = 0;
  }
  // SIZE - 3..4
  uint16_t size16 = (uint16_t)data.size;
  ssidListBuffer[3] = (uint8_t)((size16&0xFF00) >> 8); //(size16 >> 8) && 0xFF;
  ssidListBuffer[4] = (uint8_t)(size16&0x00FF); //size16 && 0xFF;
  // NAME
  char ftpFileNameChars[16];
  strncpy(ftpFileNameChars, data.orionName().c_str(), 16);
  int pos = 0;
  for(int i=0; i < 16 ;i++) {
    char c = ftpFileNameChars[i];
    if (c < 0x60) {
      ssidListBuffer[5 + pos] = c;
      pos++;
      if (pos > 8) {
        ssidListBuffer[5 + pos] = 0x00;
        break;
      }
    }
  }
}

void createNextRequestBufferA() {
  memset(ssidListBuffer, 0, sizeof(ssidListBuffer));
  byte sum = 0;
  int delta = requestBufferData.pageNum * requestBufferData.pageSize;
  // Start
  ssidListBuffer[0] = requestBufferData.pageNum;
  sum += requestBufferData.pageNum;
  ssidListBuffer[1] = requestBufferData.pageSize;
  sum += requestBufferData.pageSize;
  // IsNext 1 // 90 (0x5A)
  byte next = 1;
  if ((delta + requestBufferData.pageSize) > requestBufferData.lengtn) {
    next = 90; // (0x5A)
  }
  ssidListBuffer[2] = next;
  sum += next;
  for(int i=0; i < requestBufferData.pageSize; i++) {
    uint8_t bufferByte = requestBufferData.buffer[delta + i];
    sum += bufferByte;
    ssidListBuffer[3 + i] = bufferByte;
  }
  ssidListBuffer[3 + requestBufferData.pageSize] = sum;
}

void createNextRequestBuffer() {
  memset(ssidListBuffer, 0, sizeof(ssidListBuffer));
  byte sum = 0;
  int delta = requestBufferData.pageNum * requestBufferData.pageSize;
  // Start
  ssidListBuffer[0] = requestBufferData.pageNum;
  sum += requestBufferData.pageNum;
  ssidListBuffer[1] = requestBufferData.pageSize;
  sum += requestBufferData.pageSize;
  // IsNext 1 // 90 (0x5A)
  byte next = 1;
  if ((delta + requestBufferData.pageSize) > requestBufferData.lengtn) {
    next = 90; // (0x5A)
  }
  ssidListBuffer[2] = next;
  sum += next;
  for(int i=0; i < requestBufferData.pageSize; i++) {
    uint8_t bufferByte = requestBufferData.buffer[delta + i];
    sum += bufferByte;
    ssidListBuffer[3 + i] = bufferByte;
  }
  ssidListBuffer[3 + requestBufferData.pageSize] = sum;
  // pageNum increment
  requestBufferData.pageNum += 1;
}

void createRequestBufferFrom(String str) {
  memset(requestBufferData.buffer, 0, sizeof(requestBufferData.buffer));
  requestBufferData.pageNum = 0;
  requestBufferData.pageSize = 8;
  requestBufferData.lengtn = (uint8_t)str.length() + 1;
  str.getBytes(requestBufferData.buffer, sizeof(requestBufferData.buffer));
}

// -------------
// -= RECEIVE =-
// -------------
uint8_t receiveBuffer[32];
int receiveCount = 0;
void receiveEvent(int howMany) {
  setBusy(true);
  receiveCount = 0;
  while (0 <Wire.available()) {
    uint8_t receiveByte = Wire.read();
    receiveBuffer[receiveCount] = receiveByte;
    receiveCount ++;
  }
  receiveBufferOn = true;
}

void receiveBufferParser() {
  if (receiveCount == 0) {
    receiveData.type = NONE;
    receiveData.count = 0;
    setBusy(false);
  } else {
    int count = 0;
    for(int i = 0; i < receiveCount; i++) {
      if (count == 0) {
        int requestVal = receiveBuffer[i];
        Serial.print(F("Received request -> "));
        Serial.print(requestVal);
        receiveData.type = static_cast<REQUEST_TYPE>(requestVal);
        Serial.println();
      } else {
        char c = receiveBuffer[i]; 
        receiveData.buffer[count - 1] = c;
      }
      count++;
    }
    receiveData.buffer[count + 1] = '\0';
    receiveData.count = count;
    receiveOn = true;
  }
}

void receiveEventOld(int howMany) {
  setBusy(true);
  if (howMany == 0) {
    receiveData.type = NONE;
    receiveData.count = 0;
  } else {
    int count = 0;
    while (0 <Wire.available()) {
      if (count == 0) {
        int requestVal = Wire.read();
        Serial.print(F("Received request -> "));
        Serial.print(requestVal);
        receiveData.type = static_cast<REQUEST_TYPE>(requestVal);
        Serial.println();
        Serial.print("Count: ");
        Serial.print(count);
        Serial.print("howMany: ");
        Serial.println(howMany);
      } else {
        Serial.print("Else Count: ");
        Serial.println(count);
        char c = Wire.read(); 
        receiveData.buffer[count - 1] = c;
      }
      count++;
      if (count > howMany) {
        break;
      }
    }
    receiveData.buffer[count + 1] = '\0';
    receiveData.count = count;
    receiveOn = true;
  }
}

// -------------
// -=   EXEC  =-
// -------------
void receiveExec() {
  setBusy(true);
  i2cBusy = true;
  if (receiveData.type == NONE) {
    return;
  }

  String val;
  uint8_t tempByte;
  switch (receiveData.type) {
    case SET_FTPURL:
      receiveData.type = NONE;
      if (receiveData.count > 0) {
        for (int i = 0; i <= 15; i++) {
          data.ftpServerUrl[i] = receiveData.buffer[i];
        }
        data.ftpServerUrl[15] = 0;
        EEPROMStoreSave();
      }
      break;
    case SET_FTP_Port:
      receiveData.type = NONE;
      if (receiveData.count > 0) {
        for (int i = 0; i <= 5; i++) {
          data.ftpPort[i] = receiveData.buffer[i];
        }
        data.ftpPort[5] = 0;
        EEPROMStoreSave();
      }
      break;
    case SET_FTP_User:
      receiveData.type = NONE;
      if (receiveData.count > 0) {
        for (int i = 0; i <= 15; i++) {
          data.ftpUser[i] = receiveData.buffer[i];
        }
        data.ftpUser[15] = 0;
        EEPROMStoreSave();
      }
      break;
    case SET_FTP_Password:
      receiveData.type = NONE;
      if (receiveData.count > 0) {
        for (int i = 0; i <= 15; i++) {
          data.ftpPass[i] = receiveData.buffer[i];
        }
        data.ftpPass[15] = 0;
        EEPROMStoreSave();
      }
      break;
    case SET_SSID:
      receiveData.type = NONE;
      if (receiveData.count > 0) {
        if (receiveData.count > 0) { //== 1
          int index = receiveData.buffer[0];
          if (MAX_ENTRIES > index) {
            ssidsData[index].ssid.toCharArray(data.ssid, sizeof(data.ssid));
          }
          EEPROMStoreSave();
        }
      }
      break;
    case SET_SSID_PASSWORD:
      receiveData.type = NONE;
      if (receiveData.count > 0) {
        for (int i = 0; i <= 15; i++) {
          data.ssidPass[i] = receiveData.buffer[i];
        }
        data.ssidPass[15] = 0;
        EEPROMStoreSave();
      }
      break;
    case UPDATE_SSIDList:
      receiveData.type = NONE;
      listSSID();
      SSIDListPos = 0;
      break;
    case UPDATE_FTP_LIST:
      receiveData.type = NONE;
      if (receiveData.count > 0) {
        tempByte = receiveData.buffer[0];
      } else {
        tempByte = 0;
      }
      ftpClientA.updateFtpList(tempByte);
      ftpListPos = 0;
      break;
    case CONNECT_SSID:
      receiveData.type = NONE;
      WIFIConnect();
      break;
    case FTP_CONNECT:
      receiveData.type = NONE;
      ftpClientA.ftpConnect();
      break;
    case FTP_PATH_ADD_DIR_BY_INDEX:
      receiveData.type = NONE;
      if (receiveData.count > 0) {
        int index = receiveData.buffer[0];
        ftpClientA.addFolder(index);
      }
      break;
    case FILE_DOWNLOAD:
      receiveData.type = NONE;
      if (receiveData.count > 0) {
        int index = receiveData.buffer[0];
        ftpClientA.downloadFile(index);
      }
      break;
    case FILE_DOWNLOAD_LOAD_NEXT:
      receiveData.type = NONE;
      ftpClientA.downloadFileNext();
      break;
    case FTP_DIR_UP:
      receiveData.type = NONE;
      ftpClientA.changeDirUp();
      break;
    case FTP_DIR_INDEX:
      receiveData.type = NONE;
      if (receiveData.count > 0) {
        int index = receiveData.buffer[0];
        ftpClientA.changeDirByIndex(index);
      }
      break;
    case GET_MAC_Address:
      receiveData.type = NONE;
      val = WiFi.macAddress();
      createRequestBufferFrom(val);
      break;
    case GET_IP_Address:
      receiveData.type = NONE;
      val = WiFi.localIP().toString();
      val.toUpperCase();
      createRequestBufferFrom(val);
      break;  
    case GET_FTPURL_NEW:
      receiveData.type = NONE;
      val = String(data.ftpServerUrl);
      createRequestBufferFrom(val);
      break;  
    case GET_SSID_PASSWORD_NEW:
      receiveData.type = NONE;
      val = String(data.ssidPass);
      createRequestBufferFrom(val);
      break;  
    case GET_FTP_HOMEDIR_NEW:
      receiveData.type = NONE;
      val = String(data.ftpHomeDir);
      createRequestBufferFrom(val);
      break;  
    case GET_FTP_Port_NEW:
      receiveData.type = NONE;
      val = String(data.ftpPort);
      createRequestBufferFrom(val);
      break;  
    case GET_FTP_User_NEW:
      receiveData.type = NONE;
      val = String(data.ftpUser);
      createRequestBufferFrom(val);
      break;  
    case GET_FTP_Password_NEW:
      receiveData.type = NONE;
      val = String(data.ftpPass);
      createRequestBufferFrom(val);
      break;  
    case GET_SSID:
      receiveData.type = NONE;
      val = String(data.ssid);
      createRequestBufferFrom(val);
      break;
    case GET_FTP_DIR:
      receiveData.type = NONE;
      val = ftpClientA.getCurrentFolder();
      createRequestBufferFrom(val);
      break;
    case GET_FTP_DIR_NEW:  
      receiveData.type = NONE;
      val = ftpClientA.getCurrentFolderNew();
      createRequestBufferFrom(val);
      break;
    case GET_FTP_LIST_NEXT:
      receiveData.type = NONE;
      ftpListPos++;
      break;
    case GET_FTP_LIST_NEXT_NEW: 
      receiveData.type = NONE;
      ftpListPos++;
      break; 
    case GET_SSID_NEW_LIST_Next_Inc:
      receiveData.type = NONE;
      // -- SSIDListPos increment
      SSIDListPos += 1;
      break;
    case GET_NEXT_PAGE_BUFFER_NEW_INC:
      receiveData.type = NONE;
      // pageNum increment
      requestBufferData.pageNum += 1;
      break;
    case SET_STR16_FOR_KEY_PAGE:
      receiveData.type = NONE;
      if (receiveData.count > 10) {
        str16DataParser();
      } else {
        str16Data.state = 0x03;
      }
      break;
    case SET_FTP_GO_HOME_DIR:
      receiveData.type = NONE;
      ftpClientA.goToHomeDir();
      break;
    default:
      break;
  }
  i2cBusy = false;
  setBusy(false);
}

// -------------
// -= REQUEST =-
// -------------
void requestEvent() {
  setBusy(true);
  String val;
  switch (receiveData.type) {
    case NONE:
      Wire.write("Empty string"); //12 chars
      break;
    case GET_FILE:
      Wire.write("ESP-USER"); // send 14 bytes to master
      receiveData.type = NONE;
      break;
    case GET_SETTINGS:
      Wire.write((byte)45); // send 1 bytes to master
      receiveData.type = NONE;
      break;
    case GET_SSID_PASSWORD:
      data.ssidPass[15] = 0;
      Wire.write(data.ssidPass);
      receiveData.type = NONE;
      break;
    case GET_SSIDList:
      if(SSIDListPos < MAX_ENTRIES) {
        createSsidListBuffer();
        Wire.write(ssidListBuffer, 20);
        SSIDListPos++;
      } else {
        receiveData.type = NONE;
      }
      break;
    case GET_FTP_LIST_NEW:
      createFtpFileDataBufferB(ftpClientA.ftpFiles[ftpListPos]);
      Wire.write(ssidListBuffer, 15);
      break;  
    case GET_FTP_LIST:
      createFtpFileDataBufferA(ftpClientA.ftpFiles[ftpListPos]);
      Wire.write(ssidListBuffer, 14);
      // if (ftpListPos < ftpClientA.ftpFilesCount) {
      //   createFtpFileDataBufferA(ftpClientA.ftpFiles[ftpListPos]);
      //   Wire.write(ssidListBuffer, 14);
      //   ftpListPos++;
      // } else {
      //   ssidListBuffer[0] = ftpListPos;
      //   ssidListBuffer[1] = 90; //(0x5A)
      //   Wire.write(ssidListBuffer, 8);
      //   //Wire.write(0x00);
      //   //Wire.write(0x5A);
      //   receiveData.type = NONE;
      // }
      break;
    case STATE_SSID:
      updateStatus();
      if(WIFIflag==true){
        Wire.write(0x01);
      }else{
        Wire.write(0x00);
      }
      receiveData.type = NONE;
      break;
    case GET_SSIDList_Is_Ready:
      receiveData.type = NONE;
      Wire.write(SSIDList_Is_Ready);
      break; 
    case GET_I2C_Busy:
      receiveData.type = NONE;
      if (i2cBusy == true) {
        Wire.write(0x01);
      } else {
        Wire.write(0x00);
      }
      break; 
    case GET_FTPURL:
      data.ftpServerUrl[15] = 0;
      Wire.write(data.ftpServerUrl);
      receiveData.type = NONE;
      break;
    case GET_FTP_Port:
      data.ftpPort[5] = 0;
      Wire.write(data.ftpPort);
      receiveData.type = NONE;
      break;
    case GET_FTP_User:
      data.ftpUser[15] = 0;
      Wire.write(data.ftpUser);
      receiveData.type = NONE;
      break;
    case GET_FTP_Password:
      data.ftpPass[15] = 0;
      Wire.write(data.ftpPass);
      receiveData.type = NONE;
      break;
    case GET_FTP_STATE:
      receiveData.type = NONE;
      if (ftpClientA.getFtpDataConnected() == true) {
        Wire.write(0x01);
      } else {
        Wire.write(0x00);
      }
      break;
    case FILE_DOWNLOAD_GET_NEXT:
      Wire.write(ftpClientA.fileDownloadData.bytes, (ftpClientA.bytesPageCount + ftpClientA.bytesPropertyCount + 2));
      break;
    case GET_NEXT_PAGE_BUFFER:
      createNextRequestBuffer();
      Wire.write(ssidListBuffer, (requestBufferData.pageSize + 4));
      break;
    case GET_NEXT_PAGE_BUFFER_NEW:
      createNextRequestBufferA();
      Wire.write(ssidListBuffer, (requestBufferData.pageSize + 4));
      break;
    case GET_SSID_NEW_LIST_NEXT:
      receiveData.type = NONE;
      createSsidNewNexBuffer();
      Wire.write(ssidNexBuffer, 5);
      break;
    case GET_STR16_FOR_KEY_PAGE_STATE:
      receiveData.type = NONE;
      createstr16DataState();
      Wire.write(ssidNexBuffer, 4);
      break;  
    case GET_ALL_STATE:
      receiveData.type = NONE;
      createAllStateBuffer();
      Wire.write(ssidNexBuffer, 5);
      break;
    default:
      receiveData.type = NONE;
      break;
  };
  setBusy(false);
}