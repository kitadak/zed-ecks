

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
; draw_curr_pair: Update current airborne puyo pair on the screen
; ------------------------------------------------------------------
; Input: None
; Output: Erase previous position, draw new position of puyo pair
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e, h, l
; ------------------------------------------------------------------
; Note: This routine assumes that the puyo positions are valid,
;       although it will check for hidden row.
; ------------------------------------------------------------------
draw_curr_pair:
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
    call is_wall_hidden            ; check if pivot is wall
    cp e
    jp z,draw_curr_pair_push_1  ; if not wall, push normally, else push 0xffff
    ld bc,0xffff
draw_curr_pair_push_1:
    pop af
    push bc
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
    jp draw_curr_pair_wall_check
draw_curr_pair_right:       ; c+16
    ld a,16
    add a,c
    ld c,a
    jp draw_curr_pair_wall_check
draw_curr_pair_down:        ; b+16
    ld a,16
    add a,b
    ld b,a
    jp draw_curr_pair_wall_check
draw_curr_pair_left:        ; c-16
    ld a,c
    ld e,16
    sub e
    ld c,a

draw_curr_pair_wall_check:  ; if current cell is wall or hidden, push 0xffff
    call is_wall_hidden
    cp e
    jp z,draw_curr_pair_push_2  ; if not wall, push normally, else push 0xffff
    ld bc,0xffff
draw_curr_pair_push_2:
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
    ld a,0xff
    cp b
    jp z,draw_curr_pair_erase_skip_1   ; if wall, ignore
    call erase_puyo_2x2
draw_curr_pair_erase_skip_1:
    pop bc
    ld a,0xff
    cp b
    jp z,draw_curr_pair_erase_skip_2   ; if wall, ignore
    call erase_puyo_2x2
draw_curr_pair_erase_skip_2:
    pop bc
    ld a,0xff
    cp b
    jp z,draw_curr_pair_draw_skip_1
    ld a,(pair_color)       ; draw curr 2nd puyo
    and 0x07
    or %01000000
    ld l,a
    push bc
    call load_2x2_attr
    pop bc
    ld hl,puyo_none
    call load_2x2_data
draw_curr_pair_draw_skip_1:
    pop bc
    ld a,0xff
    cp b
    jp z,draw_curr_pair_draw_skip_2
    ld a,(pair_color)       ; draw curr pivot puyo
    srl a
    srl a
    srl a
    or %01000000
    ld l,a
    push bc
    call load_2x2_attr
    pop bc
    ld hl,puyo_none
    call load_2x2_data
draw_curr_pair_draw_skip_2:
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
    ld b,TOTAL_ROWS
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

; ------------------------------------------------------------------
; is_wall_hidden: check if given board coordinates are wall/hidden
; ------------------------------------------------------------------
; Input: bc - coordinates (as given by get_board_to_coord)
; Output: e - zero if not wall/hidden, 0xff otherwise
; ------------------------------------------------------------------
; Registers polluted: a, e
; ------------------------------------------------------------------
is_wall_hidden:
    ld a,WALL_LEFT
    cp c
    jp z,is_wall_hidden_true
    ld a,WALL_RIGHT
    cp c
    jp z,is_wall_hidden_true
    ld a,WALL_BOTTOM
    cp b
    jp z,is_wall_hidden_true
    ld a,HIDDEN_ROW
    cp b
    jp z,is_wall_hidden_true
    ld e,0
    ret
is_wall_hidden_true:
    ld e,0xff
    ret

; ------------------------------------------------------------------
; TODO
; drop_floats: drop all floating puyo down
; ------------------------------------------------------------------
; Input: None
; Output: puyo dropped with animation (delay),
;         player_board updated with all puyos settled
; ------------------------------------------------------------------
; Registers polluted: a
; ------------------------------------------------------------------
drop_floats:
    ; read the boardmap from bottom right visible cell, push & mark on boardmap
    ld bc,0xffff                ; push stack sentinel
    push bc
    push bc
    push bc
    ld hl,player_board+83+83
    ld c,83
    ld b,0
    ld e,TOTAL_ROWS
drop_floats_read:
    ld a,11                     ; check if finished top left cell
    cp c
    jp z,drop_floats_animate
    dec c
    dec hl
    dec hl
    dec e                       ; check if finished column
    xor a
    cp e
    jp z,drop_floats_wall
    ld a,(hl)                   ; read current cell
    and 0x07
    ld d,a
    xor a
    cp d
    jp nz,drop_floats_occupied  ; if cell occupied, don't inc space counter
    inc b                       ; if space, inc space count, go to next cell
    jp drop_floats_read
drop_floats_occupied:
    xor a
    cp b
    jp z,drop_floats_read       ; if already settled, skip
    push bc                     ; push original cell: space count (b), index (c)
    ld a,b                      ; mark # of spaces to drop on boardmap
    and 0x0f
    inc hl
    ld (hl),a
    dec hl
    jp drop_floats_read
drop_floats_wall:
    ld e,TOTAL_ROWS
    ld b,0
    jp drop_floats_read

drop_floats_animate:
    jp drop_floats_erase

    ; finish reading all board, start animation
    ld bc,0xfbfb
    push bc
    push bc
    push bc
    call inf_loop

drop_floats_erase:
    ; pop cell index & space counts, erase it on board
    ; push updated cell: value (b), index (c)
    pop de
    ld a,0xff
    cp d
    jr z,drop_floats_done       ; if reached stack sentinel, we're done
    ld hl,player_board          ; get original cell
    ld b,0
    ld c,e
    sla c
    add hl,bc
    ld a,(hl)                   ; store cell color in e
    and 0x07
    ld e,a
    ld (hl),b                   ; clear original cell on boardmap
    ld a,d                      ; get updated cell address
    sla a
    ld c,a
    add hl,bc
    ld (hl),e                   ; update new cell position
    jp drop_floats_erase

drop_floats_done:
    call refresh_board
    call inf_loop
    ret

