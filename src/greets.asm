start_greets:
	ld a,BACKGROUND_ATTR
	ld (23693), a
	call 3503
	ld a,2
	call 5633

	ld ix,hmc_music_data

	ld de,GREETS_MESSAGE_22
	ld bc,EOGREETS_22-GREETS_MESSAGE_22    ; subtract to get length of string

greets_animated_print:
	; play next note
	push bc
	push de
	call play_one_beat
	pop de
	pop bc

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
	cp 22
	jr nz, greets_print_next_char
	jr greets_animated_print

greets_animated_print_end:
	call play_theme_music
	ret