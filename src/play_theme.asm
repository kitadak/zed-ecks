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

play_theme_music_rest:
	ld b,0
	ld c,(ix+1)
	ld d,(ix+1)
	ld e,(ix+2)
	ld a,$00
	
play_theme_music_produce_note_rest:
	out ($fe),a
	dec d
	jr nz,play_theme_music_skip1_rest
	ld d,(ix+1)
	xor 0x00
play_theme_music_skip1_rest:
	dec e
	jr nz,play_theme_music_skip2_rest
	ld e,(ix+2)
	xor 0x00
play_theme_music_skip2_rest:
	djnz play_theme_music_produce_note_rest
	dec c
	jr nz,play_theme_music_produce_note_rest

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