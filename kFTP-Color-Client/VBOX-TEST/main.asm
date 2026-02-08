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
ordos_rfile equ 49146
ordos_pscf equ 49125
ordos_rnd equ 49113
fontaddress equ 62417
inverceaddress equ 62419
keyrusaddress equ 62437
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
unpackcharcode equ 63533
vv55_setup equ 62979
vv55_port_c equ 62978
gotovbox equ 262
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
; 33 /// пп.чтения файла с диска
; 34 void ordos_rfile() __address(0xbffa);
; 35 /// поиск файла в диске
; 36 void ordos_pscf() __address(0xbfe5);
; 37 /// чтение имени текущего диска
; 38 void ordos_rnd() __address(0xbfd9);
; 12 extern uint16_t fontAddress __address(0xF3D1);
; 13 ///ячейка, хранящая признак прямого (00Н) вывода (светлые символы на темном фоне) или инверсного (0FFH) вывода (темные символы на светлом фоне)
; 14 extern uint16_t inverceAddress __address(0xF3D3);
; 15 /// признак рус (0ffh)/лат (00)
; 16 extern uint16_t keyRusAddress __address(0xF3E5);
; 17 
; 18 ///-----* Функции Монитора *-------
; 19 ///Вывод на экран HEX из регистра A
; 20 void printHexA() __address(0xF815);
; 21 ///Вывод символа на экран из регистра A
; 22 void printChatA() __address(0xF80F);
; 23 ///Вывод символа на экран из регистра С
; 24 void printChatC() __address(0xF809);
; 25 ///ЗАПИСЬ БАЙТА В ДОП. СТРАНИЦУ HL — АДРЕСА — N СТРАНИЦЫ (0-3) C — ЗАПИСЫВАЕМЫЙ БАЙТ
; 26 void writeByteInOtherMem() __address(0xF839);
; 27 ///УСТАНОВКА КУРСОРА ВХ. Н — НОМЕР СТРОКИ — Y L — НОМЕР ПОЗИЦИИ — X
; 28 void setPosCursor() __address(0xF83C);
; 29 ///ЗАПРОС ПОЛОЖЕНИЯ КУРСОРА Н - НОМЕР СТРОКИ - Y , L - НОМЕР ПОЗИЦИИ - X
; 30 void getPosCursor() __address(0xF81E);
; 31 ///ВЫВОД НА ЭКРАН СООБЩЕНИЯ ВХ.: HL- - АДРЕС НАЧАЛА КОНЕЧНЫЙ БАЙТ - 00Н
; 32 void printHLStr() __address(0xF818);
; 33 
; 34 ///ВВОД C СИМВОЛА С КЛАВИАТУРЫ А - ВВЕДЕННЫЙ СИМВОЛ
; 35 void getKeyboardCharA() __address(0xF803);
; 36 ///ОПРОС СОСТОЯНИЯ КЛАВИАТУРЫ А = 00Н - НЕ НАЖАТА , А = 0FFH - НАЖАТА
; 37 void getKeyboardStateA() __address(0xF812);
; 38 ///ВВОД КОДА НАЖАТОЙ КЛАВИШИ А = 0FFH - НЕ НАЖАТА А = 0FEH - РУС/ЛАТ ИНАЧЕ - КОД КЛАВИШИ
; 39 void getKeyboardCodeA() __address(0xF81B);
; 40 
; 41 ///РАСПАКОВКА ВНУТРЕННЕГО ЗНАКОГЕНЕРАТОРА
; 42 void unpackCharCode() __address(0xF82D);
; 11 extern uint16_t VV55_SETUP __address(0xF603);
; 12 extern uint16_t VV55_PORT_C __address(0xF602);
; 18 void goToVBOX() __address(0x0106);

    org 0x00F0

; 19 
; 20 void mainStart();
; 21 void KeyboardEventA();
; 22 
; 23 asm{
; 24     org 0x00F0
; 25 }
; 26 
; 27 ///App Name
; 28 uint8_t appName[] = {'K','F','T','P','-','C','$',' '};
appname:
	db 75
	db 70
	db 84
	db 80
	db 45
	db 67
	db 36
	db 32


    DB 0x00, 0x01

    DB 0x00, 0x32

    DB 0x00, 0x00, 0x00, 0x00

; 39 void main(){
main:
; 40     sp = 0x6FFF;
	ld sp, 28671
; 41 //    nop();
; 42 //    nop();
; 43 //    nop();
; 44     mainStart();
	jp mainstart
; 45 }
; 46 
; 47 ///Exec VBOX
; 48 uint8_t jmpToVBOX = 0xc3;
jmptovbox:
	db 195
; 49 uint16_t startVboxAddr = 0x0000;
startvboxaddr:
	dw 0
; 51 void mainStart() {
mainstart:
; 52     hl = 0;
	ld hl, 0
; 53     setPosCursor();
	call setposcursor
; 54     a = 0;
	ld a, 0
; 55     NetIsLock = a;
	ld (netislock), a
; 56     
; 57     initI2C();
	call initi2c
; 58     vboxClearCash();
	call vboxclearcash
; 59     
; 60     HelpViewShow();
	call helpviewshow
; 61     FtpStateViewShow();
	call ftpstateviewshow
; 62     WifiStateViewShow();
	call wifistateviewshow
; 63     FtpViewShow();
	call ftpviewshow
; 64     DiskViewShow();
	call diskviewshow
; 65     
; 66     CurrentViewChangeIdA(a = FtpViewId);
	ld a, 2
	call currentviewchangeida
; 67     
; 68     #ifdef _IS_SIMULATOR
; 69 
; 70     #else
; 71         NetUpdateData();
	call netupdatedata
; 72         ThreadsTickNow();
	call threadsticknow
; 73     #endif
; 74     
; 75     for(;;) {
l_1:
; 76         //ThreadsTick();
; 77         #ifdef _IS_SIMULATOR
; 78             getKeyboardCharA();
; 79             KeyboardEventA();
; 80         #else
; 81             getKeyboardStateA();
	call getkeyboardstatea
; 82             if (a == 0xFF) {
	cp 255
	jp nz, l_3
; 83                 getKeyboardCodeA();
	call getkeyboardcodea
; 84                 KeyboardEventA();
	call keyboardeventa
	jp l_4
l_3:
; 85             } else {
; 86                 ThreadsTick();
	call threadstick
l_4:
	jp l_1
; 87             }
; 88         #endif
; 89     }
; 90 
; 91 }
; 92 
; 93 void KeyboardEventA() {
keyboardeventa:
; 94     push_pop(bc) {
	push bc
; 95         b = a; //Save
	ld b, a
; 96         if ((a = b) == 0x03) { //F4
	ld a, b
	cp 3
	jp nz, l_5
; 97             vboxClearCash();
	call vboxclearcash
; 98             ordos_start();
	call ordos_start
	jp l_6
l_5:
; 99         } else if ((a = b) == 0x02) { //F3 Open FTP settings
	ld a, b
	cp 2
	jp nz, l_7
; 100             CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
	ld a, (currentviewid)
	call currentviewdiskorftpviewbyida
; 101             if (a == 1) {
	cp 1
	jp nz, l_9
; 102                 FtpSettingsViewShow();
	call ftpsettingsviewshow
l_9:
	jp l_8
l_7:
; 103             }
; 104         } else if ((a = b) == 0x01) { //F2 Open WiFi settings
	ld a, b
	cp 1
	jp nz, l_11
; 105             CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
	ld a, (currentviewid)
	call currentviewdiskorftpviewbyida
; 106             if (a == 1) {
	cp 1
	jp nz, l_13
; 107                 WiFiSettingsViewShow();
	call wifisettingsviewshow
l_13:
l_11:
l_8:
l_6:
; 108             }
; 109         }
; 110         
; 111         c = 0;
	ld c, 0
; 112         if ((a = CurrentViewId) == DiskViewId) {
	ld a, (currentviewid)
	cp 1
	jp nz, l_15
; 113             DiskViewKeyA(a = b);
	ld a, b
	call diskviewkeya
; 114             c = 1;
	ld c, 1
	jp l_16
l_15:
; 115         } else if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, l_17
; 116             FtpViewKeyA(a = b);
	ld a, b
	call ftpviewkeya
; 117             c = 1;
	ld c, 1
	jp l_18
l_17:
; 118         } else if ((a = CurrentViewId) == SelectDiskViewId) {
	ld a, (currentviewid)
	cp 3
	jp nz, l_19
; 119             SelectDiskViewKeyA(a = b);
	ld a, b
	call selectdiskviewkeya
; 120             c = 1;
	ld c, 1
	jp l_20
l_19:
; 121         } else if ((a = CurrentViewId) == WiFiSettingsViewId) {
	ld a, (currentviewid)
	cp 5
	jp nz, l_21
; 122             WiFiSettingsViewKeyA(a = b);
	ld a, b
	call wifisettingsviewkeya
; 123             c = 1;
	ld c, 1
	jp l_22
l_21:
; 124         } else if ((a = CurrentViewId) == WiFiNetworksViewId) {
	ld a, (currentviewid)
	cp 7
	jp nz, l_23
; 125             WiFiNetworksViewKeyA(a = b);
	ld a, b
	call wifinetworksviewkeya
; 126             c = 1;
	ld c, 1
	jp l_24
l_23:
; 127         } else if ((a = CurrentViewId) == FtpSettingsViewId) {
	ld a, (currentviewid)
	cp 8
	jp nz, l_25
; 128             FtpSettingsViewKeyA(a = b);
	ld a, b
	call ftpsettingsviewkeya
; 129             c = 1;
	ld c, 1
l_25:
l_24:
l_22:
l_20:
l_18:
l_16:
	pop bc
	ret
; 11 void printMyHexA() {
printmyhexa:
; 12     push_pop(bc) {
	push bc
; 13         b = a;
	ld b, a
; 14         a &= 0xF0;
	and 240
; 15         cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 16         if (a < 10) {
	cp 10
	jp nc, l_27
; 17             a += 0x30;
	add 48
	jp l_28
l_27:
; 18         } else {
; 19             a += 0x37;
	add 55
l_28:
; 20         }
; 21         printMyChatA();
	call printmychata
; 22         a = b;
	ld a, b
; 23         a &= 0x0F;
	and 15
; 24         if (a < 10) {
	cp 10
	jp nc, l_29
; 25             a += 0x30;
	add 48
	jp l_30
l_29:
; 26         } else {
; 27             a += 0x37;
	add 55
l_30:
; 28         }
; 29         printMyChatA();
	call printmychata
	pop bc
	ret
; 30     }
; 31 }
; 32 
; 33 void printMyUTF8HLStr() {
printmyutf8hlstr:
; 34     do {
l_31:
; 35         a = *hl;
	ld a, (hl)
; 36         if (a == 0xD0) {
	cp 208
	jp nz, l_34
; 37             hl++;
	inc hl
; 38             a = *hl;
	ld a, (hl)
; 39             a += 0xF0;
	add 240
	jp l_35
l_34:
; 40         } else if (a == 0xD1) {
	cp 209
	jp nz, l_36
; 41             hl++;
	inc hl
; 42             a = *hl;
	ld a, (hl)
; 43             a += 0x60;
	add 96
l_36:
l_35:
; 44         }
; 45         if (a > 0 ) {
	or a
	jp z, l_38
; 46             printMyChatA();
	call printmychata
l_38:
; 47         }
; 48         //
; 49         a = *hl;
	ld a, (hl)
; 50         hl++;
	inc hl
l_32:
; 51     } while (a > 0);
	or a
	jp nz, l_31
	ret
; 52 }
; 53 
; 54 void printMyHLStr() {
printmyhlstr:
; 55     do {
l_40:
; 56         a = *hl;
	ld a, (hl)
; 57         if (a > 0) {
	or a
	jp z, l_43
; 58             printMyChatA();
	call printmychata
l_43:
; 59         }
; 60         a = *hl;
	ld a, (hl)
; 61         hl++;
	inc hl
l_41:
; 62     } while (a > 0);
	or a
	jp nz, l_40
	ret
; 63 }
; 64 
; 65 /// Выводит строку из HL с текущего положения
; 66 /// Длиной A. Если текст короче , то добиват до A пробелами
; 67 void printMyHLStrLenA() {
printmyhlstrlena:
; 68     push_pop(bc) {
	push bc
; 69         b = a;
	ld b, a
; 70         c = 0;
	ld c, 0
; 71         do {
l_45:
; 72             a = *hl;
	ld a, (hl)
; 73             if (a > 0) {
	or a
	jp z, l_48
; 74                 c++;
	inc c
; 75                 printMyChatA();
	call printmychata
l_48:
; 76             }
; 77             a = *hl;
	ld a, (hl)
; 78             hl++;
	inc hl
l_46:
; 79         } while (a > 0);
	or a
	jp nz, l_45
; 80         if ((a = c) < b) {
	ld a, c
	cp b
	jp nc, l_50
; 81             a = b;
	ld a, b
; 82             a -= c;
	sub c
; 83             b = a;
	ld b, a
; 84             do {
l_52:
; 85                 printMyChatA(a = ' ');
	ld a, 32
	call printmychata
; 86                 b--;
	dec b
l_53:
; 87             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_52
l_50:
	pop bc
	ret
; 88         }
; 89     }
; 90 }
; 91 
; 92 /// Выводит строку из HL с текущего положения заменяя все символы *
; 93 /// Длиной A. Если текст короче , то добиват до A пробелами
; 94 void printMyHLPassLenA() {
printmyhlpasslena:
; 95     push_pop(bc) {
	push bc
; 96         b = a;
	ld b, a
; 97         c = 0;
	ld c, 0
; 98         do {
l_55:
; 99             a = *hl;
	ld a, (hl)
; 100             if (a > 0) {
	or a
	jp z, l_58
; 101                 c++;
	inc c
; 102                 printMyChatA(a = '*');
	ld a, 42
	call printmychata
l_58:
; 103             }
; 104             a = *hl;
	ld a, (hl)
; 105             hl++;
	inc hl
l_56:
; 106         } while (a > 0);
	or a
	jp nz, l_55
; 107         if ((a = c) < b) {
	ld a, c
	cp b
	jp nc, l_60
; 108             a = b;
	ld a, b
; 109             a -= c;
	sub c
; 110             b = a;
	ld b, a
; 111             do {
l_62:
; 112                 printMyChatA(a = ' ');
	ld a, 32
	call printmychata
; 113                 b--;
	dec b
l_63:
; 114             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_62
l_60:
	pop bc
	ret
; 115         }
; 116     }
; 117 }
; 118 
; 119 void printMyChatA() {
printmychata:
; 120     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 121         // Char POS
; 122         hl = FONT_8_8_RUS;
	ld hl, font_8_8_rus
; 123         cyclic_rotate_left(a, 3);
	rlca
	rlca
	rlca
; 124         b = a;
	ld b, a
; 125         a &= 0x07;
	and 7
; 126         a += h;
	add h
; 127         h = a;
	ld h, a
; 128         a = b;
	ld a, b
; 129         a &= 0xF8;
	and 248
; 130         a += l;
	add l
; 131         if (flag_c) {
	jp nc, l_65
; 132             h++;
	inc h
l_65:
; 133         }
; 134         l = a;
	ld l, a
; 135         // Video POS
; 136         //de = 0xC000;
; 137         a = myCharPosY;
	ld a, (mycharposy)
; 138         a &= 0x1F;
	and 31
; 139         cyclic_rotate_left(a, 3);
	rlca
	rlca
	rlca
; 140         e = a;
	ld e, a
; 141         a = myCharPosX;
	ld a, (mycharposx)
; 142         a += 0xC0;
	add 192
; 143         d = a;
	ld d, a
; 144         //
; 145         b = 8;
	ld b, 8
; 146         do {
l_67:
; 147             a = *hl;
	ld a, (hl)
; 148             *de = a;
	ld (de), a
; 149             hl++;
	inc hl
; 150             de++;
	inc de
; 151             b--;
	dec b
l_68:
; 152         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_67
; 153         // Inc POS
; 154         a = myCharPosX;
	ld a, (mycharposx)
; 155         a++;
	inc a
; 156         if (a >= 0x30) { //0x2F
	cp 48
	jp c, l_70
; 157             a = 0;
	ld a, 0
; 158             b = a;
	ld b, a
; 159             // Inc Y
; 160             a = myCharPosY;
	ld a, (mycharposy)
; 161             a++;
	inc a
; 162             if (a >= 0x20) { //0x1F
	cp 32
	jp c, l_72
; 163                 a = 0;
	ld a, 0
l_72:
; 164             }
; 165             myCharPosY = a;
	ld (mycharposy), a
; 166             //
; 167             a = b;
	ld a, b
l_70:
; 168         }
; 169         myCharPosX = a;
	ld (mycharposx), a
	pop de
	pop bc
	pop hl
	ret
; 170     }
; 171 }
; 172 
; 173 void myCharPosXSpaceA(){
mycharposxspacea:
; 174     push_pop(bc) {
	push bc
; 175         b = a;
	ld b, a
; 176         a = myCharPosX;
	ld a, (mycharposx)
; 177         a += b;
	add b
; 178         myCharPosX = a;
	ld (mycharposx), a
	pop bc
	ret
; 179     }
; 180 }
; 181 
; 182 void myCharPosYSpaceA(){
mycharposyspacea:
; 183     push_pop(bc) {
	push bc
; 184         b = a;
	ld b, a
; 185         a = myCharPosY;
	ld a, (mycharposy)
; 186         a += b;
	add b
; 187         myCharPosY = a;
	ld (mycharposy), a
	pop bc
	ret
; 188     }
; 189 }
; 190 
; 191 /// Вывести на экран значение A как десятичное число
; 192 /// A не больше 99 или 0x63
; 193 /// Если больше - ничего не выводит
; 194 void printMyAsDec99A() {
printmyasdec99a:
; 195     if (a < 0x64) {
	cp 100
	jp nc, l_74
; 196         push_pop(bc, de) {
	push bc
	push de
; 197             b = a;
	ld b, a
; 198             c = a;
	ld c, a
; 199             d = 0;
	ld d, 0
; 200             e = 10;
	ld e, 10
; 201             if ((a = b) < e) {
	ld a, b
	cp e
	jp nc, l_76
; 202                 printMyChatA(a = ' ');
	ld a, 32
	call printmychata
; 203                 a = b;
	ld a, b
; 204                 a += '0';
	add 48
; 205                 printMyChatA();
	call printmychata
	jp l_77
l_76:
; 206             } else {
; 207                 do {
l_78:
; 208                     a = b;
	ld a, b
; 209                     a -= e;
	sub e
; 210                     b = a;
	ld b, a
; 211                     d++;
	inc d
l_79:
; 212                 } while ((a = b) >= e);
	ld a, b
	cp e
	jp nc, l_78
; 213                 a = d;
	ld a, d
; 214                 a += '0';
	add 48
; 215                 printMyChatA();
	call printmychata
; 216                 a = b;
	ld a, b
; 217                 a += '0';
	add 48
; 218                 printMyChatA();
	call printmychata
l_77:
	pop de
	pop bc
l_74:
	ret
; 219             }
; 220         }
; 221     }
; 222 }
; 223 
; 224 /// Вывести на экран значение A как десятичное число с ведущими нулями
; 225 /// A не больше 99 или 0x63
; 226 /// Если больше - ничего не выводит
; 227 void printMyAs00Dec99A() {
printmyas00dec99a:
; 228     if (a < 0x64) {
	cp 100
	jp nc, l_81
; 229         push_pop(bc, de) {
	push bc
	push de
; 230             b = a;
	ld b, a
; 231             c = a;
	ld c, a
; 232             d = 0;
	ld d, 0
; 233             e = 10;
	ld e, 10
; 234             if ((a = b) < e) {
	ld a, b
	cp e
	jp nc, l_83
; 235                 printMyChatA(a = '0');
	ld a, 48
	call printmychata
; 236                 a = b;
	ld a, b
; 237                 a += '0';
	add 48
; 238                 printMyChatA();
	call printmychata
	jp l_84
l_83:
; 239             } else {
; 240                 do {
l_85:
; 241                     a = b;
	ld a, b
; 242                     a -= e;
	sub e
; 243                     b = a;
	ld b, a
; 244                     d++;
	inc d
l_86:
; 245                 } while ((a = b) >= e);
	ld a, b
	cp e
	jp nc, l_85
; 246                 a = d;
	ld a, d
; 247                 a += '0';
	add 48
; 248                 printMyChatA();
	call printmychata
; 249                 a = b;
	ld a, b
; 250                 a += '0';
	add 48
; 251                 printMyChatA();
	call printmychata
l_84:
	pop de
	pop bc
l_81:
	ret
; 252             }
; 253         }
; 254     }
; 255 }
; 256 
; 257 /// Вывести на экран значение HL как десятичное число
; 258 /// A не больше 4095 или 0x0FFF
; 259 /// Если больше - ничего не выводит
; 260 void printMyAsDec4095HL() {
printmyasdec4095hl:
; 261     push_pop(bc, de) {
	push bc
	push de
; 262         de = 0x0FFF;
	ld de, 4095
; 263         compareHlDe();
	call comparehlde
; 264         if (flag_nc) {
	jp c, l_88
; 265             c = 0; // Признак ведущего нуля (0 - ставить " ", а не 0)
	ld c, 0
; 266             //1000
; 267             de = 0x03E8;
	ld de, 1000
; 268             compareHlDe();
	call comparehlde
; 269             if (flag_c) {
	jp nc, l_90
; 270                 b = 0;
	ld b, 0
; 271                 do {
l_92:
; 272                     de = 0xFC18;
	ld de, 64536
; 273                     hl += de;
	add hl, de
; 274                     b++;
	inc b
; 275                     de = 0x03E8;
	ld de, 1000
; 276                     compareHlDe();
	call comparehlde
l_93:
	jp c, l_92
; 277                 } while (flag_c);
; 278                 a = b;
	ld a, b
; 279                 a += '0';
	add 48
; 280                 printMyChatA();
	call printmychata
; 281                 c = 1;
	ld c, 1
	jp l_91
l_90:
; 282             } else {
; 283                 printMyChatA(a = ' ');
	ld a, 32
	call printmychata
l_91:
; 284             }
; 285             //0100
; 286             de = 0x0064;
	ld de, 100
; 287             compareHlDe();
	call comparehlde
; 288             if (flag_c) {
	jp nc, l_95
; 289                 b = 0;
	ld b, 0
; 290                 do {
l_97:
; 291                     de = 0xFF9C;
	ld de, 65436
; 292                     hl += de;
	add hl, de
; 293                     b++;
	inc b
; 294                     de = 0x0064;
	ld de, 100
; 295                     compareHlDe();
	call comparehlde
l_98:
	jp c, l_97
; 296                 } while (flag_c);
; 297                 a = b;
	ld a, b
; 298                 a += '0';
	add 48
; 299                 printMyChatA();
	call printmychata
; 300                 c = 1;
	ld c, 1
	jp l_96
l_95:
; 301             } else {
; 302                 if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_100
; 303                     printMyChatA(a = ' ');
	ld a, 32
	call printmychata
	jp l_101
l_100:
; 304                 } else {
; 305                     printMyChatA(a = '0');
	ld a, 48
	call printmychata
l_101:
l_96:
; 306                 }
; 307             }
; 308             //0010
; 309 //            de = 0x000A;
; 310 //            compareHlDe();
; 311 //            if (flag_c) {
; 312 //                b = 0;
; 313 //                do {
; 314 //                    de = 0xFFF6;
; 315 //                    hl += de;
; 316 //                    b++;
; 317 //                    de = 0x000A;
; 318 //                    compareHlDe();
; 319 //                } while (flag_c);
; 320 //                a = b;
; 321 //                a += '0';
; 322 //                printMyChatA();
; 323 //            } else {
; 324 //                printMyChatA(a = '0');
; 325 //            }
; 326             a = l;
	ld a, l
; 327             if ((a = l) >= 10) {
	ld a, l
	cp 10
	jp c, l_102
; 328                 b = 0;
	ld b, 0
; 329                 do {
l_104:
; 330                     a = l;
	ld a, l
; 331                     a -= 10;
	sub 10
; 332                     l = a;
	ld l, a
; 333                     b++;
	inc b
l_105:
; 334                 } while ((a = l) >= 10);
	ld a, l
	cp 10
	jp nc, l_104
; 335                 a = b;
	ld a, b
; 336                 a += '0';
	add 48
; 337                 printMyChatA();
	call printmychata
; 338                 c = 1;
	ld c, 1
	jp l_103
l_102:
; 339             } else {
; 340                 if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_107
; 341                     printMyChatA(a = ' ');
	ld a, 32
	call printmychata
	jp l_108
l_107:
; 342                 } else {
; 343                     printMyChatA(a = '0');
	ld a, 48
	call printmychata
l_108:
l_103:
; 344                 }
; 345             }
; 346             //0001
; 347             a = l;
	ld a, l
; 348             a += '0';
	add 48
; 349             printMyChatA();
	call printmychata
l_88:
	pop de
	pop bc
	ret
; 350         }
; 351     }
; 352 }
; 353 
; 354 /// Спавнение HL и DE
; 355 /// CF=1 when DE < HL
; 356 /// CF=0 DE >= HL
; 357 void compareHlDe() {
comparehlde:
; 358     a = d;
	ld a, d
; 359     a ^= h;
	xor h
; 360     if (flag_p) {
	jp m, l_109
	jp l_110
l_109:
; 361     } else {
; 362         a ^= d;
	xor d
; 363         if (flag_m) {
	jp p, l_111
; 364             return;
	ret
l_111:
; 365         }
; 366         set_flag_c();
	scf
; 367         return;
	ret
l_110:
; 368     }
; 369     a = e;
	ld a, e
; 370     a -= l; //0x95
	sub l
; 371     a = d;
	ld a, d
; 372     //a -= h; //0x9C
; 373     //asm{ SBB h };
; 374     carry_sub(a, h);
	sbc h
; 375     return;
	ret
; 376 }
; 377 
; 378 uint8_t myCharPosX = 0;
mycharposx:
	db 0
; 379 uint8_t myCharPosY = 0;
mycharposy:
	db 0
; 11 void debug() {
debug:
; 12     push_pop(hl, bc) {
	push hl
	push bc
; 13         b = a;
	ld b, a
; 14         h = 1;
	ld h, 1
; 15         l = 1;
	ld l, 1
; 16         setPosCursor();
	call setposcursor
; 17         printHexA(a = b);
	ld a, b
	call printhexa
	pop bc
	pop hl
	ret
; 18     }
; 19 }
; 20 
; 21 void debugStartVboxAddr() {
debugstartvboxaddr:
; 22     push_pop(hl, bc) {
	push hl
	push bc
; 23         b = a;
	ld b, a
; 24         h = 1;
	ld h, 1
; 25         l = 1;
	ld l, 1
; 26         setPosCursor();
	call setposcursor
; 27         hl = startVboxAddr;
	ld hl, (startvboxaddr)
; 28         printHexA(a = h);
	ld a, h
	call printhexa
; 29         printHexA(a = l);
	ld a, l
	call printhexa
	pop bc
	pop hl
	ret
; 11 void HelpViewShow() {
helpviewshow:
; 12     a = HelpViewX;
	ld a, (helpviewx)
; 13     h = a;
	ld h, a
; 14     a = HelpViewY;
	ld a, (helpviewy)
; 15     l = a;
	ld l, a
; 16     a = HelpViewDX;
	ld a, (helpviewdx)
; 17     d = a;
	ld d, a
; 18     a = HelpViewDY;
	ld a, (helpviewdy)
; 19     e = a;
	ld e, a
; 20     a = HelpViewColor;
	ld a, (helpviewcolor)
; 21     vboxOpenHLDE();
	call vboxopenhlde
; 22     HelpViewShowStr();
; 23 }
; 24 
; 25 void HelpViewShowStr() {
helpviewshowstr:
; 26     a = HelpViewX;
	ld a, (helpviewx)
; 27     a++;
	inc a
; 28     myCharPosX = a;
	ld (mycharposx), a
; 29     a = HelpViewY;
	ld a, (helpviewy)
; 30     a++;
	inc a
; 31     myCharPosY = a;
	ld (mycharposy), a
; 32     printMyHLStr(hl = HelpViewTitleF1);
	ld hl, helpviewtitlef1
	call printmyhlstr
; 33     
; 34     myCharPosXSpaceA(a = 5);
	ld a, 5
	call mycharposxspacea
; 35     printMyHLStr(hl = HelpViewTitleF2);
	ld hl, helpviewtitlef2
	call printmyhlstr
; 36     
; 37     myCharPosXSpaceA(a = 5);
	ld a, 5
	call mycharposxspacea
; 38     printMyHLStr(hl = HelpViewTitleF3);
	ld hl, helpviewtitlef3
	call printmyhlstr
; 39     
; 40     myCharPosXSpaceA(a = 5);
	ld a, 5
	call mycharposxspacea
; 41     printMyHLStr(hl = HelpViewTitleF4);
	ld hl, helpviewtitlef4
	jp printmyhlstr
; 42 }
; 43 
; 44 uint8_t HelpViewX = 0;
helpviewx:
	db 0
; 45 uint8_t HelpViewY = 29;
helpviewy:
	db 29
; 46 uint8_t HelpViewDX = 48;
helpviewdx:
	db 48
; 47 uint8_t HelpViewDY = 3;
helpviewdy:
	db 3
; 51 uint8_t HelpViewColor = 0x5f; //0x67;
helpviewcolor:
	db 95
; 54 uint8_t HelpViewTitleF1[] = "F1: ..";
helpviewtitlef1:
	db 70
	db 49
	db 58
	db 32
	db 46
	db 46
	ds 1
; 55 uint8_t HelpViewTitleF2[] = "F2: Wi-Fi";
helpviewtitlef2:
	db 70
	db 50
	db 58
	db 32
	db 87
	db 105
	db 45
	db 70
	db 105
	ds 1
; 56 uint8_t HelpViewTitleF3[] = "F3: FTP ";
helpviewtitlef3:
	db 70
	db 51
	db 58
	db 32
	db 70
	db 84
	db 80
	db 32
	ds 1
; 57 uint8_t HelpViewTitleF4[] = "F4: Quit";
helpviewtitlef4:
	db 70
	db 52
	db 58
	db 32
	db 81
	db 117
	db 105
	db 116
	ds 1
; 11 void FtpStateViewShow() {
ftpstateviewshow:
; 12     push_pop(hl, de) {
	push hl
	push de
; 13         a = FtpStateViewX;
	ld a, (ftpstateviewx)
; 14         h = a;
	ld h, a
; 15         a = FtpStateViewY;
	ld a, (ftpstateviewy)
; 16         l = a;
	ld l, a
; 17         a = FtpStateViewDX;
	ld a, (ftpstateviewdx)
; 18         d = a;
	ld d, a
; 19         a = FtpStateViewDY;
	ld a, (ftpstateviewdy)
; 20         e = a;
	ld e, a
; 21         a = FtpStateViewColor;
	ld a, (ftpstateviewcolor)
; 22         vboxOpenHLDE();
	call vboxopenhlde
; 23         vboxBorderHLDE();
	call vboxborderhlde
; 24         FtpStateViewShowTitle();
	call ftpstateviewshowtitle
; 25         FtpStateViewShowValue();
	call ftpstateviewshowvalue
	pop de
	pop hl
	ret
; 26     }
; 27 }
; 28 
; 29 void FtpStateViewShowTitle() {
ftpstateviewshowtitle:
; 30     push_pop(hl, bc) {
	push hl
	push bc
; 31         // TITLE
; 32         a = FtpStateViewX;
	ld a, (ftpstateviewx)
; 33         b = a;
	ld b, a
; 34         a = FtpStateViewDX;
	ld a, (ftpstateviewdx)
; 35         a += b;
	add b
; 36         a -= 6; //len Title
	sub 6
; 37         myCharPosX = a;
	ld (mycharposx), a
; 38         a = FtpStateViewY;
	ld a, (ftpstateviewy)
; 39         myCharPosY = a;
	ld (mycharposy), a
; 40         printMyHLStr(hl = FtpViewTitle);
	ld hl, ftpviewtitle
	call printmyhlstr
; 41         // IP
; 42         a = FtpStateViewX;
	ld a, (ftpstateviewx)
; 43         a += 1;
	add 1
; 44         myCharPosX = a;
	ld (mycharposx), a
; 45         a = FtpStateViewY;
	ld a, (ftpstateviewy)
; 46         a += 1;
	add 1
; 47         myCharPosY = a;
	ld (mycharposy), a
; 48         printMyHLStr(hl = FtpStateViewIpTitle);
	ld hl, ftpstateviewiptitle
	call printmyhlstr
; 49         // STATUS
; 50         a = FtpStateViewX;
	ld a, (ftpstateviewx)
; 51         a += 1;
	add 1
; 52         myCharPosX = a;
	ld (mycharposx), a
; 53         a = FtpStateViewY;
	ld a, (ftpstateviewy)
; 54         a += 2;
	add 2
; 55         myCharPosY = a;
	ld (mycharposy), a
; 56         printMyHLStr(hl = FtpStateViewStateTitle);
	ld hl, ftpstateviewstatetitle
	call printmyhlstr
	pop bc
	pop hl
	ret
; 57     }
; 58 }
; 59 
; 60 void FtpStateViewShowValue() {
ftpstateviewshowvalue:
; 61     push_pop(hl) {
	push hl
; 62         //IP
; 63         a = FtpStateViewX;
	ld a, (ftpstateviewx)
; 64         a += 5;
	add 5
; 65         myCharPosX = a;
	ld (mycharposx), a
; 66         a = FtpStateViewY;
	ld a, (ftpstateviewy)
; 67         a += 1;
	add 1
; 68         myCharPosY = a;
	ld (mycharposy), a
; 69         a = 16;
	ld a, 16
; 70         printMyHLStrLenA(hl = FtpStateViewIpValue);
	ld hl, ftpstateviewipvalue
	call printmyhlstrlena
; 71         // STATUS
; 72         FtpStateViewShowStatus();
	call ftpstateviewshowstatus
	pop hl
	ret
; 73     }
; 74 }
; 75 
; 76 void FtpStateViewShowStatus() {
ftpstateviewshowstatus:
; 77     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 78         if ((a = FtpStateViewStatus) == 0) {
	ld a, (ftpstateviewstatus)
	or a
	jp nz, l_113
; 79             hl = FtpStateViewStatus0;
	ld hl, ftpstateviewstatus0
; 80             a = FtpStateViewColor;
	ld a, (ftpstateviewcolor)
; 81             c = a;
	ld c, a
	jp l_114
l_113:
; 82         } else {
; 83             hl = FtpStateViewStatus1;
	ld hl, ftpstateviewstatus1
; 84             a = FtpStateViewConnectColor;
	ld a, (ftpstateviewconnectcolor)
; 85             c = a;
	ld c, a
l_114:
; 86         }
; 87         a = FtpStateViewX;
	ld a, (ftpstateviewx)
; 88         a += 9;
	add 9
; 89         d = a; // X
	ld d, a
; 90         myCharPosX = a;
	ld (mycharposx), a
; 91         a = FtpStateViewY;
	ld a, (ftpstateviewy)
; 92         a += 2;
	add 2
; 93         e = a; // Y
	ld e, a
; 94         myCharPosY = a;
	ld (mycharposy), a
; 95         printMyHLStrLenA(a = 14);
	ld a, 14
	call printmyhlstrlena
; 96         //COLOR BOX
; 97         h = d;
	ld h, d
; 98         l = e;
	ld l, e
; 99         d = 14;
	ld d, 14
; 100         e = 1;        
	ld e, 1
; 101         a = 0;
	ld a, 0
; 102         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop bc
	pop hl
	ret
; 103     }
; 104 }
; 105 
; 106 uint8_t FtpStateViewX = 0;
ftpstateviewx:
	db 0
; 107 uint8_t FtpStateViewY = 0;
ftpstateviewy:
	db 0
; 108 uint8_t FtpStateViewDX = 24;
ftpstateviewdx:
	db 24
; 109 uint8_t FtpStateViewDY = 4;
ftpstateviewdy:
	db 4
; 114 uint8_t FtpStateViewColor = 0x5f; //0x67; 07
ftpstateviewcolor:
	db 95
; 115 uint8_t FtpStateViewConnectColor = 0x52;
ftpstateviewconnectcolor:
	db 82
; 118 uint8_t FtpStateViewIpTitle[] =    "IP:";
ftpstateviewiptitle:
	db 73
	db 80
	db 58
	ds 1
; 119 uint8_t FtpStateViewStateTitle[] = "Status:";
ftpstateviewstatetitle:
	db 83
	db 116
	db 97
	db 116
	db 117
	db 115
	db 58
	ds 1
; 120 uint8_t FtpStateViewIpValue[16] = "0.0.0.0";
ftpstateviewipvalue:
	db 48
	db 46
	db 48
	db 46
	db 48
	db 46
	db 48
	ds 9
; 122 uint8_t FtpStateViewStatus = 0;
ftpstateviewstatus:
	db 0
; 123 uint8_t FtpStateViewStatus0[] = "DISCONNECT"; //a = 14
ftpstateviewstatus0:
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
	ds 1
; 124 uint8_t FtpStateViewStatus1[] = "CONNECT"; //a = 14
ftpstateviewstatus1:
	db 67
	db 79
	db 78
	db 78
	db 69
	db 67
	db 84
	ds 1
; 11 void WifiStateViewShow() {
wifistateviewshow:
; 12     push_pop(hl, de, bc) {
	push hl
	push de
	push bc
; 13         a = WifiStateViewX;
	ld a, (wifistateviewx)
; 14         h = a;
	ld h, a
; 15         a = WifiStateViewY;
	ld a, (wifistateviewy)
; 16         l = a;
	ld l, a
; 17         a = WifiStateViewDX;
	ld a, (wifistateviewdx)
; 18         d = a;
	ld d, a
; 19         a = WifiStateViewDY;
	ld a, (wifistateviewdy)
; 20         e = a;
	ld e, a
; 21         a = WifiStateViewColor;
	ld a, (wifistateviewcolor)
; 22         vboxOpenHLDE();
	call vboxopenhlde
; 23         vboxBorderHLDE();
	call vboxborderhlde
; 24         WifiStateViewShowTitle();
	call wifistateviewshowtitle
; 25         WifiStateViewShowValue();
	call wifistateviewshowvalue
	pop bc
	pop de
	pop hl
	ret
; 26     }
; 27 }
; 28 
; 29 void WifiStateViewNetAndUIUpdate() {
wifistateviewnetanduiupdate:
; 30     getSSIDValue();
	call getssidvalue
; 31     getSSIDIPAddress();
	call getssidipaddress
; 32     getSSIDMacAddress();
	call getssidmacaddress
; 33     getSSIDPassword();
	call getssidpassword
; 34     getWifiState();
	call getwifistate
; 35     WifiStateViewShowValue();
	jp wifistateviewshowvalue
; 36 }
; 37 
; 38 void WifiStateViewShowTitle() {
wifistateviewshowtitle:
; 39     push_pop(hl, bc) {
	push hl
	push bc
; 40         //Title
; 41         a = WifiStateViewX;
	ld a, (wifistateviewx)
; 42         b = a;
	ld b, a
; 43         a = WifiStateViewDX;
	ld a, (wifistateviewdx)
; 44         a += b;
	add b
; 45         a -= 8; //len Title
	sub 8
; 46         myCharPosX = a;
	ld (mycharposx), a
; 47         a = WifiStateViewY;
	ld a, (wifistateviewy)
; 48         myCharPosY = a;
	ld (mycharposy), a
; 49         printMyHLStr(hl = WifiStateViewTitle);
	ld hl, wifistateviewtitle
	call printmyhlstr
; 50         //SSID
; 51         a = WifiStateViewX;
	ld a, (wifistateviewx)
; 52         a++;
	inc a
; 53         myCharPosX = a;
	ld (mycharposx), a
; 54         a = WifiStateViewY;
	ld a, (wifistateviewy)
; 55         a++;
	inc a
; 56         myCharPosY = a;
	ld (mycharposy), a
; 57         printMyHLStr(hl = WifiStateViewTitleSSID);
	ld hl, wifistateviewtitlessid
	call printmyhlstr
; 58         //IP
; 59         a = WifiStateViewX;
	ld a, (wifistateviewx)
; 60         a++;
	inc a
; 61         myCharPosX = a;
	ld (mycharposx), a
; 62         a = WifiStateViewY;
	ld a, (wifistateviewy)
; 63         a++;
	inc a
; 64         a++;
	inc a
; 65         myCharPosY = a;
	ld (mycharposy), a
; 66         printMyHLStr(hl = WifiStateViewTitleIP);
	ld hl, wifistateviewtitleip
	call printmyhlstr
	pop bc
	pop hl
	ret
; 67     }
; 68 }
; 69 
; 70 
; 71 
; 72 void WifiStateViewShowValue() {
wifistateviewshowvalue:
; 73     // SSID
; 74     a = WifiStateViewX;
	ld a, (wifistateviewx)
; 75     a += 7;
	add 7
; 76     myCharPosX = a;
	ld (mycharposx), a
; 77     a = WifiStateViewY;
	ld a, (wifistateviewy)
; 78     a += 1;
	add 1
; 79     myCharPosY = a;
	ld (mycharposy), a
; 80     a = 16;
	ld a, 16
; 81     printMyHLStrLenA(hl = WifiStateViewSsidVal);
	ld hl, wifistateviewssidval
	call printmyhlstrlena
; 82     // IP
; 83     a = WifiStateViewX;
	ld a, (wifistateviewx)
; 84     a += 7;
	add 7
; 85     myCharPosX = a;
	ld (mycharposx), a
; 86     a = WifiStateViewY;
	ld a, (wifistateviewy)
; 87     a += 2;
	add 2
; 88     myCharPosY = a;
	ld (mycharposy), a
; 89     a = 16;
	ld a, 16
; 90     printMyHLStrLenA(hl = WifiStateViewIpVal);
	ld hl, wifistateviewipval
	jp printmyhlstrlena
; 91 }
; 92 
; 93 uint8_t WifiStateViewX = 24;
wifistateviewx:
	db 24
; 94 uint8_t WifiStateViewY = 0;
wifistateviewy:
	db 0
; 95 uint8_t WifiStateViewDX = 24;
wifistateviewdx:
	db 24
; 96 uint8_t WifiStateViewDY = 4;
wifistateviewdy:
	db 4
; 100 uint8_t WifiStateViewColor = 0x5f; //0x67;
wifistateviewcolor:
	db 95
; 103 uint8_t WifiStateViewTitleSSID[] = "SSID: ";
wifistateviewtitlessid:
	db 83
	db 83
	db 73
	db 68
	db 58
	db 32
	ds 1
; 104 uint8_t WifiStateViewTitleIP[] =   "IP  : ";
wifistateviewtitleip:
	db 73
	db 80
	db 32
	db 32
	db 58
	db 32
	ds 1
; 105 uint8_t WifiStateViewTitle[] = {0xB5, 'W', 'i', '-', 'F', 'i', 0xC6, '\0'};
wifistateviewtitle:
	db 181
	db 87
	db 105
	db 45
	db 70
	db 105
	db 198
	db 0
; 107 uint8_t WifiStateViewSsidVal[16] = "Ssid";
wifistateviewssidval:
	db 83
	db 115
	db 105
	db 100
	ds 12
; 108 uint8_t WifiStateViewIpVal[16] = "0.0.0.0";
wifistateviewipval:
	db 48
	db 46
	db 48
	db 46
	db 48
	db 46
	db 48
	ds 9
; 109 uint8_t WifiStateViewPassVal[16] = "-";
wifistateviewpassval:
	db 45
	ds 15
; 110 uint8_t WifiStateViewMacVal[18] = "00:00:00:00:00:00";
wifistateviewmacval:
	db 48
	db 48
	db 58
	db 48
	db 48
	db 58
	db 48
	db 48
	db 58
	db 48
	db 48
	db 58
	db 48
	db 48
	db 58
	db 48
	db 48
	ds 1
; 112 uint8_t WifiStateViewSSIDIsConnected = 0;
wifistateviewssidisconnected:
	db 0
; 11 void FtpViewShow() {
ftpviewshow:
; 12     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 13         a = FtpViewX;
	ld a, (ftpviewx)
; 14         h = a;
	ld h, a
; 15         a = FtpViewY;
	ld a, (ftpviewy)
; 16         l = a;
	ld l, a
; 17         a = FtpViewDX;
	ld a, (ftpviewdx)
; 18         d = a;
	ld d, a
; 19         a = FtpViewDY;
	ld a, (ftpviewdy)
; 20         e = a;
	ld e, a
; 21         a = FtpViewColor;
	ld a, (ftpviewcolor)
; 22         vboxOpenHLDE();
	call vboxopenhlde
; 23         vboxBorderHLDE();
	call vboxborderhlde
; 24         FtpViewShowTitle();
	call ftpviewshowtitle
; 25         
; 26         #ifdef _IS_SIMULATOR
; 27             FtpViewShowFileList();
; 28             FtpViewShowPath();
; 29             a = 0;
; 30             FtpViewFileCurrentPos = a;
; 31             FtpViewShowSelectLineA(a = 1);
; 32         #else
; 33             FtpViewNetLoadAndUpdate();
	call ftpviewnetloadandupdate
	pop de
	pop hl
	pop bc
	ret
; 34         #endif
; 35     }
; 36 }
; 37 
; 38 void FtpViewShowTitle() {
ftpviewshowtitle:
; 39     a = FtpViewX;
	ld a, (ftpviewx)
; 40     a++;
	inc a
; 41     myCharPosX = a;
	ld (mycharposx), a
; 42     a = FtpViewY;
	ld a, (ftpviewy)
; 43     myCharPosY = a;
	ld (mycharposy), a
; 44     printMyHLStr(hl = FtpViewTitle);
	ld hl, ftpviewtitle
	jp printmyhlstr
; 45 }
; 46 
; 47 void FtpViewShowFileList() {
ftpviewshowfilelist:
; 48     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 49         b = 0;
	ld b, 0
; 50         a = FtpViewFilesListCount;
	ld a, (ftpviewfileslistcount)
; 51         hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 52         c = a;
	ld c, a
; 53         do {
l_115:
; 54             a = FtpViewY;
	ld a, (ftpviewy)
; 55             a += 2;
	add 2
; 56             a += b;
	add b
; 57             myCharPosY = a;
	ld (mycharposy), a
; 58             FtpViewShowFileHL();
	call ftpviewshowfilehl
; 59             // HL + 16 next file
; 60             a = 16;
	ld a, 16
; 61             a += l;
	add l
; 62             l = a;
	ld l, a
; 63             if (flag_c) {
	jp nc, l_118
; 64                 h++;
	inc h
l_118:
; 65             }
; 66             b++;
	inc b
l_116:
; 67         } while ((a = b) < c);
	ld a, b
	cp c
	jp c, l_115
; 68         // Заполнить пустыми строками
; 69         a = FtpViewX;
	ld a, (ftpviewx)
; 70         a += 1;
	add 1
; 71         d = a; // X
	ld d, a
; 72         a = FtpViewY;
	ld a, (ftpviewy)
; 73         a += 2;
	add 2
; 74         e = a; // Y
	ld e, a
; 75         //--
; 76         a = FtpViewFilesListCount;
	ld a, (ftpviewfileslistcount)
; 77         b = a;
	ld b, a
; 78         // PosY
; 79         a = e;
	ld a, e
; 80         a += b;
	add b
; 81         e = a;
	ld e, a
; 82         //
; 83         a = FtpViewDY;
	ld a, (ftpviewdy)
; 84         a -= 4;
	sub 4
; 85         a -= b;
	sub b
; 86         b = a;
	ld b, a
; 87         c = 0;
	ld c, 0
; 88         do {
l_120:
; 89             a = d;
	ld a, d
; 90             myCharPosX = a;
	ld (mycharposx), a
; 91             a = e;
	ld a, e
; 92             a += c;
	add c
; 93             myCharPosY = a;
	ld (mycharposy), a
; 94             //
; 95             a = FtpViewDX;
	ld a, (ftpviewdx)
; 96             a -= 3;
	sub 3
; 97             h = a;
	ld h, a
; 98             do {
l_123:
; 99                 printMyChatA(a = ' ');
	ld a, 32
	call printmychata
; 100                 h--;
	dec h
l_124:
; 101             } while ((a = h) > 0);
	ld a, h
	or a
	jp nz, l_123
; 102             b--;
	dec b
; 103             c++;
	inc c
l_121:
; 104         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_120
	pop hl
	pop de
	pop bc
	ret
; 105     }
; 106 }
; 107 
; 108 void FtpViewShowFileHL() {
ftpviewshowfilehl:
; 109     push_pop(bc, hl) {
	push bc
	push hl
; 110         if ((a = b) == 0) {
	ld a, b
	or a
	jp nz, l_126
; 111             FtpViewShowFileName();
	call ftpviewshowfilename
	jp l_127
l_126:
; 112         } else {
; 113             FtpViewShowFileName();
	call ftpviewshowfilename
; 114             FtpViewShowFileSize();
	call ftpviewshowfilesize
; 115             FtpViewShowFileDate();
	call ftpviewshowfiledate
l_127:
	pop hl
	pop bc
	ret
; 116         }
; 117     }
; 118 }
; 119 
; 120 // A = 1 - Dir
; 121 void FtpViewShowIsDirA() {
ftpviewshowisdira:
; 122     push_pop(bc) {
	push bc
; 123         b = a;
	ld b, a
; 124         a = FtpViewX;
	ld a, (ftpviewx)
; 125         a += 1;
	add 1
; 126         myCharPosX = a;
	ld (mycharposx), a
; 127         if ((a = b) == 1) {
	ld a, b
	cp 1
	jp nz, l_128
; 128             printMyChatA(a = 0x1F); //0x10
	ld a, 31
	call printmychata
	jp l_129
l_128:
; 129         } else {
; 130             printMyChatA(a = ' ');
	ld a, 32
	call printmychata
l_129:
	pop bc
	ret
; 131         }
; 132     }
; 133 }
; 134 
; 135 void FtpViewShowFileName() {
ftpviewshowfilename:
; 136     // X pos
; 137     a = FtpViewX;
	ld a, (ftpviewx)
; 138     a += 2;
	add 2
; 139     myCharPosX = a;
	ld (mycharposx), a
; 140     //
; 141     b = 8;
	ld b, 8
; 142     do {
l_130:
; 143         printMyChatA(a = *hl);
	ld a, (hl)
	call printmychata
; 144         hl++;
	inc hl
; 145         b--;
	dec b
l_131:
; 146     } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_130
	ret
; 147 }
; 148 
; 149 void FtpViewShowFileSize() {
ftpviewshowfilesize:
; 150     push_pop(bc, de) {
	push bc
	push de
; 151         // X pos
; 152         a = FtpViewX;
	ld a, (ftpviewx)
; 153         a += 11;
	add 11
; 154         myCharPosX = a;
	ld (mycharposx), a
; 155         //
; 156         a = *hl;
	ld a, (hl)
; 157         d = a;
	ld d, a
; 158         hl++;
	inc hl
; 159         a = *hl;
	ld a, (hl)
; 160         e = a;
	ld e, a
; 161         hl++;
	inc hl
; 162         a = *hl;
	ld a, (hl)
; 163         hl++;
	inc hl
; 164         if (a == 0x00) {
	or a
	jp nz, l_133
; 165             push_pop(hl) {
	push hl
; 166                 h = 0; // файл для Орион
	ld h, 0
; 167                 if ((a = d) == 0xFF) {
	ld a, d
	cp 255
	jp nz, l_135
; 168                     if ((a = e) == 0xFF) {
	ld a, e
	cp 255
	jp nz, l_137
; 169                         h = 1; // Файл слишком большой для Орион
	ld h, 1
l_137:
l_135:
; 170                     }
; 171                 }
; 172                 if ((a = h) == 0) { // Показываем размер
	ld a, h
	or a
	jp nz, l_139
; 173                     //hl = 0x0400;
; 174                     //compareHlDe();
; 175                     if ((a = d) < 4) { // < 1024 в байтах //flag_c
	ld a, d
	cp 4
	jp nc, l_141
; 176                         push_pop(hl) {
	push hl
; 177                             h = d;
	ld h, d
; 178                             l = e;
	ld l, e
; 179                             printMyAsDec4095HL();
	call printmyasdec4095hl
	pop hl
	jp l_142
l_141:
; 180                         }
; 181                     } else { // В Кб
; 182                         a = d;
	ld a, d
; 183                         a &= 0xFC;
	and 252
; 184                         cyclic_rotate_right(a, 2);
	rrca
	rrca
; 185                         printMyAsDec99A();
	call printmyasdec99a
; 186                         printMyChatA(a = 'K');
	ld a, 75
	call printmychata
; 187                         printMyChatA(a = 'b');
	ld a, 98
	call printmychata
l_142:
	jp l_140
l_139:
; 188                     }
; 189                 } else { // Файл слишком большой
; 190                     printMyChatA(a = ' ');
	ld a, 32
	call printmychata
; 191                     printMyChatA(a = 'B');
	ld a, 66
	call printmychata
; 192                     printMyChatA(a = 'I');
	ld a, 73
	call printmychata
; 193                     printMyChatA(a = 'G');
	ld a, 71
	call printmychata
l_140:
	pop hl
; 194                 }
; 195             }
; 196             FtpViewShowIsDirA(a = 0);
	ld a, 0
	call ftpviewshowisdira
	jp l_134
l_133:
; 197         } else {
; 198             printMyChatA(a = ' ');
	ld a, 32
	call printmychata
; 199             printMyChatA(a = ' ');
	ld a, 32
	call printmychata
; 200             printMyChatA(a = ' ');
	ld a, 32
	call printmychata
; 201             printMyChatA(a = ' ');
	ld a, 32
	call printmychata
; 202             FtpViewShowIsDirA(a = 1);
	ld a, 1
	call ftpviewshowisdira
l_134:
	pop de
	pop bc
	ret
; 203         }
; 204     }
; 205 }
; 206 
; 207 void FtpViewShowFileDate() {
ftpviewshowfiledate:
; 208     push_pop(bc, de) {
	push bc
	push de
; 209         // X pos
; 210         a = FtpViewX;
	ld a, (ftpviewx)
; 211         a += 16;
	add 16
; 212         myCharPosX = a;
	ld (mycharposx), a
; 213         //
; 214         hl++;
	inc hl
; 215         hl++;
	inc hl
; 216         //--
; 217         //GGGGGGGG GGGGMMMM 000DDDDD
; 218         a = *hl;
	ld a, (hl)
; 219         cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 220         c = a;
	ld c, a
; 221         hl++;
	inc hl
; 222         a = *hl;
	ld a, (hl)
; 223         b = a;
	ld b, a
; 224         //Year
; 225         a = c;
	ld a, c
; 226         a &= 0xF0;
	and 240
; 227         d = a;
	ld d, a
; 228         a = b;
	ld a, b
; 229         a &= 0xF0;
	and 240
; 230         cyclic_rotate_right(a, 4);
	rrca
	rrca
	rrca
	rrca
; 231         a += d;
	add d
; 232         e = a;
	ld e, a
; 233         a = c;
	ld a, c
; 234         a &= 0x0F;
	and 15
; 235         d = a;
	ld d, a
; 236         push_pop(hl) {
	push hl
; 237             h = d;
	ld h, d
; 238             l = e;
	ld l, e
; 239             printMyAsDec4095HL();
	call printmyasdec4095hl
	pop hl
; 240         }
; 241         //Mount
; 242         printMyChatA(a = '-');
	ld a, 45
	call printmychata
; 243         a = b;
	ld a, b
; 244         a &= 0x0F;
	and 15
; 245         printMyAs00Dec99A();
	call printmyas00dec99a
; 246         hl++;
	inc hl
; 247         //Day
; 248         printMyChatA(a = '-');
	ld a, 45
	call printmychata
; 249         a = *hl;
	ld a, (hl)
; 250         a &= 0x1F;
	and 31
; 251         hl++;
	inc hl
; 252         printMyAs00Dec99A();
	call printmyas00dec99a
	pop de
	pop bc
	ret
; 253     }
; 254 }
; 255 
; 256 void FtpViewShowPath() {
ftpviewshowpath:
; 257     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 258         a = FtpViewX;
	ld a, (ftpviewx)
; 259         b = a;
	ld b, a
; 260         a = FtpViewDX;
	ld a, (ftpviewdx)
; 261         a += b;
	add b
; 262         a -= 19;
	sub 19
; 263         myCharPosX = a;
	ld (mycharposx), a
; 264         a = FtpViewY;
	ld a, (ftpviewy)
; 265         myCharPosY = a;
	ld (mycharposy), a
; 266         de = FtpViewPath;
	ld de, ftpviewpath
; 267         printMyChatA(a = 0xB5);
	ld a, 181
	call printmychata
; 268         b = 16;
	ld b, 16
; 269         c = 0;
	ld c, 0
; 270         do {
l_143:
; 271             a = *de;
	ld a, (de)
; 272             de++;
	inc de
; 273             if (a == 0) {
	or a
	jp nz, l_146
; 274                 c = 1;
	ld c, 1
l_146:
; 275             }
; 276             h = a;
	ld h, a
; 277             if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_148
; 278                 printMyChatA(a = h);
	ld a, h
	call printmychata
	jp l_149
l_148:
; 279             } else {
; 280                 printMyChatA(a = ' ');
	ld a, 32
	call printmychata
l_149:
; 281             }
; 282             b--;
	dec b
l_144:
; 283         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_143
; 284         printMyChatA(a = 0xC6);
	ld a, 198
	call printmychata
	pop hl
	pop de
	pop bc
	ret
; 285     }
; 286 }
; 287 
; 288 /// Обновление позиции
; 289 /// вх[A]
; 290 /// 0 - без изменений
; 291 /// 1 - вверх
; 292 /// 0xFF - вниз
; 293 void FtpViewFileCurrentPosUpdateA() {
ftpviewfilecurrentposupdatea:
; 294     push_pop(bc) {
	push bc
; 295         b = a;
	ld b, a
; 296         if (a == 0) {
	or a
	jp nz, l_150
; 297             FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
	jp l_151
l_150:
; 298         } else {
; 299             a = FtpViewFilesListCount;
	ld a, (ftpviewfileslistcount)
; 300             c = a;
	ld c, a
; 301             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 302             a = FtpViewFileCurrentPos;
	ld a, (ftpviewfilecurrentpos)
; 303             a += b;
	add b
; 304             //
; 305             if (a == 0xFF) {
	cp 255
	jp nz, l_152
; 306                 a = c;
	ld a, c
; 307                 a--;
	dec a
	jp l_153
l_152:
; 308             } else if (a == c) {
	cp c
	jp nz, l_154
; 309                 a = 0;
	ld a, 0
l_154:
l_153:
; 310             }
; 311             FtpViewFileCurrentPos = a;
	ld (ftpviewfilecurrentpos), a
; 312             FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
l_151:
	pop bc
	ret
; 313         }
; 314     }
; 315 }
; 316 
; 317 /// Рисование линии прямым или инверсным цветом
; 318 /// 0 - прямой
; 319 /// 1 - инверсный
; 320 void FtpViewShowSelectLineA() {
ftpviewshowselectlinea:
; 321     push_pop(bc) {
	push bc
; 322         c = a;
	ld c, a
; 323         // HL
; 324         a = FtpViewFileCurrentPos;
	ld a, (ftpviewfilecurrentpos)
; 325         b = a;
	ld b, a
; 326         a = FtpViewY;
	ld a, (ftpviewy)
; 327         a += 2;
	add 2
; 328         a += b;
	add b
; 329         l = a;
	ld l, a
; 330         a = FtpViewX;
	ld a, (ftpviewx)
; 331         a += 1;
	add 1
; 332         h = a;
	ld h, a
; 333         // DE
; 334         a = FtpViewDX;
	ld a, (ftpviewdx)
; 335         a -= 2;
	sub 2
; 336         d = a;
	ld d, a
; 337         a = 1;
	ld a, 1
; 338         e = a;
	ld e, a
; 339         // C
; 340         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_156
; 341             a = FtpViewColor;
	ld a, (ftpviewcolor)
	jp l_157
l_156:
; 342         } else {
; 343             a = FtpViewInvColor;
	ld a, (ftpviewinvcolor)
l_157:
; 344         }
; 345         c = a;
	ld c, a
; 346         // A
; 347         a = vboxUMP;
	ld a, 4
; 348         vboxOpenHLDECA();
	call vboxopenhldeca
	pop bc
	ret
; 349     }
; 350 }
; 351 
; 352 void FtpViewKeyA() {
ftpviewkeya:
; 353     push_pop(hl) {
	push hl
; 354         l = a;
	ld l, a
; 355         if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, l_158
; 356             if ((a = l) == 0x09) { //0x09 TAB
	ld a, l
	cp 9
	jp nz, l_160
; 357                 CurrentViewChangeIdA(a = DiskViewId);
	ld a, 1
	call currentviewchangeida
	jp l_161
l_160:
; 358             } else {
; 359                 if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, l_162
; 360                     FtpViewFileCurrentPosUpdateA(a = 0x01);
	ld a, 1
	call ftpviewfilecurrentposupdatea
	jp l_163
l_162:
; 361                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, l_164
; 362                     FtpViewFileCurrentPosUpdateA(a = 0xFF);
	ld a, 255
	call ftpviewfilecurrentposupdatea
	jp l_165
l_164:
; 363                 } else if ((a = l) == 0x0D) { //Enter
	ld a, l
	cp 13
	jp nz, l_166
; 364                     if ((a = FtpViewFileCurrentPos) == 0) { // Dir UP
	ld a, (ftpviewfilecurrentpos)
	or a
	jp nz, l_168
; 365                         ftpChangeDirUp();
	call ftpchangedirup
; 366                         FtpViewNetLoadAndUpdate();
	call ftpviewnetloadandupdate
	jp l_169
l_168:
; 367                     } else {
; 368                         FtpViewCurrentPosIsDir();
	call ftpviewcurrentposisdir
; 369                         if (a == 1) { // Enter Dir
	cp 1
	jp nz, l_170
; 370                             //FtpViewShowSelectLineA(a = 0); // TODO надо убрать...
; 371                             ftpChangeDirPosA(a = FtpViewFileCurrentPos);
	ld a, (ftpviewfilecurrentpos)
	call ftpchangedirposa
; 372                             FtpViewNetLoadAndUpdate();
	call ftpviewnetloadandupdate
	jp l_171
l_170:
; 373                         } else { // Load file
; 374                             FtpViewLoadFile();
	call ftpviewloadfile
l_171:
l_169:
	jp l_167
l_166:
; 375                         }
; 376                     }
; 377                 } else if ((a = l) == 'R') { // Обновление папки
	ld a, l
	cp 82
	jp nz, l_172
; 378                     FtpViewNetLoadAndUpdate();
	call ftpviewnetloadandupdate
	jp l_173
l_172:
; 379                 } else if ((a = l) == 'C') { // загрузка файла
	ld a, l
	cp 67
	jp nz, l_174
; 380                     FtpViewCurrentPosIsDir();
	call ftpviewcurrentposisdir
; 381                     if (a == 0) { // Проверим что это файл
	or a
	jp nz, l_176
; 382                         FtpViewLoadFile();
	call ftpviewloadfile
l_176:
	jp l_175
l_174:
; 383                     }
; 384                 } else if ((a = l) == 'H') { // Перейти в домашную папку
	ld a, l
	cp 72
	jp nz, l_178
; 385                     ThreadsNetFtpGoToHomeDir();
	call threadsnetftpgotohomedir
l_178:
l_175:
l_173:
l_167:
l_165:
l_163:
l_161:
l_158:
	pop hl
	ret
; 386                 }
; 387             }
; 388         }
; 389     }
; 390 }
; 391 
; 392 void FtpViewLoadFile() {
ftpviewloadfile:
; 393     LoadViewShowHL(hl = LoadViewLoadTitle);
	ld hl, loadviewloadtitle
	call loadviewshowhl
; 394     #ifdef _IS_SIMULATOR
; 395         push_pop(bc) {
; 396             b = 0;
; 397             do {
; 398                 LoadViewShowProgressA(a = b);
; 399                 c = 1;
; 400                 do {
; 401                     delay50ms();
; 402                     c--;
; 403                 } while ((a = c) > 0);
; 404                 b++;
; 405             } while ((a = b) < 40);
; 406             LoadViewClose();
; 407             DiskViewUpdateDateAndUI();
; 408         }
; 409     #else
; 410         FtpViewNeedLoad();
	call ftpviewneedload
; 411         LoadViewClose();
	call loadviewclose
; 412         DiskViewUpdateDateAndUI();
	jp diskviewupdatedateandui
; 413     #endif
; 414 }
; 415 
; 416 void FtpViewNeedLoad() {
ftpviewneedload:
; 417     ftpFileDownloadA(a = FtpViewFileCurrentPos);
	ld a, (ftpviewfilecurrentpos)
	call ftpfiledownloada
; 418     
; 419     // Считываем текущий диск и устанавливаем его
; 420     a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 421     ordos_wnd();
	call ordos_wnd
; 422     
; 423     // Получаем адрес куда надо начинать писать данные
; 424     ordos_mxdsk();
	call ordos_mxdsk
; 425     DiskViewStartNewFile = hl;
	ld (diskviewstartnewfile), hl
; 426     
; 427     // Вызываем закачку
; 428     ftpFileDownloadNext();
	jp ftpfiledownloadnext
; 429 }
; 430 
; 431 void FtpViewNetLoadAndUpdate() {
ftpviewnetloadandupdate:
; 432     FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 433     getFtpCurrentPathNew();
	call getftpcurrentpathnew
; 434     if ((a = FtpStateViewStatus) == 1) {
	ld a, (ftpstateviewstatus)
	cp 1
	jp nz, l_180
; 435         updateFtpList();
	call updateftplist
; 436         getNetFtpListNew();
	call getnetftplistnew
l_180:
; 437     }
; 438     a = 0;
	ld a, 0
; 439     FtpViewFileCurrentPos = a;
	ld (ftpviewfilecurrentpos), a
; 440     FtpViewShowFileList();
	call ftpviewshowfilelist
; 441     FtpViewShowPath();
	call ftpviewshowpath
; 442     FtpViewShowSelectLineA(a = 1);
	ld a, 1
	jp ftpviewshowselectlinea
; 443 }
; 444 
; 445 void FtpViewCurrentPosIsDir() {
ftpviewcurrentposisdir:
; 446     push_pop(hl, bc) {
	push hl
	push bc
; 447         hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 448         //--
; 449         a = FtpViewFileCurrentPos;
	ld a, (ftpviewfilecurrentpos)
; 450         a &= 0x3F;
	and 63
; 451         b = 0;
	ld b, 0
; 452         carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 453         if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, l_182
; 454             b++;
	inc b
l_182:
; 455         }
; 456         c = a;
	ld c, a
; 457         //-- Смещаем на позицию файла
; 458         hl += bc;
	add hl, bc
; 459         //-- Смещаем на признак директории
; 460         bc = 10;
	ld bc, 10
; 461         hl += bc;
	add hl, bc
; 462         //--
; 463         a = *hl;
	ld a, (hl)
	pop bc
	pop hl
	ret
; 464     }
; 465 }
; 466 
; 467 void FtpViewEmptyList() {
ftpviewemptylist:
; 468     push_pop(hl) {
	push hl
; 469         a = 1;
	ld a, 1
; 470         FtpViewFilesListCount = a;
	ld (ftpviewfileslistcount), a
; 471         a = 0;
	ld a, 0
; 472         FtpViewFileCurrentPos = a;
	ld (ftpviewfilecurrentpos), a
; 473         hl = FtpViewFilesList;
	ld hl, ftpviewfileslist
; 474         //--
; 475         *hl = '.';
	ld (hl), 46
; 476         hl++;
	inc hl
; 477         *hl = '.';
	ld (hl), 46
; 478         hl++;
	inc hl
; 479         //--
; 480         *hl = ' ';
	ld (hl), 32
; 481         hl++;
	inc hl
; 482         *hl = ' ';
	ld (hl), 32
; 483         hl++;
	inc hl
; 484         *hl = ' ';
	ld (hl), 32
; 485         hl++;
	inc hl
; 486         *hl = ' ';
	ld (hl), 32
; 487         hl++;
	inc hl
; 488         *hl = ' ';
	ld (hl), 32
; 489         hl++;
	inc hl
; 490         *hl = ' ';
	ld (hl), 32
; 491         hl++;
	inc hl
	pop hl
; 492     }
; 493     //--
; 494     FtpViewListUpdateUI();
; 495 }
; 496 
; 497 void FtpViewListUpdateUI() {
ftpviewlistupdateui:
; 498     FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 499     a = 0;
	ld a, 0
; 500     FtpViewFileCurrentPos = a;
	ld (ftpviewfilecurrentpos), a
; 501     FtpViewShowPath();
	call ftpviewshowpath
; 502     FtpViewShowFileList();
	call ftpviewshowfilelist
; 503     FtpViewShowSelectLineA(a = 1);
	ld a, 1
	jp ftpviewshowselectlinea
; 504 }
; 505 
; 506 uint8_t FtpViewX = 0;
ftpviewx:
	db 0
; 507 uint8_t FtpViewY = 4;
ftpviewy:
	db 4
; 508 uint8_t FtpViewDX = 28;
ftpviewdx:
	db 28
; 509 uint8_t FtpViewDY = 25;
ftpviewdy:
	db 25
; 510 uint8_t FtpViewColor = 0x1F;
ftpviewcolor:
	db 31
; 511 uint8_t FtpViewInvColor = 0xF1;
ftpviewinvcolor:
	db 241
; 513 uint8_t FtpViewTitle[] = {0xB5, 'F', 'T', 'P', 0xC6, '\0'}; //"\x12" + "FTP";
ftpviewtitle:
	db 181
	db 70
	db 84
	db 80
	db 198
	db 0
; 514 uint8_t FtpViewPath[16] = "/Orion/TEST/";
ftpviewpath:
	db 47
	db 79
	db 114
	db 105
	db 111
	db 110
	db 47
	db 84
	db 69
	db 83
	db 84
	db 47
	ds 4
; 516 uint8_t FtpViewFileCurrentPos = 0;
ftpviewfilecurrentpos:
	db 0
; 531 uint8_t FtpViewFilesListCount = 1;
ftpviewfileslistcount:
	db 1
; 532 uint8_t FtpViewFilesList[16 * 23] = {
ftpviewfileslist:
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
	db 32
	db 32
	db 32
	db 32
	ds 352
; 11 void DiskViewShow() {
diskviewshow:
; 12     a = DiskViewX;
	ld a, (diskviewx)
; 13     h = a;
	ld h, a
; 14     a = DiskViewY;
	ld a, (diskviewy)
; 15     l = a;
	ld l, a
; 16     a = DiskViewDX;
	ld a, (diskviewdx)
; 17     d = a;
	ld d, a
; 18     a = DiskViewDY;
	ld a, (diskviewdy)
; 19     e = a;
	ld e, a
; 20     a = DiskViewColor;
	ld a, (diskviewcolor)
; 21     vboxOpenHLDE();
	call vboxopenhlde
; 22     vboxBorderHLDE();
	call vboxborderhlde
; 23     DiskViewShowTitle();
	call diskviewshowtitle
; 24     
; 25     //DEBUG!!!
; 26     DiskViewSetDiskNumA(a = 'B');
	ld a, 66
	jp diskviewsetdisknuma
; 27 }
; 28 
; 29 void DiskViewShowTitle() {
diskviewshowtitle:
; 30     a = DiskViewX;
	ld a, (diskviewx)
; 31     a++;
	inc a
; 32     myCharPosX = a;
	ld (mycharposx), a
; 33     a = DiskViewY;
	ld a, (diskviewy)
; 34     myCharPosY = a;
	ld (mycharposy), a
; 35     printMyHLStr(hl = DiskViewTitle);
	ld hl, diskviewtitle
	jp printmyhlstr
; 36 }
; 37 
; 38 void DiskViewUpdateDir() {
diskviewupdatedir:
; 39     push_pop(hl) {
	push hl
; 40         a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 41         ordos_wnd();
	call ordos_wnd
; 42         hl = DiskViewDirBufer;
	ld hl, (diskviewdirbufer)
; 43         ordos_dirm();
	call ordos_dirm
; 44         DiskViewDirCount = a;
	ld (diskviewdircount), a
	pop hl
	ret
; 45     }
; 46 }
; 47 
; 48 void DiskViewShowDir() {
diskviewshowdir:
; 49     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 50         //-----
; 51         a = DiskViewX;
	ld a, (diskviewx)
; 52         a += 2;
	add 2
; 53         d = a; // X
	ld d, a
; 54         a = DiskViewY;
	ld a, (diskviewy)
; 55         a += 3;
	add 3
; 56         e = a; // Y
	ld e, a
; 57         //-----
; 58         a = d;
	ld a, d
; 59         myCharPosX = a;
	ld (mycharposx), a
; 60         a = e;
	ld a, e
; 61         a--;
	dec a
; 62         myCharPosY = a;
	ld (mycharposy), a
; 63         printMyHLStr(hl = DiskViewDirRootTitle);
	ld hl, diskviewdirroottitle
	call printmyhlstr
; 64         //-----
; 65         if ((a = DiskViewDirCount) >= 1) {
	ld a, (diskviewdircount)
	or a
	jp z, l_184
; 66             hl = DiskViewDirBufer;
	ld hl, (diskviewdirbufer)
; 67             b = 0;
	ld b, 0
; 68             do {
l_186:
; 69                 a = d;
	ld a, d
; 70                 myCharPosX = a;
	ld (mycharposx), a
; 71                 a = e;
	ld a, e
; 72                 a += b;
	add b
; 73                 myCharPosY = a;
	ld (mycharposy), a
; 74                 c = 8;
	ld c, 8
; 75                 do {
l_189:
; 76                     printMyChatA(a = *hl);
	ld a, (hl)
	call printmychata
; 77                     hl++;
	inc hl
; 78                     c--;
	dec c
l_190:
; 79                 } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, l_189
; 80                 hl++;
	inc hl
; 81                 hl++;
	inc hl
; 82                 hl++;
	inc hl
; 83                 hl++;
	inc hl
; 84                 hl++;
	inc hl
; 85                 hl++;
	inc hl
; 86                 hl++;
	inc hl
; 87                 hl++;
	inc hl
; 88                 b++;
	inc b
; 89                 a = DiskViewDirCount;
	ld a, (diskviewdircount)
; 90                 a--;
	dec a
l_187:
; 91             } while (a >= b);
	cp b
	jp nc, l_186
l_184:
; 92         }
; 93         // show empty rows
; 94         a = DiskViewDirCount;
	ld a, (diskviewdircount)
; 95         b = a;
	ld b, a
; 96         // PosY
; 97         a = e;
	ld a, e
; 98         a += b;
	add b
; 99         e = a;
	ld e, a
; 100         //
; 101         a = DiskViewDY;
	ld a, (diskviewdy)
; 102         a -= 4;
	sub 4
; 103         a -= b;
	sub b
; 104         b = a;
	ld b, a
; 105         c = 0;
	ld c, 0
; 106         do {
l_192:
; 107             a = d;
	ld a, d
; 108             myCharPosX = a;
	ld (mycharposx), a
; 109             a = e;
	ld a, e
; 110             a += c;
	add c
; 111             myCharPosY = a;
	ld (mycharposy), a
; 112             //
; 113             a = DiskViewDX;
	ld a, (diskviewdx)
; 114             a -= 3;
	sub 3
; 115             h = a;
	ld h, a
; 116             do {
l_195:
; 117                 printMyChatA(a = ' ');
	ld a, 32
	call printmychata
; 118                 h--;
	dec h
l_196:
; 119             } while ((a = h) > 0);
	ld a, h
	or a
	jp nz, l_195
; 120             b--;
	dec b
; 121             c++;
	inc c
l_193:
; 122         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_192
	pop de
	pop bc
	pop hl
	ret
; 123     }
; 124 }
; 125 
; 126 void DiskViewKeyA() {
diskviewkeya:
; 127     push_pop(hl) {
	push hl
; 128         l = a;
	ld l, a
; 129         if ((a = CurrentViewId) == DiskViewId) {
	ld a, (currentviewid)
	cp 1
	jp nz, l_198
; 130             if ((a = l) == 0x09) { //0x09 TAB
	ld a, l
	cp 9
	jp nz, l_200
; 131                 CurrentViewChangeIdA(a = FtpViewId);
	ld a, 2
	call currentviewchangeida
	jp l_201
l_200:
; 132             } else {
; 133                 if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, l_202
; 134                     DiskViewFileCurrentPosUpdateA(a = 0x01);
	ld a, 1
	call diskviewfilecurrentposupdatea
	jp l_203
l_202:
; 135                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, l_204
; 136                     DiskViewFileCurrentPosUpdateA(a = 0xFF);
	ld a, 255
	call diskviewfilecurrentposupdatea
	jp l_205
l_204:
; 137                 } else if ((a = l) == 0x0D) { //Enter
	ld a, l
	cp 13
	jp nz, l_206
; 138                     if ((a = DiskViewFileCurrentPos) == 0) { // Смена диска
	ld a, (diskviewfilecurrentpos)
	or a
	jp nz, l_208
; 139                         DiskViewNextDiskNum();
	call diskviewnextdisknum
	jp l_209
l_208:
; 140                     } else { // Закачка на FTP
l_209:
	jp l_207
l_206:
; 141                         
; 142                     }
; 143                 } else if ((a = l) == 'D') { //  Показать выбор диска
	ld a, l
	cp 68
	jp nz, l_210
; 144                     SelectDiskViewShow();
	call selectdiskviewshow
l_210:
l_207:
l_205:
l_203:
l_201:
l_198:
	pop hl
	ret
; 145                 }
; 146             }
; 147         }
; 148     }
; 149 }
; 150 
; 151 void DiskViewNextDiskNum() {
diskviewnextdisknum:
; 152     a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 153     a++;
	inc a
; 154     if (a == 'E') {
	cp 69
	jp nz, l_212
; 155         a = 'A';
	ld a, 65
l_212:
; 156     }
; 157     DiskViewSetDiskNumA();
; 158 }
; 159 
; 160 void DiskViewSetDiskNumA() {
diskviewsetdisknuma:
; 161     DiskViewDiskNum = a;
	ld (diskviewdisknum), a
; 162     DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
; 163     a = 0;
	ld a, 0
; 164     DiskViewFileCurrentPos = a;
	ld (diskviewfilecurrentpos), a
; 165     DiskViewUpdateDiskTitle();
	call diskviewupdatedisktitle
; 166     DiskViewUpdateDateAndUI();
; 167 }
; 168 
; 169 void DiskViewUpdateDateAndUI() {
diskviewupdatedateandui:
; 170     DiskViewUpdateDir();
	call diskviewupdatedir
; 171     DiskViewShowDir();
	call diskviewshowdir
; 172     if ((a = CurrentViewId) == DiskViewId) {
	ld a, (currentviewid)
	cp 1
	jp nz, l_214
; 173         DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
l_214:
	ret
; 174     }
; 175 }
; 176 
; 177 void DiskViewUpdateDiskTitle() {
diskviewupdatedisktitle:
; 178     a = DiskViewX;
	ld a, (diskviewx)
; 179     a += 7;
	add 7
; 180     myCharPosX = a;
	ld (mycharposx), a
; 181     a = DiskViewY;
	ld a, (diskviewy)
; 182     myCharPosY = a;
	ld (mycharposy), a
; 183     printMyChatA(a = DiskViewDiskNum);
	ld a, (diskviewdisknum)
	jp printmychata
; 184 }
; 185 
; 186 /// Обновление позиции
; 187 /// вх[A]
; 188 /// 0 - без изменений
; 189 /// 1 - вверх
; 190 /// 0xFF - вниз
; 191 void DiskViewFileCurrentPosUpdateA() {
diskviewfilecurrentposupdatea:
; 192     push_pop(bc) {
	push bc
; 193         b = a;
	ld b, a
; 194         if (a == 0) {
	or a
	jp nz, l_216
; 195             DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
	jp l_217
l_216:
; 196         } else {
; 197             a = DiskViewDirCount;
	ld a, (diskviewdircount)
; 198             a += 1;
	add 1
; 199             c = a;
	ld c, a
; 200             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
; 201             a = DiskViewFileCurrentPos;
	ld a, (diskviewfilecurrentpos)
; 202             a += b;
	add b
; 203             //
; 204             if (a == 0xFF) {
	cp 255
	jp nz, l_218
; 205                 a = c;
	ld a, c
; 206                 a--;
	dec a
	jp l_219
l_218:
; 207             } else if (a == c) {
	cp c
	jp nz, l_220
; 208                 a = 0;
	ld a, 0
l_220:
l_219:
; 209             }
; 210             DiskViewFileCurrentPos = a;
	ld (diskviewfilecurrentpos), a
; 211             DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
l_217:
	pop bc
	ret
; 212         }
; 213     }
; 214 }
; 215 
; 216 /// Рисование линии прямым или инверсным цветом
; 217 /// 0 - прямой
; 218 /// 1 - инверсный
; 219 void DiskViewShowSelectLineA() {
diskviewshowselectlinea:
; 220     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 221         c = a;
	ld c, a
; 222         // HL
; 223         a = DiskViewFileCurrentPos;
	ld a, (diskviewfilecurrentpos)
; 224         b = a;
	ld b, a
; 225         a = DiskViewY;
	ld a, (diskviewy)
; 226         a += 2;
	add 2
; 227         a += b;
	add b
; 228         l = a;
	ld l, a
; 229         a = DiskViewX;
	ld a, (diskviewx)
; 230         a += 1;
	add 1
; 231         h = a;
	ld h, a
; 232         // DE
; 233         a = DiskViewDX;
	ld a, (diskviewdx)
; 234         a -= 2;
	sub 2
; 235         d = a;
	ld d, a
; 236         a = 1;
	ld a, 1
; 237         e = a;
	ld e, a
; 238         // C
; 239         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_222
; 240             a = DiskViewColor;
	ld a, (diskviewcolor)
	jp l_223
l_222:
; 241         } else {
; 242             a = DiskViewInvColor;
	ld a, (diskviewinvcolor)
l_223:
; 243         }
; 244         c = a;
	ld c, a
; 245         // A
; 246         a = vboxUMP;
	ld a, 4
; 247         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop hl
	pop bc
	ret
; 248     }
; 249 }
; 250 
; 251 uint8_t DiskViewX = 28;
diskviewx:
	db 28
; 252 uint8_t DiskViewY = 4;
diskviewy:
	db 4
; 253 uint8_t DiskViewDX = 20;
diskviewdx:
	db 20
; 254 uint8_t DiskViewDY = 25;
diskviewdy:
	db 25
; 255 uint8_t DiskViewColor = 0x1F;
diskviewcolor:
	db 31
; 256 uint8_t DiskViewInvColor = 0xF1;
diskviewinvcolor:
	db 241
; 258 uint8_t DiskViewDiskNum = 'B';
diskviewdisknum:
	db 66
; 259 uint8_t DiskViewDirCount = 0;
diskviewdircount:
	db 0
; 260 uint16_t DiskViewDirBufer = 0x0000;
diskviewdirbufer:
	dw 0
; 261 uint8_t DiskViewFileCurrentPos = 0;
diskviewfilecurrentpos:
	db 0
; 263 uint16_t DiskViewStartNewFile = 0x0000;
diskviewstartnewfile:
	dw 0
; 265 uint8_t DiskViewDirRootTitle[] = "..";
diskviewdirroottitle:
	db 46
	db 46
	ds 1
; 266 uint8_t DiskViewTitle[] = {0xB5, 'D', 'i', 's', 'k', ':', 'A', 0xC6, '\0'};
diskviewtitle:
	db 181
	db 68
	db 105
	db 115
	db 107
	db 58
	db 65
	db 198
	db 0
; 11 void CurrentViewChangeAndPushIdA() {
currentviewchangeandpushida:
; 12     push_pop(bc) {
	push bc
; 13         b = a;
	ld b, a
; 14         // Save old Id
; 15         CurrentViewPushCurrentId();
	call currentviewpushcurrentid
; 16         //
; 17         a = b;
	ld a, b
; 18         CurrentViewSetIdA();
	call currentviewsetida
	pop bc
	ret
; 19     }
; 20 }
; 21 
; 22 void CurrentViewChangeIdA() {
currentviewchangeida:
; 23     push_pop(bc) {
	push bc
; 24         b = a;
	ld b, a
; 25         // Save new
; 26         a = b;
	ld a, b
; 27         CurrentViewSetIdA();
	call currentviewsetida
	pop bc
	ret
; 28     }
; 29 }
; 30 
; 31 void CurrentViewSetIdA() {
currentviewsetida:
; 32     CurrentViewId = a;
	ld (currentviewid), a
; 33     
; 34     if ((a = CurrentViewReturnIdPos) == 0) {
	ld a, (currentviewreturnidpos)
	or a
	jp nz, l_224
; 35         if ((a = CurrentViewId) == DiskViewId) {
	ld a, (currentviewid)
	cp 1
	jp nz, l_226
; 36             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 37             DiskViewShowSelectLineA(a = 1);
	ld a, 1
	call diskviewshowselectlinea
	jp l_227
l_226:
; 38         } else if ((a = CurrentViewId) == FtpViewId) {
	ld a, (currentviewid)
	cp 2
	jp nz, l_228
; 39             FtpViewShowSelectLineA(a = 1);
	ld a, 1
	call ftpviewshowselectlinea
; 40             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp l_229
l_228:
; 41         } else if ((a = CurrentViewId) == SelectDiskViewId) {
	ld a, (currentviewid)
	cp 3
	jp nz, l_230
; 42             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 43             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp l_231
l_230:
; 44         } else if ((a = CurrentViewId) == LoadViewId) {
	ld a, (currentviewid)
	cp 4
	jp nz, l_232
; 45             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 46             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp l_233
l_232:
; 47         } else if ((a = CurrentViewId) == WiFiSettingsViewId) {
	ld a, (currentviewid)
	cp 5
	jp nz, l_234
; 48             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 49             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
	jp l_235
l_234:
; 50         } else if ((a = CurrentViewId) == FtpSettingsViewId) {
	ld a, (currentviewid)
	cp 8
	jp nz, l_236
; 51             FtpViewShowSelectLineA(a = 0);
	ld a, 0
	call ftpviewshowselectlinea
; 52             DiskViewShowSelectLineA(a = 0);
	ld a, 0
	call diskviewshowselectlinea
l_236:
l_235:
l_233:
l_231:
l_229:
l_227:
l_224:
	ret
; 53         }
; 54     }
; 55 }
; 56 
; 57 void CurrentViewPushCurrentId() {
currentviewpushcurrentid:
; 58     push_pop(de, hl) {
	push de
	push hl
; 59         hl = CurrentViewReturnIds;
	ld hl, currentviewreturnids
; 60         // Add delta
; 61         d = 0;
	ld d, 0
; 62         a = CurrentViewReturnIdPos;
	ld a, (currentviewreturnidpos)
; 63         e = a;
	ld e, a
; 64         a++;
	inc a
; 65         CurrentViewReturnIdPos = a;
	ld (currentviewreturnidpos), a
; 66         hl += de;
	add hl, de
; 67         // Save current ID
; 68         a = CurrentViewId;
	ld a, (currentviewid)
; 69         *hl = a;
	ld (hl), a
	pop hl
	pop de
	ret
; 70     }
; 71 }
; 72 
; 73 // Return A - ID
; 74 void CurrentViewPopId() {
currentviewpopid:
; 75     if ((a = CurrentViewReturnIdPos) > 0) {
	ld a, (currentviewreturnidpos)
	or a
	jp z, l_238
; 76         // Decriment
; 77         a = CurrentViewReturnIdPos;
	ld a, (currentviewreturnidpos)
; 78         a--;
	dec a
; 79         CurrentViewReturnIdPos = a;
	ld (currentviewreturnidpos), a
; 80         //--
; 81         e = a;
	ld e, a
; 82         d = 0;
	ld d, 0
; 83         hl = CurrentViewReturnIds;
	ld hl, currentviewreturnids
; 84         hl += de;
	add hl, de
; 85         a = *hl;
	ld a, (hl)
	jp l_239
l_238:
; 86     } else {
; 87         a = CurrentViewId;
	ld a, (currentviewid)
l_239:
	ret
; 88     }
; 89 }
; 90 
; 91 void CurrentViewReturn() {
currentviewreturn:
; 92     CurrentViewPopId();
	call currentviewpopid
; 93     CurrentViewChangeIdA();
	jp currentviewchangeida
; 94 }
; 95 
; 96 /// вых [A] 1 - если активное окно DiskView или FtpView
; 97 /// 0 - если любое другое
; 98 void CurrentViewDiskOrFtpViewByIdA() {
currentviewdiskorftpviewbyida:
; 99     push_pop(bc) {
	push bc
; 100         b = a;
	ld b, a
; 101         if ((a = b) == DiskViewId) {
	ld a, b
	cp 1
	jp nz, l_240
; 102             a = 1;
	ld a, 1
; 103             CurrentViewDiskOrFtpViewFocus = a;
	ld (currentviewdiskorftpviewfocus), a
	jp l_241
l_240:
; 104         } else if ((a = b) == FtpViewId) {
	ld a, b
	cp 2
	jp nz, l_242
; 105             a = 1;
	ld a, 1
; 106             CurrentViewDiskOrFtpViewFocus = a;
	ld (currentviewdiskorftpviewfocus), a
	jp l_243
l_242:
; 107         } else {
; 108             a = 0;
	ld a, 0
; 109             CurrentViewDiskOrFtpViewFocus = a;
	ld (currentviewdiskorftpviewfocus), a
l_243:
l_241:
	pop bc
; 110         }
; 111     }
; 112     a =  CurrentViewDiskOrFtpViewFocus;
	ld a, (currentviewdiskorftpviewfocus)
	ret
; 113 }
; 114 
; 115 uint8_t CurrentViewDiskOrFtpViewFocus = 0;
currentviewdiskorftpviewfocus:
	db 0
; 117 uint8_t CurrentViewReturnIds[16];
currentviewreturnids:
	ds 16
; 118 uint8_t CurrentViewReturnIdPos = 0;
currentviewreturnidpos:
	db 0
; 119 uint8_t CurrentViewId = FtpViewId;
currentviewid:
	db 2
; 120 uint8_t FtpNetStateChange = 0;
ftpnetstatechange:
	db 0
; 121 uint8_t WiFiNetStateChange = 0;
wifinetstatechange:
	db 0
; 11 void SelectDiskViewShow() {
selectdiskviewshow:
; 12     CurrentViewChangeAndPushIdA(a = SelectDiskViewId);
	ld a, 3
	call currentviewchangeandpushida
; 13     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 14         a = SelectDiskViewX;
	ld a, (selectdiskviewx)
; 15         h = a;
	ld h, a
; 16         a = SelectDiskViewY;
	ld a, (selectdiskviewy)
; 17         l = a;
	ld l, a
; 18         a = SelectDiskViewDX;
	ld a, (selectdiskviewdx)
; 19         d = a;
	ld d, a
; 20         a = SelectDiskViewDY;
	ld a, (selectdiskviewdy)
; 21         e = a;
	ld e, a
; 22         a = SelectDiskViewColor;
	ld a, (selectdiskviewcolor)
; 23         c = a;
	ld c, a
; 24         a = vboxCLW;
	ld a, 64
; 25         a |= vboxFRM;
	or 32
; 26         a |= vboxSDW;
	or 16
; 27         a |= vboxSAV;
	or 8
; 28         a |= vboxUMP;
	or 4
; 29         vboxOpenHLDECA();
	call vboxopenhldeca
; 30         
; 31         a = DiskViewDiskNum;
	ld a, (diskviewdisknum)
; 32         a -= 'A';
	sub 65
; 33         SelectDiskViewCurrentPos = a;
	ld (selectdiskviewcurrentpos), a
; 34         
; 35         SelectDiskViewShowDiskList();
	call selectdiskviewshowdisklist
; 36         SelectDiskViewUpdateSelectA(a = 1);
	ld a, 1
	call selectdiskviewupdateselecta
	pop de
	pop hl
	pop bc
	ret
; 37     }
; 38 }
; 39 
; 40 void SelectDiskViewShowDiskList() {
selectdiskviewshowdisklist:
; 41     push_pop(bc) {
	push bc
; 42         // Title
; 43         a = SelectDiskViewY;
	ld a, (selectdiskviewy)
; 44         a += 1;
	add 1
; 45         myCharPosY = a;
	ld (mycharposy), a
; 46         a = SelectDiskViewX;
	ld a, (selectdiskviewx)
; 47         a += 4;
	add 4
; 48         myCharPosX = a;
	ld (mycharposx), a
; 49         printMyHLStr(hl = SelectDiskViewSelectTitle);
	ld hl, selectdiskviewselecttitle
	call printmyhlstr
; 50         // SubTitle
; 51         a = SelectDiskViewY;
	ld a, (selectdiskviewy)
; 52         a += 2;
	add 2
; 53         myCharPosY = a;
	ld (mycharposy), a
; 54         a = SelectDiskViewX;
	ld a, (selectdiskviewx)
; 55         a += 4;
	add 4
; 56         myCharPosX = a;
	ld (mycharposx), a
; 57         printMyHLStr(hl = SelectDiskViewSelectSubTitle);
	ld hl, selectdiskviewselectsubtitle
	call printmyhlstr
; 58         // LINE!!!
; 59         a = SelectDiskViewX;
	ld a, (selectdiskviewx)
; 60         a += 1;
	add 1
; 61         myCharPosX = a;
	ld (mycharposx), a
; 62         a = SelectDiskViewY;
	ld a, (selectdiskviewy)
; 63         a += 3;
	add 3
; 64         myCharPosY = a;
	ld (mycharposy), a
; 65         a = SelectDiskViewDX;
	ld a, (selectdiskviewdx)
; 66         a -= 2;
	sub 2
; 67         b = a;
	ld b, a
; 68         do {
l_244:
; 69             printMyChatA(a = 0x5F);
	ld a, 95
	call printmychata
; 70             b--;
	dec b
l_245:
; 71         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_244
; 72         // Disk List
; 73         a = SelectDiskViewY;
	ld a, (selectdiskviewy)
; 74         a += 6;
	add 6
; 75         myCharPosY = a;
	ld (mycharposy), a
; 76         a = SelectDiskViewX;
	ld a, (selectdiskviewx)
; 77         a += 2;
	add 2
; 78         myCharPosX = a;
	ld (mycharposx), a
; 79         b = 0;
	ld b, 0
; 80         do {
l_247:
; 81             a = b;
	ld a, b
; 82             a += 'A';
	add 65
; 83             printMyChatA();
	call printmychata
; 84             myCharPosXSpaceA(a = 2);
	ld a, 2
	call mycharposxspacea
; 85             b++;
	inc b
l_248:
; 86         } while ((a = b) < 4);
	ld a, b
	cp 4
	jp c, l_247
	pop bc
	ret
; 87     }
; 88 }
; 89 
; 90 /// 0 - прямой
; 91 /// 1 - инверсный
; 92 void SelectDiskViewUpdateSelectA() {
selectdiskviewupdateselecta:
; 93     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 94         c = a;
	ld c, a
; 95         // HL
; 96         a = SelectDiskViewCurrentPos;
	ld a, (selectdiskviewcurrentpos)
; 97         b = a;
	ld b, a
; 98         a = SelectDiskViewX;
	ld a, (selectdiskviewx)
; 99         a += 1;
	add 1
; 100         h = a;
	ld h, a
; 101         if ((a = b) > 0) {
	ld a, b
	or a
	jp z, l_250
; 102             do {
l_252:
; 103                 a = h;
	ld a, h
; 104                 a += 3;
	add 3
; 105                 h = a;
	ld h, a
; 106                 b--;
	dec b
l_253:
; 107             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_252
l_250:
; 108         }
; 109         a = SelectDiskViewY;
	ld a, (selectdiskviewy)
; 110         a += 5;
	add 5
; 111         l = a;
	ld l, a
; 112         // DE
; 113         a = 3;
	ld a, 3
; 114         d = a;
	ld d, a
; 115         a = 3;
	ld a, 3
; 116         e = a;
	ld e, a
; 117         // C
; 118         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_255
; 119             a = SelectDiskViewColor;
	ld a, (selectdiskviewcolor)
	jp l_256
l_255:
; 120         } else {
; 121             a = SelectDiskViewInvColor;
	ld a, (selectdiskviewinvcolor)
l_256:
; 122         }
; 123         c = a;
	ld c, a
; 124         // A
; 125         a = vboxUMP;
	ld a, 4
; 126         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop hl
	pop bc
	ret
; 127     }
; 128 }
; 129 
; 130 void SelectDiskViewSetCurrentPosA() {
selectdiskviewsetcurrentposa:
; 131     push_pop(bc) {
	push bc
; 132         b = a;
	ld b, a
; 133         SelectDiskViewUpdateSelectA(a = 0);
	ld a, 0
	call selectdiskviewupdateselecta
; 134         a = b;
	ld a, b
; 135         SelectDiskViewCurrentPos = a;
	ld (selectdiskviewcurrentpos), a
; 136         SelectDiskViewUpdateSelectA(a = 1);
	ld a, 1
	call selectdiskviewupdateselecta
	pop bc
	ret
; 137     }
; 138 }
; 139 
; 140 void SelectDiskViewKeyA() {
selectdiskviewkeya:
; 141     push_pop(hl) {
	push hl
; 142         l = a;
	ld l, a
; 143         if ((a = CurrentViewId) == SelectDiskViewId) {
	ld a, (currentviewid)
	cp 3
	jp nz, l_257
; 144             if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, l_259
; 145                 vboxClose();
	call vboxclose
; 146                 CurrentViewReturn();
	call currentviewreturn
	jp l_260
l_259:
; 147             } else if ((a = l) == 0x0D) { // Выбор диска
	ld a, l
	cp 13
	jp nz, l_261
; 148                 vboxClose();
	call vboxclose
; 149                 CurrentViewReturn();
	call currentviewreturn
; 150                 a = SelectDiskViewCurrentPos;
	ld a, (selectdiskviewcurrentpos)
; 151                 a += 'A';
	add 65
; 152                 DiskViewSetDiskNumA();
	call diskviewsetdisknuma
	jp l_262
l_261:
; 153             } else if ((a = l) == 0x18) { // Вправл
	ld a, l
	cp 24
	jp nz, l_263
; 154                 a = SelectDiskViewCurrentPos;
	ld a, (selectdiskviewcurrentpos)
; 155                 a++;
	inc a
; 156                 if (a == 4) {
	cp 4
	jp nz, l_265
; 157                     a = 0;
	ld a, 0
l_265:
; 158                 }
; 159                 SelectDiskViewSetCurrentPosA();
	call selectdiskviewsetcurrentposa
	jp l_264
l_263:
; 160             } else if ((a = l) == 0x08) { // Влево
	ld a, l
	cp 8
	jp nz, l_267
; 161                 a = SelectDiskViewCurrentPos;
	ld a, (selectdiskviewcurrentpos)
; 162                 if (a == 0) {
	or a
	jp nz, l_269
; 163                     a = 3;
	ld a, 3
	jp l_270
l_269:
; 164                 } else {
; 165                     a--;
	dec a
l_270:
; 166                 }
; 167                 SelectDiskViewSetCurrentPosA();
	call selectdiskviewsetcurrentposa
l_267:
l_264:
l_262:
l_260:
l_257:
	pop hl
	ret
; 168             }
; 169         }
; 170     }
; 171 }
; 172 
; 173 uint8_t SelectDiskViewX = 17;
selectdiskviewx:
	db 17
; 174 uint8_t SelectDiskViewY = 12;
selectdiskviewy:
	db 12
; 175 uint8_t SelectDiskViewDX = 14;
selectdiskviewdx:
	db 14
; 176 uint8_t SelectDiskViewDY = 9;
selectdiskviewdy:
	db 9
; 177 uint8_t SelectDiskViewColor = 0x70; //0x1F;
selectdiskviewcolor:
	db 112
; 178 uint8_t SelectDiskViewInvColor = 0x20; //0x2E;
selectdiskviewinvcolor:
	db 32
; 180 uint8_t SelectDiskViewCurrentPos = 0;
selectdiskviewcurrentpos:
	db 0
; 182 uint8_t SelectDiskViewSelectTitle[7] = "Choose";
selectdiskviewselecttitle:
	db 67
	db 104
	db 111
	db 111
	db 115
	db 101
	ds 1
; 183 uint8_t SelectDiskViewSelectSubTitle[7] = "drive:";
selectdiskviewselectsubtitle:
	db 100
	db 114
	db 105
	db 118
	db 101
	db 58
	ds 1
; 14 void sendCommand() {
sendcommand:
; 15     i2cWaitingForAccess();
	call i2cwaitingforaccess
; 16     push_pop(de, bc) {
	push de
	push bc
; 17         d = h;
	ld d, h
; 18         // form the slave address with the R/W bit (R=1, W=0) at LSB
; 19         a ^= a; // XRA     A Carry = 0
	xor a
; 20         a = CHIP_ADDRESS;
	ld a, (chip_address)
; 21         carry_rotate_left(a, 1); // shift address left, set R/W bit to 0 (write)
	rla
; 22         h = a;
	ld h, a
; 23         
; 24         startI2C();
	call starti2c
; 25         c = h;
	ld c, h
; 26         transmitNewI2C(); // Адрес и направление
	call transmitnewi2c
; 27         
; 28         c = l;
	ld c, l
; 29         transmitNewI2C(); // Комманда
	call transmitnewi2c
; 30         
; 31         // Отправляемые данные
; 32         if ((a = d) > 0) {
	ld a, d
	or a
	jp z, l_271
; 33             h = d;
	ld h, d
; 34             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 35             do {
l_273:
; 36                 a = *de;
	ld a, (de)
; 37                 de++;
	inc de
; 38                 c = a;
	ld c, a
; 39                 transmitNewI2C();
	call transmitnewi2c
; 40                 h--;
	dec h
l_274:
	jp nz, l_273
l_271:
; 41             } while(flag_nz);
; 42         }
; 43 
; 44         // Конец отправки
; 45         stopI2C();
	call stopi2c
	pop bc
	pop de
	ret
; 46     }
; 47 }
; 48 
; 49 /// вх. [L] - Кол-во считываемых байт
; 50 void readNewInBuffer() {
readnewinbuffer:
; 51     i2cWaitingForAccess();
	call i2cwaitingforaccess
; 52     push_pop(hl, bc) {
	push hl
	push bc
; 53         push_pop(de) {
	push de
; 54             a ^= a; // XRA
	xor a
; 55             a = CHIP_ADDRESS;
	ld a, (chip_address)
; 56             carry_rotate_left(a, 1);
	rla
; 57             a += 1;
	add 1
; 58             h = a;
	ld h, a
; 59             //
; 60             startI2C();
	call starti2c
; 61             c = h;
	ld c, h
; 62             transmitNewI2C();
	call transmitnewi2c
; 63             
; 64             // Ждем готовности ответа
; 65             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 66             
; 67             //l = 20;
; 68             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 69             do {
l_276:
; 70                 push_pop(bc) {
	push bc
; 71                     // Если последний ожидаемый байт - то передаем NACK
; 72                     if ((a = l) == 1) {
	ld a, l
	cp 1
	jp nz, l_279
; 73                         b = 0x01;
	ld b, 1
	jp l_280
l_279:
; 74                     } else {
; 75                         b = 0x00;
	ld b, 0
l_280:
; 76                     }
; 77                     recieveNewI2C();
	call recievenewi2c
; 78 //                    if ((a = b) == 0x01) {
; 79 //                        l = 1;
; 80 //                    }
; 81                     a = c;
	ld a, c
	pop bc
; 82                 }
; 83                 *de = a;
	ld (de), a
; 84                 de++;
	inc de
; 85                 l--;
	dec l
l_277:
; 86             } while ((a = l) > 0);
	ld a, l
	or a
	jp nz, l_276
; 87             a = 0; // stop byte
	ld a, 0
; 88             *de = a;
	ld (de), a
; 89             //
; 90             stopI2C();
	call stopi2c
	pop de
	pop bc
	pop hl
	ret
; 91         }
; 92     }
; 93 }
; 94 
; 95 uint8_t ESP_I2S_BUFFER[32];
esp_i2s_buffer:
	ds 32
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
l_281:
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
l_282:
	jp nz, l_281
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
l_284:
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
l_285:
	jp nz, l_284
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
	jp nz, l_287
; 158         a = 0x01;
	ld a, 1
	jp l_288
l_287:
; 159     } else {
; 160         a = 0x00;
	ld a, 0
l_288:
	ret
; 161     }
; 162 }
; 163 
; 164 void needAccess() {
needaccess:
; 165     do {
l_289:
; 166         readSDAState();
	call readsdastate
; 167         if (a == 1) {
	cp 1
	jp nz, l_292
; 168             nop();
	nop
; 169             nop();
	nop
; 170             nop();
	nop
l_292:
l_290:
; 171         }
; 172     } while (a == 0x01);
	cp 1
	jp z, l_289
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
l_294:
; 185         i2cBusy();
	call i2cbusy
; 186         if (a == 1) {
	cp 1
	jp nz, l_297
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
l_297:
l_295:
; 192         }
; 193     } while (a == 1);
	cp 1
	jp z, l_294
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
l_299:
; 200             bc--;
	dec bc
; 201             a = b;
	ld a, b
; 202             a |= c;
	or c
l_300:
	jp nz, l_299
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
; 13 void ftpChangeDirPosA() {
ftpchangedirposa:
; 14     push_pop(de) {
	push de
; 15         push_pop(hl) {
	push hl
; 16             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 17             *de = a;
	ld (de), a
; 18             //
; 19             delay5msI2C();
	call delay5msi2c
; 20             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 21             //
; 22             l = 32; // FTP_DIR_INDEX
	ld l, 32
; 23             h = 1; // 1 байт
	ld h, 1
; 24             sendCommand();
	call sendcommand
; 25             
; 26             delay5msI2C();
	call delay5msi2c
; 27             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 28             busRecoveryI2C();
	call busrecoveryi2c
	pop hl
	pop de
	ret
; 29         }
; 30     }
; 31 }
; 32 
; 33 /// Сменить директорию вверх
; 34 void ftpChangeDirUp() {
ftpchangedirup:
; 35     push_pop(de) {
	push de
; 36         push_pop(hl) {
	push hl
; 37             delay5msI2C();
	call delay5msi2c
; 38             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 39             //
; 40             l = 31; // FTP_DIR_UP
	ld l, 31
; 41             h = 0;
	ld h, 0
; 42             sendCommand();
	call sendcommand
; 43             
; 44             delay5msI2C();
	call delay5msi2c
; 45             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 46             busRecoveryI2C();
	call busrecoveryi2c
	pop hl
	pop de
	ret
; 47         }
; 48     }
; 49 }
; 50 
; 51 /// обновить сисок FTP файлов
; 52 void updateFtpList() {
updateftplist:
; 53     push_pop(hl, de) {
	push hl
	push de
; 54         //
; 55         de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 56         a = 20; // Получить 20 файлов
	ld a, 20
; 57         *de = a;
	ld (de), a
; 58         //
; 59         a = 0;
	ld a, 0
; 60         FtpViewFilesListCount = a;
	ld (ftpviewfileslistcount), a
; 61         delay5msI2C();
	call delay5msi2c
; 62         i2cWaitingForAccess();
	call i2cwaitingforaccess
; 63         l = 25;
	ld l, 25
; 64         h = 1; // Есть что передать
	ld h, 1
; 65         sendCommand();
	call sendcommand
; 66         
; 67         delay5msI2C();
	call delay5msi2c
; 68         i2cWaitingForAccess();
	call i2cwaitingforaccess
; 69         busRecoveryI2C();
	call busrecoveryi2c
	pop de
	pop hl
	ret
; 70     }
; 71 }
; 72 
; 73 /// Получаем список файлов и директорий в текущей папке
; 74 void getNetFtpListNew() {
getnetftplistnew:
; 75     //-- Lock
; 76     if ((a = NetIsLock) == 1) {
	ld a, (netislock)
	cp 1
	jp nz, l_302
; 77         return;
	ret
l_302:
; 78     }
; 79     a = 1;
	ld a, 1
; 80     NetIsLock = a;
	ld (netislock), a
; 81     //--
; 82     a = 0;
	ld a, 0
; 83     parseFtpListBufferIsCheck = a;
	ld (parseftplistbufferischeck), a
; 84     do {
l_304:
; 85         push_pop(hl) {
	push hl
; 86             if ((a = parseFtpListBufferIsCheck) == 1) {
	ld a, (parseftplistbufferischeck)
	cp 1
	jp nz, l_307
; 87                 delay5msI2C();
	call delay5msi2c
; 88                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 89                 l = 36; //GET_FTP_LIST_NEXT_NEW, // 36
	ld l, 36
; 90                 h = 0;
	ld h, 0
; 91                 sendCommand();
	call sendcommand
l_307:
; 92             }
; 93             
; 94             delay5msI2C();
	call delay5msi2c
; 95             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 96             l = 37; //GET_FTP_LIST_NEW, // 37
	ld l, 37
; 97             h = 0;
	ld h, 0
; 98             sendCommand();
	call sendcommand
; 99             //
; 100             delay5msI2C();
	call delay5msi2c
; 101             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 102             l = 15;
	ld l, 15
; 103             readNewInBuffer();
	call readnewinbuffer
; 104             
; 105             parseFtpListBuffer();
	call parseftplistbuffer
	pop hl
l_305:
; 106         }
; 107     } while ((a = parseFtpListBufferNext) != 0x5A);
	ld a, (parseftplistbuffernext)
	cp 90
	jp nz, l_304
; 108     a = FtpViewFilesListCount;
	ld a, (ftpviewfileslistcount)
; 109     a++;
	inc a
; 110     FtpViewFilesListCount = a;
	ld (ftpviewfileslistcount), a
; 111     //-- Lock
; 112     a = 0;
	ld a, 0
; 113     NetIsLock = a;
	ld (netislock), a
	ret
; 114     //--
; 115 }
; 116 
; 117 /// Получить текущий путь FTP
; 118 void getFtpCurrentPathNew() {
getftpcurrentpathnew:
; 119     push_pop(hl) {
	push hl
; 120         do {
l_309:
; 121             delay5msI2C();
	call delay5msi2c
; 122             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 123             l = 38; //GET_FTP_DIR_NEW, // 38
	ld l, 38
; 124             h = 0;
	ld h, 0
; 125             sendCommand();
	call sendcommand
; 126             //
; 127             loadStringToHL(hl = FtpViewPath);
	ld hl, ftpviewpath
	call loadstringtohl
l_310:
; 128         } while ((a = parsePageBufferIsCheck) != 1);
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_309
	pop hl
	ret
; 129     }
; 130 }
; 131 
; 132 /// Загрузить данные (не больше 255) по адресу HL
; 133 /// вх. [HL] - Куда записывать результат
; 134 void loadStringToHL() {
loadstringtohl:
; 135     do {
l_312:
; 136         push_pop(hl) {
	push hl
; 137             // Получить новый буфер
; 138             delay5msI2C();
	call delay5msi2c
; 139             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 140             l = 34; //GET_NEXT_PAGE_BUFFER, // 34
	ld l, 34
; 141             h = 0;
	ld h, 0
; 142             sendCommand();
	call sendcommand
; 143             //
; 144             delay5msI2C();
	call delay5msi2c
; 145             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 146             l = 15;
	ld l, 15
; 147             readNewInBuffer(); //ESP_I2S_BUFFER
	call readnewinbuffer
	pop hl
; 148         }
; 149         // Parse ESP_I2S_BUFFER
; 150         parsePageBuffer();
	call parsepagebuffer
l_313:
; 151     } while ((a = parsePageBufferNext) != 0x5A);
	ld a, (parsepagebuffernext)
	cp 90
	jp nz, l_312
	ret
; 152 }
; 153 
; 154 /// Загрузить данные (не больше 255) по адресу HL
; 155 /// вх. [HL] - Куда записывать результат
; 156 void loadNewStringToHL() {
loadnewstringtohl:
; 157     do {
l_315:
; 158         push_pop(hl) {
	push hl
; 159             // Получить новый буфер
; 160             delay5msI2C();
	call delay5msi2c
; 161             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 162             l = 47; //GET_NEXT_PAGE_BUFFER_NEW, // 47
	ld l, 47
; 163             h = 0;
	ld h, 0
; 164             sendCommand();
	call sendcommand
; 165             //
; 166             delay5msI2C();
	call delay5msi2c
; 167             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 168             l = 15;
	ld l, 15
; 169             readNewInBuffer(); //ESP_I2S_BUFFER
	call readnewinbuffer
	pop hl
; 170         }
; 171         // Parse ESP_I2S_BUFFER
; 172         parsePageNewBuffer();
	call parsepagenewbuffer
; 173         // Если нет ошибок, то следующие данные
; 174         if ((a = parsePageBufferIsCheck) == 1) {
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_318
; 175             push_pop(hl) {
	push hl
; 176                 delay5msI2C();
	call delay5msi2c
; 177                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 178                 l = 48; //GET_NEXT_PAGE_BUFFER_NEW_INC, // 48
	ld l, 48
; 179                 h = 0;
	ld h, 0
; 180                 sendCommand();
	call sendcommand
	pop hl
l_318:
l_316:
; 181             }
; 182         }
; 183     } while ((a = parsePageBufferNext) != 0x5A);
	ld a, (parsepagebuffernext)
	cp 90
	jp nz, l_315
	ret
; 184 }
; 185 
; 186 /// Указать какой файл скачивать
; 187 void ftpFileDownloadA() {
ftpfiledownloada:
; 188     push_pop(de, hl) {
	push de
	push hl
; 189         de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 190         *de = a;
	ld (de), a
; 191         //
; 192         i2cWaitingForAccess();
	call i2cwaitingforaccess
; 193         //
; 194         l = 28; // FILE_DOWNLOAD
	ld l, 28
; 195         h = 1; // 1 байт
	ld h, 1
; 196         sendCommand();
	call sendcommand
	pop hl
	pop de
	ret
; 197     }
; 198 }
; 199 
; 200 /// Скачать указанный файл
; 201 void ftpFileDownloadNext() {
ftpfiledownloadnext:
; 202     push_pop(hl) {
	push hl
; 203         a = 0x01;
	ld a, 1
; 204         parseFtpFileLoadViewCheckSumState = a;
	ld (parseftpfileloadviewchecksumstat), a
; 205         a = 0;
	ld a, 0
; 206         NetError = a;
	ld (neterror), a
; 207         a = 10;
	ld a, 10
; 208         NetLoopCount = a;
	ld (netloopcount), a
; 209         do {
l_320:
; 210             // Если контрольная сумма верна просим следующий буфер
; 211             if ((a = parseFtpFileLoadViewCheckSumState) == 0x01) {
	ld a, (parseftpfileloadviewchecksumstat)
	cp 1
	jp nz, l_323
; 212                 a = 10;
	ld a, 10
; 213                 NetLoopCount = a;
	ld (netloopcount), a
; 214                 //--
; 215                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 216                 l = 29;
	ld l, 29
; 217                 h = 0;
	ld h, 0
; 218                 sendCommand();
	call sendcommand
	jp l_324
l_323:
; 219             } else {
; 220                 a = NetLoopCount;
	ld a, (netloopcount)
; 221                 a--;
	dec a
; 222                 NetLoopCount = a;
	ld (netloopcount), a
; 223                 if (a == 0) {
	or a
	jp nz, l_325
; 224                     a = 1;
	ld a, 1
; 225                     NetError = a;
	ld (neterror), a
l_325:
l_324:
; 226                 }
; 227             }
; 228             
; 229             if ((a = NetError) == 0) {
	ld a, (neterror)
	or a
	jp nz, l_327
; 230                 // Получить буфер
; 231                 //i2cWaitingForAccess();
; 232                 l = 30;
	ld l, 30
; 233                 h = 0;
	ld h, 0
; 234                 sendCommand();
	call sendcommand
; 235                 //
; 236                 //delay5msI2C();
; 237                 //i2cWaitingForAccess();
; 238                 l = 15;
	ld l, 15
; 239                 readNewInBuffer();
	call readnewinbuffer
; 240                 
; 241                 // Распарсить буфер и пррверить контрольную сумму
; 242                 ftpFileDownloadParse();
	call ftpfiledownloadparse
; 243                 if ((a = parseFtpFileLoadViewCheckSumState) == 0x01) {
	ld a, (parseftpfileloadviewchecksumstat)
	cp 1
	jp nz, l_329
; 244                     LoadViewShowProgressA(a = LoadViewProgress);
	ld a, (loadviewprogress)
	call loadviewshowprogressa
l_329:
	jp l_328
l_327:
; 245                 }
; 246             } else {
; 247                 // Error!!!!
; 248                 a = 0x5A;
	ld a, 90
; 249                 parseFtpFileLoadViewIsNextData = a;
	ld (parseftpfileloadviewisnextdata), a
l_328:
l_321:
; 250             }
; 251         } while ((a = parseFtpFileLoadViewIsNextData) != 0x5A);
	ld a, (parseftpfileloadviewisnextdata)
	cp 90
	jp nz, l_320
	pop hl
	ret
; 252     }
; 253 }
; 254 
; 255 /// Получить текущее имя сети
; 256 void getSSIDValue() {
getssidvalue:
; 257     push_pop(hl) {
	push hl
; 258         do {
l_331:
; 259             delay5msI2C();
	call delay5msi2c
; 260             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 261             l = 6;
	ld l, 6
; 262             h = 0;
	ld h, 0
; 263             sendCommand();
	call sendcommand
; 264             //
; 265             loadStringToHL(hl = WifiStateViewSsidVal);
	ld hl, wifistateviewssidval
	call loadstringtohl
l_332:
; 266         } while ((a = parsePageBufferIsCheck) != 1);
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_331
	pop hl
	ret
; 267     }
; 268 }
; 269 
; 270 /// Получить IP_Address
; 271 void getSSIDIPAddress() {
getssidipaddress:
; 272     push_pop(hl) {
	push hl
; 273         do {
l_334:
; 274             delay5msI2C();
	call delay5msi2c
; 275             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 276             l = 12;
	ld l, 12
; 277             h = 0;
	ld h, 0
; 278             sendCommand();
	call sendcommand
; 279             //
; 280             loadStringToHL(hl = WifiStateViewIpVal);
	ld hl, wifistateviewipval
	call loadstringtohl
l_335:
; 281         } while ((a = parsePageBufferIsCheck) != 1);
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_334
	pop hl
	ret
; 282     }
; 283 }
; 284 
; 285 /// Получить WiFI пароль
; 286 void getSSIDPassword() {
getssidpassword:
; 287     push_pop(hl) {
	push hl
; 288         do {
l_337:
; 289             delay5msI2C();
	call delay5msi2c
; 290             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 291             l = 40; // GET_SSID_PASSWORD_NEW, // 40
	ld l, 40
; 292             h = 0;
	ld h, 0
; 293             sendCommand();
	call sendcommand
; 294             //
; 295             loadStringToHL(hl = WifiStateViewPassVal);
	ld hl, wifistateviewpassval
	call loadstringtohl
l_338:
; 296         } while ((a = parsePageBufferIsCheck) != 1);
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_337
	pop hl
	ret
; 297     }
; 298 }
; 299 
; 300 /// Запросить обновление списка сетей
; 301 void needUpdateSSIDList() {
needupdatessidlist:
; 302     push_pop(hl) {
	push hl
; 303         delay5msI2C();
	call delay5msi2c
; 304         i2cWaitingForAccess();
	call i2cwaitingforaccess
; 305         l = 4;
	ld l, 4
; 306         h = 0;
	ld h, 0
; 307         sendCommand();
	call sendcommand
	pop hl
	ret
; 308     }
; 309 }
; 310 
; 311 /// Получить список сетей
; 312 void getSsidList() {
getssidlist:
; 313     push_pop(hl) {
	push hl
; 314         do {
l_340:
; 315             // Получаем данные пл пакету
; 316             do {
l_343:
; 317                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 318                 l = 42; //GET_SSID_NEW_LIST_NEXT, // 42
	ld l, 42
; 319                 h = 0;
	ld h, 0
; 320                 sendCommand();
	call sendcommand
; 321                 //
; 322                 //delay5msI2C();
; 323                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 324                 l = 6;
	ld l, 6
; 325                 readNewInBuffer();
	call readnewinbuffer
; 326                 SsidListNextParser();
	call ssidlistnextparser
l_344:
; 327             } while ((a = SsidListNextParserCheckSumState) == 0);
	ld a, (ssidlistnextparserchecksumstate)
	or a
	jp z, l_343
; 328             // Получаем строку с именем сети
; 329             loadNewStringToHL(hl = SsidListNextParserPoint);
	ld hl, (ssidlistnextparserpoint)
	call loadnewstringtohl
; 330             // Просим следующий
; 331             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 332             l = 46; //GET_SSID_NEW_LIST_Next_Inc, // 46
	ld l, 46
; 333             h = 0;
	ld h, 0
; 334             sendCommand();
	call sendcommand
l_341:
; 335         } while ((a = SsidListNextParserNext) != 0x5A);
	ld a, (ssidlistnextparsernext)
	cp 90
	jp nz, l_340
	pop hl
	ret
; 336     }
; 337 }
; 338 
; 339 /// Получить статус WiFI TODO пепеделать!!!
; 340 void getWifiState() {
getwifistate:
; 341     push_pop(hl) {
	push hl
; 342         push_pop(de) {
	push de
; 343             push_pop(bc) {
	push bc
; 344                 delay5msI2C();
	call delay5msi2c
; 345                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 346                 l = 11; // STATE_SSID, //11
	ld l, 11
; 347                 h = 0;
	ld h, 0
; 348                 sendCommand();
	call sendcommand
; 349                 //
; 350                 delay5msI2C();
	call delay5msi2c
; 351                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 352                 l = 3;
	ld l, 3
; 353                 readNewInBuffer();
	call readnewinbuffer
; 354                 //
; 355                 a = WifiStateViewSSIDIsConnected;
	ld a, (wifistateviewssidisconnected)
; 356                 h = a;
	ld h, a
; 357                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 358                 a = *de;
	ld a, (de)
; 359                 a &= 0x01;
	and 1
; 360                 WifiStateViewSSIDIsConnected = a;
	ld (wifistateviewssidisconnected), a
; 361                 if(a != h){
	cp h
	jp z, l_346
; 362                     a = 0x01;
	ld a, 1
; 363                     WiFiNetStateChange = a;
	ld (wifinetstatechange), a
l_346:
	pop bc
	pop de
	pop hl
	ret
; 364                 }
; 365             }
; 366         }
; 367     }
; 368 }
; 369 
; 370 /// Получить MAC_Address
; 371 void getSSIDMacAddress() {
getssidmacaddress:
; 372     push_pop(hl) {
	push hl
; 373         do {
l_348:
; 374             delay5msI2C();
	call delay5msi2c
; 375             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 376             l = 13;
	ld l, 13
; 377             h = 0;
	ld h, 0
; 378             sendCommand();
	call sendcommand
; 379             //
; 380             loadStringToHL(hl = WifiStateViewMacVal);
	ld hl, wifistateviewmacval
	call loadstringtohl
l_349:
; 381         } while ((a = parsePageBufferIsCheck) != 1);
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_348
	pop hl
	ret
; 382     }
; 383 }
; 384 
; 385 /// Получить статус FTP TODO пепеделать!!!
; 386 void getFtpState() {
getftpstate:
; 387     push_pop(hl) {
	push hl
; 388         push_pop(de) {
	push de
; 389             push_pop(bc) {
	push bc
; 390                 delay5msI2C();
	call delay5msi2c
; 391                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 392                 l = 24;
	ld l, 24
; 393                 h = 0;
	ld h, 0
; 394                 sendCommand();
	call sendcommand
; 395                 //
; 396                 delay5msI2C();
	call delay5msi2c
; 397                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 398                 l = 4;
	ld l, 4
; 399                 readNewInBuffer();
	call readnewinbuffer
; 400                 //
; 401                 a = FtpStateViewStatus;
	ld a, (ftpstateviewstatus)
; 402                 h = a;
	ld h, a
; 403                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 404                 a = *de;
	ld a, (de)
; 405                 a &= 0x01;
	and 1
; 406                 FtpStateViewStatus = a;
	ld (ftpstateviewstatus), a
; 407                 if(a != h){
	cp h
	jp z, l_351
; 408                     a = 0x01;
	ld a, 1
; 409                     FtpNetStateChange = a;
	ld (ftpnetstatechange), a
l_351:
	pop bc
	pop de
	pop hl
	ret
; 410                 }
; 411             }
; 412         }
; 413     }
; 414 }
; 415 
; 416 /// Подключиться в WiFi
; 417 void needSsidConnect() {
needssidconnect:
; 418     push_pop(hl) {
	push hl
; 419         delay5msI2C();
	call delay5msi2c
; 420         i2cWaitingForAccess();
	call i2cwaitingforaccess
; 421         l = 10;
	ld l, 10
; 422         h = 0;
	ld h, 0
; 423         sendCommand();
	call sendcommand
	pop hl
	ret
; 424     }
; 425 }
; 426 
; 427 /// Подключиться в FTP
; 428 void needFtpConnect() {
needftpconnect:
; 429     push_pop(hl) {
	push hl
; 430         delay5msI2C();
	call delay5msi2c
; 431         i2cWaitingForAccess();
	call i2cwaitingforaccess
; 432         l = 23;
	ld l, 23
; 433         h = 0;
	ld h, 0
; 434         sendCommand();
	call sendcommand
	pop hl
	ret
; 435     }
; 436 }
; 437 
; 438 /// Получить FTP URL
; 439 void getFTPUrl() {
getftpurl:
; 440     push_pop(hl) {
	push hl
; 441         do {
l_353:
; 442             delay5msI2C();
	call delay5msi2c
; 443             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 444             l = 39; //GET_FTPURL_NEW, // 39
	ld l, 39
; 445             h = 0;
	ld h, 0
; 446             sendCommand();
	call sendcommand
; 447             //
; 448             loadStringToHL(hl = FtpStateViewIpValue);
	ld hl, ftpstateviewipvalue
	call loadstringtohl
l_354:
; 449         } while ((a = parsePageBufferIsCheck) != 1);
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_353
	pop hl
	ret
; 450     }
; 451 }
; 452 
; 453 /// Получить FTP HomeDir
; 454 void getFTPHomeDir() {
getftphomedir:
; 455     push_pop(hl) {
	push hl
; 456         do {
l_356:
; 457             delay5msI2C();
	call delay5msi2c
; 458             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 459             l = 41; //GET_FTP_HOMEDIR_NEW, // 41
	ld l, 41
; 460             h = 0;
	ld h, 0
; 461             sendCommand();
	call sendcommand
; 462             //
; 463             loadStringToHL(hl = FtpSettingsViewValueHomeDir);
	ld hl, ftpsettingsviewvaluehomedir
	call loadstringtohl
l_357:
; 464         } while ((a = parsePageBufferIsCheck) != 1);
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_356
	pop hl
	ret
; 465     }
; 466 }
; 467 
; 468 /// Получить FTP Port
; 469 void getFTPPort() {
getftpport:
; 470     push_pop(hl) {
	push hl
; 471         do {
l_359:
; 472             delay5msI2C();
	call delay5msi2c
; 473             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 474             l = 43; //GET_FTP_Port_NEW, // 43
	ld l, 43
; 475             h = 0;
	ld h, 0
; 476             sendCommand();
	call sendcommand
; 477             //
; 478             loadStringToHL(hl = FtpSettingsViewValuePort);
	ld hl, ftpsettingsviewvalueport
	call loadstringtohl
l_360:
; 479         } while ((a = parsePageBufferIsCheck) != 1);
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_359
	pop hl
	ret
; 480     }
; 481 }
; 482 
; 483 /// Получить FTP User
; 484 void getFTPUser() {
getftpuser:
; 485     push_pop(hl) {
	push hl
; 486         do {
l_362:
; 487             delay5msI2C();
	call delay5msi2c
; 488             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 489             l = 44; //GET_FTP_User_NEW, // 44
	ld l, 44
; 490             h = 0;
	ld h, 0
; 491             sendCommand();
	call sendcommand
; 492             //
; 493             loadStringToHL(hl = FtpSettingsViewValueUser);
	ld hl, ftpsettingsviewvalueuser
	call loadstringtohl
l_363:
; 494         } while ((a = parsePageBufferIsCheck) != 1);
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_362
	pop hl
	ret
; 495     }
; 496 }
; 497 
; 498 /// Получить FTP Password
; 499 void getFTPPassword() {
getftppassword:
; 500     push_pop(hl) {
	push hl
; 501         do {
l_365:
; 502             delay5msI2C();
	call delay5msi2c
; 503             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 504             l = 45; //GET_FTP_Password_NEW, // 45
	ld l, 45
; 505             h = 0;
	ld h, 0
; 506             sendCommand();
	call sendcommand
; 507             //
; 508             loadStringToHL(hl = FtpSettingsViewValuePass);
	ld hl, ftpsettingsviewvaluepass
	call loadstringtohl
l_366:
; 509         } while ((a = parsePageBufferIsCheck) != 1);
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_365
	pop hl
	ret
; 510     }
; 511 }
; 512 
; 513 /// Установить имя сети по номеру в списке
; 514 /// вх. [A] - номер сети
; 515 void setSSIDNumberA() {
setssidnumbera:
; 516     push_pop(de) {
	push de
; 517         push_pop(hl) {
	push hl
; 518             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 519             *de = a;
	ld (de), a
; 520             //
; 521             delay5msI2C();
	call delay5msi2c
; 522             i2cWaitingForAccess();
	call i2cwaitingforaccess
; 523             //
; 524             l = 7; // SET_SSID
	ld l, 7
; 525             h = 1; // 1 байт
	ld h, 1
; 526             sendCommand();
	call sendcommand
	pop hl
	pop de
	ret
; 527         }
; 528     }
; 529 }
; 530 
; 531 /// Отправка 16 байт буфера из HL на плату
; 532 /// A - код операции
; 533 /// ------ Структура ---------------
; 534 /// 1 byte : Action
; 535 /// 2 byte : Next (0x01 = Next; 0x5A - Stop)
; 536 /// 3..10 bytes : Data
; 537 /// 11 byte : SUM
; 538 void sendHLToA() {
sendhltoa:
; 539     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 540         // Calc
; 541         sendHLActionKey = a;
	ld (sendhlactionkey), a
; 542         sendHLPoint = hl;
	ld (sendhlpoint), hl
; 543         // Send
; 544         c = 0;
	ld c, 0
; 545         do {
l_368:
; 546             hl = sendHLPoint;
	ld hl, (sendhlpoint)
; 547             if ((a = c) == 1) {
	ld a, c
	cp 1
	jp nz, l_371
; 548                 de = 8;
	ld de, 8
; 549                 hl += de;
	add hl, de
l_371:
; 550             }
; 551             // -- Create buffer
; 552             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 553             // Action
; 554             a = sendHLActionKey;
	ld a, (sendhlactionkey)
; 555             *de = a;
	ld (de), a
; 556             de++;
	inc de
; 557             // Next
; 558             if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_373
; 559                 a = 0x01;
	ld a, 1
	jp l_374
l_373:
; 560             } else {
; 561                 a = 0x5A;
	ld a, 90
l_374:
; 562             }
; 563             *de = a;
	ld (de), a
; 564             de++;
	inc de
; 565             // Data
; 566             b = 8;
	ld b, 8
; 567             do {
l_375:
; 568                 a = *hl;
	ld a, (hl)
; 569                 *de = a;
	ld (de), a
; 570                 de++;
	inc de
; 571                 hl++;
	inc hl
; 572                 b--;
	dec b
l_376:
; 573             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_375
; 574             // SUM
; 575             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 576             b = 10;
	ld b, 10
; 577             h = 0;
	ld h, 0
; 578             do {
l_378:
; 579                 a = *de;
	ld a, (de)
; 580                 a += h;
	add h
; 581                 h = a;
	ld h, a
; 582                 de++;
	inc de
; 583                 b--;
	dec b
l_379:
; 584             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_378
; 585             a = h;
	ld a, h
; 586             *de = a;
	ld (de), a
; 587             // -- Send
; 588             push_pop(hl) {
	push hl
; 589                 i2cWaitingForAccess();
	call i2cwaitingforaccess
; 590                 l = 49; // SET_STR16_FOR_KEY_PAGE, // 49
	ld l, 49
; 591                 h = 11;
	ld h, 11
; 592                 sendCommand();
	call sendcommand
	pop hl
; 593             }
; 594             // -- Get status
; 595             push_pop(hl) {
	push hl
; 596                 // Получаем ответ
; 597                 do {
l_381:
; 598                     i2cWaitingForAccess();
	call i2cwaitingforaccess
; 599                     l = 50; // GET_STR16_FOR_KEY_PAGE_STATE, // 50
	ld l, 50
; 600                     h = 0;
	ld h, 0
; 601                     sendCommand();
	call sendcommand
; 602                     //
; 603                     i2cWaitingForAccess();
	call i2cwaitingforaccess
; 604                     l = 4;
	ld l, 4
; 605                     readNewInBuffer();
	call readnewinbuffer
; 606                     sendHLToAParser();
	call sendhltoaparser
l_382:
; 607                 } while ((a = sendHLToAParserCheckSumState) == 0);
	ld a, (sendhltoaparserchecksumstate)
	or a
	jp z, l_381
; 608                 // Если ОК , то следующая операция
; 609                 if ((a = sendHLToAParserIsOk) == 1) {
	ld a, (sendhltoaparserisok)
	cp 1
	jp nz, l_384
; 610                     c++;
	inc c
l_384:
	pop hl
l_369:
; 611                 }
; 612             }
; 613             // --
; 614         } while ((a = c) < 2);
	ld a, c
	cp 2
	jp c, l_368
	pop hl
	pop de
	pop bc
	ret
; 615     }
; 616 }
; 617 
; 618 /// Установить WiFI пароль
; 619 void setSSIDPassword() {
setssidpassword:
; 620     push_pop(hl) {
	push hl
; 621         hl = WifiStateViewPassVal;
	ld hl, wifistateviewpassval
; 622         sendHLToA(a = 0); // Action_SET_SSID_PASSWORD = 0, // 0
	ld a, 0
	call sendhltoa
	pop hl
	ret
; 623     }
; 624 }
; 625 
; 626 /// Установить FTP HomeDir
; 627 void setFtpHomeDir() {
setftphomedir:
; 628     push_pop(hl) {
	push hl
; 629         hl = FtpSettingsViewValueHomeDir;
	ld hl, ftpsettingsviewvaluehomedir
; 630         sendHLToA(a = 2); // Action_SET_FTP_HomeDir, // 2
	ld a, 2
	call sendhltoa
	pop hl
	ret
; 631     }
; 632 }
; 633 
; 634 /// Установить FTP Password
; 635 void setFtpPassword() {
setftppassword:
; 636     push_pop(hl) {
	push hl
; 637         hl = FtpSettingsViewValuePass;
	ld hl, ftpsettingsviewvaluepass
; 638         sendHLToA(a = 1); // Action_SET_FTP_PASSWORD, // 1
	ld a, 1
	call sendhltoa
	pop hl
	ret
; 639     }
; 640 }
; 641 
; 642 /// Установить FTP User
; 643 void setFtpUser() {
setftpuser:
; 644     push_pop(hl) {
	push hl
; 645         hl = FtpSettingsViewValueUser;
	ld hl, ftpsettingsviewvalueuser
; 646         sendHLToA(a = 3); // Action_SET_FTP_ftpUser, // 3
	ld a, 3
	call sendhltoa
	pop hl
	ret
; 647     }
; 648 }
; 649 
; 650 /// Установить FTP ServerUrl
; 651 void setFtpServerUrl() {
setftpserverurl:
; 652     push_pop(hl) {
	push hl
; 653         hl = FtpStateViewIpValue;
	ld hl, ftpstateviewipvalue
; 654         sendHLToA(a = 4); // Action_SET_FTP_ServerUrl, // 4
	ld a, 4
	call sendhltoa
	pop hl
	ret
; 655     }
; 656 }
; 657 
; 658 /// Установить FTP Port
; 659 void setFtpPort() {
setftpport:
; 660     push_pop(hl) {
	push hl
; 661         hl = FtpSettingsViewValuePort;
	ld hl, ftpsettingsviewvalueport
; 662         sendHLToA(a = 5); // Action_SET_FTP_Port, // 5
	ld a, 5
	call sendhltoa
	pop hl
	ret
; 663     }
; 664 }
; 665 
; 666 /// Получить все статусы
; 667 void getAllStatus() {
getallstatus:
; 668     //-- Lock
; 669     if ((a = NetIsLock) == 1) {
	ld a, (netislock)
	cp 1
	jp nz, l_386
; 670         return;
	ret
l_386:
; 671     }
; 672     a = 1;
	ld a, 1
; 673     NetIsLock = a;
	ld (netislock), a
; 674     //--
; 675     push_pop(hl) {
	push hl
; 676         a = 10;
	ld a, 10
; 677         NetLoopCount = a;
	ld (netloopcount), a
; 678         do {
l_388:
; 679             l = 51; //GET_ALL_STATE, // 51
	ld l, 51
; 680             h = 0;
	ld h, 0
; 681             sendCommand();
	call sendcommand
; 682             //
; 683             l = 5;
	ld l, 5
; 684             readNewInBuffer();
	call readnewinbuffer
; 685             getAllStatusParser();
	call getallstatusparser
; 686             //-- MAX LOOP
; 687             a = NetLoopCount;
	ld a, (netloopcount)
; 688             a--;
	dec a
; 689             NetLoopCount = a;
	ld (netloopcount), a
; 690             if (a == 0) {
	or a
	jp nz, l_391
; 691                 a = 1;
	ld a, 1
; 692                 allStatusParserCheckSumState = a;
	ld (allstatusparserchecksumstate), a
l_391:
l_389:
; 693             }
; 694             //--
; 695         } while ((a = allStatusParserCheckSumState) == 0);
	ld a, (allstatusparserchecksumstate)
	or a
	jp z, l_388
	pop hl
; 696     }
; 697     //-- Lock
; 698     a = 0;
	ld a, 0
; 699     NetIsLock = a;
	ld (netislock), a
	ret
; 700     //--
; 701 }
; 702 
; 703 /// Перейти на домашную папку
; 704 void setFtpGoToHomeDir() {
setftpgotohomedir:
; 705     push_pop(hl) {
	push hl
; 706         l = 52; //SET_FTP_GO_HOME_DIR, // 52
	ld l, 52
; 707         h = 0;
	ld h, 0
; 708         sendCommand();
	call sendcommand
	pop hl
	ret
; 709     }
; 710 }
; 711 
; 712 uint8_t NetIsLock = 0;
netislock:
	db 0
; 715 uint8_t NetError = 0;
neterror:
	db 0
; 716 uint8_t NetLoopCount = 0;
netloopcount:
	db 0
; 718 uint16_t sendHLPoint = 0x0000;
sendhlpoint:
	dw 0
; 719 uint8_t sendHLActionKey = 0;
sendhlactionkey:
	db 0
; 12 void checkSumPageBuffer() {
checksumpagebuffer:
; 13     push_pop(de) {
	push de
; 14         push_pop(bc) {
	push bc
; 15             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 16             c = 0; // c == Check SUM
	ld c, 0
; 17             // pageNum
; 18             a = *de;
	ld a, (de)
; 19             a += c;
	add c
; 20             c = a;
	ld c, a
; 21             de++;
	inc de
; 22             // pageSize
; 23             a = *de;
	ld a, (de)
; 24             b = a;
	ld b, a
; 25             a += c;
	add c
; 26             c = a;
	ld c, a
; 27             de++;
	inc de
; 28             // next
; 29             a = *de;
	ld a, (de)
; 30             a += c;
	add c
; 31             c = a;
	ld c, a
; 32             de++;
	inc de
; 33             // buffer
; 34             do {
l_393:
; 35                 a = *de;
	ld a, (de)
; 36                 a += c;
	add c
; 37                 c = a;
	ld c, a
; 38                 de++;
	inc de
; 39                 b--;
	dec b
l_394:
; 40             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_393
; 41             // sum
; 42             a = *de;
	ld a, (de)
; 43             if (a == c) {
	cp c
	jp nz, l_396
; 44                 a = 1;
	ld a, 1
; 45                 parsePageBufferIsCheck = a;
	ld (parsepagebufferischeck), a
	jp l_397
l_396:
; 46             } else {
; 47                 a = 0;
	ld a, 0
; 48                 parsePageBufferIsCheck = a;
	ld (parsepagebufferischeck), a
l_397:
	pop bc
	pop de
	ret
; 49             }
; 50         }
; 51     }
; 52 }
; 53 
; 54 /// Парсинг буфера от  API метода GET_NEXT_PAGE_BUFFER
; 55 /// вх. [HL] - Куда записывать результат
; 56 /// ESP_I2S_BUFFER - буфер где лежат полученные данные
; 57 void parsePageBuffer() {
parsepagebuffer:
; 58     checkSumPageBuffer();
	call checksumpagebuffer
; 59     if ((a = parsePageBufferIsCheck) == 1) {
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_398
; 60         push_pop(de) {
	push de
; 61             push_pop(bc) {
	push bc
; 62                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 63                 // pageNum
; 64                 de++;
	inc de
; 65                 // pageSize
; 66                 a = *de;
	ld a, (de)
; 67                 b = a;
	ld b, a
; 68                 de++;
	inc de
; 69                 // next
; 70                 a = *de;
	ld a, (de)
; 71                 parsePageBufferNext = a;
	ld (parsepagebuffernext), a
; 72                 de++;
	inc de
; 73                 // buffer
; 74                 push_pop(de) {
	push de
; 75                     do {
l_400:
; 76                         a = *de;
	ld a, (de)
; 77                         *hl = a;
	ld (hl), a
; 78                         de++;
	inc de
; 79                         hl++;
	inc hl
; 80                         b--;
	dec b
l_401:
; 81                     } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_400
	pop de
	pop bc
	pop de
	jp l_399
l_398:
; 82                 }
; 83             }
; 84         }
; 85     } else {
; 86         a = 0x5A;
	ld a, 90
; 87         parsePageBufferNext = a;
	ld (parsepagebuffernext), a
l_399:
	ret
; 88     }
; 89 }
; 90 
; 91 /// Парсинг буфера от  API метода GET_NEXT_PAGE_BUFFER
; 92 /// вх. [HL] - Куда записывать результат
; 93 /// ESP_I2S_BUFFER - буфер где лежат полученные данные
; 94 void parsePageNewBuffer() {
parsepagenewbuffer:
; 95     checkSumPageBuffer();
	call checksumpagebuffer
; 96     if ((a = parsePageBufferIsCheck) == 1) {
	ld a, (parsepagebufferischeck)
	cp 1
	jp nz, l_403
; 97         push_pop(de) {
	push de
; 98             push_pop(bc) {
	push bc
; 99                 de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 100                 // pageNum
; 101                 de++;
	inc de
; 102                 // pageSize
; 103                 a = *de;
	ld a, (de)
; 104                 b = a;
	ld b, a
; 105                 de++;
	inc de
; 106                 // next
; 107                 a = *de;
	ld a, (de)
; 108                 parsePageBufferNext = a;
	ld (parsepagebuffernext), a
; 109                 de++;
	inc de
; 110                 //-- Next or 0x01 or 0x5A
; 111                 parsePageNewBufferOr01Or5A();
	call parsepagenewbufferor01or5a
; 112                 if (a == 1) {
	cp 1
	jp nz, l_405
; 113                     // buffer
; 114                     push_pop(de) {
	push de
; 115                         do {
l_407:
; 116                             a = *de;
	ld a, (de)
; 117                             *hl = a;
	ld (hl), a
; 118                             de++;
	inc de
; 119                             hl++;
	inc hl
; 120                             b--;
	dec b
l_408:
; 121                         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_407
	pop de
	jp l_406
l_405:
; 122                     }
; 123                 } else {
; 124                     a = 0;
	ld a, 0
; 125                     parsePageBufferNext = a;
	ld (parsepagebuffernext), a
; 126                     parsePageBufferIsCheck = a;
	ld (parsepagebufferischeck), a
l_406:
	pop bc
	pop de
l_403:
	ret
; 127                 }
; 128             }
; 129         }
; 130     }
; 131 }
; 132 
; 133 void parsePageNewBufferOr01Or5A() {
parsepagenewbufferor01or5a:
; 134     push_pop(bc) {
	push bc
; 135         if ((a = parsePageBufferNext) == 0x01) {
	ld a, (parsepagebuffernext)
	cp 1
	jp nz, l_410
; 136             b = 1;
	ld b, 1
	jp l_411
l_410:
; 137         } else if ((a = parsePageBufferNext) == 0x5A) {
	ld a, (parsepagebuffernext)
	cp 90
	jp nz, l_412
; 138             b = 1;
	ld b, 1
	jp l_413
l_412:
; 139         } else {
; 140             b = 0;
	ld b, 0
l_413:
l_411:
; 141         }
; 142         a = b;
	ld a, b
	pop bc
	ret
; 143     }
; 144 }
; 145 
; 146 /// 1 byte - dnpppppp (p - pos, n - next, d - dir)
; 147 /// 2 byte - Size
; 148 /// 3 byte - Date (GGGGGGGG GGGGMMMM 000DDDDD)
; 149 /// 8 byte - Name
; 150 /// 1 byte - CheckSum
; 151 /// TO ->  'G', 'A', 'M', 'E', 'S', ' ', ' ', ' ', 0x00, 0x00, 0x01, ' ', ' ', 0x7E, 0x95, 0x1F
; 152 void parseFtpListBuffer() {
parseftplistbuffer:
; 153     checkSumFtpListBuffer();
	call checksumftplistbuffer
; 154     if ((a = parseFtpListBufferIsCheck) == 1) {
	ld a, (parseftplistbufferischeck)
	cp 1
	jp nz, l_414
; 155         push_pop(de, hl, bc) {
	push de
	push hl
	push bc
; 156             de = ESP_I2S_BUFFER; // Откуда
	ld de, esp_i2s_buffer
; 157             hl = FtpViewFilesList;     // Куда
	ld hl, ftpviewfileslist
; 158             //Pos (Pos + Next + isDir)
; 159             a = *de;
	ld a, (de)
; 160             a &= 0x3F;
	and 63
; 161             FtpViewFilesListCount = a; // Сохраним значение кол-ва файлов
	ld (ftpviewfileslistcount), a
; 162             b = 0;
	ld b, 0
; 163             carry_rotate_left(a, 4);
	rla
	rla
	rla
	rla
; 164             if (flag_c) { // Если переполняние младшего разряда, инкремент старшего
	jp nc, l_416
; 165                 b++;
	inc b
l_416:
; 166             }
; 167             c = a;
	ld c, a
; 168             hl += bc; // ftpDirList + смещение
	add hl, bc
; 169             //Pos -> Next
; 170             a = *de;
	ld a, (de)
; 171             a &= 0x40;
	and 64
; 172             if (a == 0x40) {
	cp 64
	jp nz, l_418
; 173                 a = 0x01;
	ld a, 1
; 174                 parseFtpListBufferNext = a;
	ld (parseftplistbuffernext), a
	jp l_419
l_418:
; 175             } else {
; 176                 a = 0x5A;
	ld a, 90
; 177                 parseFtpListBufferNext = a;
	ld (parseftplistbuffernext), a
l_419:
; 178             }
; 179             //Pos -> isDir
; 180             a = *de;
	ld a, (de)
; 181             a &= 0x80;
	and 128
; 182             if (a == 0x80) {
	cp 128
	jp nz, l_420
; 183                 a = 1;
	ld a, 1
	jp l_421
l_420:
; 184             } else {
; 185                 a = 0;
	ld a, 0
l_421:
; 186             }
; 187             push_pop(hl, de) {
	push hl
	push de
; 188                 de = 10;
	ld de, 10
; 189                 hl += de;
	add hl, de
; 190                 *hl = a;
	ld (hl), a
	pop de
	pop hl
; 191             }
; 192             // Size
; 193             push_pop(hl) {
	push hl
; 194                 push_pop(de) {
	push de
; 195                     de = 8;
	ld de, 8
; 196                     hl += de;
	add hl, de
	pop de
; 197                 }
; 198                 // -> size
; 199                 de++;
	inc de
; 200                 a = *de;
	ld a, (de)
; 201                 *hl = a;
	ld (hl), a
; 202                 de++;
	inc de
; 203                 hl++;
	inc hl
; 204                 a = *de;
	ld a, (de)
; 205                 *hl = a;
	ld (hl), a
	pop hl
; 206             }
; 207             // Date (3 byte)
; 208             push_pop(hl) {
	push hl
; 209                 push_pop(de) {
	push de
; 210                     de = 13;
	ld de, 13
; 211                     hl += de;
	add hl, de
	pop de
; 212                 }
; 213                 de++;
	inc de
; 214                 // 1
; 215                 a = *de;
	ld a, (de)
; 216                 *hl = a;
	ld (hl), a
; 217                 de++;
	inc de
; 218                 hl++;
	inc hl
; 219                 // 2
; 220                 a = *de;
	ld a, (de)
; 221                 *hl = a;
	ld (hl), a
; 222                 de++;
	inc de
; 223                 hl++;
	inc hl
; 224                 // 3
; 225                 a = *de;
	ld a, (de)
; 226                 *hl = a;
	ld (hl), a
; 227                 de++;
	inc de
; 228                 hl++;
	inc hl
	pop hl
; 229             }
; 230             // Name
; 231             b = 8;
	ld b, 8
; 232             do {
l_422:
; 233                 a = *de;
	ld a, (de)
; 234                 *hl = a;
	ld (hl), a
; 235                 de++;
	inc de
; 236                 hl++;
	inc hl
; 237                 b--;
	dec b
l_423:
; 238             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_422
	pop bc
	pop hl
	pop de
	jp l_415
l_414:
; 239         }
; 240     } else {
; 241         a = 0xFF; // ERROR
	ld a, 255
; 242         parseFtpListBufferNext = a;
	ld (parseftplistbuffernext), a
l_415:
	ret
; 243     }
; 244 }
; 245 
; 246 void checkSumFtpListBuffer() {
checksumftplistbuffer:
; 247     push_pop(de, bc) {
	push de
	push bc
; 248         de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 249         c = 0;
	ld c, 0
; 250         b = 14;
	ld b, 14
; 251         do {
l_425:
; 252             a = *de;
	ld a, (de)
; 253             a += c;
	add c
; 254             c = a;
	ld c, a
; 255             de++;
	inc de
; 256             b--;
	dec b
l_426:
; 257         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_425
; 258         // SUM
; 259         a = *de;
	ld a, (de)
; 260         if (a == c) {
	cp c
	jp nz, l_428
; 261             a = 1;
	ld a, 1
; 262             parseFtpListBufferIsCheck = a;
	ld (parseftplistbufferischeck), a
	jp l_429
l_428:
; 263         } else {
; 264             a = 0;
	ld a, 0
; 265             parseFtpListBufferIsCheck = a;
	ld (parseftplistbufferischeck), a
l_429:
	pop bc
	pop de
	ret
; 266         }
; 267     }
; 268 }
; 269 
; 270 /// Парсинг пакета с данными скачиваемого файла
; 271 void ftpFileDownloadParse() {
ftpfiledownloadparse:
; 272     checkSumFtpFileDownload();
	call checksumftpfiledownload
; 273     if ((a = parseFtpFileLoadViewCheckSumState) == 1) {
	ld a, (parseftpfileloadviewchecksumstat)
	cp 1
	jp nz, l_430
; 274         push_pop(de) {
	push de
; 275             push_pop(hl) {
	push hl
; 276                 push_pop(bc) {
	push bc
; 277                     de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 278                     // -- SIZE
; 279                     a = *de;
	ld a, (de)
; 280                     ftpFileDownloadParseSizePackA();
	call ftpfiledownloadparsesizepacka
; 281                     de++;
	inc de
; 282                     // -- ADDRESS
; 283                     a = *de;
	ld a, (de)
; 284                     l = a;
	ld l, a
; 285                     de++;
	inc de
; 286                     a = *de;
	ld a, (de)
; 287                     h = a;
	ld h, a
; 288                     ftpFileLoadCurrentPos = hl;
	ld (ftpfileloadcurrentpos), hl
; 289                     de++;
	inc de
; 290                     // -- PROGRESS AND NEXT
; 291                     a = *de;
	ld a, (de)
; 292                     ftpFileDownloadParseProgressAndNextA();
	call ftpfiledownloadparseprogressandn
; 293                     de++;
	inc de
; 294                     // -- DATA
; 295                     // Если контрольная сумма совпала и есть статус что данные есть - пишем на диск
; 296                     if ((a = parseFtpFileLoadViewIsNextData) == 0x01) {
	ld a, (parseftpfileloadviewisnextdata)
	cp 1
	jp nz, l_432
; 297                         ftpFileDownloadCalkDiskPosToHL();
	call ftpfiledownloadcalkdiskpostohl
; 298                         a = ftpFileDownloadDataSize;
	ld a, (ftpfiledownloaddatasize)
; 299                         b = a;
	ld b, a
; 300                         do {
l_434:
; 301                             a = *de;
	ld a, (de)
; 302                             ordos_wdisk();
	call ordos_wdisk
; 303                             de++;
	inc de
; 304                             hl++;
	inc hl
; 305                             b--;
	dec b
l_435:
; 306                         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_434
; 307                         ftpFileDownloadEnd = hl;
	ld (ftpfiledownloadend), hl
l_432:
; 308                     }
; 309                     // Если контрольная сумма совпала и статус что данные закончились - закрываем файл
; 310                     if ((a = parseFtpFileLoadViewIsNextData) == 0x5A) {
	ld a, (parseftpfileloadviewisnextdata)
	cp 90
	jp nz, l_437
; 311                         hl = ftpFileDownloadEnd;
	ld hl, (ftpfiledownloadend)
; 312                         ordos_stop();
	call ordos_stop
l_437:
	pop bc
	pop hl
	pop de
	jp l_431
l_430:
; 313                     }
; 314                 }
; 315             }
; 316         }
; 317     } else {
; 318         a = 0xFF;
	ld a, 255
; 319         parseFtpFileLoadViewIsNextData = a;
	ld (parseftpfileloadviewisnextdata), a
l_431:
	ret
; 320     }
; 321 }
; 322 
; 323 /// Подсчет контрольной суммы
; 324 void checkSumFtpFileDownload() {
checksumftpfiledownload:
; 325     push_pop(de) {
	push de
; 326         push_pop(bc) {
	push bc
; 327             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 328             a = *de;
	ld a, (de)
; 329             ftpFileDownloadParseSizePackA();
	call ftpfiledownloadparsesizepacka
; 330             a = ftpFileDownloadPropertySize;
	ld a, (ftpfiledownloadpropertysize)
; 331             b = a;
	ld b, a
; 332             a = ftpFileDownloadDataSize;
	ld a, (ftpfiledownloaddatasize)
; 333             a += b;
	add b
; 334             b = a;
	ld b, a
; 335             //
; 336             c = 0;
	ld c, 0
; 337             do {
l_439:
; 338                 a = *de;
	ld a, (de)
; 339                 a += c;
	add c
; 340                 c = a;
	ld c, a
; 341                 de++;
	inc de
; 342                 b--;
	dec b
l_440:
; 343             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_439
; 344             //
; 345             a = *de;
	ld a, (de)
; 346             if (a == c) {
	cp c
	jp nz, l_442
; 347                 a = 1;
	ld a, 1
; 348                 parseFtpFileLoadViewCheckSumState = a;
	ld (parseftpfileloadviewchecksumstat), a
	jp l_443
l_442:
; 349             } else {
; 350                 a = 0;
	ld a, 0
; 351                 parseFtpFileLoadViewCheckSumState = a;
	ld (parseftpfileloadviewchecksumstat), a
l_443:
	pop bc
	pop de
	ret
; 352             }
; 353         }
; 354     }
; 355 }
; 356 
; 357 /// Извлекает из A данные по размерам пакета (свойства + буфер)
; 358 /// первые 3 бита - свойства, последние 5 - данные
; 359 /// (property & 0x07) + ((data & 0x1f)<<3);
; 360 void ftpFileDownloadParseSizePackA() {
ftpfiledownloadparsesizepacka:
; 361     push_pop(bc) {
	push bc
; 362         b = a;
	ld b, a
; 363         a &= 0x07;
	and 7
; 364         ftpFileDownloadPropertySize = a;
	ld (ftpfiledownloadpropertysize), a
; 365         a = b;
	ld a, b
; 366         a &= 0xF8;
	and 248
; 367         carry_rotate_right(a, 3);
	rra
	rra
	rra
; 368         ftpFileDownloadDataSize = a;
	ld (ftpfiledownloaddatasize), a
	pop bc
	ret
; 369     }
; 370 }
; 371 
; 372 /// Считаем адрес куда писать данные на диск
; 373 void ftpFileDownloadCalkDiskPosToHL() {
ftpfiledownloadcalkdiskpostohl:
; 374     push_pop(de) {
	push de
; 375         // получаем адрес пакета
; 376         hl = ftpFileLoadCurrentPos;
	ld hl, (ftpfileloadcurrentpos)
; 377         // вычитаем длину пакета данных
; 378         a = ftpFileDownloadDataSize;
	ld a, (ftpfiledownloaddatasize)
; 379         e = a;
	ld e, a
; 380         a = l;
	ld a, l
; 381         a -= e;
	sub e
; 382         if (flag_c) {
	jp nc, l_444
; 383             h--;
	dec h
l_444:
; 384         }
; 385         l = a;
	ld l, a
; 386         // прибавляем к точке начала файла на диске
; 387         d = h;
	ld d, h
; 388         e = l;
	ld e, l
; 389         hl = DiskViewStartNewFile;
	ld hl, (diskviewstartnewfile)
; 390         a = l;
	ld a, l
; 391         a += e;
	add e
; 392         if (flag_c) {
	jp nc, l_446
; 393             h++;
	inc h
l_446:
; 394         }
; 395         l = a;
	ld l, a
; 396         a = h;
	ld a, h
; 397         a += d;
	add d
; 398         h = a;
	ld h, a
	pop de
	ret
; 399         // В HL адрес записи, полученных данных, на диск
; 400     }
; 401 }
; 402 
; 403 /// Извлекает из A данные о прогрессе и Статус продолжение данных
; 404 /// первые 6 бит - прогресс.
; 405 /// последние 2 - статус продолжения. (0x80 - если еще есть данные. 0x40 - данные закончились. 0x00 - ошибка данных)
; 406 void ftpFileDownloadParseProgressAndNextA() {
ftpfiledownloadparseprogressandn:
; 407     push_pop(bc) {
	push bc
; 408         b = a;
	ld b, a
; 409         a &= 0x3F;
	and 63
; 410         LoadViewProgress = a;
	ld (loadviewprogress), a
; 411         //
; 412         a = b;
	ld a, b
; 413         a &= 0xC0;
	and 192
; 414         b = a;
	ld b, a
; 415         // --
; 416         if ((a = b) == 0x80) {
	ld a, b
	cp 128
	jp nz, l_448
; 417             a = 0x01;
	ld a, 1
; 418             parseFtpFileLoadViewIsNextData = a;
	ld (parseftpfileloadviewisnextdata), a
	jp l_449
l_448:
; 419         } else if ((a = b) == 0x40) {
	ld a, b
	cp 64
	jp nz, l_450
; 420             a = 0x5A;
	ld a, 90
; 421             parseFtpFileLoadViewIsNextData = a;
	ld (parseftpfileloadviewisnextdata), a
	jp l_451
l_450:
; 422         } else {
; 423             a = 0xFF;
	ld a, 255
; 424             parseFtpFileLoadViewIsNextData = a;
	ld (parseftpfileloadviewisnextdata), a
; 425             a = 0;
	ld a, 0
; 426             parseFtpFileLoadViewCheckSumState = a;
	ld (parseftpfileloadviewchecksumstat), a
l_451:
l_449:
	pop bc
	ret
; 427         }
; 428     }
; 429 }
; 430 
; 431 void SsidListNextParser() {
ssidlistnextparser:
; 432     SsidListNextParserCheckSum();
	call ssidlistnextparserchecksum
; 433     if ((a = SsidListNextParserCheckSumState) == 1) {
	ld a, (ssidlistnextparserchecksumstate)
	cp 1
	jp nz, l_452
; 434         push_pop(de, bc) {
	push de
	push bc
; 435             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 436             // -- [0] = 1 Проверка
; 437             a = *de;
	ld a, (de)
; 438             if (a == 0x01) {
	cp 1
	jp nz, l_454
; 439                 de++;
	inc de
; 440                 //-- POS
; 441                 a = *de;
	ld a, (de)
; 442                 SsidListNextParserPos = a;
	ld (ssidlistnextparserpos), a
; 443                 a += 1;
	add 1
; 444                 WiFiNetworksViewSSIDCount = a;
	ld (wifinetworksviewssidcount), a
; 445                 de++;
	inc de
; 446                 //-- NEXT
; 447                 a = *de;
	ld a, (de)
; 448                 SsidListNextParserNext = a;
	ld (ssidlistnextparsernext), a
; 449                 de++;
	inc de
; 450                 // Подсчет указателя
; 451                 push_pop(de, hl) {
	push de
	push hl
; 452                     hl = WiFiNetworksViewSSIDList;
	ld hl, wifinetworksviewssidlist
; 453                     a = SsidListNextParserPos;
	ld a, (ssidlistnextparserpos)
; 454                     cyclic_rotate_left(a, 4);
	rlca
	rlca
	rlca
	rlca
; 455                     e = a;
	ld e, a
; 456                     d = 0;
	ld d, 0
; 457                     hl += de;
	add hl, de
; 458                     SsidListNextParserPoint = hl;
	ld (ssidlistnextparserpoint), hl
	pop hl
	pop de
	jp l_455
l_454:
; 459                 }
; 460             } else { // Что то не так, еще раз качаем
; 461                 a = 0;
	ld a, 0
; 462                 SsidListNextParserCheckSumState = a;
	ld (ssidlistnextparserchecksumstate), a
l_455:
	pop bc
	pop de
l_452:
	ret
; 463             }
; 464         }
; 465     }
; 466 }
; 467 
; 468 void SsidListNextParserCheckSum() {
ssidlistnextparserchecksum:
; 469     push_pop(de, bc) {
	push de
	push bc
; 470         de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 471         b = 3;
	ld b, 3
; 472         c = 0;
	ld c, 0
; 473         do {
l_456:
; 474             a = *de;
	ld a, (de)
; 475             a += c;
	add c
; 476             c = a;
	ld c, a
; 477             de++;
	inc de
; 478             b--;
	dec b
l_457:
; 479         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_456
; 480         a = *de;
	ld a, (de)
; 481         if (a == c) {
	cp c
	jp nz, l_459
; 482             a = 1;
	ld a, 1
; 483             SsidListNextParserCheckSumState = a;
	ld (ssidlistnextparserchecksumstate), a
	jp l_460
l_459:
; 484         } else {
; 485             a = 0;
	ld a, 0
; 486             SsidListNextParserCheckSumState = a;
	ld (ssidlistnextparserchecksumstate), a
l_460:
	pop bc
	pop de
	ret
; 487         }
; 488     }
; 489 }
; 490 
; 491 /// Ответ от платы подтверждающий правильность получения данных
; 492 /// 1 byte :  0x01 - Error; 0xA5 - Ok; 0x03 - InternalError;
; 493 /// 2 byte : Test .... 0x55
; 494 /// 3 byte : SUM
; 495 void sendHLToAParser() {
sendhltoaparser:
; 496     sendHLToAParserCheckSum();
	call sendhltoaparserchecksum
; 497     if ((a = sendHLToAParserCheckSumState) == 1) {
	ld a, (sendhltoaparserchecksumstate)
	cp 1
	jp nz, l_461
; 498         push_pop(de) {
	push de
; 499             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 500             //-- Ok/Error
; 501             a = *de;
	ld a, (de)
; 502             if (a == 0x01) {
	cp 1
	jp nz, l_463
; 503                 a = 0;
	ld a, 0
; 504                 sendHLToAParserIsOk = a;
	ld (sendhltoaparserisok), a
	jp l_464
l_463:
; 505             } else if (a == 0xA5) {
	cp 165
	jp nz, l_465
; 506                 a = 1;
	ld a, 1
; 507                 sendHLToAParserIsOk = a;
	ld (sendhltoaparserisok), a
	jp l_466
l_465:
; 508             } else {
; 509                 a = 0;
	ld a, 0
; 510                 sendHLToAParserIsOk = a;
	ld (sendhltoaparserisok), a
l_466:
l_464:
; 511             }
; 512             de++;
	inc de
; 513             //-- Test
; 514             a = *de;
	ld a, (de)
; 515             if (a != 0x55) {
	cp 85
	jp z, l_467
; 516                 a = 0;
	ld a, 0
; 517                 sendHLToAParserIsOk = a;
	ld (sendhltoaparserisok), a
l_467:
	pop de
	jp l_462
l_461:
; 518             }
; 519         }
; 520     } else {
; 521         a = 0;
	ld a, 0
; 522         sendHLToAParserIsOk = a;
	ld (sendhltoaparserisok), a
l_462:
	ret
; 523     }
; 524 }
; 525 
; 526 void sendHLToAParserCheckSum() {
sendhltoaparserchecksum:
; 527     push_pop(de, bc) {
	push de
	push bc
; 528         de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 529         //--
; 530         b = 2;
	ld b, 2
; 531         c = 0;
	ld c, 0
; 532         do {
l_469:
; 533             a = *de;
	ld a, (de)
; 534             a += c;
	add c
; 535             c = a;
	ld c, a
; 536             de++;
	inc de
; 537             b--;
	dec b
l_470:
; 538         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_469
; 539         a = *de;
	ld a, (de)
; 540         if (a == c) {
	cp c
	jp nz, l_472
; 541             a = 1;
	ld a, 1
; 542             sendHLToAParserCheckSumState = a;
	ld (sendhltoaparserchecksumstate), a
	jp l_473
l_472:
; 543         } else {
; 544             a = 0;
	ld a, 0
; 545             sendHLToAParserCheckSumState = a;
	ld (sendhltoaparserchecksumstate), a
l_473:
	pop bc
	pop de
	ret
; 546         }
; 547     }
; 548 }
; 549 
; 550 /// Get All State
; 551 /// 1 byte : Test = 0x55
; 552 /// 2 byre : All State : WIFIConnect = 0x01; FtpConnect = 0x02;
; 553 /// 3 byte : Reserved
; 554 /// 4 byte : SUM
; 555 void getAllStatusParser() {
getallstatusparser:
; 556     getAllStatusParserCheckSum();
	call getallstatusparserchecksum
; 557     if ((a = allStatusParserCheckSumState) == 1) {
	ld a, (allstatusparserchecksumstate)
	cp 1
	jp nz, l_474
; 558         push_pop(de, bc) {
	push de
	push bc
; 559             de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 560             // Test byte
; 561             a = *de;
	ld a, (de)
; 562             if (a == 0x55) {
	cp 85
	jp nz, l_476
; 563                 de++;
	inc de
; 564                 // -- All State
; 565                 a = *de;
	ld a, (de)
; 566                 b = a;
	ld b, a
; 567                 // -- WIFIConnect
; 568                 a = b;
	ld a, b
; 569                 a &= 0x01;
	and 1
; 570                 ThreadsNetSetWiFiStateA();
	call threadsnetsetwifistatea
; 571                 // -- FtpConnect
; 572                 a = b;
	ld a, b
; 573                 a &= 0x02;
	and 2
; 574                 cyclic_rotate_right(a, 1);
	rrca
; 575                 ThreadsNetSetFtpStateA();
	call threadsnetsetftpstatea
; 576                 // -- End state
; 577                 de++;
	inc de
	jp l_477
l_476:
; 578                 // -- Reserve
; 579             } else {
; 580                 a = 0;
	ld a, 0
; 581                 allStatusParserCheckSumState = a;
	ld (allstatusparserchecksumstate), a
l_477:
	pop bc
	pop de
l_474:
	ret
; 582             }
; 583         }
; 584     }
; 585 }
; 586 
; 587 void getAllStatusParserCheckSum() {
getallstatusparserchecksum:
; 588     push_pop(de, bc) {
	push de
	push bc
; 589         de = ESP_I2S_BUFFER;
	ld de, esp_i2s_buffer
; 590         //--
; 591         b = 3;
	ld b, 3
; 592         c = 0;
	ld c, 0
; 593         do {
l_478:
; 594             a = *de;
	ld a, (de)
; 595             a += c;
	add c
; 596             c = a;
	ld c, a
; 597             de++;
	inc de
; 598             b--;
	dec b
l_479:
; 599         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_478
; 600         a = *de;
	ld a, (de)
; 601         if (a == c) {
	cp c
	jp nz, l_481
; 602             a = 1;
	ld a, 1
; 603             allStatusParserCheckSumState = a;
	ld (allstatusparserchecksumstate), a
	jp l_482
l_481:
; 604         } else {
; 605             a = 0;
	ld a, 0
; 606             allStatusParserCheckSumState = a;
	ld (allstatusparserchecksumstate), a
l_482:
	pop bc
	pop de
	ret
; 607         }
; 608     }
; 609 }
; 610 
; 611 uint8_t allStatusParserCheckSumState = 0;
allstatusparserchecksumstate:
	db 0
; 613 uint8_t sendHLToAParserIsOk = 0;
sendhltoaparserisok:
	db 0
; 614 uint8_t sendHLToAParserCheckSumState = 0;
sendhltoaparserchecksumstate:
	db 0
; 616 uint8_t SsidListNextParserNext = 0;
ssidlistnextparsernext:
	db 0
; 617 uint8_t SsidListNextParserCheckSumState = 0;
ssidlistnextparserchecksumstate:
	db 0
; 618 uint8_t SsidListNextParserPos = 0;
ssidlistnextparserpos:
	db 0
; 619 uint16_t SsidListNextParserPoint = 0;
ssidlistnextparserpoint:
	dw 0
; 621 uint8_t ftpFileDownloadPropertySize = 0;
ftpfiledownloadpropertysize:
	db 0
; 622 uint16_t ftpFileDownloadEnd = 0;
ftpfiledownloadend:
	dw 0
; 623 uint8_t ftpFileDownloadDataSize = 0;
ftpfiledownloaddatasize:
	db 0
; 624 uint16_t ftpFileLoadCurrentPos = 0;
ftpfileloadcurrentpos:
	dw 0
; 625 uint8_t parseFtpFileLoadViewCheckSumState = 0;
parseftpfileloadviewchecksumstat:
	db 0
; 626 uint8_t parseFtpFileLoadViewIsNextData = 0;
parseftpfileloadviewisnextdata:
	db 0
; 628 uint8_t parsePageBufferNext = 0;
parsepagebuffernext:
	db 0
; 629 uint8_t parsePageBufferIsCheck = 0;
parsepagebufferischeck:
	db 0
; 631 uint8_t parseFtpListBufferIsCheck = 0;
parseftplistbufferischeck:
	db 0
; 632 uint8_t parseFtpListBufferNext = 0;
parseftplistbuffernext:
	db 0
; 11 void LoadViewShowHL() {
loadviewshowhl:
; 12     CurrentViewChangeAndPushIdA(a = LoadViewId);
	ld a, 4
	call currentviewchangeandpushida
; 13     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 14         a = LoadViewX;
	ld a, (loadviewx)
; 15         h = a;
	ld h, a
; 16         a = LoadViewY;
	ld a, (loadviewy)
; 17         l = a;
	ld l, a
; 18         a = LoadViewDX;
	ld a, (loadviewdx)
; 19         d = a;
	ld d, a
; 20         a = LoadViewDY;
	ld a, (loadviewdy)
; 21         e = a;
	ld e, a
; 22         a = LoadViewColor;
	ld a, (loadviewcolor)
; 23         c = a;
	ld c, a
; 24         a = vboxCLW;
	ld a, 64
; 25         a |= vboxFRM;
	or 32
; 26         a |= vboxSDW;
	or 16
; 27         a |= vboxSAV;
	or 8
; 28         a |= vboxUMP;
	or 4
; 29         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop hl
	pop bc
; 30     }
; 31     LoadViewShowTitleHL();
	jp loadviewshowtitlehl
; 32 }
; 33 
; 34 void LoadViewClose() {
loadviewclose:
; 35     vboxClose();
	call vboxclose
; 36     CurrentViewReturn();
	jp currentviewreturn
; 37 }
; 38 
; 39 void LoadViewShowTitleHL() {
loadviewshowtitlehl:
; 40     push_pop(bc) {
	push bc
; 41         push_pop(hl) {
	push hl
; 42             b = 0;
	ld b, 0
; 43             do {
l_483:
; 44                 a = *hl;
	ld a, (hl)
; 45                 c = a;
	ld c, a
; 46                 hl++;
	inc hl
; 47                 b++;
	inc b
; 48                 if ((a = LoadViewDX) < b) {
	ld a, (loadviewdx)
	cp b
	jp nc, l_486
; 49                     a = 0;
	ld a, 0
; 50                     c = a;
	ld c, a
l_486:
l_484:
; 51                 }
; 52             } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, l_483
	pop hl
; 53         }
; 54         a = LoadViewDX;
	ld a, (loadviewdx)
; 55         a -= b;
	sub b
; 56         a &= 0xFE;
	and 254
; 57         cyclic_rotate_right(a, 1);
	rrca
; 58         c = a;
	ld c, a
; 59         // X
; 60         a = LoadViewX;
	ld a, (loadviewx)
; 61         a += c;
	add c
; 62         myCharPosX = a;
	ld (mycharposx), a
; 63         // Y
; 64         a = LoadViewY;
	ld a, (loadviewy)
; 65         a += 1;
	add 1
; 66         myCharPosY = a;
	ld (mycharposy), a
; 67         //
; 68         printMyHLStr();
	call printmyhlstr
	pop bc
	ret
; 69     }
; 70 }
; 71 
; 72 uint8_t LoadViewShowProgressOld = 0xFF;
loadviewshowprogressold:
	db 255
; 73 void LoadViewShowProgressA() {
loadviewshowprogressa:
; 74     push_pop(bc) {
	push bc
; 75         c = a; //Save
	ld c, a
; 76         if ((a = LoadViewShowProgressOld) != c) {
	ld a, (loadviewshowprogressold)
	cp c
	jp z, l_488
; 77             a = c;
	ld a, c
; 78             LoadViewShowProgressOld = a;
	ld (loadviewshowprogressold), a
; 79             // X
; 80             a = LoadViewX;
	ld a, (loadviewx)
; 81             a += 1;
	add 1
; 82             myCharPosX = a;
	ld (mycharposx), a
; 83             // Y
; 84             a = LoadViewY;
	ld a, (loadviewy)
; 85             a += 2;
	add 2
; 86             myCharPosY = a;
	ld (mycharposy), a
; 87             b = 0;
	ld b, 0
; 88             do {
l_490:
; 89                 if ((a = b) < c) {
	ld a, b
	cp c
	jp nc, l_493
; 90                     printMyChatA(a = 0xDB);
	ld a, 219
	call printmychata
	jp l_494
l_493:
; 91                 } else {
; 92                     printMyChatA(a = 0xB0); //0xB0 0xB1 0xB2
	ld a, 176
	call printmychata
l_494:
; 93                 }
; 94                 b++;
	inc b
l_491:
; 95             } while ((a = b) < 40);
	ld a, b
	cp 40
	jp c, l_490
l_488:
	pop bc
	ret
; 96         }
; 97     }
; 98 }
; 99 
; 100 uint8_t LoadViewX = 3;
loadviewx:
	db 3
; 101 uint8_t LoadViewY = 14;
loadviewy:
	db 14
; 102 uint8_t LoadViewDX = 42;
loadviewdx:
	db 42
; 103 uint8_t LoadViewDY = 4;
loadviewdy:
	db 4
; 104 uint8_t LoadViewColor = 0x70; // 0x1F;
loadviewcolor:
	db 112
; 106 uint8_t LoadViewProgress = 0;
loadviewprogress:
	db 0
; 108 uint8_t LoadViewLoadTitle[] = "Load...";
loadviewloadtitle:
	db 76
	db 111
	db 97
	db 100
	db 46
	db 46
	db 46
	ds 1
; 11 void ThreadsTickNow() {
threadsticknow:
; 12     a = 101;
	ld a, 101
; 13     ThreadsTickCount = a;
	ld (threadstickcount), a
	ret
; 14 }
; 15 
; 16 void ThreadsTick() {
threadstick:
; 17     #ifdef _IS_SIMULATOR
; 18         
; 19     #else
; 20     if ((a = ThreadsTickCount) >= 100) {
	ld a, (threadstickcount)
	cp 100
	jp c, l_495
; 21         a = 0;
	ld a, 0
; 22         ThreadsTickCount = a;
	ld (threadstickcount), a
; 23         //--
; 24         ThreadsNetUpdateState();
	call threadsnetupdatestate
	jp l_496
l_495:
; 25     } else {
; 26         ThreadsTickCountNext();
	call threadstickcountnext
l_496:
	ret
; 27     }
; 28     #endif
; 29 }
; 30 
; 31 void ThreadsNetUpdateState() {
threadsnetupdatestate:
; 32     getAllStatus();
	call getallstatus
; 33     //getFtpState();
; 34     //getWifiState();
; 35     ThreadsNetNeedStateChange();
; 36 }
; 37 
; 38 void ThreadsNetNeedStateChange() {
threadsnetneedstatechange:
; 39     if ((a = WiFiNetStateChange) == 1) {
	ld a, (wifinetstatechange)
	cp 1
	jp nz, l_497
; 40         ThreadsNetNeedUpdateWiFiData();
	call threadsnetneedupdatewifidata
; 41         a = 0;
	ld a, 0
; 42         WiFiNetStateChange = a;
	ld (wifinetstatechange), a
l_497:
; 43     }
; 44     if ((a = FtpNetStateChange) == 1) {
	ld a, (ftpnetstatechange)
	cp 1
	jp nz, l_499
; 45         ThreadsNetNeedUpdateFtpData();
	call threadsnetneedupdateftpdata
; 46         a = 0;
	ld a, 0
; 47         FtpNetStateChange = a;
	ld (ftpnetstatechange), a
l_499:
	ret
; 48     }
; 49 }
; 50 
; 51 // ----------------------------------
; 52 // ------------ WiFi ----------------
; 53 // ----------------------------------
; 54 void ThreadsNetNeedUpdateWiFiData() {
threadsnetneedupdatewifidata:
; 55     getSSIDIPAddress();
	call getssidipaddress
; 56     WifiStateViewShowValue();
	jp wifistateviewshowvalue
; 57 }
; 58 
; 59 void ThreadsNetNeedUpdateWiFiValue() {
threadsnetneedupdatewifivalue:
; 60     getSSIDValue();
	call getssidvalue
; 61     getSSIDIPAddress();
	call getssidipaddress
; 62     getSSIDMacAddress();
	call getssidmacaddress
; 63     getSSIDPassword();
	call getssidpassword
; 64     // UI
; 65     WifiStateViewShowValue();
	jp wifistateviewshowvalue
; 66 }
; 67 
; 68 void ThreadsNetPasswordUpdate() {
threadsnetpasswordupdate:
; 69     setSSIDPassword();
	call setssidpassword
; 70     getSSIDPassword();
	jp getssidpassword
; 71 }
; 72 
; 73 void ThreadsNetSsidUpdateA() {
threadsnetssidupdatea:
; 74     setSSIDNumberA();
	call setssidnumbera
; 75     getSSIDValue();
	jp getssidvalue
; 76 }
; 77 
; 78 void ThreadsNetSetWiFiStateA() {
threadsnetsetwifistatea:
; 79     push_pop(bc) {
	push bc
; 80         a &= 0x01;
	and 1
; 81         b = a;
	ld b, a
; 82         // Old Value
; 83         a = WifiStateViewSSIDIsConnected;
	ld a, (wifistateviewssidisconnected)
; 84         c = a;
	ld c, a
; 85         // --
; 86         a = b;
	ld a, b
; 87         WifiStateViewSSIDIsConnected = a;
	ld (wifistateviewssidisconnected), a
; 88         if(a != c){
	cp c
	jp z, l_501
; 89             a = 0x01;
	ld a, 1
; 90             WiFiNetStateChange = a;
	ld (wifinetstatechange), a
l_501:
	pop bc
	ret
; 91         }
; 92     }
; 93 }
; 94 
; 95 // ----------------------------------
; 96 // ------------ Ftp  ----------------
; 97 // ----------------------------------
; 98 void ThreadsNetNeedUpdateFtpData() {
threadsnetneedupdateftpdata:
; 99     FtpStateViewShowValue();
	call ftpstateviewshowvalue
; 100     // Update ftp dir
; 101     getFtpCurrentPathNew();
	call getftpcurrentpathnew
; 102     FtpViewShowPath();
	call ftpviewshowpath
; 103     //
; 104     CurrentViewDiskOrFtpViewByIdA(a = CurrentViewId);
	ld a, (currentviewid)
	call currentviewdiskorftpviewbyida
; 105     if (a == 1) {
	cp 1
	jp nz, l_503
; 106         if ((a = FtpStateViewStatus) == 1) {
	ld a, (ftpstateviewstatus)
	cp 1
	jp nz, l_505
; 107             updateFtpList();
	call updateftplist
; 108             getNetFtpListNew();
	call getnetftplistnew
	jp l_506
l_505:
; 109         } else {
; 110             FtpViewEmptyList();
	call ftpviewemptylist
l_506:
; 111         }
; 112         FtpViewListUpdateUI();
	call ftpviewlistupdateui
l_503:
	ret
; 113     }
; 114 }
; 115 
; 116 void ThreadsNetNeedUpdateFtpValue() {
threadsnetneedupdateftpvalue:
; 117     getFTPUrl();
	call getftpurl
; 118     getFTPHomeDir();
	call getftphomedir
; 119     getFTPPort();
	call getftpport
; 120     getFTPUser();
	call getftpuser
; 121     getFTPPassword();
	call getftppassword
; 122     // UI
; 123     FtpStateViewShowValue();
	jp ftpstateviewshowvalue
; 124 }
; 125 
; 126 void ThreadsNetFtpHomeDirUpdate() {
threadsnetftphomedirupdate:
; 127     setFtpHomeDir();
	call setftphomedir
; 128     getFTPHomeDir();
	jp getftphomedir
; 129 }
; 130 
; 131 void ThreadsNetFtpPasswordUpdate() {
threadsnetftppasswordupdate:
; 132     setFtpPassword();
	call setftppassword
; 133     getFTPPassword();
	jp getftppassword
; 134 }
; 135 
; 136 void ThreadsNetFtpUserUpdate() {
threadsnetftpuserupdate:
; 137     setFtpUser();
	call setftpuser
; 138     getFTPUser();
	jp getftpuser
; 139 }
; 140 
; 141 void ThreadsNetFtpServerUrlUpdate() {
threadsnetftpserverurlupdate:
; 142     setFtpServerUrl();
	call setftpserverurl
; 143     getFTPUrl();
	jp getftpurl
; 144 }
; 145 
; 146 void ThreadsNetFtpPortUpdate() {
threadsnetftpportupdate:
; 147     setFtpPort();
	call setftpport
; 148     getFTPPort();
	jp getftpport
; 149 }
; 150 
; 151 void ThreadsNetSetFtpStateA() {
threadsnetsetftpstatea:
; 152     push_pop(bc) {
	push bc
; 153         a &= 0x01;
	and 1
; 154         b = a;
	ld b, a
; 155         // Old Value
; 156         a = FtpStateViewStatus;
	ld a, (ftpstateviewstatus)
; 157         c = a;
	ld c, a
; 158         // --
; 159         a = b;
	ld a, b
; 160         FtpStateViewStatus = a;
	ld (ftpstateviewstatus), a
; 161         if(a != c){
	cp c
	jp z, l_507
; 162             a = 0x01;
	ld a, 1
; 163             FtpNetStateChange = a;
	ld (ftpnetstatechange), a
l_507:
	pop bc
	ret
; 164         }
; 165     }
; 166 }
; 167 
; 168 void ThreadsNetFtpGoToHomeDir() {
threadsnetftpgotohomedir:
; 169     setFtpGoToHomeDir();
	call setftpgotohomedir
; 170     getFtpCurrentPathNew();
	call getftpcurrentpathnew
; 171     FtpViewShowPath();
	call ftpviewshowpath
; 172     if ((a = FtpStateViewStatus) == 1) {
	ld a, (ftpstateviewstatus)
	cp 1
	jp nz, l_509
; 173         updateFtpList();
	call updateftplist
; 174         getNetFtpListNew();
	call getnetftplistnew
	jp l_510
l_509:
; 175     } else {
; 176         FtpViewEmptyList();
	call ftpviewemptylist
l_510:
; 177     }
; 178     FtpViewListUpdateUI();
	jp ftpviewlistupdateui
; 179 }
; 180 
; 181 
; 182 void NetUpdateData() {
netupdatedata:
; 183     ThreadsNetNeedUpdateFtpValue();
	call threadsnetneedupdateftpvalue
; 184     ThreadsNetNeedUpdateWiFiValue();
	jp threadsnetneedupdatewifivalue
; 185 }
; 186 
; 187 void delay50ms() {
delay50ms:
; 188     push_pop(bc) {
	push bc
; 189         bc = 0xFFFF;
	ld bc, 65535
; 190         do {
l_511:
; 191             bc--;
	dec bc
; 192             a = b;
	ld a, b
; 193             a |= c;
	or c
l_512:
	jp nz, l_511
	pop bc
	ret
; 194         } while (flag_nz);
; 195     }
; 196 }
; 197 
; 198 void ThreadsTickCountNext() {
threadstickcountnext:
; 199     push_pop(hl) {
	push hl
; 200         hl = ThreadsTickSubCount;
	ld hl, (threadsticksubcount)
; 201         // Compare hl == 0
; 202         a = h;
	ld a, h
; 203         a |= l;
	or l
; 204         if (a == 0) {
	or a
	jp nz, l_514
; 205             //-- TickCount ++
; 206             a = ThreadsTickCount;
	ld a, (threadstickcount)
; 207             a++;
	inc a
; 208             ThreadsTickCount = a;
	ld (threadstickcount), a
; 209             //-- TickSubCount = max
; 210             hl = 0x800; //0x1000; //0x300;
	ld hl, 2048
	jp l_515
l_514:
; 211         } else {
; 212             hl--;
	dec hl
l_515:
; 213         }
; 214         ThreadsTickSubCount = hl;
	ld (threadsticksubcount), hl
	pop hl
	ret
; 215     }
; 216 }
; 217 
; 218 uint16_t ThreadsTickSubCount = 0x0000;
threadsticksubcount:
	dw 0
; 219 uint8_t ThreadsTickCount = 0;
threadstickcount:
	db 0
; 11 void convertKeyToMyFontA() {
convertkeytomyfonta:
; 12     push_pop(bc) {
	push bc
; 13         b = a;
	ld b, a
; 14         c = a;
	ld c, a
; 15         if ((a = keyRusAddress) == 0) { //0 лат
	ld a, (keyrusaddress)
	or a
	jp nz, l_516
; 16             // Меняем заглавные на маленькие
; 17             if ((a = b) >= 0x41) {
	ld a, b
	cp 65
	jp c, l_518
; 18                 if ((a = b) < 0x5B) {
	ld a, b
	cp 91
	jp nc, l_520
; 19                     a = b;
	ld a, b
; 20                     a += 0x20;
	add 32
; 21                     c = a;
	ld c, a
l_520:
l_518:
; 22                 }
; 23             }
; 24             // Меняем маленькие на заглавные
; 25             if ((a = b) >= 0x61) {
	ld a, b
	cp 97
	jp c, l_522
; 26                 if ((a = b) < 0x7B) {
	ld a, b
	cp 123
	jp nc, l_524
; 27                     a = b;
	ld a, b
; 28                     a -= 0x20;
	sub 32
; 29                     c = a;
	ld c, a
l_524:
l_522:
	jp l_517
l_516:
; 30                 }
; 31             }
; 32         } else if ((a = keyRusAddress) == 0xFF) { // rus
	ld a, (keyrusaddress)
	cp 255
	jp nz, l_526
; 33             // Меняем заглавные английские на заглавные русские
; 34             if ((a = b) >= 0x41) {
	ld a, b
	cp 65
	jp c, l_528
; 35                 if ((a = b) < 0x5B) {
	ld a, b
	cp 91
	jp nc, l_530
; 36                     a = b;
	ld a, b
; 37                     a += 0x3F;
	add 63
; 38                     c = a;
	ld c, a
; 39                     KeyboardConverRusCharC(a = 1);
	ld a, 1
	call keyboardconverruscharc
l_530:
l_528:
; 40                 }
; 41             }
; 42             // Меняем маленькие английские на маленькие русские
; 43             if ((a = b) >= 0x61) {
	ld a, b
	cp 97
	jp c, l_532
; 44                 if ((a = b) < 0x7B) {
	ld a, b
	cp 123
	jp nc, l_534
; 45                     a = b;
	ld a, b
; 46                     a += 0x3F;
	add 63
; 47                     c = a;
	ld c, a
; 48                     //
; 49                     KeyboardConverRusCharC(a = 0);
	ld a, 0
	call keyboardconverruscharc
; 50                     // если больше "п" то + 30
; 51                     if ((a = c) >= 0xB0) {
	ld a, c
	cp 176
	jp c, l_536
; 52                         a = c;
	ld a, c
; 53                         a += 0x30;
	add 48
; 54                         c = a;
	ld c, a
l_536:
l_534:
l_532:
; 55                     }
; 56                 }
; 57             }
; 58             // Ю
; 59             d = 0x40;
	ld d, 64
; 60             e = 0x60;
	ld e, 96
; 61             KeyboardBOrDOrE();
	call keyboardbordore
; 62             if (a == 1) {
	cp 1
	jp nz, l_538
; 63                 a = b;
	ld a, b
; 64                 a += 0x5E;
	add 94
; 65                 c = a;
	ld c, a
l_538:
; 66             }
; 67             // Э
; 68             d = 0x5C;
	ld d, 92
; 69             e = 0x7C;
	ld e, 124
; 70             KeyboardBOrDOrE();
	call keyboardbordore
; 71             if (a == 1) {
	cp 1
	jp nz, l_540
; 72                 a = b;
	ld a, b
; 73                 a += 0x41;
	add 65
; 74                 c = a;
	ld c, a
l_540:
; 75             }
; 76             // Ч
; 77             d = 0x5E;
	ld d, 94
; 78             e = 0x7E;
	ld e, 126
; 79             KeyboardBOrDOrE();
	call keyboardbordore
; 80             if (a == 1) {
	cp 1
	jp nz, l_542
; 81                 a = b;
	ld a, b
; 82                 a += 0x39;
	add 57
; 83                 c = a;
	ld c, a
l_542:
; 84             }
; 85             // Ш
; 86             d = 0x5B;
	ld d, 91
; 87             e = 0x7B;
	ld e, 123
; 88             KeyboardBOrDOrE();
	call keyboardbordore
; 89             if (a == 1) {
	cp 1
	jp nz, l_544
; 90                 a = b;
	ld a, b
; 91                 a += 0x3D;
	add 61
; 92                 c = a;
	ld c, a
l_544:
; 93             }
; 94             // Щ
; 95             d = 0x5D;
	ld d, 93
; 96             e = 0x7D;
	ld e, 125
; 97             KeyboardBOrDOrE();
	call keyboardbordore
; 98             if (a == 1) {
	cp 1
	jp nz, l_546
; 99                 a = b;
	ld a, b
; 100                 a += 0x3C;
	add 60
; 101                 c = a;
	ld c, a
l_546:
; 102             }
; 103             if ((a = c) >= 0xB0) {
	ld a, c
	cp 176
	jp c, l_548
; 104                 if ((a = c) < 0xC0) {
	ld a, c
	cp 192
	jp nc, l_550
; 105                     a = c;
	ld a, c
; 106                     a += 0x30;
	add 48
; 107                     c = a;
	ld c, a
l_550:
l_548:
	jp l_527
l_526:
; 108                 }
; 109             }
; 110         } else {
l_527:
l_517:
; 111             
; 112         }
; 113         a = c;
	ld a, c
	pop bc
	ret
; 114     }
; 115 }
; 116 
; 117 void KeyboardBOrDOrE() {
keyboardbordore:
; 118     push_pop(hl) {
	push hl
; 119         if ((a = b) == d) {
	ld a, b
	cp d
	jp nz, l_552
; 120             h = 1;
	ld h, 1
	jp l_553
l_552:
; 121         } else if ((a = b) == e) {
	ld a, b
	cp e
	jp nz, l_554
; 122             h = 1;
	ld h, 1
	jp l_555
l_554:
; 123         } else {
; 124             h = 0;
	ld h, 0
l_555:
l_553:
; 125         }
; 126         a = h;
	ld a, h
	pop hl
	ret
; 127     }
; 128 }
; 129 
; 130 /// A - 0 происная, 1 - заглавная
; 131 /// C - Символ
; 132 void KeyboardConverRusCharC() {
keyboardconverruscharc:
; 133     push_pop(hl, de) {
	push hl
	push de
; 134         if (a == 0) {
	or a
	jp nz, l_556
; 135             a = c;
	ld a, c
; 136             a -= 0xA0;
	sub 160
; 137             e = a;
	ld e, a
	jp l_557
l_556:
; 138         } else {
; 139             a = c;
	ld a, c
; 140             a -= 0x80;
	sub 128
; 141             e = a;
	ld e, a
l_557:
; 142         }
; 143         d = 0;
	ld d, 0
; 144         hl = KeyboardRusCharConver;
	ld hl, keyboardruscharconver
; 145         hl += de;
	add hl, de
; 146         a = *hl;
	ld a, (hl)
; 147         a += c;
	add c
; 148         c = a;
	ld c, a
	pop de
	pop hl
	ret
; 149     }
; 150 }
; 151 
; 152 uint8_t KeyboardRusCharConver[32] = {
keyboardruscharconver:
	db 0
	db 0
	db 20
	db 1
	db 1
	db 15
	db 253
	db 14
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 15
	db 255
	db 255
	db 255
	db 255
	db 241
	db 236
	db 5
	db 3
	db 237
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
; 11 void WiFiSettingsViewShow() {
wifisettingsviewshow:
; 12     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 13         CurrentViewChangeAndPushIdA(a = WiFiSettingsViewId);
	ld a, 5
	call currentviewchangeandpushida
; 14         //--
; 15         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 16         h = a;
	ld h, a
; 17         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 18         l = a;
	ld l, a
; 19         a = WiFiSettingsViewDX;
	ld a, (wifisettingsviewdx)
; 20         d = a;
	ld d, a
; 21         a = WiFiSettingsViewDY;
	ld a, (wifisettingsviewdy)
; 22         e = a;
	ld e, a
; 23         a = WiFiSettingsViewColor;
	ld a, (wifisettingsviewcolor)
; 24         c = a;
	ld c, a
; 25         a = vboxCLW;
	ld a, 64
; 26         a |= vboxFRM;
	or 32
; 27         a |= vboxSDW;
	or 16
; 28         a |= vboxSAV;
	or 8
; 29         a |= vboxUMP;
	or 4
; 30         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop hl
	pop bc
; 31     }
; 32     a = 0;
	ld a, 0
; 33     WiFiSettingsViewSelectPos = a;
	ld (wifisettingsviewselectpos), a
; 34     WiFiSettingsViewShowTitle();
	call wifisettingsviewshowtitle
; 35     WiFiSettingsViewShowValue();
	call wifisettingsviewshowvalue
; 36     WiFiSettingsViewSelectLineA(a = 1);
	ld a, 1
	jp wifisettingsviewselectlinea
; 37 }
; 38 
; 39 void WiFiSettingsViewShowTitle() {
wifisettingsviewshowtitle:
; 40     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 41         // Title
; 42         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 43         a += 7;
	add 7
; 44         myCharPosX = a;
	ld (mycharposx), a
; 45         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 46         a += 1; //2;
	add 1
; 47         myCharPosY = a;
	ld (mycharposy), a
; 48         printMyHLStr(hl = WiFiSettingsViewTitle);
	ld hl, wifisettingsviewtitle
	call printmyhlstr
; 49         // LINE!!!
; 50         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 51         a += 1;
	add 1
; 52         myCharPosX = a;
	ld (mycharposx), a
; 53         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 54         a += 2;
	add 2
; 55         myCharPosY = a;
	ld (mycharposy), a
; 56         a = WiFiSettingsViewDX;
	ld a, (wifisettingsviewdx)
; 57         a -= 2;
	sub 2
; 58         b = a;
	ld b, a
; 59         do {
l_558:
; 60             printMyChatA(a = 0x5F);
	ld a, 95
	call printmychata
; 61             b--;
	dec b
l_559:
; 62         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_558
; 63         // SSID
; 64         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 65         a += 2;
	add 2
; 66         b = a; // X
	ld b, a
; 67         myCharPosX = a;
	ld (mycharposx), a
; 68         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 69         a += 4;
	add 4
; 70         c = a; // Y
	ld c, a
; 71         myCharPosY = a;
	ld (mycharposy), a
; 72         printMyHLStr(hl = WifiStateViewTitleSSID);
	ld hl, wifistateviewtitlessid
	call printmyhlstr
; 73         // PASS
; 74         a = b;
	ld a, b
; 75         myCharPosX = a;
	ld (mycharposx), a
; 76         a = c;
	ld a, c
; 77         a += 1;
	add 1
; 78         myCharPosY = a;
	ld (mycharposy), a
; 79         printMyHLStr(hl = WiFiSettingsViewTitlePass);
	ld hl, wifisettingsviewtitlepass
	call printmyhlstr
; 80         // MAC
; 81         a = b;
	ld a, b
; 82         myCharPosX = a;
	ld (mycharposx), a
; 83         a = c;
	ld a, c
; 84         a += 2;
	add 2
; 85         myCharPosY = a;
	ld (mycharposy), a
; 86         printMyHLStr(hl = WiFiSettingsViewTitleMac);
	ld hl, wifisettingsviewtitlemac
	call printmyhlstr
; 87         // OK
; 88         d = 13;
	ld d, 13
; 89         e = 3;
	ld e, 3
; 90         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 91         a += 7;
	add 7
; 92         h = a;
	ld h, a
; 93         a = c;
	ld a, c
; 94         a += 4;
	add 4
; 95         l = a;
	ld l, a
; 96         if ((a = WifiStateViewSSIDIsConnected) == 0) {
	ld a, (wifistateviewssidisconnected)
	or a
	jp nz, l_561
; 97             bc = WiFiSettingsViewButtonTitle;
	ld bc, wifisettingsviewbuttontitle
	jp l_562
l_561:
; 98         } else {
; 99             bc = strOK;
	ld bc, strok
l_562:
; 100         }
; 101         ButtonShadowViewShow();
	call buttonshadowviewshow
	pop de
	pop bc
	pop hl
	ret
; 102     }
; 103 }
; 104 
; 105 void WiFiSettingsViewShowValue() {
wifisettingsviewshowvalue:
; 106     push_pop(hl, bc) {
	push hl
	push bc
; 107         // SSID
; 108         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 109         a += 8;
	add 8
; 110         b = a; // X
	ld b, a
; 111         myCharPosX = a;
	ld (mycharposx), a
; 112         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 113         a += 4;
	add 4
; 114         c = a; // Y
	ld c, a
; 115         myCharPosY = a;
	ld (mycharposy), a
; 116         a = 18;
	ld a, 18
; 117         printMyHLStrLenA(hl = WifiStateViewSsidVal);
	ld hl, wifistateviewssidval
	call printmyhlstrlena
; 118         // PASS
; 119         a = b;
	ld a, b
; 120         myCharPosX = a;
	ld (mycharposx), a
; 121         a = c;
	ld a, c
; 122         a += 1;
	add 1
; 123         myCharPosY = a;
	ld (mycharposy), a
; 124         a = 18;
	ld a, 18
; 125         printMyHLPassLenA(hl = WifiStateViewPassVal);
	ld hl, wifistateviewpassval
	call printmyhlpasslena
; 126         // MAC
; 127         a = b;
	ld a, b
; 128         myCharPosX = a;
	ld (mycharposx), a
; 129         a = c;
	ld a, c
; 130         a += 2;
	add 2
; 131         myCharPosY = a;
	ld (mycharposy), a
; 132         a = 18;
	ld a, 18
; 133         printMyHLStrLenA(hl = WifiStateViewMacVal);
	ld hl, wifistateviewmacval
	call printmyhlstrlena
	pop bc
	pop hl
	ret
; 134     }
; 135 }
; 136 
; 137 void WiFiSettingsViewClose() {
wifisettingsviewclose:
; 138     vboxClose();
	call vboxclose
; 139     CurrentViewReturn();
	jp currentviewreturn
; 140 }
; 141 
; 142 void WiFiSettingsViewKeyA() {
wifisettingsviewkeya:
; 143     push_pop(hl) {
	push hl
; 144         l = a;
	ld l, a
; 145         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_563
; 146             if ((a = CurrentViewId) == WiFiSettingsViewId) {
	ld a, (currentviewid)
	cp 5
	jp nz, l_565
; 147                 if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, l_567
; 148                     WiFiSettingsViewClose();
	call wifisettingsviewclose
	jp l_568
l_567:
; 149                 } else if ((a = l) == 0x0D) { // Выбор
	ld a, l
	cp 13
	jp nz, l_569
; 150                     if ((a = WiFiSettingsViewSelectPos) == 0) { // OK
	ld a, (wifisettingsviewselectpos)
	or a
	jp nz, l_571
; 151                         WiFiSettingsViewClose();
	call wifisettingsviewclose
; 152                         if ((a = WifiStateViewSSIDIsConnected) == 0) {
	ld a, (wifistateviewssidisconnected)
	or a
	jp nz, l_573
; 153                             needSsidConnect();
	call needssidconnect
; 154                             ThreadsTickNow();
	call threadsticknow
l_573:
	jp l_572
l_571:
; 155                         }
; 156                     } else if ((a = WiFiSettingsViewSelectPos) == 1) { // Выбор SSID
	ld a, (wifisettingsviewselectpos)
	cp 1
	jp nz, l_575
; 157                         WiFiNetworksViewShow();
	call wifinetworksviewshow
	jp l_576
l_575:
; 158                     } else { // Переход в редактирование
; 159                         WiFiSettingsViewByPosBoxValue();
	call wifisettingsviewbyposboxvalue
; 160                         WiFiSettingsViewByPosValue();
	call wifisettingsviewbyposvalue
; 161                         EditFieldViewShow();
	call editfieldviewshow
; 162                         if (a == 1) { // что то изменилось
	cp 1
	jp nz, l_577
; 163                             #ifdef _IS_SIMULATOR
; 164 
; 165                             #else
; 166                                 ThreadsNetPasswordUpdate();
	call threadsnetpasswordupdate
; 167                             #endif
; 168                             WiFiSettingsViewShowValue();
	call wifisettingsviewshowvalue
l_577:
l_576:
l_572:
	jp l_570
l_569:
; 169                         }
; 170                     }
; 171                 } else if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, l_579
; 172                     WiFiSettingsViewPosUpdateA(a = 0x01);
	ld a, 1
	call wifisettingsviewposupdatea
	jp l_580
l_579:
; 173                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, l_581
; 174                     WiFiSettingsViewPosUpdateA(a = 0xFF);
	ld a, 255
	call wifisettingsviewposupdatea
l_581:
l_580:
l_570:
l_568:
l_565:
l_563:
	pop hl
	ret
; 175                 }
; 176             }
; 177         }
; 178     }
; 179 }
; 180 
; 181 /// вых [BC] -
; 182 void WiFiSettingsViewByPosValue() {
wifisettingsviewbyposvalue:
; 183     push_pop(hl) {
	push hl
; 184         if ((a = WiFiSettingsViewSelectPos) == 2) {
	ld a, (wifisettingsviewselectpos)
	cp 2
	jp nz, l_583
; 185             bc = WifiStateViewPassVal;
	ld bc, wifistateviewpassval
	jp l_584
l_583:
; 186         } else {
; 187             bc = 0;
	ld bc, 0
l_584:
	pop hl
	ret
; 188         }        
; 189     }
; 190 }
; 191 
; 192 /// вых [HL] -
; 193 /// вых [DE]-
; 194 void WiFiSettingsViewByPosBoxValue() {
wifisettingsviewbyposboxvalue:
; 195     push_pop(bc) {
	push bc
; 196         // HL
; 197         a = WiFiSettingsViewSelectPos;
	ld a, (wifisettingsviewselectpos)
; 198         b = a;
	ld b, a
; 199         a = WiFiSettingsViewY;
	ld a, (wifisettingsviewy)
; 200         a += 3;
	add 3
; 201         a += b;
	add b
; 202         l = a;
	ld l, a
; 203         a = WiFiSettingsViewX;
	ld a, (wifisettingsviewx)
; 204         a += 7;
	add 7
; 205         h = a;
	ld h, a
; 206         // DE
; 207         a = WiFiSettingsViewDX;
	ld a, (wifisettingsviewdx)
; 208         a -= 8;
	sub 8
; 209         d = a;
	ld d, a
; 210         a = 1;
	ld a, 1
; 211         e = a;
	ld e, a
	pop bc
	ret
; 212     }
; 213 }
; 214 
; 215 /// Рисование линии прямым или инверсным цветом
; 216 /// 0 - прямой
; 217 /// 1 - инверсный
; 218 void WiFiSettingsViewSelectLineA() {
wifisettingsviewselectlinea:
; 219     push_pop(bc, hl) {
	push bc
	push hl
; 220         c = a;
	ld c, a
; 221         // 0 - Button
; 222         if ((a = WiFiSettingsViewSelectPos) == 0) {
	ld a, (wifisettingsviewselectpos)
	or a
	jp nz, l_585
; 223             ButtonShadowViewSelectA(a = c);
	ld a, c
	call buttonshadowviewselecta
	jp l_586
l_585:
; 224         } else {
; 225             WiFiSettingsViewByPosBoxValue();
	call wifisettingsviewbyposboxvalue
; 226             // C
; 227             if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_587
; 228                 a = WiFiSettingsViewColor;
	ld a, (wifisettingsviewcolor)
	jp l_588
l_587:
; 229             } else {
; 230                 a = WiFiSettingsViewInvColor;
	ld a, (wifisettingsviewinvcolor)
l_588:
; 231             }
; 232             c = a;
	ld c, a
; 233             // A
; 234             a = vboxUMP;
	ld a, 4
; 235             vboxOpenHLDECA();
	call vboxopenhldeca
l_586:
	pop hl
	pop bc
	ret
; 236         }
; 237     }
; 238 }
; 239 
; 240 /// Обновление позиции
; 241 /// вх[A]
; 242 /// 0 - без изменений
; 243 /// 1 - вверх
; 244 /// 0xFF - вниз
; 245 void WiFiSettingsViewPosUpdateA() {
wifisettingsviewposupdatea:
; 246     push_pop(bc) {
	push bc
; 247         b = a;
	ld b, a
; 248         if (a == 0) {
	or a
	jp nz, l_589
; 249             WiFiSettingsViewSelectLineA(a = 1);
	ld a, 1
	call wifisettingsviewselectlinea
	jp l_590
l_589:
; 250         } else {
; 251             a = 3;
	ld a, 3
; 252             c = a;
	ld c, a
; 253             WiFiSettingsViewSelectLineA(a = 0);
	ld a, 0
	call wifisettingsviewselectlinea
; 254             a = WiFiSettingsViewSelectPos;
	ld a, (wifisettingsviewselectpos)
; 255             a += b;
	add b
; 256             //-- FIX
; 257             if (a == 0xFF) {
	cp 255
	jp nz, l_591
; 258                 a = c;
	ld a, c
; 259                 a--;
	dec a
	jp l_592
l_591:
; 260             } else if (a == c) {
	cp c
	jp nz, l_593
; 261                 a = 0;
	ld a, 0
l_593:
l_592:
; 262             }
; 263             //--
; 264             WiFiSettingsViewSelectPos = a;
	ld (wifisettingsviewselectpos), a
; 265             WiFiSettingsViewSelectLineA(a = 1);
	ld a, 1
	call wifisettingsviewselectlinea
l_590:
	pop bc
	ret
; 266         }
; 267     }
; 268 }
; 269 
; 270 uint8_t WiFiSettingsViewX = 11;
wifisettingsviewx:
	db 11
; 271 uint8_t WiFiSettingsViewY = 10;
wifisettingsviewy:
	db 10
; 272 uint8_t WiFiSettingsViewDX = 27;
wifisettingsviewdx:
	db 27
; 273 uint8_t WiFiSettingsViewDY = 13;
wifisettingsviewdy:
	db 13
; 274 uint8_t WiFiSettingsViewColor = 0x70;
wifisettingsviewcolor:
	db 112
; 275 uint8_t WiFiSettingsViewInvColor = 0x07;
wifisettingsviewinvcolor:
	db 7
; 277 uint8_t WiFiSettingsViewSelectPos = 0;
wifisettingsviewselectpos:
	db 0
; 279 uint8_t WiFiSettingsViewTitle[] = "Wi-Fi settings";
wifisettingsviewtitle:
	db 87
	db 105
	db 45
	db 70
	db 105
	db 32
	db 115
	db 101
	db 116
	db 116
	db 105
	db 110
	db 103
	db 115
	ds 1
; 280 uint8_t WiFiSettingsViewTitlePass[] = "Pass:";
wifisettingsviewtitlepass:
	db 80
	db 97
	db 115
	db 115
	db 58
	ds 1
; 281 uint8_t WiFiSettingsViewTitleMac[] =  " MAC:";
wifisettingsviewtitlemac:
	db 32
	db 77
	db 65
	db 67
	db 58
	ds 1
; 282 uint8_t WiFiSettingsViewButtonTitle[] = "Connect";
wifisettingsviewbuttontitle:
	db 67
	db 111
	db 110
	db 110
	db 101
	db 99
	db 116
	ds 1
; 14 void EditFieldViewShow() {
editfieldviewshow:
; 15     CurrentViewChangeAndPushIdA(a = EditFieldViewId);
	ld a, 6
	call currentviewchangeandpushida
; 16     //-- clear
; 17     a = 0;
	ld a, 0
; 18     EditFieldViewTextIsChanged = a;
	ld (editfieldviewtextischanged), a
; 19     //-- Save
; 20     a = h;
	ld a, h
; 21     EditFieldViewX = a;
	ld (editfieldviewx), a
; 22     a = l;
	ld a, l
; 23     EditFieldViewY = a;
	ld (editfieldviewy), a
; 24     a = d;
	ld a, d
; 25     EditFieldViewDX = a;
	ld (editfieldviewdx), a
; 26     a = e;
	ld a, e
; 27     EditFieldViewDY = a;
	ld (editfieldviewdy), a
; 28     //--
; 29     push_pop(bc) {
	push bc
; 30         a = EditFieldViewColor;
	ld a, (editfieldviewcolor)
; 31         c = a;
	ld c, a
; 32         // A
; 33         a = vboxCLW
	ld a, 64
; 34         a |= vboxSAV
	or 8
; 35         a |= vboxUMP;
	or 4
; 36         vboxOpenHLDECA();
	call vboxopenhldeca
	pop bc
; 37     }
; 38     // Save text point
; 39     h = b;
	ld h, b
; 40     l = c;
	ld l, c
; 41     EditFieldViewTextPoint = hl;
	ld (editfieldviewtextpoint), hl
; 42     //-- Copy text to edit
; 43     EditFieldViewTextCopy();
	call editfieldviewtextcopy
; 44     //--
; 45     EditFieldViewShowTextValue();
	call editfieldviewshowtextvalue
; 46     //--
; 47     EditFieldViewLoopKey();
	jp editfieldviewloopkey
; 48 }
; 49 
; 50 void EditFieldViewClose() {
editfieldviewclose:
; 51     vboxClose();
	call vboxclose
; 52     CurrentViewReturn();
	call currentviewreturn
; 53     a = EditFieldViewTextIsChanged;
	ld a, (editfieldviewtextischanged)
	ret
; 54 }
; 55 
; 56 void EditFieldViewLoopKey() {
editfieldviewloopkey:
; 57     push_pop(bc, de) {
	push bc
	push de
; 58         b = 0;
	ld b, 0
; 59         do {
l_595:
; 60             getKeyboardCharA();
	call getkeyboardchara
; 61             c = a;
	ld c, a
; 62             if ((a = c) == 0x1B) { //ESC выход
	ld a, c
	cp 27
	jp nz, l_598
; 63                 b = 1;
	ld b, 1
	jp l_599
l_598:
; 64             } else if ((a = c) == 0x7F) { //Забой... (удаление символа)
	ld a, c
	cp 127
	jp nz, l_600
; 65                 a = EditFieldViewEditTextPos;
	ld a, (editfieldviewedittextpos)
; 66                 if (a > 0) {
	or a
	jp z, l_602
; 67                     a--;
	dec a
; 68                     EditFieldViewEditTextPos = a;
	ld (editfieldviewedittextpos), a
l_602:
; 69                 }
; 70                 EditFieldViewShowTextValue();
	call editfieldviewshowtextvalue
	jp l_601
l_600:
; 71             } else if ((a = c) == 0x0D) { // Сохранить и выйти из редактирования
	ld a, c
	cp 13
	jp nz, l_604
; 72                 a = 1;
	ld a, 1
; 73                 EditFieldViewTextIsChanged = a;
	ld (editfieldviewtextischanged), a
; 74                 EditFieldViewTextSave();
	call editfieldviewtextsave
; 75                 b = 1;
	ld b, 1
	jp l_605
l_604:
; 76             } else if ((a = c) < 0x20) { // ничего не делаем
	ld a, c
	cp 32
	jp nc, l_606
	jp l_607
l_606:
; 77                 
; 78             } else {
; 79                 a = EditFieldViewEditTextPos;
	ld a, (editfieldviewedittextpos)
; 80                 if (a < 15) {
	cp 15
	jp nc, l_608
; 81                     d = 0;
	ld d, 0
; 82                     e = a;
	ld e, a
; 83                     hl = EditFieldViewEditText;
	ld hl, editfieldviewedittext
; 84                     hl += de;
	add hl, de
; 85                     a = c;
	ld a, c
; 86                     convertKeyToMyFontA(); // перевести данные
	call convertkeytomyfonta
; 87                     *hl = a;
	ld (hl), a
; 88                     //--
; 89                     a = EditFieldViewEditTextPos;
	ld a, (editfieldviewedittextpos)
; 90                     a++;
	inc a
; 91                     EditFieldViewEditTextPos = a;
	ld (editfieldviewedittextpos), a
; 92                     //--
; 93                     EditFieldViewShowTextValue();
	call editfieldviewshowtextvalue
l_608:
l_607:
l_605:
l_601:
l_599:
l_596:
; 94                 }
; 95             }
; 96         } while ((a = b) == 0);
	ld a, b
	or a
	jp z, l_595
	pop de
	pop bc
; 97     }
; 98     EditFieldViewClose();
	jp editfieldviewclose
; 99 }
; 100 
; 101 void EditFieldViewShowTextValue() {
editfieldviewshowtextvalue:
; 102     push_pop(bc, hl) {
	push bc
	push hl
; 103         //-- POS
; 104         a = EditFieldViewX;
	ld a, (editfieldviewx)
; 105         a += 1;
	add 1
; 106         myCharPosX = a;
	ld (mycharposx), a
; 107         a = EditFieldViewY;
	ld a, (editfieldviewy)
; 108         myCharPosY = a;
	ld (mycharposy), a
; 109         //--
; 110         a = EditFieldViewEditTextPos;
	ld a, (editfieldviewedittextpos)
; 111         b = a;
	ld b, a
; 112         c = a;
	ld c, a
; 113         hl = EditFieldViewEditText;
	ld hl, editfieldviewedittext
; 114         if ((a = b) > 0) {
	ld a, b
	or a
	jp z, l_610
; 115             do {
l_612:
; 116                 printMyChatA(a = *hl);
	ld a, (hl)
	call printmychata
; 117                 hl++;
	inc hl
; 118                 c--;
	dec c
l_613:
; 119             } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, l_612
l_610:
; 120         }
; 121         // Clear
; 122         a = 16; // Max char array
	ld a, 16
; 123         a -= b;
	sub b
; 124         c = a;
	ld c, a
; 125         do {
l_615:
; 126             printMyChatA(a = ' ');
	ld a, 32
	call printmychata
; 127             c--;
	dec c
l_616:
; 128         } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, l_615
	pop hl
	pop bc
	ret
; 129         
; 130     }
; 131 }
; 132 
; 133 void EditFieldViewTextCopy() {
editfieldviewtextcopy:
; 134     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 135         hl = EditFieldViewTextPoint;
	ld hl, (editfieldviewtextpoint)
; 136         de = EditFieldViewEditText;
	ld de, editfieldviewedittext
; 137         c = 1;
	ld c, 1
; 138         b = 0;
	ld b, 0
; 139         do {
l_618:
; 140             a = *hl;
	ld a, (hl)
; 141             if (a > 0) {
	or a
	jp z, l_621
; 142                 b++;
	inc b
; 143                 *de = a;
	ld (de), a
; 144                 hl++;
	inc hl
; 145                 de++;
	inc de
	jp l_622
l_621:
; 146             } else {
; 147                 a = b;
	ld a, b
; 148                 EditFieldViewEditTextPos = a;
	ld (editfieldviewedittextpos), a
; 149                 c = 0;
	ld c, 0
l_622:
l_619:
; 150             }
; 151         } while ((a = c) == 1);
	ld a, c
	cp 1
	jp z, l_618
	pop hl
	pop de
	pop bc
	ret
; 152     }
; 153 }
; 154 
; 155 void EditFieldViewTextSave() {
editfieldviewtextsave:
; 156     a = EditFieldViewEditTextPos;
	ld a, (editfieldviewedittextpos)
; 157     if (a == 0) {
	or a
	jp nz, l_623
; 158         push_pop(hl) {
	push hl
; 159             hl = EditFieldViewTextPoint;
	ld hl, (editfieldviewtextpoint)
; 160             *hl = 0;
	ld (hl), 0
	pop hl
	jp l_624
l_623:
; 161         }
; 162     } else {
; 163         push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 164             b = a;
	ld b, a
; 165             de = EditFieldViewEditText;
	ld de, editfieldviewedittext
; 166             hl = EditFieldViewTextPoint;
	ld hl, (editfieldviewtextpoint)
; 167             do {
l_625:
; 168                 a = *de;
	ld a, (de)
; 169                 *hl = a;
	ld (hl), a
; 170                 hl++;
	inc hl
; 171                 de++;
	inc de
; 172                 b--;
	dec b
l_626:
; 173             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_625
; 174             *hl = 0;
	ld (hl), 0
	pop hl
	pop de
	pop bc
l_624:
	ret
; 175         }
; 176     }
; 177 }
; 178 
; 179 uint8_t EditFieldViewX = 0;
editfieldviewx:
	db 0
; 180 uint8_t EditFieldViewY = 0;
editfieldviewy:
	db 0
; 181 uint8_t EditFieldViewDX = 0;
editfieldviewdx:
	db 0
; 182 uint8_t EditFieldViewDY = 0;
editfieldviewdy:
	db 0
; 183 uint8_t EditFieldViewColor = 0xA0; //0xF0;
editfieldviewcolor:
	db 160
; 185 uint16_t EditFieldViewTextPoint = 0;
editfieldviewtextpoint:
	dw 0
; 186 uint8_t EditFieldViewEditText[16];
editfieldviewedittext:
	ds 16
; 187 uint8_t EditFieldViewEditTextPos = 0;
editfieldviewedittextpos:
	db 0
; 189 uint8_t EditFieldViewTextIsChanged = 0;
editfieldviewtextischanged:
	db 0
; 11 void WiFiNetworksViewShow() {
wifinetworksviewshow:
; 12     CurrentViewChangeAndPushIdA(a = WiFiNetworksViewId);
	ld a, 7
	call currentviewchangeandpushida
; 13     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 14         a = WiFiNetworksViewX;
	ld a, (wifinetworksviewx)
; 15         h = a;
	ld h, a
; 16         a = WiFiNetworksViewY;
	ld a, (wifinetworksviewy)
; 17         l = a;
	ld l, a
; 18         a = WiFiNetworksViewDX;
	ld a, (wifinetworksviewdx)
; 19         d = a;
	ld d, a
; 20         a = WiFiNetworksViewDY;
	ld a, (wifinetworksviewdy)
; 21         e = a;
	ld e, a
; 22         a = WiFiNetworksViewColor;
	ld a, (wifinetworksviewcolor)
; 23         c = a;
	ld c, a
; 24         a = vboxCLW;
	ld a, 64
; 25         a |= vboxFRM;
	or 32
; 26         a |= vboxSDW;
	or 16
; 27         a |= vboxSAV;
	or 8
; 28         a |= vboxUMP;
	or 4
; 29         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop hl
	pop bc
; 30     }
; 31     WiFiNetworksViewShowTitle();
	call wifinetworksviewshowtitle
; 32     WiFiNetworksViewUpdateList();
; 33 }
; 34 
; 35 void WiFiNetworksViewUpdateList() {
wifinetworksviewupdatelist:
; 36     WiFiNetworksViewSelectLineA(a = 0);
	ld a, 0
	call wifinetworksviewselectlinea
; 37     #ifdef _IS_SIMULATOR
; 38 
; 39     #else
; 40         WiFiNetworksViewClearData();
	call wifinetworksviewcleardata
; 41         needUpdateSSIDList();
	call needupdatessidlist
; 42         getSsidList();
	call getssidlist
; 43         WiFiNetworksViewFixData();
	call wifinetworksviewfixdata
; 44     #endif
; 45     WiFiNetworksViewShowList();
	call wifinetworksviewshowlist
; 46     a = 0;
	ld a, 0
; 47     WiFiNetworksViewSelectPos = a;
	ld (wifinetworksviewselectpos), a
; 48     WiFiNetworksViewSelectLineA(a = 1);
	ld a, 1
	jp wifinetworksviewselectlinea
; 49 }
; 50 
; 51 void WiFiNetworksViewFixData() {
wifinetworksviewfixdata:
; 52     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 53         hl = WiFiNetworksViewSSIDList;
	ld hl, wifinetworksviewssidlist
; 54         de = 16;
	ld de, 16
; 55         b = 16;
	ld b, 16
; 56         do {
l_628:
; 57             a = *hl;
	ld a, (hl)
; 58             if (a == 0) {
	or a
	jp nz, l_631
; 59                 a = '-';
	ld a, 45
; 60                 *hl = a;
	ld (hl), a
l_631:
; 61             }
; 62             hl += de;
	add hl, de
; 63             b--;
	dec b
l_629:
; 64         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_628
	pop de
	pop bc
	pop hl
	ret
; 65     }
; 66 }
; 67 
; 68 void WiFiNetworksViewShowTitle() {
wifinetworksviewshowtitle:
; 69     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 70         // Title
; 71         a = WiFiNetworksViewX;
	ld a, (wifinetworksviewx)
; 72         a += 3;
	add 3
; 73         myCharPosX = a;
	ld (mycharposx), a
; 74         a = WiFiNetworksViewY;
	ld a, (wifinetworksviewy)
; 75         a += 1; //2;
	add 1
; 76         myCharPosY = a;
	ld (mycharposy), a
; 77         printMyHLStr(hl = WiFiNetworksViewTitle);
	ld hl, wifinetworksviewtitle
	call printmyhlstr
; 78         // LINE!!!
; 79         a = WiFiNetworksViewX;
	ld a, (wifinetworksviewx)
; 80         a += 1;
	add 1
; 81         myCharPosX = a;
	ld (mycharposx), a
; 82         a = WiFiNetworksViewY;
	ld a, (wifinetworksviewy)
; 83         a += 2;
	add 2
; 84         myCharPosY = a;
	ld (mycharposy), a
; 85         a = WiFiNetworksViewDX;
	ld a, (wifinetworksviewdx)
; 86         a -= 2;
	sub 2
; 87         b = a;
	ld b, a
; 88         do {
l_633:
; 89             printMyChatA(a = 0x5F);
	ld a, 95
	call printmychata
; 90             b--;
	dec b
l_634:
; 91         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_633
	pop de
	pop bc
	pop hl
	ret
; 92     }
; 93 }
; 94 
; 95 void WiFiNetworksViewClose() {
wifinetworksviewclose:
; 96     vboxClose();
	call vboxclose
; 97     CurrentViewReturn();
	jp currentviewreturn
; 98 }
; 99 
; 100 void WiFiNetworksViewKeyA() {
wifinetworksviewkeya:
; 101     push_pop(hl) {
	push hl
; 102         l = a;
	ld l, a
; 103         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_636
; 104             if ((a = CurrentViewId) == WiFiNetworksViewId) {
	ld a, (currentviewid)
	cp 7
	jp nz, l_638
; 105                 if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, l_640
; 106                     WiFiNetworksViewClose();
	call wifinetworksviewclose
	jp l_641
l_640:
; 107                 } else if ((a = l) == 0x0D) { // Выбор
	ld a, l
	cp 13
	jp nz, l_642
; 108                     WiFiNetworksViewClose();
	call wifinetworksviewclose
; 109                     //--
; 110                     #ifdef _IS_SIMULATOR
; 111                         WiFiNetworksViewCopySSIDForSimulator();
; 112                     #else
; 113                         ThreadsNetSsidUpdateA(a = WiFiNetworksViewSelectPos);
	ld a, (wifinetworksviewselectpos)
	call threadsnetssidupdatea
; 114                     #endif
; 115                     WiFiSettingsViewShowValue();
	call wifisettingsviewshowvalue
	jp l_643
l_642:
; 116                     //--
; 117                 } else if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, l_644
; 118                     WiFiNetworksViewPosUpdateA(a = 0x01);
	ld a, 1
	call wifinetworksviewposupdatea
	jp l_645
l_644:
; 119                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, l_646
; 120                     WiFiNetworksViewPosUpdateA(a = 0xFF);
	ld a, 255
	call wifinetworksviewposupdatea
l_646:
l_645:
l_643:
l_641:
l_638:
l_636:
	pop hl
	ret
; 121                 }
; 122             }
; 123         }
; 124     }
; 125 }
; 126 
; 127 void WiFiNetworksViewCopySSIDForSimulator() {
wifinetworksviewcopyssidforsimul:
; 128     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 129         hl = WiFiNetworksViewSSIDList;
	ld hl, wifinetworksviewssidlist
; 130         a = WiFiNetworksViewSelectPos;
	ld a, (wifinetworksviewselectpos)
; 131         a &= 0x0F;
	and 15
; 132         cyclic_rotate_left(a, 4);
	rlca
	rlca
	rlca
	rlca
; 133         e = a;
	ld e, a
; 134         d = 0;
	ld d, 0
; 135         hl += de;
	add hl, de
; 136         de = WifiStateViewSsidVal;
	ld de, wifistateviewssidval
; 137         //-- Copy
; 138         b = 16;
	ld b, 16
; 139         c = 0; // is 0 exist
	ld c, 0
; 140         do {
l_648:
; 141             a = *hl;
	ld a, (hl)
; 142             *de = a;
	ld (de), a
; 143             if (a == 0) {
	or a
	jp nz, l_651
; 144                 c = 1;
	ld c, 1
l_651:
; 145             }
; 146             hl++;
	inc hl
; 147             de++;
	inc de
; 148             b--;
	dec b
l_649:
; 149         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_648
; 150         //-- if stop byte (0)
; 151         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_653
; 152             de--;
	dec de
; 153             a = 0;
	ld a, 0
; 154             *de = a;
	ld (de), a
l_653:
	pop de
	pop bc
	pop hl
	ret
; 155         }
; 156     }
; 157 }
; 158 
; 159 void WiFiNetworksViewClearData() {
wifinetworksviewcleardata:
; 160     push_pop(hl, bc) {
	push hl
	push bc
; 161         hl = WiFiNetworksViewSSIDList;
	ld hl, wifinetworksviewssidlist
; 162         b = 0xFF;
	ld b, 255
; 163         do {
l_655:
; 164             *hl = 0;
	ld (hl), 0
; 165             hl++;
	inc hl
; 166             b--;
	dec b
l_656:
; 167         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_655
	pop bc
	pop hl
	ret
; 168     }
; 169 }
; 170 
; 171 void WiFiNetworksViewShowList() {
wifinetworksviewshowlist:
; 172     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 173         hl = WiFiNetworksViewSSIDList;
	ld hl, wifinetworksviewssidlist
; 174         c = 0;
	ld c, 0
; 175         //
; 176         a = WiFiNetworksViewX;
	ld a, (wifinetworksviewx)
; 177         a += 2;
	add 2
; 178         d = a; // X
	ld d, a
; 179         a = WiFiNetworksViewY;
	ld a, (wifinetworksviewy)
; 180         a += 5;
	add 5
; 181         e = a; // Y
	ld e, a
; 182         //
; 183         do {
l_658:
; 184             //--
; 185             a = e;
	ld a, e
; 186             a += c;
	add c
; 187             myCharPosY = a;
	ld (mycharposy), a
; 188             a = d;
	ld a, d
; 189             myCharPosX = a;
	ld (mycharposx), a
; 190             //--
; 191             b = 16;
	ld b, 16
; 192             do {
l_661:
; 193                 printMyChatA(a = *hl);
	ld a, (hl)
	call printmychata
; 194                 hl++;
	inc hl
; 195                 b--;
	dec b
l_662:
; 196             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_661
; 197             c++;
	inc c
l_659:
; 198         } while ((a = WiFiNetworksViewSSIDCount) >= c);
	ld a, (wifinetworksviewssidcount)
	cp c
	jp nc, l_658
; 199         // Crean
; 200         a = WiFiNetworksViewSSIDCount;
	ld a, (wifinetworksviewssidcount)
; 201         c = a;
	ld c, a
; 202         a = 16; // Максимальное число строк
	ld a, 16
; 203         a -= c;
	sub c
; 204         if (a > 0) { // До добавляем пустые строки
	or a
	jp z, l_664
; 205             b = a;
	ld b, a
; 206             //--
; 207             a = WiFiNetworksViewSSIDCount;
	ld a, (wifinetworksviewssidcount)
; 208             a += e;
	add e
; 209             e = a;
	ld e, a
; 210             //--
; 211             h = 0;
	ld h, 0
; 212             do {
l_666:
; 213                 //--
; 214                 a = e;
	ld a, e
; 215                 a += h;
	add h
; 216                 myCharPosY = a;
	ld (mycharposy), a
; 217                 a = d;
	ld a, d
; 218                 myCharPosX = a;
	ld (mycharposx), a
; 219                 //--
; 220                 c = 16;
	ld c, 16
; 221                 do {
l_669:
; 222                     printMyChatA(a = ' ');
	ld a, 32
	call printmychata
; 223                     c--;
	dec c
l_670:
; 224                 } while ((a = c) > 0);
	ld a, c
	or a
	jp nz, l_669
; 225                 b--;
	dec b
; 226                 h++;
	inc h
l_667:
; 227             } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_666
l_664:
	pop de
	pop bc
	pop hl
	ret
; 228         }
; 229     }
; 230 }
; 231 
; 232 /// Обновление позиции
; 233 /// вх[A]
; 234 /// 0 - без изменений
; 235 /// 1 - вверх
; 236 /// 0xFF - вниз
; 237 void WiFiNetworksViewPosUpdateA() {
wifinetworksviewposupdatea:
; 238     push_pop(bc) {
	push bc
; 239         b = a;
	ld b, a
; 240         if (a == 0) {
	or a
	jp nz, l_672
; 241             WiFiNetworksViewSelectLineA(a = 1);
	ld a, 1
	call wifinetworksviewselectlinea
	jp l_673
l_672:
; 242         } else {
; 243             a = WiFiNetworksViewSSIDCount;
	ld a, (wifinetworksviewssidcount)
; 244             c = a;
	ld c, a
; 245             WiFiNetworksViewSelectLineA(a = 0);
	ld a, 0
	call wifinetworksviewselectlinea
; 246             if ((a = c) == 0) { // нет ни одной записи
	ld a, c
	or a
	jp nz, l_674
; 247                 a = 0;
	ld a, 0
; 248                 WiFiNetworksViewSelectPos = a;
	ld (wifinetworksviewselectpos), a
	jp l_675
l_674:
; 249             } else { // если есть хоть одна запись
; 250                 a = WiFiNetworksViewSelectPos;
	ld a, (wifinetworksviewselectpos)
; 251                 a += b;
	add b
; 252                 //-- FIX
; 253                 if (a == 0xFF) {
	cp 255
	jp nz, l_676
; 254                     a = c;
	ld a, c
; 255                     a--;
	dec a
	jp l_677
l_676:
; 256                 } else if (a == c) {
	cp c
	jp nz, l_678
; 257                     a = 0;
	ld a, 0
l_678:
l_677:
; 258                 }
; 259                 //--
; 260                 WiFiNetworksViewSelectPos = a;
	ld (wifinetworksviewselectpos), a
l_675:
; 261             }
; 262             WiFiNetworksViewSelectLineA(a = 1);
	ld a, 1
	call wifinetworksviewselectlinea
l_673:
	pop bc
	ret
; 263         }
; 264     }
; 265 }
; 266 
; 267 /// Рисование линии прямым или инверсным цветом
; 268 /// 0 - прямой
; 269 /// 1 - инверсный
; 270 void WiFiNetworksViewSelectLineA() {
wifinetworksviewselectlinea:
; 271     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 272         c = a;
	ld c, a
; 273         //--
; 274         a = WiFiNetworksViewSelectPos;
	ld a, (wifinetworksviewselectpos)
; 275         b = a;
	ld b, a
; 276         //--
; 277         a = WiFiNetworksViewX;
	ld a, (wifinetworksviewx)
; 278         a += 1;
	add 1
; 279         h = a; // X
	ld h, a
; 280         a = WiFiNetworksViewY;
	ld a, (wifinetworksviewy)
; 281         a += 5;
	add 5
; 282         a += b;
	add b
; 283         l = a; // Y
	ld l, a
; 284         //--
; 285         a = WiFiNetworksViewDX;
	ld a, (wifinetworksviewdx)
; 286         a -= 2;
	sub 2
; 287         d = a;
	ld d, a
; 288         e = 1;
	ld e, 1
; 289         //--
; 290         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_680
; 291             a = WiFiNetworksViewColor;
	ld a, (wifinetworksviewcolor)
	jp l_681
l_680:
; 292         } else {
; 293             a = WiFiNetworksViewInvColor;
	ld a, (wifinetworksviewinvcolor)
l_681:
; 294         }
; 295         c = a;
	ld c, a
; 296         //--
; 297         a = vboxUMP;
	ld a, 4
; 298         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop hl
	pop bc
	ret
; 299     }
; 300 }
; 301 
; 302 uint8_t WiFiNetworksViewX = 14; //21;
wifinetworksviewx:
	db 14
; 303 uint8_t WiFiNetworksViewY = 3;
wifinetworksviewy:
	db 3
; 304 uint8_t WiFiNetworksViewDX = 20;
wifinetworksviewdx:
	db 20
; 305 uint8_t WiFiNetworksViewDY = 23;
wifinetworksviewdy:
	db 23
; 306 uint8_t WiFiNetworksViewColor = 0x70;
wifinetworksviewcolor:
	db 112
; 307 uint8_t WiFiNetworksViewInvColor = 0x07;
wifinetworksviewinvcolor:
	db 7
; 309 uint8_t WiFiNetworksViewSelectPos = 0;
wifinetworksviewselectpos:
	db 0
; 311 uint8_t WiFiNetworksViewTitle[] = "Wi-Fi Networks";
wifinetworksviewtitle:
	db 87
	db 105
	db 45
	db 70
	db 105
	db 32
	db 78
	db 101
	db 116
	db 119
	db 111
	db 114
	db 107
	db 115
	ds 1
; 334 uint8_t WiFiNetworksViewSSIDCount = 0;
wifinetworksviewssidcount:
	db 0
; 335 uint8_t WiFiNetworksViewSSIDList[16*16] = {
wifinetworksviewssidlist:
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
; 11 void FtpSettingsViewShow() {
ftpsettingsviewshow:
; 12     push_pop(bc, hl, de) {
	push bc
	push hl
	push de
; 13         CurrentViewChangeAndPushIdA(a = FtpSettingsViewId);
	ld a, 8
	call currentviewchangeandpushida
; 14         //--
; 15         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 16         h = a;
	ld h, a
; 17         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 18         l = a;
	ld l, a
; 19         a = FtpSettingsViewDX;
	ld a, (ftpsettingsviewdx)
; 20         d = a;
	ld d, a
; 21         a = FtpSettingsViewDY;
	ld a, (ftpsettingsviewdy)
; 22         e = a;
	ld e, a
; 23         a = FtpSettingsViewColor;
	ld a, (ftpsettingsviewcolor)
; 24         c = a;
	ld c, a
; 25         a = vboxCLW;
	ld a, 64
; 26         a |= vboxFRM;
	or 32
; 27         a |= vboxSDW;
	or 16
; 28         a |= vboxSAV;
	or 8
; 29         a |= vboxUMP;
	or 4
; 30         vboxOpenHLDECA();
	call vboxopenhldeca
	pop de
	pop hl
	pop bc
; 31     }
; 32     a = 0;
	ld a, 0
; 33     FtpSettingsViewSelectPos = a;
	ld (ftpsettingsviewselectpos), a
; 34     FtpSettingsViewShowTitle();
	call ftpsettingsviewshowtitle
; 35     FtpSettingsViewShowValue();
	call ftpsettingsviewshowvalue
; 36     FtpSettingsViewSelectLineA(a = 1);
	ld a, 1
	jp ftpsettingsviewselectlinea
; 37 }
; 38 
; 39 void FtpSettingsViewClose() {
ftpsettingsviewclose:
; 40     vboxClose();
	call vboxclose
; 41     CurrentViewReturn();
	jp currentviewreturn
; 42 }
; 43 
; 44 void FtpSettingsViewShowTitle() {
ftpsettingsviewshowtitle:
; 45     push_pop(hl, bc, de) {
	push hl
	push bc
	push de
; 46         // Title
; 47         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 48         a += 7;
	add 7
; 49         myCharPosX = a;
	ld (mycharposx), a
; 50         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 51         a += 1; //2;
	add 1
; 52         myCharPosY = a;
	ld (mycharposy), a
; 53         printMyHLStr(hl = FtpSettingsViewTitle);
	ld hl, ftpsettingsviewtitle
	call printmyhlstr
; 54         // LINE!!!
; 55         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 56         a += 1;
	add 1
; 57         myCharPosX = a;
	ld (mycharposx), a
; 58         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 59         a += 2;
	add 2
; 60         myCharPosY = a;
	ld (mycharposy), a
; 61         a = FtpSettingsViewDX;
	ld a, (ftpsettingsviewdx)
; 62         a -= 2;
	sub 2
; 63         b = a;
	ld b, a
; 64         do {
l_682:
; 65             printMyChatA(a = 0x5F);
	ld a, 95
	call printmychata
; 66             b--;
	dec b
l_683:
; 67         } while ((a = b) > 0);
	ld a, b
	or a
	jp nz, l_682
; 68         // IP
; 69         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 70         a += 2;
	add 2
; 71         b = a; // X
	ld b, a
; 72         myCharPosX = a;
	ld (mycharposx), a
; 73         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 74         a += 4;
	add 4
; 75         c = a; // Y
	ld c, a
; 76         myCharPosY = a;
	ld (mycharposy), a
; 77         printMyHLStr(hl = FtpSettingsViewTitleIP);
	ld hl, ftpsettingsviewtitleip
	call printmyhlstr
; 78         // PORT
; 79         a = b;
	ld a, b
; 80         myCharPosX = a;
	ld (mycharposx), a
; 81         a = c;
	ld a, c
; 82         a += 1;
	add 1
; 83         myCharPosY = a;
	ld (mycharposy), a
; 84         printMyHLStr(hl = FtpSettingsViewTitlePort);
	ld hl, ftpsettingsviewtitleport
	call printmyhlstr
; 85         // USER
; 86         a = b;
	ld a, b
; 87         myCharPosX = a;
	ld (mycharposx), a
; 88         a = c;
	ld a, c
; 89         a += 2;
	add 2
; 90         myCharPosY = a;
	ld (mycharposy), a
; 91         printMyHLStr(hl = FtpSettingsViewTitleUser);
	ld hl, ftpsettingsviewtitleuser
	call printmyhlstr
; 92         // PASS
; 93         a = b;
	ld a, b
; 94         myCharPosX = a;
	ld (mycharposx), a
; 95         a = c;
	ld a, c
; 96         a += 3;
	add 3
; 97         myCharPosY = a;
	ld (mycharposy), a
; 98         printMyHLStr(hl = WiFiSettingsViewTitlePass);
	ld hl, wifisettingsviewtitlepass
	call printmyhlstr
; 99         // HOME dir
; 100         a = b;
	ld a, b
; 101         myCharPosX = a;
	ld (mycharposx), a
; 102         a = c;
	ld a, c
; 103         a += 4;
	add 4
; 104         myCharPosY = a;
	ld (mycharposy), a
; 105         printMyHLStr(hl = FtpSettingsViewTitleHomeDir);
	ld hl, ftpsettingsviewtitlehomedir
	call printmyhlstr
; 106         // Button
; 107         if ((a = FtpStateViewStatus) == 0) {
	ld a, (ftpstateviewstatus)
	or a
	jp nz, l_685
; 108             bc = WiFiSettingsViewButtonTitle;
	ld bc, wifisettingsviewbuttontitle
	jp l_686
l_685:
; 109         } else {
; 110             bc = strOK;
	ld bc, strok
l_686:
; 111         }
; 112         
; 113         d = 13;
	ld d, 13
; 114         e = 3;
	ld e, 3
; 115         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 116         a += 7;
	add 7
; 117         h = a;
	ld h, a
; 118         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 119         a += 10;
	add 10
; 120         l = a;
	ld l, a
; 121         ButtonShadowViewShow();
	call buttonshadowviewshow
	pop de
	pop bc
	pop hl
	ret
; 122     }
; 123 }
; 124 
; 125 void FtpSettingsViewShowValue() {
ftpsettingsviewshowvalue:
; 126     push_pop(hl, bc) {
	push hl
	push bc
; 127         // IP
; 128         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 129         a += 8;
	add 8
; 130         b = a; // X
	ld b, a
; 131         myCharPosX = a;
	ld (mycharposx), a
; 132         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 133         a += 4;
	add 4
; 134         c = a; // Y
	ld c, a
; 135         myCharPosY = a;
	ld (mycharposy), a
; 136         a = 18;
	ld a, 18
; 137         printMyHLStrLenA(hl = FtpStateViewIpValue);
	ld hl, ftpstateviewipvalue
	call printmyhlstrlena
; 138         // PORT
; 139         a = b;
	ld a, b
; 140         myCharPosX = a;
	ld (mycharposx), a
; 141         a = c;
	ld a, c
; 142         a += 1;
	add 1
; 143         myCharPosY = a;
	ld (mycharposy), a
; 144         a = 18;
	ld a, 18
; 145         printMyHLStrLenA(hl = FtpSettingsViewValuePort);
	ld hl, ftpsettingsviewvalueport
	call printmyhlstrlena
; 146         // USER
; 147         a = b;
	ld a, b
; 148         myCharPosX = a;
	ld (mycharposx), a
; 149         a = c;
	ld a, c
; 150         a += 2;
	add 2
; 151         myCharPosY = a;
	ld (mycharposy), a
; 152         a = 18;
	ld a, 18
; 153         printMyHLStrLenA(hl = FtpSettingsViewValueUser);
	ld hl, ftpsettingsviewvalueuser
	call printmyhlstrlena
; 154         // PASS
; 155         a = b;
	ld a, b
; 156         myCharPosX = a;
	ld (mycharposx), a
; 157         a = c;
	ld a, c
; 158         a += 3;
	add 3
; 159         myCharPosY = a;
	ld (mycharposy), a
; 160         a = 18;
	ld a, 18
; 161         printMyHLPassLenA(hl = FtpSettingsViewValuePass);
	ld hl, ftpsettingsviewvaluepass
	call printmyhlpasslena
; 162         // HOME DIR
; 163         a = b;
	ld a, b
; 164         myCharPosX = a;
	ld (mycharposx), a
; 165         a = c;
	ld a, c
; 166         a += 4;
	add 4
; 167         myCharPosY = a;
	ld (mycharposy), a
; 168         a = 18;
	ld a, 18
; 169         printMyHLStrLenA(hl = FtpSettingsViewValueHomeDir);
	ld hl, ftpsettingsviewvaluehomedir
	call printmyhlstrlena
	pop bc
	pop hl
	ret
; 170     }
; 171 }
; 172 
; 173 /// вых [BC] -
; 174 void FtpSettingsViewByPosValue() {
ftpsettingsviewbyposvalue:
; 175     if ((a = FtpSettingsViewSelectPos) == 1) {
	ld a, (ftpsettingsviewselectpos)
	cp 1
	jp nz, l_687
; 176         bc = FtpStateViewIpValue;
	ld bc, ftpstateviewipvalue
	jp l_688
l_687:
; 177     } else if ((a = FtpSettingsViewSelectPos) == 2) {
	ld a, (ftpsettingsviewselectpos)
	cp 2
	jp nz, l_689
; 178         bc = FtpSettingsViewValuePort;
	ld bc, ftpsettingsviewvalueport
	jp l_690
l_689:
; 179     } else if ((a = FtpSettingsViewSelectPos) == 3) {
	ld a, (ftpsettingsviewselectpos)
	cp 3
	jp nz, l_691
; 180         bc = FtpSettingsViewValueUser;
	ld bc, ftpsettingsviewvalueuser
	jp l_692
l_691:
; 181     } else if ((a = FtpSettingsViewSelectPos) == 4) {
	ld a, (ftpsettingsviewselectpos)
	cp 4
	jp nz, l_693
; 182         bc = FtpSettingsViewValuePass;
	ld bc, ftpsettingsviewvaluepass
	jp l_694
l_693:
; 183     } else if ((a = FtpSettingsViewSelectPos) == 5) {
	ld a, (ftpsettingsviewselectpos)
	cp 5
	jp nz, l_695
; 184         bc = FtpSettingsViewValueHomeDir;
	ld bc, ftpsettingsviewvaluehomedir
	jp l_696
l_695:
; 185     } else {
; 186         bc = 0;
	ld bc, 0
l_696:
l_694:
l_692:
l_690:
l_688:
	ret
; 187     }
; 188 }
; 189 
; 190 /// вых [HL] -
; 191 /// вых [DE]-
; 192 void FtpSettingsViewByPosBoxValue() {
ftpsettingsviewbyposboxvalue:
; 193     push_pop(bc) {
	push bc
; 194         // HL
; 195         a = FtpSettingsViewSelectPos;
	ld a, (ftpsettingsviewselectpos)
; 196         b = a;
	ld b, a
; 197         a = FtpSettingsViewY;
	ld a, (ftpsettingsviewy)
; 198         a += 3;
	add 3
; 199         a += b;
	add b
; 200         l = a;
	ld l, a
; 201         a = FtpSettingsViewX;
	ld a, (ftpsettingsviewx)
; 202         a += 7;
	add 7
; 203         h = a;
	ld h, a
; 204         // DE
; 205         a = FtpSettingsViewDX;
	ld a, (ftpsettingsviewdx)
; 206         a -= 8;
	sub 8
; 207         d = a;
	ld d, a
; 208         a = 1;
	ld a, 1
; 209         e = a;
	ld e, a
	pop bc
	ret
; 210     }
; 211 }
; 212 
; 213 /// Обновление позиции
; 214 /// вх[A]
; 215 /// 0 - без изменений
; 216 /// 1 - вверх
; 217 /// 0xFF - вниз
; 218 void FtpSettingsViewPosUpdateA() {
ftpsettingsviewposupdatea:
; 219     push_pop(bc) {
	push bc
; 220         b = a;
	ld b, a
; 221         if (a == 0) {
	or a
	jp nz, l_697
; 222             FtpSettingsViewSelectLineA(a = 1);
	ld a, 1
	call ftpsettingsviewselectlinea
	jp l_698
l_697:
; 223         } else {
; 224             a = 6;
	ld a, 6
; 225             c = a;
	ld c, a
; 226             FtpSettingsViewSelectLineA(a = 0);
	ld a, 0
	call ftpsettingsviewselectlinea
; 227             a = FtpSettingsViewSelectPos;
	ld a, (ftpsettingsviewselectpos)
; 228             a += b;
	add b
; 229             b = a;
	ld b, a
; 230             //-- FIX
; 231             if ((a = b) == 0xFF) {
	ld a, b
	cp 255
	jp nz, l_699
; 232                 a = c;
	ld a, c
; 233                 a--;
	dec a
	jp l_700
l_699:
; 234             } else if ((a = b) == c) {
	ld a, b
	cp c
	jp nz, l_701
; 235                 a = 0;
	ld a, 0
l_701:
l_700:
; 236             }
; 237             //--
; 238             FtpSettingsViewSelectPos = a;
	ld (ftpsettingsviewselectpos), a
; 239             FtpSettingsViewSelectLineA(a = 1);
	ld a, 1
	call ftpsettingsviewselectlinea
l_698:
	pop bc
	ret
; 240         }
; 241     }
; 242 }
; 243 
; 244 /// Рисование линии прямым или инверсным цветом
; 245 /// 0 - прямой
; 246 /// 1 - инверсный
; 247 void FtpSettingsViewSelectLineA() {
ftpsettingsviewselectlinea:
; 248     push_pop(bc, hl) {
	push bc
	push hl
; 249         c = a;
	ld c, a
; 250         // 0 - Button
; 251         if ((a = FtpSettingsViewSelectPos) == 0) {
	ld a, (ftpsettingsviewselectpos)
	or a
	jp nz, l_703
; 252             ButtonShadowViewSelectA(a = c);
	ld a, c
	call buttonshadowviewselecta
	jp l_704
l_703:
; 253         } else {
; 254             FtpSettingsViewByPosBoxValue();
	call ftpsettingsviewbyposboxvalue
; 255             // C
; 256             if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_705
; 257                 a = FtpSettingsViewColor;
	ld a, (ftpsettingsviewcolor)
	jp l_706
l_705:
; 258             } else {
; 259                 a = FtpSettingsViewInvColor;
	ld a, (ftpsettingsviewinvcolor)
l_706:
; 260             }
; 261             c = a;
	ld c, a
; 262             // A
; 263             a = vboxUMP;
	ld a, 4
; 264             vboxOpenHLDECA();
	call vboxopenhldeca
l_704:
	pop hl
	pop bc
	ret
; 265         }
; 266     }
; 267 }
; 268 
; 269 void FtpSettingsViewKeyA() {
ftpsettingsviewkeya:
; 270     push_pop(hl) {
	push hl
; 271         l = a;
	ld l, a
; 272         if ((a = c) == 0) {
	ld a, c
	or a
	jp nz, l_707
; 273             if ((a = CurrentViewId) == FtpSettingsViewId) {
	ld a, (currentviewid)
	cp 8
	jp nz, l_709
; 274                 if ((a = l) == 0x1B) { //ESC выход
	ld a, l
	cp 27
	jp nz, l_711
; 275                     FtpSettingsViewClose();
	call ftpsettingsviewclose
	jp l_712
l_711:
; 276                 } else if ((a = l) == 0x0D) { // Выбор
	ld a, l
	cp 13
	jp nz, l_713
; 277                     if ((a = FtpSettingsViewSelectPos) == 0) { // OK
	ld a, (ftpsettingsviewselectpos)
	or a
	jp nz, l_715
; 278                         WiFiSettingsViewClose();
	call wifisettingsviewclose
; 279                         if ((a = FtpStateViewStatus) == 0) {
	ld a, (ftpstateviewstatus)
	or a
	jp nz, l_717
; 280                             needFtpConnect();
	call needftpconnect
; 281                             ThreadsTickNow();
	call threadsticknow
l_717:
	jp l_716
l_715:
; 282                         }
; 283                     } else { // Переход в редактирование
; 284                         FtpSettingsViewByPosBoxValue();
	call ftpsettingsviewbyposboxvalue
; 285                         FtpSettingsViewByPosValue();
	call ftpsettingsviewbyposvalue
; 286                         EditFieldViewShow();
	call editfieldviewshow
; 287                         if (a == 1) { // что то изменилось
	cp 1
	jp nz, l_719
; 288                             if ((a = FtpSettingsViewSelectPos) == 5) {
	ld a, (ftpsettingsviewselectpos)
	cp 5
	jp nz, l_721
; 289                                 ThreadsNetFtpHomeDirUpdate();
	call threadsnetftphomedirupdate
	jp l_722
l_721:
; 290                             } else if ((a = FtpSettingsViewSelectPos) == 3) {
	ld a, (ftpsettingsviewselectpos)
	cp 3
	jp nz, l_723
; 291                                 ThreadsNetFtpUserUpdate();
	call threadsnetftpuserupdate
	jp l_724
l_723:
; 292                             } else if ((a = FtpSettingsViewSelectPos) == 4) {
	ld a, (ftpsettingsviewselectpos)
	cp 4
	jp nz, l_725
; 293                                 ThreadsNetFtpPasswordUpdate();
	call threadsnetftppasswordupdate
	jp l_726
l_725:
; 294                             } else if ((a = FtpSettingsViewSelectPos) == 1) { // IP
	ld a, (ftpsettingsviewselectpos)
	cp 1
	jp nz, l_727
; 295                                 ThreadsNetFtpServerUrlUpdate();
	call threadsnetftpserverurlupdate
	jp l_728
l_727:
; 296                             } else if ((a = FtpSettingsViewSelectPos) == 2) { // PORT
	ld a, (ftpsettingsviewselectpos)
	cp 2
	jp nz, l_729
; 297                                 ThreadsNetFtpPortUpdate();
	call threadsnetftpportupdate
l_729:
l_728:
l_726:
l_724:
l_722:
; 298                             }
; 299                             FtpSettingsViewShowValue();
	call ftpsettingsviewshowvalue
l_719:
l_716:
	jp l_714
l_713:
; 300                         }
; 301                     }
; 302                 } else if ((a = l) == 0x1A) { //down
	ld a, l
	cp 26
	jp nz, l_731
; 303                     FtpSettingsViewPosUpdateA(a = 0x01);
	ld a, 1
	call ftpsettingsviewposupdatea
	jp l_732
l_731:
; 304                 } else if ((a = l) == 0x19) { //up
	ld a, l
	cp 25
	jp nz, l_733
; 305                     FtpSettingsViewPosUpdateA(a = 0xFF);
	ld a, 255
	call ftpsettingsviewposupdatea
l_733:
l_732:
l_714:
l_712:
l_709:
l_707:
	pop hl
	ret
; 306                 }
; 307             }
; 308         }
; 309     }
; 310 }
; 311 
; 312 uint8_t FtpSettingsViewX = 11;
ftpsettingsviewx:
	db 11
; 313 uint8_t FtpSettingsViewY = 9;
ftpsettingsviewy:
	db 9
; 314 uint8_t FtpSettingsViewDX = 27;
ftpsettingsviewdx:
	db 27
; 315 uint8_t FtpSettingsViewDY = 15;
ftpsettingsviewdy:
	db 15
; 316 uint8_t FtpSettingsViewColor = 0x70;
ftpsettingsviewcolor:
	db 112
; 317 uint8_t FtpSettingsViewInvColor = 0x07;
ftpsettingsviewinvcolor:
	db 7
; 319 uint8_t FtpSettingsViewSelectPos = 1; //0
ftpsettingsviewselectpos:
	db 1
; 321 uint8_t FtpSettingsViewTitle[] = "FTP settings";
ftpsettingsviewtitle:
	db 70
	db 84
	db 80
	db 32
	db 115
	db 101
	db 116
	db 116
	db 105
	db 110
	db 103
	db 115
	ds 1
; 322 uint8_t FtpSettingsViewTitleIP[] =      "  IP:";
ftpsettingsviewtitleip:
	db 32
	db 32
	db 73
	db 80
	db 58
	ds 1
; 323 uint8_t FtpSettingsViewTitlePort[] =    "Port:";
ftpsettingsviewtitleport:
	db 80
	db 111
	db 114
	db 116
	db 58
	ds 1
; 324 uint8_t FtpSettingsViewTitleHomeDir[] = "Home:";
ftpsettingsviewtitlehomedir:
	db 72
	db 111
	db 109
	db 101
	db 58
	ds 1
; 325 uint8_t FtpSettingsViewTitleUser[] = "User:";
ftpsettingsviewtitleuser:
	db 85
	db 115
	db 101
	db 114
	db 58
	ds 1
; 327 uint8_t FtpSettingsViewValuePort[16] = "21";
ftpsettingsviewvalueport:
	db 50
	db 49
	ds 14
; 328 uint8_t FtpSettingsViewValueUser[16] = "-";
ftpsettingsviewvalueuser:
	db 45
	ds 15
; 329 uint8_t FtpSettingsViewValuePass[16] = "-";
ftpsettingsviewvaluepass:
	db 45
	ds 15
; 330 uint8_t FtpSettingsViewValueHomeDir[16] = "/";
ftpsettingsviewvaluehomedir:
	db 47
	ds 15
; 1 unsigned char FONT_8_8_RUS[] = {
font_8_8_rus:
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 126
	db 129
	db 165
	db 129
	db 189
	db 153
	db 129
	db 126
	db 126
	db 255
	db 219
	db 255
	db 195
	db 231
	db 255
	db 126
	db 108
	db 254
	db 254
	db 254
	db 124
	db 56
	db 16
	db 0
	db 16
	db 56
	db 124
	db 254
	db 124
	db 56
	db 16
	db 0
	db 56
	db 124
	db 56
	db 254
	db 254
	db 214
	db 16
	db 56
	db 16
	db 16
	db 56
	db 124
	db 254
	db 124
	db 16
	db 56
	db 0
	db 0
	db 24
	db 60
	db 60
	db 24
	db 0
	db 0
	db 255
	db 255
	db 231
	db 195
	db 195
	db 231
	db 255
	db 255
	db 0
	db 60
	db 102
	db 66
	db 66
	db 102
	db 60
	db 0
	db 255
	db 195
	db 153
	db 189
	db 189
	db 153
	db 195
	db 255
	db 15
	db 7
	db 15
	db 125
	db 204
	db 204
	db 204
	db 120
	db 60
	db 102
	db 102
	db 102
	db 60
	db 24
	db 126
	db 24
	db 63
	db 51
	db 63
	db 48
	db 48
	db 112
	db 240
	db 224
	db 127
	db 99
	db 127
	db 99
	db 99
	db 103
	db 230
	db 192
	db 24
	db 219
	db 60
	db 231
	db 231
	db 60
	db 219
	db 24
	db 128
	db 224
	db 248
	db 254
	db 248
	db 224
	db 128
	db 0
	db 2
	db 14
	db 62
	db 254
	db 62
	db 14
	db 2
	db 0
	db 24
	db 60
	db 126
	db 24
	db 24
	db 126
	db 60
	db 24
	db 102
	db 102
	db 102
	db 102
	db 102
	db 0
	db 102
	db 0
	db 127
	db 219
	db 219
	db 123
	db 27
	db 27
	db 27
	db 0
	db 60
	db 96
	db 60
	db 102
	db 102
	db 60
	db 6
	db 60
	db 0
	db 0
	db 0
	db 0
	db 126
	db 126
	db 126
	db 0
	db 24
	db 60
	db 126
	db 24
	db 126
	db 60
	db 24
	db 126
	db 24
	db 60
	db 126
	db 24
	db 24
	db 24
	db 24
	db 0
	db 24
	db 24
	db 24
	db 24
	db 126
	db 60
	db 24
	db 0
	db 0
	db 24
	db 12
	db 254
	db 12
	db 24
	db 0
	db 0
	db 0
	db 48
	db 96
	db 254
	db 96
	db 48
	db 0
	db 0
	db 0
	db 0
	db 192
	db 192
	db 192
	db 254
	db 0
	db 0
	db 0
	db 36
	db 102
	db 255
	db 102
	db 36
	db 0
	db 0
	db 0
	db 16
	db 56
	db 124
	db 254
	db 254
	db 0
	db 0
	db 0
	db 254
	db 254
	db 124
	db 56
	db 16
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
	db 48
	db 120
	db 120
	db 48
	db 48
	db 0
	db 48
	db 0
	db 102
	db 102
	db 68
	db 0
	db 0
	db 0
	db 0
	db 0
	db 108
	db 108
	db 254
	db 108
	db 254
	db 108
	db 108
	db 0
	db 24
	db 62
	db 96
	db 60
	db 6
	db 124
	db 24
	db 0
	db 98
	db 102
	db 12
	db 24
	db 48
	db 102
	db 70
	db 0
	db 56
	db 108
	db 56
	db 118
	db 220
	db 204
	db 118
	db 0
	db 48
	db 48
	db 96
	db 0
	db 0
	db 0
	db 0
	db 0
	db 12
	db 24
	db 48
	db 48
	db 48
	db 24
	db 12
	db 0
	db 48
	db 24
	db 12
	db 12
	db 12
	db 24
	db 48
	db 0
	db 0
	db 102
	db 60
	db 255
	db 60
	db 102
	db 0
	db 0
	db 0
	db 24
	db 24
	db 126
	db 24
	db 24
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 48
	db 48
	db 96
	db 0
	db 0
	db 0
	db 126
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 48
	db 48
	db 0
	db 6
	db 12
	db 24
	db 48
	db 96
	db 192
	db 128
	db 0
	db 124
	db 198
	db 206
	db 222
	db 246
	db 230
	db 124
	db 0
	db 24
	db 56
	db 24
	db 24
	db 24
	db 24
	db 126
	db 0
	db 60
	db 102
	db 6
	db 28
	db 48
	db 102
	db 126
	db 0
	db 60
	db 102
	db 6
	db 28
	db 6
	db 102
	db 60
	db 0
	db 28
	db 60
	db 108
	db 204
	db 254
	db 12
	db 30
	db 0
	db 126
	db 96
	db 124
	db 6
	db 6
	db 102
	db 60
	db 0
	db 28
	db 48
	db 96
	db 124
	db 102
	db 102
	db 60
	db 0
	db 126
	db 102
	db 6
	db 12
	db 24
	db 24
	db 24
	db 0
	db 60
	db 102
	db 102
	db 60
	db 102
	db 102
	db 60
	db 0
	db 60
	db 102
	db 102
	db 62
	db 6
	db 12
	db 56
	db 0
	db 0
	db 48
	db 48
	db 0
	db 0
	db 48
	db 48
	db 0
	db 0
	db 48
	db 48
	db 0
	db 0
	db 48
	db 48
	db 96
	db 12
	db 24
	db 48
	db 96
	db 48
	db 24
	db 12
	db 0
	db 0
	db 0
	db 126
	db 0
	db 0
	db 126
	db 0
	db 0
	db 96
	db 48
	db 24
	db 12
	db 24
	db 48
	db 96
	db 0
	db 60
	db 102
	db 6
	db 12
	db 24
	db 0
	db 24
	db 0
	db 124
	db 198
	db 222
	db 222
	db 222
	db 192
	db 120
	db 0
	db 24
	db 60
	db 102
	db 102
	db 126
	db 102
	db 102
	db 0
	db 252
	db 102
	db 102
	db 124
	db 102
	db 102
	db 252
	db 0
	db 60
	db 102
	db 192
	db 192
	db 192
	db 102
	db 60
	db 0
	db 248
	db 108
	db 102
	db 102
	db 102
	db 108
	db 248
	db 0
	db 254
	db 98
	db 104
	db 120
	db 104
	db 98
	db 254
	db 0
	db 254
	db 98
	db 104
	db 120
	db 104
	db 96
	db 240
	db 0
	db 60
	db 102
	db 192
	db 192
	db 206
	db 102
	db 62
	db 0
	db 102
	db 102
	db 102
	db 126
	db 102
	db 102
	db 102
	db 0
	db 60
	db 24
	db 24
	db 24
	db 24
	db 24
	db 60
	db 0
	db 30
	db 12
	db 12
	db 12
	db 204
	db 204
	db 120
	db 0
	db 230
	db 102
	db 108
	db 120
	db 108
	db 102
	db 230
	db 0
	db 240
	db 96
	db 96
	db 96
	db 98
	db 102
	db 254
	db 0
	db 198
	db 238
	db 254
	db 254
	db 214
	db 198
	db 198
	db 0
	db 198
	db 230
	db 246
	db 222
	db 206
	db 198
	db 198
	db 0
	db 56
	db 108
	db 198
	db 198
	db 198
	db 108
	db 56
	db 0
	db 252
	db 102
	db 102
	db 124
	db 96
	db 96
	db 240
	db 0
	db 60
	db 102
	db 102
	db 102
	db 110
	db 60
	db 14
	db 0
	db 252
	db 102
	db 102
	db 124
	db 108
	db 102
	db 230
	db 0
	db 60
	db 102
	db 48
	db 24
	db 12
	db 102
	db 60
	db 0
	db 126
	db 90
	db 24
	db 24
	db 24
	db 24
	db 60
	db 0
	db 102
	db 102
	db 102
	db 102
	db 102
	db 102
	db 60
	db 0
	db 102
	db 102
	db 102
	db 102
	db 102
	db 60
	db 24
	db 0
	db 198
	db 198
	db 198
	db 214
	db 254
	db 238
	db 198
	db 0
	db 198
	db 198
	db 108
	db 56
	db 56
	db 108
	db 198
	db 0
	db 102
	db 102
	db 102
	db 60
	db 24
	db 24
	db 60
	db 0
	db 254
	db 198
	db 140
	db 24
	db 50
	db 102
	db 254
	db 0
	db 60
	db 48
	db 48
	db 48
	db 48
	db 48
	db 60
	db 0
	db 192
	db 96
	db 48
	db 24
	db 12
	db 6
	db 2
	db 0
	db 60
	db 12
	db 12
	db 12
	db 12
	db 12
	db 60
	db 0
	db 16
	db 56
	db 108
	db 198
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
	db 255
	db 48
	db 48
	db 24
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 120
	db 12
	db 124
	db 204
	db 118
	db 0
	db 224
	db 96
	db 96
	db 124
	db 102
	db 102
	db 220
	db 0
	db 0
	db 0
	db 60
	db 96
	db 96
	db 96
	db 60
	db 0
	db 28
	db 12
	db 12
	db 124
	db 204
	db 204
	db 118
	db 0
	db 0
	db 0
	db 60
	db 102
	db 126
	db 96
	db 60
	db 0
	db 28
	db 54
	db 48
	db 120
	db 48
	db 48
	db 120
	db 0
	db 0
	db 0
	db 118
	db 204
	db 204
	db 124
	db 12
	db 248
	db 224
	db 96
	db 108
	db 118
	db 102
	db 102
	db 230
	db 0
	db 24
	db 0
	db 56
	db 24
	db 24
	db 24
	db 60
	db 0
	db 6
	db 0
	db 6
	db 6
	db 6
	db 102
	db 102
	db 60
	db 224
	db 96
	db 102
	db 108
	db 120
	db 108
	db 230
	db 0
	db 56
	db 24
	db 24
	db 24
	db 24
	db 24
	db 60
	db 0
	db 0
	db 0
	db 204
	db 254
	db 254
	db 214
	db 198
	db 0
	db 0
	db 0
	db 220
	db 102
	db 102
	db 102
	db 102
	db 0
	db 0
	db 0
	db 60
	db 102
	db 102
	db 102
	db 60
	db 0
	db 0
	db 0
	db 220
	db 102
	db 102
	db 124
	db 96
	db 240
	db 0
	db 0
	db 118
	db 204
	db 204
	db 124
	db 12
	db 30
	db 0
	db 0
	db 220
	db 118
	db 102
	db 96
	db 240
	db 0
	db 0
	db 0
	db 62
	db 96
	db 60
	db 6
	db 124
	db 0
	db 16
	db 48
	db 124
	db 48
	db 48
	db 54
	db 28
	db 0
	db 0
	db 0
	db 204
	db 204
	db 204
	db 204
	db 118
	db 0
	db 0
	db 0
	db 102
	db 102
	db 102
	db 60
	db 24
	db 0
	db 0
	db 0
	db 198
	db 214
	db 254
	db 254
	db 108
	db 0
	db 0
	db 0
	db 198
	db 108
	db 56
	db 108
	db 198
	db 0
	db 0
	db 0
	db 102
	db 102
	db 102
	db 62
	db 6
	db 124
	db 0
	db 0
	db 126
	db 76
	db 24
	db 50
	db 126
	db 0
	db 14
	db 24
	db 24
	db 112
	db 24
	db 24
	db 14
	db 0
	db 24
	db 24
	db 24
	db 0
	db 24
	db 24
	db 24
	db 0
	db 112
	db 24
	db 24
	db 14
	db 24
	db 24
	db 112
	db 0
	db 118
	db 220
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 16
	db 56
	db 108
	db 198
	db 198
	db 254
	db 0
	db 30
	db 54
	db 102
	db 198
	db 254
	db 198
	db 198
	db 0
	db 252
	db 192
	db 192
	db 252
	db 198
	db 198
	db 252
	db 0
	db 248
	db 204
	db 204
	db 252
	db 198
	db 198
	db 252
	db 0
	db 126
	db 96
	db 96
	db 96
	db 96
	db 96
	db 96
	db 0
	db 30
	db 54
	db 102
	db 102
	db 102
	db 102
	db 255
	db 195
	db 252
	db 192
	db 192
	db 248
	db 192
	db 192
	db 254
	db 0
	db 219
	db 219
	db 126
	db 60
	db 126
	db 219
	db 219
	db 0
	db 60
	db 102
	db 6
	db 60
	db 6
	db 198
	db 124
	db 0
	db 198
	db 198
	db 206
	db 222
	db 246
	db 230
	db 198
	db 0
	db 186
	db 198
	db 206
	db 222
	db 246
	db 230
	db 198
	db 0
	db 198
	db 204
	db 216
	db 248
	db 204
	db 198
	db 198
	db 0
	db 30
	db 54
	db 102
	db 102
	db 102
	db 102
	db 230
	db 0
	db 198
	db 238
	db 254
	db 214
	db 198
	db 198
	db 198
	db 0
	db 198
	db 198
	db 198
	db 254
	db 198
	db 198
	db 198
	db 0
	db 124
	db 198
	db 198
	db 198
	db 198
	db 198
	db 124
	db 0
	db 254
	db 198
	db 198
	db 198
	db 198
	db 198
	db 198
	db 0
	db 252
	db 198
	db 198
	db 252
	db 192
	db 192
	db 192
	db 0
	db 124
	db 198
	db 192
	db 192
	db 192
	db 198
	db 124
	db 0
	db 126
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 0
	db 198
	db 198
	db 198
	db 126
	db 6
	db 198
	db 124
	db 0
	db 24
	db 126
	db 219
	db 219
	db 219
	db 126
	db 24
	db 0
	db 198
	db 108
	db 56
	db 56
	db 108
	db 198
	db 198
	db 0
	db 204
	db 204
	db 204
	db 204
	db 204
	db 204
	db 254
	db 6
	db 198
	db 198
	db 198
	db 126
	db 6
	db 6
	db 6
	db 0
	db 214
	db 214
	db 214
	db 214
	db 214
	db 214
	db 254
	db 0
	db 214
	db 214
	db 214
	db 214
	db 214
	db 214
	db 255
	db 3
	db 240
	db 48
	db 48
	db 62
	db 51
	db 51
	db 62
	db 0
	db 198
	db 198
	db 198
	db 246
	db 218
	db 218
	db 246
	db 0
	db 192
	db 192
	db 192
	db 252
	db 198
	db 198
	db 252
	db 0
	db 124
	db 198
	db 6
	db 30
	db 6
	db 198
	db 124
	db 0
	db 204
	db 222
	db 182
	db 246
	db 182
	db 222
	db 204
	db 0
	db 126
	db 198
	db 198
	db 126
	db 54
	db 102
	db 198
	db 0
	db 0
	db 0
	db 120
	db 12
	db 124
	db 204
	db 126
	db 0
	db 6
	db 60
	db 96
	db 124
	db 102
	db 102
	db 60
	db 0
	db 0
	db 0
	db 248
	db 204
	db 248
	db 198
	db 252
	db 0
	db 0
	db 0
	db 126
	db 96
	db 96
	db 96
	db 96
	db 0
	db 0
	db 0
	db 30
	db 54
	db 102
	db 102
	db 255
	db 195
	db 0
	db 0
	db 60
	db 102
	db 126
	db 96
	db 62
	db 0
	db 0
	db 0
	db 219
	db 126
	db 60
	db 126
	db 219
	db 0
	db 0
	db 0
	db 60
	db 102
	db 12
	db 102
	db 60
	db 0
	db 0
	db 0
	db 102
	db 110
	db 126
	db 118
	db 102
	db 0
	db 24
	db 0
	db 102
	db 110
	db 126
	db 118
	db 102
	db 0
	db 0
	db 0
	db 102
	db 108
	db 120
	db 108
	db 102
	db 0
	db 0
	db 0
	db 30
	db 54
	db 102
	db 102
	db 230
	db 0
	db 0
	db 0
	db 198
	db 238
	db 254
	db 214
	db 198
	db 0
	db 0
	db 0
	db 102
	db 102
	db 126
	db 102
	db 102
	db 0
	db 0
	db 0
	db 60
	db 102
	db 102
	db 102
	db 60
	db 0
	db 0
	db 0
	db 126
	db 102
	db 102
	db 102
	db 102
	db 0
	db 34
	db 136
	db 34
	db 136
	db 34
	db 136
	db 34
	db 136
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 219
	db 119
	db 219
	db 238
	db 219
	db 119
	db 219
	db 238
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 248
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 248
	db 24
	db 248
	db 24
	db 24
	db 24
	db 108
	db 108
	db 108
	db 236
	db 108
	db 108
	db 108
	db 108
	db 0
	db 0
	db 0
	db 252
	db 108
	db 108
	db 108
	db 108
	db 0
	db 0
	db 248
	db 24
	db 248
	db 24
	db 24
	db 24
	db 108
	db 108
	db 236
	db 12
	db 236
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 0
	db 0
	db 252
	db 12
	db 236
	db 108
	db 108
	db 108
	db 108
	db 108
	db 236
	db 12
	db 252
	db 0
	db 0
	db 0
	db 108
	db 108
	db 108
	db 252
	db 0
	db 0
	db 0
	db 0
	db 24
	db 24
	db 248
	db 24
	db 248
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 248
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 31
	db 0
	db 0
	db 0
	db 0
	db 24
	db 24
	db 24
	db 255
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 255
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 31
	db 24
	db 24
	db 24
	db 24
	db 0
	db 0
	db 0
	db 255
	db 0
	db 0
	db 0
	db 0
	db 24
	db 24
	db 24
	db 255
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 31
	db 24
	db 31
	db 24
	db 24
	db 24
	db 108
	db 108
	db 108
	db 111
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 111
	db 96
	db 127
	db 0
	db 0
	db 0
	db 0
	db 0
	db 127
	db 96
	db 111
	db 108
	db 108
	db 108
	db 108
	db 108
	db 239
	db 0
	db 255
	db 0
	db 0
	db 0
	db 0
	db 0
	db 255
	db 0
	db 239
	db 108
	db 108
	db 108
	db 108
	db 108
	db 111
	db 96
	db 111
	db 108
	db 108
	db 108
	db 0
	db 0
	db 255
	db 0
	db 255
	db 0
	db 0
	db 0
	db 108
	db 108
	db 239
	db 0
	db 239
	db 108
	db 108
	db 108
	db 24
	db 24
	db 255
	db 0
	db 255
	db 0
	db 0
	db 0
	db 108
	db 108
	db 108
	db 255
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 255
	db 0
	db 255
	db 24
	db 24
	db 24
	db 0
	db 0
	db 0
	db 255
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 127
	db 0
	db 0
	db 0
	db 0
	db 24
	db 24
	db 31
	db 24
	db 31
	db 0
	db 0
	db 0
	db 0
	db 0
	db 31
	db 24
	db 31
	db 24
	db 24
	db 24
	db 0
	db 0
	db 0
	db 127
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 108
	db 255
	db 108
	db 108
	db 108
	db 108
	db 24
	db 24
	db 255
	db 24
	db 255
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 248
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 31
	db 24
	db 24
	db 24
	db 24
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 255
	db 0
	db 0
	db 0
	db 0
	db 255
	db 255
	db 255
	db 255
	db 240
	db 240
	db 240
	db 240
	db 240
	db 240
	db 240
	db 240
	db 15
	db 15
	db 15
	db 15
	db 15
	db 15
	db 15
	db 15
	db 255
	db 255
	db 255
	db 255
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 124
	db 102
	db 102
	db 124
	db 96
	db 96
	db 0
	db 0
	db 60
	db 102
	db 96
	db 102
	db 60
	db 0
	db 0
	db 0
	db 126
	db 24
	db 24
	db 24
	db 24
	db 0
	db 0
	db 0
	db 102
	db 102
	db 62
	db 6
	db 102
	db 60
	db 0
	db 24
	db 126
	db 219
	db 219
	db 126
	db 24
	db 24
	db 0
	db 0
	db 198
	db 108
	db 56
	db 108
	db 198
	db 0
	db 0
	db 0
	db 204
	db 204
	db 204
	db 204
	db 254
	db 6
	db 0
	db 0
	db 102
	db 102
	db 62
	db 6
	db 6
	db 0
	db 0
	db 0
	db 214
	db 214
	db 214
	db 214
	db 254
	db 0
	db 0
	db 0
	db 214
	db 214
	db 214
	db 214
	db 255
	db 3
	db 0
	db 0
	db 240
	db 48
	db 62
	db 51
	db 62
	db 0
	db 0
	db 0
	db 198
	db 198
	db 246
	db 218
	db 246
	db 0
	db 0
	db 0
	db 96
	db 96
	db 124
	db 102
	db 124
	db 0
	db 0
	db 0
	db 124
	db 198
	db 30
	db 198
	db 124
	db 0
	db 0
	db 0
	db 220
	db 182
	db 246
	db 182
	db 220
	db 0
	db 0
	db 0
	db 62
	db 102
	db 62
	db 54
	db 102
	db 0
	db 0
	db 254
	db 0
	db 254
	db 0
	db 254
	db 0
	db 0
	db 24
	db 24
	db 126
	db 24
	db 24
	db 0
	db 126
	db 0
	db 48
	db 24
	db 12
	db 24
	db 48
	db 0
	db 126
	db 0
	db 12
	db 24
	db 48
	db 24
	db 12
	db 0
	db 126
	db 0
	db 12
	db 30
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 24
	db 120
	db 48
	db 0
	db 0
	db 0
	db 24
	db 0
	db 126
	db 0
	db 24
	db 0
	db 0
	db 118
	db 220
	db 0
	db 118
	db 220
	db 0
	db 0
	db 120
	db 204
	db 204
	db 120
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 24
	db 24
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 24
	db 0
	db 0
	db 0
	db 31
	db 24
	db 24
	db 24
	db 248
	db 56
	db 24
	db 0
	db 216
	db 108
	db 108
	db 108
	db 0
	db 0
	db 0
	db 0
	db 112
	db 216
	db 48
	db 248
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 60
	db 60
	db 60
	db 60
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
; 14 void ButtonShadowViewShow() {
buttonshadowviewshow:
; 15     push_pop(hl) {
	push hl
; 16         h = b;
	ld h, b
; 17         l = c;
	ld l, c
; 18         ButtonShadowViewTitlePoint = hl;
	ld (buttonshadowviewtitlepoint), hl
	pop hl
; 19     }
; 20     //- SAVE -
; 21     a = h;
	ld a, h
; 22     ButtonShadowViewX = a;
	ld (buttonshadowviewx), a
; 23     //printHexA(a = ButtonShadowViewX);
; 24     a = l;
	ld a, l
; 25     ButtonShadowViewY = a;
	ld (buttonshadowviewy), a
; 26     //printHexA(a = ButtonShadowViewY);
; 27     a = d;
	ld a, d
; 28     ButtonShadowViewDX = a;
	ld (buttonshadowviewdx), a
; 29     //printHexA(a = ButtonShadowViewDX);
; 30     a = e;
	ld a, e
; 31     ButtonShadowViewDY = a;
	ld (buttonshadowviewdy), a
; 32     //printHexA(a = ButtonShadowViewDY);
; 33     //--
; 34     a = ButtonShadowViewColor;
	ld a, (buttonshadowviewcolor)
; 35     c = a;
	ld c, a
; 36     a = vboxCLW;
	ld a, 64
; 37     a |= vboxFRM;
	or 32
; 38     a |= vboxSDW;
	or 16
; 39     a |= vboxUMP;
	or 4
; 40     vboxOpenHLDECA();
	call vboxopenhldeca
; 41     //
; 42     ButtonShadowViewShowTitleBC();
	jp buttonshadowviewshowtitlebc
; 43 }
; 44 
; 45 /// Закраска кнопки
; 46 /// 0 - прямой
; 47 /// 1 - инверсный
; 48 void ButtonShadowViewSelectA() {
buttonshadowviewselecta:
; 49     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 50         b = a;
	ld b, a
; 51         a = ButtonShadowViewX;
	ld a, (buttonshadowviewx)
; 52         h = a;
	ld h, a
; 53         a = ButtonShadowViewY;
	ld a, (buttonshadowviewy)
; 54         l = a;
	ld l, a
; 55         a = ButtonShadowViewDX;
	ld a, (buttonshadowviewdx)
; 56         d = a;
	ld d, a
; 57         a = ButtonShadowViewDY;
	ld a, (buttonshadowviewdy)
; 58         e = a;
	ld e, a
; 59         //--------
; 60         if ((a = b) == 0) {
	ld a, b
	or a
	jp nz, l_735
; 61             a = ButtonShadowViewColor;
	ld a, (buttonshadowviewcolor)
	jp l_736
l_735:
; 62         } else {
; 63             a = ButtonShadowViewInvColor;
	ld a, (buttonshadowviewinvcolor)
l_736:
; 64         }
; 65         c = a;
	ld c, a
; 66         //----
; 67         a = vboxFRM;
	ld a, 32
; 68         a |= vboxUMP;
	or 4
; 69         vboxOpenHLDECA();
	call vboxopenhldeca
	pop hl
	pop de
	pop bc
	ret
; 70     }
; 71 }
; 72 
; 73 void ButtonShadowViewShowTitleBC() {
buttonshadowviewshowtitlebc:
; 74     push_pop(hl, de, bc) {
	push hl
	push de
	push bc
; 75         hl = ButtonShadowViewTitlePoint;
	ld hl, (buttonshadowviewtitlepoint)
; 76         b = 0;
	ld b, 0
; 77         a = ButtonShadowViewDX;
	ld a, (buttonshadowviewdx)
; 78         c = a;
	ld c, a
; 79         do {
l_737:
; 80             a = *hl;
	ld a, (hl)
; 81             d = a;
	ld d, a
; 82             hl++;
	inc hl
; 83             if (a > 0) {
	or a
	jp z, l_740
; 84                 b++;
	inc b
l_740:
; 85             }
; 86             if ((a = b) >= c) {
	ld a, b
	cp c
	jp c, l_742
; 87                 d = 0;
	ld d, 0
l_742:
l_738:
; 88             }
; 89         } while ((a = d) > 0);
	ld a, d
	or a
	jp nz, l_737
; 90         a = ButtonShadowViewDX;
	ld a, (buttonshadowviewdx)
; 91         a -= b;
	sub b
; 92         a &= 0xFE;
	and 254
; 93         cyclic_rotate_right(a, 1);
	rrca
; 94         b = a;
	ld b, a
; 95         a = ButtonShadowViewX;
	ld a, (buttonshadowviewx)
; 96         a += b;
	add b
; 97         myCharPosX = a;
	ld (mycharposx), a
; 98         a = ButtonShadowViewY;
	ld a, (buttonshadowviewy)
; 99         a += 1;
	add 1
; 100         myCharPosY = a;
	ld (mycharposy), a
; 101         printMyHLStr(hl = ButtonShadowViewTitlePoint);
	ld hl, (buttonshadowviewtitlepoint)
	call printmyhlstr
	pop bc
	pop de
	pop hl
	ret
; 102     }
; 103 }
; 104 
; 105 uint8_t ButtonShadowViewX = 0;
buttonshadowviewx:
	db 0
; 106 uint8_t ButtonShadowViewY = 0;
buttonshadowviewy:
	db 0
; 107 uint8_t ButtonShadowViewDX = 0;
buttonshadowviewdx:
	db 0
; 108 uint8_t ButtonShadowViewDY = 0;
buttonshadowviewdy:
	db 0
; 110 uint8_t ButtonShadowViewColor = 0xF7;
buttonshadowviewcolor:
	db 247
; 111 uint8_t ButtonShadowViewInvColor = 0xE2; //0xE6
buttonshadowviewinvcolor:
	db 226
; 113 uint16_t ButtonShadowViewTitlePoint = 0x0000;
buttonshadowviewtitlepoint:
	dw 0
; 11 uint8_t vboxOpenHLDEColor = 0;
vboxopenhldecolor:
	db 0
; 12 uint8_t vboxOpenHLDEAccum = 0;
vboxopenhldeaccum:
	db 0
; 18 void vboxOpenHLDECA() {
vboxopenhldeca:
; 19     push_pop(bc, de, hl) {
	push bc
	push de
	push hl
; 20     //push_pop(hl, de, bc, a) {
; 21         vboxOpenHLDEAccum = a;
	ld (vboxopenhldeaccum), a
; 22         a = c;
	ld a, c
; 23         vboxOpenHLDEColor = a;
	ld (vboxopenhldecolor), a
; 24         //HL Начальный адрес
; 25         a = l;
	ld a, l
; 26         a &= 0x1F;
	and 31
; 27         cyclic_rotate_left(a, 3);
	rlca
	rlca
	rlca
; 28         l = a;
	ld l, a
; 29         a = h;
	ld a, h
; 30         a += 0xC0;
	add 192
; 31         h = a;
	ld h, a
; 32         //BC Размер
; 33         b = d;
	ld b, d
; 34         a = e;
	ld a, e
; 35         cyclic_rotate_left(a, 3);
	rlca
	rlca
	rlca
; 36         c = a;
	ld c, a
; 37         //DE цвет
; 38         d = 0x07; //0x00; //Тень
	ld d, 7
; 39         a = vboxOpenHLDEColor;
	ld a, (vboxopenhldecolor)
; 40         e = a;
	ld e, a
; 41         a = vboxOpenHLDEAccum;
	ld a, (vboxopenhldeaccum)
; 42         vboxOpen();
	call vboxopen
	pop hl
	pop de
	pop bc
	ret
; 43     }
; 44 }
; 45 
; 46 void vboxClearCash() {
vboxclearcash:
; 47     push_pop(a) {
	push af
; 48         do {
l_744:
; 49             a = vboxBLW;
	ld a, 16
; 50             a |= vboxERA;
	or 8
; 51             a |= vboxUMP;
	or 4
; 52             vboxCall();
	call vboxcall
l_745:
; 53         } while (a == 0x00);
	or a
	jp z, l_744
	pop af
	ret
; 54     }
; 55 }
; 56 
; 57 /// HL верхний левый угол
; 58 /// DE нижний правый
; 59 void vboxBorderHLDE() {
vboxborderhlde:
; 60     push_pop(bc) {
	push bc
; 61         //Верхняя линия
; 62         push_pop(hl, de) {
	push hl
	push de
; 63             a = h;
	ld a, h
; 64             myCharPosX = a;
	ld (mycharposx), a
; 65             a = l;
	ld a, l
; 66             myCharPosY = a;
	ld (mycharposy), a
; 67             printMyChatA(a = 0xC9);
	ld a, 201
	call printmychata
; 68             b = 2;
	ld b, 2
; 69             do {
l_747:
; 70                 printMyChatA(a = 0xCD);
	ld a, 205
	call printmychata
; 71                 b++;
	inc b
l_748:
; 72             } while ((a = b) < d);
	ld a, b
	cp d
	jp c, l_747
; 73             printMyChatA(a = 0xBB);
	ld a, 187
	call printmychata
	pop de
	pop hl
; 74         }
; 75         // Нижняя линия
; 76         push_pop(hl, de) {
	push hl
	push de
; 77             a = h;
	ld a, h
; 78             myCharPosX = a;
	ld (mycharposx), a
; 79             a = l;
	ld a, l
; 80             a += e;
	add e
; 81             a--;
	dec a
; 82             myCharPosY = a;
	ld (mycharposy), a
; 83             printMyChatA(a = 0xC8);
	ld a, 200
	call printmychata
; 84             b = 2;
	ld b, 2
; 85             do {
l_750:
; 86                 printMyChatA(a = 0xCD);
	ld a, 205
	call printmychata
; 87                 b++;
	inc b
l_751:
; 88             } while ((a = b) < d);
	ld a, b
	cp d
	jp c, l_750
; 89             printMyChatA(a = 0xBC);
	ld a, 188
	call printmychata
	pop de
	pop hl
; 90         }
; 91         // Левая горизонтальная
; 92         push_pop(hl, de) {
	push hl
	push de
; 93             a = h;
	ld a, h
; 94             myCharPosX = a;
	ld (mycharposx), a
; 95             a = l;
	ld a, l
; 96             a++;
	inc a
; 97             myCharPosY = a;
	ld (mycharposy), a
; 98             b = 2;
	ld b, 2
; 99             do {
l_753:
; 100                 printMyChatA(a = 0xBA);
	ld a, 186
	call printmychata
; 101                 a = h;
	ld a, h
; 102                 myCharPosX = a;
	ld (mycharposx), a
; 103                 a = l;
	ld a, l
; 104                 a += b;
	add b
; 105                 myCharPosY = a;
	ld (mycharposy), a
; 106                 b++;
	inc b
l_754:
; 107             } while ((a = b) < e);
	ld a, b
	cp e
	jp c, l_753
	pop de
	pop hl
; 108         }
; 109         // Правая горизонтальная
; 110         push_pop(hl, de) {
	push hl
	push de
; 111             a = h;
	ld a, h
; 112             a += d;
	add d
; 113             a--;
	dec a
; 114             c = a;
	ld c, a
; 115             myCharPosX = a;
	ld (mycharposx), a
; 116             a = l;
	ld a, l
; 117             a++;
	inc a
; 118             myCharPosY = a;
	ld (mycharposy), a
; 119             b = 2;
	ld b, 2
; 120             do {
l_756:
; 121                 printMyChatA(a = 0xBA);
	ld a, 186
	call printmychata
; 122                 a = c;
	ld a, c
; 123                 myCharPosX = a;
	ld (mycharposx), a
; 124                 a = l;
	ld a, l
; 125                 a += b;
	add b
; 126                 myCharPosY = a;
	ld (mycharposy), a
; 127                 b++;
	inc b
l_757:
; 128             } while ((a = b) < e);
	ld a, b
	cp e
	jp c, l_756
	pop de
	pop hl
	pop bc
	ret
; 129         }
; 130     }
; 131 }
; 132 
; 133 void vboxOpenHLDE() {
vboxopenhlde:
; 134     c = a;
	ld c, a
; 135     a = vboxCLW;
	ld a, 64
; 136     a |= vboxUMP;
	or 4
; 137     vboxOpenHLDECA();
	jp vboxopenhldeca
; 138 }
; 139 
; 140 /// Загрузка драйвера VBOX, если не загружен
; 141 void validVBOX() {
validvbox:
; 142     a = vboxAddr; // 0 - если там знакогенератор
	ld a, (vboxaddr)
; 143     a |= a;
	or a
; 144     if (a == 0) {
	or a
	jp nz, l_759
; 145         push_pop(bc, hl) {
	push bc
	push hl
; 146             ordos_sdma(hl = vboxFL);
	ld hl, vboxfl
	call ordos_sdma
; 147             b = 0;
	ld b, 0
; 148             do {
l_761:
; 149                 a = 'A';
	ld a, 65
; 150                 a += b;
	add b
; 151                 ordos_wnd(); // A = Disk
	call ordos_wnd
; 152                 ordos_pscf();
	call ordos_pscf
; 153                 c = a;
	ld c, a
; 154                 b++;
	inc b
; 155                 if ((a = b) == 4) {
	ld a, b
	cp 4
	jp nz, l_764
; 156                     c = 1;
	ld c, 1
l_764:
l_762:
; 157                 }
; 158             } while ((a = c) == 0);
	ld a, c
	or a
	jp z, l_761
; 159             if ((a = c) == 0xFF) {
	ld a, c
	cp 255
	jp nz, l_766
; 160                 loadVBOX();
	call loadvbox
l_766:
	pop hl
	pop bc
l_759:
	ret
; 161             }
; 162         }
; 163     }
; 164 }
; 165 
; 166 /// Загрузка
; 167 void loadVBOX() {
loadvbox:
; 168     ordos_rfile();
	call ordos_rfile
; 169     startVboxAddr = hl;
	ld (startvboxaddr), hl
	ret
; 170 }
; 171 
; 172 void vboxOpen() {
vboxopen:
; 173     a |= vboxOPN;
	or 128
; 174     vboxCall();
	jp vboxcall
; 175 }
; 176 
; 177 void vboxClose() {
vboxclose:
; 178     push_pop(a) {
	push af
; 179         a = vboxERA;
	ld a, 8
; 180         a |= vboxUMP;
	or 4
; 181         vboxCall();
	call vboxcall
	pop af
	ret
; 182     }
; 183 }
; 184 
; 185 void vboxCall() {
vboxcall:
; 186     push_pop(a) {
	push af
; 187         push_pop(bc) {
	push bc
; 188             push_pop(de) {
	push de
; 189                 push_pop(hl) {
	push hl
; 190                     ordos_rnd();
	call ordos_rnd
; 191                     push_pop(a) {
	push af
; 192                         validVBOX();
	call validvbox
	pop af
; 193                     }
; 194                     ordos_wnd();
	call ordos_wnd
	pop hl
	pop de
	pop bc
	pop af
; 195                 }
; 196             }
; 197         }
; 198     }
; 199     a |= 0x03; //0x03; //0x01; //ADD disk
	or 3
; 200     goToVBOX();
	jp gotovbox
; 201 }
; 202 
; 203 uint8_t vboxFL[] = "VBOX "; // Имя файла
vboxfl:
	db 86
	db 66
	db 79
	db 88
	db 32
	ds 1
; 204 uint16_t vboxAddr = 0xF000;
vboxaddr:
	dw 61440
; 136 uint8_t strOK[] = "Ok";
strok:
	db 79
	db 107
	ds 1
; 137 uint8_t strError[] = "Error!";
strerror:
	db 69
	db 114
	db 114
	db 111
	db 114
	db 33
	ds 1
; 138 uint8_t strWarning[] = "Warning!";
strwarning:
	db 87
	db 97
	db 114
	db 110
	db 105
	db 110
	db 103
	db 33
	ds 1
; 139 uint8_t strUtf8[] = {0xd0 ,0x9f ,0xd1 ,0x80 ,0xd0 ,0xb8 ,0xd0 ,0xb2 ,0xd0 ,0xb5 ,0xd1 ,0x82 ,0x20 ,0xd0 ,0x9c ,0xd0 ,0xb8 ,0xd1 ,0x80 , 0x00}; //"Привет Мир!"
strutf8:
	db 208
	db 159
	db 209
	db 128
	db 208
	db 184
	db 208
	db 178
	db 208
	db 181
	db 209
	db 130
	db 32
	db 208
	db 156
	db 208
	db 184
	db 209
	db 128
	db 0
 savebin "test.ORD", 0x00f0, 0x3210
