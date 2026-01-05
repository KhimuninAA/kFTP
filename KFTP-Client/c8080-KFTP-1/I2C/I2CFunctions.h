//
//  I2CFunctions.h
//  i2C-8080
//
//  Created by Алексей Химунин on 21.12.2025.
//

#ifndef I2CFunctions_h
#define I2CFunctions_h

#define NOPS nop(); nop(); nop(); nop(); //nop();
//nop(); //nop(); nop(); nop(); //nop(); nop();
//nop(); nop(); nop(); nop(); nop(); nop(); nop(); nop(); nop(); nop();
#define _SLOW_SETTINGS

void initI2C() {
    a = 0x81;
    VV55_SETUP = a;
    #ifdef _SLOW_SETTINGS
    NOPS
    #endif
    a = 0xC0;
    VV55_PORT_C = a;
}

void startI2C() {
    #ifdef _SLOW_SETTINGS
    NOPS
    #endif
    a = 0x40;
    VV55_PORT_C = a;
    #ifdef _SLOW_SETTINGS
    NOPS
    #endif
    nop();
    a = 0x00;
    VV55_PORT_C = a;
}

void stopI2C() {
    #ifdef _SLOW_SETTINGS
    NOPS
    #endif
    a = 0x40;
    VV55_PORT_C = a;
    #ifdef _SLOW_SETTINGS
    NOPS
    #endif
    nop();
    a = 0xC0;
    VV55_PORT_C = a;
}

/// вх. [A] - устанавливаемое значение (8 бит)
void setSDAI2C(){
//    #ifdef _SLOW_SETTINGS
//    NOPS
//    #endif
    a &= 0x80;
    I2C_CURRETN_VALUE = a;
    VV55_PORT_C = a;
}

void pulseNewI2C() {
    #ifdef _SLOW_SETTINGS
    NOPS
    #endif
    a = I2C_CURRETN_VALUE;
    a += 0x40;
    VV55_PORT_C = a;
//    /// - Проверим что SLAVE не тормозит передачу -
//    /// - После установки 1 - проверяем - есть ли 1 на SCL. Если там 0 - то ждем SLAVE
//    do {
//        a = VV55_PORT_C;
//        a &= 0x40;
//    } while (a != 0x40);
//    /// -------------------------------------
    #ifdef _SLOW_SETTINGS
    NOPS
    #endif
    nop();
    a = I2C_CURRETN_VALUE;
    a += 0x00;
    VV55_PORT_C = a;
}

/// вх. [C] передаваемый байт
/// вых.[A]=0 - OK
void transmitNewI2C() {
    push_pop(bc) {
        b = 8;
        do {
            setSDAI2C(a = c);
            pulseNewI2C();
            a = c;
            carry_rotate_left(a, 1);
            c = a;
            b--;
        } while (flag_nz);
        
        setSDAI2C(a = 0x80);
        a = VV55_PORT_C;
        a &= 1;
        b = a;
        setSDAI2C(a = 0x00);
        pulseNewI2C();
        a = b;
    }
}

/// вых.[C] принятый байт
/// вых.[B] ACK/NAK
void recieveNewI2C() {
    push_pop(de) {
        setSDAI2C(a = 0x80);
        c = 0;
        d = 0x08;
        do {
            a = c;
            carry_rotate_left(a, 1);
            c = a;
            a = VV55_PORT_C; // READ BIT
            a &= 1;
            a += c;
            c = a;
            pulseNewI2C();
            d--;
            a = d;
        } while (flag_nz);
//        setSDAI2C(a = 0x80);
//        a &= 1;
//        b = a;
//        setSDAI2C(a = 0x00);
//        if ((a = b) == 0x01) {
//            setSDAI2C(a = 0x80);
//        } else {
//            setSDAI2C(a = 0x00);
//        }
        
        setSDAI2C(a = 0x00);
        
        pulseNewI2C();
        
        a = VV55_PORT_C;
        a &= 1;
        b = a;
    }
}

/// вых.[B] - 1 устройство занято
void i2cBusy() {
    a = VV55_PORT_C;
    a &= 2;
    carry_rotate_right(a, 1);
}

/// Ожидание готовности I2C
void i2cWaitingForAccess() {
    do {
        i2cBusy();
        if (a == 1) {
            nop();
            nop();
            nop();
            nop();
            nop();
        }
    } while (a == 1);
}

void delay5msI2C() {
    push_pop(bc) {
        bc = 0x500;
        do {
            bc--;
            a = b;
            a |= c;
        } while (flag_nz);
    }
}

void busRecoveryI2C() {
    startI2C();
    a = 0;
    setSDAI2C();
    pulseNewI2C();
    pulseNewI2C();
    pulseNewI2C();
    pulseNewI2C();
    pulseNewI2C();
    pulseNewI2C();
    pulseNewI2C();
    pulseNewI2C();
    pulseNewI2C();
    stopI2C();
    
    
}

#include "I2CSettigs.h"

#endif /* I2CFunctions_h */
