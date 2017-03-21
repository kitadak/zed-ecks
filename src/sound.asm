current_theme: defb 0

; ------------------------------------------------------------------
; Adapted from MM disassembly
; Play looping theme music
; ------------------------------------------------------------------
start_theme_music:
	ld hl,current_theme
    inc (hl)
    ld a,(hl)
    cp 0
    jr z, start_hmc_theme
    cp 1
    jr z, start_medley_theme
    cp 2
    jr z, start_hAndD_theme
    cp 3
    jr z, start_nightofnights_theme
start_hmc_theme:
	ld ix,hmc_music_data
	jr play_theme_music
start_medley_theme:
	ld ix,medley_music_data
	jr play_theme_music
start_hAndD_theme:
	ld ix,hAndD_music_data
	jr play_theme_music
start_nightofnights_theme:
	ld ix,nightofnights_music_data
	ld (hl),255
	jr play_theme_music
play_theme_music:
	ld a,(ix)	; theme_music_data in ix
	cp 255
	jr z,start_theme_music
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

	; check keyboard input to go to next theme
	ld a, 0xFD
    in a, (0xFE)
    cpl
    and 0x1
	jr nz,start_theme_music

	inc ix
	inc ix
	inc ix
	jr play_theme_music

; ------------------------------------------------------------------
; Play sound effect from data in hl
; ------------------------------------------------------------------
play_sound_effect:
	ld a,(hl)	; data in hl
	cp 255
	ret z
	cp 254
	jr z, play_se_rest

	ld b,0
	ld c,a
	inc hl
	ld d,(hl)
	inc hl
	ld e,(hl)
	dec hl
	ld a,$10
	jr play_se_produce_note
	
play_se_rest:
	ld b,0
	inc hl
	ld c,(hl)
	ld d,(hl)
	inc hl
	ld e,(hl)
	dec hl
	ld a,$00

play_se_produce_note:
	out ($fe),a
	dec d
	jr nz,play_se_skip1
	ld d,(hl)
	xor 0x10
play_se_skip1:
	dec e
	jr nz,play_se_skip2
	inc hl
	ld e,(hl)
	dec hl
	xor 0x10
play_se_skip2:
	djnz play_se_produce_note
	dec c
	jr nz,play_se_produce_note

	inc hl
	inc hl
	jr play_sound_effect


; ------------------------------------------------------------------
; Play a "beat" of music equal to max(beat,note_length)
; ------------------------------------------------------------------
play_one_beat:
	ld l,60
play_one_note:
	ld a,(ix)	; theme_music_data in ix
	cp 255
	ret z
	cp 254
	jr z, play_one_note_rest

	ld b,0
	ld c,a

	ld a,l
	sub c
	jp po,set_beat_zero
	jr set_beat_zero_skip

set_beat_zero:
	ld l,0

set_beat_zero_skip:
	ld d,(ix+1)
	ld e,(ix+2)
	ld a,$10
	jr play_one_note_produce_note

play_one_note_rest:
	ld b,0
	ld c,(ix+1)

	ld a,l
	sub c
	jp po,set_beat_zero_2
	jr set_beat_zero_skip_2
	
set_beat_zero_2:
	ld l,0

set_beat_zero_skip_2:
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

	inc ix
	inc ix
	inc ix

	; continue unless reg l went below 0
	ld a,l
	cp 0
	jr nz,play_one_note
	ret