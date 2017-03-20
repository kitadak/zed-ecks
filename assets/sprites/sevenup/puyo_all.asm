; ASM source file created by SevenuP v1.20
; SevenuP (C) Copyright 2002-2006 by Jaime Tejedor Gomez, aka Metalbrain

;GRAPHIC DATA:
;Pixel Size:      ( 16,  16)
;Char Size:       (  2,   2)
;Sort Priorities: X char, Char line, Y char
;Data Outputted:  Gfx+Attr
;Interleave:      Sprite
;Mask:            No

; %0000
puyo_none:
	DEFB	  0,  0,  1,128,  3,192,  7,240
	DEFB	 15,248, 31,196, 49,186,110,170
	DEFB	106,186,110,198,113,254,127,254
	DEFB	 63,252, 31,248,  7,224,  0,  0

; %0001
puyo_l:
	DEFB	  0,  0,  0,  0,  3,248, 15,252
	DEFB	 31,252, 35,252, 93,142,205,118
	DEFB	221, 54,227,118,255,142,127,254
	DEFB	 63,252, 31,248,  0,  0,  0,  0

; %0010
puyo_d:
	DEFB	  0,  0,  1,192,  3,224,  7,240
	DEFB	 15,248, 31,196, 49,186,110,186
	DEFB	110,170,106,198,113,254,127,252
	DEFB	 63,248, 31,224, 15,128,  7,  0

; %0011
puyo_dl:
	DEFB	  0,  0,  7,192, 15,224, 31,240
	DEFB	 63,248, 99,252,221,140,205,118
	DEFB	221,118,227, 86,127,142, 63,252
	DEFB	 31,248, 15,240,  7,224,  3,192

; %0100
puyo_r:
	DEFB	  0,  0,  0,  0, 31,192, 63,240
	DEFB	 63,248, 63,196,113,186,110,179
	DEFB	108,187,110,199,113,255,127,254
	DEFB	 63,252, 31,248,  0,  0,  0,  0

; %0101
puyo_lr:
	DEFB	  0,  0,  7,240, 15,248, 31,252
	DEFB	 63,254, 99,226,221,221,205,217
	DEFB	221,221,227,227,127,254,127,254
	DEFB	 63,252, 31,248,  7,224,  0,  0

; %0110
puyo_dr:
	DEFB	  0,  0,  3,224,  7,240, 15,248
	DEFB	 31,252, 63,198, 49,187,110,179
	DEFB	110,187,106,199,113,254, 63,252
	DEFB	 31,248, 15,240,  7,224,  3,192

; %0111
puyo_dlr:
	DEFB	  0,  0,  7,224, 15,240, 31,248
	DEFB	 63,252,127,254,227,199,221,187
	DEFB	213,171,221,187, 99,198,127,254
	DEFB	 63,252, 31,248, 15,240,  3,192

; %1000
puyo_u:
	DEFB	  3,192,  7,192, 15,224, 31,240
	DEFB	 63,136, 63, 84,113,118,106,118
	DEFB	110,142,110,254,113,252,127,252
	DEFB	127,248, 63,240, 31,224,  0,  0

; %1001
puyo_ul:
	DEFB	  3,192, 15,224, 31,240, 63,248
	DEFB	127,140, 99, 84,221,116,205,116
	DEFB	221,140,227,252,127,252,127,248
	DEFB	 63,240, 31,224, 15,128,  0,  0

; %1010
puyo_ud:
	DEFB	  3,192,  3,224,  7,240, 15,248
	DEFB	 17,252, 42,196, 46,186, 46,186
	DEFB	 49,170, 63,198, 63,254, 31,252
	DEFB	 31,252, 15,240,  7,224,  3,192

; %1011
puyo_udl:
	DEFB	  3,192,  7,192, 15,224, 31,240
	DEFB	 63,248, 71,252,187, 28,170,236
	DEFB	186,172,198,236,127, 28,127,252
	DEFB	 63,248, 31,248, 15,240,  3,192

; %1100
puyo_ur:
	DEFB	  3,192,  7,240, 15,248, 31,252
	DEFB	 49,254, 42,198, 46,187, 46,179
	DEFB	 49,187, 63,199, 63,254, 31,254
	DEFB	 15,252,  7,248,  1,240,  0,  0

; %1101
puyo_ulr:
	DEFB	  3,192, 15,240, 31,248, 63,252
	DEFB	127,254, 99,198,221,187,213,171
	DEFB	221,187,227,199,127,254, 63,252
	DEFB	 31,248, 15,240,  7,224,  0,  0

; %1110
puyo_udr:
	DEFB	  3,192,  3,224,  7,240, 15,248
	DEFB	 31,252, 63,226, 56,221, 55, 85
	DEFB	 53, 93, 55, 99, 56,254, 63,254
	DEFB	 31,252, 31,248, 15,240,  3,192

; %1111
puyo_udlr:
	DEFB	  3,192,  7,224, 15,240, 31,248
	DEFB	 63,252,127,254,241,199,238,187
	DEFB	234,171,238,187,113,198,127,254
	DEFB	 63,254, 31,252, 15,248,  3,192

