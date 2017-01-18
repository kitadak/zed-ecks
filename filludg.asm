#target tap

; sync bytes:
headerflag:     equ 0
dataflag:       equ 0xff

; some Basic tokens:
tCLEAR		equ     $FD             ; token CLEAR
tLOAD		equ     $EF             ; token LOAD
tCODE		equ     $AF             ; token CODE
tPRINT		equ     $F5             ; token PRINT
tRANDOMIZE	equ     $F9             ; token RANDOMIZE
tUSR		equ     $C0             ; token USR


pixels_start	equ	0x4000		; ZXSP screen pixels
attr_start	equ	0x5800		; ZXSP screen attributes
printer_buffer	equ	0x5B00		; ZXSP printer buffer
code_start	equ	24000

; ---------------------------------------------------
;		a Basic Loader:
; ---------------------------------------------------

#code PROG_HEADER,0,17,headerflag
	defb    0
	defb    "mloader   "
	defw    variables_end-0
	defw    10
	defw    program_end-0

#code PROG_DATA,0,*,dataflag

; 10 CLEAR 23999
        defb    0,10                    ; line number
        defb    end10-($+1)             ; line length
        defb    0                       ; statement number
        defb    tCLEAR                  ; token CLEAR
        defm    "23999",$0e0000bf5d00   ; number 23999, ascii & internal format
end10:  defb    $0d                     ; line end marker

; 20 LOAD "" CODE 24000
        defb    0,20                    ; line number
        defb    end20-($+1)             ; line length
        defb    0                       ; statement number
        defb    tLOAD,'"','"',tCODE     ; token LOAD, 2 quotes, token CODE
        defm    "24000",$0e0000c05d00   ; number 24000, ascii & internal format
end20:  defb    $0d                     ; line end marker

; 30 RANDOMIZE USR 24000
        defb    0,30                    ; line number
        defb    end30-($+1)             ; line length
        defb    0                       ; statement number
        defb    tRANDOMIZE,tUSR         ; token RANDOMIZE, token USR
        defm    "24000",$0e0000c05d00   ; number 24000, ascii & internal format
end30:  defb    $0d                     ; line end marker

program_end:

variables_end:

; ---------------------------------------------------
;		a machine code block:
; ---------------------------------------------------

#code CODE_HEADER,0,17,headerflag
	defb    3			; Indicates binary data
	defb    "mcode     "	  	; the block name, 10 bytes long
	defw    code_end-code_start	; length of data block which follows
	defw    code_start		; default location for the data
	defw    0       		; unused


#code CODE_DATA, code_start,*,dataflag

; Z80 assembler code and data

	org 32687

	ld a,49         ; blue ink (1) on yellow paper (6*8).
	ld (23693),a    ; set our screen colours.
	call 3503       ; clear the screen.

	ld hl,udgs      ; UDGs.
	ld (23675),hl   ; set up UDG system variable.
	ld a,2          ; 2 = upper screen.
	call 5633       ; open channel.

setcolor:
	ld a,(color_flag)
	cp 2
	jr z, colorblue
	cp 1
	jr z, colorgreen
colorred:
	ld a,16         ; set ink to red
	rst 16
	ld a,2
	rst 16
	ld hl,color_flag
	inc (hl)
	jp loop
colorgreen:
	ld a,16         ; set ink to green
	rst 16
	ld a,4
	rst 16
	ld hl,color_flag
	inc (hl)
	jp loop
colorblue:
	ld a,16         ; set ink to blue
	rst 16
	ld a,1
	rst 16
	ld hl,color_flag
	ld (hl),0
	jp loop

loop:
	ld a,144        ; show UDG instead of asterisk.
	rst 16          ; display it.
	jp setcolor	; no, carry on. change color
	ret
setxy:
	ld a,22         ; ASCII control code for AT.
	rst 16          ; print it.
	ld a,(xcoord)   ; vertical position.
	rst 16          ; print it.
	ld a,(ycoord)   ; y coordinate.
	rst 16          ; print it.
	ret

xcoord:
	defb 0
ycoord:
	defb 0
color_flag:
	defb 0
udgs:
	; pacman thing
	defb 60,126,219,153
	defb 255,255,219,219

	; Manic Miner central cavern, unused so far
	DEFB 22,0,0,0,0,0,0,0
	DEFB 0,0,0,5,0,0,0,0
	DEFB 5,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,22
	DEFB 22,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,22
	DEFB 22,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,22
	DEFB 22,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,22
	DEFB 22,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,68
	DEFB 0,0,0,68,0,0,0,22
	DEFB 22,66,66,66,66,66,66,66
	DEFB 66,66,66,66,66,66,2,2
	DEFB 2,2,66,2,2,2,2,66
	DEFB 66,66,66,66,66,66,66,22
	DEFB 22,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,22
	DEFB 22,66,66,66,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,22
	DEFB 22,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,22,22,22,0,68,0,0
	DEFB 0,0,0,0,0,0,0,22
	DEFB 22,66,66,66,66,0,0,0
	DEFB 4,4,4,4,4,4,4,4
	DEFB 4,4,4,4,4,4,4,4
	DEFB 4,4,4,4,0,0,0,22
	DEFB 22,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,66,66,22
	DEFB 22,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,22
	DEFB 22,0,0,0,0,0,0,0
	DEFB 0,0,0,0,68,0,0,0
	DEFB 0,0,0,0,22,22,22,2
	DEFB 2,2,2,2,66,66,66,22
	DEFB 22,0,0,0,0,66,66,66
	DEFB 66,66,66,66,66,66,66,66
	DEFB 66,66,66,66,0,0,0,0
	DEFB 0,0,0,0,0,0,0,22
	DEFB 22,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,22
	DEFB 22,66,66,66,66,66,66,66
	DEFB 66,66,66,66,66,66,66,66
	DEFB 66,66,66,66,66,66,66,66
	DEFB 66,66,66,66,66,66,66,22

code_end:
