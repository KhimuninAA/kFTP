//
//  DiskView.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 16.09.2025.
//

#ifndef DiskView_h
#define DiskView_h

uint8_t diskViewX = 0;
uint8_t diskViewY = 7;
uint8_t diskViewEX = 29; //54;
uint8_t diskViewEY = 25;

uint16_t diskViewLabelPos = 0x0709;
uint8_t diskViewLabel[] = " DISK:   ";

uint8_t diskViewDiskNum = 'B';
uint8_t diskViewListCount = 0;
uint8_t diskViewCurrPos = 1;
uint16_t diskViewListNamePos = 0x0902;

uint16_t diskViewListDirPos = 0x0802;
uint8_t diskViewListDirLabel[] = " ..       ";

uint16_t diskViewDriveNamePos = 0x0710;

uint16_t diskStartNewFile = 0x0000;

#endif /* DiskView_h */
