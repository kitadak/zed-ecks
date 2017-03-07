

; ==================================================================
; FILE: layout.asm
; ------------------------------------------------------------------
;   Contains routines to draw entire screen layout and game area.
; ==================================================================


; ------------------------------------------------------------------
; init_background: Draw initial background with play area.
; ------------------------------------------------------------------
; Input: None
; Output:
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e, h, l
; ------------------------------------------------------------------
init_background:
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
; update_board_pixel: update pixel data of play area from board map
; ------------------------------------------------------------------
; Input: None
; Output: all cell pixel data in play area updated
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e, h, l
; ------------------------------------------------------------------
update_board_pixel:
    ld de,0xffff            ; push stack end marker
    push de
    ld c,TOTAL_CELLS        ; setup initial counter and values
    ld b,1                  ; row counter -- to ignore hidden row
    ld e,0                  ; position index
    ld hl,sample_boardmap
update_board_pixel_write:   ; read all cell values, push existing ones to stack
    xor a                   ; clear a for comparison
    dec b                   ; decrement row counter, check for hidden row
    cp b
    jp z,update_board_pixel_hidden  ; if hidden row, do not push, refresh b
    ld d,(hl)               ; load current map cell
    ld a,d
    and 0x01
    jp z,update_board_pixel_next    ; if cell empty, do not push
update_board_pixel_push:
    push de                 ; push: cell value (d) & position number (e)
    jp update_board_pixel_next
update_board_pixel_hidden:
    ld b,10
update_board_pixel_next:
    inc hl                  ; increment pointer to cell in boardmap
    inc e                   ; increment position index
    xor a
    dec c                   ; decrement cell counter, check if reached last cell
    cp c
    jp nz,update_board_pixel_write

update_board_pixel_read:
    pop de                  ; pop values, compare to 0xff
    ld a,0xff
    cp e
    jp z,update_board_pixel_done
update_board_pixel_draw:
    ld b,0                  ; put coordinates in bc
    ld c,e
    call get_board_to_coord
    ld e,0                  ; calculate sprite address
    ld a,0x10
    and a,d
    ld d,a
    srl d                   ; should be puyo_none + orientation*32
    srl d
    srl d
    ld hl,puyo_none
    ld de,%0000000111100000
    add hl,de

    ; only include attr for testing
    push bc
    call load_2x2_data      ; draw puyo
    pop bc
    ld l,puyo_green         ; load attr data
    call load_2x2_attr

    jp update_board_pixel_read  ; repeat until stack marker reached
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

