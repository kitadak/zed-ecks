; ------------------------------------------------------------------
; Adapted from MM disassembly
; ------------------------------------------------------------------
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

	; TODO: check keyboard input here to stop music
	; call check_menu_key
	; ret nz

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

	; TODO: check keyboard input here to stop music
	; call check_menu_key
	; ret nz

	inc ix
	inc ix
	inc ix
	jr play_theme_music

theme_music_data:
	defb 40,104,105
	defb 40,69,70
	defb 20,92,93
	defb 40,69,70
	defb 40,87,88
	defb 40,69,70
	defb 20,69,70
	defb 20,78,79
	defb 20,87,88
	defb 40,92,93
	defb 40,104,105
	defb 40,69,70
	defb 40,92,93
	defb 20,69,70
	defb 40,87,88
	defb 40,69,70
	defb 20,69,70
	defb 40,117,118
	defb 40,111,112
	defb 40,104,105
	defb 40,69,70
	defb 20,92,93
	defb 40,69,70
	defb 40,87,88
	defb 40,69,70
	defb 20,69,70
	defb 20,78,79
	defb 20,87,88
	defb 40,92,93
	defb 40,104,105
	defb 40,69,70
	defb 40,92,93
	defb 20,69,70
	defb 40,87,88
	defb 40,69,70
	defb 20,69,70
	defb 40,117,118
	defb 40,111,112
	defb 40,104,105
	defb 40,69,70
	defb 20,92,93
	defb 40,69,70
	defb 40,87,88
	defb 40,69,70
	defb 20,69,70
	defb 20,78,79
	defb 20,87,88
	defb 40,92,93
	defb 40,104,105
	defb 40,69,70
	defb 40,92,93
	defb 20,69,70
	defb 40,87,88
	defb 40,69,70
	defb 20,69,70
	defb 40,117,118
	defb 40,111,112
	defb 40,104,105
	defb 40,69,70
	defb 20,92,93
	defb 40,69,70
	defb 40,87,88
	defb 40,69,70
	defb 20,69,70
	defb 20,78,79
	defb 20,87,88
	defb 40,92,93
	defb 40,104,105
	defb 40,69,70
	defb 40,92,93
	defb 20,69,70
	defb 40,87,88
	defb 40,69,70
	defb 20,43,44
	defb 20,46,47
	defb 20,52,53
	defb 40,58,59
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,58,59
	defb 40,69,70
	defb 40,78,79
	defb 40,69,70
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,55,56
	defb 40,69,70
	defb 40,78,79
	defb 40,69,70
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,58,59
	defb 40,69,70
	defb 40,92,93
	defb 40,87,88
	defb 40,78,79
	defb 20,157,158
	defb 40,78,79
	defb 20,157,158
	defb 40,78,79
	defb 40,69,70
	defb 20,139,140
	defb 40,69,70
	defb 20,139,140
	defb 40,69,70
	defb 40,66,67
	defb 40,132,133
	defb 40,62,63
	defb 40,124,125
	defb 40,58,59
	defb 20,117,118
	defb 40,58,59
	defb 20,117,118
	defb 40,58,59
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,58,59
	defb 40,69,70
	defb 40,78,79
	defb 40,69,70
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,55,56
	defb 40,69,70
	defb 40,78,79
	defb 40,69,70
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,58,59
	defb 40,69,70
	defb 40,92,93
	defb 40,87,88
	defb 40,78,79
	defb 20,157,158
	defb 40,78,79
	defb 20,157,158
	defb 40,78,79
	defb 40,69,70
	defb 40,78,79
	defb 40,87,88
	defb 40,92,93
	defb 160,104,105
	defb 160,104,105
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,58,59
	defb 40,69,70
	defb 40,78,79
	defb 40,69,70
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,58,59
	defb 40,69,70
	defb 40,78,79
	defb 40,92,93
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,117,118
	defb 20,104,105
	defb 20,139,140
	defb 40,117,118
	defb 40,157,158
	defb 40,185,186
	defb 40,208,209
	defb 40,185,186
	defb 40,175,176
	defb 40,157,158
	defb 40,139,140
	defb 40,111,112
	defb 40,104,105
	defb 40,92,93
	defb 40,111,112
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,78,79
	defb 40,55,56
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,78,79
	defb 40,55,56
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,78,79
	defb 40,55,56
	defb 40,69,70
	defb 40,46,47
	defb 40,55,56
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,58,59
	defb 40,69,70
	defb 40,78,79
	defb 40,69,70
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,58,59
	defb 40,69,70
	defb 40,78,79
	defb 40,92,93
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,117,118
	defb 20,104,105
	defb 20,139,140
	defb 40,117,118
	defb 40,157,158
	defb 40,185,186
	defb 40,208,209
	defb 40,185,186
	defb 40,175,176
	defb 40,157,158
	defb 40,139,140
	defb 40,111,112
	defb 40,104,105
	defb 40,92,93
	defb 40,111,112
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,78,79
	defb 40,55,56
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,78,79
	defb 40,55,56
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,78,79
	defb 40,55,56
	defb 40,69,70
	defb 40,46,47
	defb 40,55,56
	defb 80,139,140
	defb 80,87,88
	defb 80,92,93
	defb 40,104,105
	defb 120,117,118
	defb 80,69,70
	defb 80,92,93
	defb 80,117,118
	defb 80,104,105
	defb 80,87,88
	defb 80,92,93
	defb 40,104,105
	defb 120,117,118
	defb 80,69,70
	defb 80,92,93
	defb 40,117,118
	defb 40,111,112
	defb 80,104,105
	defb 80,87,88
	defb 80,92,93
	defb 40,104,105
	defb 120,117,118
	defb 80,69,70
	defb 80,92,93
	defb 80,117,118
	defb 80,104,105
	defb 80,87,88
	defb 80,92,93
	defb 40,87,88
	defb 120,78,79
	defb 80,87,88
	defb 80,92,93
	defb 80,117,118
	defb 80,87,88
	defb 80,69,70
	defb 80,78,79
	defb 40,87,88
	defb 120,92,93
	defb 80,58,59
	defb 80,78,79
	defb 80,92,93
	defb 80,87,88
	defb 80,69,70
	defb 80,78,79
	defb 40,69,70
	defb 120,66,67
	defb 80,69,70
	defb 80,78,79
	defb 80,92,93
	defb 80,104,105
	defb 80,87,88
	defb 80,92,93
	defb 80,104,105
	defb 80,104,105
	defb 80,66,67
	defb 80,69,70
	defb 80,78,79
	defb 160,69,70
	defb 160,62,63
	defb 160,55,56
	defb 160,55,56
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,58,59
	defb 40,69,70
	defb 40,78,79
	defb 40,69,70
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,55,56
	defb 40,69,70
	defb 40,78,79
	defb 40,69,70
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,58,59
	defb 40,69,70
	defb 40,92,93
	defb 40,87,88
	defb 40,78,79
	defb 20,157,158
	defb 40,78,79
	defb 20,157,158
	defb 40,78,79
	defb 40,69,70
	defb 20,139,140
	defb 40,69,70
	defb 20,139,140
	defb 40,69,70
	defb 40,66,67
	defb 40,132,133
	defb 40,62,63
	defb 40,124,125
	defb 40,58,59
	defb 20,117,118
	defb 40,58,59
	defb 20,117,118
	defb 40,58,59
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,58,59
	defb 40,69,70
	defb 40,78,79
	defb 40,69,70
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,55,56
	defb 40,69,70
	defb 40,78,79
	defb 40,69,70
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,58,59
	defb 40,69,70
	defb 40,92,93
	defb 40,87,88
	defb 40,78,79
	defb 20,157,158
	defb 40,78,79
	defb 20,157,158
	defb 40,78,79
	defb 40,69,70
	defb 40,78,79
	defb 40,87,88
	defb 40,92,93
	defb 160,104,105
	defb 120,104,105
	defb 10,104,105
	defb 254,30,30
	defb 40,104,105
	defb 40,69,70
	defb 20,92,93
	defb 40,69,70
	defb 40,87,88
	defb 40,69,70
	defb 20,69,70
	defb 20,78,79
	defb 20,87,88
	defb 40,92,93
	defb 40,104,105
	defb 40,69,70
	defb 40,92,93
	defb 20,69,70
	defb 40,87,88
	defb 40,69,70
	defb 20,69,70
	defb 40,117,118
	defb 40,111,112
	defb 40,104,105
	defb 40,69,70
	defb 20,92,93
	defb 40,69,70
	defb 40,87,88
	defb 40,69,70
	defb 20,69,70
	defb 20,78,79
	defb 20,87,88
	defb 40,92,93
	defb 40,104,105
	defb 40,69,70
	defb 40,92,93
	defb 20,69,70
	defb 40,87,88
	defb 40,69,70
	defb 20,69,70
	defb 40,117,118
	defb 40,111,112
	defb 40,104,105
	defb 40,69,70
	defb 20,92,93
	defb 40,69,70
	defb 40,87,88
	defb 40,69,70
	defb 20,69,70
	defb 20,78,79
	defb 20,87,88
	defb 40,92,93
	defb 40,104,105
	defb 40,69,70
	defb 40,92,93
	defb 20,69,70
	defb 40,87,88
	defb 40,69,70
	defb 20,69,70
	defb 40,117,118
	defb 40,111,112
	defb 40,104,105
	defb 40,69,70
	defb 20,92,93
	defb 40,69,70
	defb 40,87,88
	defb 40,69,70
	defb 20,69,70
	defb 20,78,79
	defb 20,87,88
	defb 40,92,93
	defb 40,104,105
	defb 40,69,70
	defb 40,92,93
	defb 20,69,70
	defb 40,87,88
	defb 40,69,70
	defb 20,43,44
	defb 20,46,47
	defb 20,52,53
	defb 40,58,59
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,58,59
	defb 40,69,70
	defb 40,78,79
	defb 40,69,70
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,55,56
	defb 40,69,70
	defb 40,78,79
	defb 40,69,70
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,58,59
	defb 40,69,70
	defb 40,92,93
	defb 40,87,88
	defb 40,78,79
	defb 20,157,158
	defb 40,78,79
	defb 20,157,158
	defb 40,78,79
	defb 40,69,70
	defb 20,139,140
	defb 40,69,70
	defb 20,139,140
	defb 40,69,70
	defb 40,66,67
	defb 40,132,133
	defb 40,62,63
	defb 40,124,125
	defb 40,58,59
	defb 20,117,118
	defb 40,58,59
	defb 20,117,118
	defb 40,58,59
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,58,59
	defb 40,69,70
	defb 40,78,79
	defb 40,69,70
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,55,56
	defb 40,69,70
	defb 40,78,79
	defb 40,69,70
	defb 40,139,140
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 40,92,93
	defb 40,78,79
	defb 40,87,88
	defb 20,92,93
	defb 20,87,88
	defb 20,92,93
	defb 20,117,118
	defb 40,104,105
	defb 40,69,70
	defb 20,78,79
	defb 20,69,70
	defb 20,78,79
	defb 20,69,70
	defb 40,58,59
	defb 40,69,70
	defb 40,92,93
	defb 40,87,88
	defb 40,78,79
	defb 20,157,158
	defb 40,78,79
	defb 20,157,158
	defb 40,78,79
	defb 40,69,70
	defb 20,139,140
	defb 40,69,70
	defb 20,139,140
	defb 40,69,70
	defb 40,66,67
	defb 40,132,133
	defb 40,62,63
	defb 40,124,125
	defb 40,58,59
	defb 20,117,118
	defb 40,58,59
	defb 20,117,118
	defb 40,58,59
	defb 40,132,133
	defb 40,83,84
	defb 20,87,88
	defb 20,83,84
	defb 40,87,88
	defb 40,74,75
	defb 40,83,84
	defb 20,87,88
	defb 20,83,84
	defb 20,87,88
	defb 20,111,112
	defb 40,98,99
	defb 40,66,67
	defb 20,74,75
	defb 20,66,67
	defb 20,74,75
	defb 20,66,67
	defb 40,55,56
	defb 40,66,67
	defb 40,74,75
	defb 40,66,67
	defb 40,132,133
	defb 40,83,84
	defb 20,87,88
	defb 20,83,84
	defb 40,87,88
	defb 40,74,75
	defb 40,83,84
	defb 20,87,88
	defb 20,83,84
	defb 20,87,88
	defb 20,111,112
	defb 40,98,99
	defb 40,66,67
	defb 20,74,75
	defb 20,66,67
	defb 20,74,75
	defb 20,66,67
	defb 40,52,53
	defb 40,66,67
	defb 40,74,75
	defb 40,66,67
	defb 40,132,133
	defb 40,83,84
	defb 20,87,88
	defb 20,83,84
	defb 40,87,88
	defb 40,74,75
	defb 40,83,84
	defb 20,87,88
	defb 20,83,84
	defb 20,87,88
	defb 20,111,112
	defb 40,98,99
	defb 40,66,67
	defb 20,74,75
	defb 20,66,67
	defb 20,74,75
	defb 20,66,67
	defb 40,55,56
	defb 40,66,67
	defb 40,87,88
	defb 40,83,84
	defb 40,74,75
	defb 20,148,149
	defb 40,74,75
	defb 20,148,149
	defb 40,74,75
	defb 40,66,67
	defb 20,132,133
	defb 40,66,67
	defb 20,132,133
	defb 40,66,67
	defb 40,62,63
	defb 40,124,125
	defb 40,58,59
	defb 40,117,118
	defb 40,55,56
	defb 20,111,112
	defb 40,55,56
	defb 20,111,112
	defb 40,55,56
	defb 40,132,133
	defb 40,83,84
	defb 20,87,88
	defb 20,83,84
	defb 40,87,88
	defb 40,74,75
	defb 40,83,84
	defb 20,87,88
	defb 20,83,84
	defb 20,87,88
	defb 20,111,112
	defb 40,98,99
	defb 40,66,67
	defb 20,74,75
	defb 20,66,67
	defb 20,74,75
	defb 20,66,67
	defb 40,55,56
	defb 40,66,67
	defb 40,74,75
	defb 40,66,67
	defb 40,132,133
	defb 40,83,84
	defb 20,87,88
	defb 20,83,84
	defb 40,87,88
	defb 40,74,75
	defb 40,83,84
	defb 20,87,88
	defb 20,83,84
	defb 20,87,88
	defb 20,111,112
	defb 40,98,99
	defb 40,66,67
	defb 20,74,75
	defb 20,66,67
	defb 20,74,75
	defb 20,66,67
	defb 40,55,56
	defb 40,66,67
	defb 40,55,56
	defb 40,43,44
	defb 80,49,50
	defb 30,49,50
	defb 5,49,50
	defb 254,5,5
	defb 20,49,50
	defb 30,49,50
	defb 5,49,50
	defb 254,5,5
	defb 20,49,50
	defb 30,49,50
	defb 5,49,50
	defb 254,5,5
	defb 20,55,56
	defb 30,55,56
	defb 5,55,56
	defb 254,5,5
	defb 20,55,56
	defb 30,55,56
	defb 5,55,56
	defb 254,5,5
	defb 40,49,50
	defb 160,49,50
	defb 40,83,84
	defb 40,78,79
	defb 160,74,75
	defb 40,66,67
	defb 40,41,42
	defb 40,43,44
	defb 160,49,50
	defb 160,49,50
	defb 40,49,50


	defb 255