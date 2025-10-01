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

    org 0x00F0

; 19 uint8_t appName[] = {'K','F','T','P','$',' ',' ',' '};
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

    DB 0x00, 0x0B

    DB 0x00, 0x00, 0x00, 0x00

; 30 void main(){
main:
; 31     updateDiskList();
	call updatedisklist
; 32     
; 33     updateRootUI();
	call updaterootui
; 34     
; 35     updateRootDataUI();
	call updaterootdataui
; 36     
; 37     //Бесконечный цикл. Что бы увидеть результат
; 38     for (;;) {
l_1:
; 39         getKeyboardCodeA();
	call getkeyboardcodea
; 40         l = a; //Save key
	ld l, a
; 41         if ((a = rootViewOldKey) != l) {
	ld a, (rootviewoldkey)
	cp l
	jp z, l_3
; 42             a = l; //Load key
	ld a, l
; 43             rootViewOldKey = a;
	ld (rootviewoldkey), a
; 44             push_pop(hl) {
	push hl
; 45                 a = l; //Load key
	ld a, l
; 46                 if (a != 0xFF) {
	cp 255
	jp z, l_5
; 47                     /// Hot ley
; 48                     if (a == 0x03) { //F4 quit ordos
	cp 3
	jp nz, l_7
; 49                         ordos_start();
	call ordos_start
	jp l_8
l_7:
; 50                     } else if (a == 0x02) { //F3 Open FTP settings
	cp 2
	jp nz, l_9
; 51                         needOpenFTPSettingsEditView();
	call needopenftpsettingseditview
	jp l_10
l_9:
; 52                     } else if (a == 'C') { // Button C
	cp 67
	jp nz, l_11
; 53                         createTestFile();
	call createtestfile
; 54                         updateDiskList();
	call updatedisklist
; 55                         updateRootUI();
	call updaterootui
; 56                         showDiskList();
	call showdisklist
l_11:
l_10:
l_8:
; 57                     }
; 58                     
; 59                     /// View's
; 60                     if ((a = rootViewCurrentView) == rootViewCurrentDiskView) {
	ld a, (rootviewcurrentview)
	or a
	jp nz, l_13
; 61                         a = l; //Load key
	ld a, l
; 62                         diskViewKeyA();
	call diskviewkeya
; 63                         showDiskList(); //Refresh
	call showdisklist
	jp l_14
l_13:
; 64                     } else if ((a = rootViewCurrentView) == rootViewCurrentFTPSettingsEditView) {
	ld a, (rootviewcurrentview)
	cp 2
	jp nz, l_15
; 65                         a = l; //Load key
	ld a, l
; 66                         ftpSettingsEditViewKeyA();
	call ftpsettingseditviewkeya
; 67                         ftpSettingsEditViewDataUpdate();
	call ftpsettingseditviewdataupdate
l_15:
l_14:
l_5:
	pop hl
l_3:
	jp l_1
; 68                     }
; 69                     //printHexA();
; 70                 }
; 71             }
; 72         }
; 73     }
; 74 }
; 75 
; 76 void updateRootDataUI() {
updaterootdataui:
; 77     showDiskList();
	jp showdisklist
; 78 }
; 79 
; 80 void updateRootUI() {
updaterootui:
; 81     clearScreen();
	call clearscreen
; 82     
; 83     showWiFiView();
	call showwifiview
; 84     showFtpView();
	call showftpview
; 85     diskView();
	call diskview
; 86     ftpView();
	call ftpview
; 87     
; 88     showHelpStr();
	jp showhelpstr
; 89 }
; 90 
; 91 void ftpView() {
ftpview:
; 92     drowRectX = (a = ftpViewX);
	ld a, (ftpviewx)
	ld (drowrectx), a
; 93     drowRectY = (a = ftpViewY);
	ld a, (ftpviewy)
	ld (drowrecty), a
; 94     drowRectEndX = (a = ftpViewEX);
	ld a, (ftpviewex)
	ld (drowrectendx), a
; 95     drowRectEndY = (a = ftpViewEY);
	ld a, (ftpviewey)
	ld (drowrectendy), a
; 96     drowRect();
	call drowrect
; 97     
; 98     hl = ftpLabelPos;
	ld hl, (ftplabelpos)
; 99     setPosCursor();
	call setposcursor
; 100     hl = ftpLabel;
	ld hl, ftplabel
; 101     printHLStr();
	jp printhlstr
; 102 }
; 103 
; 104 void diskView() {
diskview:
; 105     drowRectX = (a = diskViewX);
	ld a, (diskviewx)
	ld (drowrectx), a
; 106     drowRectY = (a = diskViewY);
	ld a, (diskviewy)
	ld (drowrecty), a
; 107     drowRectEndX = (a = diskViewEX);
	ld a, (diskviewex)
	ld (drowrectendx), a
; 108     drowRectEndY = (a = diskViewEY);
	ld a, (diskviewey)
	ld (drowrectendy), a
; 109     drowRect();
	call drowrect
; 110     
; 111     hl = diskViewLabelPos;
	ld hl, (diskviewlabelpos)
; 112     setPosCursor();
	call setposcursor
; 113     hl = diskViewLabel;
	ld hl, diskviewlabel
; 114     printHLStr();
	jp printhlstr
; 115 }
; 116 
; 117 void showFtpView() {
showftpview:
; 118     drowRectX = (a = ftpSettingsViewX);
	ld a, (ftpsettingsviewx)
	ld (drowrectx), a
; 119     drowRectY = (a = ftpSettingsViewY);
	ld a, (ftpsettingsviewy)
	ld (drowrecty), a
; 120     drowRectEndX = (a = ftpSettingsViewEX);
	ld a, (ftpsettingsviewex)
	ld (drowrectendx), a
; 121     drowRectEndY = (a = ftpSettingsViewEY);
	ld a, (ftpsettingsviewey)
	ld (drowrectendy), a
; 122     drowRect();
	call drowrect
; 123     
; 124     hl = ftpSettingsLabelPos;
	ld hl, (ftpsettingslabelpos)
; 125     setPosCursor();
	call setposcursor
; 126     hl = ftpSettingsLabel;
	ld hl, ftpsettingslabel
; 127     printHLStr();
	call printhlstr
; 128     
; 129     hl = ftpSettingsStatusLabelPos;
	ld hl, (ftpsettingsstatuslabelpos)
; 130     setPosCursor();
	call setposcursor
; 131     hl = ftpSettingsStatusLabel;
	ld hl, ftpsettingsstatuslabel
; 132     printHLStr();
	call printhlstr
; 133     
; 134     hl = ftpSettingsIpLabelPos;
	ld hl, (ftpsettingsiplabelpos)
; 135     setPosCursor();
	call setposcursor
; 136     hl = ftpSettingsIpLabel;
	ld hl, ftpsettingsiplabel
; 137     printHLStr();
	call printhlstr
; 138     
; 139     hl = ftpSettingsPortLabelPos;
	ld hl, (ftpsettingsportlabelpos)
; 140     setPosCursor();
	call setposcursor
; 141     hl = ftpSettingsPortLabel;
	ld hl, ftpsettingsportlabel
; 142     printHLStr();
	call printhlstr
; 143     
; 144     hl = ftpSettingsUserLabelPos;
	ld hl, (ftpsettingsuserlabelpos)
; 145     setPosCursor();
	call setposcursor
; 146     hl = ftpSettingsUserLabel;
	ld hl, ftpsettingsuserlabel
; 147     printHLStr();
	call printhlstr
; 148     
; 149     //Value
; 150     hl = ftpSettingsIpValuePos;
	ld hl, (ftpsettingsipvaluepos)
; 151     setPosCursor();
	call setposcursor
; 152     hl = ftpSettingsIpValue;
	ld hl, ftpsettingsipvalue
; 153     printHLStr();
	call printhlstr
; 154     
; 155     hl = ftpSettingsPortValuePos;
	ld hl, (ftpsettingsportvaluepos)
; 156     setPosCursor();
	call setposcursor
; 157     hl = ftpSettingsPortValue;
	ld hl, ftpsettingsportvalue
; 158     printHLStr();
	call printhlstr
; 159     
; 160     hl = ftpSettingsStatusValuePos;
	ld hl, (ftpsettingsstatusvaluepos)
; 161     setPosCursor();
	call setposcursor
; 162     hl = ftpSettingsStatusValue;
	ld hl, ftpsettingsstatusvalue
; 163     printHLStr();
	call printhlstr
; 164     
; 165     hl = ftpSettingsUserValuePos;
	ld hl, (ftpsettingsuservaluepos)
; 166     setPosCursor();
	call setposcursor
; 167     hl = ftpSettingsUserValue;
	ld hl, ftpsettingsuservalue
; 168     printHLStr();
	jp printhlstr
; 169 }
; 170 
; 171 void showWiFiView() {
showwifiview:
; 172     drowRectX = (a = wifiSettingsViewX);
	ld a, (wifisettingsviewx)
	ld (drowrectx), a
; 173     drowRectY = (a = wifiSettingsViewY);
	ld a, (wifisettingsviewy)
	ld (drowrecty), a
; 174     drowRectEndX = (a = wifiSettingsViewEX);
	ld a, (wifisettingsviewex)
	ld (drowrectendx), a
; 175     drowRectEndY = (a = wifiSettingsViewEY);
	ld a, (wifisettingsviewey)
	ld (drowrectendy), a
; 176     drowRect();
	call drowrect
; 177     
; 178     hl = wifiSettingsPos;
	ld hl, (wifisettingspos)
; 179     setPosCursor();
	call setposcursor
; 180     hl = wifiSettingsLabel;
	ld hl, wifisettingslabel
; 181     printHLStr();
	call printhlstr
; 182     
; 183     hl = wifiSettingsSsidLabelPos;
	ld hl, (wifisettingsssidlabelpos)
; 184     setPosCursor();
	call setposcursor
; 185     hl = wifiSettingsSsidLabel;
	ld hl, wifisettingsssidlabel
; 186     printHLStr();
	call printhlstr
; 187     
; 188     hl = wifiSettingsIpLabelPos;
	ld hl, (wifisettingsiplabelpos)
; 189     setPosCursor();
	call setposcursor
; 190     hl = wifiSettingsIpLabel;
	ld hl, wifisettingsiplabel
; 191     printHLStr();
	call printhlstr
; 192     
; 193     hl = wifiSettingsMacLabelPos;
	ld hl, (wifisettingsmaclabelpos)
; 194     setPosCursor();
	call setposcursor
; 195     hl = wifiSettingsMacLabel;
	ld hl, wifisettingsmaclabel
; 196     printHLStr();
	call printhlstr
; 197     
; 198     hl = wifiSettingsMacValPos;
	ld hl, (wifisettingsmacvalpos)
; 199     setPosCursor();
	call setposcursor
; 200     hl = wifiSettingsMacVal;
	ld hl, wifisettingsmacval
; 201     printHLStr();
	call printhlstr
; 202     
; 203     hl = wifiSettingsIpValPos;
	ld hl, (wifisettingsipvalpos)
; 204     setPosCursor();
	call setposcursor
; 205     hl = wifiSettingsIpVal;
	ld hl, wifisettingsipval
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
	jp printhlstr
; 212 }
; 213 
; 214 void clearScreen() {
clearscreen:
; 215     c = 0x1B;
	ld c, 27
; 216     printChatC();
	call printchatc
; 217     c = 0x45;
	ld c, 69
; 218     printChatC();
	jp printchatc
; 219 }
; 220 
; 221 void drowRect() {
drowrect:
; 222     setMyFont();
	call setmyfont
; 223     
; 224     //h = y
; 225     a = drowRectY;
	ld a, (drowrecty)
; 226     h = a;
	ld h, a
; 227     
; 228     do {
l_17:
; 229         //l = x
; 230         a = drowRectX;
	ld a, (drowrectx)
; 231         l = a;
	ld l, a
; 232         
; 233         push_pop(hl) {
	push hl
; 234             setPosCursor();
	call setposcursor
	pop hl
; 235         }
; 236         
; 237         do {
l_20:
; 238             if ((a = drowRectY) == h) {
	ld a, (drowrecty)
	cp h
	jp nz, l_23
; 239                 c = 0x26;
	ld c, 38
; 240                 if ((a = drowRectX) == l) {
	ld a, (drowrectx)
	cp l
	jp nz, l_25
; 241                     c = 0x21;
	ld c, 33
l_25:
; 242                 }
; 243                 if ((a = drowRectEndX)-- == l) {
	ld a, (drowrectendx)
	dec a
	cp l
	jp nz, l_27
; 244                     c = 0x23;
	ld c, 35
l_27:
	jp l_24
l_23:
; 245                 }
; 246             } else if ((a = drowRectEndY)-- == h) {
	ld a, (drowrectendy)
	dec a
	cp h
	jp nz, l_29
; 247                 c = 0x26;
	ld c, 38
; 248                 if ((a = drowRectX) == l) {
	ld a, (drowrectx)
	cp l
	jp nz, l_31
; 249                     c = 0x22;
	ld c, 34
l_31:
; 250                 }
; 251                 if ((a = drowRectEndX)-- == l) {
	ld a, (drowrectendx)
	dec a
	cp l
	jp nz, l_33
; 252                     c = 0x24;
	ld c, 36
l_33:
	jp l_30
l_29:
; 253                 }
; 254             } else {
; 255                 c = 0x20;
	ld c, 32
; 256                 if ((a = drowRectX) == l) {
	ld a, (drowrectx)
	cp l
	jp nz, l_35
; 257                     c = 0x25;
	ld c, 37
l_35:
; 258                 }
; 259                 if ((a = drowRectEndX)-- == l) {
	ld a, (drowrectendx)
	dec a
	cp l
	jp nz, l_37
; 260                     c = 0x25;
	ld c, 37
l_37:
l_30:
l_24:
; 261                 }
; 262             }
; 263             
; 264             push_pop(hl) {
	push hl
; 265                 printChatC();
	call printchatc
	pop hl
; 266             }
; 267             
; 268             a = drowRectEndX;
	ld a, (drowrectendx)
; 269             l++;
	inc l
; 270             a -= l;
	sub l
l_21:
	jp nz, l_20
; 271         } while (flag_nz);
; 272         
; 273         a = drowRectEndY;
	ld a, (drowrectendy)
; 274         h++;
	inc h
; 275         a -= h;
	sub h
l_18:
	jp nz, l_17
; 276     } while (flag_nz);
; 277     
; 278     setSystemFont();
	jp setsystemfont
; 279 }
; 280 
; 281 void setMyFont() {
setmyfont:
; 282     hl = fontAddress;
	ld hl, (fontaddress)
; 283     systemFontAddress = hl;
	ld (systemfontaddress), hl
; 284     hl = &myFont;
	ld hl, myfont
; 285     fontAddress = hl;
	ld (fontaddress), hl
	ret
; 286 }
; 287 
; 288 void setSystemFont() {
setsystemfont:
; 289     hl = systemFontAddress;
	ld hl, (systemfontaddress)
; 290     fontAddress = hl;
	ld (fontaddress), hl
	ret
; 291 }
; 292 
; 293 uint8_t drowRectX = 0x00;
drowrectx:
	db 0
; 294 uint8_t drowRectY = 0x00;
drowrecty:
	db 0
; 295 uint8_t drowRectEndX = 0x00;
drowrectendx:
	db 0
; 296 uint8_t drowRectEndY = 0x00;
drowrectendy:
	db 0
; 298 uint16_t systemFontAddress = 0x0000;
systemfontaddress:
	dw 0
; 300 void updateDiskList() {
updatedisklist:
; 301     a = diskViewDiskNum;
	ld a, (diskviewdisknum)
; 302     ordos_wnd();
	call ordos_wnd
; 303     hl = startListBufer;
	ld hl, 0
; 304     ordos_dirm();
	call ordos_dirm
; 305     diskViewListCount = a;
	ld (diskviewlistcount), a
	ret
; 306 }
; 307 
; 308 void showDiskList() {
showdisklist:
; 309     b = 0;
	ld b, 0
; 310     showDiskDriveName();
	call showdiskdrivename
; 311     showDiskDir();
	call showdiskdir
; 312     hl = diskViewListNamePos;
	ld hl, (diskviewlistnamepos)
; 313     
; 314     if ((a = diskViewListCount) == 0) {
	ld a, (diskviewlistcount)
	or a
	jp nz, l_39
; 315         return;
	ret
l_39:
; 316     }
; 317     
; 318     do {
l_41:
; 319         setPosCursor();
	call setposcursor
; 320         a = b;
	ld a, b
; 321         push_pop(hl) {
	push hl
; 322             showDiskApp();
	call showdiskapp
	pop hl
; 323         };
; 324         
; 325         h++;
	inc h
; 326         b++;
	inc b
; 327         a = diskViewListCount;
	ld a, (diskviewlistcount)
; 328         a -= b;
	sub b
l_42:
	jp nz, l_41
	ret
; 329     } while (flag_nz);
; 330 }
; 331 
; 332 void showDiskDriveName() {
showdiskdrivename:
; 333     push_pop(hl) {
	push hl
; 334         hl = diskViewDriveNamePos;
	ld hl, (diskviewdrivenamepos)
; 335         setPosCursor();
	call setposcursor
; 336         a = diskViewDiskNum;
	ld a, (diskviewdisknum)
; 337         printChatA();
	call printchata
	pop hl
	ret
; 338     }
; 339 }
; 340 
; 341 void showDiskDir() {
showdiskdir:
; 342     push_pop(hl) {
	push hl
; 343         hl = diskViewListDirPos;
	ld hl, (diskviewlistdirpos)
; 344         setPosCursor();
	call setposcursor
; 345         hl = diskViewListDirLabel;
	ld hl, diskviewlistdirlabel
; 346         push_pop(bc) {
	push bc
; 347             if ((a = diskViewCurrPos) == 0) {
	ld a, (diskviewcurrpos)
	or a
	jp nz, l_44
; 348                 if ((a = rootViewCurrentView) == rootViewCurrentDiskView) {
	ld a, (rootviewcurrentview)
	or a
	jp nz, l_46
; 349                     a = 0xFF;
	ld a, 255
; 350                     inverceAddress = a;
	ld (inverceaddress), a
l_46:
l_44:
; 351                 }
; 352             }
; 353             printHLStr();
	call printhlstr
; 354             a = 0;
	ld a, 0
; 355             inverceAddress = a;
	ld (inverceaddress), a
	pop bc
	pop hl
	ret
; 356         }
; 357     }
; 358 }
; 359 
; 360 ///A - count app
; 361 void showDiskApp() {
showdiskapp:
; 362     push_pop(bc) {
	push bc
; 363         
; 364         c = a;
	ld c, a
; 365         carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 366         hl = startListBufer;
	ld hl, 0
; 367         a += l;
	add l
; 368         l = a;
	ld l, a
; 369         if (flag_c) {
	jp nc, l_48
; 370             h++;
	inc h
l_48:
; 371         }
; 372         
; 373         if ((a = diskViewCurrPos)-- == c) {
	ld a, (diskviewcurrpos)
	dec a
	cp c
	jp nz, l_50
; 374             if ((a = rootViewCurrentView) == rootViewCurrentDiskView) {
	ld a, (rootviewcurrentview)
	or a
	jp nz, l_52
; 375                 a = 0xFF;
	ld a, 255
; 376                 inverceAddress = a;
	ld (inverceaddress), a
l_52:
l_50:
; 377             }
; 378         }
; 379     
; 380         a = ' ';
	ld a, 32
; 381         printChatA();
	call printchata
; 382         b = 0;
	ld b, 0
; 383         
; 384         do {
l_54:
; 385             a = *hl;
	ld a, (hl)
; 386             printChatA();
	call printchata
; 387             hl++;
	inc hl
; 388             b++;
	inc b
; 389             a = 8;
	ld a, 8
; 390             a -= b;
	sub b
l_55:
	jp nz, l_54
; 391         } while (flag_nz);
; 392         a = ' ';
	ld a, 32
; 393         printChatA();
	call printchata
	pop bc
; 394     };
; 395     a = 0;
	ld a, 0
; 396     inverceAddress = a;
	ld (inverceaddress), a
	ret
; 397 }
; 398 
; 399 void diskViewKeyA() {
diskviewkeya:
; 400     push_pop(bc) {
	push bc
; 401         b = a;
	ld b, a
; 402         
; 403         if (a == 0x1A) { //down
	cp 26
	jp nz, l_57
; 404             a = diskViewListCount;
	ld a, (diskviewlistcount)
; 405             c = a;
	ld c, a
; 406             if ( (a = diskViewCurrPos) < c  ) {
	ld a, (diskviewcurrpos)
	cp c
	jp nc, l_59
; 407                 a++;
	inc a
; 408                 diskViewCurrPos = a;
	ld (diskviewcurrpos), a
l_59:
	jp l_58
l_57:
; 409             }
; 410         } else if (a == 0x19) { //up
	cp 25
	jp nz, l_61
; 411             if ( (a = diskViewCurrPos) > 0 ) {
	ld a, (diskviewcurrpos)
	or a
	jp z, l_63
; 412                 a--;
	dec a
; 413                 diskViewCurrPos = a;
	ld (diskviewcurrpos), a
l_63:
	jp l_62
l_61:
; 414             }
; 415         } else if (a == 0x0D) { //Enter
	cp 13
	jp nz, l_65
; 416             if ((a = diskViewCurrPos) == 0) { // Change drive
	ld a, (diskviewcurrpos)
	or a
	jp nz, l_67
; 417                 a = diskViewDiskNum;
	ld a, (diskviewdisknum)
; 418                 if (a == 'B') {
	cp 66
	jp nz, l_69
; 419                     a = 'C';
	ld a, 67
	jp l_70
l_69:
; 420                 } else if (a == 'C') {
	cp 67
	jp nz, l_71
; 421                     a = 'D';
	ld a, 68
	jp l_72
l_71:
; 422                 } else if (a == 'D') {
	cp 68
	jp nz, l_73
; 423                     a = 'B';
	ld a, 66
l_73:
l_72:
l_70:
; 424                 }
; 425                 diskViewDiskNum = a;
	ld (diskviewdisknum), a
; 426                 diskView();
	call diskview
; 427                 updateDiskList();
	call updatedisklist
	jp l_68
l_67:
; 428             } else { // Upload file to FTP
l_68:
l_65:
l_62:
l_58:
	pop bc
	ret
; 429                 
; 430             }
; 431         }
; 432     }
; 433 }
; 434 
; 435 void showHelpStr() {
showhelpstr:
; 436     push_pop(hl) {
	push hl
; 437         hl = rootViewHelpStrPos;
	ld hl, (rootviewhelpstrpos)
; 438         setPosCursor();
	call setposcursor
; 439         hl = rootViewHelpStr;
	ld hl, rootviewhelpstr
; 440         printHLStr();
	call printhlstr
	pop hl
	ret
; 441     }
; 442 }
; 443 
; 444 void showFtpSettingsEditView() {
showftpsettingseditview:
; 445     drowRectX = (a = ftpSettingsEditViewX);
	ld a, (ftpsettingseditviewx)
	ld (drowrectx), a
; 446     drowRectY = (a = ftpSettingsEditViewY);
	ld a, (ftpsettingseditviewy)
	ld (drowrecty), a
; 447     drowRectEndX = (a = ftpSettingsEditViewEX);
	ld a, (ftpsettingseditviewex)
	ld (drowrectendx), a
; 448     drowRectEndY = (a = ftpSettingsEditViewEY);
	ld a, (ftpsettingseditviewey)
	ld (drowrectendy), a
; 449     drowRect();
	call drowrect
; 450     
; 451     hl = ftpSettingsEditViewLabelPos;
	ld hl, (ftpsettingseditviewlabelpos)
; 452     setPosCursor();
	call setposcursor
; 453     hl = ftpSettingsEditViewLabel;
	ld hl, ftpsettingseditviewlabel
; 454     printHLStr();
	call printhlstr
; 455     
; 456     hl = ftpSettingsEditViewIpLabelPos;
	ld hl, (ftpsettingseditviewiplabelpos)
; 457     setPosCursor();
	call setposcursor
; 458     hl = ftpSettingsIpLabel;
	ld hl, ftpsettingsiplabel
; 459     printHLStr();
	call printhlstr
; 460     
; 461     hl = ftpSettingsEditViewPortLabelPos;
	ld hl, (ftpsettingseditviewportlabelpos)
; 462     setPosCursor();
	call setposcursor
; 463     hl = ftpSettingsPortLabel;
	ld hl, ftpsettingsportlabel
; 464     printHLStr();
	call printhlstr
; 465     
; 466     hl = ftpSettingsEditViewUserLabelPos;
	ld hl, (ftpsettingseditviewuserlabelpos)
; 467     setPosCursor();
	call setposcursor
; 468     hl = ftpSettingsUserLabel;
	ld hl, ftpsettingsuserlabel
; 469     printHLStr();
	call printhlstr
; 470     
; 471     hl = ftpSettingsEditViewPasswordLabelPos;
	ld hl, (ftpsettingseditviewpasswordlabel)
; 472     setPosCursor();
	call setposcursor
; 473     hl = ftpSettingsEditViewPasswordLabel;
	ld hl, ftpsettingseditviewpasswordlabel_0
; 474     printHLStr();
	call printhlstr
; 475     
; 476     hl = ftpSettingsEditViewOkLabelPos;
	ld hl, (ftpsettingseditviewoklabelpos)
; 477     setPosCursor();
	call setposcursor
; 478     hl = ftpSettingsEditViewOkLabel;
	ld hl, ftpsettingseditviewoklabel
; 479     printHLStr();
	jp printhlstr
; 480 }
; 481 
; 482 void needOpenFTPSettingsEditView() {
needopenftpsettingseditview:
; 483     push_pop(hl) {
	push hl
; 484         if ((a = rootViewCurrentView) != rootViewCurrentFTPSettingsEditView) { //Если уже открыты настройки - не открываем
	ld a, (rootviewcurrentview)
	cp 2
	jp z, l_75
; 485             if ((a = rootViewCurrentView) != rootViewCurrentFTPSettingsEditView) { //Если открыта настройка WiFi тоже не открываем
	ld a, (rootviewcurrentview)
	cp 2
	jp z, l_77
; 486                 
; 487                 a = rootViewCurrentFTPSettingsEditView;
	ld a, 2
; 488                 rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 489                 a = 4;
	ld a, 4
; 490                 ftpSettingsEditViewCurrentPos = a;
	ld (ftpsettingseditviewcurrentpos), a
; 491                 
; 492                 showDiskList(); //Сбросить выделение строки
	call showdisklist
; 493                 showFtpSettingsEditView();
	call showftpsettingseditview
; 494                 ftpSettingsEditViewDataUpdate();
	call ftpsettingseditviewdataupdate
l_77:
l_75:
	pop hl
	ret
; 495             }
; 496         }
; 497     }
; 498 }
; 499 
; 500 void ftpSettingsEditViewKeyA() {
ftpsettingseditviewkeya:
; 501     push_pop(hl) {
	push hl
; 502         l = a;
	ld l, a
; 503         if ((a = rootViewCurrentView) == rootViewCurrentFTPSettingsEditView) {
	ld a, (rootviewcurrentview)
	cp 2
	jp nz, l_79
; 504             a = l;
	ld a, l
; 505             if (a == 0x1B) { //ESC выход из настройки
	cp 27
	jp nz, l_81
; 506                 a = rootViewCurrentDiskView; // переходим на список файлов на диске
	ld a, 0
; 507                 rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 508                 
; 509                 updateRootUI();
	call updaterootui
; 510                 updateRootDataUI();
	call updaterootdataui
	jp l_82
l_81:
; 511             } else {
; 512                 if (a == 0x1A) { //down
	cp 26
	jp nz, l_83
; 513                     a = ftpSettingsEditViewCurrentPos;
	ld a, (ftpsettingseditviewcurrentpos)
; 514                     a++;
	inc a
; 515                     if (a == 5) {
	cp 5
	jp nz, l_85
; 516                         a = 0;
	ld a, 0
l_85:
; 517                     }
; 518                     ftpSettingsEditViewCurrentPos = a;
	ld (ftpsettingseditviewcurrentpos), a
	jp l_84
l_83:
; 519                 } else if (a == 0x19) { //up
	cp 25
	jp nz, l_87
; 520                     a = ftpSettingsEditViewCurrentPos;
	ld a, (ftpsettingseditviewcurrentpos)
; 521                     if (a == 0) {
	or a
	jp nz, l_89
; 522                         a = 4;
	ld a, 4
	jp l_90
l_89:
; 523                     } else {
; 524                         a--;
	dec a
l_90:
; 525                     }
; 526                     ftpSettingsEditViewCurrentPos = a;
	ld (ftpsettingseditviewcurrentpos), a
	jp l_88
l_87:
; 527                 } else if (a == 0x0D) { //Enter
	cp 13
	jp nz, l_91
; 528                     if ((a = ftpSettingsEditViewCurrentPos) == 4) { // Нажатие на кнопку ОК
	ld a, (ftpsettingseditviewcurrentpos)
	cp 4
	jp nz, l_93
; 529                         a = rootViewCurrentDiskView; // переходим на список файлов на диске
	ld a, 0
; 530                         rootViewCurrentView = a;
	ld (rootviewcurrentview), a
; 531                         
; 532                         updateRootUI();
	call updaterootui
; 533                         updateRootDataUI();
	call updaterootdataui
	jp l_94
l_93:
; 534                     } else {
; 535                         ftpSettingsEditViewSelectEditField();
	call ftpsettingseditviewselecteditfie
l_94:
l_91:
l_88:
l_84:
l_82:
l_79:
	pop hl
	ret
; 536                     }
; 537                 }
; 538             }
; 539         }
; 540     }
; 541 }
; 542 
; 543 void ftpSettingsEditViewSelectEditField() {
ftpsettingseditviewselecteditfie:
; 544     a = ftpSettingsEditViewCurrentPos;
	ld a, (ftpsettingseditviewcurrentpos)
; 545     if (a == 0) {
	or a
	jp nz, l_95
; 546         hl = ftpSettingsEditViewIpValPos;
	ld hl, (ftpsettingseditviewipvalpos)
; 547         ftpSettingsEditViewEditValuePos = hl;
	ld (ftpsettingseditvieweditvaluepos), hl
; 548         setPosCursor();
	call setposcursor
; 549         
; 550         push_pop(hl) {
	push hl
; 551             hl = ftpSettingsIpValue;
	ld hl, ftpsettingsipvalue
; 552             ftpSettingsEditView_CopyStrFromHL();
	call ftpsettingseditview_copystrfromh
	pop hl
	jp l_96
l_95:
; 553         }
; 554     } else if (a == 1) {
	cp 1
	jp nz, l_97
; 555         hl = ftpSettingsEditViewPortValPos;
	ld hl, (ftpsettingseditviewportvalpos)
; 556         ftpSettingsEditViewEditValuePos = hl;
	ld (ftpsettingseditvieweditvaluepos), hl
; 557         setPosCursor();
	call setposcursor
; 558         
; 559         push_pop(hl) {
	push hl
; 560             hl = ftpSettingsPortValue;
	ld hl, ftpsettingsportvalue
; 561             ftpSettingsEditView_CopyStrFromHL();
	call ftpsettingseditview_copystrfromh
	pop hl
	jp l_98
l_97:
; 562         }
; 563     } else if (a == 2) {
	cp 2
	jp nz, l_99
; 564         hl = ftpSettingsEditViewUserValPos;
	ld hl, (ftpsettingseditviewuservalpos)
; 565         ftpSettingsEditViewEditValuePos = hl;
	ld (ftpsettingseditvieweditvaluepos), hl
; 566         setPosCursor();
	call setposcursor
; 567         
; 568         push_pop(hl) {
	push hl
; 569             hl = ftpSettingsUserValue;
	ld hl, ftpsettingsuservalue
; 570             ftpSettingsEditView_CopyStrFromHL();
	call ftpsettingseditview_copystrfromh
	pop hl
	jp l_100
l_99:
; 571         }
; 572     } else if (a == 3) {
	cp 3
	jp nz, l_101
; 573         hl = ftpSettingsEditViewPasswordValPos;
	ld hl, (ftpsettingseditviewpasswordvalpo)
; 574         ftpSettingsEditViewEditValuePos = hl;
	ld (ftpsettingseditvieweditvaluepos), hl
; 575         setPosCursor();
	call setposcursor
; 576         
; 577         push_pop(hl) {
	push hl
; 578             hl = ftpSettingsEditViewPasswordVal;
	ld hl, ftpsettingseditviewpasswordval
; 579             ftpSettingsEditView_CopyStrFromHL();
	call ftpsettingseditview_copystrfromh
	pop hl
l_101:
l_100:
l_98:
l_96:
; 580         }
; 581     }
; 582     ftpSettingsEditViewEditField();
	jp ftpsettingseditvieweditfield
; 583 }
; 584 
; 585 void ftpSettingsEditViewSaveField() {
ftpsettingseditviewsavefield:
; 586     a = ftpSettingsEditViewCurrentPos;
	ld a, (ftpsettingseditviewcurrentpos)
; 587     if (a == 0) {
	or a
	jp nz, l_103
; 588         hl = ftpSettingsIpValue;
	ld hl, ftpsettingsipvalue
	jp l_104
l_103:
; 589     } else if (a == 1) {
	cp 1
	jp nz, l_105
; 590         hl = ftpSettingsPortValue;
	ld hl, ftpsettingsportvalue
	jp l_106
l_105:
; 591     } else if (a == 2) {
	cp 2
	jp nz, l_107
; 592         hl = ftpSettingsUserValue;
	ld hl, ftpsettingsuservalue
	jp l_108
l_107:
; 593     } else if (a == 3) {
	cp 3
	jp nz, l_109
; 594         hl = ftpSettingsEditViewPasswordVal;
	ld hl, ftpsettingseditviewpasswordval
l_109:
l_108:
l_106:
l_104:
; 595     }
; 596     ftpSettingsEditViewSaveEditValueToHL();
; 597 }
; 598 
; 599 void ftpSettingsEditViewSaveEditValueToHL() {
ftpsettingseditviewsaveeditvalue:
; 600     push_pop(de) {
	push de
; 601         push_pop(bc) {
	push bc
; 602             de = ftpSettingsEditViewEditValue;
	ld de, ftpsettingseditvieweditvalue
; 603             a = ftpSettingsEditViewEditPos;
	ld a, (ftpsettingseditvieweditpos)
; 604             c = a;
	ld c, a
; 605             b = 0;
	ld b, 0
; 606             do {
l_111:
; 607                 a = *de;
	ld a, (de)
; 608                 *hl = a;
	ld (hl), a
; 609                 hl++;
	inc hl
; 610                 de++;
	inc de
; 611                 b++;
	inc b
; 612                 a = b;
	ld a, b
; 613                 a -= c;
	sub c
l_112:
	jp nz, l_111
; 614             } while (flag_nz);
; 615             *hl = 0;
	ld (hl), 0
	pop bc
	pop de
	ret
; 616         }
; 617     }
; 618 }
; 619 
; 620 void ftpSettingsEditView_CopyStrFromHL() {
ftpsettingseditview_copystrfromh:
; 621     push_pop(de) {
	push de
; 622         push_pop(bc) {
	push bc
; 623             de = ftpSettingsEditViewEditValue;
	ld de, ftpsettingseditvieweditvalue
; 624             b = 0;
	ld b, 0
; 625             c = 0;
	ld c, 0
; 626             do {
l_114:
; 627                 a = *hl;
	ld a, (hl)
; 628                 *de = a;
	ld (de), a
; 629                 if ((a = b) == 22) {
	ld a, b
	cp 22
	jp nz, l_117
; 630                     a = 0;
	ld a, 0
; 631                     *de = a;
	ld (de), a
	jp l_118
l_117:
; 632                 } else if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_119
; 633                     a = ' ';
	ld a, 32
; 634                     *de = a;
	ld (de), a
	jp l_120
l_119:
; 635                 } else if ((a = *de) == 0) {
	ld a, (de)
	or a
	jp nz, l_121
; 636                     c = 1;
	ld c, 1
; 637                     a = ' ';
	ld a, 32
; 638                     *de = a;
	ld (de), a
; 639                     a = b;
	ld a, b
; 640                     ftpSettingsEditViewEditPos = a;
	ld (ftpsettingseditvieweditpos), a
l_121:
l_120:
l_118:
; 641                 }
; 642                 
; 643                 hl ++;
	inc hl
; 644                 de++;
	inc de
; 645                 b++;
	inc b
; 646                 a = b;
	ld a, b
; 647                 a -= 23;
	sub 23
l_115:
	jp nz, l_114
	pop bc
	pop de
	ret
; 648             } while (flag_nz);
; 649         }
; 650     }
; 651 }
; 652 
; 653 void ftpSettingsEditViewEditField() {
ftpsettingseditvieweditfield:
; 654     hl = ftpSettingsEditViewEditValuePos;
	ld hl, (ftpsettingseditvieweditvaluepos)
; 655     setPosCursor();
	call setposcursor
; 656     
; 657     a = 0xFF;
	ld a, 255
; 658     inverceAddress = a;
	ld (inverceaddress), a
; 659     
; 660     hl = ftpSettingsEditViewEditValue;
	ld hl, ftpsettingseditvieweditvalue
; 661     printHLStr();
	call printhlstr
; 662     
; 663     ftpSettingsEditViewSetEditCursor();
	call ftpsettingseditviewseteditcursor
; 664     push_pop(bc) {
	push bc
; 665         b = 0;
	ld b, 0
; 666         do {
l_123:
; 667             getKeyboardCharA();
	call getkeyboardchara
; 668             
; 669             if (a == 0x1B) { // выход из редактирования без сохранения
	cp 27
	jp nz, l_126
; 670                 b = 1;
	ld b, 1
	jp l_127
l_126:
; 671             } else if (a == 0x0D) { // Сохранить и выйти из редактирования
	cp 13
	jp nz, l_128
; 672                 b = 1;
	ld b, 1
; 673                 ftpSettingsEditViewSaveField();
	call ftpsettingseditviewsavefield
	jp l_129
l_128:
; 674             } else if (a >= 0x20) {
	cp 32
	jp c, l_130
; 675                 if (a < 0x7F) { //Ввод символа
	cp 127
	jp nc, l_132
; 676                     c = a;
	ld c, a
; 677                     // Если достигли предела - то перемещаем курсор на 1 назад
; 678                     a = ftpSettingsEditViewEditPos;
	ld a, (ftpsettingseditvieweditpos)
; 679                     if (a >= 15) {
	cp 15
	jp c, l_134
; 680                         a--;
	dec a
l_134:
; 681                     }
; 682                     ftpSettingsEditViewEditPos = a;
	ld (ftpsettingseditvieweditpos), a
; 683                     
; 684                     //Сохраняем символ
; 685                     a = c;
	ld a, c
; 686                     ftpSettingsEditViewSetValueA();
	call ftpsettingseditviewsetvaluea
; 687                     a = ftpSettingsEditViewEditPos;
	ld a, (ftpsettingseditvieweditpos)
; 688                     a++;
	inc a
; 689                     ftpSettingsEditViewEditPos = a;
	ld (ftpsettingseditvieweditpos), a
; 690                     ftpSettingsEditViewSetEditCursor();
	call ftpsettingseditviewseteditcursor
	jp l_133
l_132:
; 691                 } else if (a == 0x7F) { //Забой... (удаление символа)
	cp 127
	jp nz, l_136
; 692                     if ((a = ftpSettingsEditViewEditPos) > 0) {
	ld a, (ftpsettingseditvieweditpos)
	or a
	jp z, l_138
; 693                         a--;
	dec a
; 694                         ftpSettingsEditViewEditPos = a;
	ld (ftpsettingseditvieweditpos), a
; 695                         ftpSettingsEditViewSetEditCursor();
	call ftpsettingseditviewseteditcursor
; 696                         a = ' ';
	ld a, 32
; 697                         ftpSettingsEditViewSetValueA();
	call ftpsettingseditviewsetvaluea
l_138:
l_136:
l_133:
l_130:
l_129:
l_127:
; 698                     }
; 699                 }
; 700             }
; 701             
; 702             a = b;
	ld a, b
; 703             a -= 1;
	sub 1
l_124:
	jp nz, l_123
	pop bc
; 704         } while (flag_nz);
; 705     }
; 706     
; 707     a = 0x00;
	ld a, 0
; 708     inverceAddress = a;
	ld (inverceaddress), a
; 709     
; 710     showFtpSettingsEditView();
	call showftpsettingseditview
; 711     ftpSettingsEditViewDataUpdate();
	jp ftpsettingseditviewdataupdate
; 712 }
; 713 
; 714 void ftpSettingsEditViewSetValueA() {
ftpsettingseditviewsetvaluea:
; 715     push_pop(hl) {
	push hl
; 716         push_pop(bc) {
	push bc
; 717             b = a;
	ld b, a
; 718             //Сохраним символ в ftpSettingsEditViewEditValue
; 719             hl = ftpSettingsEditViewEditValue;
	ld hl, ftpsettingseditvieweditvalue
; 720             a = ftpSettingsEditViewEditPos;
	ld a, (ftpsettingseditvieweditpos)
; 721             a += l;
	add l
; 722             l = a;
	ld l, a
; 723             if (flag_c) {
	jp nc, l_140
; 724                 h++;
	inc h
l_140:
; 725             }
; 726             *hl = b;
	ld (hl), b
; 727             //Отрисуем символ на экране
; 728             ftpSettingsEditViewSetEditCursor();
	call ftpsettingseditviewseteditcursor
; 729             a = b;
	ld a, b
; 730             printChatA();
	call printchata
; 731             ftpSettingsEditViewSetEditCursor();
	call ftpsettingseditviewseteditcursor
	pop bc
	pop hl
	ret
; 732         }
; 733     }
; 734 }
; 735 
; 736 void ftpSettingsEditViewSetEditCursor() {
ftpsettingseditviewseteditcursor:
; 737     push_pop(hl) {
	push hl
; 738         hl = ftpSettingsEditViewEditValuePos;
	ld hl, (ftpsettingseditvieweditvaluepos)
; 739         a = ftpSettingsEditViewEditPos;
	ld a, (ftpsettingseditvieweditpos)
; 740         a += l;
	add l
; 741         l = a;
	ld l, a
; 742         setPosCursor();
	call setposcursor
	pop hl
	ret
; 743     }
; 744 }
; 745 
; 746 void ftpSettingsEditViewDataUpdate() {
ftpsettingseditviewdataupdate:
; 747     if ((a = rootViewCurrentView) != rootViewCurrentFTPSettingsEditView) {
	ld a, (rootviewcurrentview)
	cp 2
	jp z, l_142
; 748         return;
	ret
l_142:
; 749     }
; 750     
; 751     push_pop(bc) {
	push bc
; 752         b = 0;
	ld b, 0
; 753         do {
l_144:
; 754             if ((a = ftpSettingsEditViewCurrentPos) == b) {
	ld a, (ftpsettingseditviewcurrentpos)
	cp b
	jp nz, l_147
; 755                 a = 0xFF;
	ld a, 255
; 756                 inverceAddress = a;
	ld (inverceaddress), a
l_147:
; 757             }
; 758             
; 759             a = b;
	ld a, b
; 760             ftpSettingsEditViewShowValueA();
	call ftpsettingseditviewshowvaluea
; 761             
; 762             a = 0x00;
	ld a, 0
; 763             inverceAddress = a;
	ld (inverceaddress), a
; 764             
; 765             b++;
	inc b
; 766             a = b;
	ld a, b
; 767             a -= 5;
	sub 5
l_145:
	jp nz, l_144
	pop bc
	ret
; 11 void ftpSettingsEditViewShowValueA() {
ftpsettingseditviewshowvaluea:
; 12     if (a == 0) {
	or a
	jp nz, l_149
; 13         hl = ftpSettingsEditViewIpValPos;
	ld hl, (ftpsettingseditviewipvalpos)
; 14         setPosCursor();
	call setposcursor
; 15         
; 16         hl = ftpSettingsIpValue;
	ld hl, ftpsettingsipvalue
; 17         printHLStr();
	call printhlstr
	jp l_150
l_149:
; 18     } else if (a == 1) {
	cp 1
	jp nz, l_151
; 19         hl = ftpSettingsEditViewPortValPos;
	ld hl, (ftpsettingseditviewportvalpos)
; 20         setPosCursor();
	call setposcursor
; 21         
; 22         hl = ftpSettingsPortValue;
	ld hl, ftpsettingsportvalue
; 23         printHLStr();
	call printhlstr
	jp l_152
l_151:
; 24     } else if (a == 2) {
	cp 2
	jp nz, l_153
; 25         hl = ftpSettingsEditViewUserValPos;
	ld hl, (ftpsettingseditviewuservalpos)
; 26         setPosCursor();
	call setposcursor
; 27         
; 28         hl = ftpSettingsUserValue;
	ld hl, ftpsettingsuservalue
; 29         printHLStr();
	call printhlstr
	jp l_154
l_153:
; 30     } else if (a == 3) {
	cp 3
	jp nz, l_155
; 31         hl = ftpSettingsEditViewPasswordValPos;
	ld hl, (ftpsettingseditviewpasswordvalpo)
; 32         setPosCursor();
	call setposcursor
; 33         
; 34         hl = ftpSettingsEditViewPasswordVal;
	ld hl, ftpsettingseditviewpasswordval
; 35         printHLStr();
	call printhlstr
	jp l_156
l_155:
; 36     } else if (a == 4) {
	cp 4
	jp nz, l_157
; 37         hl = ftpSettingsEditViewOkLabelPos;
	ld hl, (ftpsettingseditviewoklabelpos)
; 38         setPosCursor();
	call setposcursor
; 39         hl = ftpSettingsEditViewOkLabel;
	ld hl, ftpsettingseditviewoklabel
; 40         printHLStr();
	call printhlstr
l_157:
l_156:
l_154:
l_152:
l_150:
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
; 26 uint8_t wifiSettingsSsidVal[20] = "K159";
wifisettingsssidval:
	db 75
	db 49
	db 53
	db 57
	ds 16
; 27 uint16_t wifiSettingsIpValPos = 0x0308;
wifisettingsipvalpos:
	dw 776
; 28 uint8_t wifiSettingsIpVal[20] = "192.168.1.127";
wifisettingsipval:
	db 49
	db 57
	db 50
	db 46
	db 49
	db 54
	db 56
	db 46
	db 49
	db 46
	db 49
	db 50
	db 55
	ds 7
; 29 uint16_t wifiSettingsMacValPos = 0x0408;
wifisettingsmacvalpos:
	dw 1032
; 30 uint8_t wifiSettingsMacVal[20] = "10:98:C3:DC:88:06";
wifisettingsmacval:
	db 49
	db 48
	db 58
	db 57
	db 56
	db 58
	db 67
	db 51
	db 58
	db 68
	db 67
	db 58
	db 56
	db 56
	db 58
	db 48
	db 54
	ds 3
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
; 39 uint8_t ftpSettingsStatusValue[12] = "DISCONNECT";
ftpsettingsstatusvalue:
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
	ds 2
; 41 uint16_t ftpSettingsUserValuePos = 0x0326;
ftpsettingsuservaluepos:
	dw 806
; 42 uint8_t ftpSettingsUserValue[16] = "ESP8266";
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
l_159:
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
l_160:
	jp nz, l_159
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
 savebin "test.ORD", 0x00f0, 0xBff
