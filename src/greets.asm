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

GREETS_MESSAGE_22:
    defb 16,7
    defb 'CSE'
    defb 22,0,4
    defb '0175'
    defb 22,2,0
    defb 'Kenta'
    defb 22,2,6
    defb 'Kitada'
    defb 22,3,0
    defb 'Thao'
    defb 22,3,5
    defb 'Truong'
    defb 22,4,0
    defb 'Joshua'
    defb 22,4,7
    defb 'Tang'
    defb 22,5,0
    defb 'Professor'
    defb 22,5,10
    defb 'Hovav'
    defb 22,5,16
    defb 'Shacham'
    defb 22,20,0
    defb 'Special'
    defb 22,20,8
    defb 'thanks'
    defb 22,20,15
    defb 'to:'
    defb 22,21,0
    defb 'Adam'
    defb 22,21,5
    defb "Liu's"
    defb 22,21,11
    defb 'perfect'
    defb 22,21,19
    defb 'pitch.'
EOGREETS_22: equ $
