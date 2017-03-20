; ------------------------------------------------------------------
; Adapted from MM disassembly
; ------------------------------------------------------------------
start_theme_music:
	ld ix,theme_music_data
play_theme_music:
	ld a,(ix)	; theme_music_data in ix
	cp 255
	ret z
	cp 254
	jr z, play_theme_music_rest

	ld b,0
	ld c,a
	ld d,(ix+1)
	ld e,(ix+2)
	ld a,$10
	jr play_theme_music_produce_note
	
play_theme_music_rest:
	ld b,0
	ld c,(ix+1)
	ld d,(ix+1)
	ld e,(ix+2)
	ld a,$00

play_theme_music_produce_note:
	out ($fe),a
	dec d
	jr nz,play_theme_music_skip1
	ld d,(ix+1)
	xor 0x10
play_theme_music_skip1:
	dec e
	jr nz,play_theme_music_skip2
	ld e,(ix+2)
	xor 0x10
play_theme_music_skip2:
	djnz play_theme_music_produce_note
	dec c
	jr nz,play_theme_music_produce_note

	; check keyboard input here to stop music
	ld a, 0xBF
    in a, (0xFE)
    cpl
    and 0x1
	ret nz

	inc ix
	inc ix
	inc ix
	jr play_theme_music


play_one_note:
	ld a,(ix)	; theme_music_data in ix
	cp 254
	jr z, play_one_note_rest

	ld b,0
	ld c,a
	ld d,(ix+1)
	ld e,(ix+2)
	ld a,$10
	jr play_one_note_produce_note

play_one_note_rest:
	ld b,0
	ld c,(ix+1)
	ld d,(ix+1)
	ld e,(ix+2)
	ld a,$00

play_one_note_produce_note:
	out ($fe),a
	dec d
	jr nz,play_one_note_skip1
	ld d,(ix+1)
	xor 0x10
play_one_note_skip1:
	dec e
	jr nz,play_one_note_skip2
	ld e,(ix+2)
	xor 0x10
play_one_note_skip2:
	djnz play_one_note_produce_note
	dec c
	jr nz,play_one_note_produce_note

	; check keyboard input here to stop music
	ld a, 0xBF
    in a, (0xFE)
    cpl
    and 0x1
	ret nz

	inc ix
	inc ix
	inc ix
	ret