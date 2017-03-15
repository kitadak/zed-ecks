; ------------------------------------------------------------------
; Something like shepherd's tone
; ------------------------------------------------------------------
shepherd_se:
	di

	; initial pitches
	ld c,120
	ld e,100
	ld b,c
	ld d,e

shepherd_se_sloop_low:
	ld hl,0x500
shepherd_se_pitchloop_low:
	xor a
	dec b
	jr nz, shepherd_se_low_sk1
	ld b,c
	ld a,$10
shepherd_se_low_sk1:
	out ($fe),a

	xor a
	dec d
	jr nz, shepherd_se_low_sk2
	ld d,e
	ld a,$10
shepherd_se_low_sk2:
	out ($fe),a

	dec hl
	ld a,l
	or h
	jr nz,shepherd_se_pitchloop_low
shepherd_se_pitchup:
	ld a,c
	sub 50
	ld c,a
	ld a,e
	sub 60
	ld e,a
shepherd_se_sloop_high:
	ld hl,0x500
shepherd_se_pitchloop_high:
	xor a
	dec b
	jr nz, shepherd_se_high_sk1
	ld b,c
	ld a,$10
shepherd_se_high_sk1:
	out ($fe),a

	xor a
	dec d
	jr nz, shepherd_se_high_sk2
	ld d,e
	ld a,$10
shepherd_se_high_sk2:
	out ($fe),a

	dec hl
	ld a,l
	or h
	jr nz,shepherd_se_pitchloop_high
shepherd_se_pitchdown:
	ld a,c
	add 40
	ld c,a
	ld a,e
	add 40
	ld e,a

	jr shepherd_se_sloop_low
shepherd_se_cleanup:
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