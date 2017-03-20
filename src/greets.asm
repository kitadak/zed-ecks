start_greets:
	ld a,BACKGROUND_ATTR
	ld (23693), a
	call 3503
	ld a,2
	call 5633

	ld ix,theme_music_data

	ld de,GREETS_MESSAGE
	ld bc,EOGREETS-GREETS_MESSAGE    ; subtract to get length of string

greets_animated_print:
	; play next note
	push bc
	push de
	call play_one_note
	pop de
	pop bc

	; check keyboard input here to stop music
	ld a, 0xBF
    in a, (0xFE)
    cpl
    and 0x1
	ret nz

greets_print_next_char:
	; print next character
	ld a,b
	or c
	dec bc
	jr z,greets_animated_print_end
	ld a,(de)
	inc de
	rst 10h
	ld a,(de)
	;cp 22
	;jr nz, greets_print_next_char
	jr greets_animated_print

greets_animated_print_end:
	call play_theme_music
	ret