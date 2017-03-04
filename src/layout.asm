

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
; TODO: update pixel data of gameplay area from board map
; ------------------------------------------------------------------
; Input:
; Output:
; ------------------------------------------------------------------
; Registers polluted:
; ------------------------------------------------------------------
update_pixel:
    ; push stack end marker
    ; Check bits 1-0 for existence
    ; if exists, check state of sprite, push to stack
    ; translate coordinates, push to stack (NO TABLE, 3KB IS TOO MUCH)
    ; repeat til end of boardmap


; ------------------------------------------------------------------
; TODO: update attributes of gameplay area from board map
; ------------------------------------------------------------------
; Input:
; Output:
; ------------------------------------------------------------------
; Registers polluted:
; ------------------------------------------------------------------
update_attribute:

