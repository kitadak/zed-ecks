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
