

; ==================================================================
; FILE: layout.asm
; ------------------------------------------------------------------
;   Contains routines to draw entire screen layout and game area.
; ==================================================================


; ------------------------------------------------------------------
; Macros
; ------------------------------------------------------------------
TOPLEFT_VISIBLE equ 0x1818
TOPLEFT_HIDDEN  equ 0x1018
TOTAL_CELLS     equ 66

; ------------------------------------------------------------------
; init_background: Draw initial background with play area.
; ------------------------------------------------------------------
; Input: None
; Output:
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e, h, l
; ------------------------------------------------------------------
init_background:
    call populate_coord_tab
    ld bc,TOPLEFT_VISIBLE
init_background_clear:
    ld hl,18                ; push loop counter = rows*2
    push hl
init_background_clear_loop:
    call get_attr_address   ; get attr addr of left cell
    ld h,11
    xor a
    ld (de),a
init_background_clear_row_loop:
    inc de
    ld (de),a
    dec h
    cp h
    jp nz,init_background_clear_row_loop
    ld a,8
    add a,b
    ld b,a
    pop hl
    dec hl
    push hl
    xor a
    cp l
    jp nz,init_background_clear_loop
    pop hl
    ld hl,background_data   ; fill entire screen with background
    call fill_screen_data
    ret

; ------------------------------------------------------------------
; TODO: score layout
; ------------------------------------------------------------------
; Input:
; Output:
; ------------------------------------------------------------------
; Registers polluted:
; ------------------------------------------------------------------


; ------------------------------------------------------------------
; TODO
; update_board_pixel: update pixel data of gameplay area from board map
; ------------------------------------------------------------------
; Input:
; Output:
; ------------------------------------------------------------------
; Registers polluted:
; ------------------------------------------------------------------
update_board_pixel:
    ld de,0xffff            ; push stack end marker
    push de
    ld c,TOTAL_CELLS        ; setup initial counter and values
    ld e,0
    ld hl,sample_boardmap
update_board_pixel_write    ; read all cell values, push existing ones to stack
    ld d,(hl)               ; load current map cell
    ld a,d
    and 0x01
    jp z,update_board_pixel_next
    push de                 ; push: cell value (d) & position number (e)
update_board_pixel_next:
    inc hl
    inc e
    dec c
    cp c
    jp nz,update_board_pixel_write

update_board_pixel_read:
    pop de                  ; pop values, compare to 0xffff
    ld a,0xff
    cp d
    jp nz,update_board_pixel_draw
update_board_pixel_cp:
    cp e
    jp z,update_board_pixel_done
update_board_pixel_draw:
    ld b,0                  ; put coordinates in bc
    ld c,e
    call get_board_to_coord
    ld hl,puyo_none         ; put sprite address in hl

update_board_pixel_done:
    ret

; ------------------------------------------------------------------
; TODO: update attributes of gameplay area from board map
; ------------------------------------------------------------------
; Input:
; Output:
; ------------------------------------------------------------------
; Registers polluted:
; ------------------------------------------------------------------
update_board_attribute:

