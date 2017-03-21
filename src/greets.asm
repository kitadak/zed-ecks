start_greets:
	ld a,BACKGROUND_ATTR
	ld (23693), a
	call 3503
	ld a,2
	call 5633

	ld de,GREETS_MESSAGE_22
	ld bc,EOGREETS_22-GREETS_MESSAGE_22    ; subtract to get length of string

	ld hl,current_theme
	ld a,(hl)
    cp 0
    jr z, greets_hmc_theme
    cp 1
    jr z, greets_medley_theme
    cp 2
    jr z, greets_hungarian_theme
greets_hmc_theme:
	ld ix,hmc_music_data
	jr greets_animated_print
greets_medley_theme:
	ld ix,medley_music_data
	jr greets_animated_print
greets_hungarian_theme:
	ld ix,hungarian_music_data
	ld (hl),255
	jr greets_animated_print

greets_animated_print:
	; play next note
	push bc
	push de
	call play_one_beat
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
	cp 22
	jr nz, greets_print_next_char
	jr greets_animated_print

greets_animated_print_end:
	call play_theme_music
	ret

GREETS_MESSAGE_22:
    defb 16,7
    defb 19,1
    defb 'CSE'
    defb 22,0,4
    defb '0175'
    defb 22,0,9
    defb '-'
    defb 22,0,11

    defb 16,4
    defb 18,1
    defb 'Puyo'
    defb 22,0,15
    defb ' Puyo'
    defb 16,7
    defb 18,0

    defb 22,1,0
    defb 'Joshua'
    defb 22,1,7
    defb 'Tang'

    defb 22,2,0
    defb 'Kenta'
    defb 22,2,6
    defb 'Kitada'

    defb 22,3,0
    defb 'Thao'
    defb 22,3,5
    defb 'Truong'

    defb 22,4,0
    defb 'Professor'
    defb 22,4,10
    defb 'Hovav'
    defb 22,4,16
    defb 'Shacham'

    defb 16,7
    defb 17,1
    defb 22,6,0
    defb 'github.com'
    defb 22,6,10
    defb '/addtea'
    defb 22,6,17
    defb '/zed-ecks'
    defb 17,0

    defb 16,7
    defb 22,8,0
    defb 'Special'
    defb 22,8,8
    defb 'Thanks:'

    defb 19,0
    defb 22,9,1
    defb 'Adam'
    defb 22,9,6
    defb "Liu"

    defb 22,10,1
    defb 'Arjun'

    defb 22,11,1
    defb 'cobbpg'

    defb 22,12,1
    defb 'Compile'

    defb 22,13,1
    defb 'ClrHome'

    defb 22,14,1
    defb 'Dean'
    defb 22,14,6
    defb 'Belfield'

    defb 22,15,1
    defb 'Puyo'
    defb 22,15,6
    defb 'Nexus'

    defb 22,16,1
    defb 'RetroTechie'

    defb 22,17,1
    defb 'SevenuP'

    defb 22,18,1
    defb 'skoolkid'

    defb 22,19,1
    defb 'Y&K'

    defb 22,20,1
    defb 'z80-Heaven'

    defb 22,21,1
    defb 'ZX-Paintbrush'

    defb 19,1
    defb 22,8,18
    defb 'Music:'
    defb 19,0

    defb 22,9,19
    defb "Howl's"
    defb 22,10,20
    defb 'Moving'
    defb 22,11,20
    defb 'Castle'
    defb 22,12,20
    defb 'Theme'

    defb 22,14,19
    defb "Night"
    defb 22,14,25
    defb "of"
    defb 22,15,20
    defb "Nights"
    defb 22,16,20
    defb "Medley"

    defb 22,18,19
    defb "and..."
    defb 22,19,19
    defb "Hungarian"
    defb 22,20,20
    defb "Rhapsody"

EOGREETS_22: equ $
