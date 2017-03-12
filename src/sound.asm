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
	ld c,70
	ld e,50
	ld b,c
	ld d,e

puyoclear_se_sloop_low:
	ld hl,0x500
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
	sub 40
	ld c,a
	ld a,e
	sub 40
	ld e,a
puyoclear_se_sloop_high:
	ld hl,0x500
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
	add 50
	ld c,a

	ld a,120
	cp c
	jr c, puyoclear_se_cleanup

	ld a,e
	add 50
	ld e,a

	jr puyoclear_se_sloop_low
puyoclear_se_cleanup:
	ei
	ret


; ------------------------------------------------------------------
; Plays scary sequence
; ------------------------------------------------------------------
scary_se:
	di

	; initial pitches
	ld c,100
	ld e,80
	ld b,c
	ld d,e

scary_se_sloop_low:
	ld hl,0x1200
scary_se_pitchloop_low:
	xor a
	dec b
	jr nz, scary_se_low_sk1
	ld b,c
	ld a,$10
scary_se_low_sk1:
	out ($fe),a

	xor a
	dec d
	jr nz, scary_se_low_sk2
	ld d,e
	ld a,$10
scary_se_low_sk2:
	out ($fe),a

	dec hl
	ld a,l
	or h
	jr nz,scary_se_pitchloop_low
scary_se_pitchup:
	ld a,c
	sub 40
	ld c,a
	ld a,e
	sub 40
	ld e,a
scary_se_sloop_high:
	ld hl,0x1000
scary_se_pitchloop_high:
	xor a
	dec b
	jr nz, scary_se_high_sk1
	ld b,c
	ld a,$10
scary_se_high_sk1:
	out ($fe),a

	xor a
	dec d
	jr nz, scary_se_high_sk2
	ld d,e
	ld a,$10
scary_se_high_sk2:
	out ($fe),a

	dec hl
	ld a,l
	or h
	jr nz,scary_se_pitchloop_high
scary_se_pitchdown:
	ld a,c
	add 50
	ld c,a
	ld a,e
	add 50
	ld e,a

	jr scary_se_sloop_low
scary_se_cleanup:
	ei
	ret


; ------------------------------------------------------------------
; Plays on gameover
; ------------------------------------------------------------------
gameover_se:
	di

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

	ld hl,0x2500
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
	call puyoclear_se
	ret