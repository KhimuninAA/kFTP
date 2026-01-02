//
//  I2CInclude.h
//  i2C-8080
//
//  Created by Алексей Химунин on 21.12.2025.
//

#ifndef I2CInclude_h
#define I2CInclude_h

#include "I2CDefine.h"

void initI2C();
void startI2C();
void stopI2C();
void delay5msI2C();

void setSDAI2C();
void pulseNewI2C();
void transmitNewI2C();
void recieveNewI2C();

/// вых.[B] - 1 устройство занято
void i2cBusy();
/// Ожидание готовности I2C
void i2cWaitingForAccess();

void busRecoveryI2C();

#endif /* I2CInclude_h */
