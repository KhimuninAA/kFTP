//
//  ExtDiskView.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 16.09.2025.
//

#ifndef ExtDiskView_h
#define ExtDiskView_h

extern uint8_t diskViewX;
extern uint8_t diskViewY;
extern uint8_t diskViewEX;
extern uint8_t diskViewEY;

extern uint16_t diskViewLabelPos;
extern uint8_t diskViewLabel[10];

extern uint8_t diskViewDiskNum;
extern uint8_t diskViewListCount;
extern uint8_t diskViewCurrPos;
extern uint16_t diskViewListNamePos;

const uint16_t startListBufer = 0x0000;

extern uint16_t diskViewListDirPos;
extern uint8_t diskViewListDirLabel[11];

extern uint16_t diskViewDriveNamePos;

extern uint16_t diskStartNewFile;

#endif /* ExtDiskView_h */
