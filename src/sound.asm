; ------------------------------------------------------------------
; Plays on puyo settling
; ------------------------------------------------------------------
puyodrop_se:
	di

	; initial pitches
	ld c,180
	ld e,240
	ld b,c
	ld d,e

puyodrop_se_sloop:
	ld hl,0x50
puyodrop_se_pitchloop:
	xor a
	dec b
	jr nz, puyodrop_se_sk1
	ld b,c
	ld a,$10
puyodrop_se_sk1:
	out ($fe),a

	xor a
	dec d
	jr nz, puyodrop_se_sk2
	ld d,e
	ld a,$10
puyodrop_se_sk2:
	out ($fe),a

	dec hl
	ld a,l
	or h
	jr nz,puyodrop_se_pitchloop
puyodrop_se_pitchchange:
	dec c
	; compare to cutoff
	ld a,50
	cp c
	jr nc,puyodrop_se_cleanup
	dec e
	jr z,puyodrop_se_cleanup
	jr puyodrop_se_sloop
puyodrop_se_cleanup:
	ei
	ret



; ------------------------------------------------------------------
; Plays on puyo rotate
; ------------------------------------------------------------------
puyorotate_se:
	di

	; initial pitches
	ld c,230

puyorotate_se_sloop:
	ld hl,0x1200
puyorotate_se_pitchloop:
	xor a
	dec b
	jr nz, puyorotate_se_sk1
	ld b,c
	ld a,$10
puyorotate_se_sk1:
	out ($fe),a

	dec hl
	ld a,l
	or h
	jr nz,puyorotate_se_pitchloop
puyorotate_se_cleanup:
	ei
	ret



; ------------------------------------------------------------------
; Plays on puyo clear
; ------------------------------------------------------------------
puyoclear_se:
	di

	; initial pitches
	ld c,120
	ld e,100
	ld b,c
	ld d,e

puyoclear_se_sloop_low:
	ld hl,0x400
puyoclear_se_pitchloop_low:
	xor a
	dec b
	jr nz, puyoclear_se_low_sk1
	ld b,c
	ld a,$10
puyoclear_se_low_sk1:
	out ($fe),a

	xor a
	dec d
	jr nz, puyoclear_se_low_sk2
	ld d,e
	ld a,$10
puyoclear_se_low_sk2:
	out ($fe),a

	dec hl
	ld a,l
	or h
	jr nz,puyoclear_se_pitchloop_low
puyoclear_se_pitchup:
	ld a,c
	sub 50
	ld c,a
	ld a,e
	sub 50
	ld e,a

	ld a,10      ; threshold
	cp e
	jr nc, puyoclear_se_cleanup
puyoclear_se_sloop_high:
	ld hl,0x400
puyoclear_se_pitchloop_high:
	xor a
	dec b
	jr nz, puyoclear_se_high_sk1
	ld b,c
	ld a,$10
puyoclear_se_high_sk1:
	out ($fe),a

	xor a
	dec d
	jr nz, puyoclear_se_high_sk2
	ld d,e
	ld a,$10
puyoclear_se_high_sk2:
	out ($fe),a

	dec hl
	ld a,l
	or h
	jr nz,puyoclear_se_pitchloop_high
puyoclear_se_pitchdown:
	ld a,c
	add 40
	ld c,a
	ld a,e
	add 40
	ld e,a

	jr puyoclear_se_sloop_low
puyoclear_se_cleanup:
	ei
	ret


; ------------------------------------------------------------------
; Plays on gameover
; ------------------------------------------------------------------
gameover_se:
	di

	; initial pitches
	ld c,120
	ld e,100
	ld b,c
	ld d,e

gameover_se_start_sloop_low:
	ld hl,0x400
gameover_se_start_pitchloop_low:
	xor a
	dec b
	jr nz, gameover_se_start_low_sk1
	ld b,c
	ld a,$10
gameover_se_start_low_sk1:
	out ($fe),a

	xor a
	dec d
	jr nz, gameover_se_start_low_sk2
	ld d,e
	ld a,$10
gameover_se_start_low_sk2:
	out ($fe),a

	dec hl
	ld a,l
	or h
	jr nz,gameover_se_start_pitchloop_low
gameover_se_start_pitchup:
	ld a,c
	sub 50
	ld c,a
	ld a,e
	sub 50
	ld e,a

	ld a,10      ; threshold
	cp e
	jr nc, gameover_se_body
gameover_se_start_sloop_high:
	ld hl,0x400
gameover_se_start_pitchloop_high:
	xor a
	dec b
	jr nz, gameover_se_start_high_sk1
	ld b,c
	ld a,$10
gameover_se_start_high_sk1:
	out ($fe),a

	xor a
	dec d
	jr nz, gameover_se_start_high_sk2
	ld d,e
	ld a,$10
gameover_se_start_high_sk2:
	out ($fe),a

	dec hl
	ld a,l
	or h
	jr nz,gameover_se_start_pitchloop_high
gameover_se_start_pitchdown:
	ld a,c
	add 40
	ld c,a
	ld a,e
	add 40
	ld e,a

	jr gameover_se_start_sloop_low

gameover_se_body:
	; initial pitches
	ld c,50
	ld e,30
	ld b,c
	ld d,e

gameover_se_sloop_low:
	ld hl,0x500
gameover_se_pitchloop_low:
	xor a
	dec b
	jr nz, gameover_se_low_sk1
	ld b,c
	ld a,$10
gameover_se_low_sk1:
	out ($fe),a

	xor a
	dec d
	jr nz, gameover_se_low_sk2
	ld d,e
	ld a,$10
gameover_se_low_sk2:
	out ($fe),a

	dec hl
	ld a,l
	or h
	jr nz,gameover_se_pitchloop_low
gameover_se_pitchup:
	ld a,c
	sub 40
	ld c,a
	ld a,e
	sub 40
	ld e,a
gameover_se_sloop_high:
	ld hl,0x500
gameover_se_pitchloop_high:
	xor a
	dec b
	jr nz, gameover_se_high_sk1
	ld b,c
	ld a,$10
gameover_se_high_sk1:
	out ($fe),a

	xor a
	dec d
	jr nz, gameover_se_high_sk2
	ld d,e
	ld a,$10
gameover_se_high_sk2:
	out ($fe),a

	dec hl
	ld a,l
	or h
	jr nz,gameover_se_pitchloop_high
gameover_se_pitchdown:
	ld a,c
	add 50
	jr c,gameover_se_closing
	ld c,a
	ld a,e
	add 50
	ld e,a

	jr gameover_se_sloop_low

gameover_se_closing:
	ld c,240
	ld e,220

	ld hl,0x3000
gameover_se_closingloop:
	xor a
	dec b
	jr nz, gameover_se_closing_sk1
	ld b,c
	ld a,$10
gameover_se_closing_sk1:
	out ($fe),a

	xor a
	dec d
	jr nz, gameover_se_closing_sk2
	ld d,e
	ld a,$10
gameover_se_closing_sk2:
	out ($fe),a

	dec hl
	ld a,l
	or h
	jr nz,gameover_se_closingloop

gameover_se_cleanup:
	ei
	ret
	ld b,c
	ld d,e


sound_test:
	ld ix,theme_music_data
	call play_theme_music
	ret