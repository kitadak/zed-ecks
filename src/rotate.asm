; curr_puyo
; 6b = position. 0d to 59d
; 2b = orientation. 00b=up, 01b=right, 10b=down, 11b=left

; ------------------------------------------------------------------
; rotate_clockwise: Rotate current puyo pair clockwise
; ------------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------------
; special cases:
; 1. curr_puyo in last column with up orientation 	 ---(50..59)---00
; 2. curr_puyo in first column with down orientation ---(0..9)---10
; 3. curr_puyo in last row with right orientation 	 ---(9,19,29,39,49,59)---01
; ------------------------------------------------------------------
rotate_clockwise:
	ld a, (curr_puyo)
	ld b, a 			; make copy of original

	and 0x03			; extract orientation
rotate_clockwise_1:
	jr nz,rotate_clockwise_2
	
	; check position
	ld a,b
	and 0xfc
	rrca
	rrca
	cp 49
	jr z, end_rotate_clockwise 		; = 49
	jr c, end_rotate_clockwise 		; < 49
	sub 10							; move to left column
	sla a
	sla a
	ld c, a

	; put new position to b
	ld a, b
	and 0x03
	or c
	ld b, a

	jr end_rotate_clockwise

rotate_clockwise_2:
	cp 0x02
	jr nz,rotate_clockwise_3

	; check position
	ld a,b
	and 0xfc
	rrca
	rrca
	cp 10
	jr z, end_rotate_clockwise 		; = 10
	jr nc, end_rotate_clockwise 	; > 10
	add 10							; move to right column
	sla a
	sla a
	ld c, a

	; put new position to b
	ld a, b
	and 0x03
	or c
	ld b, a

	jr end_rotate_clockwise

rotate_clockwise_3:
	cp 0x01
	jr nz,end_rotate_clockwise

	; check position
	ld a,b
	and 0xfc
	rrca
	rrca
	cp 9
	jr z, rotate_clockwise_bottom
	cp 19
	jr z, rotate_clockwise_bottom
	cp 29
	jr z, rotate_clockwise_bottom
	cp 39
	jr z, rotate_clockwise_bottom
	cp 49
	jr z, rotate_clockwise_bottom
	cp 59
	jr z, rotate_clockwise_bottom
	jr end_rotate_clockwise

rotate_clockwise_bottom:
	dec a							; move up a row
	sla a
	sla a
	ld c, a

	; put new position to b
	ld a, b
	and 0x03
	or c
	ld b, a

end_rotate_clockwise:
	; 00->01->10->11->00
	; increment last two bits
	ld a, b
	inc a
	and 0x03
	ld c, a

	; replace last two bits
	ld a, b
	and 0xfc
	or c
	ld (curr_puyo), a

	ret

; ------------------------------------------------------------------
; rotate_anticlockwise: Rotate current puyo pair anticlockwise
; ------------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------------
; special cases:
; 1. curr_puyo in first column with up orientation	 ---(0..9)---00
; 2. curr_puyo in last column with down orientation	 ---(50...59)---10
; 3. curr_puyo in last row with left orientation	 ---(9,19,29,39,49,59)---11
; ------------------------------------------------------------------
rotate_anticlockwise:
	ld a, (curr_puyo)
	ld b, a 			; make copy of original

	and 0x03			; extract orientation
rotate_anticlockwise_1:
	jr nz,rotate_anticlockwise_2
	
	; check position
	ld a,b
	and 0xfc
	rrca
	rrca
	cp 10
	jr z, end_rotate_anticlockwise 		; = 10
	jr nc, end_rotate_anticlockwise 	; > 10
	add 10								; move to right column
	sla a
	sla a
	ld c, a

	; put new position to b
	ld a, b
	and 0x03
	or c
	ld b, a

	jr end_rotate_anticlockwise

rotate_anticlockwise_2:
	cp 0x02
	jr nz,rotate_anticlockwise_3

	; check position
	ld a,b
	and 0xfc
	rrca
	rrca
	cp 49
	jr z, end_rotate_anticlockwise 	; = 49
	jr c, end_rotate_anticlockwise 	; < 49
	sub 10							; move to left column
	sla a
	sla a
	ld c, a

	; put new position to b
	ld a, b
	and 0x03
	or c
	ld b, a

	jr end_rotate_anticlockwise

rotate_anticlockwise_3:
	cp 0x03
	jr nz,end_rotate_anticlockwise

	; check position
	ld a,b
	and 0xfc
	rrca
	rrca
	cp 9
	jr z, rotate_anticlockwise_bottom
	cp 19
	jr z, rotate_anticlockwise_bottom
	cp 29
	jr z, rotate_anticlockwise_bottom
	cp 39
	jr z, rotate_anticlockwise_bottom
	cp 49
	jr z, rotate_anticlockwise_bottom
	cp 59
	jr z, rotate_anticlockwise_bottom
	jr end_rotate_anticlockwise

rotate_anticlockwise_bottom:
	dec a							; move up a row
	sla a
	sla a
	ld c, a

	; put new position to b
	ld a, b
	and 0x03
	or c
	ld b, a

end_rotate_anticlockwise:
	; 00->11->10->01->00
	ld a, b
	dec a
	and 0x03
	ld c, a

	; replace last two bits
	ld a, b
	and 0xfc
	or c
	ld (curr_puyo), a

	ret