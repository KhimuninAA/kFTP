#include "I2CEvents.h"
#include <WiFi.h>
#include <Wire.h>
#include "WIFIMy.h"

//struct 
ReceiveData receiveData = {NONE, ""};
uint8_t ftpListPos = 0;

byte ssidListBuffer[20];
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
  Serial.println(ssidsData[SSIDListPos].ssidCh);
}

void createSsidBuffer() {
  memset(ssidListBuffer, 0, sizeof(ssidListBuffer));
  char ssidCh[16];
  String newSSID = data.ssid;
  newSSID.toUpperCase();
  strncpy(ssidCh, newSSID.c_str(), 16);
  int pos = 0;
  for(int j = 0; j < 16; j++) {
    char c = ssidCh[j];
    if (c < 0x60) {
      ssidListBuffer[pos] = c;
      pos++;
    } else if (c == 0) {
      ssidListBuffer[pos] = 0;
      break;
    }
  }
  if (pos >= 15) {
    ssidListBuffer[pos] = 0;
  }
}

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
  Serial.println(data.orionName());
  Serial.println(ssidListBuffer[3]);
  Serial.println(ssidListBuffer[4]);
  Serial.println(size16);
  Serial.println(data.size);
}

// -------------
// -= RECEIVE =-
// -------------
void receiveEvent(int howMany) {
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
      } else {
        char c = Wire.read(); 
        receiveData.buffer[count - 1] = c;
      }
      count++;
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
          Serial.println("Save SSID");
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
        Serial.println("Save SSID PASSWORD");
      }
      break;
    case UPDATE_SSIDList:
      receiveData.type = NONE;
      listSSID();
      SSIDListPos = 0;
      break;
    case UPDATE_FTP_LIST:
      receiveData.type = NONE;
      ftpClientA.updateFtpList();
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
  Serial.print("request type : ");
  Serial.print(receiveData.type);
  Serial.println();
  String val;
  switch (receiveData.type) {
    case NONE:
      //Wire.write("Empty string"); //12 chars
      Wire.print("REQUEST NONE");
      Serial.println(F("Not good, no request type!"));
      break;
    case GET_FILE:
      //Wire.write(F("ESP-USER")); // send 14 bytes to master
      Wire.print("ESP-USER");
      receiveData.type = NONE;
      break;
    case GET_SETTINGS:
      Wire.write((byte)45); // send 1 bytes to master
      receiveData.type = NONE;
      break;
    case GET_SSID:
      createSsidBuffer();
      Wire.write(ssidListBuffer, 20);
      receiveData.type = NONE;
      break;
    case GET_SSID_PASSWORD:
      data.ssidPass[15] = 0;
      Wire.write((const uint8_t*)data.ssidPass, sizeof(data.ssidPass));
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
    case GET_FTP_LIST:
      if (ftpListPos < ftpClientA.ftpFilesCount) {
        createFtpFileDataBuffer(ftpClientA.ftpFiles[ftpListPos]);
        Wire.write(ssidListBuffer, 16);
        ftpListPos++;
      } else {
        ssidListBuffer[0] = ftpListPos;
        ssidListBuffer[1] = 90; //(0x5A)
        Wire.write(ssidListBuffer, 8);
        //Wire.write(0x00);
        //Wire.write(0x5A);
        receiveData.type = NONE;
      }
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
    case GET_IP_Address:
      val = WiFi.localIP().toString();
      val.toUpperCase();
      //Wire.write(F(val.c_str()));
      Wire.print(val);
      receiveData.type = NONE;
      break;
    case GET_MAC_Address:
      val = WiFi.macAddress();
      //Wire.write(F(val.c_str()));
      Wire.print(val);
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
      Wire.write((const uint8_t*)data.ftpServerUrl, sizeof(data.ftpServerUrl));
      receiveData.type = NONE;
      break;
    case GET_FTP_Port:
      data.ftpPort[5] = 0;
      Wire.write((const uint8_t*)data.ftpPort, sizeof(data.ftpPort));
      receiveData.type = NONE;
      break;
    case GET_FTP_User:
      data.ftpUser[15] = 0;
      Wire.write((const uint8_t*)data.ftpUser, sizeof(data.ftpUser));
      receiveData.type = NONE;
      break;
    case GET_FTP_Password:
      data.ftpPass[15] = 0;
      Wire.write((const uint8_t*)data.ftpPass, sizeof(data.ftpPass));
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
      Wire.write(ftpClientA.fileDownloadData.bytes, (ftpClientA.bytesPageCount + 6));
      break;
    default:
      receiveData.type = NONE;
      break;
  };
  setBusy(false);
}