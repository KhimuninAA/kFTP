//
//  ESPFunctions.h
//  i2C-8080
//
//  Created by Алексей Химунин on 21.12.2025.
//

#ifndef ESPFunctions_h
#define ESPFunctions_h

/// вх. [L] - комманада
/// вх. [H] - кл-во байт
/// вх. [ESP_I2S_BUFFER] - байты для отправки
void sendCommand() {
    push_pop(de) {
        d = h;
        // form the slave address with the R/W bit (R=1, W=0) at LSB
        a ^= a; // XRA     A Carry = 0
        a = CHIP_ADDRESS;
        carry_rotate_left(a, 1); // shift address left, set R/W bit to 0 (write)
        h = a;
        
        startI2C();
        c = h;
        transmitNewI2C(); // Адрес и направление
        
        c = l;
        transmitNewI2C(); // Комманда
        
        // Отправляемые данные
        if ((a = d) > 0) {
            h = d;
            de = ESP_I2S_BUFFER;
            do {
                a = *de;
                de++;
                c = a;
                transmitNewI2C();
                h--;
            } while(flag_nz);
        }

        // Конец отправки
        stopI2C();
    }
}

/// вх. [L] - Кол-во считываемых байт
void readNewInBuffer() {
    push_pop(hl) {
        push_pop(de) {
            a ^= a; // XRA
            a = CHIP_ADDRESS;
            carry_rotate_left(a, 1);
            a += 1;
            h = a;
            //
            startI2C();
            c = h;
            transmitNewI2C();
            
            i2cWaitingForAccess();
            
            //l = 20;
            de = ESP_I2S_BUFFER;
            do {
                push_pop(bc) {
                    recieveNewI2C();
                    a = c;
                }
                *de = a;
                de++;
                l--;
                a = l;
            } while (a > 0);
            a = 0; // stop byte
            *de = a;
            //
            stopI2C();
        }
    }
}

uint8_t ESP_I2S_BUFFER[32];

#endif /* ESPFunctions_h */
