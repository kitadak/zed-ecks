

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
    ld hl,TOTAL_ROWS+TOTAL_ROWS-4   ; push loop counter = (visible rows)*2
    push hl
init_background_clear_loop:
    call get_attr_address   ; get attr addr of left cell
    ld h,TOTAL_COLUMNS+TOTAL_COLUMNS-5  ; column counter = (visible cols)*2-1
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
; Input: None
; Output: Erase previous position, draw new position of puyo pair
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e, h, l
; ------------------------------------------------------------------
draw_curr_pair:
    ld de,0xffff
    ld c,64
    xor a
test_push:
    push de
    dec c
    cp c
    jp nz,test_push

    ; push coordinates: curr pivot, curr 2nd, prev pivot, prev 2nd
    ld d,2
    ld hl,curr_pair+1       ; get current position info
    ld a,(hl)
    push af
    dec hl
draw_curr_pair_calc:
    ld a,(hl)
    ld c,a                  ; calculate coord of pivot & push
    ld b,0
    call get_board_to_coord

    pop af
    push bc
    ;ld hl,curr_pair+1
    ;ld a,(hl)
    and %00000011           ; calculate coord of 2nd
    ld e,a
    ld a,0x03
    cp e
    jp z,draw_curr_pair_left
    dec a
    cp e
    jp z,draw_curr_pair_down
    dec a
    cp e
    jp z,draw_curr_pair_right
draw_curr_pair_up:          ; b-16
    ld a,b
    ld e,16
    sub e
    ld b,a
    jp draw_curr_pair_push
draw_curr_pair_right:       ; c+16
    ld a,16
    add a,c
    ld c,a
    jp draw_curr_pair_push
draw_curr_pair_down:        ; b+16
    ld a,16
    add a,b
    ld b,a
    jp draw_curr_pair_push
draw_curr_pair_left:        ; c-16
    ld a,c
    ld e,16
    sub e
    ld c,a
draw_curr_pair_push:
    push bc
    ld hl,prev_pair+1
    ld a,(hl)
    push af
    dec hl

    xor a
    dec d
    cp d
    jp nz,draw_curr_pair_calc
    pop af

    ; finished pushing, pop to erase and draw next
    pop bc                  ; erase previous position first
    call erase_puyo_2x2
    pop bc
    call erase_puyo_2x2
    ld hl,pair_color        ; draw curr 2nd puyo
    ld a,(hl)
    ex af,af'               ; store a copy of color byte in a'
    ld a,(hl)
    ex af,af'
    and %00000011
    ld d,0
    ld e,a
    ld hl,val_puyo_blue
    add hl,de
    ld l,(hl)
    pop bc
    push bc
    call load_2x2_attr
    pop bc
    ld hl,puyo_none
    call load_2x2_data
    ex af,af'               ; draw curr pivot puyo
    and %00001100
    srl a
    srl a
    ex af,af'
    ld d,0
    ld e,a
    ld hl,val_puyo_blue
    add hl,de
    ld l,(hl)
    pop bc
    push bc
    call load_2x2_attr
    pop bc
    ld hl,puyo_none
    call load_2x2_data

    call inf_loop
    ret

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
    ld c,BOARD_SIZE         ; setup initial counter and values
    ld b,13                 ; row counter -- to ignore hidden row
    ld e,0                  ; position index
    ld hl,player_board
refresh_board_write:        ; read all cell values, push existing ones to stack
    xor a                   ; clear a for comparison
    dec b                   ; decrement row counter, check for hidden row
    cp b
    jp z,refresh_board_hidden   ; if hidden row, do not push, refresh b
    ld d,(hl)               ; load current map cell
    ld a,d
    and 0x07
    jp z,refresh_board_next ; if cell empty, do not push
    xor 0x07
    jp z,refresh_board_next ; if cell is wall, do not push
refresh_board_push:
    push de                 ; push: cell value (d) & position number (e)
    ld a,d                  ; push: attribute (d) & position (e)
    and 0x07                ; color
    or 0x40                 ; set to bright
    ld d,a
    push de
    jp refresh_board_next
refresh_board_hidden:
    ld b,12
refresh_board_next:
    inc hl                  ; increment pointer to cell in boardmap
    inc hl
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
    ld l,d
    call load_2x2_attr
    pop bc
    pop de                  ; calculate sprite address
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
    jp refresh_board_read   ; repeat until stack marker reached
refresh_board_done:
    ret

