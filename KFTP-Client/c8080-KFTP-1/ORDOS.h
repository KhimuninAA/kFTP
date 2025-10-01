//
//  ORDOS.h
//  c8080-KFTP-1
//
//  Created by Алексей Химунин on 16.09.2025.
//

#pragma once

///-----* Функции ORDOS *-------
///определение текущего диска
void ordos_wnd() __address(0xbfd6);
///запись н/адреса буфера имени файла
void ordos_sdma() __address(0xbfd0);
///запись адресов (н/к) блока озу
void ordos_watf() __address(0xbfca);
///пп.записи файла на диск
void ordos_wfile() __address(0xbff7);
///запись стоп-слова в диск
void ordos_stop() __address(0xbfe2);
/// вывод каталога диска в буфер
void ordos_dirm() __address(0xbfe8);
/// вход в ос "ordos"
void ordos_start() __address(0xbffd);
/// конеч.адрес программ.на диске (FF адрес стоп байта) HL
void ordos_mxdsk() __address(0xbfb8);
/// чтение максимального адреса диска HL
void ordos_rmax() __address(0xbfc1);
/// запись байта в диск HL-addr A-byte
void ordos_wdisk() __address(0xbfdf);

