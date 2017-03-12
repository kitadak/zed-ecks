; This code moves a character up, left, down, or right based on the HJKL keys

; Z80 assembler code and data

	ld a,49         ; blue ink (1) on yellow paper (6*8).
	ld (23693),a    ; set our screen colours.
	call 3503       ; clear the screen.

	ld hl,udgs      ; UDGs.
	ld (23675),hl   ; set up UDG system variable.
	ld a,2          ; 2 = upper screen.
	call 5633       ; open channel.


loop:

    call read_kbd   ; update our position based on input
	call setxy      ; set up our x/y coords.
	ld a,144        ; show UDG instead of asterisk.
	rst 16          ; display it.
	call delay      ; want a delay.
	call setxy      ; set up our x/y coords.
	ld a,32         ; ASCII code for space.
	rst 16		; delete old asterisk.
	call setxy      ; set up our x/y coords.
    jp loop
delay:
	ld b,2          ; length of delay.
delay0:
	halt            ; wait for an interrupt.
	djnz delay0     ; loop.
	ret             ; return.

setxy:
	ld a,22         ; ASCII control code for AT.
	rst 16          ; print it.
	ld a,(xcoord)   ; vertical position.
	rst 16          ; print it.
	ld a,(ycoord)   ; y coordinate.
	rst 16          ; print it.
	ret

read_kbd:
    ld bc,$BFFE     ; load keys HJKL(enter)
    in d,(c)        ; get status of keys
    ld a,d
    and $02         ; check if L is pressed
    jr z, move_right
    ld a,d
    and $04
    jr z, move_up
    ld a,d
    and $08
    jr z, move_down
    ld a,d
    and $10
    jr z, move_left
    ret

; move character in a direction based on keypress
move_up:
    ld hl, xcoord
    ld a,(hl)      ; are we at top of screen
    cp 0
    ret z
    dec (hl)
    ret

move_down:
    ld hl, xcoord
    ld a,(hl)      ; are we at bottom of screen
    cp 21
    ret z
    inc (hl)
    ret

move_left:
    ld hl, ycoord
    ld a,(hl)      ; are we at left edge of screen
    cp 0
    ret z
    dec (hl)
    ret

move_right:
    ld hl, ycoord
    ld a,(hl)      ; are we at right edge of screen
    cp 31
    ret z
    inc (hl)
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
