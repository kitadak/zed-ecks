

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
    ld hl,background_data   ; fill entire screen with background
    call fill_screen_data
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
; TODO:
; draw_curr_pair: Update current airborne puyo pair on the screen
; ------------------------------------------------------------------
; Input:
; Output:
; ------------------------------------------------------------------
; Registers polluted:
; ------------------------------------------------------------------


; ------------------------------------------------------------------
; refresh_board: update play area from board map
; ------------------------------------------------------------------
; Input: None
; Output: all cell pixel data & attr in play area updated
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e, h, l
; ------------------------------------------------------------------
refresh_board:
    ld bc,TOPLEFT_VISIBLE   ; clear play area
    call init_background_clear

    ld de,0xffff            ; push stack end marker
    push de
    ld c,TOTAL_CELLS        ; setup initial counter and values
    ld b,1                  ; row counter -- to ignore hidden row
    ld e,0                  ; position index
    ld hl,sample_boardmap
refresh_board_write:         ; read all cell values, push existing ones to stack
    xor a                   ; clear a for comparison
    dec b                   ; decrement row counter, check for hidden row
    cp b
    jp z,refresh_board_hidden    ; if hidden row, do not push, refresh b
    ld d,(hl)               ; load current map cell
    ld a,d
    and 0x01
    jp z,refresh_board_next ; if cell empty, do not push
refresh_board_push:
    push de                 ; push: cell value (d) & position number (e)
    ld a,d                  ; push: 2 -bit attr indicator (d) & position (e)
    and %00001100
    srl a
    srl a
    ld d,a
    push de
    jp refresh_board_next
refresh_board_hidden:
    ld b,10
refresh_board_next:
    inc hl                  ; increment pointer to cell in boardmap
    inc e                   ; increment position index
    xor a
    dec c                   ; decrement cell counter, check if reached last cell
    cp c
    jp nz,refresh_board_write

refresh_board_read:
    pop de                  ; pop values, compare to 0xff
    ld a,0xff
    cp e
    jp z,refresh_board_done
refresh_board_draw:
    ld b,0                  ; put coordinates in bc
    ld c,e
    call get_board_to_coord
    push bc
    ld hl,val_puyo_blue     ; load attribute value
    ld e,d
    ld d,0
    add hl,de
    ld l,(hl)
    call load_2x2_attr
    pop bc                  ; calculate sprite address
    pop de
    ld a,0xf0               ; should be puyo_none + orientation*32
    and a,d
    sla a
    ld e,a
    xor a
    adc a,a
    ld d,a
    ld hl,puyo_none
    add hl,de
    call load_2x2_data      ; draw puyo
    jp refresh_board_read    ; repeat until stack marker reached
refresh_board_done:
    ret

; ------------------------------------------------------------------
; Test variables
; ------------------------------------------------------------------
curr_pair: defs 1,0x77
old_pair: defs 1,0x77
color_pair: defs 1,0xa8

