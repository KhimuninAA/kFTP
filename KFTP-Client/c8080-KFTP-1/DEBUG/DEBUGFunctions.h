//
//  DEBUGFunctions.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 15.01.2026.
//

#ifndef DEBUGFunctions_h
#define DEBUGFunctions_h

void DEBUGFirstCurA() {
    push_pop(hl) {
        l = 1;
        h = a;
        setPosCursor();
    }
}

void DEBUGShowHexA() {
    printHexA();
    a = ' ';
    printChatA();
}

#endif /* DEBUGFunctions_h */
