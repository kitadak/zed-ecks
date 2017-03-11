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
code_start	equ	32768           ; org 32768

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

; 10 CLEAR 32767
        defb    0,10                    ; line number
        defb    end10-($+1)             ; line length
        defb    0                       ; statement number
        defb    tCLEAR                  ; token CLEAR
        defm    "32767",$0e0000ff7f00   ; number 32767, ascii & internal format
end10:  defb    $0d                     ; line end marker

; 20 LOAD "" CODE 32768
        defb    0,20                    ; line number
        defb    end20-($+1)             ; line length
        defb    0                       ; statement number
        defb    tLOAD,'"','"',tCODE     ; token LOAD, 2 quotes, token CODE
        defm    "32768",$0e0000008000   ; number 32768, ascii & internal format
end20:  defb    $0d                     ; line end marker

; 30 RANDOMIZE USR 32768
        defb    0,30                    ; line number
        defb    end30-($+1)             ; line length
        defb    0                       ; statement number
        defb    tRANDOMIZE,tUSR         ; token RANDOMIZE, token USR
        defm    "32768",$0e0000008000   ; number 32768, ascii & internal format
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


get_input:
    ld a, 0xFB                  ; load qwert row
    in a, (0xFE)

    cpl                         ; invert input
    and 0x02                    ; isolate W (bit 1)
    rrca                        ; move W to bit 6
    rrca
    rrca
    ld c, a                     ; store in C

    ld a, 0xFD                  ; load asdfg row
    in a, (0xFE)
    cpl
    and 0x07                    ; isolate ASD (bits 012)
                                ; ASD is already in place!
    or c                        ; combine previous results
    ld c, a

    ld a, 0xBF                  ; load hjklenter row
    in a, (0xFE)
    cpl
    and 0x18                    ; isolate JH (bits 34)
                                ; JH is already in place
    or c
    ld c, a

    ld a, 0xDF                  ; load yuiop row
    in a, (0xFE)
    cpl
    and 0x01                    ; isolate P (bit 0)
    rrca                        ; move P to bit 7
    or c
    ld (current_input), a       ; store result in c

test_p:
    bit 7, a
    jp z, test_w
    ld a, 2
    call 8859
test_w:
    ld hl, current_input
    ld a, (hl)

    bit 6, a
    jp z, test_j
    ld a, 3
    call 8859
test_j:
    ld hl, current_input
    ld a, (hl)

    bit 3, a
    jp z, test_h
    ld a, 4
    call 8859
test_h:
    ld hl, current_input
    ld a, (hl)

    bit 4, a
    jp z, test_a
    ld a, 5
    call 8859
test_a:
    ld hl, current_input
    ld a, (hl)
    bit 0, a
    jp z, test_s
    ld a, 6
    call 8859
test_s:
    ld hl, current_input
    ld a, (hl)
    bit 1, a
    jp z, test_d
    ld a, 7
    call 8859
test_d:
    ld hl, current_input
    ld a, (hl)
    bit 2, a
    jp z, get_input
    ld a, 0
    call 8859
    jp get_input


current_input: defb 0
code_end:
