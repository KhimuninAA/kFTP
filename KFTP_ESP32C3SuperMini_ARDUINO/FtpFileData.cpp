#include "FtpFileData.h"

FtpFileData FtpFileDataHelper::parse(String src) {
  FtpFileData parseFtpFileData;
  parseFtpFileData.name = "";
  parseFtpFileData.isDir = false;
  parseFtpFileData.data = "";
  parseFtpFileData.size = 0;
  parseFtpFileData.isHidden = true;

  parseL(src, &parseFtpFileData);

  return parseFtpFileData;
}

void FtpFileDataHelper::parseL(String src, FtpFileData *ftpFileData) {
  int inxed = 0;
  int seek = -1;
  String temp = src;
  do {
    seek = temp.indexOf(';');
    if (seek >= 0) {
      String value = temp.substring(0, seek);
      paramValue(value, ftpFileData);
      temp = temp.substring(seek + 1);
    } else if (temp.length() > 0) {
      ftpFileData->name = temp;
      ftpFileData->name.trim();
      if (ftpFileData->name == ".DS_Store") {
        ftpFileData->isHidden = true;
      }
    }
  }while(seek >= 0);
}

void FtpFileDataHelper::paramValue(String src, FtpFileData *ftpFileData) {
  int seek = src.indexOf('=');
  if (seek >= 0) {
    String val = src.substring(seek + 1);
    String param = src.substring(0, seek);
    if (param == "size") {
      ftpFileData->size = val.toInt();
    } else if (param == "type") {
      if (val == "cdir") {
        ftpFileData->isHidden = true;
      } else {
        ftpFileData->isHidden = false;
        if ((val == "pdir") || (val == "dir")) {
          ftpFileData->isDir = true;
        } else {
          ftpFileData->isDir = false;
        }
      }
    }
  }
}