//
//  RootViewValue.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 17.09.2025.
//

#ifndef RootViewValue_h
#define RootViewValue_h

/// Какое окно сейчас активно
/// 0 - главный экран с 4-мя окошками. Фокус на квазедиске
/// 1 - главный экран с 4-мя окошками. Фокус на FTP просмотре
/// 2 - Экран настройки подключения к FTP
/// 3 - Экран настройки подключения к Wi-Fi
uint8_t rootViewCurrentView = 0;

uint16_t rootViewHelpStrPos = 0x0600;
uint8_t rootViewHelpStr[] = " F1: ..          F2: WI-FI          F3: FTP          F4: QUIT";

uint8_t rootViewOldKey = 0xFF;

#endif /* RootViewValue_h */
