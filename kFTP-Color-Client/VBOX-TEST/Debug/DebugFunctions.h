//
//  DebugFunctions.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef DebugFunctions_h
#define DebugFunctions_h

void debug() {
    push_pop(hl, bc) {
        b = a;
        h = 1;
        l = 1;
        setPosCursor();
        printHexA(a = b);
    }
}

void debugStartVboxAddr() {
    push_pop(hl, bc) {
        b = a;
        h = 1;
        l = 1;
        setPosCursor();
        hl = startVboxAddr;
        printHexA(a = h);
        printHexA(a = l);
    }
}

#endif /* DebugFunctions_h */
