#ifndef FTP_FILE_DATA_H_
#define FTP_FILE_DATA_H_

#include <Arduino.h> 

struct FtpFileDownloadData{
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
  byte bytes[24];
};

struct FtpFileData {
  public:
    String name;
    bool isDir;
    String data;
    int size;
    bool isHidden;

    String orionName() {
      String temp = name;
      temp.toUpperCase();
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