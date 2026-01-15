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

    DB 0x00, 0x20

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
; 38     //delay5msI2C(); delay5msI2C();
; 39     getSSIDValue();
	call getssidvalue
; 40     //delay5msI2C(); delay5msI2C();
; 41     getSSIDPasswordValue();
	call getssidpasswordvalue
; 42     
; 43     /// FTP
; 44     //delay5msI2C(); delay5msI2C();
; 45     getFTPUrl();
	call getftpurl
; 46     //delay5msI2C(); delay5msI2C();
; 47     getFTPUser();
	call getftpuser
; 48     //delay5msI2C(); delay5msI2C();
; 49     getFTPPassword();
	call getftppassword
; 50     //delay5msI2C(); delay5msI2C();
; 51     getFTPPort();
	call getftpport
; 52     getFtpCurrentPath();
	call getftpcurrentpath
; 53     
; 54     ///
; 55     updateRootUI();
	call updaterootui
; 56     
; 57     updateRootDataUI();
	call updaterootdataui
; 58     
; 59     //Бесконечный цикл. Что бы увидеть результат
; 60     for (;;) {
l_1:
; 61         getKeyboardStateA();
	call getkeyboardstatea
; 62         if (a == 0xFF) {
	cp 255
	jp nz, l_3
; 63             // Если клавиша нажата - вызываем обработчик
; 64             keyboardEvent();
	call keyboardevent
	jp l_4
l_3:
; 65         } else {
; 66             a = rootTimerTike;
	ld a, (roottimertike)
; 67             if (a >= 240) {
	cp 240
	jp c, l_5
; 68                 a = 0;
	ld a, 0
; 69                 rootTimerTike = a;
	ld (roottimertike), a
; 70                 if ((a = rootViewCurrentView) == rootViewCurrentDiskView) {
	ld a, (rootviewcurrentview)
	or a
	jp nz, l_7
; 71                     updateWiFiStatus();
	call updatewifistatus
; 72                     updateFtpStatus();
	call updateftpstatus
l_7:
	jp l_6
l_5:
; 73                 }
; 74             } else {
; 75                 a++;
	inc a
; 76                 rootTimerTike = a;
	ld (roottimertike), a
l_6:
l_4:
	jp l_1
; 77             }
; 78         }
; 79     }
; 80 }
; 81 
; 82 void keyboardEvent() {
keyboardevent:
; 83     getKeyboardCodeA();
	call getkeyboardcodea
; 84     l = a; //Save key
	ld l, a
; 85     if ((a = rootViewOldKey) != l) {
	ld a, (rootviewoldkey)
	cp l
	jp z, l_9
; 86         a = l; //Load key
	ld a, l
; 87         rootViewOldKey = a;
	ld (rootviewoldkey), a
; 88         push_pop(hl) {
	push hl
; 89             a = l; //Load key
	ld a, l
; 90             if (a != 0xFF) {
	cp 255
	jp z, l_11
; 91                 /// Hot ley
; 92                 if (a == 0x03) { //F4 quit ordos
	cp 3
	jp nz, l_13
; 93                     ordos_start();
	call ordos_start
	jp l_14
l_13:
; 94                 } else if (a == 0x02) { //F3 Open FTP settings
	cp 2
	jp nz, l_15
; 95                     needOpenFTPSettingsEditView();
	call needopenftpsettingseditview
	jp l_16
l_15:
; 96                 } else if (a == 0x01) { //F2 Open WiFi settings
	cp 1
	jp nz, l_17
; 97                     needOpenWiFiSettingsEditView();
	call needopenwifisettingseditview
l_17:
l_16:
l_14:
; 98                 }
; 99                 
; 100                 /// View's
; 101                 if ((a = rootViewCurrentView) == rootViewCurrentDiskView) { // Local disk
	ld a, (rootviewcurrentview)
	or a
	jp nz, l_19
; 102                     a = l; //Load key
	ld a, l
; 103                     diskViewKeyA();
	call diskviewkeya
; 104                     showDiskList(); //Refresh
	call showdisklist
	jp l_20
l_19:
; 105                 } else if ((a = rootViewCurrentView) == rootViewCurrentFTPView) { // FTP Dir
	ld a, (rootviewcurrentview)
	cp 1
	jp nz, l_21
; 106                     a = l; //Load key
	ld a, l
; 107                     ftpViewKeyA();
	call ftpviewkeya
; 108                     ftpViewDataUpdate();
	call ftpviewdataupdate
	jp l_22
l_21:
; 109                 } else if ((a = rootViewCurrentView) == rootViewCurrentFTPSettingsEditView) {
	ld a, (rootviewcurrentview)
	cp 2
	jp nz, l_23
; 110                     a = l; //Load key
	ld a, l
; 111                     ftpSettingsEditViewKeyA();
	call ftpsettingseditviewkeya
; 112                     ftpSettingsEditViewDataUpdate();
	call ftpsettingseditviewdataupdate
	jp l_24
l_23:
; 113                 } else if ((a = rootViewCurrentView) == rootViewCurrentWiFiSettingsEditView) {
	ld a, (rootviewcurrentview)
	cp 3
	jp nz, l_25
; 114                     a = l; //Load key
	ld a, l
; 115                     wifiSettingsEditViewKeyA();
	call wifisettingseditviewkeya
; 116                     wifiSettingsEditViewDataUpdate();
	call wifisettingseditviewdataupdate
	jp l_26
l_25:
; 117                 } else if ((a = rootViewCurrentView) == rootSSIDListView) {
	ld a, (rootviewcurrentview)
	cp 4
	jp nz, l_27
; 118                     a = l; //Load key
	ld a, l
; 119                     SSIDListViewKeyA();
	call ssidlistviewkeya
; 120                     SSIDListViewDataUpdate();
	call ssidlistviewdataupdate
l_27:
l_26:
l_24:
l_22:
l_20:
l_11:
	pop hl
l_9:
	ret
; 121                 }
; 122                 //printHexA();
; 123             }
; 124         }
; 125     }
; 126 }
; 127 
; 128 void updateRootDataUI() {
updaterootdataui:
; 129     showDiskList();
	jp showdisklist
; 130 }
; 131 
; 132 void updateRootUI() {
updaterootui:
; 133     a = 0x00;
	ld a, 0
; 134     inverceAddress = a;
	ld (inverceaddress), a
; 135     clearScreen();
	call clearscreen
; 136     
; 137     a = 0x00;
	ld a, 0
; 138     inverceAddress = a;
	ld (inverceaddress), a
; 139     showWiFiView();
	call showwifiview
; 140     a = 0x00;
	ld a, 0
; 141     inverceAddress = a;
	ld (inverceaddress), a
; 142     showFtpView();
	call showftpview
; 143     a = 0x00;
	ld a, 0
; 144     inverceAddress = a;
	ld (inverceaddress), a
; 145     diskView();
	call diskview
; 146     a = 0x00;
	ld a, 0
; 147     inverceAddress = a;
	ld (inverceaddress), a
; 148     ftpView();
	call ftpview
; 149     
; 150     showHelpStr();
	jp showhelpstr
; 151 }
; 152 
; 153 void ftpView() {
ftpview:
; 154     drowRectX = (a = ftpViewX);
	ld a, (ftpviewx)
	ld (drowrectx), a
; 155     drowRectY = (a = ftpViewY);
	ld a, (ftpviewy)
	ld (drowrecty), a
; 156     drowRectEndX = (a = ftpViewEX);
	ld a, (ftpviewex)
	ld (drowrectendx), a
; 157     drowRectEndY = (a = ftpViewEY);
	ld a, (ftpviewey)
	ld (drowrectendy), a
; 158     drowRect();
	call drowrect
; 159     
; 160     hl = ftpLabelPos;
	ld hl, (ftplabelpos)
; 161     setPosCursor();
	call setposcursor
; 162     hl = ftpLabel;
	ld hl, ftplabel
; 163     printHLStr();
	call printhlstr
; 164     
; 165     updateCurrentPath();
	jp updatecurrentpath
; 166 }
; 167 
; 168 void diskView() {
diskview:
; 169     drowRectX = (a = diskViewX);
	ld a, (diskviewx)
	ld (drowrectx), a
; 170     drowRectY = (a = diskViewY);
	ld a, (diskviewy)
	ld (drowrecty), a
; 171     drowRectEndX = (a = diskViewEX);
	ld a, (diskviewex)
	ld (drowrectendx), a
; 172     drowRectEndY = (a = diskViewEY);
	ld a, (diskviewey)
	ld (drowrectendy), a
; 173     drowRect();
	call drowrect
; 174     
; 175     hl = diskViewLabelPos;
	ld hl, (diskviewlabelpos)
; 176     setPosCursor();
	call setposcursor
; 177     hl = diskViewLabel;
	ld hl, diskviewlabel
; 178     printHLStr();
	jp printhlstr
; 179 }
; 180 
; 181 void showWiFiView() {
showwifiview:
; 182     drowRectX = (a = wifiSettingsViewX);
	ld a, (wifisettingsviewx)
	ld (drowrectx), a
; 183     drowRectY = (a = wifiSettingsViewY);
	ld a, (wifisettingsviewy)
	ld (drowrecty), a
; 184     drowRectEndX = (a = wifiSettingsViewEX);
	ld a, (wifisettingsviewex)
	ld (drowrectendx), a
; 185     drowRectEndY = (a = wifiSettingsViewEY);
	ld a, (wifisettingsviewey)
	ld (drowrectendy), a
; 186     drowRect();
	call drowrect
; 187     
; 188     hl = wifiSettingsPos;
	ld hl, (wifisettingspos)
; 189     setPosCursor();
	call setposcursor
; 190     hl = wifiSettingsLabel;
	ld hl, wifisettingslabel
; 191     printHLStr();
	call printhlstr
; 192     
; 193     hl = wifiSettingsSsidLabelPos;
	ld hl, (wifisettingsssidlabelpos)
; 194     setPosCursor();
	call setposcursor
; 195     hl = wifiSettingsSsidLabel;
	ld hl, wifisettingsssidlabel
; 196     printHLStr();
	call printhlstr
; 197     
; 198     hl = wifiSettingsIpLabelPos;
	ld hl, (wifisettingsiplabelpos)
; 199     setPosCursor();
	call setposcursor
; 200     hl = wifiSettingsIpLabel;
	ld hl, wifisettingsiplabel
; 201     printHLStr();
	call printhlstr
; 202     
; 203     hl = wifiSettingsMacLabelPos;
	ld hl, (wifisettingsmaclabelpos)
; 204     setPosCursor();
	call setposcursor
; 205     hl = wifiSettingsMacLabel;
	ld hl, wifisettingsmaclabel
; 206     printHLStr();
	call printhlstr
; 207     
; 208     hl = wifiSettingsSsidValPos;
	ld hl, (wifisettingsssidvalpos)
; 209     setPosCursor();
	call setposcursor
; 210     hl = wifiSettingsSsidVal;
	ld hl, wifisettingsssidval
; 211     printHLStr();
	call printhlstr
; 212     
; 213     updateWiFiViewValData();
	jp updatewifiviewvaldata
; 214 }
; 215 
; 216 void clearWiFiViewValData() {
clearwifiviewvaldata:
; 217     hl = wifiSettingsIpValPos;
	ld hl, (wifisettingsipvalpos)
; 218     setPosCursor();
	call setposcursor
; 219     hl = wifiSettingsEmpty18;
	ld hl, wifisettingsempty18
; 220     printHLStr();
	call printhlstr
; 221     
; 222     hl = wifiSettingsMacValPos;
	ld hl, (wifisettingsmacvalpos)
; 223     setPosCursor();
	call setposcursor
; 224     hl = wifiSettingsEmpty18;
	ld hl, wifisettingsempty18
; 225     printHLStr();
	jp printhlstr
; 226 }
; 227 
; 228 void updateWiFiViewValData() {
updatewifiviewvaldata:
; 229     hl = wifiSettingsIpValPos;
	ld hl, (wifisettingsipvalpos)
; 230     setPosCursor();
	call setposcursor
; 231     hl = wifiSettingsIpVal;
	ld hl, wifisettingsipval
; 232     printHLStr();
	call printhlstr
; 233     
; 234     hl = wifiSettingsMacValPos;
	ld hl, (wifisettingsmacvalpos)
; 235     setPosCursor();
	call setposcursor
; 236     hl = wifiSettingsMacVal;
	ld hl, wifisettingsmacval
; 237     printHLStr();
	jp printhlstr
; 238 }
; 239 
; 240 void clearScreen() {
clearscreen:
; 241     c = 0x1B;
	ld c, 27
; 242     printChatC();
	call printchatc
; 243     c = 0x45;
	ld c, 69
; 244     printChatC();
	jp printchatc
; 245 }
; 246 
; 247 void drowRect() {
drowrect:
; 248     setMyFont();
	call setmyfont
; 249     
; 250     //h = y
; 251     a = drowRectY;
	ld a, (drowrecty)
; 252     h = a;
	ld h, a
; 253     
; 254     do {
l_29:
; 255         //l = x
; 256         a = drowRectX;
	ld a, (drowrectx)
; 257         l = a;
	ld l, a
; 258         
; 259         push_pop(hl) {
	push hl
; 260             setPosCursor();
	call setposcursor
	pop hl
; 261         }
; 262         
; 263         do {
l_32:
; 264             if ((a = drowRectY) == h) {
	ld a, (drowrecty)
	cp h
	jp nz, l_35
; 265                 c = 0x26;
	ld c, 38
; 266                 if ((a = drowRectX) == l) {
	ld a, (drowrectx)
	cp l
	jp nz, l_37
; 267                     c = 0x21;
	ld c, 33
l_37:
; 268                 }
; 269                 if ((a = drowRectEndX)-- == l) {
	ld a, (drowrectendx)
	dec a
	cp l
	jp nz, l_39
; 270                     c = 0x23;
	ld c, 35
l_39:
	jp l_36
l_35:
; 271                 }
; 272             } else if ((a = drowRectEndY)-- == h) {
	ld a, (drowrectendy)
	dec a
	cp h
	jp nz, l_41
; 273                 c = 0x26;
	ld c, 38
; 274                 if ((a = drowRectX) == l) {
	ld a, (drowrectx)
	cp l
	jp nz, l_43
; 275                     c = 0x22;
	ld c, 34
l_43:
; 276                 }
; 277                 if ((a = drowRectEndX)-- == l) {
	ld a, (drowrectendx)
	dec a
	cp l
	jp nz, l_45
; 278                     c = 0x24;
	ld c, 36
l_45:
	jp l_42
l_41:
; 279                 }
; 280             } else {
; 281                 c = 0x20;
	ld c, 32
; 282                 if ((a = drowRectX) == l) {
	ld a, (drowrectx)
	cp l
	jp nz, l_47
; 283                     c = 0x25;
	ld c, 37
l_47:
; 284                 }
; 285                 if ((a = drowRectEndX)-- == l) {
	ld a, (drowrectendx)
	dec a
	cp l
	jp nz, l_49
; 286                     c = 0x25;
	ld c, 37
l_49:
l_42:
l_36:
; 287                 }
; 288             }
; 289             
; 290             push_pop(hl) {
	push hl
; 291                 printChatC();
	call printchatc
	pop hl
; 292             }
; 293             
; 294             a = drowRectEndX;
	ld a, (drowrectendx)
; 295             l++;
	inc l
; 296             a -= l;
	sub l
l_33:
	jp nz, l_32
; 297         } while (flag_nz);
; 298         
; 299         a = drowRectEndY;
	ld a, (drowrectendy)
; 300         h++;
	inc h
; 301         a -= h;
	sub h
l_30:
	jp nz, l_29
; 302     } while (flag_nz);
; 303     
; 304     setSystemFont();
	jp setsystemfont
; 305 }
; 306 
; 307 void setMyFont() {
setmyfont:
; 308     push_pop(hl) {
	push hl
; 309         hl = fontAddress;
	ld hl, (fontaddress)
; 310         systemFontAddress = hl;
	ld (systemfontaddress), hl
; 311         hl = &myFont;
	ld hl, myfont
; 312         fontAddress = hl;
	ld (fontaddress), hl
	pop hl
	ret
; 313     }
; 314 }
; 315 
; 316 void setSystemFont() {
setsystemfont:
; 317     push_pop(hl) {
	push hl
; 318         hl = systemFontAddress;
	ld hl, (systemfontaddress)
; 319         fontAddress = hl;
	ld (fontaddress), hl
	pop hl
	ret
; 320     }
; 321 }
; 322 
; 323 uint8_t drowRectX = 0x00;
drowrectx:
	db 0
; 324 uint8_t drowRectY = 0x00;
drowrecty:
	db 0
; 325 uint8_t drowRectEndX = 0x00;
drowrectendx:
	db 0
; 326 uint8_t drowRectEndY = 0x00;
drowrectendy:
	db 0
; 328 uint16_t systemFontAddress = 0x0000;
systemfontaddress:
	dw 0
; 330 void updateDiskList() {
updatedisklist:
; 331     a = diskViewDiskNum;
	ld a, (diskviewdisknum)
; 332     ordos_wnd();
	call ordos_wnd
; 333     hl = startListBufer;
	ld hl, 0
; 334     ordos_dirm();
	call ordos_dirm
; 335     diskViewListCount = a;
	ld (diskviewlistcount), a
	ret
; 336 }
; 337 
; 338 void showDiskList() {
showdisklist:
; 339     b = 0;
	ld b, 0
; 340     showDiskDriveName();
	call showdiskdrivename
; 341     showDiskDir();
	call showdiskdir
; 342     hl = diskViewListNamePos;
	ld hl, (diskviewlistnamepos)
; 343     
; 344     if ((a = diskViewListCount) == 0) {
	ld a, (diskviewlistcount)
	or a
	jp nz, l_51
; 345         return;
	ret
l_51:
; 346     }
; 347     
; 348     do {
l_53:
; 349         setPosCursor();
	call setposcursor
; 350         a = b;
	ld a, b
; 351         push_pop(hl) {
	push hl
; 352             showDiskApp();
	call showdiskapp
	pop hl
; 353         };
; 354         
; 355         h++;
	inc h
; 356         b++;
	inc b
; 357         a = diskViewListCount;
	ld a, (diskviewlistcount)
; 358         a -= b;
	sub b
l_54:
	jp nz, l_53
	ret
; 359     } while (flag_nz);
; 360 }
; 361 
; 362 void showDiskDriveName() {
showdiskdrivename:
; 363     push_pop(hl) {
	push hl
; 364         hl = diskViewDriveNamePos;
	ld hl, (diskviewdrivenamepos)
; 365         setPosCursor();
	call setposcursor
; 366         a = diskViewDiskNum;
	ld a, (diskviewdisknum)
; 367         printChatA();
	call printchata
	pop hl
	ret
; 368     }
; 369 }
; 370 
; 371 void showDiskDir() {
showdiskdir:
; 372     push_pop(hl) {
	push hl
; 373         hl = diskViewListDirPos;
	ld hl, (diskviewlistdirpos)
; 374         setPosCursor();
	call setposcursor
; 375         hl = diskViewListDirLabel;
	ld hl, diskviewlistdirlabel
; 376         push_pop(bc) {
	push bc
; 377             a = 0;
	ld a, 0
; 378             inverceAddress = a;
	ld (inverceaddress), a
; 379             if ((a = diskViewCurrPos) == 0) {
	ld a, (diskviewcurrpos)
	or a
	jp nz, l_56
; 380                 if ((a = rootViewCurrentView) == rootViewCurrentDiskView) {
	ld a, (rootviewcurrentview)
	or a
	jp nz, l_58
; 381                     a = 0xFF;
	ld a, 255
; 382                     inverceAddress = a;
	ld (inverceaddress), a
l_58:
l_56:
; 383                 }
; 384             }
; 385             printHLStr();
	call printhlstr
; 386             a = 0;
	ld a, 0
; 387             inverceAddress = a;
	ld (inverceaddress), a
	pop bc
	pop hl
	ret
; 388         }
; 389     }
; 390 }
; 391 
; 392 ///A - count app
; 393 void showDiskApp() {
showdiskapp:
; 394     push_pop(bc) {
	push bc
; 395         
; 396         c = a;
	ld c, a
; 397         carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 398         hl = startListBufer;
	ld hl, 0
; 399         a += l;
	add l
; 400         l = a;
	ld l, a
; 401         if (flag_c) {
	jp nc, l_60
; 402             h++;
	inc h
l_60:
; 403         }
; 404         
; 405         a = 0x00;
	ld a, 0
; 406         inverceAddress = a;
	ld (inverceaddress), a
; 407         
; 408         if ((a = diskViewCurrPos)-- == c) {
	ld a, (diskviewcurrpos)
	dec a
	cp c
	jp nz, l_62
; 409             if ((a = rootViewCurrentView) == rootViewCurrentDiskView) {
	ld a, (rootviewcurrentview)
	or a
	jp nz, l_64
; 410                 a = 0xFF;
	ld a, 255
; 411                 inverceAddress = a;
	ld (inverceaddress), a
l_64:
l_62:
; 412             }
; 413         }
; 414     
; 415         a = ' ';
	ld a, 32
; 416         printChatA();
	call printchata
; 417         b = 0;
	ld b, 0
; 418         
; 419         do {
l_66:
; 420             a = *hl;
	ld a, (hl)
; 421             printChatA();
	call printchata
; 422             hl++;
	inc hl
; 423             b++;
	inc b
; 424             a = 8;
	ld a, 8
; 425             a -= b;
	sub b
l_67:
	jp nz, l_66
; 426         } while (flag_nz);
; 427         a = ' ';
	ld a, 32
; 428         printChatA();
	call printchata
	pop bc
; 429     };
; 430     a = 0x00;
	ld a, 0
; 431     inverceAddress = a;
	ld (inverceaddress), a
	ret
; 432 }
; 433 
; 434 void diskViewKeyA() {
diskviewkeya:
; 435     push_pop(bc) {
	push bc
; 436         b = a;
	ld b, a
; 437         
; 438         if (a == 0x1A) { //down
	cp 26
	jp nz, l_69
; 439             a = diskViewListCount;
	ld a, (diskviewlistcount)
; 440             c = a;
	ld c, a
; 441             if ( (a = diskViewCurrPos) < c  ) {
	ld a, (diskviewcurrpos)
	cp c
	jp nc, l_71
; 442                 a++;
	inc a
; 443                 diskViewCurrPos = a;
	ld (diskviewcurrpos), a
l_71:
	jp l_70
l_69:
; 444             }
; 445         } else if (a == 0x19) { //up
	cp 25
	jp nz, l_73
; 446             if ( (a = diskViewCurrPos) > 0 ) {
	ld a, (diskviewcurrpos)
	or a
	jp z, l_75
; 447                 a--;
	dec a
; 448                 diskViewCurrPos = a;
	ld (diskviewcurrpos), a
l_75:
	jp l_74
l_73:
; 449             }
; 450         } else if (a == 0x0D) { //Enter
	cp 13
	jp nz, l_77
; 451             if ((a = diskViewCurrPos) == 0) { // Change drive
	ld a, (diskviewcurrpos)
	or a
	jp nz, l_79
; 452                 a = diskViewDiskNum;
	ld a, (diskviewdisknum)
; 453                 if (a == 'B') {
	cp 66
	jp nz, l_81
; 454                     a = 'C';
	ld a, 67
	jp l_82
l_81:
; 455                 } else if (a == 'C') {
	cp 67
	jp nz, l_83
; 456                     a = 'D';
	ld a, 68
	jp l_84
l_83:
; 457                 } else if (a == 'D') {
	cp 68
	jp nz, l_85
; 458                     a = 'B';
	ld a, 66
l_85:
l_84:
l_82:
; 459                 }
; 460                 diskViewDiskNum = a;
	ld (diskviewdisknum), a
; 461                 diskView();
	call diskview
; 462                 updateDiskList();
	call updatedisklist
	jp l_80
l_79:
; 463             } else { // Upload file to FTP
l_80:
	jp l_78
l_77:
; 464                 
; 465             }
; 466         } else if (a == 0x09) { //TAB
	cp 9
	jp nz, l_87
; 467             a = rootViewCurrentFTPView; // переходим на список файлов FTP
	ld a, 1
; 468             rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 469             // Сбросить выделение строки на диске
; 470             showDiskList();
	call showdisklist
; 471             // Выделить текущую позицию на FTP
; 472             ftpViewDataUpdate();
	call ftpviewdataupdate
l_87:
l_78:
l_74:
l_70:
	pop bc
	ret
; 473         }
; 474     }
; 475 }
; 476 
; 477 void showHelpStr() {
showhelpstr:
; 478     push_pop(hl) {
	push hl
; 479         hl = rootViewHelpStrPos;
	ld hl, (rootviewhelpstrpos)
; 480         setPosCursor();
	call setposcursor
; 481         hl = rootViewHelpStr;
	ld hl, rootviewhelpstr
; 482         printHLStr();
	call printhlstr
	pop hl
	ret
; 483     }
; 484 }
; 485 
; 486 void showFtpSettingsEditView() {
showftpsettingseditview:
; 487     drowRectX = (a = ftpSettingsEditViewX);
	ld a, (ftpsettingseditviewx)
	ld (drowrectx), a
; 488     drowRectY = (a = ftpSettingsEditViewY);
	ld a, (ftpsettingseditviewy)
	ld (drowrecty), a
; 489     drowRectEndX = (a = ftpSettingsEditViewEX);
	ld a, (ftpsettingseditviewex)
	ld (drowrectendx), a
; 490     drowRectEndY = (a = ftpSettingsEditViewEY);
	ld a, (ftpsettingseditviewey)
	ld (drowrectendy), a
; 491     drowRect();
	call drowrect
; 492     
; 493     hl = ftpSettingsEditViewLabelPos;
	ld hl, (ftpsettingseditviewlabelpos)
; 494     setPosCursor();
	call setposcursor
; 495     hl = ftpSettingsEditViewLabel;
	ld hl, ftpsettingseditviewlabel
; 496     printHLStr();
	call printhlstr
; 497     
; 498     hl = ftpSettingsEditViewIpLabelPos;
	ld hl, (ftpsettingseditviewiplabelpos)
; 499     setPosCursor();
	call setposcursor
; 500     hl = ftpSettingsIpLabel;
	ld hl, ftpsettingsiplabel
; 501     printHLStr();
	call printhlstr
; 502     
; 503     hl = ftpSettingsEditViewPortLabelPos;
	ld hl, (ftpsettingseditviewportlabelpos)
; 504     setPosCursor();
	call setposcursor
; 505     hl = ftpSettingsPortLabel;
	ld hl, ftpsettingsportlabel
; 506     printHLStr();
	call printhlstr
; 507     
; 508     hl = ftpSettingsEditViewUserLabelPos;
	ld hl, (ftpsettingseditviewuserlabelpos)
; 509     setPosCursor();
	call setposcursor
; 510     hl = ftpSettingsUserLabel;
	ld hl, ftpsettingsuserlabel
; 511     printHLStr();
	call printhlstr
; 512     
; 513     hl = ftpSettingsEditViewPasswordLabelPos;
	ld hl, (ftpsettingseditviewpasswordlabel)
; 514     setPosCursor();
	call setposcursor
; 515     hl = ftpSettingsEditViewPasswordLabel;
	ld hl, ftpsettingseditviewpasswordlabel_0
; 516     printHLStr();
	call printhlstr
; 517     
; 518     hl = ftpSettingsEditViewOkLabelPos;
	ld hl, (ftpsettingseditviewoklabelpos)
; 519     setPosCursor();
	call setposcursor
; 520     hl = ftpSettingsEditViewOkLabel;
	ld hl, ftpsettingseditviewoklabel
; 521     printHLStr();
	jp printhlstr
; 522 }
; 523 
; 524 void needOpenFTPSettingsEditView() {
needopenftpsettingseditview:
; 525     push_pop(hl) {
	push hl
; 526         if ((a = rootViewCurrentView) != rootViewCurrentFTPSettingsEditView) { //Если уже открыты настройки - не открываем
	ld a, (rootviewcurrentview)
	cp 2
	jp z, l_89
; 527             if ((a = rootViewCurrentView) != rootViewCurrentWiFiSettingsEditView) { //Если открыта настройка WiFi тоже не открываем
	ld a, (rootviewcurrentview)
	cp 3
	jp z, l_91
; 528                 
; 529                 a = rootViewCurrentFTPSettingsEditView;
	ld a, 2
; 530                 rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 531                 a = 4;
	ld a, 4
; 532                 ftpSettingsEditViewCurrentPos = a;
	ld (ftpsettingseditviewcurrentpos), a
; 533                 
; 534                 showDiskList(); //Сбросить выделение строки
	call showdisklist
; 535                 showFtpSettingsEditView();
	call showftpsettingseditview
; 536                 ftpSettingsEditViewDataUpdate();
	call ftpsettingseditviewdataupdate
l_91:
l_89:
	pop hl
	ret
; 537             }
; 538         }
; 539     }
; 540 }
; 541 
; 542 void ftpSettingsEditViewSelectEditField() {
ftpsettingseditviewselecteditfie:
; 543     a = ftpSettingsEditViewCurrentPos;
	ld a, (ftpsettingseditviewcurrentpos)
; 544     if (a == 0) {
	or a
	jp nz, l_93
; 545         hl = ftpSettingsEditViewIpValPos;
	ld hl, (ftpsettingseditviewipvalpos)
; 546         ftpSettingsEditViewEditValuePos = hl;
	ld (ftpsettingseditvieweditvaluepos), hl
; 547         setPosCursor();
	call setposcursor
; 548         
; 549         push_pop(hl) {
	push hl
; 550             hl = ftpSettingsIpValue;
	ld hl, ftpsettingsipvalue
; 551             ftpSettingsEditView_CopyStrFromHL();
	call ftpsettingseditview_copystrfromh
	pop hl
	jp l_94
l_93:
; 552         }
; 553     } else if (a == 1) {
	cp 1
	jp nz, l_95
; 554         hl = ftpSettingsEditViewPortValPos;
	ld hl, (ftpsettingseditviewportvalpos)
; 555         ftpSettingsEditViewEditValuePos = hl;
	ld (ftpsettingseditvieweditvaluepos), hl
; 556         setPosCursor();
	call setposcursor
; 557         
; 558         push_pop(hl) {
	push hl
; 559             hl = ftpSettingsPortValue;
	ld hl, ftpsettingsportvalue
; 560             ftpSettingsEditView_CopyStrFromHL();
	call ftpsettingseditview_copystrfromh
	pop hl
	jp l_96
l_95:
; 561         }
; 562     } else if (a == 2) {
	cp 2
	jp nz, l_97
; 563         hl = ftpSettingsEditViewUserValPos;
	ld hl, (ftpsettingseditviewuservalpos)
; 564         ftpSettingsEditViewEditValuePos = hl;
	ld (ftpsettingseditvieweditvaluepos), hl
; 565         setPosCursor();
	call setposcursor
; 566         
; 567         push_pop(hl) {
	push hl
; 568             hl = ftpSettingsUserValue;
	ld hl, ftpsettingsuservalue
; 569             ftpSettingsEditView_CopyStrFromHL();
	call ftpsettingseditview_copystrfromh
	pop hl
	jp l_98
l_97:
; 570         }
; 571     } else if (a == 3) {
	cp 3
	jp nz, l_99
; 572         hl = ftpSettingsEditViewPasswordValPos;
	ld hl, (ftpsettingseditviewpasswordvalpo)
; 573         ftpSettingsEditViewEditValuePos = hl;
	ld (ftpsettingseditvieweditvaluepos), hl
; 574         setPosCursor();
	call setposcursor
; 575         
; 576         push_pop(hl) {
	push hl
; 577             hl = ftpSettingsEditViewPasswordVal;
	ld hl, ftpsettingseditviewpasswordval
; 578             ftpSettingsEditView_CopyStrFromHL();
	call ftpsettingseditview_copystrfromh
	pop hl
l_99:
l_98:
l_96:
l_94:
; 579         }
; 580     }
; 581     ftpSettingsEditViewEditField();
	jp ftpsettingseditvieweditfield
; 582 }
; 583 
; 584 void ftpSettingsEditViewSaveEditValueToHL() {
ftpsettingseditviewsaveeditvalue:
; 585     push_pop(de) {
	push de
; 586         push_pop(bc) {
	push bc
; 587             de = ftpSettingsEditViewEditValue;
	ld de, ftpsettingseditvieweditvalue
; 588             a = ftpSettingsEditViewEditPos;
	ld a, (ftpsettingseditvieweditpos)
; 589             c = a;
	ld c, a
; 590             b = 0;
	ld b, 0
; 591             do {
l_101:
; 592                 a = *de;
	ld a, (de)
; 593                 *hl = a;
	ld (hl), a
; 594                 hl++;
	inc hl
; 595                 de++;
	inc de
; 596                 b++;
	inc b
; 597                 a = b;
	ld a, b
; 598                 a -= c;
	sub c
l_102:
	jp nz, l_101
; 599             } while (flag_nz);
; 600             *hl = 0;
	ld (hl), 0
	pop bc
	pop de
	ret
; 601         }
; 602     }
; 603 }
; 604 
; 605 void ftpSettingsEditView_CopyStrFromHL() {
ftpsettingseditview_copystrfromh:
; 606     push_pop(de) {
	push de
; 607         push_pop(bc) {
	push bc
; 608             de = ftpSettingsEditViewEditValue;
	ld de, ftpsettingseditvieweditvalue
; 609             b = 0;
	ld b, 0
; 610             c = 0;
	ld c, 0
; 611             do {
l_104:
; 612                 a = *hl;
	ld a, (hl)
; 613                 *de = a;
	ld (de), a
; 614                 if ((a = b) == 22) {
	ld a, b
	cp 22
	jp nz, l_107
; 615                     a = 0;
	ld a, 0
; 616                     *de = a;
	ld (de), a
	jp l_108
l_107:
; 617                 } else if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_109
; 618                     a = ' ';
	ld a, 32
; 619                     *de = a;
	ld (de), a
	jp l_110
l_109:
; 620                 } else if ((a = *de) == 0) {
	ld a, (de)
	or a
	jp nz, l_111
; 621                     c = 1;
	ld c, 1
; 622                     a = ' ';
	ld a, 32
; 623                     *de = a;
	ld (de), a
; 624                     a = b;
	ld a, b
; 625                     ftpSettingsEditViewEditPos = a;
	ld (ftpsettingseditvieweditpos), a
l_111:
l_110:
l_108:
; 626                 }
; 627                 
; 628                 hl ++;
	inc hl
; 629                 de++;
	inc de
; 630                 b++;
	inc b
; 631                 a = b;
	ld a, b
; 632                 a -= 23;
	sub 23
l_105:
	jp nz, l_104
	pop bc
	pop de
	ret
; 633             } while (flag_nz);
; 634         }
; 635     }
; 636 }
; 637 
; 638 void ftpSettingsEditViewEditField() {
ftpsettingseditvieweditfield:
; 639     hl = ftpSettingsEditViewEditValuePos;
	ld hl, (ftpsettingseditvieweditvaluepos)
; 640     setPosCursor();
	call setposcursor
; 641     
; 642     a = 0xFF;
	ld a, 255
; 643     inverceAddress = a;
	ld (inverceaddress), a
; 644     
; 645     hl = ftpSettingsEditViewEditValue;
	ld hl, ftpsettingseditvieweditvalue
; 646     printHLStr();
	call printhlstr
; 647     
; 648     ftpSettingsEditViewSetEditCursor();
	call ftpsettingseditviewseteditcursor
; 649     push_pop(bc) {
	push bc
; 650         b = 0;
	ld b, 0
; 651         do {
l_113:
; 652             getKeyboardCharA();
	call getkeyboardchara
; 653             
; 654             if (a == 0x1B) { // выход из редактирования без сохранения
	cp 27
	jp nz, l_116
; 655                 b = 1;
	ld b, 1
	jp l_117
l_116:
; 656             } else if (a == 0x0D) { // Сохранить и выйти из редактирования
	cp 13
	jp nz, l_118
; 657                 b = 1;
	ld b, 1
; 658                 ftpSettingsEditViewSaveField();
	call ftpsettingseditviewsavefield
	jp l_119
l_118:
; 659             } else if (a >= 0x20) {
	cp 32
	jp c, l_120
; 660                 if (a < 0x7F) { //Ввод символа
	cp 127
	jp nc, l_122
; 661                     c = a;
	ld c, a
; 662                     // Если достигли предела - то перемещаем курсор на 1 назад
; 663                     a = ftpSettingsEditViewEditPos;
	ld a, (ftpsettingseditvieweditpos)
; 664                     if (a >= 15) {
	cp 15
	jp c, l_124
; 665                         a--;
	dec a
l_124:
; 666                     }
; 667                     ftpSettingsEditViewEditPos = a;
	ld (ftpsettingseditvieweditpos), a
; 668                     
; 669                     //Сохраняем символ
; 670                     a = c;
	ld a, c
; 671                     ftpSettingsEditViewSetValueA();
	call ftpsettingseditviewsetvaluea
; 672                     a = ftpSettingsEditViewEditPos;
	ld a, (ftpsettingseditvieweditpos)
; 673                     a++;
	inc a
; 674                     ftpSettingsEditViewEditPos = a;
	ld (ftpsettingseditvieweditpos), a
; 675                     ftpSettingsEditViewSetEditCursor();
	call ftpsettingseditviewseteditcursor
	jp l_123
l_122:
; 676                 } else if (a == 0x7F) { //Забой... (удаление символа)
	cp 127
	jp nz, l_126
; 677                     if ((a = ftpSettingsEditViewEditPos) > 0) {
	ld a, (ftpsettingseditvieweditpos)
	or a
	jp z, l_128
; 678                         a--;
	dec a
; 679                         ftpSettingsEditViewEditPos = a;
	ld (ftpsettingseditvieweditpos), a
; 680                         ftpSettingsEditViewSetEditCursor();
	call ftpsettingseditviewseteditcursor
; 681                         a = ' ';
	ld a, 32
; 682                         ftpSettingsEditViewSetValueA();
	call ftpsettingseditviewsetvaluea
l_128:
l_126:
l_123:
l_120:
l_119:
l_117:
; 683                     }
; 684                 }
; 685             }
; 686             
; 687             a = b;
	ld a, b
; 688             a -= 1;
	sub 1
l_114:
	jp nz, l_113
	pop bc
; 689         } while (flag_nz);
; 690     }
; 691     
; 692     a = 0x00;
	ld a, 0
; 693     inverceAddress = a;
	ld (inverceaddress), a
; 694     
; 695     showFtpSettingsEditView();
	call showftpsettingseditview
; 696     ftpSettingsEditViewDataUpdate();
	jp ftpsettingseditviewdataupdate
; 697 }
; 698 
; 699 void ftpSettingsEditViewSetValueA() {
ftpsettingseditviewsetvaluea:
; 700     push_pop(hl) {
	push hl
; 701         push_pop(bc) {
	push bc
; 702             b = a;
	ld b, a
; 703             //Сохраним символ в ftpSettingsEditViewEditValue
; 704             hl = ftpSettingsEditViewEditValue;
	ld hl, ftpsettingseditvieweditvalue
; 705             a = ftpSettingsEditViewEditPos;
	ld a, (ftpsettingseditvieweditpos)
; 706             a += l;
	add l
; 707             l = a;
	ld l, a
; 708             if (flag_c) {
	jp nc, l_130
; 709                 h++;
	inc h
l_130:
; 710             }
; 711             *hl = b;
	ld (hl), b
; 712             //Отрисуем символ на экране
; 713             ftpSettingsEditViewSetEditCursor();
	call ftpsettingseditviewseteditcursor
; 714             a = b;
	ld a, b
; 715             printChatA();
	call printchata
; 716             ftpSettingsEditViewSetEditCursor();
	call ftpsettingseditviewseteditcursor
	pop bc
	pop hl
	ret
; 717         }
; 718     }
; 719 }
; 720 
; 721 void ftpSettingsEditViewSetEditCursor() {
ftpsettingseditviewseteditcursor:
; 722     push_pop(hl) {
	push hl
; 723         hl = ftpSettingsEditViewEditValuePos;
	ld hl, (ftpsettingseditvieweditvaluepos)
; 724         a = ftpSettingsEditViewEditPos;
	ld a, (ftpsettingseditvieweditpos)
; 725         a += l;
	add l
; 726         l = a;
	ld l, a
; 727         setPosCursor();
	call setposcursor
	pop hl
	ret
; 728     }
; 729 }
; 730 
; 731 void ftpSettingsEditViewDataUpdate() {
ftpsettingseditviewdataupdate:
; 732     if ((a = rootViewCurrentView) != rootViewCurrentFTPSettingsEditView) {
	ld a, (rootviewcurrentview)
	cp 2
	jp z, l_132
; 733         return;
	ret
l_132:
; 734     }
; 735     
; 736     push_pop(bc) {
	push bc
; 737         b = 0;
	ld b, 0
; 738         do {
l_134:
; 739             a = 0x00;
	ld a, 0
; 740             inverceAddress = a;
	ld (inverceaddress), a
; 741             
; 742             if ((a = ftpSettingsEditViewCurrentPos) == b) {
	ld a, (ftpsettingseditviewcurrentpos)
	cp b
	jp nz, l_137
; 743                 a = 0xFF;
	ld a, 255
; 744                 inverceAddress = a;
	ld (inverceaddress), a
l_137:
; 745             }
; 746             
; 747             a = b;
	ld a, b
; 748             ftpSettingsEditViewShowValueA();
	call ftpsettingseditviewshowvaluea
; 749             
; 750             a = 0x00;
	ld a, 0
; 751             inverceAddress = a;
	ld (inverceaddress), a
; 752             
; 753             b++;
	inc b
; 754             a = b;
	ld a, b
; 755             a -= 5;
	sub 5
l_135:
	jp nz, l_134
	pop bc
	ret
; 11 void ftpSettingsEditViewShowValueA() {
ftpsettingseditviewshowvaluea:
; 12     if (a == 0) {
	or a
	jp nz, l_139
; 13         hl = ftpSettingsEditViewIpValPos;
	ld hl, (ftpsettingseditviewipvalpos)
; 14         setPosCursor();
	call setposcursor
; 15         
; 16         hl = ftpSettingsIpValue;
	ld hl, ftpsettingsipvalue
; 17         printHLStr();
	call printhlstr
	jp l_140
l_139:
; 18     } else if (a == 1) {
	cp 1
	jp nz, l_141
; 19         hl = ftpSettingsEditViewPortValPos;
	ld hl, (ftpsettingseditviewportvalpos)
; 20         setPosCursor();
	call setposcursor
; 21         
; 22         hl = ftpSettingsPortValue;
	ld hl, ftpsettingsportvalue
; 23         printHLStr();
	call printhlstr
	jp l_142
l_141:
; 24     } else if (a == 2) {
	cp 2
	jp nz, l_143
; 25         hl = ftpSettingsEditViewUserValPos;
	ld hl, (ftpsettingseditviewuservalpos)
; 26         setPosCursor();
	call setposcursor
; 27         
; 28         hl = ftpSettingsUserValue;
	ld hl, ftpsettingsuservalue
; 29         printHLStr();
	call printhlstr
	jp l_144
l_143:
; 30     } else if (a == 3) {
	cp 3
	jp nz, l_145
; 31         hl = ftpSettingsEditViewPasswordValPos;
	ld hl, (ftpsettingseditviewpasswordvalpo)
; 32         setPosCursor();
	call setposcursor
; 33         
; 34         hl = ftpSettingsEditViewPasswordVal;
	ld hl, ftpsettingseditviewpasswordval
; 35         printHLStr();
	call printhlstr
	jp l_146
l_145:
; 36     } else if (a == 4) {
	cp 4
	jp nz, l_147
; 37         hl = ftpSettingsEditViewOkLabelPos;
	ld hl, (ftpsettingseditviewoklabelpos)
; 38         setPosCursor();
	call setposcursor
; 39         hl = ftpSettingsEditViewOkLabel;
	ld hl, ftpsettingseditviewoklabel
; 40         printHLStr();
	call printhlstr
l_147:
l_146:
l_144:
l_142:
l_140:
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
	jp nz, l_149
; 47         hl = ftpSettingsIpValue;
	ld hl, ftpsettingsipvalue
	jp l_150
l_149:
; 48     } else if (a == 1) {
	cp 1
	jp nz, l_151
; 49         hl = ftpSettingsPortValue;
	ld hl, ftpsettingsportvalue
	jp l_152
l_151:
; 50     } else if (a == 2) {
	cp 2
	jp nz, l_153
; 51         hl = ftpSettingsUserValue;
	ld hl, ftpsettingsuservalue
	jp l_154
l_153:
; 52     } else if (a == 3) {
	cp 3
	jp nz, l_155
; 53         hl = ftpSettingsEditViewPasswordVal;
	ld hl, ftpsettingseditviewpasswordval
l_155:
l_154:
l_152:
l_150:
; 54     }
; 55     ftpSettingsEditViewSaveEditValueToHL();
	call ftpsettingseditviewsaveeditvalue
; 56     //Save ESP
; 57     a = ftpSettingsEditViewCurrentPos;
	ld a, (ftpsettingseditviewcurrentpos)
; 58     if (a == 0) {
	or a
	jp nz, l_157
; 59         setFTPUrl();
	call setftpurl
	jp l_158
l_157:
; 60     } else if (a == 1) {
	cp 1
	jp nz, l_159
; 61         setFTPPort();
	call setftpport
	jp l_160
l_159:
; 62     } else if (a == 2) {
	cp 2
	jp nz, l_161
; 63         setFTPUser();
	call setftpuser
	jp l_162
l_161:
; 64     } else if (a == 3) {
	cp 3
	jp nz, l_163
; 65         setFTPPassword();
	call setftppassword
l_163:
l_162:
l_160:
l_158:
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
	jp nz, l_165
; 73             a = l;
	ld a, l
; 74             if (a == 0x1B) { //ESC выход из настройки
	cp 27
	jp nz, l_167
; 75                 a = rootViewCurrentDiskView; // переходим на список файлов на диске
	ld a, 0
; 76                 rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 77                 
; 78                 updateRootUI();
	call updaterootui
; 79                 updateRootDataUI();
	call updaterootdataui
	jp l_168
l_167:
; 80             } else {
; 81                 if (a == 0x1A) { //down
	cp 26
	jp nz, l_169
; 82                     a = ftpSettingsEditViewCurrentPos;
	ld a, (ftpsettingseditviewcurrentpos)
; 83                     a++;
	inc a
; 84                     if (a == 5) {
	cp 5
	jp nz, l_171
; 85                         a = 0;
	ld a, 0
l_171:
; 86                     }
; 87                     ftpSettingsEditViewCurrentPos = a;
	ld (ftpsettingseditviewcurrentpos), a
	jp l_170
l_169:
; 88                 } else if (a == 0x19) { //up
	cp 25
	jp nz, l_173
; 89                     a = ftpSettingsEditViewCurrentPos;
	ld a, (ftpsettingseditviewcurrentpos)
; 90                     if (a == 0) {
	or a
	jp nz, l_175
; 91                         a = 4;
	ld a, 4
	jp l_176
l_175:
; 92                     } else {
; 93                         a--;
	dec a
l_176:
; 94                     }
; 95                     ftpSettingsEditViewCurrentPos = a;
	ld (ftpsettingseditviewcurrentpos), a
	jp l_174
l_173:
; 96                 } else if (a == 0x0D) { //Enter
	cp 13
	jp nz, l_177
; 97                     /// и подключиться к FTP
; 98                     needFtpConnect();
	call needftpconnect
; 99                     ///
; 100                     if ((a = ftpSettingsEditViewCurrentPos) == 4) { // Нажатие на кнопку ОК
	ld a, (ftpsettingseditviewcurrentpos)
	cp 4
	jp nz, l_179
; 101                         a = rootViewCurrentDiskView; // переходим на список файлов на диске
	ld a, 0
; 102                         rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 103                         
; 104                         updateRootUI();
	call updaterootui
; 105                         updateRootDataUI();
	call updaterootdataui
	jp l_180
l_179:
; 106                     } else {
; 107                         ftpSettingsEditViewSelectEditField();
	call ftpsettingseditviewselecteditfie
l_180:
l_177:
l_174:
l_170:
l_168:
l_165:
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
	jp nc, l_181
; 118         a++;
	inc a
; 119         updateFtpStatusTike = a;
	ld (updateftpstatustike), a
; 120         return;
	ret
l_181:
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
	jp nz, l_183
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
	jp nz, l_185
; 142             needUpdateFtpList();
	call needupdateftplist
l_185:
l_183:
	ret
; 11 void needOpenWiFiSettingsEditView() {
needopenwifisettingseditview:
; 12     push_pop(hl) {
	push hl
; 13         if ((a = rootViewCurrentView) != rootViewCurrentWiFiSettingsEditView) { //Если уже открыты настройки - не открываем
	ld a, (rootviewcurrentview)
	cp 3
	jp z, l_187
; 14             if ((a = rootViewCurrentView) != rootViewCurrentFTPSettingsEditView) { //Если открыта настройка WiFi тоже не открываем
	ld a, (rootviewcurrentview)
	cp 2
	jp z, l_189
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
l_189:
l_187:
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
	jp z, l_191
; 60         return;
	ret
l_191:
; 61     }
; 62     
; 63     push_pop(bc) {
	push bc
; 64         b = 0;
	ld b, 0
; 65         do {
l_193:
; 66             a = 0x00;
	ld a, 0
; 67             inverceAddress = a;
	ld (inverceaddress), a
; 68             
; 69             if ((a = wifiSettingsEditViewCurrentPos) == b) {
	ld a, (wifisettingseditviewcurrentpos)
	cp b
	jp nz, l_196
; 70                 a = 0xFF;
	ld a, 255
; 71                 inverceAddress = a;
	ld (inverceaddress), a
l_196:
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
l_194:
	jp nz, l_193
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
	jp nz, l_198
; 89         hl = wifiSettingsEditViewSSIDValPos;
	ld hl, (wifisettingseditviewssidvalpos)
; 90         setPosCursor();
	call setposcursor
; 91         
; 92         hl = wifiSettingsSsidVal;
	ld hl, wifisettingsssidval
; 93         printHLStr();
	call printhlstr
	jp l_199
l_198:
; 94     } else if (a == 1) {
	cp 1
	jp nz, l_200
; 95         hl = wifiSettingsEditViewSSIDPasswordValPos;
	ld hl, (wifisettingseditviewssidpassword_2)
; 96         setPosCursor();
	call setposcursor
; 97         
; 98         hl = wifiSettingsEditViewSSIDPasswordVal;
	ld hl, wifisettingseditviewssidpassword_3
; 99         printHLStr();
	call printhlstr
	jp l_201
l_200:
; 100     } else if (a == 2) {
	cp 2
	jp nz, l_202
; 101         hl = wifiSettingsEditViewOkLabelPos;
	ld hl, (wifisettingseditviewoklabelpos)
; 102         setPosCursor();
	call setposcursor
; 103         hl = wifiSettingsEditViewOkLabel;
	ld hl, wifisettingseditviewoklabel
; 104         printHLStr();
	call printhlstr
l_202:
l_201:
l_199:
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
	jp nz, l_204
; 112             a = l;
	ld a, l
; 113             if (a == 0x1B) { //ESC выход из настройки
	cp 27
	jp nz, l_206
; 114                 a = rootViewCurrentDiskView; // переходим на список файлов на диске
	ld a, 0
; 115                 rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 116                 
; 117                 updateRootUI();
	call updaterootui
; 118                 updateRootDataUI();
	call updaterootdataui
	jp l_207
l_206:
; 119             } else {
; 120                 if (a == 0x1A) { //down
	cp 26
	jp nz, l_208
; 121                     a = wifiSettingsEditViewCurrentPos;
	ld a, (wifisettingseditviewcurrentpos)
; 122                     a++;
	inc a
; 123                     if (a == 3) {
	cp 3
	jp nz, l_210
; 124                         a = 0;
	ld a, 0
l_210:
; 125                     }
; 126                     wifiSettingsEditViewCurrentPos = a;
	ld (wifisettingseditviewcurrentpos), a
	jp l_209
l_208:
; 127                 } else if (a == 0x19) { //up
	cp 25
	jp nz, l_212
; 128                     a = wifiSettingsEditViewCurrentPos;
	ld a, (wifisettingseditviewcurrentpos)
; 129                     if (a == 0) {
	or a
	jp nz, l_214
; 130                         a = 2;
	ld a, 2
	jp l_215
l_214:
; 131                     } else {
; 132                         a--;
	dec a
l_215:
; 133                     }
; 134                     wifiSettingsEditViewCurrentPos = a;
	ld (wifisettingseditviewcurrentpos), a
	jp l_213
l_212:
; 135                 } else if (a == 0x0D) { //Enter
	cp 13
	jp nz, l_216
; 136                     if ((a = wifiSettingsEditViewCurrentPos) == 2) { // Нажатие на кнопку ОК
	ld a, (wifisettingseditviewcurrentpos)
	cp 2
	jp nz, l_218
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
	jp l_219
l_218:
; 146                     } else {
; 147                         wifiSettingsEditViewSelectEditField();
	call wifisettingseditviewselecteditfi
l_219:
l_216:
l_213:
l_209:
l_207:
l_204:
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
	jp nz, l_220
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
	jp l_221
l_220:
; 165         }
; 166     } else {
; 167         // открыть список доступных сетей
; 168         needOpenSSIDListView();
	call needopenssidlistview
; 169         return;
	ret
l_221:
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
l_222:
; 181                 a = *hl;
	ld a, (hl)
; 182                 *de = a;
	ld (de), a
; 183                 if ((a = b) == 22) {
	ld a, b
	cp 22
	jp nz, l_225
; 184                     a = 0;
	ld a, 0
; 185                     *de = a;
	ld (de), a
	jp l_226
l_225:
; 186                 } else if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_227
; 187                     a = ' ';
	ld a, 32
; 188                     *de = a;
	ld (de), a
	jp l_228
l_227:
; 189                 } else if ((a = *de) == 0) {
	ld a, (de)
	or a
	jp nz, l_229
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
l_229:
l_228:
l_226:
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
l_223:
	jp nz, l_222
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
l_231:
; 221             getKeyboardCharA();
	call getkeyboardchara
; 222             
; 223             if (a == 0x1B) { // выход из редактирования без сохранения
	cp 27
	jp nz, l_234
; 224                 b = 1;
	ld b, 1
	jp l_235
l_234:
; 225             } else if (a == 0x0D) { // Сохранить и выйти из редактирования
	cp 13
	jp nz, l_236
; 226                 b = 1;
	ld b, 1
; 227                 wifiSettingsEditViewSaveField();
	call wifisettingseditviewsavefield
	jp l_237
l_236:
; 228             } else if (a >= 0x20) {
	cp 32
	jp c, l_238
; 229                 if (a < 0x7F) { //Ввод символа
	cp 127
	jp nc, l_240
; 230                     c = a;
	ld c, a
; 231                     // Если достигли предела - то перемещаем курсор на 1 назад
; 232                     a = wifiSettingsEditViewEditPos;
	ld a, (wifisettingseditvieweditpos)
; 233                     if (a >= 15) {
	cp 15
	jp c, l_242
; 234                         a--;
	dec a
l_242:
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
	jp l_241
l_240:
; 245                 } else if (a == 0x7F) { //Забой... (удаление символа)
	cp 127
	jp nz, l_244
; 246                     if ((a = wifiSettingsEditViewEditPos) > 0) {
	ld a, (wifisettingseditvieweditpos)
	or a
	jp z, l_246
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
l_246:
l_244:
l_241:
l_238:
l_237:
l_235:
; 252                     }
; 253                 }
; 254             }
; 255             
; 256             a = b;
	ld a, b
; 257             a -= 1;
	sub 1
l_232:
	jp nz, l_231
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
	jp nz, l_248
; 281         hl = wifiSettingsEditViewSSIDPasswordVal;
	ld hl, wifisettingseditviewssidpassword_3
l_248:
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
	jp nc, l_250
; 296                 h++;
	inc h
l_250:
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
l_252:
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
l_253:
	jp nz, l_252
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
	jp nc, l_255
; 336         a++;
	inc a
; 337         updateWiFiStatusTike = a;
	ld (updatewifistatustike), a
; 338         return;
	ret
l_255:
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
	jp nz, l_257
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
l_257:
	ret
; 13 void needOpenSSIDListView() {
needopenssidlistview:
; 14     push_pop(hl) {
	push hl
; 15         if ((a = rootViewCurrentView) != rootSSIDListView) { //Если уже открыто окно - не открываем
	ld a, (rootviewcurrentview)
	cp 4
	jp z, l_259
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
l_259:
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
l_261:
; 39                     a = *hl;
	ld a, (hl)
; 40                     if (a > 0) {
	or a
	jp z, l_264
; 41                         a = SSIDListCount;
	ld a, (ssidlistcount)
; 42                         a++;
	inc a
; 43                         SSIDListCount = a;
	ld (ssidlistcount), a
l_264:
; 44                     }
; 45                     hl += de;
	add hl, de
; 46                     b--;
	dec b
l_262:
	jp nz, l_261
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
l_266:
; 99                     a = 0;
	ld a, 0
; 100                     *hl = a;
	ld (hl), a
; 101                     hl += de;
	add hl, de
; 102                     b--;
	dec b
l_267:
	jp nz, l_266
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
	jp z, l_269
; 111         return;
	ret
l_269:
; 112     }
; 113     
; 114     push_pop(bc) {
	push bc
; 115         b = 0;
	ld b, 0
; 116         do {
l_271:
; 117             a = 0x00;
	ld a, 0
; 118             inverceAddress = a;
	ld (inverceaddress), a
; 119             
; 120             if ((a = SSIDListViewCurrentPos) == b) {
	ld a, (ssidlistviewcurrentpos)
	cp b
	jp nz, l_274
; 121                 a = 0xFF;
	ld a, 255
; 122                 inverceAddress = a;
	ld (inverceaddress), a
l_274:
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
l_272:
	jp nz, l_271
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
	jp z, l_276
; 148                 do {
l_278:
; 149                     hl += de;
	add hl, de
; 150                     c--;
	dec c
l_279:
	jp nz, l_278
l_276:
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
	jp nz, l_281
; 162             a = l;
	ld a, l
; 163             if (a == 0x1B) { //ESC выход из настройки
	cp 27
	jp nz, l_283
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
	jp l_284
l_283:
; 170             } else {
; 171                 a = SSIDListCount;
	ld a, (ssidlistcount)
; 172                 h = a;
	ld h, a
; 173                 a = l;
	ld a, l
; 174                 if (a == 0x1A) { //down
	cp 26
	jp nz, l_285
; 175                     a = SSIDListViewCurrentPos;
	ld a, (ssidlistviewcurrentpos)
; 176                     a++;
	inc a
; 177                     if (a == h) {
	cp h
	jp nz, l_287
; 178                         a = 0;
	ld a, 0
l_287:
; 179                     }
; 180                     SSIDListViewCurrentPos = a;
	ld (ssidlistviewcurrentpos), a
	jp l_286
l_285:
; 181                 } else if (a == 0x19) { //up
	cp 25
	jp nz, l_289
; 182                     a = SSIDListViewCurrentPos;
	ld a, (ssidlistviewcurrentpos)
; 183                     if (a == 0) {
	or a
	jp nz, l_291
; 184                         a = h;
	ld a, h
; 185                         a--;
	dec a
	jp l_292
l_291:
; 186                     } else {
; 187                         a--;
	dec a
l_292:
; 188                     }
; 189                     SSIDListViewCurrentPos = a;
	ld (ssidlistviewcurrentpos), a
	jp l_290
l_289:
; 190                 } else if (a == 0x0D) { //Enter
	cp 13
	jp nz, l_293
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
l_293:
l_290:
l_286:
l_284:
l_281:
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
; 32 uint8_t wifiSettingsEmpty18[18] = "                ";
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
	ds 2
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
; 25 uint8_t ftpViewEmpty16[16] = "               ";
ftpviewempty16:
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
; 27 uint8_t ftpViewDirPath[26] = "";
ftpviewdirpath:
	ds 26
; 28 uint16_t ftpViewDirPathPos = 0x1822;
ftpviewdirpathpos:
	dw 6178
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
l_295:
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
l_296:
	jp nz, l_295
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
; 17 void initI2C() {
initi2c:
; 18     a = 0x81;
	ld a, 129
; 19     VV55_SETUP = a;
	ld (vv55_setup), a
; 20     #ifdef _SLOW_SETTINGS
; 21     NOPS
	nop
	nop
; 22     #endif
; 23     a = 0xC0;
	ld a, 192
; 24     VV55_PORT_C = a;
	ld (vv55_port_c), a
	ret
; 25 }
; 26 
; 27 void startI2C() {
starti2c:
; 28     #ifdef _SLOW_SETTINGS
; 29     NOPS
	nop
	nop
; 30     #endif
; 31     a = 0x40;
	ld a, 64
; 32     VV55_PORT_C = a;
	ld (vv55_port_c), a
; 33     #ifdef _SLOW_SETTINGS
; 34     NOPS
	nop
	nop
; 35     #endif
; 36     nop();
	nop
; 37     a = 0x00;
	ld a, 0
; 38     VV55_PORT_C = a;
	ld (vv55_port_c), a
	ret
; 39 }
; 40 
; 41 void stopI2C() {
stopi2c:
; 42     #ifdef _SLOW_SETTINGS
; 43     NOPS
	nop
	nop
; 44     #endif
; 45     a = 0x40;
	ld a, 64
; 46     VV55_PORT_C = a;
	ld (vv55_port_c), a
; 47     #ifdef _SLOW_SETTINGS
; 48     NOPS
	nop
	nop
; 49     #endif
; 50     nop();
	nop
; 51     a = 0xC0;
	ld a, 192
; 52     VV55_PORT_C = a;
	ld (vv55_port_c), a
	ret
; 53 }
; 54 
; 55 /// вх. [A] - устанавливаемое значение (8 бит)
; 56 void setSDAI2C(){
setsdai2c:
; 57 //    #ifdef _SLOW_SETTINGS
; 58 //    NOPS
; 59 //    #endif
; 60     a &= 0x80;
	and 128
; 61     I2C_CURRETN_VALUE = a;
	ld (i2c_curretn_value), a
; 62     VV55_PORT_C = a;
	ld (vv55_port_c), a
	ret
; 63 }
; 64 
; 65 void pulseNewI2C() {
pulsenewi2c:
; 66     #ifdef _SLOW_SETTINGS
; 67     NOPS
	nop
	nop
; 68     #endif
; 69     a = I2C_CURRETN_VALUE;
	ld a, (i2c_curretn_value)
; 70     a += 0x40;
	add 64
; 71     VV55_PORT_C = a;
	ld (vv55_port_c), a
; 72 //    /// - Проверим что SLAVE не тормозит передачу -
; 73 //    /// - После установки 1 - проверяем - есть ли 1 на SCL. Если там 0 - то ждем SLAVE
; 74 //    do {
; 75 //        a = VV55_PORT_C;
; 76 //        a &= 0x40;
; 77 //    } while (a != 0x40);
; 78 //    /// -------------------------------------
; 79     #ifdef _SLOW_SETTINGS
; 80     NOPS
	nop
	nop
; 81     #endif
; 82     nop();
	nop
; 83     a = I2C_CURRETN_VALUE;
	ld a, (i2c_curretn_value)
; 84     a += 0x00;
; 85     VV55_PORT_C = a;
	ld (vv55_port_c), a
	ret
; 86 }
; 87 
; 88 /// вх. [C] передаваемый байт
; 89 /// вых.[A]=0 - OK
; 90 void transmitNewI2C() {
transmitnewi2c:
; 91     push_pop(bc) {
	push bc
; 92         b = 8;
	ld b, 8
; 93         do {
l_298:
; 94             setSDAI2C(a = c);
	ld a, c
	call setsdai2c
; 95             pulseNewI2C();
	call pulsenewi2c
; 96             a = c;
	ld a, c
; 97             carry_rotate_left(a, 1);
	rla
; 98             c = a;
	ld c, a
; 99             b--;
	dec b
l_299:
	jp nz, l_298
; 100         } while (flag_nz);
; 101         
; 102         setSDAI2C(a = 0x80);
	ld a, 128
	call setsdai2c
; 103         a = VV55_PORT_C;
	ld a, (vv55_port_c)
; 104         a &= 1;
	and 1
; 105         b = a;
	ld b, a
; 106         setSDAI2C(a = 0x00);
	ld a, 0
	call setsdai2c
; 107         pulseNewI2C();
	call pulsenewi2c
; 108         a = b;
	ld a, b
	pop bc
	ret
; 109     }
; 110 }
; 111 
; 112 /// вых.[C] принятый байт
; 113 /// вых.[B] ACK/NAK
; 114 void recieveNewI2C() {
recievenewi2c:
; 115     push_pop(de) {
	push de
; 116         setSDAI2C(a = 0x80);
	ld a, 128
	call setsdai2c
; 117         c = 0;
	ld c, 0
; 118         d = 0x08;
	ld d, 8
; 119         do {
l_301:
; 120             a = c;
	ld a, c
; 121             carry_rotate_left(a, 1);
	rla
; 122             c = a;
	ld c, a
; 123             a = VV55_PORT_C; // READ BIT
	ld a, (vv55_port_c)
; 124             a &= 1;
	and 1
; 125             a += c;
	add c
; 126             c = a;
	ld c, a
; 127             pulseNewI2C();
	call pulsenewi2c
; 128             d--;
	dec d
; 129             a = d;
	ld a, d
l_302:
	jp nz, l_301
; 130         } while (flag_nz);
; 131 //        setSDAI2C(a = 0x80);
; 132 //        a &= 1;
; 133 //        b = a;
; 134 //        setSDAI2C(a = 0x00);
; 135 //        if ((a = b) == 0x01) {
; 136 //            setSDAI2C(a = 0x80);
; 137 //        } else {
; 138 //            setSDAI2C(a = 0x00);
; 139 //        }
; 140         
; 141         setSDAI2C(a = 0x00);
	ld a, 0
	call setsdai2c
; 142         
; 143         pulseNewI2C();
	call pulsenewi2c
; 144         
; 145         a = VV55_PORT_C;
	ld a, (vv55_port_c)
; 146         a &= 1;
	and 1
; 147         b = a;
	ld b, a
	pop de
	ret
; 148     }
; 149 }
; 150 
; 151 void readSDAState() {
readsdastate:
; 152     a = 0x80;
	ld a, 128
; 153     VV55_PORT_C = a;
	ld (vv55_port_c), a
; 154     nop();
	nop
; 155     a = VV55_PORT_C;
	ld a, (vv55_port_c)
; 156     a &= 1;
	and 1
; 157     if (a == 0) {
	or a
	jp nz, l_304
; 158         a = 0x01;
	ld a, 1
	jp l_305
l_304:
; 159     } else {
; 160         a = 0x00;
	ld a, 0
l_305:
	ret
; 161     }
; 162 }
; 163 
; 164 void needAccess() {
needaccess:
; 165     do {
l_306:
; 166         readSDAState();
	call readsdastate
; 167         if (a == 1) {
	cp 1
	jp nz, l_309
; 168             nop();
	nop
; 169             nop();
	nop
; 170             nop();
	nop
l_309:
l_307:
; 171         }
; 172     } while (a == 0x01);
	cp 1
	jp z, l_306
	ret
; 173 }
; 174 
; 175 /// вых.[B] - 1 устройство занято
; 176 void i2cBusy() {
i2cbusy:
; 177     a = VV55_PORT_C;
	ld a, (vv55_port_c)
; 178     a &= 2;
	and 2
; 179     carry_rotate_right(a, 1);
	rra
	ret
; 180 }
; 181 
; 182 /// Ожидание готовности I2C
; 183 void i2cWaitingForAccess() {
i2cwaitingforaccess:
; 184     do {
l_311:
; 185         i2cBusy();
	call i2cbusy
; 186         if (a == 1) {
	cp 1
	jp nz, l_314
; 187             nop();
	nop
; 188             nop();
	nop
; 189             nop();
	nop
; 190             nop();
	nop
; 191             nop();
	nop
l_314:
l_312:
; 192         }
; 193     } while (a == 1);
	cp 1
	jp z, l_311
	ret
; 194 }
; 195 
; 196 void delay5msI2C() {
delay5msi2c:
; 197     push_pop(bc) {
	push bc
; 198         bc = 0x500;
	ld bc, 1280
; 199         do {
l_316:
; 200             bc--;
	dec bc
; 201             a = b;
	ld a, b
; 202             a |= c;
	or c
l_317:
	jp nz, l_316
	pop bc
	ret
; 203         } while (flag_nz);
; 204     }
; 205 }
; 206 
; 207 void busRecoveryI2C() {
busrecoveryi2c:
; 208     startI2C();
	call starti2c
; 209     a = 0;
	ld a, 0
; 210     setSDAI2C();
	call setsdai2c
; 211     pulseNewI2C();
	call pulsenewi2c
; 212     pulseNewI2C();
	call pulsenewi2c
; 213     pulseNewI2C();
	call pulsenewi2c
; 214     pulseNewI2C();
	call pulsenewi2c
; 215     pulseNewI2C();
	call pulsenewi2c
; 216     pulseNewI2C();
	call pulsenewi2c
; 217     pulseNewI2C();
	call pulsenewi2c
; 218     pulseNewI2C();
	call pulsenewi2c
; 219     pulseNewI2C();
	call pulsenewi2c
; 220     stopI2C();
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
	jp z, l_319
; 32             h = d;
	ld h, d
; 33             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 34             do {
l_321:
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
l_322:
	jp nz, l_321
l_319:
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
l_324:
; 67                 push_pop(bc) {
	push bc
; 68                     // Если последний ожидаемый байт - то передаем NACK
; 69                     if ((a = l) == 1) {
	ld a, l
	cp 1
	jp nz, l_327
; 70                         b = 0x01;
	ld b, 1
	jp l_328
l_327:
; 71                     } else {
; 72                         b = 0x00;
	ld b, 0
l_328:
; 73                     }
; 74                     recieveNewI2C();
	call recievenewi2c
; 75 //                    if ((a = b) == 0x01) {
; 76 //                        l = 1;
; 77 //                    }
; 78                     a = c;
	ld a, c
	pop bc
; 79                 }
; 80                 *de = a;
	ld (de), a
; 81                 de++;
	inc de
; 82                 l--;
	dec l
l_325:
; 83             } while ((a = l) > 0);
	ld a, l
	or a
	jp nz, l_324
; 84             a = 0; // stop byte
	ld a, 0
; 85             *de = a;
	ld (de), a
; 86             //
; 87             stopI2C();
	call stopi2c
	pop de
	pop hl
	ret
; 88         }
; 89     }
; 90 }
; 91 
; 92 uint8_t ESP_I2S_BUFFER[32];
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
l_329:
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
l_332:
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
l_333:
	jp nz, l_332
	pop hl
	pop de
	pop af
; 53                         } while (flag_nz);
; 54                     }
; 55                 }
; 56             }
; 57             a = SSIDListNext;
	ld a, (ssidlistnext)
l_330:
; 58         } while (a != 0);
	or a
	jp nz, l_329
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
; 65         do {
l_335:
; 66             delay5msI2C();
	call delay5msi2c
; 67             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 68             l = 6;
	ld l, 6
; 69             h = 0;
	ld h, 0
; 70             sendCommand();
	call sendcommand
; 71             //
; 72             loadStringToHL(hl = wifiSettingsSsidVal);
	ld hl, wifisettingsssidval
	call loadstringtohl
l_336:
; 73         } while ((a = parsePageBufferIsCheck) != 1);
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_335
	pop hl
	ret
; 74     }
; 75 }
; 76 
; 77 /// Получить пароль wifi
; 78 void getSSIDPasswordValue() {
getssidpasswordvalue:
; 79     push_pop(hl) {
	push hl
; 80         push_pop(de) {
	push de
; 81             push_pop(bc) {
	push bc
; 82                 delay5msI2C();
	call delay5msi2c
; 83                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 84                 l = 8;
	ld l, 8
; 85                 h = 0;
	ld h, 0
; 86                 sendCommand();
	call sendcommand
; 87                 
; 88                 delay5msI2C();
	call delay5msi2c
; 89                 
; 90                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 91                 l = 26;
	ld l, 26
; 92                 readNewInBuffer();
	call readnewinbuffer
; 93                 
; 94                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 95                 hl = wifiSettingsEditViewSSIDPasswordVal;
	ld hl, wifisettingseditviewssidpassword_3
; 96                 b = 16;
	ld b, 16
; 97                 do {
l_338:
; 98                     a = *de;
	ld a, (de)
; 99                     if(a==0xFF){
	cp 255
	jp nz, l_341
; 100                         a = 0x00;
	ld a, 0
l_341:
; 101                     }
; 102                     *hl = a;
	ld (hl), a
; 103                     de++;
	inc de
; 104                     hl++;
	inc hl
; 105                     b--;
	dec b
l_339:
	jp nz, l_338
	pop bc
	pop de
	pop hl
	ret
; 106                 } while (flag_nz);
; 107             }
; 108         }
; 109     }
; 110 }
; 111 
; 112 /// Отправить пароль wifi
; 113 void setSSIDPasswordValue() {
setssidpasswordvalue:
; 114     push_pop(hl) {
	push hl
; 115         push_pop(de) {
	push de
; 116             push_pop(bc) {
	push bc
; 117                 de = wifiSettingsEditViewSSIDPasswordVal;
	ld de, wifisettingseditviewssidpassword_3
; 118                 hl = ESP_I2S_BUFFER;
	ld hl, esp_i2s_buffer
; 119                 b = 16;
	ld b, 16
; 120                 c = 0;
	ld c, 0
; 121                 do {
l_343:
; 122                     a = *de;
	ld a, (de)
; 123                     if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_346
; 124                         a = 0xFF;
	ld a, 255
	jp l_347
l_346:
; 125                     } else if((a = *de) == 0) {
	ld a, (de)
	or a
	jp nz, l_348
; 126                         c = 1;
	ld c, 1
; 127                         a = 0x00;
	ld a, 0
l_348:
l_347:
; 128                     }
; 129                     *hl = a;
	ld (hl), a
; 130                     de++;
	inc de
; 131                     hl++;
	inc hl
; 132                     b--;
	dec b
l_344:
	jp nz, l_343
; 133                 } while (flag_nz);
; 134                 
; 135                 delay5msI2C();
	call delay5msi2c
; 136                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 137                 l = 9;
	ld l, 9
; 138                 h = 16;
	ld h, 16
; 139                 sendCommand();
	call sendcommand
	pop bc
	pop de
	pop hl
	ret
; 140             }
; 141         }
; 142     }
; 143 }
; 144 
; 145 /// Подключиться в WiFi
; 146 void needSsidConnect() {
needssidconnect:
; 147     push_pop(hl) {
	push hl
; 148         delay5msI2C();
	call delay5msi2c
; 149         i2cWaitingForAccess();
	call i2cwaitingforaccess
; 150         l = 10;
	ld l, 10
; 151         h = 0;
	ld h, 0
; 152         sendCommand();
	call sendcommand
	pop hl
	ret
; 153     }
; 154 }
; 155 
; 156 /// Запросить обновление списка сетей
; 157 void needUpdateSSIDList() {
needupdatessidlist:
; 158     push_pop(hl) {
	push hl
; 159         delay5msI2C();
	call delay5msi2c
; 160         i2cWaitingForAccess();
	call i2cwaitingforaccess
; 161         l = 4;
	ld l, 4
; 162         h = 0;
	ld h, 0
; 163         sendCommand();
	call sendcommand
	pop hl
	ret
; 164     }
; 165 }
; 166 
; 167 /// Установить имя сети по номеру в списке
; 168 /// вх. [A] - номер сети
; 169 void setSSIDNumberA() {
setssidnumbera:
; 170     push_pop(de) {
	push de
; 171         push_pop(hl) {
	push hl
; 172             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 173             *de = a;
	ld (de), a
; 174             //
; 175             delay5msI2C();
	call delay5msi2c
; 176             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 177             //
; 178             l = 7; // SET_SSID
	ld l, 7
; 179             h = 1; // 1 байт
	ld h, 1
; 180             sendCommand();
	call sendcommand
	pop hl
	pop de
	ret
; 181         }
; 182     }
; 183 }
; 184 
; 185 /// Получить IP_Address
; 186 void getSSIDIPAddress() {
getssidipaddress:
; 187     push_pop(hl) {
	push hl
; 188         do {
l_350:
; 189             delay5msI2C();
	call delay5msi2c
; 190             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 191             l = 12;
	ld l, 12
; 192             h = 0;
	ld h, 0
; 193             sendCommand();
	call sendcommand
; 194             //
; 195             loadStringToHL(hl = wifiSettingsIpVal);
	ld hl, wifisettingsipval
	call loadstringtohl
l_351:
; 196         } while ((a = parsePageBufferIsCheck) != 1);
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_350
	pop hl
	ret
; 197     }
; 198 }
; 199 
; 200 /// Получить MAC_Address
; 201 void getSSIDMacAddress() {
getssidmacaddress:
; 202     push_pop(hl) {
	push hl
; 203         do {
l_353:
; 204             delay5msI2C();
	call delay5msi2c
; 205             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 206             l = 13;
	ld l, 13
; 207             h = 0;
	ld h, 0
; 208             sendCommand();
	call sendcommand
; 209             //
; 210             loadStringToHL(hl = wifiSettingsMacVal);
	ld hl, wifisettingsmacval
	call loadstringtohl
l_354:
; 211         } while ((a = parsePageBufferIsCheck) != 1);
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_353
	pop hl
	ret
; 212     }
; 213 }
; 214 
; 215 /// Загрузить данные (не больше 255) по адресу HL
; 216 /// вх. [HL] - Куда записывать результат
; 217 void loadStringToHL() {
loadstringtohl:
; 218     do {
l_356:
; 219         push_pop(hl) {
	push hl
; 220             // Получить новый буфер
; 221             delay5msI2C();
	call delay5msi2c
; 222             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 223             l = 34; //GET_NEXT_PAGE_BUFFER, // 34
	ld l, 34
; 224             h = 0;
	ld h, 0
; 225             sendCommand();
	call sendcommand
; 226             //
; 227             delay5msI2C();
	call delay5msi2c
; 228             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 229             l = 15;
	ld l, 15
; 230             readNewInBuffer(); //ESP_I2S_BUFFER
	call readnewinbuffer
	pop hl
; 231         }
; 232         // Parse ESP_I2S_BUFFER
; 233         parsePageBuffer();
	call parsepagebuffer
l_357:
; 234     } while ((a = parsePageBufferNext) != 0x5A);
	ld a, (parsepagebuffernext)
	cp 90
	jp nz, l_356
	ret
; 235 }
; 236 
; 237 /// Получить STATE_SSID
; 238 void getSSIDState() {
getssidstate:
; 239     push_pop(hl) {
	push hl
; 240         push_pop(de) {
	push de
; 241             push_pop(bc) {
	push bc
; 242                 delay5msI2C();
	call delay5msi2c
; 243                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 244                 l = 11;
	ld l, 11
; 245                 h = 0;
	ld h, 0
; 246                 sendCommand();
	call sendcommand
; 247                 //
; 248                 delay5msI2C();
	call delay5msi2c
; 249                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 250                 l = 4;
	ld l, 4
; 251                 readNewInBuffer();
	call readnewinbuffer
; 252                 //
; 253                 a = WiFiState;
	ld a, (wifistate)
; 254                 h = a;
	ld h, a
; 255                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 256                 a = *de;
	ld a, (de)
; 257                 a &= 0x01;
	and 1
; 258                 WiFiState = a;
	ld (wifistate), a
; 259                 if(a != h){
	cp h
	jp z, l_359
; 260                     a = 0x01;
	ld a, 1
; 261                     WiFiStateUpdate = a;
	ld (wifistateupdate), a
l_359:
	pop bc
	pop de
	pop hl
	ret
; 262                 }
; 263             }
; 264         }
; 265     }
; 266 }
; 267 
; 268 /// FTP
; 269 
; 270 /// Получить FTP URL
; 271 void getFTPUrl() {
getftpurl:
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
; 277                 l = 2;
	ld l, 2
; 278                 h = 0;
	ld h, 0
; 279                 sendCommand();
	call sendcommand
; 280                 //
; 281                 delay5msI2C();
	call delay5msi2c
; 282                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 283                 l = 26;
	ld l, 26
; 284                 readNewInBuffer();
	call readnewinbuffer
; 285                 //
; 286                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 287                 hl = ftpSettingsIpValue;
	ld hl, ftpsettingsipvalue
; 288                 b = 16;
	ld b, 16
; 289                 do {
l_361:
; 290                     a = *de;
	ld a, (de)
; 291                     if(a==0xFF){
	cp 255
	jp nz, l_364
; 292                         a = 0x00;
	ld a, 0
l_364:
; 293                     }
; 294                     *hl = a;
	ld (hl), a
; 295                     de++;
	inc de
; 296                     hl++;
	inc hl
; 297                     b--;
	dec b
l_362:
	jp nz, l_361
	pop bc
	pop de
	pop hl
	ret
; 298                 } while (flag_nz);
; 299             }
; 300         }
; 301     }
; 302 }
; 303 
; 304 /// Отправить FTP URL
; 305 void setFTPUrl() {
setftpurl:
; 306     push_pop(hl) {
	push hl
; 307         push_pop(de) {
	push de
; 308             push_pop(bc) {
	push bc
; 309                 de = ftpSettingsIpValue;
	ld de, ftpsettingsipvalue
; 310                 hl = ESP_I2S_BUFFER;
	ld hl, esp_i2s_buffer
; 311                 b = 16;
	ld b, 16
; 312                 c = 0;
	ld c, 0
; 313                 do {
l_366:
; 314                     a = *de;
	ld a, (de)
; 315                     if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_369
; 316                         a = 0xFF;
	ld a, 255
	jp l_370
l_369:
; 317                     } else if((a = *de) == 0) {
	ld a, (de)
	or a
	jp nz, l_371
; 318                         c = 1;
	ld c, 1
; 319                         a = 0x00;
	ld a, 0
l_371:
l_370:
; 320                     }
; 321                     *hl = a;
	ld (hl), a
; 322                     de++;
	inc de
; 323                     hl++;
	inc hl
; 324                     b--;
	dec b
l_367:
	jp nz, l_366
; 325                 } while (flag_nz);
; 326                 
; 327                 delay5msI2C();
	call delay5msi2c
; 328                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 329                 l = 3;
	ld l, 3
; 330                 h = 16;
	ld h, 16
; 331                 sendCommand();
	call sendcommand
	pop bc
	pop de
	pop hl
	ret
; 332             }
; 333         }
; 334     }
; 335 }
; 336 
; 337 /// Получить FTP User
; 338 void getFTPUser() {
getftpuser:
; 339     push_pop(hl) {
	push hl
; 340         push_pop(de) {
	push de
; 341             push_pop(bc) {
	push bc
; 342                 delay5msI2C();
	call delay5msi2c
; 343                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 344                 l = 18;
	ld l, 18
; 345                 h = 0;
	ld h, 0
; 346                 sendCommand();
	call sendcommand
; 347                 //
; 348                 delay5msI2C();
	call delay5msi2c
; 349                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 350                 l = 26;
	ld l, 26
; 351                 readNewInBuffer();
	call readnewinbuffer
; 352                 //
; 353                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 354                 hl = ftpSettingsUserValue;
	ld hl, ftpsettingsuservalue
; 355                 b = 16;
	ld b, 16
; 356                 do {
l_373:
; 357                     a = *de;
	ld a, (de)
; 358                     if(a==0xFF){
	cp 255
	jp nz, l_376
; 359                         a = 0x00;
	ld a, 0
l_376:
; 360                     }
; 361                     *hl = a;
	ld (hl), a
; 362                     de++;
	inc de
; 363                     hl++;
	inc hl
; 364                     b--;
	dec b
l_374:
	jp nz, l_373
	pop bc
	pop de
	pop hl
	ret
; 365                 } while (flag_nz);
; 366             }
; 367         }
; 368     }
; 369 }
; 370 
; 371 /// Отправить FTP User
; 372 void setFTPUser() {
setftpuser:
; 373     push_pop(hl) {
	push hl
; 374         push_pop(de) {
	push de
; 375             push_pop(bc) {
	push bc
; 376                 de = ftpSettingsUserValue;
	ld de, ftpsettingsuservalue
; 377                 hl = ESP_I2S_BUFFER;
	ld hl, esp_i2s_buffer
; 378                 b = 16;
	ld b, 16
; 379                 c = 0;
	ld c, 0
; 380                 do {
l_378:
; 381                     a = *de;
	ld a, (de)
; 382                     if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_381
; 383                         a = 0xFF;
	ld a, 255
	jp l_382
l_381:
; 384                     } else if((a = *de) == 0) {
	ld a, (de)
	or a
	jp nz, l_383
; 385                         c = 1;
	ld c, 1
; 386                         a = 0x00;
	ld a, 0
l_383:
l_382:
; 387                     }
; 388                     *hl = a;
	ld (hl), a
; 389                     de++;
	inc de
; 390                     hl++;
	inc hl
; 391                     b--;
	dec b
l_379:
	jp nz, l_378
; 392                 } while (flag_nz);
; 393                 
; 394                 delay5msI2C();
	call delay5msi2c
; 395                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 396                 l = 19;
	ld l, 19
; 397                 h = 16;
	ld h, 16
; 398                 sendCommand();
	call sendcommand
	pop bc
	pop de
	pop hl
	ret
; 399             }
; 400         }
; 401     }
; 402 }
; 403 
; 404 /// Получить FTP Password
; 405 void getFTPPassword() {
getftppassword:
; 406     push_pop(hl) {
	push hl
; 407         push_pop(de) {
	push de
; 408             push_pop(bc) {
	push bc
; 409                 delay5msI2C();
	call delay5msi2c
; 410                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 411                 l = 20;
	ld l, 20
; 412                 h = 0;
	ld h, 0
; 413                 sendCommand();
	call sendcommand
; 414                 //
; 415                 delay5msI2C();
	call delay5msi2c
; 416                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 417                 l = 26;
	ld l, 26
; 418                 readNewInBuffer();
	call readnewinbuffer
; 419                 //
; 420                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 421                 hl = ftpSettingsEditViewPasswordVal;
	ld hl, ftpsettingseditviewpasswordval
; 422                 b = 16;
	ld b, 16
; 423                 do {
l_385:
; 424                     a = *de;
	ld a, (de)
; 425                     if(a==0xFF){
	cp 255
	jp nz, l_388
; 426                         a = 0x00;
	ld a, 0
l_388:
; 427                     }
; 428                     *hl = a;
	ld (hl), a
; 429                     de++;
	inc de
; 430                     hl++;
	inc hl
; 431                     b--;
	dec b
l_386:
	jp nz, l_385
	pop bc
	pop de
	pop hl
	ret
; 432                 } while (flag_nz);
; 433             }
; 434         }
; 435     }
; 436 }
; 437 
; 438 /// Отправить FTP Password
; 439 void setFTPPassword() {
setftppassword:
; 440     push_pop(hl) {
	push hl
; 441         push_pop(de) {
	push de
; 442             push_pop(bc) {
	push bc
; 443                 de = ftpSettingsEditViewPasswordVal;
	ld de, ftpsettingseditviewpasswordval
; 444                 hl = ESP_I2S_BUFFER;
	ld hl, esp_i2s_buffer
; 445                 b = 16;
	ld b, 16
; 446                 c = 0;
	ld c, 0
; 447                 do {
l_390:
; 448                     a = *de;
	ld a, (de)
; 449                     if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_393
; 450                         a = 0xFF;
	ld a, 255
	jp l_394
l_393:
; 451                     } else if((a = *de) == 0) {
	ld a, (de)
	or a
	jp nz, l_395
; 452                         c = 1;
	ld c, 1
; 453                         a = 0x00;
	ld a, 0
l_395:
l_394:
; 454                     }
; 455                     *hl = a;
	ld (hl), a
; 456                     de++;
	inc de
; 457                     hl++;
	inc hl
; 458                     b--;
	dec b
l_391:
	jp nz, l_390
; 459                 } while (flag_nz);
; 460                 
; 461                 delay5msI2C();
	call delay5msi2c
; 462                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 463                 l = 21;
	ld l, 21
; 464                 h = 16;
	ld h, 16
; 465                 sendCommand();
	call sendcommand
	pop bc
	pop de
	pop hl
	ret
; 466             }
; 467         }
; 468     }
; 469 }
; 470 
; 471 /// Получить FTP Port
; 472 void getFTPPort() {
getftpport:
; 473     push_pop(hl) {
	push hl
; 474         push_pop(de) {
	push de
; 475             push_pop(bc) {
	push bc
; 476                 delay5msI2C();
	call delay5msi2c
; 477                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 478                 l = 16;
	ld l, 16
; 479                 h = 0;
	ld h, 0
; 480                 sendCommand();
	call sendcommand
; 481                 //
; 482                 delay5msI2C();
	call delay5msi2c
; 483                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 484                 l = 10;
	ld l, 10
; 485                 readNewInBuffer();
	call readnewinbuffer
; 486                 //
; 487                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 488                 hl = ftpSettingsPortValue;
	ld hl, ftpsettingsportvalue
; 489                 b = 6;
	ld b, 6
; 490                 do {
l_397:
; 491                     a = *de;
	ld a, (de)
; 492                     if(a==0xFF){
	cp 255
	jp nz, l_400
; 493                         a = 0x00;
	ld a, 0
l_400:
; 494                     }
; 495                     *hl = a;
	ld (hl), a
; 496                     de++;
	inc de
; 497                     hl++;
	inc hl
; 498                     b--;
	dec b
l_398:
	jp nz, l_397
	pop bc
	pop de
	pop hl
	ret
; 499                 } while (flag_nz);
; 500             }
; 501         }
; 502     }
; 503 }
; 504 
; 505 /// Отправить FTP Port
; 506 void setFTPPort() {
setftpport:
; 507     push_pop(hl) {
	push hl
; 508         push_pop(de) {
	push de
; 509             push_pop(bc) {
	push bc
; 510                 de = ftpSettingsPortValue;
	ld de, ftpsettingsportvalue
; 511                 hl = ESP_I2S_BUFFER;
	ld hl, esp_i2s_buffer
; 512                 b = 6;
	ld b, 6
; 513                 c = 0;
	ld c, 0
; 514                 do {
l_402:
; 515                     a = *de;
	ld a, (de)
; 516                     if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_405
; 517                         a = 0xFF;
	ld a, 255
	jp l_406
l_405:
; 518                     } else if((a = *de) == 0) {
	ld a, (de)
	or a
	jp nz, l_407
; 519                         c = 1;
	ld c, 1
; 520                         a = 0x00;
	ld a, 0
l_407:
l_406:
; 521                     }
; 522                     *hl = a;
	ld (hl), a
; 523                     de++;
	inc de
; 524                     hl++;
	inc hl
; 525                     b--;
	dec b
l_403:
	jp nz, l_402
; 526                 } while (flag_nz);
; 527                 
; 528                 delay5msI2C();
	call delay5msi2c
; 529                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 530                 l = 17;
	ld l, 17
; 531                 h = 6;
	ld h, 6
; 532                 sendCommand();
	call sendcommand
	pop bc
	pop de
	pop hl
	ret
; 533             }
; 534         }
; 535     }
; 536 }
; 537 
; 538 /// Подключиться в FTP
; 539 void needFtpConnect() {
needftpconnect:
; 540     push_pop(hl) {
	push hl
; 541         delay5msI2C();
	call delay5msi2c
; 542         i2cWaitingForAccess();
	call i2cwaitingforaccess
; 543         l = 23;
	ld l, 23
; 544         h = 0;
	ld h, 0
; 545         sendCommand();
	call sendcommand
	pop hl
	ret
; 546     }
; 547 }
; 548 
; 549 /// Получить статус FTP
; 550 void getFtpState() {
getftpstate:
; 551     push_pop(hl) {
	push hl
; 552         push_pop(de) {
	push de
; 553             push_pop(bc) {
	push bc
; 554                 delay5msI2C();
	call delay5msi2c
; 555                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 556                 l = 24;
	ld l, 24
; 557                 h = 0;
	ld h, 0
; 558                 sendCommand();
	call sendcommand
; 559                 //
; 560                 delay5msI2C();
	call delay5msi2c
; 561                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 562                 l = 4;
	ld l, 4
; 563                 readNewInBuffer();
	call readnewinbuffer
; 564                 //
; 565                 a = ftpSettingsStateVal;
	ld a, (ftpsettingsstateval)
; 566                 h = a;
	ld h, a
; 567                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 568                 a = *de;
	ld a, (de)
; 569                 a &= 0x01;
	and 1
; 570                 ftpSettingsStateVal = a;
	ld (ftpsettingsstateval), a
; 571                 if(a != h){
	cp h
	jp z, l_409
; 572                     a = 0x01;
	ld a, 1
; 573                     ftpSettingsStateChange = a;
	ld (ftpsettingsstatechange), a
l_409:
	pop bc
	pop de
	pop hl
	ret
; 574                 }
; 575             }
; 576         }
; 577     }
; 578 }
; 579 
; 580 /// обновить сисок FTP файлов
; 581 void updateFtpList() {
updateftplist:
; 582     push_pop(hl) {
	push hl
; 583         a = 0;
	ld a, 0
; 584         ftpDirListCount = a;
	ld (ftpdirlistcount), a
; 585         delay5msI2C();
	call delay5msi2c
; 586         i2cWaitingForAccess();
	call i2cwaitingforaccess
; 587         l = 25;
	ld l, 25
; 588         h = 0;
	ld h, 0
; 589         sendCommand();
	call sendcommand
; 590         
; 591         delay5msI2C();
	call delay5msi2c
; 592         i2cWaitingForAccess();
	call i2cwaitingforaccess
; 593         busRecoveryI2C();
	call busrecoveryi2c
	pop hl
	ret
; 594     }
; 595 }
; 596 
; 597 void convert4bitToCharA() {
convert4bittochara:
; 598     if (a < 10) {
	cp 10
	jp nc, l_411
; 599         a += 0x30;
	add 48
	jp l_412
l_411:
; 600     } else {
; 601         a += 0x37;
	add 55
l_412:
	ret
; 602     }
; 603 }
; 604 
; 605 /// Получаем список файлов и директорий в текущей папке
; 606 void getFtpList() {
getftplist:
; 607     // Получить ответ
; 608     // Ответ ESP_I2S_BUFFER
; 609     // ftpDirList буфер заполнения
; 610     a = 0;
	ld a, 0
; 611     parseFtpListBufferIsCheck = a;
	ld (parseftplistbufferischeck), a
; 612     do {
l_413:
; 613         push_pop(hl) {
	push hl
; 614             if ((a = parseFtpListBufferIsCheck) == 1) {
	ld a, (parseftplistbufferischeck)
	cp 1
	jp nz, l_416
; 615                 delay5msI2C();
	call delay5msi2c
; 616                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 617                 l = 35; //GET_FTP_LIST_NEXT, // 35
	ld l, 35
; 618                 h = 0;
	ld h, 0
; 619                 sendCommand();
	call sendcommand
l_416:
; 620             }
; 621             
; 622             delay5msI2C();
	call delay5msi2c
; 623             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 624             l = 26; //GET_FTP_LIST
	ld l, 26
; 625             h = 0;
	ld h, 0
; 626             sendCommand();
	call sendcommand
; 627             //
; 628             delay5msI2C();
	call delay5msi2c
; 629             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 630             l = 15;
	ld l, 15
; 631             readNewInBuffer();
	call readnewinbuffer
; 632             
; 633             parseFtpListBuffer();
	call parseftplistbuffer
	pop hl
l_414:
; 634         }
; 635     } while ((a = ftpDirListNext) != 0x5A);
	ld a, (ftpdirlistnext)
	cp 90
	jp nz, l_413
; 636     a = ftpDirListCount;
	ld a, (ftpdirlistcount)
; 637     a++;
	inc a
; 638     ftpDirListCount = a;
	ld (ftpdirlistcount), a
	ret
; 639 }
; 640 
; 641 /// Получаем список файлов и директорий в текущей папке
; 642 void getFtpListOld() {
getftplistold:
; 643     // Получить ответ
; 644     // Ответ ESP_I2S_BUFFER
; 645     // ftpDirList буфер заполнения
; 646     push_pop(bc) {
	push bc
; 647         do {
l_418:
; 648             //
; 649             delay5msI2C();
	call delay5msi2c
; 650             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 651             l = 26; //GET_FTP_LIST
	ld l, 26
; 652             h = 0;
	ld h, 0
; 653             sendCommand();
	call sendcommand
; 654             //
; 655             delay5msI2C();
	call delay5msi2c
; 656             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 657             l = 15;
	ld l, 15
; 658             readNewInBuffer();
	call readnewinbuffer
; 659             
; 660             
; 661             push_pop(a) {
	push af
; 662                 push_pop(de) {
	push de
; 663                     push_pop(hl) {
	push hl
; 664                         parceBufferToFile();
	call parcebuffertofile
	pop hl
	pop de
	pop af
l_419:
; 665                     }
; 666                 }
; 667             }
; 668         } while ((a = ftpDirListNext) != 0x5A); // == 1
	ld a, (ftpdirlistnext)
	cp 90
	jp nz, l_418
; 669         
; 670         delay5msI2C();
	call delay5msi2c
; 671         i2cWaitingForAccess();
	call i2cwaitingforaccess
; 672         busRecoveryI2C();
	call busrecoveryi2c
	pop bc
	ret
; 673     }
; 674 }
; 675 
; 676 /// Указать какой файл скачивать
; 677 void ftpFileDownload() {
ftpfiledownload:
; 678     push_pop(de) {
	push de
; 679         push_pop(hl) {
	push hl
; 680             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 681             a = ftpViewCurrentPos;
	ld a, (ftpviewcurrentpos)
; 682             *de = a;
	ld (de), a
; 683             //
; 684             delay5msI2C();
	call delay5msi2c
; 685             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 686             //
; 687             l = 28; // FILE_DOWNLOAD
	ld l, 28
; 688             h = 1; // 1 байт
	ld h, 1
; 689             sendCommand();
	call sendcommand
	pop hl
	pop de
	ret
; 690         }
; 691     }
; 692 }
; 693 
; 694 /// Скачать указанный файл
; 695 void ftpFileDownloadNext() {
ftpfiledownloadnext:
; 696     push_pop(hl) {
	push hl
; 697         a = 0x01;
	ld a, 1
; 698         ftpFileLoadViewCheckSumState = a;
	ld (ftpfileloadviewchecksumstate), a
; 699         do {
l_421:
; 700             // Если контрольная сумма верна просим следующий буфер
; 701             if ((a = ftpFileLoadViewCheckSumState) == 0x01) {
	ld a, (ftpfileloadviewchecksumstate)
	cp 1
	jp nz, l_424
; 702                 delay5msI2C();
	call delay5msi2c
; 703                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 704                 l = 29;
	ld l, 29
; 705                 h = 0;
	ld h, 0
; 706                 sendCommand();
	call sendcommand
l_424:
; 707             }
; 708             
; 709             // Получить буфер
; 710             delay5msI2C();
	call delay5msi2c
; 711             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 712             l = 30;
	ld l, 30
; 713             h = 0;
	ld h, 0
; 714             sendCommand();
	call sendcommand
; 715             //
; 716             delay5msI2C();
	call delay5msi2c
; 717             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 718             l = 15;
	ld l, 15
; 719             readNewInBuffer();
	call readnewinbuffer
; 720             
; 721             // Распарсить буфер и пррверить контрольную сумму
; 722             //ftpFileLoadViewParce(); Старая реализация
; 723             ftpFileDownloadParse();
	call ftpfiledownloadparse
; 724             
; 725             updateProgress();
	call updateprogress
l_422:
; 726         } while ((a = ftpFileLoadViewIsNextData) != 0x5A);
	ld a, (ftpfileloadviewisnextdata)
	cp 90
	jp nz, l_421
	pop hl
	ret
; 727         // 0x5A признак окончания файла
; 728     }
; 729 }
; 730 
; 731 /// Сменить директорию
; 732 void ftpChangeDirPos() {
ftpchangedirpos:
; 733     push_pop(de) {
	push de
; 734         push_pop(hl) {
	push hl
; 735             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 736             a = ftpViewCurrentPos;
	ld a, (ftpviewcurrentpos)
; 737             *de = a;
	ld (de), a
; 738             //
; 739             delay5msI2C();
	call delay5msi2c
; 740             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 741             //
; 742             l = 32; // FTP_DIR_INDEX
	ld l, 32
; 743             h = 1; // 1 байт
	ld h, 1
; 744             sendCommand();
	call sendcommand
; 745             
; 746             delay5msI2C();
	call delay5msi2c
; 747             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 748             busRecoveryI2C();
	call busrecoveryi2c
	pop hl
	pop de
	ret
; 749         }
; 750     }
; 751 }
; 752 
; 753 /// Сменить директорию вверх
; 754 void ftpChangeDirUp() {
ftpchangedirup:
; 755     push_pop(de) {
	push de
; 756         push_pop(hl) {
	push hl
; 757             delay5msI2C();
	call delay5msi2c
; 758             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 759             //
; 760             l = 31; // FTP_DIR_UP
	ld l, 31
; 761             h = 0;
	ld h, 0
; 762             sendCommand();
	call sendcommand
; 763             
; 764             delay5msI2C();
	call delay5msi2c
; 765             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 766             busRecoveryI2C();
	call busrecoveryi2c
	pop hl
	pop de
	ret
; 767         }
; 768     }
; 769 }
; 770 
; 771 /// Получить текущий путь FTP
; 772 void getFtpCurrentPath() {
getftpcurrentpath:
; 773     push_pop(hl) {
	push hl
; 774         do {
l_426:
; 775             delay5msI2C();
	call delay5msi2c
; 776             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 777             l = 33; //GET_FTP_DIR, // 33
	ld l, 33
; 778             h = 0;
	ld h, 0
; 779             sendCommand();
	call sendcommand
; 780             //
; 781             loadStringToHL(hl = ftpViewDirPath);
	ld hl, ftpviewdirpath
	call loadstringtohl
l_427:
; 782         } while ((a = parsePageBufferIsCheck) != 1);
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_426
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
; 17 //    a = ftpDirListCount;
; 18 //    if (a >= 16) {
; 19 //        a = 16;
; 20 //        ftpDirListCount = a;
; 21 //    }
; 22     
; 23     a = 0;
	ld a, 0
; 24     ftpViewCurrentPos = a;
	ld (ftpviewcurrentpos), a
; 25     
; 26     ftpViewDataUpdate();
	jp ftpviewdataupdate
; 27 }
; 28 
; 29 void clearView() {
clearview:
; 30     push_pop(hl) {
	push hl
; 31         push_pop(bc) {
	push bc
; 32             b = 15;
	ld b, 15
; 33             //
; 34             a = ftpDirListCount;
	ld a, (ftpdirlistcount)
; 35             c = a; //0;
	ld c, a
; 36             // Отнять от B
; 37             a = b;
	ld a, b
; 38             a -= c;
	sub c
; 39             b = a;
	ld b, a
; 40             //--
; 41             do {
l_429:
; 42                 ftpViewPosCursorC();
	call ftpviewposcursorc
; 43                 hl = ftpViewEmpty16; //wifiSettingsEmpty18;
	ld hl, ftpviewempty16
; 44                 printHLStr();
	call printhlstr
; 45                 b--;
	dec b
; 46                 c++;
	inc c
l_430:
; 47             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_429
	pop bc
	pop hl
	ret
; 48         }
; 49     }
; 50 }
; 51 
; 52 /// Обновить на экране текущий путь на FTP
; 53 void updateCurrentPath() {
updatecurrentpath:
; 54     push_pop(hl, bc) {
	push hl
	push bc
; 55         hl = ftpViewDirPath;
	ld hl, ftpviewdirpath
; 56         b = 25;
	ld b, 25
; 57         c = 0; // признак что нужно проставить пробелы
	ld c, 0
; 58         do {
l_432:
; 59             a = *hl;
	ld a, (hl)
; 60             if (a == 0) {
	or a
	jp nz, l_435
; 61                 c = 1;
	ld c, 1
l_435:
; 62             }
; 63             if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_437
; 64                 a = ' ';
	ld a, 32
; 65                 *hl = a;
	ld (hl), a
l_437:
; 66             }
; 67             hl++;
	inc hl
; 68             b--;
	dec b
l_433:
; 69         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_432
; 70         // Если был признак простановки пробелов, ставим в конце 0
; 71         if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_439
; 72             a = 0;
	ld a, 0
; 73             *hl = a;
	ld (hl), a
l_439:
; 74         }
; 75         setPosCursor(hl = ftpViewDirPathPos);
	ld hl, (ftpviewdirpathpos)
	call setposcursor
; 76         printHLStr(hl = ftpViewDirPath);
	ld hl, ftpviewdirpath
	call printhlstr
	pop bc
	pop hl
	ret
; 77     }
; 78 }
; 79 
; 80 void ftpViewDataUpdate() {
ftpviewdataupdate:
; 81     push_pop(bc) {
	push bc
; 82         b = 0;
	ld b, 0
; 83         a = ftpDirListCount;
	ld a, (ftpdirlistcount)
; 84         c = a;
	ld c, a
; 85         do {
l_441:
; 86             a = 0x00;
	ld a, 0
; 87             inverceAddress = a;
	ld (inverceaddress), a
; 88             
; 89             if ((a = rootViewCurrentView) == rootViewCurrentFTPView) {
	ld a, (rootviewcurrentview)
	cp 1
	jp nz, l_444
; 90                 if ((a = ftpViewCurrentPos) == b) {
	ld a, (ftpviewcurrentpos)
	cp b
	jp nz, l_446
; 91                     a = 0xFF;
	ld a, 255
; 92                     inverceAddress = a;
	ld (inverceaddress), a
l_446:
l_444:
; 93                 }
; 94             }
; 95             
; 96             a = b;
	ld a, b
; 97             ftpViewShowValueA();
	call ftpviewshowvaluea
; 98             
; 99             a = 0x00;
	ld a, 0
; 100             inverceAddress = a;
	ld (inverceaddress), a
; 101             
; 102             b++;
	inc b
; 103             c--;
	dec c
l_442:
; 104         } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, l_441
	pop bc
; 105     }
; 106     clearView();
	jp clearview
; 107 }
; 108 
; 109 void ftpViewShowValueA() {
ftpviewshowvaluea:
; 110     push_pop(hl) {
	push hl
; 111         push_pop(de) {
	push de
; 112             push_pop(bc) {
	push bc
; 113                 de = 16;
	ld de, 16
; 114                 c = a;
	ld c, a
; 115                 ftpViewPosCursorC();
	call ftpviewposcursorc
; 116                 hl = ftpDirList;
	ld hl, ftpdirlist
; 117                 if ((a = c) > 0) {
	ld a, c
	or a
	jp z, l_448
; 118                     do {
l_450:
; 119                         hl += de;
	add hl, de
; 120                         c--;
	dec c
l_451:
	jp nz, l_450
l_448:
; 121                     } while (flag_nz);
; 122                 }
; 123                 //hl = ftpLabel;
; 124                 printHLStr();
	call printhlstr
	pop bc
	pop de
	pop hl
	ret
; 125             }
; 126         }
; 127     }
; 128 }
; 129 
; 130 void ftpViewPosCursorC() {
ftpviewposcursorc:
; 131     push_pop(hl) {
	push hl
; 132         a = ftpViewY;
	ld a, (ftpviewy)
; 133         a += 1;
	add 1
; 134         a += c;
	add c
; 135         h = a;
	ld h, a
; 136         a = ftpViewX;
	ld a, (ftpviewx)
; 137         a += 3;
	add 3
; 138         l = a;
	ld l, a
; 139         setPosCursor();
	call setposcursor
	pop hl
	ret
; 140     }
; 141 }
; 142 
; 143 void ftpViewKeyA() {
ftpviewkeya:
; 144     push_pop(hl) {
	push hl
; 145         l = a;
	ld l, a
; 146         if ((a = rootViewCurrentView) == rootViewCurrentFTPView) {
	ld a, (rootviewcurrentview)
	cp 1
	jp nz, l_453
; 147             a = l;
	ld a, l
; 148             if (a == 0x09) { // TAB - Change to local disk
	cp 9
	jp nz, l_455
; 149                 a = rootViewCurrentDiskView; // переходим на список файлов на диске
	ld a, 0
; 150                 rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 151                 ftpViewDataUpdate();
	call ftpviewdataupdate
; 152                 showDiskList();
	call showdisklist
	jp l_456
l_455:
; 153             } else {
; 154                 a = ftpDirListCount;
	ld a, (ftpdirlistcount)
; 155                 h = a;
	ld h, a
; 156                 a = l;
	ld a, l
; 157                 if (a == 0x1A) { //down
	cp 26
	jp nz, l_457
; 158                     a = ftpViewCurrentPos;
	ld a, (ftpviewcurrentpos)
; 159                     a++;
	inc a
; 160                     if (a == h) {
	cp h
	jp nz, l_459
; 161                         a = 0;
	ld a, 0
l_459:
; 162                     }
; 163                     ftpViewCurrentPos = a;
	ld (ftpviewcurrentpos), a
	jp l_458
l_457:
; 164                 } else if (a == 0x19) { //up
	cp 25
	jp nz, l_461
; 165                     a = ftpViewCurrentPos;
	ld a, (ftpviewcurrentpos)
; 166                     if (a == 0) {
	or a
	jp nz, l_463
; 167                         a = h;
	ld a, h
; 168                         a--;
	dec a
	jp l_464
l_463:
; 169                     } else {
; 170                         a--;
	dec a
l_464:
; 171                     }
; 172                     ftpViewCurrentPos = a;
	ld (ftpviewcurrentpos), a
	jp l_462
l_461:
; 173                 } else if (a == 0x0D) { //Enter
	cp 13
	jp nz, l_465
; 174                     ftpViewCurrentPosIsDir();
	call ftpviewcurrentposisdir
; 175                     if ((a = ftpDirListIsDir) == 1) {
	ld a, (ftpdirlistisdir)
	cp 1
	jp nz, l_467
; 176                         if ((a = ftpViewCurrentPos) == 0) {
	ld a, (ftpviewcurrentpos)
	or a
	jp nz, l_469
; 177                             ftpChangeDirUp();
	call ftpchangedirup
	jp l_470
l_469:
; 178                         } else {
; 179                             ftpChangeDirPos();
	call ftpchangedirpos
l_470:
; 180                         }
; 181                         getFtpCurrentPath();
	call getftpcurrentpath
; 182                         needUpdateFtpList();
	call needupdateftplist
; 183                         updateCurrentPath();
	call updatecurrentpath
	jp l_468
l_467:
; 184                     } else {
; 185                         loadSelectFile();
	call loadselectfile
l_468:
	jp l_466
l_465:
; 186                     }
; 187                 } else if (a == 0x34) { // C (COPY)
	cp 52
	jp nz, l_471
; 188                     ftpViewCurrentPosIsDir();
	call ftpviewcurrentposisdir
; 189                     if ((a = ftpDirListIsDir) == 0) {
	ld a, (ftpdirlistisdir)
	or a
	jp nz, l_473
; 190                         loadSelectFile();
	call loadselectfile
l_473:
	jp l_472
l_471:
; 191                     }
; 192                 } else if (a == 'R') { // R (Refresh)
	cp 82
	jp nz, l_475
; 193                     getFtpCurrentPath();
	call getftpcurrentpath
; 194                     needUpdateFtpList();
	call needupdateftplist
; 195                     updateCurrentPath();
	call updatecurrentpath
l_475:
l_472:
l_466:
l_462:
l_458:
l_456:
l_453:
	pop hl
	ret
; 196                 }
; 197             }
; 198         }
; 199     }
; 200 }
; 201 
; 202 void loadSelectFile() {
loadselectfile:
; 203     showFtpFileLoadView();
	call showftpfileloadview
; 204     ftpFileLoadViewNeedLoad();
	call ftpfileloadviewneedload
; 205     updateDiskList();
	call updatedisklist
; 206     updateRootUI();
	call updaterootui
; 207     showDiskList();
	jp showdisklist
; 208 }
; 209 
; 210 /// from ESP_I2S_BUFFER
; 211 /// to ftpDirList
; 212 /// count ftpDirListCount
; 213 /// next ftpDirListNext
; 214 void parceBufferToFile() {
parcebuffertofile:
; 215     de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 216     // (0) - порядковый номер Должен быть == ftpDirListCount + 1
; 217     a = ftpDirListCount;
	ld a, (ftpdirlistcount)
; 218 //    b = a;
; 219 //    a = *de;
; 220 //    if (a != b) {
; 221 //        a = 0x5A;
; 222 //        ftpDirListNext = a;
; 223 //        return;
; 224 //    }
; 225     hl = ftpDirList;
	ld hl, ftpdirlist
; 226     b = 0;
	ld b, 0
; 227     carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 228     if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, l_477
; 229         b++;
	inc b
l_477:
; 230     }
; 231     c = a;
	ld c, a
; 232     hl += bc; // ftpDirList + смещение
	add hl, bc
; 233 //    a = ftpDirListCount;
; 234 //    a ++;
; 235 //    ftpDirListCount = a;
; 236     // (1) - Флаг окончания пакета. Если 1 - то продолжаем. Любой другой - СТОП!
; 237     de++;
	inc de
; 238     a = *de;
	ld a, (de)
; 239     ftpDirListNext = a;
	ld (ftpdirlistnext), a
; 240     if (a != 0x5A) {
	cp 90
	jp z, l_479
; 241         a = ftpDirListCount;
	ld a, (ftpdirlistcount)
; 242         a ++;
	inc a
; 243         ftpDirListCount = a;
	ld (ftpdirlistcount), a
l_479:
; 244     }
; 245 //    if (a == 0x01) {
; 246 //        a = 1;
; 247 //        ftpDirListNext = a;
; 248 //    } else {
; 249 //        a = 0;
; 250 //        ftpDirListNext = a;
; 251 //        return;
; 252 //    }
; 253     // (2) - Флаг директоии
; 254     de++;
	inc de
; 255     a = *de;
	ld a, (de)
; 256     a &= 0x01;
	and 1
; 257     ftpDirListIsDir = a;
	ld (ftpdirlistisdir), a
; 258     if (a == 0) {
	or a
	jp nz, l_481
; 259         a = ' ';
	ld a, 32
; 260         *hl = a;
	ld (hl), a
	jp l_482
l_481:
; 261     } else {
; 262         a = ' '; //'>';
	ld a, 32
; 263         *hl = a;
	ld (hl), a
l_482:
; 264     }
; 265     hl++;
	inc hl
; 266     // (3-4) - размер файла
; 267     de++;
	inc de
; 268     parceSizeFileInBuffer();
	call parcesizefileinbuffer
; 269     // (5-) Имя файла/директории
; 270     b = 9;
	ld b, 9
; 271     do {
l_483:
; 272         a = *de;
	ld a, (de)
; 273         if (a == 0x00) {
	or a
	jp nz, l_486
; 274             a = ' ';
	ld a, 32
l_486:
; 275         }
; 276         *hl = a;
	ld (hl), a
; 277         if ((a = b) == 1) {
	ld a, b
	cp 1
	jp nz, l_488
; 278             a = ' ';
	ld a, 32
; 279             *hl = a;
	ld (hl), a
l_488:
; 280         }
; 281         de++;
	inc de
; 282         hl++;
	inc hl
; 283         b--;
	dec b
l_484:
	jp nz, l_483
	ret
; 284     } while (flag_nz);
; 285 }
; 286 
; 287 /// HL - result string
; 288 /// DE - 2 byte size
; 289 void parceSizeFileInBuffer() {
parcesizefileinbuffer:
; 290     push_pop(hl) {
	push hl
; 291         push_pop(bc) {
	push bc
; 292             bc = 9;
	ld bc, 9
; 293             hl += bc; // смещаем указатель на позицию с размеров файла
	add hl, bc
; 294             a = ' ';
	ld a, 32
; 295             *hl = a;
	ld (hl), a
; 296             hl++;
	inc hl
; 297             // Размер
; 298             if ((a = ftpDirListIsDir) == 0) {
	ld a, (ftpdirlistisdir)
	or a
	jp nz, l_490
; 299                 a = *de;
	ld a, (de)
; 300                 a &= 0xF0;
	and 240
; 301                 cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 302                 convert4bitToCharA();
	call convert4bittochara
; 303                 *hl = a;
	ld (hl), a
; 304                 hl++;
	inc hl
; 305                 a = *de;
	ld a, (de)
; 306                 a &= 0x0F;
	and 15
; 307                 convert4bitToCharA();
	call convert4bittochara
; 308                 *hl = a;
	ld (hl), a
; 309                 hl++;
	inc hl
; 310                 de++;
	inc de
; 311                 
; 312                 a = *de;
	ld a, (de)
; 313                 a &= 0xF0;
	and 240
; 314                 cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 315                 convert4bitToCharA();
	call convert4bittochara
; 316                 *hl = a;
	ld (hl), a
; 317                 hl++;
	inc hl
; 318                 a = *de;
	ld a, (de)
; 319                 a &= 0x0F;
	and 15
; 320                 convert4bitToCharA();
	call convert4bittochara
; 321                 *hl = a;
	ld (hl), a
; 322                 hl++;
	inc hl
; 323                 de++;
	inc de
	jp l_491
l_490:
; 324             } else {
; 325                 a = ' ';
	ld a, 32
; 326                 *hl = a;
	ld (hl), a
; 327                 hl++;
	inc hl
; 328                 a = 'D';
	ld a, 68
; 329                 *hl = a;
	ld (hl), a
; 330                 hl++;
	inc hl
; 331                 a = 'I';
	ld a, 73
; 332                 *hl = a;
	ld (hl), a
; 333                 hl++;
	inc hl
; 334                 a = 'R';
	ld a, 82
; 335                 *hl = a;
	ld (hl), a
; 336                 hl++;
	inc hl
; 337                 de++;
	inc de
; 338                 de++;
	inc de
l_491:
; 339             }
; 340             //
; 341             a = 0;
	ld a, 0
; 342             *hl = a; // End char string
	ld (hl), a
	pop bc
	pop hl
	ret
; 343         }
; 344     }
; 345 }
; 346 
; 347 void ftpViewCurrentPosIsDir() {
ftpviewcurrentposisdir:
; 348     push_pop(hl) {
	push hl
; 349         push_pop(bc) {
	push bc
; 350             hl = ftpDirList;
	ld hl, ftpdirlist
; 351             a = ftpViewCurrentPos;
	ld a, (ftpviewcurrentpos)
; 352             b = 0;
	ld b, 0
; 353             carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 354             if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, l_492
; 355                 b++;
	inc b
l_492:
; 356             }
; 357             c = a;
	ld c, a
; 358             hl += bc;
	add hl, bc
; 359             // + 12 (DIR)
; 360             bc = 12;
	ld bc, 12
; 361             hl += bc;
	add hl, bc
; 362             a = *hl;
	ld a, (hl)
; 363             if (a == 'D') {
	cp 68
	jp nz, l_494
; 364                 a = 1;
	ld a, 1
	jp l_495
l_494:
; 365             } else {
; 366                 a = 0;
	ld a, 0
l_495:
; 367             }
; 368             ftpDirListIsDir = a;
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
	jp nz, l_496
; 83                     hl = ftpSettingsStatus0;
	ld hl, ftpsettingsstatus0
	jp l_497
l_496:
; 84                 } else {
; 85                     hl = ftpSettingsStatus1;
	ld hl, ftpsettingsstatus1
l_497:
; 86                 }
; 87                 
; 88                 de = ftpSettingsStatusValue;
	ld de, ftpsettingsstatusvalue
; 89                 //Copy *hl to *de
; 90                 b = 12;
	ld b, 12
; 91                 do {
l_498:
; 92                     a = *hl;
	ld a, (hl)
; 93                     *de = a;
	ld (de), a
; 94                     if ((a = b) == 1) {
	ld a, b
	cp 1
	jp nz, l_501
; 95                         a = 0;
	ld a, 0
; 96                         *de = a;
	ld (de), a
l_501:
; 97                     }
; 98                     de++;
	inc de
; 99                     hl++;
	inc hl
; 100                     b--;
	dec b
l_499:
; 101                 } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_498
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
l_503:
; 40                 h++;
	inc h
; 41                 if ((a = h) < l) {
	ld a, h
	cp l
	jp nc, l_506
; 42                     c = 0x28; //'X';
	ld c, 40
	jp l_507
l_506:
; 43                 } else {
; 44                     c = 0x27; //' ';
	ld c, 39
l_507:
; 45                 }
; 46                 push_pop(hl) {
	push hl
; 47                     printChatC();
	call printchatc
	pop hl
l_504:
; 48                 }
; 49             } while ((a = h) < 40);
	ld a, h
	cp 40
	jp c, l_503
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
	jp updatedisklist
; 71     //updateRootUI();
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
; 80                 a = *de;
	ld a, (de)
; 81                 l = a;
	ld l, a
; 82                 de++;
	inc de
; 83                 a = *de;
	ld a, (de)
; 84                 h = a;
	ld h, a
; 85                 ftpFileLoadCurrentPos = hl;
	ld (ftpfileloadcurrentpos), hl
; 86                 de++;
	inc de
; 87                 //stopByte
; 88                 a = *de;
	ld a, (de)
; 89                 //a &= 0x01;
; 90                 ftpFileLoadViewIsNextData = a;
	ld (ftpfileloadviewisnextdata), a
; 91                 de++;
	inc de
; 92                 //sum
; 93                 a = *de;
	ld a, (de)
; 94                 ftpFileLoadViewCheckSum = a;
	ld (ftpfileloadviewchecksum), a
; 95                 de++;
	inc de
; 96                 // PROGRESS
; 97                 a = *de;
	ld a, (de)
; 98                 ftpFileLoadViewProgress = a;
	ld (ftpfileloadviewprogress), a
; 99                 de++;
	inc de
; 100                 // PAGE SIZE
; 101                 a = *de;
	ld a, (de)
; 102                 if (a >= 15) {
	cp 15
	jp c, l_508
; 103                     a = 15;
	ld a, 15
l_508:
; 104                 }
; 105                 de++;
	inc de
; 106                 b = a; // SAVE PAGE SIZE in B
	ld b, a
; 107                 // Вычесть из ftpFileLoadCurrentPos SIZE
; 108                 push_pop(hl) {
	push hl
; 109                     hl = ftpFileLoadCurrentPos;
	ld hl, (ftpfileloadcurrentpos)
; 110                     a = l;
	ld a, l
; 111                     a -= b;
	sub b
; 112                     if (flag_c) {
	jp nc, l_510
; 113                         h--;
	dec h
l_510:
; 114                     }
; 115                     l = a;
	ld l, a
; 116                     ftpFileLoadCurrentPos = hl;
	ld (ftpfileloadcurrentpos), hl
	pop hl
; 117                 }
; 118                 //CHECK SUM
; 119                 push_pop(de) {
	push de
; 120                     push_pop(bc) {
	push bc
; 121                         h = 0; //SUM!!!
	ld h, 0
; 122                         do {
l_512:
; 123                             a = *de;
	ld a, (de)
; 124                             a += h;
	add h
; 125                             h = a;
	ld h, a
; 126                             de++;
	inc de
; 127                             b--;
	dec b
l_513:
; 128                         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_512
	pop bc
	pop de
; 129                     }
; 130                 }
; 131                 //
; 132                 if ((a = ftpFileLoadViewCheckSum) == h) {
	ld a, (ftpfileloadviewchecksum)
	cp h
	jp nz, l_515
; 133                     // Сумма корректная
; 134                     if ((a = ftpFileLoadViewIsNextData) == 0) {
	ld a, (ftpfileloadviewisnextdata)
	or a
	jp nz, l_517
; 135                         // Данных больше нет - закрываем файл!
; 136                         ordos_stop();
	call ordos_stop
	jp l_518
l_517:
; 137                     } else {
; 138                         // Данные корректны и еще есть - пишем
; 139                         // DATA
; 140                         //hl = diskStartNewFile;
; 141                         push_pop(de) {
	push de
; 142                             hl = ftpFileLoadCurrentPos;
	ld hl, (ftpfileloadcurrentpos)
; 143                             d = h;
	ld d, h
; 144                             e = l;
	ld e, l
; 145                             hl = diskStartNewFile;
	ld hl, (diskstartnewfile)
; 146                             a = l;
	ld a, l
; 147                             a += e;
	add e
; 148                             if (flag_c) {
	jp nc, l_519
; 149                                 h++;
	inc h
l_519:
; 150                             }
; 151                             l = a;
	ld l, a
; 152                             a = h;
	ld a, h
; 153                             a += d;
	add d
; 154                             h = a;
	ld h, a
	pop de
; 155                         }
; 156                         do {
l_521:
; 157                             a = *de;
	ld a, (de)
; 158                             ordos_wdisk();
	call ordos_wdisk
; 159                             //SUM
; 160                             hl++;
	inc hl
; 161                             de++;
	inc de
; 162                             b--;
	dec b
l_522:
; 163                         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_521
l_518:
; 164                         //diskStartNewFile = hl;
; 165                     }
; 166                     // Получить следующий пакет
; 167                     a = 0x01;
	ld a, 1
; 168                     ftpFileLoadViewCheckSumState = a;
	ld (ftpfileloadviewchecksumstate), a
; 169                     // Если считано без ошибок - то отрисовываем прогресс
; 170                     updateProgress();
	call updateprogress
	jp l_516
l_515:
; 171                 } else {
; 172                     // Получить пакет снова!
; 173                     a = 0x00;
	ld a, 0
; 174                     ftpFileLoadViewCheckSumState = a;
	ld (ftpfileloadviewchecksumstate), a
l_516:
	pop bc
	pop hl
	pop de
	ret
; 175                 }
; 176             }
; 177         }
; 178     }
; 179 }
; 180 
; 181 uint8_t ftpFileLoadViewIsNextData = 0;
ftpfileloadviewisnextdata:
	db 0
; 182 uint16_t ftpFileLoadViewFileAddrPos = 0x0000;
ftpfileloadviewfileaddrpos:
	dw 0
; 183 uint8_t ftpFileLoadViewCheckSum = 0;
ftpfileloadviewchecksum:
	db 0
; 184 uint8_t ftpFileLoadViewCheckSumState = 0;
ftpfileloadviewchecksumstate:
	db 0
; 185 uint8_t ftpFileLoadViewProgress = 0;
ftpfileloadviewprogress:
	db 0
; 187 uint8_t FtpFileLoadViewX = 10;
ftpfileloadviewx:
	db 10
; 188 uint8_t FtpFileLoadViewY = 11;
ftpfileloadviewy:
	db 11
; 189 uint8_t FtpFileLoadViewEX = 54;
ftpfileloadviewex:
	db 54
; 190 uint8_t FtpFileLoadViewEY = 14;
ftpfileloadviewey:
	db 14
; 192 uint16_t FtpFileLoadViewTitlelPos = 0x0B1D; //031B
ftpfileloadviewtitlelpos:
	dw 2845
; 193 uint8_t FtpFileLoadViewTitlel[] = " LOAD ";
ftpfileloadviewtitlel:
	db 32
	db 76
	db 79
	db 65
	db 68
	db 32
	ds 1
; 194 uint16_t ftpFileLoadCurrentPos = 0x0000;
ftpfileloadcurrentpos:
	dw 0
; 14 void parsePageBuffer() {
parsepagebuffer:
; 15     checkSumPageBuffer();
	call checksumpagebuffer
; 16     if ((a = parsePageBufferIsCheck) == 1) {
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_524
; 17         push_pop(de) {
	push de
; 18             push_pop(bc) {
	push bc
; 19                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 20                 // pageNum
; 21                 de++;
	inc de
; 22                 // pageSize
; 23                 a = *de;
	ld a, (de)
; 24                 b = a;
	ld b, a
; 25                 de++;
	inc de
; 26                 // next
; 27                 a = *de;
	ld a, (de)
; 28                 parsePageBufferNext = a;
	ld (parsepagebuffernext), a
; 29                 de++;
	inc de
; 30                 // buffer
; 31                 push_pop(de) {
	push de
; 32                     do {
l_526:
; 33                         a = *de;
	ld a, (de)
; 34                         *hl = a;
	ld (hl), a
; 35                         de++;
	inc de
; 36                         hl++;
	inc hl
; 37                         b--;
	dec b
l_527:
; 38                     } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_526
	pop de
	pop bc
	pop de
	jp l_525
l_524:
; 39                 }
; 40             }
; 41         }
; 42     } else {
; 43         a = 0x5A;
	ld a, 90
; 44         parsePageBufferNext = a;
	ld (parsepagebuffernext), a
l_525:
	ret
; 45     }
; 46 }
; 47 
; 48 void checkSumPageBuffer() {
checksumpagebuffer:
; 49     push_pop(de) {
	push de
; 50         push_pop(bc) {
	push bc
; 51             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 52             c = 0; // c == Check SUM
	ld c, 0
; 53             // pageNum
; 54             a = *de;
	ld a, (de)
; 55             a += c;
	add c
; 56             c = a;
	ld c, a
; 57             de++;
	inc de
; 58             // pageSize
; 59             a = *de;
	ld a, (de)
; 60             b = a;
	ld b, a
; 61             a += c;
	add c
; 62             c = a;
	ld c, a
; 63             de++;
	inc de
; 64             // next
; 65             a = *de;
	ld a, (de)
; 66             a += c;
	add c
; 67             c = a;
	ld c, a
; 68             de++;
	inc de
; 69             // buffer
; 70             do {
l_529:
; 71                 a = *de;
	ld a, (de)
; 72                 a += c;
	add c
; 73                 c = a;
	ld c, a
; 74                 de++;
	inc de
; 75                 b--;
	dec b
l_530:
; 76             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_529
; 77             // sum
; 78             a = *de;
	ld a, (de)
; 79             if (a == c) {
	cp c
	jp nz, l_532
; 80                 a = 1;
	ld a, 1
; 81                 parsePageBufferIsCheck = a;
	ld (parsepagebufferischeck), a
	jp l_533
l_532:
; 82             } else {
; 83                 a = 0;
	ld a, 0
; 84                 parsePageBufferIsCheck = a;
	ld (parsepagebufferischeck), a
l_533:
	pop bc
	pop de
	ret
; 85             }
; 86         }
; 87     }
; 88 }
; 89 
; 90 uint8_t parsePageBufferNext = 0;
parsepagebuffernext:
	db 0
; 91 uint8_t parsePageBufferIsCheck = 0;
parsepagebufferischeck:
	db 0
; 94 void parseFtpListBuffer() {
parseftplistbuffer:
; 95     checkSumFtpListBuffer();
	call checksumftplistbuffer
; 96     if ((a = parseFtpListBufferIsCheck) == 1) {
	ld a, (parseftplistbufferischeck)
	cp 1
	jp nz, l_534
; 97         push_pop(de) {
	push de
; 98             push_pop(bc) {
	push bc
; 99                 push_pop(hl) {
	push hl
; 100                     de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 101                     hl = ftpDirList;
	ld hl, ftpdirlist
; 102                     //-- Pos
; 103                     a = *de;
	ld a, (de)
; 104                     a &= 0x3F;
	and 63
; 105                     ftpDirListCount = a;
	ld (ftpdirlistcount), a
; 106                     b = 0;
	ld b, 0
; 107                     carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 108                     if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, l_536
; 109                         b++;
	inc b
l_536:
; 110                     }
; 111                     c = a;
	ld c, a
; 112                     hl += bc; // ftpDirList + смещение
	add hl, bc
; 113                     //-- Next
; 114                     a = *de;
	ld a, (de)
; 115                     a &= 0x40;
	and 64
; 116                     if (a == 0x40) {
	cp 64
	jp nz, l_538
; 117                         a = 0x01;
	ld a, 1
; 118                         ftpDirListNext = a;
	ld (ftpdirlistnext), a
	jp l_539
l_538:
; 119                     } else {
; 120                         a = 0x5A;
	ld a, 90
; 121                         ftpDirListNext = a;
	ld (ftpdirlistnext), a
l_539:
; 122                     }
; 123                     //-- Dir
; 124                     a = *de;
	ld a, (de)
; 125                     a &= 0x80;
	and 128
; 126                     if (a == 0x80) {
	cp 128
	jp nz, l_540
; 127                         a = 1;
	ld a, 1
; 128                         ftpDirListIsDir = a;
	ld (ftpdirlistisdir), a
	jp l_541
l_540:
; 129                     } else {
; 130                         a = 0;
	ld a, 0
; 131                         ftpDirListIsDir = a;
	ld (ftpdirlistisdir), a
l_541:
; 132                     }
; 133                     //-- SIZE
; 134                     de++;
	inc de
; 135                     sizeFtpListBuffer();
	call sizeftplistbuffer
; 136                     //-- NAME
; 137                     a = ' ';
	ld a, 32
; 138                     *hl = a;
	ld (hl), a
; 139                     hl++;
	inc hl
; 140                     b = 9;
	ld b, 9
; 141                     do {
l_542:
; 142                         a = *de;
	ld a, (de)
; 143                         if (a == 0x00) {
	or a
	jp nz, l_545
; 144                             a = ' ';
	ld a, 32
l_545:
; 145                         }
; 146                         *hl = a;
	ld (hl), a
; 147                         hl++;
	inc hl
; 148                         de++;
	inc de
; 149                         b--;
	dec b
l_543:
; 150                     } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_542
	pop hl
	pop bc
	pop de
	jp l_535
l_534:
; 151                 }
; 152             }
; 153         }
; 154     } else {
; 155         a = 0xFF; // ERROR
	ld a, 255
; 156         ftpDirListNext = a;
	ld (ftpdirlistnext), a
l_535:
	ret
; 157     }
; 158 }
; 159 
; 160 // HL - point File
; 161 // DE - point size
; 162 void sizeFtpListBuffer() {
sizeftplistbuffer:
; 163     push_pop(hl) {
	push hl
; 164         b = 10;
	ld b, 10
; 165         do {
l_547:
; 166             hl++;
	inc hl
; 167             b--;
	dec b
l_548:
; 168         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_547
; 169         // -- Separator
; 170         a = ' ';
	ld a, 32
; 171         *hl = a;
	ld (hl), a
; 172         hl++;
	inc hl
; 173         // --
; 174         if ((a = ftpDirListIsDir) == 1) {
	ld a, (ftpdirlistisdir)
	cp 1
	jp nz, l_550
; 175             de++;
	inc de
; 176             de++;
	inc de
; 177             a = ' ';
	ld a, 32
; 178             *hl = a;
	ld (hl), a
; 179             hl++;
	inc hl
; 180             a = 'D';
	ld a, 68
; 181             *hl = a;
	ld (hl), a
; 182             hl++;
	inc hl
; 183             a = 'I';
	ld a, 73
; 184             *hl = a;
	ld (hl), a
; 185             hl++;
	inc hl
; 186             a = 'R';
	ld a, 82
; 187             *hl = a;
	ld (hl), a
; 188             hl++;
	inc hl
; 189             a = 0;
	ld a, 0
; 190             *hl = a;
	ld (hl), a
; 191             hl++;
	inc hl
	jp l_551
l_550:
; 192         } else {
; 193             a = *de;
	ld a, (de)
; 194             a &= 0xF0;
	and 240
; 195             cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 196             convert4bitToCharA();
	call convert4bittochara
; 197             *hl = a;
	ld (hl), a
; 198             hl++;
	inc hl
; 199             a = *de;
	ld a, (de)
; 200             a &= 0x0F;
	and 15
; 201             convert4bitToCharA();
	call convert4bittochara
; 202             *hl = a;
	ld (hl), a
; 203             hl++;
	inc hl
; 204             de++;
	inc de
; 205             a = *de;
	ld a, (de)
; 206             a &= 0xF0;
	and 240
; 207             cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 208             convert4bitToCharA();
	call convert4bittochara
; 209             *hl = a;
	ld (hl), a
; 210             hl++;
	inc hl
; 211             a = *de;
	ld a, (de)
; 212             a &= 0x0F;
	and 15
; 213             convert4bitToCharA();
	call convert4bittochara
; 214             *hl = a;
	ld (hl), a
; 215             hl++;
	inc hl
; 216             de++;
	inc de
; 217             a = 0;
	ld a, 0
; 218             *hl = a;
	ld (hl), a
; 219             hl++;
	inc hl
l_551:
	pop hl
	ret
; 220         }
; 221     }
; 222 }
; 223 
; 224 // ESP_I2S_BUFFER
; 225 // diskStartNewFile
; 226 void checkSumFtpListBuffer() {
checksumftplistbuffer:
; 227     push_pop(de) {
	push de
; 228         push_pop(bc) {
	push bc
; 229             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 230             c = 0;
	ld c, 0
; 231             b = 12;
	ld b, 12
; 232             do {
l_552:
; 233                 a = *de;
	ld a, (de)
; 234                 a += c;
	add c
; 235                 c = a;
	ld c, a
; 236                 de++;
	inc de
; 237                 b--;
	dec b
l_553:
; 238             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_552
; 239             // SUM
; 240             a = *de;
	ld a, (de)
; 241             if (a == c) {
	cp c
	jp nz, l_555
; 242                 a = 1;
	ld a, 1
; 243                 parseFtpListBufferIsCheck = a;
	ld (parseftplistbufferischeck), a
	jp l_556
l_555:
; 244             } else {
; 245                 a = 0;
	ld a, 0
; 246                 parseFtpListBufferIsCheck = a;
	ld (parseftplistbufferischeck), a
l_556:
	pop bc
	pop de
	ret
; 247             }
; 248         }
; 249     }
; 250 }
; 251 
; 252 /// Парсинг пакета с данными скачиваемого файла
; 253 void ftpFileDownloadParse() {
ftpfiledownloadparse:
; 254     checkSumFtpFileDownload();
	call checksumftpfiledownload
; 255     if ((a = ftpFileLoadViewCheckSumState) == 1) {
	ld a, (ftpfileloadviewchecksumstate)
	cp 1
	jp nz, l_557
; 256         push_pop(de) {
	push de
; 257             push_pop(hl) {
	push hl
; 258                 push_pop(bc) {
	push bc
; 259                     de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 260                     // -- SIZE
; 261                     a = *de;
	ld a, (de)
; 262                     ftpFileDownloadParseSizePackA();
	call ftpfiledownloadparsesizepacka
; 263                     de++;
	inc de
; 264                     // -- ADDRESS
; 265                     a = *de;
	ld a, (de)
; 266                     l = a;
	ld l, a
; 267                     de++;
	inc de
; 268                     a = *de;
	ld a, (de)
; 269                     h = a;
	ld h, a
; 270                     ftpFileLoadCurrentPos = hl;
	ld (ftpfileloadcurrentpos), hl
; 271                     de++;
	inc de
; 272                     // -- PROGRESS AND NEXT
; 273                     a = *de;
	ld a, (de)
; 274                     ftpFileDownloadParseProgressAndNextA();
	call ftpfiledownloadparseprogressandn
; 275                     de++;
	inc de
; 276                     // -- DATA
; 277                     // Если контрольная сумма совпала и есть статус что данные есть - пишем на диск
; 278                     if ((a = ftpFileLoadViewIsNextData) == 0x01) {
	ld a, (ftpfileloadviewisnextdata)
	cp 1
	jp nz, l_559
; 279                         ftpFileDownloadCalkDiskPosToHL();
	call ftpfiledownloadcalkdiskpostohl
; 280                         a = ftpFileDownloadDataSize;
	ld a, (ftpfiledownloaddatasize)
; 281                         b = a;
	ld b, a
; 282                         do {
l_561:
; 283                             a = *de;
	ld a, (de)
; 284                             ordos_wdisk();
	call ordos_wdisk
; 285                             de++;
	inc de
; 286                             hl++;
	inc hl
; 287                             b--;
	dec b
l_562:
; 288                         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_561
; 289                         ftpFileDownloadEnd = hl;
	ld (ftpfiledownloadend), hl
l_559:
; 290                     }
; 291                     // Если контрольная сумма совпала и статус что данные закончились - закрываем файл
; 292                     if ((a = ftpFileLoadViewIsNextData) == 0x5A) {
	ld a, (ftpfileloadviewisnextdata)
	cp 90
	jp nz, l_564
; 293                         hl = ftpFileDownloadEnd;
	ld hl, (ftpfiledownloadend)
; 294                         ordos_stop();
	call ordos_stop
l_564:
	pop bc
	pop hl
	pop de
	jp l_558
l_557:
; 295                     }
; 296                 }
; 297             }
; 298         }
; 299     } else {
; 300         a = 0xFF;
	ld a, 255
; 301         ftpFileLoadViewIsNextData = a;
	ld (ftpfileloadviewisnextdata), a
l_558:
	ret
; 302     }
; 303 }
; 304 
; 305 /// Считаем адрес куда писать данные на диск
; 306 void ftpFileDownloadCalkDiskPosToHL() {
ftpfiledownloadcalkdiskpostohl:
; 307     push_pop(de) {
	push de
; 308         // получаем адрес пакета
; 309         hl = ftpFileLoadCurrentPos;
	ld hl, (ftpfileloadcurrentpos)
; 310         // вычитаем длину пакета данных
; 311         a = ftpFileDownloadDataSize;
	ld a, (ftpfiledownloaddatasize)
; 312         e = a;
	ld e, a
; 313         a = l;
	ld a, l
; 314         a -= e;
	sub e
; 315         if (flag_c) {
	jp nc, l_566
; 316             h--;
	dec h
l_566:
; 317         }
; 318         l = a;
	ld l, a
; 319         // прибавляем к точке начала файла на диске
; 320         d = h;
	ld d, h
; 321         e = l;
	ld e, l
; 322         hl = diskStartNewFile;
	ld hl, (diskstartnewfile)
; 323         a = l;
	ld a, l
; 324         a += e;
	add e
; 325         if (flag_c) {
	jp nc, l_568
; 326             h++;
	inc h
l_568:
; 327         }
; 328         l = a;
	ld l, a
; 329         a = h;
	ld a, h
; 330         a += d;
	add d
; 331         h = a;
	ld h, a
	pop de
	ret
; 332         // В HL адрес записи, полученных данных, на диск
; 333     }
; 334 }
; 335 
; 336 /// Подсчет контрольной суммы
; 337 void checkSumFtpFileDownload() {
checksumftpfiledownload:
; 338     push_pop(de) {
	push de
; 339         push_pop(bc) {
	push bc
; 340             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 341             a = *de;
	ld a, (de)
; 342             ftpFileDownloadParseSizePackA();
	call ftpfiledownloadparsesizepacka
; 343             a = ftpFileDownloadPropertySize;
	ld a, (ftpfiledownloadpropertysize)
; 344             b = a;
	ld b, a
; 345             a = ftpFileDownloadDataSize;
	ld a, (ftpfiledownloaddatasize)
; 346             a += b;
	add b
; 347             b = a;
	ld b, a
; 348             //
; 349             c = 0;
	ld c, 0
; 350             do {
l_570:
; 351                 a = *de;
	ld a, (de)
; 352                 a += c;
	add c
; 353                 c = a;
	ld c, a
; 354                 de++;
	inc de
; 355                 b--;
	dec b
l_571:
; 356             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_570
; 357             //
; 358             a = *de;
	ld a, (de)
; 359             if (a == c) {
	cp c
	jp nz, l_573
; 360                 a = 1;
	ld a, 1
; 361                 ftpFileLoadViewCheckSumState = a;
	ld (ftpfileloadviewchecksumstate), a
	jp l_574
l_573:
; 362             } else {
; 363                 a = 0;
	ld a, 0
; 364                 ftpFileLoadViewCheckSumState = a;
	ld (ftpfileloadviewchecksumstate), a
l_574:
	pop bc
	pop de
	ret
; 365             }
; 366         }
; 367     }
; 368 }
; 369 
; 370 /// Извлекает из A данные о прогрессе и Статус продолжение данных
; 371 /// первые 6 бит - прогресс.
; 372 /// последние 2 - статус продолжения. (0x80 - если еще есть данные. 0x40 - данные закончились. 0x00 - ошибка данных)
; 373 void ftpFileDownloadParseProgressAndNextA() {
ftpfiledownloadparseprogressandn:
; 374     push_pop(bc) {
	push bc
; 375         b = a;
	ld b, a
; 376         a &= 0x3F;
	and 63
; 377         ftpFileLoadViewProgress = a;
	ld (ftpfileloadviewprogress), a
; 378         //
; 379         a = b;
	ld a, b
; 380         a &= 0xC0;
	and 192
; 381         b = a;
	ld b, a
; 382         // --
; 383         if ((a = b) == 0x80) {
	ld a, b
	cp 128
	jp nz, l_575
; 384             a = 0x01;
	ld a, 1
; 385             ftpFileLoadViewIsNextData = a;
	ld (ftpfileloadviewisnextdata), a
	jp l_576
l_575:
; 386         } else if ((a = b) == 0x40) {
	ld a, b
	cp 64
	jp nz, l_577
; 387             a = 0x5A;
	ld a, 90
; 388             ftpFileLoadViewIsNextData = a;
	ld (ftpfileloadviewisnextdata), a
	jp l_578
l_577:
; 389         } else {
; 390             a = 0xFF;
	ld a, 255
; 391             ftpFileLoadViewIsNextData = a;
	ld (ftpfileloadviewisnextdata), a
; 392             a = 0;
	ld a, 0
; 393             ftpFileLoadViewCheckSumState = a;
	ld (ftpfileloadviewchecksumstate), a
l_578:
l_576:
	pop bc
	ret
; 394         }
; 395     }
; 396 }
; 397 
; 398 /// Извлекает из A данные по размерам пакета (свойства + буфер)
; 399 /// первые 3 бита - свойства, последние 5 - данные
; 400 /// (property & 0x07) + ((data & 0x1f)<<3);
; 401 void ftpFileDownloadParseSizePackA() {
ftpfiledownloadparsesizepacka:
; 402     push_pop(bc) {
	push bc
; 403         b = a;
	ld b, a
; 404         a &= 0x07;
	and 7
; 405         ftpFileDownloadPropertySize = a;
	ld (ftpfiledownloadpropertysize), a
; 406         a = b;
	ld a, b
; 407         a &= 0xF8;
	and 248
; 408         carry_rotate_right(a, 3);
	rra
	rra
	rra
; 409         ftpFileDownloadDataSize = a;
	ld (ftpfiledownloaddatasize), a
	pop bc
	ret
; 410     }
; 411 }
; 412 
; 413 uint8_t ftpFileDownloadPropertySize = 0;
ftpfiledownloadpropertysize:
	db 0
; 414 uint8_t ftpFileDownloadDataSize = 0;
ftpfiledownloaddatasize:
	db 0
; 415 uint8_t parseFtpListBufferIsCheck = 0;
parseftplistbufferischeck:
	db 0
; 416 uint8_t ftpFileDownloadIsCheck = 0;
ftpfiledownloadischeck:
	db 0
; 417 uint16_t ftpFileDownloadEnd = 0;
ftpfiledownloadend:
	dw 0
; 11 void DEBUGFirstCurA() {
debugfirstcura:
; 12     push_pop(hl) {
	push hl
; 13         l = 1;
	ld l, 1
; 14         h = a;
	ld h, a
; 15         setPosCursor();
	call setposcursor
	pop hl
	ret
; 16     }
; 17 }
; 18 
; 19 void DEBUGShowHexA() {
debugshowhexa:
; 20     printHexA();
	call printhexa
; 21     a = ' ';
	ld a, 32
; 22     printChatA();
	jp printchata
; 32 uint8_t rootTimerTike = 0;
roottimertike:
	db 0
 savebin "test.ORD", 0x00f0, 0x200f
