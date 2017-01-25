#target tap
headerflag: equ 0
dataflag: equ 0xff

; some Basic tokens:
tCLEAR      equ     $FD             ; token CLEAR
tLOAD       equ     $EF             ; token LOAD
tCODE       equ     $AF             ; token CODE
tPRINT      equ     $F5             ; token PRINT
tRANDOMIZE  equ     $F9             ; token RANDOMIZE
tUSR        equ     $C0             ; token USR

pixels_start    equ 0x4000      ; ZXSP screen pixels
attr_start      equ 0x5800      ; ZXSP screen attributes
printer_buffer  equ 0x5B00      ; ZXSP printer buffer
code_start      equ 24000

#data VARIABLES, printer_buffer, 0x100

#code PROG_HEADER,0,17,headerflag
    defb    0
    defb    "mloader   "
    defw    variables_end-0
    defw    10
    defw    program_end-0

#code PROG_DATA,0,*,dataflag
    defb 0,10
    defb end10-($+1)
    defb 0
    defb tCLEAR
    defm "23999",$0e0000bf5d00
end10:  defb $0d
    defb 0,20
    defb end20-($+1)
    defb 0
    defb tLOAD,'"','"',tCODE
    defb "24000",$0e0000c05d00
end20: defb $0d
    defb 0,30
    defb end30-($+1)
    defb 0
    defb tRANDOMIZE,tUSR
    defm "24000",$0e0000c05d00
end30: defb $0d
program_end:
variables_end:

#code CODE_HEADER,0,17,headerflag
    defb 3
    defb "mcode     "
    defw code_end-code_start
    defw code_start
    defw 0

#code CODE_DATA, code_start,*,dataflag

       ld a,14             ; yellow ink (6) on blue paper (1*8).
       ld (23693),a        ; set our screen colours.
       call 3503           ; clear the screen.

       ld a,4              ; 4 code for green.
       call 8859           ; set border colour.

       ld hl,udgs      ; UDGs.
       ld (23675),hl   ; set up UDG system variable.
       ld a,2          ; 2 = upper screen.
       call 5633       ; open channel.
       ld a,21         ; row 21 = bottom of screen.
       ld (ycoord),a   ; set initial y coordinate.
loop   call setxy      ; set up our x/y coords.
       ld a,144        ; show UDG instead of asterisk.
       rst 16          ; display it.
       call delay      ; want a delay.
       call setxy      ; set up our x/y coords.
       ld a,32         ; ASCII code for space.
       rst 16          ; delete old asterisk.
       call setxy      ; set up our x/y coords.

       ld a,(dir)      ; jump according to direction
       cp 0
       jr z,left
       cp 1
       jr z,up
       cp 2
       jr z,right
       cp 3
       jr z,down

left   ld hl,xcoord    ; horizontal position.
       dec (hl)
       ld a,(xcoord)   ; where is it now?
       cp 0            ; left edge of screen?
       jp loopee

right  ld hl,xcoord    ; horizontal position.
       inc (hl)
       ld a,(xcoord)    ; where is it now?
       cp 31            ; right edge of screen?
       jp loopee

up     ld hl,ycoord    ; vertical position.
       dec (hl)
       ld a,(ycoord)   ; where is it now?
       cp 0            ; past top of screen yet?
       jp loopee

down   ld hl,ycoord    ; vertical position.
       inc (hl)
       ld a,(ycoord)   ; where is it now?
       cp 21            ; last row of screen?
       jp loopee

loopee jr nz,loop     ; no, carry on in this direction
       call incm4     ; change direction
       jp loop

incm4  ld hl,dir      ; increment and mod4
       inc (hl)
       ld a,(dir)       ; modulo
       cp 4
       jr z,incm4_sub
       ret
incm4_sub
       sub a
       ld (hl),a
       ret

delay  ld b,5          ; length of delay.
delay0 halt            ; wait for an interrupt.
       djnz delay0     ; loop.
       ret             ; return.
setxy  ld a,22         ; ASCII control code for AT.
       rst 16          ; print it.
       ld a,(ycoord)   ; vertical position.
       rst 16          ; print it.
       ld a,(xcoord)   ; horizontal position
       rst 16          ; print it.
       ret
ycoord defb 0
xcoord defb 31
dir    defb 0
udgs   defb 60,126,219,153
       defb 255,255,219,219

code_end:
