#ifndef FTP_FILE_DATA_H_
#define FTP_FILE_DATA_H_

#include <Arduino.h> 

struct RequestBufferData{
  byte pageSize;
  byte lengtn;
  byte pageNum;
  byte buffer[64];
};

#pragma pack(push, 1) 

struct FtpFileDownloadData {
  byte structSize;
  uint16_t addr;
  byte progressAndNext;
  byte buffer[17];
  uint16_t fileSize;

  void setSize(byte property, byte data) {
    structSize = (property & 0x07) + ((data & 0x1f)<<3);
  }
  void setProgress(byte progress, bool isNext) {
    byte next = 0x40;
    if (isNext == true) {
      next = 0x80;
    }
    progressAndNext = (progress & 0x3f) + next;
  }
  int propertySize() {
    return (int)(structSize & 0x07);
  }
  int dataSize() {
    return (int)((structSize & 0xF8)>>3);
  }
  void updateSUM() {
    int size = dataSize() + propertySize();
    byte* pointSelf = (byte*) &structSize;
    uint8_t sum = 0;
    for(int i = 0; i < size; i++){
      sum += pointSelf[i];
    }
    pointSelf[size] = sum;
  }
};
#pragma pack(pop)

struct FtpFileDownloadDataOld{
  uint16_t addr;
  byte stopByte;
  byte sum;
  byte progress;
  byte pageSize;
  byte buffer[16];
  uint16_t fileSize;
};

union UnionFtpFileDownloadData {
  FtpFileDownloadData downloadData; 
  byte bytes[23]; //24
};

struct FtpFileData {
  public:
    String name;
    bool isDir;
    String data;
    int size;
    bool isHidden;

    String orionName() {
      //char  en_a_Char = 0x61;
      String temp = name;
      temp.toUpperCase();
      // for (int i = 0; i < temp.length(); i++) {
      //   uint8_t charByte = (uint8_t)temp.charAt(i);
      //   if (charByte >= (uint8_t)en_a_Char) {

      //   }
      // }
      return temp;
    }
};

class FtpFileDataHelper {
  private:
  static void parseL(String src, FtpFileData *ftpFileData);
  static void paramValue(String src, FtpFileData *ftpFileData);

  public:
  static FtpFileData parse(String src);
};

#endif