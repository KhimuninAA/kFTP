    device zxspectrum48 ; There is no ZX Spectrum, it is needed for the sjasmplus assembler.
ordos_wnd equ 49110
ordos_sdma equ 49104
ordos_watf equ 49098
ordos_wfile equ 49143
ordos_stop equ 49122
ordos_dirm equ 49128
ordos_start equ 49149
ordos_mxdsk equ 49080
ordos_rmax equ 49089
ordos_wdisk equ 49119
ordos_rdisk equ 49116
fontaddress equ 62417
inverceaddress equ 62419
printhexa equ 63509
printchata equ 63503
printchatc equ 63497
writebyteinothermem equ 63545
setposcursor equ 63548
getposcursor equ 63518
printhlstr equ 63512
getkeyboardchara equ 63491
getkeyboardstatea equ 63506
getkeyboardcodea equ 63515
vv55_setup equ 62979
vv55_port_c equ 62978
; 12 void ordos_wnd() __address(0xbfd6);
; 13 ///запись н/адреса буфера имени файла
; 14 void ordos_sdma() __address(0xbfd0);
; 15 ///запись адресов (н/к) блока озу
; 16 void ordos_watf() __address(0xbfca);
; 17 ///пп.записи файла на диск
; 18 void ordos_wfile() __address(0xbff7);
; 19 ///запись стоп-слова в диск
; 20 void ordos_stop() __address(0xbfe2);
; 21 /// вывод каталога диска в буфер
; 22 void ordos_dirm() __address(0xbfe8);
; 23 /// вход в ос "ordos"
; 24 void ordos_start() __address(0xbffd);
; 25 /// конеч.адрес программ.на диске (FF адрес стоп байта) HL
; 26 void ordos_mxdsk() __address(0xbfb8);
; 27 /// чтение максимального адреса диска HL
; 28 void ordos_rmax() __address(0xbfc1);
; 29 /// запись байта в диск HL-addr A-byte
; 30 void ordos_wdisk() __address(0xbfdf);
; 31 /// чтение байта из диска HL-addr A-byte
; 32 void ordos_rdisk() __address(0xbfdc);
; 12 extern uint16_t fontAddress __address(0xF3D1);
; 13 ///ячейка, хранящая признак прямого (00Н) вывода (светлые символы на темном фоне) или инверсного (0FFH) вывода (темные символы на светлом фоне)
; 14 extern uint16_t inverceAddress __address(0xF3D3);
; 15 
; 16 ///-----* Функции Монитора *-------
; 17 ///Вывод на экран HEX из регистра A
; 18 void printHexA() __address(0xF815);
; 19 ///Вывод символа на экран из регистра A
; 20 void printChatA() __address(0xF80F);
; 21 ///Вывод символа на экран из регистра С
; 22 void printChatC() __address(0xF809);
; 23 ///ЗАПИСЬ БАЙТА В ДОП. СТРАНИЦУ HL — АДРЕСА — N СТРАНИЦЫ (0-3) C — ЗАПИСЫВАЕМЫЙ БАЙТ
; 24 void writeByteInOtherMem() __address(0xF839);
; 25 ///УСТАНОВКА КУРСОРА ВХ. Н — НОМЕР СТРОКИ — Y L — НОМЕР ПОЗИЦИИ — X
; 26 void setPosCursor() __address(0xF83C);
; 27 ///ЗАПРОС ПОЛОЖЕНИЯ КУРСОРА Н - НОМЕР СТРОКИ - Y , L - НОМЕР ПОЗИЦИИ - X
; 28 void getPosCursor() __address(0xF81E);
; 29 ///ВЫВОД НА ЭКРАН СООБЩЕНИЯ ВХ.: HL- - АДРЕС НАЧАЛА КОНЕЧНЫЙ БАЙТ - 00Н
; 30 void printHLStr() __address(0xF818);
; 31 
; 32 ///ВВОД C СИМВОЛА С КЛАВИАТУРЫ А - ВВЕДЕННЫЙ СИМВОЛ
; 33 void getKeyboardCharA() __address(0xF803);
; 34 ///ОПРОС СОСТОЯНИЯ КЛАВИАТУРЫ А = 00Н - НЕ НАЖАТА , А = 0FFH - НАЖАТА
; 35 void getKeyboardStateA() __address(0xF812);
; 36 ///ВВОД КОДА НАЖАТОЙ КЛАВИШИ А = 0FFH - НЕ НАЖАТА А = 0FEH - РУС/ЛАТ ИНАЧЕ - КОД КЛАВИШИ
; 37 void getKeyboardCodeA() __address(0xF81B);
; 11 extern uint16_t VV55_SETUP __address(0xF603);
; 12 extern uint16_t VV55_PORT_C __address(0xF602);

    org 0x00F0

; 21 uint8_t appName[] = {'K','F','T','P','$',' ',' ',' '};
appname:
	db 75
	db 70
	db 84
	db 80
	db 36
	db 32
	db 32
	db 32


    DB 0x00, 0x01

    DB 0x00, 0x1C

    DB 0x00, 0x00, 0x00, 0x00

; 32 void main(){
main:
; 33     updateDiskList();
	call updatedisklist
; 34     initI2C();
	call initi2c
; 35     ///
; 36     
; 37     /// WiFI
; 38     delay5msI2C(); delay5msI2C();
	call delay5msi2c
	call delay5msi2c
; 39     getSSIDValue();
	call getssidvalue
; 40     delay5msI2C(); delay5msI2C();
	call delay5msi2c
	call delay5msi2c
; 41     getSSIDPasswordValue();
	call getssidpasswordvalue
; 42     
; 43     /// FTP
; 44     delay5msI2C(); delay5msI2C();
	call delay5msi2c
	call delay5msi2c
; 45     getFTPUrl();
	call getftpurl
; 46     delay5msI2C(); delay5msI2C();
	call delay5msi2c
	call delay5msi2c
; 47     getFTPUser();
	call getftpuser
; 48     delay5msI2C(); delay5msI2C();
	call delay5msi2c
	call delay5msi2c
; 49     getFTPPassword();
	call getftppassword
; 50     delay5msI2C(); delay5msI2C();
	call delay5msi2c
	call delay5msi2c
; 51     getFTPPort();
	call getftpport
; 52     
; 53     ///
; 54     updateRootUI();
	call updaterootui
; 55     
; 56     updateRootDataUI();
	call updaterootdataui
; 57     
; 58     //Бесконечный цикл. Что бы увидеть результат
; 59     for (;;) {
l_1:
; 60         getKeyboardStateA();
	call getkeyboardstatea
; 61         if (a == 0xFF) {
	cp 255
	jp nz, l_3
; 62             // Если клавиша нажата - вызываем обработчик
; 63             keyboardEvent();
	call keyboardevent
	jp l_4
l_3:
; 64         } else {
; 65             a = rootTimerTike;
	ld a, (roottimertike)
; 66             if (a >= 240) {
	cp 240
	jp c, l_5
; 67                 a = 0;
	ld a, 0
; 68                 rootTimerTike = a;
	ld (roottimertike), a
; 69                 if ((a = rootViewCurrentView) == rootViewCurrentDiskView) {
	ld a, (rootviewcurrentview)
	or a
	jp nz, l_7
; 70                     updateWiFiStatus();
	call updatewifistatus
; 71                     updateFtpStatus();
	call updateftpstatus
l_7:
	jp l_6
l_5:
; 72                 }
; 73             } else {
; 74                 a++;
	inc a
; 75                 rootTimerTike = a;
	ld (roottimertike), a
l_6:
l_4:
	jp l_1
; 76             }
; 77         }
; 78     }
; 79 }
; 80 
; 81 void keyboardEvent() {
keyboardevent:
; 82     getKeyboardCodeA();
	call getkeyboardcodea
; 83     l = a; //Save key
	ld l, a
; 84     if ((a = rootViewOldKey) != l) {
	ld a, (rootviewoldkey)
	cp l
	jp z, l_9
; 85         a = l; //Load key
	ld a, l
; 86         rootViewOldKey = a;
	ld (rootviewoldkey), a
; 87         push_pop(hl) {
	push hl
; 88             a = l; //Load key
	ld a, l
; 89             if (a != 0xFF) {
	cp 255
	jp z, l_11
; 90                 /// Hot ley
; 91                 if (a == 0x03) { //F4 quit ordos
	cp 3
	jp nz, l_13
; 92                     ordos_start();
	call ordos_start
	jp l_14
l_13:
; 93                 } else if (a == 0x02) { //F3 Open FTP settings
	cp 2
	jp nz, l_15
; 94                     needOpenFTPSettingsEditView();
	call needopenftpsettingseditview
	jp l_16
l_15:
; 95                 } else if (a == 0x01) { //F2 Open WiFi settings
	cp 1
	jp nz, l_17
; 96                     needOpenWiFiSettingsEditView();
	call needopenwifisettingseditview
	jp l_18
l_17:
; 97                 } else if (a == 'C') { // Button C
	cp 67
	jp nz, l_19
; 98                     createTestFile();
	call createtestfile
; 99                     updateDiskList();
	call updatedisklist
; 100                     updateRootUI();
	call updaterootui
; 101                     showDiskList();
	call showdisklist
l_19:
l_18:
l_16:
l_14:
; 102                 }
; 103                 
; 104                 /// View's
; 105                 if ((a = rootViewCurrentView) == rootViewCurrentDiskView) { // Local disk
	ld a, (rootviewcurrentview)
	or a
	jp nz, l_21
; 106                     a = l; //Load key
	ld a, l
; 107                     diskViewKeyA();
	call diskviewkeya
; 108                     showDiskList(); //Refresh
	call showdisklist
	jp l_22
l_21:
; 109                 } else if ((a = rootViewCurrentView) == rootViewCurrentFTPView) { // FTP Dir
	ld a, (rootviewcurrentview)
	cp 1
	jp nz, l_23
; 110                     a = l; //Load key
	ld a, l
; 111                     ftpViewKeyA();
	call ftpviewkeya
; 112                     ftpViewDataUpdate();
	call ftpviewdataupdate
	jp l_24
l_23:
; 113                 } else if ((a = rootViewCurrentView) == rootViewCurrentFTPSettingsEditView) {
	ld a, (rootviewcurrentview)
	cp 2
	jp nz, l_25
; 114                     a = l; //Load key
	ld a, l
; 115                     ftpSettingsEditViewKeyA();
	call ftpsettingseditviewkeya
; 116                     ftpSettingsEditViewDataUpdate();
	call ftpsettingseditviewdataupdate
	jp l_26
l_25:
; 117                 } else if ((a = rootViewCurrentView) == rootViewCurrentWiFiSettingsEditView) {
	ld a, (rootviewcurrentview)
	cp 3
	jp nz, l_27
; 118                     a = l; //Load key
	ld a, l
; 119                     wifiSettingsEditViewKeyA();
	call wifisettingseditviewkeya
; 120                     wifiSettingsEditViewDataUpdate();
	call wifisettingseditviewdataupdate
	jp l_28
l_27:
; 121                 } else if ((a = rootViewCurrentView) == rootSSIDListView) {
	ld a, (rootviewcurrentview)
	cp 4
	jp nz, l_29
; 122                     a = l; //Load key
	ld a, l
; 123                     SSIDListViewKeyA();
	call ssidlistviewkeya
; 124                     SSIDListViewDataUpdate();
	call ssidlistviewdataupdate
l_29:
l_28:
l_26:
l_24:
l_22:
l_11:
	pop hl
l_9:
	ret
; 125                 }
; 126                 //printHexA();
; 127             }
; 128         }
; 129     }
; 130 }
; 131 
; 132 void updateRootDataUI() {
updaterootdataui:
; 133     showDiskList();
	jp showdisklist
; 134 }
; 135 
; 136 void updateRootUI() {
updaterootui:
; 137     a = 0x00;
	ld a, 0
; 138     inverceAddress = a;
	ld (inverceaddress), a
; 139     clearScreen();
	call clearscreen
; 140     
; 141     a = 0x00;
	ld a, 0
; 142     inverceAddress = a;
	ld (inverceaddress), a
; 143     showWiFiView();
	call showwifiview
; 144     a = 0x00;
	ld a, 0
; 145     inverceAddress = a;
	ld (inverceaddress), a
; 146     showFtpView();
	call showftpview
; 147     a = 0x00;
	ld a, 0
; 148     inverceAddress = a;
	ld (inverceaddress), a
; 149     diskView();
	call diskview
; 150     a = 0x00;
	ld a, 0
; 151     inverceAddress = a;
	ld (inverceaddress), a
; 152     ftpView();
	call ftpview
; 153     
; 154     showHelpStr();
	jp showhelpstr
; 155 }
; 156 
; 157 void ftpView() {
ftpview:
; 158     drowRectX = (a = ftpViewX);
	ld a, (ftpviewx)
	ld (drowrectx), a
; 159     drowRectY = (a = ftpViewY);
	ld a, (ftpviewy)
	ld (drowrecty), a
; 160     drowRectEndX = (a = ftpViewEX);
	ld a, (ftpviewex)
	ld (drowrectendx), a
; 161     drowRectEndY = (a = ftpViewEY);
	ld a, (ftpviewey)
	ld (drowrectendy), a
; 162     drowRect();
	call drowrect
; 163     
; 164     hl = ftpLabelPos;
	ld hl, (ftplabelpos)
; 165     setPosCursor();
	call setposcursor
; 166     hl = ftpLabel;
	ld hl, ftplabel
; 167     printHLStr();
	jp printhlstr
; 168 }
; 169 
; 170 void diskView() {
diskview:
; 171     drowRectX = (a = diskViewX);
	ld a, (diskviewx)
	ld (drowrectx), a
; 172     drowRectY = (a = diskViewY);
	ld a, (diskviewy)
	ld (drowrecty), a
; 173     drowRectEndX = (a = diskViewEX);
	ld a, (diskviewex)
	ld (drowrectendx), a
; 174     drowRectEndY = (a = diskViewEY);
	ld a, (diskviewey)
	ld (drowrectendy), a
; 175     drowRect();
	call drowrect
; 176     
; 177     hl = diskViewLabelPos;
	ld hl, (diskviewlabelpos)
; 178     setPosCursor();
	call setposcursor
; 179     hl = diskViewLabel;
	ld hl, diskviewlabel
; 180     printHLStr();
	jp printhlstr
; 181 }
; 182 
; 183 void showWiFiView() {
showwifiview:
; 184     drowRectX = (a = wifiSettingsViewX);
	ld a, (wifisettingsviewx)
	ld (drowrectx), a
; 185     drowRectY = (a = wifiSettingsViewY);
	ld a, (wifisettingsviewy)
	ld (drowrecty), a
; 186     drowRectEndX = (a = wifiSettingsViewEX);
	ld a, (wifisettingsviewex)
	ld (drowrectendx), a
; 187     drowRectEndY = (a = wifiSettingsViewEY);
	ld a, (wifisettingsviewey)
	ld (drowrectendy), a
; 188     drowRect();
	call drowrect
; 189     
; 190     hl = wifiSettingsPos;
	ld hl, (wifisettingspos)
; 191     setPosCursor();
	call setposcursor
; 192     hl = wifiSettingsLabel;
	ld hl, wifisettingslabel
; 193     printHLStr();
	call printhlstr
; 194     
; 195     hl = wifiSettingsSsidLabelPos;
	ld hl, (wifisettingsssidlabelpos)
; 196     setPosCursor();
	call setposcursor
; 197     hl = wifiSettingsSsidLabel;
	ld hl, wifisettingsssidlabel
; 198     printHLStr();
	call printhlstr
; 199     
; 200     hl = wifiSettingsIpLabelPos;
	ld hl, (wifisettingsiplabelpos)
; 201     setPosCursor();
	call setposcursor
; 202     hl = wifiSettingsIpLabel;
	ld hl, wifisettingsiplabel
; 203     printHLStr();
	call printhlstr
; 204     
; 205     hl = wifiSettingsMacLabelPos;
	ld hl, (wifisettingsmaclabelpos)
; 206     setPosCursor();
	call setposcursor
; 207     hl = wifiSettingsMacLabel;
	ld hl, wifisettingsmaclabel
; 208     printHLStr();
	call printhlstr
; 209     
; 210     hl = wifiSettingsSsidValPos;
	ld hl, (wifisettingsssidvalpos)
; 211     setPosCursor();
	call setposcursor
; 212     hl = wifiSettingsSsidVal;
	ld hl, wifisettingsssidval
; 213     printHLStr();
	call printhlstr
; 214     
; 215     updateWiFiViewValData();
	jp updatewifiviewvaldata
; 216 }
; 217 
; 218 void clearWiFiViewValData() {
clearwifiviewvaldata:
; 219     hl = wifiSettingsIpValPos;
	ld hl, (wifisettingsipvalpos)
; 220     setPosCursor();
	call setposcursor
; 221     hl = wifiSettingsEmpty18;
	ld hl, wifisettingsempty18
; 222     printHLStr();
	call printhlstr
; 223     
; 224     hl = wifiSettingsMacValPos;
	ld hl, (wifisettingsmacvalpos)
; 225     setPosCursor();
	call setposcursor
; 226     hl = wifiSettingsEmpty18;
	ld hl, wifisettingsempty18
; 227     printHLStr();
	jp printhlstr
; 228 }
; 229 
; 230 void updateWiFiViewValData() {
updatewifiviewvaldata:
; 231     hl = wifiSettingsIpValPos;
	ld hl, (wifisettingsipvalpos)
; 232     setPosCursor();
	call setposcursor
; 233     hl = wifiSettingsIpVal;
	ld hl, wifisettingsipval
; 234     printHLStr();
	call printhlstr
; 235     
; 236     hl = wifiSettingsMacValPos;
	ld hl, (wifisettingsmacvalpos)
; 237     setPosCursor();
	call setposcursor
; 238     hl = wifiSettingsMacVal;
	ld hl, wifisettingsmacval
; 239     printHLStr();
	jp printhlstr
; 240 }
; 241 
; 242 void clearScreen() {
clearscreen:
; 243     c = 0x1B;
	ld c, 27
; 244     printChatC();
	call printchatc
; 245     c = 0x45;
	ld c, 69
; 246     printChatC();
	jp printchatc
; 247 }
; 248 
; 249 void drowRect() {
drowrect:
; 250     setMyFont();
	call setmyfont
; 251     
; 252     //h = y
; 253     a = drowRectY;
	ld a, (drowrecty)
; 254     h = a;
	ld h, a
; 255     
; 256     do {
l_31:
; 257         //l = x
; 258         a = drowRectX;
	ld a, (drowrectx)
; 259         l = a;
	ld l, a
; 260         
; 261         push_pop(hl) {
	push hl
; 262             setPosCursor();
	call setposcursor
	pop hl
; 263         }
; 264         
; 265         do {
l_34:
; 266             if ((a = drowRectY) == h) {
	ld a, (drowrecty)
	cp h
	jp nz, l_37
; 267                 c = 0x26;
	ld c, 38
; 268                 if ((a = drowRectX) == l) {
	ld a, (drowrectx)
	cp l
	jp nz, l_39
; 269                     c = 0x21;
	ld c, 33
l_39:
; 270                 }
; 271                 if ((a = drowRectEndX)-- == l) {
	ld a, (drowrectendx)
	dec a
	cp l
	jp nz, l_41
; 272                     c = 0x23;
	ld c, 35
l_41:
	jp l_38
l_37:
; 273                 }
; 274             } else if ((a = drowRectEndY)-- == h) {
	ld a, (drowrectendy)
	dec a
	cp h
	jp nz, l_43
; 275                 c = 0x26;
	ld c, 38
; 276                 if ((a = drowRectX) == l) {
	ld a, (drowrectx)
	cp l
	jp nz, l_45
; 277                     c = 0x22;
	ld c, 34
l_45:
; 278                 }
; 279                 if ((a = drowRectEndX)-- == l) {
	ld a, (drowrectendx)
	dec a
	cp l
	jp nz, l_47
; 280                     c = 0x24;
	ld c, 36
l_47:
	jp l_44
l_43:
; 281                 }
; 282             } else {
; 283                 c = 0x20;
	ld c, 32
; 284                 if ((a = drowRectX) == l) {
	ld a, (drowrectx)
	cp l
	jp nz, l_49
; 285                     c = 0x25;
	ld c, 37
l_49:
; 286                 }
; 287                 if ((a = drowRectEndX)-- == l) {
	ld a, (drowrectendx)
	dec a
	cp l
	jp nz, l_51
; 288                     c = 0x25;
	ld c, 37
l_51:
l_44:
l_38:
; 289                 }
; 290             }
; 291             
; 292             push_pop(hl) {
	push hl
; 293                 printChatC();
	call printchatc
	pop hl
; 294             }
; 295             
; 296             a = drowRectEndX;
	ld a, (drowrectendx)
; 297             l++;
	inc l
; 298             a -= l;
	sub l
l_35:
	jp nz, l_34
; 299         } while (flag_nz);
; 300         
; 301         a = drowRectEndY;
	ld a, (drowrectendy)
; 302         h++;
	inc h
; 303         a -= h;
	sub h
l_32:
	jp nz, l_31
; 304     } while (flag_nz);
; 305     
; 306     setSystemFont();
	jp setsystemfont
; 307 }
; 308 
; 309 void setMyFont() {
setmyfont:
; 310     push_pop(hl) {
	push hl
; 311         hl = fontAddress;
	ld hl, (fontaddress)
; 312         systemFontAddress = hl;
	ld (systemfontaddress), hl
; 313         hl = &myFont;
	ld hl, myfont
; 314         fontAddress = hl;
	ld (fontaddress), hl
	pop hl
	ret
; 315     }
; 316 }
; 317 
; 318 void setSystemFont() {
setsystemfont:
; 319     push_pop(hl) {
	push hl
; 320         hl = systemFontAddress;
	ld hl, (systemfontaddress)
; 321         fontAddress = hl;
	ld (fontaddress), hl
	pop hl
	ret
; 322     }
; 323 }
; 324 
; 325 uint8_t drowRectX = 0x00;
drowrectx:
	db 0
; 326 uint8_t drowRectY = 0x00;
drowrecty:
	db 0
; 327 uint8_t drowRectEndX = 0x00;
drowrectendx:
	db 0
; 328 uint8_t drowRectEndY = 0x00;
drowrectendy:
	db 0
; 330 uint16_t systemFontAddress = 0x0000;
systemfontaddress:
	dw 0
; 332 void updateDiskList() {
updatedisklist:
; 333     a = diskViewDiskNum;
	ld a, (diskviewdisknum)
; 334     ordos_wnd();
	call ordos_wnd
; 335     hl = startListBufer;
	ld hl, 0
; 336     ordos_dirm();
	call ordos_dirm
; 337     diskViewListCount = a;
	ld (diskviewlistcount), a
	ret
; 338 }
; 339 
; 340 void showDiskList() {
showdisklist:
; 341     b = 0;
	ld b, 0
; 342     showDiskDriveName();
	call showdiskdrivename
; 343     showDiskDir();
	call showdiskdir
; 344     hl = diskViewListNamePos;
	ld hl, (diskviewlistnamepos)
; 345     
; 346     if ((a = diskViewListCount) == 0) {
	ld a, (diskviewlistcount)
	or a
	jp nz, l_53
; 347         return;
	ret
l_53:
; 348     }
; 349     
; 350     do {
l_55:
; 351         setPosCursor();
	call setposcursor
; 352         a = b;
	ld a, b
; 353         push_pop(hl) {
	push hl
; 354             showDiskApp();
	call showdiskapp
	pop hl
; 355         };
; 356         
; 357         h++;
	inc h
; 358         b++;
	inc b
; 359         a = diskViewListCount;
	ld a, (diskviewlistcount)
; 360         a -= b;
	sub b
l_56:
	jp nz, l_55
	ret
; 361     } while (flag_nz);
; 362 }
; 363 
; 364 void showDiskDriveName() {
showdiskdrivename:
; 365     push_pop(hl) {
	push hl
; 366         hl = diskViewDriveNamePos;
	ld hl, (diskviewdrivenamepos)
; 367         setPosCursor();
	call setposcursor
; 368         a = diskViewDiskNum;
	ld a, (diskviewdisknum)
; 369         printChatA();
	call printchata
	pop hl
	ret
; 370     }
; 371 }
; 372 
; 373 void showDiskDir() {
showdiskdir:
; 374     push_pop(hl) {
	push hl
; 375         hl = diskViewListDirPos;
	ld hl, (diskviewlistdirpos)
; 376         setPosCursor();
	call setposcursor
; 377         hl = diskViewListDirLabel;
	ld hl, diskviewlistdirlabel
; 378         push_pop(bc) {
	push bc
; 379             a = 0;
	ld a, 0
; 380             inverceAddress = a;
	ld (inverceaddress), a
; 381             if ((a = diskViewCurrPos) == 0) {
	ld a, (diskviewcurrpos)
	or a
	jp nz, l_58
; 382                 if ((a = rootViewCurrentView) == rootViewCurrentDiskView) {
	ld a, (rootviewcurrentview)
	or a
	jp nz, l_60
; 383                     a = 0xFF;
	ld a, 255
; 384                     inverceAddress = a;
	ld (inverceaddress), a
l_60:
l_58:
; 385                 }
; 386             }
; 387             printHLStr();
	call printhlstr
; 388             a = 0;
	ld a, 0
; 389             inverceAddress = a;
	ld (inverceaddress), a
	pop bc
	pop hl
	ret
; 390         }
; 391     }
; 392 }
; 393 
; 394 ///A - count app
; 395 void showDiskApp() {
showdiskapp:
; 396     push_pop(bc) {
	push bc
; 397         
; 398         c = a;
	ld c, a
; 399         carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 400         hl = startListBufer;
	ld hl, 0
; 401         a += l;
	add l
; 402         l = a;
	ld l, a
; 403         if (flag_c) {
	jp nc, l_62
; 404             h++;
	inc h
l_62:
; 405         }
; 406         
; 407         a = 0x00;
	ld a, 0
; 408         inverceAddress = a;
	ld (inverceaddress), a
; 409         
; 410         if ((a = diskViewCurrPos)-- == c) {
	ld a, (diskviewcurrpos)
	dec a
	cp c
	jp nz, l_64
; 411             if ((a = rootViewCurrentView) == rootViewCurrentDiskView) {
	ld a, (rootviewcurrentview)
	or a
	jp nz, l_66
; 412                 a = 0xFF;
	ld a, 255
; 413                 inverceAddress = a;
	ld (inverceaddress), a
l_66:
l_64:
; 414             }
; 415         }
; 416     
; 417         a = ' ';
	ld a, 32
; 418         printChatA();
	call printchata
; 419         b = 0;
	ld b, 0
; 420         
; 421         do {
l_68:
; 422             a = *hl;
	ld a, (hl)
; 423             printChatA();
	call printchata
; 424             hl++;
	inc hl
; 425             b++;
	inc b
; 426             a = 8;
	ld a, 8
; 427             a -= b;
	sub b
l_69:
	jp nz, l_68
; 428         } while (flag_nz);
; 429         a = ' ';
	ld a, 32
; 430         printChatA();
	call printchata
	pop bc
; 431     };
; 432     a = 0x00;
	ld a, 0
; 433     inverceAddress = a;
	ld (inverceaddress), a
	ret
; 434 }
; 435 
; 436 void diskViewKeyA() {
diskviewkeya:
; 437     push_pop(bc) {
	push bc
; 438         b = a;
	ld b, a
; 439         
; 440         if (a == 0x1A) { //down
	cp 26
	jp nz, l_71
; 441             a = diskViewListCount;
	ld a, (diskviewlistcount)
; 442             c = a;
	ld c, a
; 443             if ( (a = diskViewCurrPos) < c  ) {
	ld a, (diskviewcurrpos)
	cp c
	jp nc, l_73
; 444                 a++;
	inc a
; 445                 diskViewCurrPos = a;
	ld (diskviewcurrpos), a
l_73:
	jp l_72
l_71:
; 446             }
; 447         } else if (a == 0x19) { //up
	cp 25
	jp nz, l_75
; 448             if ( (a = diskViewCurrPos) > 0 ) {
	ld a, (diskviewcurrpos)
	or a
	jp z, l_77
; 449                 a--;
	dec a
; 450                 diskViewCurrPos = a;
	ld (diskviewcurrpos), a
l_77:
	jp l_76
l_75:
; 451             }
; 452         } else if (a == 0x0D) { //Enter
	cp 13
	jp nz, l_79
; 453             if ((a = diskViewCurrPos) == 0) { // Change drive
	ld a, (diskviewcurrpos)
	or a
	jp nz, l_81
; 454                 a = diskViewDiskNum;
	ld a, (diskviewdisknum)
; 455                 if (a == 'B') {
	cp 66
	jp nz, l_83
; 456                     a = 'C';
	ld a, 67
	jp l_84
l_83:
; 457                 } else if (a == 'C') {
	cp 67
	jp nz, l_85
; 458                     a = 'D';
	ld a, 68
	jp l_86
l_85:
; 459                 } else if (a == 'D') {
	cp 68
	jp nz, l_87
; 460                     a = 'B';
	ld a, 66
l_87:
l_86:
l_84:
; 461                 }
; 462                 diskViewDiskNum = a;
	ld (diskviewdisknum), a
; 463                 diskView();
	call diskview
; 464                 updateDiskList();
	call updatedisklist
	jp l_82
l_81:
; 465             } else { // Upload file to FTP
l_82:
	jp l_80
l_79:
; 466                 
; 467             }
; 468         } else if (a == 0x09) { //TAB
	cp 9
	jp nz, l_89
; 469             a = rootViewCurrentFTPView; // переходим на список файлов FTP
	ld a, 1
; 470             rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 471             // Сбросить выделение строки на диске
; 472             showDiskList();
	call showdisklist
; 473             // Выделить текущую позицию на FTP
; 474             ftpViewDataUpdate();
	call ftpviewdataupdate
l_89:
l_80:
l_76:
l_72:
	pop bc
	ret
; 475         }
; 476     }
; 477 }
; 478 
; 479 void showHelpStr() {
showhelpstr:
; 480     push_pop(hl) {
	push hl
; 481         hl = rootViewHelpStrPos;
	ld hl, (rootviewhelpstrpos)
; 482         setPosCursor();
	call setposcursor
; 483         hl = rootViewHelpStr;
	ld hl, rootviewhelpstr
; 484         printHLStr();
	call printhlstr
	pop hl
	ret
; 485     }
; 486 }
; 487 
; 488 void showFtpSettingsEditView() {
showftpsettingseditview:
; 489     drowRectX = (a = ftpSettingsEditViewX);
	ld a, (ftpsettingseditviewx)
	ld (drowrectx), a
; 490     drowRectY = (a = ftpSettingsEditViewY);
	ld a, (ftpsettingseditviewy)
	ld (drowrecty), a
; 491     drowRectEndX = (a = ftpSettingsEditViewEX);
	ld a, (ftpsettingseditviewex)
	ld (drowrectendx), a
; 492     drowRectEndY = (a = ftpSettingsEditViewEY);
	ld a, (ftpsettingseditviewey)
	ld (drowrectendy), a
; 493     drowRect();
	call drowrect
; 494     
; 495     hl = ftpSettingsEditViewLabelPos;
	ld hl, (ftpsettingseditviewlabelpos)
; 496     setPosCursor();
	call setposcursor
; 497     hl = ftpSettingsEditViewLabel;
	ld hl, ftpsettingseditviewlabel
; 498     printHLStr();
	call printhlstr
; 499     
; 500     hl = ftpSettingsEditViewIpLabelPos;
	ld hl, (ftpsettingseditviewiplabelpos)
; 501     setPosCursor();
	call setposcursor
; 502     hl = ftpSettingsIpLabel;
	ld hl, ftpsettingsiplabel
; 503     printHLStr();
	call printhlstr
; 504     
; 505     hl = ftpSettingsEditViewPortLabelPos;
	ld hl, (ftpsettingseditviewportlabelpos)
; 506     setPosCursor();
	call setposcursor
; 507     hl = ftpSettingsPortLabel;
	ld hl, ftpsettingsportlabel
; 508     printHLStr();
	call printhlstr
; 509     
; 510     hl = ftpSettingsEditViewUserLabelPos;
	ld hl, (ftpsettingseditviewuserlabelpos)
; 511     setPosCursor();
	call setposcursor
; 512     hl = ftpSettingsUserLabel;
	ld hl, ftpsettingsuserlabel
; 513     printHLStr();
	call printhlstr
; 514     
; 515     hl = ftpSettingsEditViewPasswordLabelPos;
	ld hl, (ftpsettingseditviewpasswordlabel)
; 516     setPosCursor();
	call setposcursor
; 517     hl = ftpSettingsEditViewPasswordLabel;
	ld hl, ftpsettingseditviewpasswordlabel_0
; 518     printHLStr();
	call printhlstr
; 519     
; 520     hl = ftpSettingsEditViewOkLabelPos;
	ld hl, (ftpsettingseditviewoklabelpos)
; 521     setPosCursor();
	call setposcursor
; 522     hl = ftpSettingsEditViewOkLabel;
	ld hl, ftpsettingseditviewoklabel
; 523     printHLStr();
	jp printhlstr
; 524 }
; 525 
; 526 void needOpenFTPSettingsEditView() {
needopenftpsettingseditview:
; 527     push_pop(hl) {
	push hl
; 528         if ((a = rootViewCurrentView) != rootViewCurrentFTPSettingsEditView) { //Если уже открыты настройки - не открываем
	ld a, (rootviewcurrentview)
	cp 2
	jp z, l_91
; 529             if ((a = rootViewCurrentView) != rootViewCurrentWiFiSettingsEditView) { //Если открыта настройка WiFi тоже не открываем
	ld a, (rootviewcurrentview)
	cp 3
	jp z, l_93
; 530                 
; 531                 a = rootViewCurrentFTPSettingsEditView;
	ld a, 2
; 532                 rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 533                 a = 4;
	ld a, 4
; 534                 ftpSettingsEditViewCurrentPos = a;
	ld (ftpsettingseditviewcurrentpos), a
; 535                 
; 536                 showDiskList(); //Сбросить выделение строки
	call showdisklist
; 537                 showFtpSettingsEditView();
	call showftpsettingseditview
; 538                 ftpSettingsEditViewDataUpdate();
	call ftpsettingseditviewdataupdate
l_93:
l_91:
	pop hl
	ret
; 539             }
; 540         }
; 541     }
; 542 }
; 543 
; 544 void ftpSettingsEditViewSelectEditField() {
ftpsettingseditviewselecteditfie:
; 545     a = ftpSettingsEditViewCurrentPos;
	ld a, (ftpsettingseditviewcurrentpos)
; 546     if (a == 0) {
	or a
	jp nz, l_95
; 547         hl = ftpSettingsEditViewIpValPos;
	ld hl, (ftpsettingseditviewipvalpos)
; 548         ftpSettingsEditViewEditValuePos = hl;
	ld (ftpsettingseditvieweditvaluepos), hl
; 549         setPosCursor();
	call setposcursor
; 550         
; 551         push_pop(hl) {
	push hl
; 552             hl = ftpSettingsIpValue;
	ld hl, ftpsettingsipvalue
; 553             ftpSettingsEditView_CopyStrFromHL();
	call ftpsettingseditview_copystrfromh
	pop hl
	jp l_96
l_95:
; 554         }
; 555     } else if (a == 1) {
	cp 1
	jp nz, l_97
; 556         hl = ftpSettingsEditViewPortValPos;
	ld hl, (ftpsettingseditviewportvalpos)
; 557         ftpSettingsEditViewEditValuePos = hl;
	ld (ftpsettingseditvieweditvaluepos), hl
; 558         setPosCursor();
	call setposcursor
; 559         
; 560         push_pop(hl) {
	push hl
; 561             hl = ftpSettingsPortValue;
	ld hl, ftpsettingsportvalue
; 562             ftpSettingsEditView_CopyStrFromHL();
	call ftpsettingseditview_copystrfromh
	pop hl
	jp l_98
l_97:
; 563         }
; 564     } else if (a == 2) {
	cp 2
	jp nz, l_99
; 565         hl = ftpSettingsEditViewUserValPos;
	ld hl, (ftpsettingseditviewuservalpos)
; 566         ftpSettingsEditViewEditValuePos = hl;
	ld (ftpsettingseditvieweditvaluepos), hl
; 567         setPosCursor();
	call setposcursor
; 568         
; 569         push_pop(hl) {
	push hl
; 570             hl = ftpSettingsUserValue;
	ld hl, ftpsettingsuservalue
; 571             ftpSettingsEditView_CopyStrFromHL();
	call ftpsettingseditview_copystrfromh
	pop hl
	jp l_100
l_99:
; 572         }
; 573     } else if (a == 3) {
	cp 3
	jp nz, l_101
; 574         hl = ftpSettingsEditViewPasswordValPos;
	ld hl, (ftpsettingseditviewpasswordvalpo)
; 575         ftpSettingsEditViewEditValuePos = hl;
	ld (ftpsettingseditvieweditvaluepos), hl
; 576         setPosCursor();
	call setposcursor
; 577         
; 578         push_pop(hl) {
	push hl
; 579             hl = ftpSettingsEditViewPasswordVal;
	ld hl, ftpsettingseditviewpasswordval
; 580             ftpSettingsEditView_CopyStrFromHL();
	call ftpsettingseditview_copystrfromh
	pop hl
l_101:
l_100:
l_98:
l_96:
; 581         }
; 582     }
; 583     ftpSettingsEditViewEditField();
	jp ftpsettingseditvieweditfield
; 584 }
; 585 
; 586 void ftpSettingsEditViewSaveEditValueToHL() {
ftpsettingseditviewsaveeditvalue:
; 587     push_pop(de) {
	push de
; 588         push_pop(bc) {
	push bc
; 589             de = ftpSettingsEditViewEditValue;
	ld de, ftpsettingseditvieweditvalue
; 590             a = ftpSettingsEditViewEditPos;
	ld a, (ftpsettingseditvieweditpos)
; 591             c = a;
	ld c, a
; 592             b = 0;
	ld b, 0
; 593             do {
l_103:
; 594                 a = *de;
	ld a, (de)
; 595                 *hl = a;
	ld (hl), a
; 596                 hl++;
	inc hl
; 597                 de++;
	inc de
; 598                 b++;
	inc b
; 599                 a = b;
	ld a, b
; 600                 a -= c;
	sub c
l_104:
	jp nz, l_103
; 601             } while (flag_nz);
; 602             *hl = 0;
	ld (hl), 0
	pop bc
	pop de
	ret
; 603         }
; 604     }
; 605 }
; 606 
; 607 void ftpSettingsEditView_CopyStrFromHL() {
ftpsettingseditview_copystrfromh:
; 608     push_pop(de) {
	push de
; 609         push_pop(bc) {
	push bc
; 610             de = ftpSettingsEditViewEditValue;
	ld de, ftpsettingseditvieweditvalue
; 611             b = 0;
	ld b, 0
; 612             c = 0;
	ld c, 0
; 613             do {
l_106:
; 614                 a = *hl;
	ld a, (hl)
; 615                 *de = a;
	ld (de), a
; 616                 if ((a = b) == 22) {
	ld a, b
	cp 22
	jp nz, l_109
; 617                     a = 0;
	ld a, 0
; 618                     *de = a;
	ld (de), a
	jp l_110
l_109:
; 619                 } else if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_111
; 620                     a = ' ';
	ld a, 32
; 621                     *de = a;
	ld (de), a
	jp l_112
l_111:
; 622                 } else if ((a = *de) == 0) {
	ld a, (de)
	or a
	jp nz, l_113
; 623                     c = 1;
	ld c, 1
; 624                     a = ' ';
	ld a, 32
; 625                     *de = a;
	ld (de), a
; 626                     a = b;
	ld a, b
; 627                     ftpSettingsEditViewEditPos = a;
	ld (ftpsettingseditvieweditpos), a
l_113:
l_112:
l_110:
; 628                 }
; 629                 
; 630                 hl ++;
	inc hl
; 631                 de++;
	inc de
; 632                 b++;
	inc b
; 633                 a = b;
	ld a, b
; 634                 a -= 23;
	sub 23
l_107:
	jp nz, l_106
	pop bc
	pop de
	ret
; 635             } while (flag_nz);
; 636         }
; 637     }
; 638 }
; 639 
; 640 void ftpSettingsEditViewEditField() {
ftpsettingseditvieweditfield:
; 641     hl = ftpSettingsEditViewEditValuePos;
	ld hl, (ftpsettingseditvieweditvaluepos)
; 642     setPosCursor();
	call setposcursor
; 643     
; 644     a = 0xFF;
	ld a, 255
; 645     inverceAddress = a;
	ld (inverceaddress), a
; 646     
; 647     hl = ftpSettingsEditViewEditValue;
	ld hl, ftpsettingseditvieweditvalue
; 648     printHLStr();
	call printhlstr
; 649     
; 650     ftpSettingsEditViewSetEditCursor();
	call ftpsettingseditviewseteditcursor
; 651     push_pop(bc) {
	push bc
; 652         b = 0;
	ld b, 0
; 653         do {
l_115:
; 654             getKeyboardCharA();
	call getkeyboardchara
; 655             
; 656             if (a == 0x1B) { // выход из редактирования без сохранения
	cp 27
	jp nz, l_118
; 657                 b = 1;
	ld b, 1
	jp l_119
l_118:
; 658             } else if (a == 0x0D) { // Сохранить и выйти из редактирования
	cp 13
	jp nz, l_120
; 659                 b = 1;
	ld b, 1
; 660                 ftpSettingsEditViewSaveField();
	call ftpsettingseditviewsavefield
	jp l_121
l_120:
; 661             } else if (a >= 0x20) {
	cp 32
	jp c, l_122
; 662                 if (a < 0x7F) { //Ввод символа
	cp 127
	jp nc, l_124
; 663                     c = a;
	ld c, a
; 664                     // Если достигли предела - то перемещаем курсор на 1 назад
; 665                     a = ftpSettingsEditViewEditPos;
	ld a, (ftpsettingseditvieweditpos)
; 666                     if (a >= 15) {
	cp 15
	jp c, l_126
; 667                         a--;
	dec a
l_126:
; 668                     }
; 669                     ftpSettingsEditViewEditPos = a;
	ld (ftpsettingseditvieweditpos), a
; 670                     
; 671                     //Сохраняем символ
; 672                     a = c;
	ld a, c
; 673                     ftpSettingsEditViewSetValueA();
	call ftpsettingseditviewsetvaluea
; 674                     a = ftpSettingsEditViewEditPos;
	ld a, (ftpsettingseditvieweditpos)
; 675                     a++;
	inc a
; 676                     ftpSettingsEditViewEditPos = a;
	ld (ftpsettingseditvieweditpos), a
; 677                     ftpSettingsEditViewSetEditCursor();
	call ftpsettingseditviewseteditcursor
	jp l_125
l_124:
; 678                 } else if (a == 0x7F) { //Забой... (удаление символа)
	cp 127
	jp nz, l_128
; 679                     if ((a = ftpSettingsEditViewEditPos) > 0) {
	ld a, (ftpsettingseditvieweditpos)
	or a
	jp z, l_130
; 680                         a--;
	dec a
; 681                         ftpSettingsEditViewEditPos = a;
	ld (ftpsettingseditvieweditpos), a
; 682                         ftpSettingsEditViewSetEditCursor();
	call ftpsettingseditviewseteditcursor
; 683                         a = ' ';
	ld a, 32
; 684                         ftpSettingsEditViewSetValueA();
	call ftpsettingseditviewsetvaluea
l_130:
l_128:
l_125:
l_122:
l_121:
l_119:
; 685                     }
; 686                 }
; 687             }
; 688             
; 689             a = b;
	ld a, b
; 690             a -= 1;
	sub 1
l_116:
	jp nz, l_115
	pop bc
; 691         } while (flag_nz);
; 692     }
; 693     
; 694     a = 0x00;
	ld a, 0
; 695     inverceAddress = a;
	ld (inverceaddress), a
; 696     
; 697     showFtpSettingsEditView();
	call showftpsettingseditview
; 698     ftpSettingsEditViewDataUpdate();
	jp ftpsettingseditviewdataupdate
; 699 }
; 700 
; 701 void ftpSettingsEditViewSetValueA() {
ftpsettingseditviewsetvaluea:
; 702     push_pop(hl) {
	push hl
; 703         push_pop(bc) {
	push bc
; 704             b = a;
	ld b, a
; 705             //Сохраним символ в ftpSettingsEditViewEditValue
; 706             hl = ftpSettingsEditViewEditValue;
	ld hl, ftpsettingseditvieweditvalue
; 707             a = ftpSettingsEditViewEditPos;
	ld a, (ftpsettingseditvieweditpos)
; 708             a += l;
	add l
; 709             l = a;
	ld l, a
; 710             if (flag_c) {
	jp nc, l_132
; 711                 h++;
	inc h
l_132:
; 712             }
; 713             *hl = b;
	ld (hl), b
; 714             //Отрисуем символ на экране
; 715             ftpSettingsEditViewSetEditCursor();
	call ftpsettingseditviewseteditcursor
; 716             a = b;
	ld a, b
; 717             printChatA();
	call printchata
; 718             ftpSettingsEditViewSetEditCursor();
	call ftpsettingseditviewseteditcursor
	pop bc
	pop hl
	ret
; 719         }
; 720     }
; 721 }
; 722 
; 723 void ftpSettingsEditViewSetEditCursor() {
ftpsettingseditviewseteditcursor:
; 724     push_pop(hl) {
	push hl
; 725         hl = ftpSettingsEditViewEditValuePos;
	ld hl, (ftpsettingseditvieweditvaluepos)
; 726         a = ftpSettingsEditViewEditPos;
	ld a, (ftpsettingseditvieweditpos)
; 727         a += l;
	add l
; 728         l = a;
	ld l, a
; 729         setPosCursor();
	call setposcursor
	pop hl
	ret
; 730     }
; 731 }
; 732 
; 733 void ftpSettingsEditViewDataUpdate() {
ftpsettingseditviewdataupdate:
; 734     if ((a = rootViewCurrentView) != rootViewCurrentFTPSettingsEditView) {
	ld a, (rootviewcurrentview)
	cp 2
	jp z, l_134
; 735         return;
	ret
l_134:
; 736     }
; 737     
; 738     push_pop(bc) {
	push bc
; 739         b = 0;
	ld b, 0
; 740         do {
l_136:
; 741             a = 0x00;
	ld a, 0
; 742             inverceAddress = a;
	ld (inverceaddress), a
; 743             
; 744             if ((a = ftpSettingsEditViewCurrentPos) == b) {
	ld a, (ftpsettingseditviewcurrentpos)
	cp b
	jp nz, l_139
; 745                 a = 0xFF;
	ld a, 255
; 746                 inverceAddress = a;
	ld (inverceaddress), a
l_139:
; 747             }
; 748             
; 749             a = b;
	ld a, b
; 750             ftpSettingsEditViewShowValueA();
	call ftpsettingseditviewshowvaluea
; 751             
; 752             a = 0x00;
	ld a, 0
; 753             inverceAddress = a;
	ld (inverceaddress), a
; 754             
; 755             b++;
	inc b
; 756             a = b;
	ld a, b
; 757             a -= 5;
	sub 5
l_137:
	jp nz, l_136
	pop bc
	ret
; 11 void ftpSettingsEditViewShowValueA() {
ftpsettingseditviewshowvaluea:
; 12     if (a == 0) {
	or a
	jp nz, l_141
; 13         hl = ftpSettingsEditViewIpValPos;
	ld hl, (ftpsettingseditviewipvalpos)
; 14         setPosCursor();
	call setposcursor
; 15         
; 16         hl = ftpSettingsIpValue;
	ld hl, ftpsettingsipvalue
; 17         printHLStr();
	call printhlstr
	jp l_142
l_141:
; 18     } else if (a == 1) {
	cp 1
	jp nz, l_143
; 19         hl = ftpSettingsEditViewPortValPos;
	ld hl, (ftpsettingseditviewportvalpos)
; 20         setPosCursor();
	call setposcursor
; 21         
; 22         hl = ftpSettingsPortValue;
	ld hl, ftpsettingsportvalue
; 23         printHLStr();
	call printhlstr
	jp l_144
l_143:
; 24     } else if (a == 2) {
	cp 2
	jp nz, l_145
; 25         hl = ftpSettingsEditViewUserValPos;
	ld hl, (ftpsettingseditviewuservalpos)
; 26         setPosCursor();
	call setposcursor
; 27         
; 28         hl = ftpSettingsUserValue;
	ld hl, ftpsettingsuservalue
; 29         printHLStr();
	call printhlstr
	jp l_146
l_145:
; 30     } else if (a == 3) {
	cp 3
	jp nz, l_147
; 31         hl = ftpSettingsEditViewPasswordValPos;
	ld hl, (ftpsettingseditviewpasswordvalpo)
; 32         setPosCursor();
	call setposcursor
; 33         
; 34         hl = ftpSettingsEditViewPasswordVal;
	ld hl, ftpsettingseditviewpasswordval
; 35         printHLStr();
	call printhlstr
	jp l_148
l_147:
; 36     } else if (a == 4) {
	cp 4
	jp nz, l_149
; 37         hl = ftpSettingsEditViewOkLabelPos;
	ld hl, (ftpsettingseditviewoklabelpos)
; 38         setPosCursor();
	call setposcursor
; 39         hl = ftpSettingsEditViewOkLabel;
	ld hl, ftpsettingseditviewoklabel
; 40         printHLStr();
	call printhlstr
l_149:
l_148:
l_146:
l_144:
l_142:
	ret
; 41     }
; 42 }
; 43 
; 44 void ftpSettingsEditViewSaveField() {
ftpsettingseditviewsavefield:
; 45     a = ftpSettingsEditViewCurrentPos;
	ld a, (ftpsettingseditviewcurrentpos)
; 46     if (a == 0) {
	or a
	jp nz, l_151
; 47         hl = ftpSettingsIpValue;
	ld hl, ftpsettingsipvalue
	jp l_152
l_151:
; 48     } else if (a == 1) {
	cp 1
	jp nz, l_153
; 49         hl = ftpSettingsPortValue;
	ld hl, ftpsettingsportvalue
	jp l_154
l_153:
; 50     } else if (a == 2) {
	cp 2
	jp nz, l_155
; 51         hl = ftpSettingsUserValue;
	ld hl, ftpsettingsuservalue
	jp l_156
l_155:
; 52     } else if (a == 3) {
	cp 3
	jp nz, l_157
; 53         hl = ftpSettingsEditViewPasswordVal;
	ld hl, ftpsettingseditviewpasswordval
l_157:
l_156:
l_154:
l_152:
; 54     }
; 55     ftpSettingsEditViewSaveEditValueToHL();
	call ftpsettingseditviewsaveeditvalue
; 56     //Save ESP
; 57     a = ftpSettingsEditViewCurrentPos;
	ld a, (ftpsettingseditviewcurrentpos)
; 58     if (a == 0) {
	or a
	jp nz, l_159
; 59         setFTPUrl();
	call setftpurl
	jp l_160
l_159:
; 60     } else if (a == 1) {
	cp 1
	jp nz, l_161
; 61         setFTPPort();
	call setftpport
	jp l_162
l_161:
; 62     } else if (a == 2) {
	cp 2
	jp nz, l_163
; 63         setFTPUser();
	call setftpuser
	jp l_164
l_163:
; 64     } else if (a == 3) {
	cp 3
	jp nz, l_165
; 65         setFTPPassword();
	call setftppassword
l_165:
l_164:
l_162:
l_160:
	ret
; 66     }
; 67 }
; 68 
; 69 void ftpSettingsEditViewKeyA() {
ftpsettingseditviewkeya:
; 70     push_pop(hl) {
	push hl
; 71         l = a;
	ld l, a
; 72         if ((a = rootViewCurrentView) == rootViewCurrentFTPSettingsEditView) {
	ld a, (rootviewcurrentview)
	cp 2
	jp nz, l_167
; 73             a = l;
	ld a, l
; 74             if (a == 0x1B) { //ESC выход из настройки
	cp 27
	jp nz, l_169
; 75                 a = rootViewCurrentDiskView; // переходим на список файлов на диске
	ld a, 0
; 76                 rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 77                 
; 78                 updateRootUI();
	call updaterootui
; 79                 updateRootDataUI();
	call updaterootdataui
	jp l_170
l_169:
; 80             } else {
; 81                 if (a == 0x1A) { //down
	cp 26
	jp nz, l_171
; 82                     a = ftpSettingsEditViewCurrentPos;
	ld a, (ftpsettingseditviewcurrentpos)
; 83                     a++;
	inc a
; 84                     if (a == 5) {
	cp 5
	jp nz, l_173
; 85                         a = 0;
	ld a, 0
l_173:
; 86                     }
; 87                     ftpSettingsEditViewCurrentPos = a;
	ld (ftpsettingseditviewcurrentpos), a
	jp l_172
l_171:
; 88                 } else if (a == 0x19) { //up
	cp 25
	jp nz, l_175
; 89                     a = ftpSettingsEditViewCurrentPos;
	ld a, (ftpsettingseditviewcurrentpos)
; 90                     if (a == 0) {
	or a
	jp nz, l_177
; 91                         a = 4;
	ld a, 4
	jp l_178
l_177:
; 92                     } else {
; 93                         a--;
	dec a
l_178:
; 94                     }
; 95                     ftpSettingsEditViewCurrentPos = a;
	ld (ftpsettingseditviewcurrentpos), a
	jp l_176
l_175:
; 96                 } else if (a == 0x0D) { //Enter
	cp 13
	jp nz, l_179
; 97                     /// и подключиться к FTP
; 98                     needFtpConnect();
	call needftpconnect
; 99                     ///
; 100                     if ((a = ftpSettingsEditViewCurrentPos) == 4) { // Нажатие на кнопку ОК
	ld a, (ftpsettingseditviewcurrentpos)
	cp 4
	jp nz, l_181
; 101                         a = rootViewCurrentDiskView; // переходим на список файлов на диске
	ld a, 0
; 102                         rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 103                         
; 104                         updateRootUI();
	call updaterootui
; 105                         updateRootDataUI();
	call updaterootdataui
	jp l_182
l_181:
; 106                     } else {
; 107                         ftpSettingsEditViewSelectEditField();
	call ftpsettingseditviewselecteditfie
l_182:
l_179:
l_176:
l_172:
l_170:
l_167:
	pop hl
	ret
; 108                     }
; 109                 }
; 110             }
; 111         }
; 112     }
; 113 }
; 114 
; 115 void updateFtpStatus() {
updateftpstatus:
; 116     a = updateFtpStatusTike;
	ld a, (updateftpstatustike)
; 117     if (a < 240) {
	cp 240
	jp nc, l_183
; 118         a++;
	inc a
; 119         updateFtpStatusTike = a;
	ld (updateftpstatustike), a
; 120         return;
	ret
l_183:
; 121     }
; 122     a = 0;
	ld a, 0
; 123     updateFtpStatusTike = a;
	ld (updateftpstatustike), a
; 124     //
; 125     getFtpState();
	call getftpstate
; 126     //
; 127     updateFtpStatusUI();
; 128 }
; 129 
; 130 void updateFtpStatusUI() {
updateftpstatusui:
; 131     if ((a = ftpSettingsStateChange) == 0x01) {
	ld a, (ftpsettingsstatechange)
	cp 1
	jp nz, l_185
; 132         a = 0x00;
	ld a, 0
; 133         ftpSettingsStateChange = a;
	ld (ftpsettingsstatechange), a
; 134         
; 135         updateFtpViewStatusText();
	call updateftpviewstatustext
; 136         //
; 137         clearFtpViewValData();
	call clearftpviewvaldata
; 138         updateFtpViewValData();
	call updateftpviewvaldata
; 139         
; 140         // Получаем каталог
; 141         if ((a = ftpSettingsStateVal) == 0x01) {
	ld a, (ftpsettingsstateval)
	cp 1
	jp nz, l_187
; 142             needUpdateFtpList();
	call needupdateftplist
l_187:
l_185:
	ret
; 11 void needOpenWiFiSettingsEditView() {
needopenwifisettingseditview:
; 12     push_pop(hl) {
	push hl
; 13         if ((a = rootViewCurrentView) != rootViewCurrentWiFiSettingsEditView) { //Если уже открыты настройки - не открываем
	ld a, (rootviewcurrentview)
	cp 3
	jp z, l_189
; 14             if ((a = rootViewCurrentView) != rootViewCurrentFTPSettingsEditView) { //Если открыта настройка WiFi тоже не открываем
	ld a, (rootviewcurrentview)
	cp 2
	jp z, l_191
; 15                 
; 16                 a = rootViewCurrentWiFiSettingsEditView;
	ld a, 3
; 17                 rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 18                 
; 19                 a = 2;
	ld a, 2
; 20                 wifiSettingsEditViewCurrentPos = a;
	ld (wifisettingseditviewcurrentpos), a
; 21                 
; 22                 showDiskList(); //Сбросить выделение строки
	call showdisklist
; 23                 showWiFiSettingsEditView();
	call showwifisettingseditview
; 24                 wifiSettingsEditViewDataUpdate();
	call wifisettingseditviewdataupdate
l_191:
l_189:
	pop hl
	ret
; 25             }
; 26         }
; 27     }
; 28 }
; 29 
; 30 void showWiFiSettingsEditView() {
showwifisettingseditview:
; 31     drowRectX = (a = wifiSettingsEditViewX);
	ld a, (wifisettingseditviewx)
	ld (drowrectx), a
; 32     drowRectY = (a = wifiSettingsEditViewY);
	ld a, (wifisettingseditviewy)
	ld (drowrecty), a
; 33     drowRectEndX = (a = wifiSettingsEditViewEX);
	ld a, (wifisettingseditviewex)
	ld (drowrectendx), a
; 34     drowRectEndY = (a = wifiSettingsEditViewEY);
	ld a, (wifisettingseditviewey)
	ld (drowrectendy), a
; 35     drowRect();
	call drowrect
; 36     
; 37     hl = wifiSettingsEditViewLabelPos;
	ld hl, (wifisettingseditviewlabelpos)
; 38     setPosCursor();
	call setposcursor
; 39     hl = wifiSettingsEditViewLabel;
	ld hl, wifisettingseditviewlabel
; 40     printHLStr();
	call printhlstr
; 41     
; 42     hl = wifiSettingsEditViewSSIDLabelPos;
	ld hl, (wifisettingseditviewssidlabelpos)
; 43     setPosCursor();
	call setposcursor
; 44     hl = wifiSettingsEditViewSSIDLabel;
	ld hl, wifisettingseditviewssidlabel
; 45     printHLStr();
	call printhlstr
; 46     
; 47     hl = wifiSettingsEditViewSSIDPasswordLabelPos;
	ld hl, (wifisettingseditviewssidpassword)
; 48     setPosCursor();
	call setposcursor
; 49     hl = wifiSettingsEditViewSSIDPasswordLabel;
	ld hl, wifisettingseditviewssidpassword_1
; 50     printHLStr();
	call printhlstr
; 51     
; 52     hl = wifiSettingsEditViewOkLabelPos;
	ld hl, (wifisettingseditviewoklabelpos)
; 53     setPosCursor();
	call setposcursor
; 54     hl = wifiSettingsEditViewOkLabel;
	ld hl, wifisettingseditviewoklabel
; 55     printHLStr();
	jp printhlstr
; 56 }
; 57 
; 58 void wifiSettingsEditViewDataUpdate() {
wifisettingseditviewdataupdate:
; 59     if ((a = rootViewCurrentView) != rootViewCurrentWiFiSettingsEditView) {
	ld a, (rootviewcurrentview)
	cp 3
	jp z, l_193
; 60         return;
	ret
l_193:
; 61     }
; 62     
; 63     push_pop(bc) {
	push bc
; 64         b = 0;
	ld b, 0
; 65         do {
l_195:
; 66             a = 0x00;
	ld a, 0
; 67             inverceAddress = a;
	ld (inverceaddress), a
; 68             
; 69             if ((a = wifiSettingsEditViewCurrentPos) == b) {
	ld a, (wifisettingseditviewcurrentpos)
	cp b
	jp nz, l_198
; 70                 a = 0xFF;
	ld a, 255
; 71                 inverceAddress = a;
	ld (inverceaddress), a
l_198:
; 72             }
; 73             
; 74             a = b;
	ld a, b
; 75             wifiSettingsEditViewShowValueA();
	call wifisettingseditviewshowvaluea
; 76             
; 77             a = 0x00;
	ld a, 0
; 78             inverceAddress = a;
	ld (inverceaddress), a
; 79             
; 80             b++;
	inc b
; 81             a = b;
	ld a, b
; 82             a -= 5;
	sub 5
l_196:
	jp nz, l_195
	pop bc
	ret
; 83         } while (flag_nz);
; 84     }
; 85 }
; 86 
; 87 void wifiSettingsEditViewShowValueA() {
wifisettingseditviewshowvaluea:
; 88     if (a == 0) {
	or a
	jp nz, l_200
; 89         hl = wifiSettingsEditViewSSIDValPos;
	ld hl, (wifisettingseditviewssidvalpos)
; 90         setPosCursor();
	call setposcursor
; 91         
; 92         hl = wifiSettingsSsidVal;
	ld hl, wifisettingsssidval
; 93         printHLStr();
	call printhlstr
	jp l_201
l_200:
; 94     } else if (a == 1) {
	cp 1
	jp nz, l_202
; 95         hl = wifiSettingsEditViewSSIDPasswordValPos;
	ld hl, (wifisettingseditviewssidpassword_2)
; 96         setPosCursor();
	call setposcursor
; 97         
; 98         hl = wifiSettingsEditViewSSIDPasswordVal;
	ld hl, wifisettingseditviewssidpassword_3
; 99         printHLStr();
	call printhlstr
	jp l_203
l_202:
; 100     } else if (a == 2) {
	cp 2
	jp nz, l_204
; 101         hl = wifiSettingsEditViewOkLabelPos;
	ld hl, (wifisettingseditviewoklabelpos)
; 102         setPosCursor();
	call setposcursor
; 103         hl = wifiSettingsEditViewOkLabel;
	ld hl, wifisettingseditviewoklabel
; 104         printHLStr();
	call printhlstr
l_204:
l_203:
l_201:
	ret
; 105     }
; 106 }
; 107 
; 108 void wifiSettingsEditViewKeyA() {
wifisettingseditviewkeya:
; 109     push_pop(hl) {
	push hl
; 110         l = a;
	ld l, a
; 111         if ((a = rootViewCurrentView) == rootViewCurrentWiFiSettingsEditView) {
	ld a, (rootviewcurrentview)
	cp 3
	jp nz, l_206
; 112             a = l;
	ld a, l
; 113             if (a == 0x1B) { //ESC выход из настройки
	cp 27
	jp nz, l_208
; 114                 a = rootViewCurrentDiskView; // переходим на список файлов на диске
	ld a, 0
; 115                 rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 116                 
; 117                 updateRootUI();
	call updaterootui
; 118                 updateRootDataUI();
	call updaterootdataui
	jp l_209
l_208:
; 119             } else {
; 120                 if (a == 0x1A) { //down
	cp 26
	jp nz, l_210
; 121                     a = wifiSettingsEditViewCurrentPos;
	ld a, (wifisettingseditviewcurrentpos)
; 122                     a++;
	inc a
; 123                     if (a == 3) {
	cp 3
	jp nz, l_212
; 124                         a = 0;
	ld a, 0
l_212:
; 125                     }
; 126                     wifiSettingsEditViewCurrentPos = a;
	ld (wifisettingseditviewcurrentpos), a
	jp l_211
l_210:
; 127                 } else if (a == 0x19) { //up
	cp 25
	jp nz, l_214
; 128                     a = wifiSettingsEditViewCurrentPos;
	ld a, (wifisettingseditviewcurrentpos)
; 129                     if (a == 0) {
	or a
	jp nz, l_216
; 130                         a = 2;
	ld a, 2
	jp l_217
l_216:
; 131                     } else {
; 132                         a--;
	dec a
l_217:
; 133                     }
; 134                     wifiSettingsEditViewCurrentPos = a;
	ld (wifisettingseditviewcurrentpos), a
	jp l_215
l_214:
; 135                 } else if (a == 0x0D) { //Enter
	cp 13
	jp nz, l_218
; 136                     if ((a = wifiSettingsEditViewCurrentPos) == 2) { // Нажатие на кнопку ОК
	ld a, (wifisettingseditviewcurrentpos)
	cp 2
	jp nz, l_220
; 137                         
; 138                         //Пробуем подключиться в WiFi
; 139                         needSsidConnect();
	call needssidconnect
; 140                         
; 141                         a = rootViewCurrentDiskView; // переходим на список файлов на диске
	ld a, 0
; 142                         rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 143                         
; 144                         updateRootUI();
	call updaterootui
; 145                         updateRootDataUI();
	call updaterootdataui
	jp l_221
l_220:
; 146                     } else {
; 147                         wifiSettingsEditViewSelectEditField();
	call wifisettingseditviewselecteditfi
l_221:
l_218:
l_215:
l_211:
l_209:
l_206:
	pop hl
	ret
; 148                     }
; 149                 }
; 150             }
; 151         }
; 152     }
; 153 }
; 154 
; 155 void wifiSettingsEditViewSelectEditField() {
wifisettingseditviewselecteditfi:
; 156     a = wifiSettingsEditViewCurrentPos;
	ld a, (wifisettingseditviewcurrentpos)
; 157     if (a == 1) {
	cp 1
	jp nz, l_222
; 158         hl = wifiSettingsEditViewSSIDPasswordValPos;
	ld hl, (wifisettingseditviewssidpassword_2)
; 159         wifiSettingsEditViewEditValuePos = hl;
	ld (wifisettingseditvieweditvaluepos), hl
; 160         setPosCursor();
	call setposcursor
; 161         
; 162         push_pop(hl) {
	push hl
; 163             hl = wifiSettingsEditViewSSIDPasswordVal;
	ld hl, wifisettingseditviewssidpassword_3
; 164             wifiSettingsEditView_CopyStrFromHL();
	call wifisettingseditview_copystrfrom
	pop hl
	jp l_223
l_222:
; 165         }
; 166     } else {
; 167         // открыть список доступных сетей
; 168         needOpenSSIDListView();
	call needopenssidlistview
; 169         return;
	ret
l_223:
; 170     }
; 171     wifiSettingsEditViewEditField();
	jp wifisettingseditvieweditfield
; 172 }
; 173 
; 174 void wifiSettingsEditView_CopyStrFromHL() {
wifisettingseditview_copystrfrom:
; 175     push_pop(de) {
	push de
; 176         push_pop(bc) {
	push bc
; 177             de = wifiSettingsEditViewEditValue;
	ld de, wifisettingseditvieweditvalue
; 178             b = 0;
	ld b, 0
; 179             c = 0;
	ld c, 0
; 180             do {
l_224:
; 181                 a = *hl;
	ld a, (hl)
; 182                 *de = a;
	ld (de), a
; 183                 if ((a = b) == 22) {
	ld a, b
	cp 22
	jp nz, l_227
; 184                     a = 0;
	ld a, 0
; 185                     *de = a;
	ld (de), a
	jp l_228
l_227:
; 186                 } else if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_229
; 187                     a = ' ';
	ld a, 32
; 188                     *de = a;
	ld (de), a
	jp l_230
l_229:
; 189                 } else if ((a = *de) == 0) {
	ld a, (de)
	or a
	jp nz, l_231
; 190                     c = 1;
	ld c, 1
; 191                     a = ' ';
	ld a, 32
; 192                     *de = a;
	ld (de), a
; 193                     a = b;
	ld a, b
; 194                     wifiSettingsEditViewEditPos = a;
	ld (wifisettingseditvieweditpos), a
l_231:
l_230:
l_228:
; 195                 }
; 196                 
; 197                 hl ++;
	inc hl
; 198                 de++;
	inc de
; 199                 b++;
	inc b
; 200                 a = b;
	ld a, b
; 201                 a -= 23;
	sub 23
l_225:
	jp nz, l_224
	pop bc
	pop de
	ret
; 202             } while (flag_nz);
; 203         }
; 204     }
; 205 }
; 206 
; 207 void wifiSettingsEditViewEditField() {
wifisettingseditvieweditfield:
; 208     hl = wifiSettingsEditViewEditValuePos;
	ld hl, (wifisettingseditvieweditvaluepos)
; 209     setPosCursor();
	call setposcursor
; 210     
; 211     a = 0xFF;
	ld a, 255
; 212     inverceAddress = a;
	ld (inverceaddress), a
; 213     
; 214     hl = wifiSettingsEditViewEditValue;
	ld hl, wifisettingseditvieweditvalue
; 215     printHLStr();
	call printhlstr
; 216     
; 217     wifiSettingsEditViewSetEditCursor();
	call wifisettingseditviewseteditcurso
; 218     push_pop(bc) {
	push bc
; 219         b = 0;
	ld b, 0
; 220         do {
l_233:
; 221             getKeyboardCharA();
	call getkeyboardchara
; 222             
; 223             if (a == 0x1B) { // выход из редактирования без сохранения
	cp 27
	jp nz, l_236
; 224                 b = 1;
	ld b, 1
	jp l_237
l_236:
; 225             } else if (a == 0x0D) { // Сохранить и выйти из редактирования
	cp 13
	jp nz, l_238
; 226                 b = 1;
	ld b, 1
; 227                 wifiSettingsEditViewSaveField();
	call wifisettingseditviewsavefield
	jp l_239
l_238:
; 228             } else if (a >= 0x20) {
	cp 32
	jp c, l_240
; 229                 if (a < 0x7F) { //Ввод символа
	cp 127
	jp nc, l_242
; 230                     c = a;
	ld c, a
; 231                     // Если достигли предела - то перемещаем курсор на 1 назад
; 232                     a = wifiSettingsEditViewEditPos;
	ld a, (wifisettingseditvieweditpos)
; 233                     if (a >= 15) {
	cp 15
	jp c, l_244
; 234                         a--;
	dec a
l_244:
; 235                     }
; 236                     wifiSettingsEditViewEditPos = a;
	ld (wifisettingseditvieweditpos), a
; 237                     
; 238                     //Сохраняем символ
; 239                     a = c;
	ld a, c
; 240                     wifiSettingsEditViewSetValueA();
	call wifisettingseditviewsetvaluea
; 241                     a = wifiSettingsEditViewEditPos;
	ld a, (wifisettingseditvieweditpos)
; 242                     a++;
	inc a
; 243                     wifiSettingsEditViewEditPos = a;
	ld (wifisettingseditvieweditpos), a
; 244                     wifiSettingsEditViewSetEditCursor();
	call wifisettingseditviewseteditcurso
	jp l_243
l_242:
; 245                 } else if (a == 0x7F) { //Забой... (удаление символа)
	cp 127
	jp nz, l_246
; 246                     if ((a = wifiSettingsEditViewEditPos) > 0) {
	ld a, (wifisettingseditvieweditpos)
	or a
	jp z, l_248
; 247                         a--;
	dec a
; 248                         wifiSettingsEditViewEditPos = a;
	ld (wifisettingseditvieweditpos), a
; 249                         wifiSettingsEditViewSetEditCursor();
	call wifisettingseditviewseteditcurso
; 250                         a = ' ';
	ld a, 32
; 251                         wifiSettingsEditViewSetValueA();
	call wifisettingseditviewsetvaluea
l_248:
l_246:
l_243:
l_240:
l_239:
l_237:
; 252                     }
; 253                 }
; 254             }
; 255             
; 256             a = b;
	ld a, b
; 257             a -= 1;
	sub 1
l_234:
	jp nz, l_233
	pop bc
; 258         } while (flag_nz);
; 259     }
; 260     
; 261     a = 0x00;
	ld a, 0
; 262     inverceAddress = a;
	ld (inverceaddress), a
; 263     
; 264     showWiFiSettingsEditView();
	call showwifisettingseditview
; 265     wifiSettingsEditViewDataUpdate();
	jp wifisettingseditviewdataupdate
; 266 }
; 267 
; 268 void wifiSettingsEditViewSetEditCursor() {
wifisettingseditviewseteditcurso:
; 269     push_pop(hl) {
	push hl
; 270         hl = wifiSettingsEditViewEditValuePos;
	ld hl, (wifisettingseditvieweditvaluepos)
; 271         a = wifiSettingsEditViewEditPos;
	ld a, (wifisettingseditvieweditpos)
; 272         a += l;
	add l
; 273         l = a;
	ld l, a
; 274         setPosCursor();
	call setposcursor
	pop hl
	ret
; 275     }
; 276 }
; 277 
; 278 void wifiSettingsEditViewSaveField() {
wifisettingseditviewsavefield:
; 279     a = wifiSettingsEditViewCurrentPos;
	ld a, (wifisettingseditviewcurrentpos)
; 280     if (a == 1) {
	cp 1
	jp nz, l_250
; 281         hl = wifiSettingsEditViewSSIDPasswordVal;
	ld hl, wifisettingseditviewssidpassword_3
l_250:
; 282     }
; 283     wifiSettingsEditViewSaveEditValueToHL();
	jp wifisettingseditviewsaveeditvalu
; 284 }
; 285 
; 286 void wifiSettingsEditViewSetValueA() {
wifisettingseditviewsetvaluea:
; 287     push_pop(hl) {
	push hl
; 288         push_pop(bc) {
	push bc
; 289             b = a;
	ld b, a
; 290             //Сохраним символ в wifiSettingsEditViewEditValue
; 291             hl = wifiSettingsEditViewEditValue;
	ld hl, wifisettingseditvieweditvalue
; 292             a = wifiSettingsEditViewEditPos;
	ld a, (wifisettingseditvieweditpos)
; 293             a += l;
	add l
; 294             l = a;
	ld l, a
; 295             if (flag_c) {
	jp nc, l_252
; 296                 h++;
	inc h
l_252:
; 297             }
; 298             *hl = b;
	ld (hl), b
; 299             //Отрисуем символ на экране
; 300             wifiSettingsEditViewSetEditCursor();
	call wifisettingseditviewseteditcurso
; 301             a = b;
	ld a, b
; 302             printChatA();
	call printchata
; 303             wifiSettingsEditViewSetEditCursor();
	call wifisettingseditviewseteditcurso
	pop bc
	pop hl
	ret
; 304         }
; 305     }
; 306 }
; 307 
; 308 void wifiSettingsEditViewSaveEditValueToHL() {
wifisettingseditviewsaveeditvalu:
; 309     push_pop(de) {
	push de
; 310         push_pop(bc) {
	push bc
; 311             de = wifiSettingsEditViewEditValue;
	ld de, wifisettingseditvieweditvalue
; 312             a = wifiSettingsEditViewEditPos;
	ld a, (wifisettingseditvieweditpos)
; 313             c = a;
	ld c, a
; 314             b = 0;
	ld b, 0
; 315             do {
l_254:
; 316                 a = *de;
	ld a, (de)
; 317                 *hl = a;
	ld (hl), a
; 318                 hl++;
	inc hl
; 319                 de++;
	inc de
; 320                 b++;
	inc b
; 321                 a = b;
	ld a, b
; 322                 a -= c;
	sub c
l_255:
	jp nz, l_254
; 323             } while (flag_nz);
; 324             *hl = 0;
	ld (hl), 0
	pop bc
	pop de
; 325         }
; 326     }
; 327     setSSIDPasswordValue();
	call setssidpasswordvalue
; 328     setSSIDPasswordValue();
	jp setssidpasswordvalue
; 329     //getSSIDPasswordValue();
; 330 }
; 331 
; 332 ///  Обновить данные WiFi
; 333 void updateWiFiStatus() {
updatewifistatus:
; 334     a = updateWiFiStatusTike;
	ld a, (updatewifistatustike)
; 335     if (a < 240) {
	cp 240
	jp nc, l_257
; 336         a++;
	inc a
; 337         updateWiFiStatusTike = a;
	ld (updatewifistatustike), a
; 338         return;
	ret
l_257:
; 339     }
; 340     a = 0;
	ld a, 0
; 341     updateWiFiStatusTike = a;
	ld (updatewifistatustike), a
; 342     //
; 343     getSSIDState();
	call getssidstate
; 344     if ((a = WiFiStateUpdate) == 0x01) {
	ld a, (wifistateupdate)
	cp 1
	jp nz, l_259
; 345         a = 0x00;
	ld a, 0
; 346         WiFiStateUpdate = a;
	ld (wifistateupdate), a
; 347         getSSIDIPAddress();
	call getssidipaddress
; 348         getSSIDMacAddress();
	call getssidmacaddress
; 349         //
; 350         clearWiFiViewValData();
	call clearwifiviewvaldata
; 351         updateWiFiViewValData();
	call updatewifiviewvaldata
l_259:
	ret
; 13 void needOpenSSIDListView() {
needopenssidlistview:
; 14     push_pop(hl) {
	push hl
; 15         if ((a = rootViewCurrentView) != rootSSIDListView) { //Если уже открыто окно - не открываем
	ld a, (rootviewcurrentview)
	cp 4
	jp z, l_261
; 16             a = rootSSIDListView;
	ld a, 4
; 17             rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 18             
; 19             a = 0;
	ld a, 0
; 20             SSIDListViewCurrentPos = a;
	ld (ssidlistviewcurrentpos), a
; 21             
; 22             showSSIDListView();
	call showssidlistview
; 23             SSIDListViewDataUpdate();
	call ssidlistviewdataupdate
l_261:
	pop hl
	ret
; 24         }
; 25     }
; 26 }
; 27 
; 28 void SSIDListGetCount() {
ssidlistgetcount:
; 29     push_pop(hl) {
	push hl
; 30         push_pop(bc) {
	push bc
; 31             push_pop(de) {
	push de
; 32                 a = 0;
	ld a, 0
; 33                 SSIDListCount = a;
	ld (ssidlistcount), a
; 34                 de = 16;
	ld de, 16
; 35                 
; 36                 b = 16;
	ld b, 16
; 37                 hl = SSIDList;
	ld hl, ssidlist
; 38                 do {
l_263:
; 39                     a = *hl;
	ld a, (hl)
; 40                     if (a > 0) {
	or a
	jp z, l_266
; 41                         a = SSIDListCount;
	ld a, (ssidlistcount)
; 42                         a++;
	inc a
; 43                         SSIDListCount = a;
	ld (ssidlistcount), a
l_266:
; 44                     }
; 45                     hl += de;
	add hl, de
; 46                     b--;
	dec b
l_264:
	jp nz, l_263
	pop de
	pop bc
	pop hl
	ret
; 47                 } while (flag_nz);
; 48             }
; 49         }
; 50     }
; 51 }
; 52 
; 53 void setSSIDPosCursorC() {
setssidposcursorc:
; 54     push_pop(hl) {
	push hl
; 55         a = SSIDListViewY;
	ld a, (ssidlistviewy)
; 56         a += 2;
	add 2
; 57         a += c;
	add c
; 58         h = a;
	ld h, a
; 59         a = SSIDListViewX;
	ld a, (ssidlistviewx)
; 60         a += 3;
	add 3
; 61         l = a;
	ld l, a
; 62         setPosCursor();
	call setposcursor
	pop hl
	ret
; 63     }
; 64 }
; 65 
; 66 void showSSIDListView() {
showssidlistview:
; 67     drowRectX = (a = SSIDListViewX);
	ld a, (ssidlistviewx)
	ld (drowrectx), a
; 68     drowRectY = (a = SSIDListViewY);
	ld a, (ssidlistviewy)
	ld (drowrecty), a
; 69     drowRectEndX = (a = SSIDListViewEX);
	ld a, (ssidlistviewex)
	ld (drowrectendx), a
; 70     drowRectEndY = (a = SSIDListViewEY);
	ld a, (ssidlistviewey)
	ld (drowrectendy), a
; 71     drowRect();
	call drowrect
; 72     
; 73     hl = SSIDListViewTitlePos;
	ld hl, (ssidlistviewtitlepos)
; 74     setPosCursor();
	call setposcursor
; 75     hl = SSIDListViewTitle;
	ld hl, ssidlistviewtitle
; 76     printHLStr();
	call printhlstr
; 77     
; 78     i2cWaitingForAccess();
	call i2cwaitingforaccess
; 79     needUpdateSSIDList();
	call needupdatessidlist
; 80     i2cWaitingForAccess();
	call i2cwaitingforaccess
; 81     getSSIDList();
	call getssidlist
; 82     
; 83     SSIDFixBuffer();
	call ssidfixbuffer
; 84     
; 85     // Получить кол-во сетей
; 86     SSIDListGetCount();
	jp ssidlistgetcount
; 87 }
; 88 
; 89 void SSIDFixBuffer() {
ssidfixbuffer:
; 90     push_pop(bc) {
	push bc
; 91         push_pop(de) {
	push de
; 92             push_pop(hl) {
	push hl
; 93                 hl = SSIDList;
	ld hl, ssidlist
; 94                 de = 15;
	ld de, 15
; 95                 hl += de;
	add hl, de
; 96                 de = 16;
	ld de, 16
; 97                 b = 16;
	ld b, 16
; 98                 do {
l_268:
; 99                     a = 0;
	ld a, 0
; 100                     *hl = a;
	ld (hl), a
; 101                     hl += de;
	add hl, de
; 102                     b--;
	dec b
l_269:
	jp nz, l_268
	pop hl
	pop de
	pop bc
	ret
; 103                 } while (flag_nz);
; 104             }
; 105         }
; 106     }
; 107 }
; 108 
; 109 void SSIDListViewDataUpdate() {
ssidlistviewdataupdate:
; 110     if ((a = rootViewCurrentView) != rootSSIDListView) {
	ld a, (rootviewcurrentview)
	cp 4
	jp z, l_271
; 111         return;
	ret
l_271:
; 112     }
; 113     
; 114     push_pop(bc) {
	push bc
; 115         b = 0;
	ld b, 0
; 116         do {
l_273:
; 117             a = 0x00;
	ld a, 0
; 118             inverceAddress = a;
	ld (inverceaddress), a
; 119             
; 120             if ((a = SSIDListViewCurrentPos) == b) {
	ld a, (ssidlistviewcurrentpos)
	cp b
	jp nz, l_276
; 121                 a = 0xFF;
	ld a, 255
; 122                 inverceAddress = a;
	ld (inverceaddress), a
l_276:
; 123             }
; 124             
; 125             a = b;
	ld a, b
; 126             SSIDListViewShowValueA();
	call ssidlistviewshowvaluea
; 127             
; 128             a = 0x00;
	ld a, 0
; 129             inverceAddress = a;
	ld (inverceaddress), a
; 130             
; 131             b++;
	inc b
; 132             a = SSIDListCount;
	ld a, (ssidlistcount)
; 133             a -= b;
	sub b
l_274:
	jp nz, l_273
	pop bc
	ret
; 134             //a = b;
; 135             //a -= SSIDListCount;
; 136         } while (flag_nz);
; 137     }
; 138 }
; 139 
; 140 void SSIDListViewShowValueA() {
ssidlistviewshowvaluea:
; 141     push_pop(hl) {
	push hl
; 142         push_pop(de) {
	push de
; 143             de = 16;
	ld de, 16
; 144             c = a;
	ld c, a
; 145             setSSIDPosCursorC();
	call setssidposcursorc
; 146             hl = SSIDList;
	ld hl, ssidlist
; 147             if ((a = c) > 0) {
	ld a, c
	or a
	jp z, l_278
; 148                 do {
l_280:
; 149                     hl += de;
	add hl, de
; 150                     c--;
	dec c
l_281:
	jp nz, l_280
l_278:
; 151                 } while (flag_nz);
; 152             }
; 153             printHLStr();
	call printhlstr
	pop de
	pop hl
	ret
; 154         }
; 155     }
; 156 }
; 157 
; 158 void SSIDListViewKeyA() {
ssidlistviewkeya:
; 159     push_pop(hl) {
	push hl
; 160         l = a;
	ld l, a
; 161         if ((a = rootViewCurrentView) == rootSSIDListView) {
	ld a, (rootviewcurrentview)
	cp 4
	jp nz, l_283
; 162             a = l;
	ld a, l
; 163             if (a == 0x1B) { //ESC выход из настройки
	cp 27
	jp nz, l_285
; 164                 a = rootViewCurrentDiskView; // переходим на список файлов на диске
	ld a, 0
; 165                 rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 166                 
; 167                 updateRootUI();
	call updaterootui
; 168                 updateRootDataUI();
	call updaterootdataui
; 169                 needOpenWiFiSettingsEditView();
	call needopenwifisettingseditview
	jp l_286
l_285:
; 170             } else {
; 171                 a = SSIDListCount;
	ld a, (ssidlistcount)
; 172                 h = a;
	ld h, a
; 173                 a = l;
	ld a, l
; 174                 if (a == 0x1A) { //down
	cp 26
	jp nz, l_287
; 175                     a = SSIDListViewCurrentPos;
	ld a, (ssidlistviewcurrentpos)
; 176                     a++;
	inc a
; 177                     if (a == h) {
	cp h
	jp nz, l_289
; 178                         a = 0;
	ld a, 0
l_289:
; 179                     }
; 180                     SSIDListViewCurrentPos = a;
	ld (ssidlistviewcurrentpos), a
	jp l_288
l_287:
; 181                 } else if (a == 0x19) { //up
	cp 25
	jp nz, l_291
; 182                     a = SSIDListViewCurrentPos;
	ld a, (ssidlistviewcurrentpos)
; 183                     if (a == 0) {
	or a
	jp nz, l_293
; 184                         a = h;
	ld a, h
; 185                         a--;
	dec a
	jp l_294
l_293:
; 186                     } else {
; 187                         a--;
	dec a
l_294:
; 188                     }
; 189                     SSIDListViewCurrentPos = a;
	ld (ssidlistviewcurrentpos), a
	jp l_292
l_291:
; 190                 } else if (a == 0x0D) { //Enter
	cp 13
	jp nz, l_295
; 191                     // Надо отправить на ESP
; 192                     a = SSIDListViewCurrentPos;
	ld a, (ssidlistviewcurrentpos)
; 193                     
; 194                     // Отправляем index на ESP
; 195                     setSSIDNumberA();
	call setssidnumbera
; 196                     // Подождем
; 197                     
; 198                     getSSIDValue();
	call getssidvalue
; 199                     
; 200                     // закрываем
; 201                     a = rootViewCurrentDiskView; // переходим на список файлов на диске
	ld a, 0
; 202                     rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 203                     
; 204                     updateRootUI();
	call updaterootui
; 205                     updateRootDataUI();
	call updaterootdataui
; 206                     needOpenWiFiSettingsEditView();
	call needopenwifisettingseditview
l_295:
l_292:
l_288:
l_286:
l_283:
	pop hl
	ret
; 12 uint8_t myFont[] =
myfont:
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 31
	db 16
	db 16
	db 19
	db 18
	db 18
	db 18
	db 18
	db 19
	db 16
	db 16
	db 31
	db 0
	db 0
	db 0
	db 0
	db 62
	db 2
	db 2
	db 50
	db 18
	db 18
	db 18
	db 18
	db 50
	db 2
	db 2
	db 62
	db 0
	db 0
	db 18
	db 18
	db 18
	db 18
	db 18
	db 18
	db 18
	db 18
	db 0
	db 0
	db 63
	db 0
	db 0
	db 63
	db 0
	db 0
	db 42
	db 21
	db 42
	db 21
	db 42
	db 21
	db 42
	db 21
	db 63
	db 63
	db 63
	db 63
	db 63
	db 63
	db 63
	db 63
; 11 uint8_t wifiSettingsViewX = 0x00;
wifisettingsviewx:
	db 0
; 12 uint8_t wifiSettingsViewY = 0x01;
wifisettingsviewy:
	db 1
; 13 uint8_t wifiSettingsViewEX = 29;
wifisettingsviewex:
	db 29
; 14 uint8_t wifiSettingsViewEY = 6;
wifisettingsviewey:
	db 6
; 15 uint16_t wifiSettingsPos = 0x0108;
wifisettingspos:
	dw 264
; 16 uint8_t wifiSettingsLabel[] = " WI-FI SETTINGS ";
wifisettingslabel:
	db 32
	db 87
	db 73
	db 45
	db 70
	db 73
	db 32
	db 83
	db 69
	db 84
	db 84
	db 73
	db 78
	db 71
	db 83
	db 32
	ds 1
; 17 uint8_t wifiSettingsSsidLabel[] = "SSID:";
wifisettingsssidlabel:
	db 83
	db 83
	db 73
	db 68
	db 58
	ds 1
; 18 uint8_t wifiSettingsIpLabel[] = "IP  :";
wifisettingsiplabel:
	db 73
	db 80
	db 32
	db 32
	db 58
	ds 1
; 19 uint8_t wifiSettingsMacLabel[] = "MAC :";
wifisettingsmaclabel:
	db 77
	db 65
	db 67
	db 32
	db 58
	ds 1
; 21 uint16_t wifiSettingsSsidLabelPos = 0x0202;
wifisettingsssidlabelpos:
	dw 514
; 22 uint16_t wifiSettingsIpLabelPos = 0x0302;
wifisettingsiplabelpos:
	dw 770
; 23 uint16_t wifiSettingsMacLabelPos = 0x0402;
wifisettingsmaclabelpos:
	dw 1026
; 25 uint16_t wifiSettingsSsidValPos = 0x0208;
wifisettingsssidvalpos:
	dw 520
; 26 uint8_t wifiSettingsSsidVal[16] = "K159";
wifisettingsssidval:
	db 75
	db 49
	db 53
	db 57
	ds 12
; 27 uint16_t wifiSettingsIpValPos = 0x0308;
wifisettingsipvalpos:
	dw 776
; 28 uint8_t wifiSettingsIpVal[16] = "-";
wifisettingsipval:
	db 45
	ds 15
; 29 uint16_t wifiSettingsMacValPos = 0x0408;
wifisettingsmacvalpos:
	dw 1032
; 30 uint8_t wifiSettingsMacVal[18] = "-";
wifisettingsmacval:
	db 45
	ds 17
; 32 uint8_t wifiSettingsEmpty18[18] = "                 ";
wifisettingsempty18:
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	ds 1
; 11 uint8_t ftpSettingsViewX = 30;
ftpsettingsviewx:
	db 30
; 12 uint8_t ftpSettingsViewY = 1;
ftpsettingsviewy:
	db 1
; 13 uint8_t ftpSettingsViewEX = 63; //54;
ftpsettingsviewex:
	db 63
; 14 uint8_t ftpSettingsViewEY = 6;
ftpsettingsviewey:
	db 6
; 16 uint16_t ftpSettingsLabelPos = 0x0127;
ftpsettingslabelpos:
	dw 295
; 17 uint8_t ftpSettingsLabel[] = " FTP SETTINGS ";
ftpsettingslabel:
	db 32
	db 70
	db 84
	db 80
	db 32
	db 83
	db 69
	db 84
	db 84
	db 73
	db 78
	db 71
	db 83
	db 32
	ds 1
; 20 uint16_t ftpSettingsIpLabelPos = 0x0220;
ftpsettingsiplabelpos:
	dw 544
; 21 uint8_t ftpSettingsIpLabel[] = "IP:";
ftpsettingsiplabel:
	db 73
	db 80
	db 58
	ds 1
; 23 uint16_t ftpSettingsPortLabelPos = 0x0234;
ftpsettingsportlabelpos:
	dw 564
; 24 uint8_t ftpSettingsPortLabel[] = "PORT:";
ftpsettingsportlabel:
	db 80
	db 79
	db 82
	db 84
	db 58
	ds 1
; 26 uint16_t ftpSettingsUserLabelPos = 0x0320;
ftpsettingsuserlabelpos:
	dw 800
; 27 uint8_t ftpSettingsUserLabel[] = "USER:";
ftpsettingsuserlabel:
	db 85
	db 83
	db 69
	db 82
	db 58
	ds 1
; 29 uint16_t ftpSettingsStatusLabelPos = 0x0420;
ftpsettingsstatuslabelpos:
	dw 1056
; 30 uint8_t ftpSettingsStatusLabel[] = "STATUS:";
ftpsettingsstatuslabel:
	db 83
	db 84
	db 65
	db 84
	db 85
	db 83
	db 58
	ds 1
; 32 uint16_t ftpSettingsIpValuePos = 0x0224;
ftpsettingsipvaluepos:
	dw 548
; 33 uint8_t ftpSettingsIpValue[16] = "100.100.100.100";
ftpsettingsipvalue:
	db 49
	db 48
	db 48
	db 46
	db 49
	db 48
	db 48
	db 46
	db 49
	db 48
	db 48
	db 46
	db 49
	db 48
	db 48
	ds 1
; 35 uint16_t ftpSettingsPortValuePos = 0x023A;
ftpsettingsportvaluepos:
	dw 570
; 36 uint8_t ftpSettingsPortValue[6] = "21";
ftpsettingsportvalue:
	db 50
	db 49
	ds 4
; 38 uint16_t ftpSettingsStatusValuePos = 0x0428;
ftpsettingsstatusvaluepos:
	dw 1064
; 39 uint8_t ftpSettingsStatusValue[12] = "-";
ftpsettingsstatusvalue:
	db 45
	ds 11
; 40 uint8_t ftpSettingsStateVal = 0;
ftpsettingsstateval:
	db 0
; 41 uint8_t ftpSettingsStateChange = 1;
ftpsettingsstatechange:
	db 1
; 42 uint8_t ftpSettingsStatus0[12] = "DISCONNECT ";
ftpsettingsstatus0:
	db 68
	db 73
	db 83
	db 67
	db 79
	db 78
	db 78
	db 69
	db 67
	db 84
	db 32
	ds 1
; 43 uint8_t ftpSettingsStatus1[12] = "CONNECT    ";
ftpsettingsstatus1:
	db 67
	db 79
	db 78
	db 78
	db 69
	db 67
	db 84
	db 32
	db 32
	db 32
	db 32
	ds 1
; 45 uint16_t ftpSettingsUserValuePos = 0x0326;
ftpsettingsuservaluepos:
	dw 806
; 46 uint8_t ftpSettingsUserValue[16] = "ESP8266";
ftpsettingsuservalue:
	db 69
	db 83
	db 80
	db 56
	db 50
	db 54
	db 54
	ds 9
; 11 uint8_t diskViewX = 0;
diskviewx:
	db 0
; 12 uint8_t diskViewY = 7;
diskviewy:
	db 7
; 13 uint8_t diskViewEX = 29; //54;
diskviewex:
	db 29
; 14 uint8_t diskViewEY = 25;
diskviewey:
	db 25
; 16 uint16_t diskViewLabelPos = 0x0709;
diskviewlabelpos:
	dw 1801
; 17 uint8_t diskViewLabel[] = " DISK:   ";
diskviewlabel:
	db 32
	db 68
	db 73
	db 83
	db 75
	db 58
	db 32
	db 32
	db 32
	ds 1
; 19 uint8_t diskViewDiskNum = 'B';
diskviewdisknum:
	db 66
; 20 uint8_t diskViewListCount = 0;
diskviewlistcount:
	db 0
; 21 uint8_t diskViewCurrPos = 1;
diskviewcurrpos:
	db 1
; 22 uint16_t diskViewListNamePos = 0x0902;
diskviewlistnamepos:
	dw 2306
; 24 uint16_t diskViewListDirPos = 0x0802;
diskviewlistdirpos:
	dw 2050
; 25 uint8_t diskViewListDirLabel[] = " ..       ";
diskviewlistdirlabel:
	db 32
	db 46
	db 46
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	ds 1
; 27 uint16_t diskViewDriveNamePos = 0x0710;
diskviewdrivenamepos:
	dw 1808
; 29 uint16_t diskStartNewFile = 0x0000;
diskstartnewfile:
	dw 0
; 11 uint8_t ftpViewX = 30;
ftpviewx:
	db 30
; 12 uint8_t ftpViewY = 7;
ftpviewy:
	db 7
; 13 uint8_t ftpViewEX = 63;
ftpviewex:
	db 63
; 14 uint8_t ftpViewEY = 25;
ftpviewey:
	db 25
; 16 uint16_t ftpLabelPos = 0x0728;
ftplabelpos:
	dw 1832
; 17 uint8_t ftpLabel[] = " FTP: ";
ftplabel:
	db 32
	db 70
	db 84
	db 80
	db 58
	db 32
	ds 1
; 19 uint8_t ftpDirList[16 * 24];
ftpdirlist:
	ds 384
; 20 uint8_t ftpDirListNext = 0;
ftpdirlistnext:
	db 0
; 21 uint8_t ftpDirListCount = 0;
ftpdirlistcount:
	db 0
; 22 uint8_t ftpDirListIsDir = 0;
ftpdirlistisdir:
	db 0
; 24 uint8_t ftpViewCurrentPos = 0;
ftpviewcurrentpos:
	db 0
; 16 uint8_t rootViewCurrentView = 0;
rootviewcurrentview:
	db 0
; 18 uint16_t rootViewHelpStrPos = 0x0600;
rootviewhelpstrpos:
	dw 1536
; 19 uint8_t rootViewHelpStr[] = " F1: ..          F2: WI-FI          F3: FTP          F4: QUIT";
rootviewhelpstr:
	db 32
	db 70
	db 49
	db 58
	db 32
	db 46
	db 46
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 70
	db 50
	db 58
	db 32
	db 87
	db 73
	db 45
	db 70
	db 73
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 70
	db 51
	db 58
	db 32
	db 70
	db 84
	db 80
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 32
	db 70
	db 52
	db 58
	db 32
	db 81
	db 85
	db 73
	db 84
	ds 1
; 21 uint8_t rootViewOldKey = 0xFF;
rootviewoldkey:
	db 255
; 11 uint8_t ftpSettingsEditViewX = 14;
ftpsettingseditviewx:
	db 14
; 12 uint8_t ftpSettingsEditViewY = 4;
ftpsettingseditviewy:
	db 4
; 13 uint8_t ftpSettingsEditViewEX = 50;
ftpsettingseditviewex:
	db 50
; 14 uint8_t ftpSettingsEditViewEY = 20;
ftpsettingseditviewey:
	db 20
; 16 uint16_t ftpSettingsEditViewLabelPos = 0x0418;
ftpsettingseditviewlabelpos:
	dw 1048
; 17 uint8_t ftpSettingsEditViewLabel[] = " FTP SETTINGS ";
ftpsettingseditviewlabel:
	db 32
	db 70
	db 84
	db 80
	db 32
	db 83
	db 69
	db 84
	db 84
	db 73
	db 78
	db 71
	db 83
	db 32
	ds 1
; 19 uint16_t ftpSettingsEditViewIpLabelPos = 0x0713;
ftpsettingseditviewiplabelpos:
	dw 1811
; 20 uint16_t ftpSettingsEditViewPortLabelPos = 0x0911;
ftpsettingseditviewportlabelpos:
	dw 2321
; 21 uint16_t ftpSettingsEditViewUserLabelPos = 0x0B11;
ftpsettingseditviewuserlabelpos:
	dw 2833
; 23 uint16_t ftpSettingsEditViewPasswordLabelPos = 0x0D11;
ftpsettingseditviewpasswordlabel:
	dw 3345
; 24 uint8_t ftpSettingsEditViewPasswordLabel[] = "PASS:";
ftpsettingseditviewpasswordlabel_0:
	db 80
	db 65
	db 83
	db 83
	db 58
	ds 1
; 26 uint16_t ftpSettingsEditViewOkLabelPos = 0x101D;
ftpsettingseditviewoklabelpos:
	dw 4125
; 27 uint8_t ftpSettingsEditViewOkLabel[] = "  OK  ";
ftpsettingseditviewoklabel:
	db 32
	db 32
	db 79
	db 75
	db 32
	db 32
	ds 1
; 29 uint16_t ftpSettingsEditViewIpValPos = 0x0719;
ftpsettingseditviewipvalpos:
	dw 1817
; 30 uint16_t ftpSettingsEditViewPortValPos = 0x0919;
ftpsettingseditviewportvalpos:
	dw 2329
; 31 uint16_t ftpSettingsEditViewUserValPos = 0x0B19;
ftpsettingseditviewuservalpos:
	dw 2841
; 32 uint16_t ftpSettingsEditViewPasswordValPos = 0x0D19;
ftpsettingseditviewpasswordvalpo:
	dw 3353
; 33 uint8_t ftpSettingsEditViewPasswordVal[16] = "ESP8266";
ftpsettingseditviewpasswordval:
	db 69
	db 83
	db 80
	db 56
	db 50
	db 54
	db 54
	ds 9
; 35 uint8_t ftpSettingsEditViewCurrentPos = 0;
ftpsettingseditviewcurrentpos:
	db 0
; 37 uint16_t ftpSettingsEditViewEditValuePos = 0x0000;
ftpsettingseditvieweditvaluepos:
	dw 0
; 38 uint8_t ftpSettingsEditViewEditValue[24] = "";
ftpsettingseditvieweditvalue:
	ds 24
; 39 uint8_t ftpSettingsEditViewEditPos = 0;
ftpsettingseditvieweditpos:
	db 0
; 41 uint8_t updateFtpStatusTike = 0;
updateftpstatustike:
	db 0
; 11 void createTestFile() {
createtestfile:
; 12     push_pop(hl) {
	push hl
; 13         a = diskViewDiskNum;
	ld a, (diskviewdisknum)
; 14         ordos_wnd();
	call ordos_wnd
; 15         
; 16         ordos_mxdsk();
	call ordos_mxdsk
; 17         diskStartNewFile = hl;
	ld (diskstartnewfile), hl
; 18         de = fileTable;
	ld de, filetable
; 19         b = 0;
	ld b, 0
; 20         do {
l_297:
; 21             a = *de;
	ld a, (de)
; 22             ordos_wdisk();
	call ordos_wdisk
; 23             hl++;
	inc hl
; 24             de++;
	inc de
; 25             b++;
	inc b
; 26             a = b;
	ld a, b
; 27             a -= 64;
	sub 64
l_298:
	jp nz, l_297
; 28         } while (flag_nz);
; 29         ordos_stop();
	call ordos_stop
	pop hl
	ret
; 30     }
; 31 }
; 32 
; 33 uint8_t fileTable[] = {
filetable:
	db 66
	db 79
	db 79
	db 84
	db 36
	db 32
	db 32
	db 32
	db 0
	db 180
	db 48
	db 0
	db 0
	db 255
	db 255
	db 255
	db 33
	db 208
	db 180
	db 205
	db 24
	db 248
	db 17
	db 0
	db 247
	db 62
	db 16
	db 50
	db 32
	db 247
	db 175
	db 50
	db 1
	db 247
	db 62
	db 208
	db 205
	db 191
	db 180
	db 6
	db 5
	db 62
	db 75
	db 205
	db 191
	db 180
	db 5
	db 194
	db 25
	db 180
	db 62
	db 11
	db 205
	db 191
	db 180
	db 26
	db 7
	db 218
	db 39
	db 180
	db 205
	db 141
	db 180
	db 202
; 11 uint8_t wifiSettingsEditViewCurrentPos = 0;
wifisettingseditviewcurrentpos:
	db 0
; 13 uint8_t wifiSettingsEditViewX = 14;
wifisettingseditviewx:
	db 14
; 14 uint8_t wifiSettingsEditViewY = 4;
wifisettingseditviewy:
	db 4
; 15 uint8_t wifiSettingsEditViewEX = 50;
wifisettingseditviewex:
	db 50
; 16 uint8_t wifiSettingsEditViewEY = 15;
wifisettingseditviewey:
	db 15
; 18 uint16_t wifiSettingsEditViewLabelPos = 0x0418;
wifisettingseditviewlabelpos:
	dw 1048
; 19 uint8_t wifiSettingsEditViewLabel[] = " WI-FI SETTINGS ";
wifisettingseditviewlabel:
	db 32
	db 87
	db 73
	db 45
	db 70
	db 73
	db 32
	db 83
	db 69
	db 84
	db 84
	db 73
	db 78
	db 71
	db 83
	db 32
	ds 1
; 21 uint16_t wifiSettingsEditViewSSIDLabelPos = 0x0711;
wifisettingseditviewssidlabelpos:
	dw 1809
; 22 uint8_t wifiSettingsEditViewSSIDLabel[] = "SSID:";
wifisettingseditviewssidlabel:
	db 83
	db 83
	db 73
	db 68
	db 58
	ds 1
; 24 uint16_t wifiSettingsEditViewSSIDPasswordLabelPos = 0x0911;
wifisettingseditviewssidpassword:
	dw 2321
; 25 uint8_t wifiSettingsEditViewSSIDPasswordLabel[] = "PASS:";
wifisettingseditviewssidpassword_1:
	db 80
	db 65
	db 83
	db 83
	db 58
	ds 1
; 27 uint16_t wifiSettingsEditViewOkLabelPos = 0x0B1D;
wifisettingseditviewoklabelpos:
	dw 2845
; 28 uint8_t wifiSettingsEditViewOkLabel[] = "  OK  ";
wifisettingseditviewoklabel:
	db 32
	db 32
	db 79
	db 75
	db 32
	db 32
	ds 1
; 30 uint16_t wifiSettingsEditViewSSIDValPos = 0x0719;
wifisettingseditviewssidvalpos:
	dw 1817
; 31 uint16_t wifiSettingsEditViewSSIDPasswordValPos = 0x0919;
wifisettingseditviewssidpassword_2:
	dw 2329
; 33 uint8_t wifiSettingsEditViewSSIDPasswordVal[16] = "---";
wifisettingseditviewssidpassword_3:
	db 45
	db 45
	db 45
	ds 13
; 35 uint16_t wifiSettingsEditViewEditValuePos = 0x0000;
wifisettingseditvieweditvaluepos:
	dw 0
; 36 uint8_t wifiSettingsEditViewEditValue[24] = "";
wifisettingseditvieweditvalue:
	ds 24
; 37 uint8_t wifiSettingsEditViewEditPos = 0;
wifisettingseditvieweditpos:
	db 0
; 39 uint8_t updateWiFiStatusTike = 0;
updatewifistatustike:
	db 0
; 40 uint8_t WiFiState = 0;
wifistate:
	db 0
; 41 uint8_t WiFiStateUpdate = 1;
wifistateupdate:
	db 1
; 11 uint8_t SSIDListViewX = 22;
ssidlistviewx:
	db 22
; 12 uint8_t SSIDListViewY = 3;
ssidlistviewy:
	db 3
; 13 uint8_t SSIDListViewEX = 44;
ssidlistviewex:
	db 44
; 14 uint8_t SSIDListViewEY = 23;
ssidlistviewey:
	db 23
; 16 uint16_t SSIDListViewTitlePos = 0x031B;
ssidlistviewtitlepos:
	dw 795
; 17 uint8_t SSIDListViewTitle[] = " SSID LIST ";
ssidlistviewtitle:
	db 32
	db 83
	db 83
	db 73
	db 68
	db 32
	db 76
	db 73
	db 83
	db 84
	db 32
	ds 1
; 19 uint8_t SSIDListCount = 0;
ssidlistcount:
	db 0
; 20 uint8_t SSIDListViewCurrentPos = 0;
ssidlistviewcurrentpos:
	db 0
; 21 uint8_t SSIDListNext = 0;
ssidlistnext:
	db 0
; 23 uint8_t SSIDList[] = {
ssidlist:
	db 68
	db 73
	db 82
	db 69
	db 67
	db 84
	db 45
	db 76
	db 48
	db 91
	db 66
	db 68
	db 93
	db 83
	db 76
	db 0
	db 75
	db 86
	db 49
	db 53
	db 49
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 77
	db 71
	db 84
	db 83
	db 95
	db 71
	db 80
	db 79
	db 78
	db 95
	db 68
	db 68
	db 49
	db 53
	db 0
	db 0
	db 77
	db 71
	db 84
	db 83
	db 95
	db 71
	db 80
	db 79
	db 78
	db 95
	db 57
	db 48
	db 54
	db 57
	db 0
	db 0
	db 65
	db 69
	db 82
	db 79
	db 76
	db 73
	db 78
	db 75
	db 68
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 77
	db 71
	db 84
	db 83
	db 95
	db 71
	db 80
	db 79
	db 78
	db 95
	db 54
	db 52
	db 54
	db 48
	db 0
	db 0
	db 77
	db 84
	db 83
	db 95
	db 71
	db 80
	db 79
	db 78
	db 95
	db 57
	db 51
	db 50
	db 65
	db 70
	db 56
	db 0
	db 77
	db 71
	db 84
	db 83
	db 95
	db 71
	db 80
	db 79
	db 78
	db 95
	db 57
	db 65
	db 54
	db 50
	db 0
	db 0
	db 66
	db 69
	db 69
	db 76
	db 73
	db 78
	db 69
	db 45
	db 82
	db 79
	db 85
	db 84
	db 69
	db 82
	db 69
	db 0
	db 84
	db 79
	db 84
	db 79
	db 82
	db 79
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 80
	db 79
	db 75
	db 69
	db 77
	db 79
	db 78
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 75
	db 69
	db 69
	db 78
	db 69
	db 84
	db 73
	db 67
	db 45
	db 53
	db 53
	db 53
	db 50
	db 0
	db 0
	db 0
	db 75
	db 49
	db 53
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 75
	db 84
	db 49
	db 53
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
; 16 void initI2C() {
initi2c:
; 17     a = 0x81;
	ld a, 129
; 18     VV55_SETUP = a;
	ld (vv55_setup), a
; 19     #ifdef _SLOW_SETTINGS
; 20     NOPS
	nop
	nop
	nop
	nop
	nop
; 21     #endif
; 22     a = 0xC0;
	ld a, 192
; 23     VV55_PORT_C = a;
	ld (vv55_port_c), a
	ret
; 24 }
; 25 
; 26 void startI2C() {
starti2c:
; 27     #ifdef _SLOW_SETTINGS
; 28     NOPS
	nop
	nop
	nop
	nop
	nop
; 29     #endif
; 30     a = 0x40;
	ld a, 64
; 31     VV55_PORT_C = a;
	ld (vv55_port_c), a
; 32     #ifdef _SLOW_SETTINGS
; 33     NOPS
	nop
	nop
	nop
	nop
	nop
; 34     #endif
; 35     nop();
	nop
; 36     a = 0x00;
	ld a, 0
; 37     VV55_PORT_C = a;
	ld (vv55_port_c), a
	ret
; 38 }
; 39 
; 40 void stopI2C() {
stopi2c:
; 41     #ifdef _SLOW_SETTINGS
; 42     NOPS
	nop
	nop
	nop
	nop
	nop
; 43     #endif
; 44     a = 0x40;
	ld a, 64
; 45     VV55_PORT_C = a;
	ld (vv55_port_c), a
; 46     #ifdef _SLOW_SETTINGS
; 47     NOPS
	nop
	nop
	nop
	nop
	nop
; 48     #endif
; 49     nop();
	nop
; 50     a = 0xC0;
	ld a, 192
; 51     VV55_PORT_C = a;
	ld (vv55_port_c), a
	ret
; 52 }
; 53 
; 54 /// вх. [A] - устанавливаемое значение (8 бит)
; 55 void setSDAI2C(){
setsdai2c:
; 56 //    #ifdef _SLOW_SETTINGS
; 57 //    NOPS
; 58 //    #endif
; 59     a &= 0x80;
	and 128
; 60     I2C_CURRETN_VALUE = a;
	ld (i2c_curretn_value), a
; 61     VV55_PORT_C = a;
	ld (vv55_port_c), a
	ret
; 62 }
; 63 
; 64 void pulseNewI2C() {
pulsenewi2c:
; 65     #ifdef _SLOW_SETTINGS
; 66     NOPS
	nop
	nop
	nop
	nop
	nop
; 67     #endif
; 68     a = I2C_CURRETN_VALUE;
	ld a, (i2c_curretn_value)
; 69     a += 0x40;
	add 64
; 70     VV55_PORT_C = a;
	ld (vv55_port_c), a
; 71     #ifdef _SLOW_SETTINGS
; 72     NOPS
	nop
	nop
	nop
	nop
	nop
; 73     #endif
; 74     nop();
	nop
; 75     a = I2C_CURRETN_VALUE;
	ld a, (i2c_curretn_value)
; 76     a += 0x00;
; 77     VV55_PORT_C = a;
	ld (vv55_port_c), a
	ret
; 78 }
; 79 
; 80 /// вх. [C] передаваемый байт
; 81 /// вых.[A]=0 - OK
; 82 void transmitNewI2C() {
transmitnewi2c:
; 83     push_pop(bc) {
	push bc
; 84         b = 8;
	ld b, 8
; 85         do {
l_300:
; 86             setSDAI2C(a = c);
	ld a, c
	call setsdai2c
; 87             pulseNewI2C();
	call pulsenewi2c
; 88             a = c;
	ld a, c
; 89             carry_rotate_left(a, 1);
	rla
; 90             c = a;
	ld c, a
; 91             b--;
	dec b
l_301:
	jp nz, l_300
; 92         } while (flag_nz);
; 93         
; 94         setSDAI2C(a = 0x80);
	ld a, 128
	call setsdai2c
; 95         a = VV55_PORT_C;
	ld a, (vv55_port_c)
; 96         a &= 1;
	and 1
; 97         b = a;
	ld b, a
; 98         setSDAI2C(a = 0x00);
	ld a, 0
	call setsdai2c
; 99         pulseNewI2C();
	call pulsenewi2c
; 100         a = b;
	ld a, b
	pop bc
	ret
; 101     }
; 102 }
; 103 
; 104 /// вых.[C] принятый байт
; 105 /// вых.[B] ACK/NAK
; 106 void recieveNewI2C() {
recievenewi2c:
; 107     //push_pop(bc) {
; 108         setSDAI2C(a = 0x80);
	ld a, 128
	call setsdai2c
; 109         
; 110         bc = 0x0800;
	ld bc, 2048
; 111         do {
l_303:
; 112             a = c;
	ld a, c
; 113             carry_rotate_left(a, 1);
	rla
; 114             c = a;
	ld c, a
; 115             a = VV55_PORT_C; // READ BIT
	ld a, (vv55_port_c)
; 116             a &= 1;
	and 1
; 117             a += c;
	add c
; 118             c = a;
	ld c, a
; 119             pulseNewI2C();
	call pulsenewi2c
; 120             b--;
	dec b
; 121             a = b;
	ld a, b
l_304:
	jp nz, l_303
; 122         } while (flag_nz);
; 123         setSDAI2C(a = 0x80);
	ld a, 128
	call setsdai2c
; 124         a &= 1;
	and 1
; 125         b = a;
	ld b, a
; 126         setSDAI2C(a = 0x00);
	ld a, 0
	call setsdai2c
; 127         pulseNewI2C();
	jp pulsenewi2c
; 128     //}
; 129 }
; 130 
; 131 /// вых.[B] - 1 устройство занято
; 132 void i2cBusy() {
i2cbusy:
; 133     a = VV55_PORT_C;
	ld a, (vv55_port_c)
; 134     a &= 2;
	and 2
; 135     carry_rotate_right(a, 1);
	rra
	ret
; 136 }
; 137 
; 138 /// Ожидание готовности I2C
; 139 void i2cWaitingForAccess() {
i2cwaitingforaccess:
; 140     do {
l_306:
; 141         i2cBusy();
	call i2cbusy
; 142         if (a == 1) {
	cp 1
	jp nz, l_309
; 143             nop();
	nop
; 144             nop();
	nop
; 145             nop();
	nop
; 146             nop();
	nop
; 147             nop();
	nop
l_309:
l_307:
; 148         }
; 149     } while (a == 1);
	cp 1
	jp z, l_306
	ret
; 150 }
; 151 
; 152 void delay5msI2C() {
delay5msi2c:
; 153     push_pop(bc) {
	push bc
; 154         bc = 0x500;
	ld bc, 1280
; 155         do {
l_311:
; 156             bc--;
	dec bc
; 157             a = b;
	ld a, b
; 158             a |= c;
	or c
l_312:
	jp nz, l_311
	pop bc
	ret
; 159         } while (flag_nz);
; 160     }
; 161 }
; 162 
; 163 void busRecoveryI2C() {
busrecoveryi2c:
; 164     startI2C();
	call starti2c
; 165     a = 0;
	ld a, 0
; 166     setSDAI2C();
	call setsdai2c
; 167     pulseNewI2C();
	call pulsenewi2c
; 168     pulseNewI2C();
	call pulsenewi2c
; 169     pulseNewI2C();
	call pulsenewi2c
; 170     pulseNewI2C();
	call pulsenewi2c
; 171     pulseNewI2C();
	call pulsenewi2c
; 172     pulseNewI2C();
	call pulsenewi2c
; 173     pulseNewI2C();
	call pulsenewi2c
; 174     pulseNewI2C();
	call pulsenewi2c
; 175     pulseNewI2C();
	call pulsenewi2c
; 176     stopI2C();
	jp stopi2c
; 11 uint8_t I2C_CURRETN_VALUE = 0x00;
i2c_curretn_value:
	db 0
; 12 uint8_t CHIP_ADDRESS = 0x12;
chip_address:
	db 18
; 14 void sendCommand() {
sendcommand:
; 15     push_pop(de) {
	push de
; 16         d = h;
	ld d, h
; 17         // form the slave address with the R/W bit (R=1, W=0) at LSB
; 18         a ^= a; // XRA     A Carry = 0
	xor a
; 19         a = CHIP_ADDRESS;
	ld a, (chip_address)
; 20         carry_rotate_left(a, 1); // shift address left, set R/W bit to 0 (write)
	rla
; 21         h = a;
	ld h, a
; 22         
; 23         startI2C();
	call starti2c
; 24         c = h;
	ld c, h
; 25         transmitNewI2C(); // Адрес и направление
	call transmitnewi2c
; 26         
; 27         c = l;
	ld c, l
; 28         transmitNewI2C(); // Комманда
	call transmitnewi2c
; 29         
; 30         // Отправляемые данные
; 31         if ((a = d) > 0) {
	ld a, d
	or a
	jp z, l_314
; 32             h = d;
	ld h, d
; 33             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 34             do {
l_316:
; 35                 a = *de;
	ld a, (de)
; 36                 de++;
	inc de
; 37                 c = a;
	ld c, a
; 38                 transmitNewI2C();
	call transmitnewi2c
; 39                 h--;
	dec h
l_317:
	jp nz, l_316
l_314:
; 40             } while(flag_nz);
; 41         }
; 42 
; 43         // Конец отправки
; 44         stopI2C();
	call stopi2c
	pop de
	ret
; 45     }
; 46 }
; 47 
; 48 /// вх. [L] - Кол-во считываемых байт
; 49 void readNewInBuffer() {
readnewinbuffer:
; 50     push_pop(hl) {
	push hl
; 51         push_pop(de) {
	push de
; 52             a ^= a; // XRA
	xor a
; 53             a = CHIP_ADDRESS;
	ld a, (chip_address)
; 54             carry_rotate_left(a, 1);
	rla
; 55             a += 1;
	add 1
; 56             h = a;
	ld h, a
; 57             //
; 58             startI2C();
	call starti2c
; 59             c = h;
	ld c, h
; 60             transmitNewI2C();
	call transmitnewi2c
; 61             
; 62             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 63             
; 64             //l = 20;
; 65             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 66             do {
l_319:
; 67                 push_pop(bc) {
	push bc
; 68                     recieveNewI2C();
	call recievenewi2c
; 69                     a = c;
	ld a, c
	pop bc
; 70                 }
; 71                 *de = a;
	ld (de), a
; 72                 de++;
	inc de
; 73                 l--;
	dec l
; 74                 a = l;
	ld a, l
l_320:
; 75             } while (a > 0);
	or a
	jp nz, l_319
; 76             a = 0; // stop byte
	ld a, 0
; 77             *de = a;
	ld (de), a
; 78             //
; 79             stopI2C();
	call stopi2c
	pop de
	pop hl
	ret
; 80         }
; 81     }
; 82 }
; 83 
; 84 uint8_t ESP_I2S_BUFFER[32];
esp_i2s_buffer:
	ds 32
; 12 void getSSIDList() {
getssidlist:
; 13     // Получить ответ
; 14     // Ответ ESP_I2S_BUFFER
; 15     // SSIDList буфер заполнения
; 16     push_pop(bc) {
	push bc
; 17         do {
l_322:
; 18             //
; 19             delay5msI2C();
	call delay5msi2c
; 20             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 21             l = 5;
	ld l, 5
; 22             h = 0;
	ld h, 0
; 23             sendCommand();
	call sendcommand
; 24             //
; 25             delay5msI2C();
	call delay5msi2c
; 26             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 27             l = 22;
	ld l, 22
; 28             readNewInBuffer();
	call readnewinbuffer
; 29             push_pop(a) {
	push af
; 30                 push_pop(de) {
	push de
; 31                     push_pop(hl) {
	push hl
; 32                         de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 33                         a = *de; // позиция
	ld a, (de)
; 34                         carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 35                         c = a;
	ld c, a
; 36                         // смещаем адрес буфера на 16 * на позицию
; 37                         b = 0;
	ld b, 0
; 38                         hl = SSIDList;
	ld hl, ssidlist
; 39                         hl += bc;
	add hl, bc
; 40                         //
; 41                         de++;
	inc de
; 42                         a = *de; // flag
	ld a, (de)
; 43                         SSIDListNext = a;
	ld (ssidlistnext), a
; 44                         de++;
	inc de
; 45                         // copy 16 byte
; 46                         b = 16;
	ld b, 16
; 47                         do {
l_325:
; 48                             a = *de;
	ld a, (de)
; 49                             *hl = a;
	ld (hl), a
; 50                             de++;
	inc de
; 51                             hl++;
	inc hl
; 52                             b--;
	dec b
l_326:
	jp nz, l_325
	pop hl
	pop de
	pop af
; 53                         } while (flag_nz);
; 54                     }
; 55                 }
; 56             }
; 57             a = SSIDListNext;
	ld a, (ssidlistnext)
l_323:
; 58         } while (a != 0);
	or a
	jp nz, l_322
	pop bc
	ret
; 59     }
; 60 }
; 61 
; 62 /// Получить текущее имя сети
; 63 void getSSIDValue() {
getssidvalue:
; 64     push_pop(hl) {
	push hl
; 65         push_pop(de) {
	push de
; 66             push_pop(bc) {
	push bc
; 67                 delay5msI2C();
	call delay5msi2c
; 68                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 69                 l = 6;
	ld l, 6
; 70                 h = 0;
	ld h, 0
; 71                 sendCommand();
	call sendcommand
; 72                 
; 73                 delay5msI2C();
	call delay5msi2c
; 74                 
; 75                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 76                 l = 26;
	ld l, 26
; 77                 readNewInBuffer();
	call readnewinbuffer
; 78                 
; 79                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 80                 hl = wifiSettingsSsidVal;
	ld hl, wifisettingsssidval
; 81                 b = 16;
	ld b, 16
; 82                 do {
l_328:
; 83                     a = *de;
	ld a, (de)
; 84                     *hl = a;
	ld (hl), a
; 85                     de++;
	inc de
; 86                     hl++;
	inc hl
; 87                     b--;
	dec b
l_329:
	jp nz, l_328
	pop bc
	pop de
	pop hl
	ret
; 88                 } while (flag_nz);
; 89             }
; 90         }
; 91     }
; 92 }
; 93 
; 94 /// Получить пароль wifi
; 95 void getSSIDPasswordValue() {
getssidpasswordvalue:
; 96     push_pop(hl) {
	push hl
; 97         push_pop(de) {
	push de
; 98             push_pop(bc) {
	push bc
; 99                 delay5msI2C();
	call delay5msi2c
; 100                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 101                 l = 8;
	ld l, 8
; 102                 h = 0;
	ld h, 0
; 103                 sendCommand();
	call sendcommand
; 104                 
; 105                 delay5msI2C();
	call delay5msi2c
; 106                 
; 107                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 108                 l = 26;
	ld l, 26
; 109                 readNewInBuffer();
	call readnewinbuffer
; 110                 
; 111                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 112                 hl = wifiSettingsEditViewSSIDPasswordVal;
	ld hl, wifisettingseditviewssidpassword_3
; 113                 b = 16;
	ld b, 16
; 114                 do {
l_331:
; 115                     a = *de;
	ld a, (de)
; 116                     if(a==0xFF){
	cp 255
	jp nz, l_334
; 117                         a = 0x00;
	ld a, 0
l_334:
; 118                     }
; 119                     *hl = a;
	ld (hl), a
; 120                     de++;
	inc de
; 121                     hl++;
	inc hl
; 122                     b--;
	dec b
l_332:
	jp nz, l_331
	pop bc
	pop de
	pop hl
	ret
; 123                 } while (flag_nz);
; 124             }
; 125         }
; 126     }
; 127 }
; 128 
; 129 /// Отправить пароль wifi
; 130 void setSSIDPasswordValue() {
setssidpasswordvalue:
; 131     push_pop(hl) {
	push hl
; 132         push_pop(de) {
	push de
; 133             push_pop(bc) {
	push bc
; 134                 de = wifiSettingsEditViewSSIDPasswordVal;
	ld de, wifisettingseditviewssidpassword_3
; 135                 hl = ESP_I2S_BUFFER;
	ld hl, esp_i2s_buffer
; 136                 b = 16;
	ld b, 16
; 137                 c = 0;
	ld c, 0
; 138                 do {
l_336:
; 139                     a = *de;
	ld a, (de)
; 140                     if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_339
; 141                         a = 0xFF;
	ld a, 255
	jp l_340
l_339:
; 142                     } else if((a = *de) == 0) {
	ld a, (de)
	or a
	jp nz, l_341
; 143                         c = 1;
	ld c, 1
; 144                         a = 0x00;
	ld a, 0
l_341:
l_340:
; 145                     }
; 146                     *hl = a;
	ld (hl), a
; 147                     de++;
	inc de
; 148                     hl++;
	inc hl
; 149                     b--;
	dec b
l_337:
	jp nz, l_336
; 150                 } while (flag_nz);
; 151                 
; 152                 delay5msI2C();
	call delay5msi2c
; 153                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 154                 l = 9;
	ld l, 9
; 155                 h = 16;
	ld h, 16
; 156                 sendCommand();
	call sendcommand
	pop bc
	pop de
	pop hl
	ret
; 157             }
; 158         }
; 159     }
; 160 }
; 161 
; 162 /// Подключиться в WiFi
; 163 void needSsidConnect() {
needssidconnect:
; 164     push_pop(hl) {
	push hl
; 165         delay5msI2C();
	call delay5msi2c
; 166         i2cWaitingForAccess();
	call i2cwaitingforaccess
; 167         l = 10;
	ld l, 10
; 168         h = 0;
	ld h, 0
; 169         sendCommand();
	call sendcommand
	pop hl
	ret
; 170     }
; 171 }
; 172 
; 173 /// Запросить обновление списка сетей
; 174 void needUpdateSSIDList() {
needupdatessidlist:
; 175     push_pop(hl) {
	push hl
; 176         delay5msI2C();
	call delay5msi2c
; 177         i2cWaitingForAccess();
	call i2cwaitingforaccess
; 178         l = 4;
	ld l, 4
; 179         h = 0;
	ld h, 0
; 180         sendCommand();
	call sendcommand
	pop hl
	ret
; 181     }
; 182 }
; 183 
; 184 /// Установить имя сети по номеру в списке
; 185 /// вх. [A] - номер сети
; 186 void setSSIDNumberA() {
setssidnumbera:
; 187     push_pop(de) {
	push de
; 188         push_pop(hl) {
	push hl
; 189             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 190             *de = a;
	ld (de), a
; 191             //
; 192             delay5msI2C();
	call delay5msi2c
; 193             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 194             //
; 195             l = 7; // SET_SSID
	ld l, 7
; 196             h = 1; // 1 байт
	ld h, 1
; 197             sendCommand();
	call sendcommand
	pop hl
	pop de
	ret
; 198         }
; 199     }
; 200 }
; 201 
; 202 /// Получить IP_Address
; 203 void getSSIDIPAddress() {
getssidipaddress:
; 204     push_pop(hl) {
	push hl
; 205         push_pop(de) {
	push de
; 206             push_pop(bc) {
	push bc
; 207                 delay5msI2C();
	call delay5msi2c
; 208                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 209                 l = 12;
	ld l, 12
; 210                 h = 0;
	ld h, 0
; 211                 sendCommand();
	call sendcommand
; 212                 //
; 213                 delay5msI2C();
	call delay5msi2c
; 214                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 215                 l = 26;
	ld l, 26
; 216                 readNewInBuffer();
	call readnewinbuffer
; 217                 //
; 218                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 219                 hl = wifiSettingsIpVal;
	ld hl, wifisettingsipval
; 220                 b = 16;
	ld b, 16
; 221                 do {
l_343:
; 222                     a = *de;
	ld a, (de)
; 223                     if(a==0xFF){
	cp 255
	jp nz, l_346
; 224                         a = 0x00;
	ld a, 0
l_346:
; 225                     }
; 226                     *hl = a;
	ld (hl), a
; 227                     de++;
	inc de
; 228                     hl++;
	inc hl
; 229                     b--;
	dec b
l_344:
	jp nz, l_343
	pop bc
	pop de
	pop hl
	ret
; 230                 } while (flag_nz);
; 231             }
; 232         }
; 233     }
; 234 }
; 235 
; 236 /// Получить MAC_Address
; 237 void getSSIDMacAddress() {
getssidmacaddress:
; 238     push_pop(hl) {
	push hl
; 239         push_pop(de) {
	push de
; 240             push_pop(bc) {
	push bc
; 241                 delay5msI2C();
	call delay5msi2c
; 242                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 243                 l = 13;
	ld l, 13
; 244                 h = 0;
	ld h, 0
; 245                 sendCommand();
	call sendcommand
; 246                 //
; 247                 delay5msI2C();
	call delay5msi2c
; 248                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 249                 l = 26;
	ld l, 26
; 250                 readNewInBuffer();
	call readnewinbuffer
; 251                 //
; 252                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 253                 hl = wifiSettingsMacVal;
	ld hl, wifisettingsmacval
; 254                 b = 18;
	ld b, 18
; 255                 do {
l_348:
; 256                     a = *de;
	ld a, (de)
; 257                     if(a==0xFF){
	cp 255
	jp nz, l_351
; 258                         a = 0x00;
	ld a, 0
l_351:
; 259                     }
; 260                     *hl = a;
	ld (hl), a
; 261                     de++;
	inc de
; 262                     hl++;
	inc hl
; 263                     b--;
	dec b
l_349:
	jp nz, l_348
	pop bc
	pop de
	pop hl
	ret
; 264                 } while (flag_nz);
; 265             }
; 266         }
; 267     }
; 268 }
; 269 
; 270 /// Получить STATE_SSID
; 271 void getSSIDState() {
getssidstate:
; 272     push_pop(hl) {
	push hl
; 273         push_pop(de) {
	push de
; 274             push_pop(bc) {
	push bc
; 275                 delay5msI2C();
	call delay5msi2c
; 276                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 277                 l = 11;
	ld l, 11
; 278                 h = 0;
	ld h, 0
; 279                 sendCommand();
	call sendcommand
; 280                 //
; 281                 delay5msI2C();
	call delay5msi2c
; 282                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 283                 l = 4;
	ld l, 4
; 284                 readNewInBuffer();
	call readnewinbuffer
; 285                 //
; 286                 a = WiFiState;
	ld a, (wifistate)
; 287                 h = a;
	ld h, a
; 288                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 289                 a = *de;
	ld a, (de)
; 290                 a &= 0x01;
	and 1
; 291                 WiFiState = a;
	ld (wifistate), a
; 292                 if(a != h){
	cp h
	jp z, l_353
; 293                     a = 0x01;
	ld a, 1
; 294                     WiFiStateUpdate = a;
	ld (wifistateupdate), a
l_353:
	pop bc
	pop de
	pop hl
	ret
; 295                 }
; 296             }
; 297         }
; 298     }
; 299 }
; 300 
; 301 /// FTP
; 302 
; 303 /// Получить FTP URL
; 304 void getFTPUrl() {
getftpurl:
; 305     push_pop(hl) {
	push hl
; 306         push_pop(de) {
	push de
; 307             push_pop(bc) {
	push bc
; 308                 delay5msI2C();
	call delay5msi2c
; 309                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 310                 l = 2;
	ld l, 2
; 311                 h = 0;
	ld h, 0
; 312                 sendCommand();
	call sendcommand
; 313                 //
; 314                 delay5msI2C();
	call delay5msi2c
; 315                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 316                 l = 26;
	ld l, 26
; 317                 readNewInBuffer();
	call readnewinbuffer
; 318                 //
; 319                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 320                 hl = ftpSettingsIpValue;
	ld hl, ftpsettingsipvalue
; 321                 b = 16;
	ld b, 16
; 322                 do {
l_355:
; 323                     a = *de;
	ld a, (de)
; 324                     if(a==0xFF){
	cp 255
	jp nz, l_358
; 325                         a = 0x00;
	ld a, 0
l_358:
; 326                     }
; 327                     *hl = a;
	ld (hl), a
; 328                     de++;
	inc de
; 329                     hl++;
	inc hl
; 330                     b--;
	dec b
l_356:
	jp nz, l_355
	pop bc
	pop de
	pop hl
	ret
; 331                 } while (flag_nz);
; 332             }
; 333         }
; 334     }
; 335 }
; 336 
; 337 /// Отправить FTP URL
; 338 void setFTPUrl() {
setftpurl:
; 339     push_pop(hl) {
	push hl
; 340         push_pop(de) {
	push de
; 341             push_pop(bc) {
	push bc
; 342                 de = ftpSettingsIpValue;
	ld de, ftpsettingsipvalue
; 343                 hl = ESP_I2S_BUFFER;
	ld hl, esp_i2s_buffer
; 344                 b = 16;
	ld b, 16
; 345                 c = 0;
	ld c, 0
; 346                 do {
l_360:
; 347                     a = *de;
	ld a, (de)
; 348                     if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_363
; 349                         a = 0xFF;
	ld a, 255
	jp l_364
l_363:
; 350                     } else if((a = *de) == 0) {
	ld a, (de)
	or a
	jp nz, l_365
; 351                         c = 1;
	ld c, 1
; 352                         a = 0x00;
	ld a, 0
l_365:
l_364:
; 353                     }
; 354                     *hl = a;
	ld (hl), a
; 355                     de++;
	inc de
; 356                     hl++;
	inc hl
; 357                     b--;
	dec b
l_361:
	jp nz, l_360
; 358                 } while (flag_nz);
; 359                 
; 360                 delay5msI2C();
	call delay5msi2c
; 361                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 362                 l = 3;
	ld l, 3
; 363                 h = 16;
	ld h, 16
; 364                 sendCommand();
	call sendcommand
	pop bc
	pop de
	pop hl
	ret
; 365             }
; 366         }
; 367     }
; 368 }
; 369 
; 370 /// Получить FTP User
; 371 void getFTPUser() {
getftpuser:
; 372     push_pop(hl) {
	push hl
; 373         push_pop(de) {
	push de
; 374             push_pop(bc) {
	push bc
; 375                 delay5msI2C();
	call delay5msi2c
; 376                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 377                 l = 18;
	ld l, 18
; 378                 h = 0;
	ld h, 0
; 379                 sendCommand();
	call sendcommand
; 380                 //
; 381                 delay5msI2C();
	call delay5msi2c
; 382                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 383                 l = 26;
	ld l, 26
; 384                 readNewInBuffer();
	call readnewinbuffer
; 385                 //
; 386                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 387                 hl = ftpSettingsUserValue;
	ld hl, ftpsettingsuservalue
; 388                 b = 16;
	ld b, 16
; 389                 do {
l_367:
; 390                     a = *de;
	ld a, (de)
; 391                     if(a==0xFF){
	cp 255
	jp nz, l_370
; 392                         a = 0x00;
	ld a, 0
l_370:
; 393                     }
; 394                     *hl = a;
	ld (hl), a
; 395                     de++;
	inc de
; 396                     hl++;
	inc hl
; 397                     b--;
	dec b
l_368:
	jp nz, l_367
	pop bc
	pop de
	pop hl
	ret
; 398                 } while (flag_nz);
; 399             }
; 400         }
; 401     }
; 402 }
; 403 
; 404 /// Отправить FTP User
; 405 void setFTPUser() {
setftpuser:
; 406     push_pop(hl) {
	push hl
; 407         push_pop(de) {
	push de
; 408             push_pop(bc) {
	push bc
; 409                 de = ftpSettingsUserValue;
	ld de, ftpsettingsuservalue
; 410                 hl = ESP_I2S_BUFFER;
	ld hl, esp_i2s_buffer
; 411                 b = 16;
	ld b, 16
; 412                 c = 0;
	ld c, 0
; 413                 do {
l_372:
; 414                     a = *de;
	ld a, (de)
; 415                     if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_375
; 416                         a = 0xFF;
	ld a, 255
	jp l_376
l_375:
; 417                     } else if((a = *de) == 0) {
	ld a, (de)
	or a
	jp nz, l_377
; 418                         c = 1;
	ld c, 1
; 419                         a = 0x00;
	ld a, 0
l_377:
l_376:
; 420                     }
; 421                     *hl = a;
	ld (hl), a
; 422                     de++;
	inc de
; 423                     hl++;
	inc hl
; 424                     b--;
	dec b
l_373:
	jp nz, l_372
; 425                 } while (flag_nz);
; 426                 
; 427                 delay5msI2C();
	call delay5msi2c
; 428                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 429                 l = 19;
	ld l, 19
; 430                 h = 16;
	ld h, 16
; 431                 sendCommand();
	call sendcommand
	pop bc
	pop de
	pop hl
	ret
; 432             }
; 433         }
; 434     }
; 435 }
; 436 
; 437 /// Получить FTP Password
; 438 void getFTPPassword() {
getftppassword:
; 439     push_pop(hl) {
	push hl
; 440         push_pop(de) {
	push de
; 441             push_pop(bc) {
	push bc
; 442                 delay5msI2C();
	call delay5msi2c
; 443                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 444                 l = 20;
	ld l, 20
; 445                 h = 0;
	ld h, 0
; 446                 sendCommand();
	call sendcommand
; 447                 //
; 448                 delay5msI2C();
	call delay5msi2c
; 449                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 450                 l = 26;
	ld l, 26
; 451                 readNewInBuffer();
	call readnewinbuffer
; 452                 //
; 453                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 454                 hl = ftpSettingsEditViewPasswordVal;
	ld hl, ftpsettingseditviewpasswordval
; 455                 b = 16;
	ld b, 16
; 456                 do {
l_379:
; 457                     a = *de;
	ld a, (de)
; 458                     if(a==0xFF){
	cp 255
	jp nz, l_382
; 459                         a = 0x00;
	ld a, 0
l_382:
; 460                     }
; 461                     *hl = a;
	ld (hl), a
; 462                     de++;
	inc de
; 463                     hl++;
	inc hl
; 464                     b--;
	dec b
l_380:
	jp nz, l_379
	pop bc
	pop de
	pop hl
	ret
; 465                 } while (flag_nz);
; 466             }
; 467         }
; 468     }
; 469 }
; 470 
; 471 /// Отправить FTP Password
; 472 void setFTPPassword() {
setftppassword:
; 473     push_pop(hl) {
	push hl
; 474         push_pop(de) {
	push de
; 475             push_pop(bc) {
	push bc
; 476                 de = ftpSettingsEditViewPasswordVal;
	ld de, ftpsettingseditviewpasswordval
; 477                 hl = ESP_I2S_BUFFER;
	ld hl, esp_i2s_buffer
; 478                 b = 16;
	ld b, 16
; 479                 c = 0;
	ld c, 0
; 480                 do {
l_384:
; 481                     a = *de;
	ld a, (de)
; 482                     if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_387
; 483                         a = 0xFF;
	ld a, 255
	jp l_388
l_387:
; 484                     } else if((a = *de) == 0) {
	ld a, (de)
	or a
	jp nz, l_389
; 485                         c = 1;
	ld c, 1
; 486                         a = 0x00;
	ld a, 0
l_389:
l_388:
; 487                     }
; 488                     *hl = a;
	ld (hl), a
; 489                     de++;
	inc de
; 490                     hl++;
	inc hl
; 491                     b--;
	dec b
l_385:
	jp nz, l_384
; 492                 } while (flag_nz);
; 493                 
; 494                 delay5msI2C();
	call delay5msi2c
; 495                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 496                 l = 21;
	ld l, 21
; 497                 h = 16;
	ld h, 16
; 498                 sendCommand();
	call sendcommand
	pop bc
	pop de
	pop hl
	ret
; 499             }
; 500         }
; 501     }
; 502 }
; 503 
; 504 /// Получить FTP Port
; 505 void getFTPPort() {
getftpport:
; 506     push_pop(hl) {
	push hl
; 507         push_pop(de) {
	push de
; 508             push_pop(bc) {
	push bc
; 509                 delay5msI2C();
	call delay5msi2c
; 510                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 511                 l = 16;
	ld l, 16
; 512                 h = 0;
	ld h, 0
; 513                 sendCommand();
	call sendcommand
; 514                 //
; 515                 delay5msI2C();
	call delay5msi2c
; 516                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 517                 l = 10;
	ld l, 10
; 518                 readNewInBuffer();
	call readnewinbuffer
; 519                 //
; 520                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 521                 hl = ftpSettingsPortValue;
	ld hl, ftpsettingsportvalue
; 522                 b = 6;
	ld b, 6
; 523                 do {
l_391:
; 524                     a = *de;
	ld a, (de)
; 525                     if(a==0xFF){
	cp 255
	jp nz, l_394
; 526                         a = 0x00;
	ld a, 0
l_394:
; 527                     }
; 528                     *hl = a;
	ld (hl), a
; 529                     de++;
	inc de
; 530                     hl++;
	inc hl
; 531                     b--;
	dec b
l_392:
	jp nz, l_391
	pop bc
	pop de
	pop hl
	ret
; 532                 } while (flag_nz);
; 533             }
; 534         }
; 535     }
; 536 }
; 537 
; 538 /// Отправить FTP Port
; 539 void setFTPPort() {
setftpport:
; 540     push_pop(hl) {
	push hl
; 541         push_pop(de) {
	push de
; 542             push_pop(bc) {
	push bc
; 543                 de = ftpSettingsPortValue;
	ld de, ftpsettingsportvalue
; 544                 hl = ESP_I2S_BUFFER;
	ld hl, esp_i2s_buffer
; 545                 b = 6;
	ld b, 6
; 546                 c = 0;
	ld c, 0
; 547                 do {
l_396:
; 548                     a = *de;
	ld a, (de)
; 549                     if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_399
; 550                         a = 0xFF;
	ld a, 255
	jp l_400
l_399:
; 551                     } else if((a = *de) == 0) {
	ld a, (de)
	or a
	jp nz, l_401
; 552                         c = 1;
	ld c, 1
; 553                         a = 0x00;
	ld a, 0
l_401:
l_400:
; 554                     }
; 555                     *hl = a;
	ld (hl), a
; 556                     de++;
	inc de
; 557                     hl++;
	inc hl
; 558                     b--;
	dec b
l_397:
	jp nz, l_396
; 559                 } while (flag_nz);
; 560                 
; 561                 delay5msI2C();
	call delay5msi2c
; 562                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 563                 l = 17;
	ld l, 17
; 564                 h = 6;
	ld h, 6
; 565                 sendCommand();
	call sendcommand
	pop bc
	pop de
	pop hl
	ret
; 566             }
; 567         }
; 568     }
; 569 }
; 570 
; 571 /// Подключиться в FTP
; 572 void needFtpConnect() {
needftpconnect:
; 573     push_pop(hl) {
	push hl
; 574         delay5msI2C();
	call delay5msi2c
; 575         i2cWaitingForAccess();
	call i2cwaitingforaccess
; 576         l = 23;
	ld l, 23
; 577         h = 0;
	ld h, 0
; 578         sendCommand();
	call sendcommand
	pop hl
	ret
; 579     }
; 580 }
; 581 
; 582 /// Получить статус FTP
; 583 void getFtpState() {
getftpstate:
; 584     push_pop(hl) {
	push hl
; 585         push_pop(de) {
	push de
; 586             push_pop(bc) {
	push bc
; 587                 delay5msI2C();
	call delay5msi2c
; 588                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 589                 l = 24;
	ld l, 24
; 590                 h = 0;
	ld h, 0
; 591                 sendCommand();
	call sendcommand
; 592                 //
; 593                 delay5msI2C();
	call delay5msi2c
; 594                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 595                 l = 4;
	ld l, 4
; 596                 readNewInBuffer();
	call readnewinbuffer
; 597                 //
; 598                 a = ftpSettingsStateVal;
	ld a, (ftpsettingsstateval)
; 599                 h = a;
	ld h, a
; 600                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 601                 a = *de;
	ld a, (de)
; 602                 a &= 0x01;
	and 1
; 603                 ftpSettingsStateVal = a;
	ld (ftpsettingsstateval), a
; 604                 if(a != h){
	cp h
	jp z, l_403
; 605                     a = 0x01;
	ld a, 1
; 606                     ftpSettingsStateChange = a;
	ld (ftpsettingsstatechange), a
l_403:
	pop bc
	pop de
	pop hl
	ret
; 607                 }
; 608             }
; 609         }
; 610     }
; 611 }
; 612 
; 613 /// обновить сисок FTP файлов
; 614 void updateFtpList() {
updateftplist:
; 615     push_pop(hl) {
	push hl
; 616         a = 0;
	ld a, 0
; 617         ftpDirListCount = a;
	ld (ftpdirlistcount), a
; 618         delay5msI2C();
	call delay5msi2c
; 619         i2cWaitingForAccess();
	call i2cwaitingforaccess
; 620         l = 25;
	ld l, 25
; 621         h = 0;
	ld h, 0
; 622         sendCommand();
	call sendcommand
	pop hl
	ret
; 623     }
; 624 }
; 625 
; 626 void convert4bitToCharA() {
convert4bittochara:
; 627     if (a < 10) {
	cp 10
	jp nc, l_405
; 628         a += 0x30;
	add 48
	jp l_406
l_405:
; 629     } else {
; 630         a += 0x37;
	add 55
l_406:
	ret
; 631     }
; 632 }
; 633 
; 634 /// Получаем список файлов и директорий в текущей папке
; 635 void getFtpList() {
getftplist:
; 636     // Получить ответ
; 637     // Ответ ESP_I2S_BUFFER
; 638     // ftpDirList буфер заполнения
; 639     push_pop(bc) {
	push bc
; 640         do {
l_407:
; 641             //
; 642             delay5msI2C();
	call delay5msi2c
; 643             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 644             l = 26;
	ld l, 26
; 645             h = 0;
	ld h, 0
; 646             sendCommand();
	call sendcommand
; 647             //
; 648             delay5msI2C();
	call delay5msi2c
; 649             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 650             l = 26;
	ld l, 26
; 651             readNewInBuffer();
	call readnewinbuffer
; 652             push_pop(a) {
	push af
; 653                 push_pop(de) {
	push de
; 654                     push_pop(hl) {
	push hl
; 655                         parceBufferToFile();
	call parcebuffertofile
	pop hl
	pop de
	pop af
; 656                     }
; 657                 }
; 658             }
; 659             a = ftpDirListNext;
	ld a, (ftpdirlistnext)
l_408:
; 660         } while (a == 1);
	cp 1
	jp z, l_407
	pop bc
	ret
; 661     }
; 662 }
; 663 
; 664 /// Указать какой файл скачивать
; 665 void ftpFileDownload() {
ftpfiledownload:
; 666     push_pop(de) {
	push de
; 667         push_pop(hl) {
	push hl
; 668             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 669             a = ftpViewCurrentPos;
	ld a, (ftpviewcurrentpos)
; 670             *de = a;
	ld (de), a
; 671             //
; 672             delay5msI2C();
	call delay5msi2c
; 673             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 674             //
; 675             l = 28; // FILE_DOWNLOAD
	ld l, 28
; 676             h = 1; // 1 байт
	ld h, 1
; 677             sendCommand();
	call sendcommand
	pop hl
	pop de
	ret
; 678         }
; 679     }
; 680 }
; 681 
; 682 /// Скачать указанный файл
; 683 void ftpFileDownloadNext() {
ftpfiledownloadnext:
; 684     push_pop(hl) {
	push hl
; 685         a = 0x01;
	ld a, 1
; 686         ftpFileLoadViewCheckSumState = a;
	ld (ftpfileloadviewchecksumstate), a
; 687         do {
l_410:
; 688             // Если контрольная сумма верна просим следующий буфер
; 689             if ((a = ftpFileLoadViewCheckSumState) == 0x01) {
	ld a, (ftpfileloadviewchecksumstate)
	cp 1
	jp nz, l_413
; 690                 delay5msI2C();
	call delay5msi2c
; 691                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 692                 l = 29;
	ld l, 29
; 693                 h = 0;
	ld h, 0
; 694                 sendCommand();
	call sendcommand
l_413:
; 695             }
; 696             
; 697             // Получить буфер
; 698             delay5msI2C();
	call delay5msi2c
; 699             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 700             l = 30;
	ld l, 30
; 701             h = 0;
	ld h, 0
; 702             sendCommand();
	call sendcommand
; 703             //
; 704             delay5msI2C();
	call delay5msi2c
; 705             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 706             l = 15; //(12) //26; (20)
	ld l, 15
; 707             readNewInBuffer();
	call readnewinbuffer
; 708             
; 709             // Распарсить буфер и пррверить контрольную сумму
; 710             ftpFileLoadViewParce();
	call ftpfileloadviewparce
l_411:
; 711             
; 712         } while ((a = ftpFileLoadViewIsNextData) == 1);
	ld a, (ftpfileloadviewisnextdata)
	cp 1
	jp z, l_410
	pop hl
	ret
; 11 void needUpdateFtpList() {
needupdateftplist:
; 12     i2cWaitingForAccess();
	call i2cwaitingforaccess
; 13     updateFtpList();
	call updateftplist
; 14     i2cWaitingForAccess();
	call i2cwaitingforaccess
; 15     getFtpList();
	call getftplist
; 16     
; 17     a = ftpDirListCount;
	ld a, (ftpdirlistcount)
; 18     if (a >= 16) {
	cp 16
	jp c, l_415
; 19         a = 16;
	ld a, 16
; 20         ftpDirListCount = a;
	ld (ftpdirlistcount), a
l_415:
; 21     }
; 22     
; 23     a = 0;
	ld a, 0
; 24     ftpViewCurrentPos = a;
	ld (ftpviewcurrentpos), a
; 25     
; 26     // clearView();
; 27     ftpViewDataUpdate();
	jp ftpviewdataupdate
; 28 }
; 29 
; 30 void clearView() {
clearview:
; 31     push_pop(hl) {
	push hl
; 32         push_pop(bc) {
	push bc
; 33             b = 14;
	ld b, 14
; 34             c = 0;
	ld c, 0
; 35             do {
l_417:
; 36                 ftpViewPosCursorC();
	call ftpviewposcursorc
; 37                 hl = wifiSettingsEmpty18;
	ld hl, wifisettingsempty18
; 38                 printHLStr();
	call printhlstr
; 39                 b--;
	dec b
; 40                 c++;
	inc c
l_418:
	jp nz, l_417
	pop bc
	pop hl
	ret
; 41             } while (flag_nz);
; 42         }
; 43     }
; 44 }
; 45 
; 46 void ftpViewDataUpdate() {
ftpviewdataupdate:
; 47     push_pop(bc) {
	push bc
; 48         b = 0;
	ld b, 0
; 49         do {
l_420:
; 50             a = 0x00;
	ld a, 0
; 51             inverceAddress = a;
	ld (inverceaddress), a
; 52             
; 53             if ((a = rootViewCurrentView) == rootViewCurrentFTPView) {
	ld a, (rootviewcurrentview)
	cp 1
	jp nz, l_423
; 54                 if ((a = ftpViewCurrentPos) == b) {
	ld a, (ftpviewcurrentpos)
	cp b
	jp nz, l_425
; 55                     a = 0xFF;
	ld a, 255
; 56                     inverceAddress = a;
	ld (inverceaddress), a
l_425:
l_423:
; 57                 }
; 58             }
; 59             
; 60             a = b;
	ld a, b
; 61             ftpViewShowValueA();
	call ftpviewshowvaluea
; 62             
; 63             a = 0x00;
	ld a, 0
; 64             inverceAddress = a;
	ld (inverceaddress), a
; 65             
; 66             b++;
	inc b
; 67             //a = ftpDirListCount;
; 68             //a++;
; 69             a = b;
	ld a, b
l_421:
; 70         } while (a < 14);
	cp 14
	jp c, l_420
	pop bc
	ret
; 71     }
; 72 }
; 73 
; 74 void ftpViewShowValueA() {
ftpviewshowvaluea:
; 75     push_pop(hl) {
	push hl
; 76         push_pop(de) {
	push de
; 77             push_pop(bc) {
	push bc
; 78                 de = 16;
	ld de, 16
; 79                 c = a;
	ld c, a
; 80                 ftpViewPosCursorC();
	call ftpviewposcursorc
; 81                 hl = ftpDirList;
	ld hl, ftpdirlist
; 82                 if ((a = c) > 0) {
	ld a, c
	or a
	jp z, l_427
; 83                     do {
l_429:
; 84                         hl += de;
	add hl, de
; 85                         c--;
	dec c
l_430:
	jp nz, l_429
l_427:
; 86                     } while (flag_nz);
; 87                 }
; 88                 //hl = ftpLabel;
; 89                 printHLStr();
	call printhlstr
	pop bc
	pop de
	pop hl
	ret
; 90             }
; 91         }
; 92     }
; 93 }
; 94 
; 95 void ftpViewPosCursorC() {
ftpviewposcursorc:
; 96     push_pop(hl) {
	push hl
; 97         a = ftpViewY;
	ld a, (ftpviewy)
; 98         a += 1;
	add 1
; 99         a += c;
	add c
; 100         h = a;
	ld h, a
; 101         a = ftpViewX;
	ld a, (ftpviewx)
; 102         a += 3;
	add 3
; 103         l = a;
	ld l, a
; 104         setPosCursor();
	call setposcursor
	pop hl
	ret
; 105     }
; 106 }
; 107 
; 108 void ftpViewKeyA() {
ftpviewkeya:
; 109     push_pop(hl) {
	push hl
; 110         l = a;
	ld l, a
; 111         if ((a = rootViewCurrentView) == rootViewCurrentFTPView) {
	ld a, (rootviewcurrentview)
	cp 1
	jp nz, l_432
; 112             a = l;
	ld a, l
; 113             if (a == 0x09) { // TAB - Change to local disk
	cp 9
	jp nz, l_434
; 114                 a = rootViewCurrentDiskView; // переходим на список файлов на диске
	ld a, 0
; 115                 rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 116                 ftpViewDataUpdate();
	call ftpviewdataupdate
; 117                 showDiskList();
	call showdisklist
	jp l_435
l_434:
; 118             } else {
; 119                 a = ftpDirListCount;
	ld a, (ftpdirlistcount)
; 120                 h = a;
	ld h, a
; 121                 a = l;
	ld a, l
; 122                 if (a == 0x1A) { //down
	cp 26
	jp nz, l_436
; 123                     a = ftpViewCurrentPos;
	ld a, (ftpviewcurrentpos)
; 124                     a++;
	inc a
; 125                     if (a == h) {
	cp h
	jp nz, l_438
; 126                         a = 0;
	ld a, 0
l_438:
; 127                     }
; 128                     ftpViewCurrentPos = a;
	ld (ftpviewcurrentpos), a
	jp l_437
l_436:
; 129                 } else if (a == 0x19) { //up
	cp 25
	jp nz, l_440
; 130                     a = ftpViewCurrentPos;
	ld a, (ftpviewcurrentpos)
; 131                     if (a == 0) {
	or a
	jp nz, l_442
; 132                         a = h;
	ld a, h
; 133                         a--;
	dec a
	jp l_443
l_442:
; 134                     } else {
; 135                         a--;
	dec a
l_443:
; 136                     }
; 137                     ftpViewCurrentPos = a;
	ld (ftpviewcurrentpos), a
	jp l_441
l_440:
; 138                 } else if (a == 0x0D) { //Enter
	cp 13
	jp nz, l_444
; 139                     ftpViewCurrentPosIsDir();
	call ftpviewcurrentposisdir
; 140                     if ((a = ftpDirListIsDir) == 1) {
	ld a, (ftpdirlistisdir)
	cp 1
	jp nz, l_446
; 141                         if ((a = ftpViewCurrentPos) == 0) {
	ld a, (ftpviewcurrentpos)
	or a
	jp nz, l_448
	jp l_449
l_448:
; 142                             // DirUp
; 143                         } else {
l_449:
	jp l_447
l_446:
; 144                             // Dir enter
; 145                         }
; 146                     } else {
; 147                         showFtpFileLoadView();
	call showftpfileloadview
; 148                         ftpFileLoadViewNeedLoad();
	call ftpfileloadviewneedload
l_447:
	jp l_445
l_444:
; 149                     }
; 150                 } else if (a == 0x34) { // C (COPY)
	cp 52
	jp nz, l_450
; 151                     ftpViewCurrentPosIsDir();
	call ftpviewcurrentposisdir
; 152                     if ((a = ftpDirListIsDir) == 0) {
	ld a, (ftpdirlistisdir)
	or a
	jp nz, l_452
; 153                         showFtpFileLoadView();
	call showftpfileloadview
; 154                         ftpFileLoadViewNeedLoad();
	call ftpfileloadviewneedload
l_452:
	jp l_451
l_450:
; 155                     }
; 156                 } else if (a == 'R') { // R (Refresh)
	cp 82
	jp nz, l_454
; 157                     needUpdateFtpList();
	call needupdateftplist
l_454:
l_451:
l_445:
l_441:
l_437:
l_435:
l_432:
	pop hl
	ret
; 158                 }
; 159             }
; 160         }
; 161     }
; 162 }
; 163 
; 164 /// from ESP_I2S_BUFFER
; 165 /// to ftpDirList
; 166 /// count ftpDirListCount
; 167 /// next ftpDirListNext
; 168 void parceBufferToFile() {
parcebuffertofile:
; 169     de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 170     // (0) - порядковый номер Должен быть == ftpDirListCount + 1
; 171     a = ftpDirListCount;
	ld a, (ftpdirlistcount)
; 172     b = a;
	ld b, a
; 173     a = *de;
	ld a, (de)
; 174     if (a != b) {
	cp b
	jp z, l_456
; 175         a = 0;
	ld a, 0
; 176         ftpDirListNext = a;
	ld (ftpdirlistnext), a
; 177         return;
	ret
l_456:
; 178     }
; 179     hl = ftpDirList;
	ld hl, ftpdirlist
; 180     b = 0;
	ld b, 0
; 181     carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 182     if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, l_458
; 183         b++;
	inc b
l_458:
; 184     }
; 185     c = a;
	ld c, a
; 186     hl += bc; // ftpDirList + смещение
	add hl, bc
; 187     a = ftpDirListCount;
	ld a, (ftpdirlistcount)
; 188     a ++;
	inc a
; 189     ftpDirListCount = a;
	ld (ftpdirlistcount), a
; 190     // (1) - Флаг окончания пакета. Если 1 - то продолжаем. Любой другой - СТОП!
; 191     de++;
	inc de
; 192     a = *de;
	ld a, (de)
; 193     if (a == 0x01) {
	cp 1
	jp nz, l_460
; 194         a = 1;
	ld a, 1
; 195         ftpDirListNext = a;
	ld (ftpdirlistnext), a
	jp l_461
l_460:
; 196     } else {
; 197         a = 0;
	ld a, 0
; 198         ftpDirListNext = a;
	ld (ftpdirlistnext), a
; 199         return;
	ret
l_461:
; 200     }
; 201     // (2) - Флаг директоии
; 202     de++;
	inc de
; 203     a = *de;
	ld a, (de)
; 204     a &= 0x01;
	and 1
; 205     ftpDirListIsDir = a;
	ld (ftpdirlistisdir), a
; 206     if (a == 0) {
	or a
	jp nz, l_462
; 207         a = ' ';
	ld a, 32
; 208         *hl = a;
	ld (hl), a
	jp l_463
l_462:
; 209     } else {
; 210         a = ' '; //'>';
	ld a, 32
; 211         *hl = a;
	ld (hl), a
l_463:
; 212     }
; 213     hl++;
	inc hl
; 214     // (3-4) - размер файла
; 215     de++;
	inc de
; 216     parceSizeFileInBuffer();
	call parcesizefileinbuffer
; 217     // (5-) Имя файла/директории
; 218     b = 9;
	ld b, 9
; 219     do {
l_464:
; 220         a = *de;
	ld a, (de)
; 221         if (a == 0x00) {
	or a
	jp nz, l_467
; 222             a = ' ';
	ld a, 32
l_467:
; 223         }
; 224         *hl = a;
	ld (hl), a
; 225         if ((a = b) == 1) {
	ld a, b
	cp 1
	jp nz, l_469
; 226             a = ' ';
	ld a, 32
; 227             *hl = a;
	ld (hl), a
l_469:
; 228         }
; 229         de++;
	inc de
; 230         hl++;
	inc hl
; 231         b--;
	dec b
l_465:
	jp nz, l_464
	ret
; 232     } while (flag_nz);
; 233 }
; 234 
; 235 /// HL - result string
; 236 /// DE - 2 byte size
; 237 void parceSizeFileInBuffer() {
parcesizefileinbuffer:
; 238     push_pop(hl) {
	push hl
; 239         push_pop(bc) {
	push bc
; 240             bc = 9;
	ld bc, 9
; 241             hl += bc; // смещаем указатель на позицию с размеров файла
	add hl, bc
; 242             a = ' ';
	ld a, 32
; 243             *hl = a;
	ld (hl), a
; 244             hl++;
	inc hl
; 245             // Размер
; 246             if ((a = ftpDirListIsDir) == 0) {
	ld a, (ftpdirlistisdir)
	or a
	jp nz, l_471
; 247                 a = *de;
	ld a, (de)
; 248                 a &= 0xF0;
	and 240
; 249                 cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 250                 convert4bitToCharA();
	call convert4bittochara
; 251                 *hl = a;
	ld (hl), a
; 252                 hl++;
	inc hl
; 253                 a = *de;
	ld a, (de)
; 254                 a &= 0x0F;
	and 15
; 255                 convert4bitToCharA();
	call convert4bittochara
; 256                 *hl = a;
	ld (hl), a
; 257                 hl++;
	inc hl
; 258                 de++;
	inc de
; 259                 
; 260                 a = *de;
	ld a, (de)
; 261                 a &= 0xF0;
	and 240
; 262                 cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 263                 convert4bitToCharA();
	call convert4bittochara
; 264                 *hl = a;
	ld (hl), a
; 265                 hl++;
	inc hl
; 266                 a = *de;
	ld a, (de)
; 267                 a &= 0x0F;
	and 15
; 268                 convert4bitToCharA();
	call convert4bittochara
; 269                 *hl = a;
	ld (hl), a
; 270                 hl++;
	inc hl
; 271                 de++;
	inc de
	jp l_472
l_471:
; 272             } else {
; 273                 a = ' ';
	ld a, 32
; 274                 *hl = a;
	ld (hl), a
; 275                 hl++;
	inc hl
; 276                 a = 'D';
	ld a, 68
; 277                 *hl = a;
	ld (hl), a
; 278                 hl++;
	inc hl
; 279                 a = 'I';
	ld a, 73
; 280                 *hl = a;
	ld (hl), a
; 281                 hl++;
	inc hl
; 282                 a = 'R';
	ld a, 82
; 283                 *hl = a;
	ld (hl), a
; 284                 hl++;
	inc hl
; 285                 de++;
	inc de
; 286                 de++;
	inc de
l_472:
; 287             }
; 288             //
; 289             a = 0;
	ld a, 0
; 290             *hl = a; // End char string
	ld (hl), a
	pop bc
	pop hl
	ret
; 291         }
; 292     }
; 293 }
; 294 
; 295 void ftpViewCurrentPosIsDir() {
ftpviewcurrentposisdir:
; 296     push_pop(hl) {
	push hl
; 297         push_pop(bc) {
	push bc
; 298             hl = ftpDirList;
	ld hl, ftpdirlist
; 299             a = ftpViewCurrentPos;
	ld a, (ftpviewcurrentpos)
; 300             b = 0;
	ld b, 0
; 301             carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 302             if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, l_473
; 303                 b++;
	inc b
l_473:
; 304             }
; 305             c = a;
	ld c, a
; 306             hl += bc;
	add hl, bc
; 307             // + 12 (DIR)
; 308             bc = 12;
	ld bc, 12
; 309             hl += bc;
	add hl, bc
; 310             a = *hl;
	ld a, (hl)
; 311             if (a == 'D') {
	cp 68
	jp nz, l_475
; 312                 a = 1;
	ld a, 1
	jp l_476
l_475:
; 313             } else {
; 314                 a = 0;
	ld a, 0
l_476:
; 315             }
; 316             ftpDirListIsDir = a;
	ld (ftpdirlistisdir), a
	pop bc
	pop hl
	ret
; 11 void showFtpView() {
showftpview:
; 12     drowRectX = (a = ftpSettingsViewX);
	ld a, (ftpsettingsviewx)
	ld (drowrectx), a
; 13     drowRectY = (a = ftpSettingsViewY);
	ld a, (ftpsettingsviewy)
	ld (drowrecty), a
; 14     drowRectEndX = (a = ftpSettingsViewEX);
	ld a, (ftpsettingsviewex)
	ld (drowrectendx), a
; 15     drowRectEndY = (a = ftpSettingsViewEY);
	ld a, (ftpsettingsviewey)
	ld (drowrectendy), a
; 16     drowRect();
	call drowrect
; 17     
; 18     hl = ftpSettingsLabelPos;
	ld hl, (ftpsettingslabelpos)
; 19     setPosCursor();
	call setposcursor
; 20     hl = ftpSettingsLabel;
	ld hl, ftpsettingslabel
; 21     printHLStr();
	call printhlstr
; 22     
; 23     hl = ftpSettingsStatusLabelPos;
	ld hl, (ftpsettingsstatuslabelpos)
; 24     setPosCursor();
	call setposcursor
; 25     hl = ftpSettingsStatusLabel;
	ld hl, ftpsettingsstatuslabel
; 26     printHLStr();
	call printhlstr
; 27     
; 28     hl = ftpSettingsIpLabelPos;
	ld hl, (ftpsettingsiplabelpos)
; 29     setPosCursor();
	call setposcursor
; 30     hl = ftpSettingsIpLabel;
	ld hl, ftpsettingsiplabel
; 31     printHLStr();
	call printhlstr
; 32     
; 33     hl = ftpSettingsPortLabelPos;
	ld hl, (ftpsettingsportlabelpos)
; 34     setPosCursor();
	call setposcursor
; 35     hl = ftpSettingsPortLabel;
	ld hl, ftpsettingsportlabel
; 36     printHLStr();
	call printhlstr
; 37     
; 38     hl = ftpSettingsUserLabelPos;
	ld hl, (ftpsettingsuserlabelpos)
; 39     setPosCursor();
	call setposcursor
; 40     hl = ftpSettingsUserLabel;
	ld hl, ftpsettingsuserlabel
; 41     printHLStr();
	call printhlstr
; 42     
; 43     //Value
; 44     hl = ftpSettingsIpValuePos;
	ld hl, (ftpsettingsipvaluepos)
; 45     setPosCursor();
	call setposcursor
; 46     hl = ftpSettingsIpValue;
	ld hl, ftpsettingsipvalue
; 47     printHLStr();
	call printhlstr
; 48     
; 49     hl = ftpSettingsPortValuePos;
	ld hl, (ftpsettingsportvaluepos)
; 50     setPosCursor();
	call setposcursor
; 51     hl = ftpSettingsPortValue;
	ld hl, ftpsettingsportvalue
; 52     printHLStr();
	call printhlstr
; 53     
; 54     hl = ftpSettingsUserValuePos;
	ld hl, (ftpsettingsuservaluepos)
; 55     setPosCursor();
	call setposcursor
; 56     hl = ftpSettingsUserValue;
	ld hl, ftpsettingsuservalue
; 57     printHLStr();
	call printhlstr
; 58     
; 59     updateFtpViewStatusText();
	call updateftpviewstatustext
; 60     updateFtpViewValData();
	jp updateftpviewvaldata
; 61 }
; 62 
; 63 void clearFtpViewValData() {
clearftpviewvaldata:
; 64     hl = ftpSettingsStatusValuePos;
	ld hl, (ftpsettingsstatusvaluepos)
; 65     setPosCursor();
	call setposcursor
; 66     hl = wifiSettingsEmpty18;
	ld hl, wifisettingsempty18
; 67     printHLStr();
	jp printhlstr
; 68 }
; 69 
; 70 void updateFtpViewValData() {
updateftpviewvaldata:
; 71     hl = ftpSettingsStatusValuePos;
	ld hl, (ftpsettingsstatusvaluepos)
; 72     setPosCursor();
	call setposcursor
; 73     hl = ftpSettingsStatusValue;
	ld hl, ftpsettingsstatusvalue
; 74     printHLStr();
	jp printhlstr
; 75 }
; 76 
; 77 void updateFtpViewStatusText() {
updateftpviewstatustext:
; 78     push_pop(hl) {
	push hl
; 79         push_pop(de) {
	push de
; 80             push_pop(bc) {
	push bc
; 81                 
; 82                 if ((a = ftpSettingsStateVal) == 0x00) {
	ld a, (ftpsettingsstateval)
	or a
	jp nz, l_477
; 83                     hl = ftpSettingsStatus0;
	ld hl, ftpsettingsstatus0
	jp l_478
l_477:
; 84                 } else {
; 85                     hl = ftpSettingsStatus1;
	ld hl, ftpsettingsstatus1
l_478:
; 86                 }
; 87                 
; 88                 de = ftpSettingsStatusValue;
	ld de, ftpsettingsstatusvalue
; 89                 //Copy *hl to *de
; 90                 b = 12;
	ld b, 12
; 91                 do {
l_479:
; 92                     a = *hl;
	ld a, (hl)
; 93                     *de = a;
	ld (de), a
; 94                     if ((a = b) == 1) {
	ld a, b
	cp 1
	jp nz, l_482
; 95                         a = 0;
	ld a, 0
; 96                         *de = a;
	ld (de), a
l_482:
; 97                     }
; 98                     de++;
	inc de
; 99                     hl++;
	inc hl
; 100                     b--;
	dec b
l_480:
; 101                 } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_479
	pop bc
	pop de
	pop hl
	ret
; 11 void showFtpFileLoadView() {
showftpfileloadview:
; 12     drowRectX = (a = FtpFileLoadViewX);
	ld a, (ftpfileloadviewx)
	ld (drowrectx), a
; 13     drowRectY = (a = FtpFileLoadViewY);
	ld a, (ftpfileloadviewy)
	ld (drowrecty), a
; 14     drowRectEndX = (a = FtpFileLoadViewEX);
	ld a, (ftpfileloadviewex)
	ld (drowrectendx), a
; 15     drowRectEndY = (a = FtpFileLoadViewEY);
	ld a, (ftpfileloadviewey)
	ld (drowrectendy), a
; 16     drowRect();
	call drowrect
; 17     
; 18     hl = FtpFileLoadViewTitlelPos;
	ld hl, (ftpfileloadviewtitlelpos)
; 19     setPosCursor();
	call setposcursor
; 20     hl = FtpFileLoadViewTitlel;
	ld hl, ftpfileloadviewtitlel
; 21     printHLStr();
	jp printhlstr
; 22 }
; 23 
; 24 void updateProgress() {
updateprogress:
; 25     push_pop(hl) {
	push hl
; 26         push_pop(bc) {
	push bc
; 27             a = FtpFileLoadViewY;
	ld a, (ftpfileloadviewy)
; 28             a += 1;
	add 1
; 29             h = a;
	ld h, a
; 30             a = FtpFileLoadViewX;
	ld a, (ftpfileloadviewx)
; 31             a += 2;
	add 2
; 32             l = a;
	ld l, a
; 33             setPosCursor();
	call setposcursor
; 34             h = 0;
	ld h, 0
; 35             a = ftpFileLoadViewProgress;
	ld a, (ftpfileloadviewprogress)
; 36             l = a;
	ld l, a
; 37             //
; 38             setMyFont();
	call setmyfont
; 39             do {
l_484:
; 40                 h++;
	inc h
; 41                 if ((a = h) < l) {
	ld a, h
	cp l
	jp nc, l_487
; 42                     c = 0x28; //'X';
	ld c, 40
	jp l_488
l_487:
; 43                 } else {
; 44                     c = 0x27; //' ';
	ld c, 39
l_488:
; 45                 }
; 46                 push_pop(hl) {
	push hl
; 47                     printChatC();
	call printchatc
	pop hl
l_485:
; 48                 }
; 49             } while ((a = h) < 30);
	ld a, h
	cp 30
	jp c, l_484
; 50             setSystemFont();
	call setsystemfont
	pop bc
	pop hl
	ret
; 51         }
; 52     }
; 53 }
; 54 
; 55 void ftpFileLoadViewNeedLoad() {
ftpfileloadviewneedload:
; 56     ftpFileDownload();
	call ftpfiledownload
; 57     
; 58     // Считываем текущий диск и устанавливаем его
; 59     a = diskViewDiskNum;
	ld a, (diskviewdisknum)
; 60     ordos_wnd();
	call ordos_wnd
; 61     
; 62     // Получаем адрес куда надо начинать писать данные
; 63     ordos_mxdsk();
	call ordos_mxdsk
; 64     diskStartNewFile = hl;
	ld (diskstartnewfile), hl
; 65     
; 66     // Вызываем закачку
; 67     ftpFileDownloadNext();
	call ftpfiledownloadnext
; 68     
; 69     // Обновляем
; 70     updateDiskList();
	call updatedisklist
; 71     updateRootUI();
	jp updaterootui
; 72 }
; 73 
; 74 void ftpFileLoadViewParce() {
ftpfileloadviewparce:
; 75     push_pop(de) {
	push de
; 76         push_pop(hl) {
	push hl
; 77             push_pop(bc) {
	push bc
; 78                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 79                 //addr
; 80                 de++;
	inc de
; 81                 de++;
	inc de
; 82                 //stopByte
; 83                 a = *de;
	ld a, (de)
; 84                 a &= 0x01;
	and 1
; 85                 ftpFileLoadViewIsNextData = a;
	ld (ftpfileloadviewisnextdata), a
; 86                 de++;
	inc de
; 87                 //sum
; 88                 a = *de;
	ld a, (de)
; 89                 ftpFileLoadViewCheckSum = a;
	ld (ftpfileloadviewchecksum), a
; 90                 de++;
	inc de
; 91                 // PROGRESS
; 92                 a = *de;
	ld a, (de)
; 93                 ftpFileLoadViewProgress = a;
	ld (ftpfileloadviewprogress), a
; 94                 de++;
	inc de
; 95                 // PAGE SIZE
; 96                 a = *de;
	ld a, (de)
; 97                 if (a >= 15) {
	cp 15
	jp c, l_489
; 98                     a = 15;
	ld a, 15
l_489:
; 99                 }
; 100                 de++;
	inc de
; 101                 //CHECK SUM
; 102                 b = a; // SAVE PAGE SIZE in B
	ld b, a
; 103                 push_pop(de) {
	push de
; 104                     push_pop(bc) {
	push bc
; 105                         h = 0; //SUM!!!
	ld h, 0
; 106                         do {
l_491:
; 107                             a = *de;
	ld a, (de)
; 108                             a += h;
	add h
; 109                             h = a;
	ld h, a
; 110                             de++;
	inc de
; 111                             b--;
	dec b
l_492:
; 112                         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_491
	pop bc
	pop de
; 113                     }
; 114                 }
; 115                 //
; 116                 if ((a = ftpFileLoadViewCheckSum) == h) {
	ld a, (ftpfileloadviewchecksum)
	cp h
	jp nz, l_494
; 117                     // Сумма корректная
; 118                     if ((a = ftpFileLoadViewIsNextData) == 0) {
	ld a, (ftpfileloadviewisnextdata)
	or a
	jp nz, l_496
; 119                         // Данных больше нет - закрываем файл!
; 120                         ordos_stop();
	call ordos_stop
	jp l_497
l_496:
; 121                     } else {
; 122                         // Данные корректны и еще есть - пишем
; 123                         // DATA
; 124                         hl = diskStartNewFile;
	ld hl, (diskstartnewfile)
; 125                         do {
l_498:
; 126                             a = *de;
	ld a, (de)
; 127                             ordos_wdisk();
	call ordos_wdisk
; 128                             //SUM
; 129                             hl++;
	inc hl
; 130                             de++;
	inc de
; 131                             b--;
	dec b
l_499:
; 132                         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_498
; 133                         diskStartNewFile = hl;
	ld (diskstartnewfile), hl
l_497:
; 134                     }
; 135                     // Получить следующий пакет
; 136                     a = 0x01;
	ld a, 1
; 137                     ftpFileLoadViewCheckSumState = a;
	ld (ftpfileloadviewchecksumstate), a
; 138                     // Если считано без ошибок - то отрисовываем прогресс
; 139                     updateProgress();
	call updateprogress
	jp l_495
l_494:
; 140                 } else {
; 141                     // Получить пакет снова!
; 142                     a = 0x00;
	ld a, 0
; 143                     ftpFileLoadViewCheckSumState = a;
	ld (ftpfileloadviewchecksumstate), a
l_495:
	pop bc
	pop hl
	pop de
	ret
; 144                 }
; 145             }
; 146         }
; 147     }
; 148 }
; 149 
; 150 uint8_t ftpFileLoadViewIsNextData = 0;
ftpfileloadviewisnextdata:
	db 0
; 151 uint16_t ftpFileLoadViewFileAddrPos = 0x0000;
ftpfileloadviewfileaddrpos:
	dw 0
; 152 uint8_t ftpFileLoadViewCheckSum = 0;
ftpfileloadviewchecksum:
	db 0
; 153 uint8_t ftpFileLoadViewCheckSumState = 0;
ftpfileloadviewchecksumstate:
	db 0
; 154 uint8_t ftpFileLoadViewProgress = 0;
ftpfileloadviewprogress:
	db 0
; 156 uint8_t FtpFileLoadViewX = 15;
ftpfileloadviewx:
	db 15
; 157 uint8_t FtpFileLoadViewY = 11;
ftpfileloadviewy:
	db 11
; 158 uint8_t FtpFileLoadViewEX = 49;
ftpfileloadviewex:
	db 49
; 159 uint8_t FtpFileLoadViewEY = 14;
ftpfileloadviewey:
	db 14
; 161 uint16_t FtpFileLoadViewTitlelPos = 0x0B1D; //031B
ftpfileloadviewtitlelpos:
	dw 2845
; 162 uint8_t FtpFileLoadViewTitlel[] = " LOAD ";
ftpfileloadviewtitlel:
	db 32
	db 76
	db 79
	db 65
	db 68
	db 32
	ds 1
; 30 uint8_t rootTimerTike = 0;
roottimertike:
	db 0
 savebin "test.ORD", 0x00f0, 0x1C0f
