//
//  ESPInclude.h
//  i2C-8080
//
//  Created by Алексей Химунин on 21.12.2025.
//

#ifndef ESPInclude_h
#define ESPInclude_h

extern uint8_t ESP_I2S_BUFFER[32];

/// вх. [L] - комманада
/// вх. [H] - кл-во байт
/// вх. [ESP_I2S_BUFFER] - байты для отправки
void sendCommand();
/// вх. [L] - Кол-во считываемых байт
void readNewInBuffer();

#endif /* ESPInclude_h */
