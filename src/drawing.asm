

; ==================================================================
; FILE: drawing.asm
; ------------------------------------------------------------------
;   Contains routines to draw entire screen layout and game area.
; ==================================================================


; ------------------------------------------------------------------
; init_title: Show title screen, play theme music.
; ------------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e, h, l
; ------------------------------------------------------------------
init_title:
    ld a,TITLE_BOTTOM_ATTR          ; load title background attribute
    ld (23693),a
	call $0daf			            ; clear the screen.
	ld hl,title_screen              ; load title graphic data (top 2/3)
	ld de,16384                     ; MAGIC - 0x4000
	ld bc,4096                      ; copy top 2/3 graphic data to screen
	ldir
	ld hl,title_attribute           ; load title attr
	ld	de,22528		            ; MAGIC
	ld bc,512			            ; copy 512 bytes of attr only
	ldir
    ld l,TITLE_FLASH_ATTR           ; load ENTER flash attr
    ld bc,0x8860
    call load_2x2_attr
    ld bc,0x8870
    call load_2x2_attr
    ld bc,0x8880
    call load_2x2_attr
init_title_dialog:                  ; load bottom 3rd data
    ld bc,0x0208
    push bc
    ld bc,0x9030
    call get_pixel_address
    ld hl,title_dialog_data_2
    push de
    xor a
init_title_dialog_loop:
    ld bc,21
    ldir
    pop de
    inc d
    pop bc
    dec c
    push bc
    push de
    cp c
    jp nz,init_title_dialog_loop
    pop de
    pop bc
    dec b
    xor a
    cp b
    jp z,init_title_dialog_end
    ld bc,0x0103
    push bc
    ld bc,0x8830
    call get_pixel_address
    ld a,5
    add a,d
    ld d,a
    push de
    xor a
    ld hl,title_dialog_data
    jp init_title_dialog_loop
init_title_dialog_end:
    ret

; ------------------------------------------------------------------
; TODO: score area
; init_background: Draw initial background with play area.
; ------------------------------------------------------------------
; Input: None
; Output:
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e, h, l
; ------------------------------------------------------------------
init_background:
    ld a,BACKGROUND_ATTR            ; load gameplay background attribute
    ld (23693),a                    ; set our screen colours.
    call 3503                       ; clear the screen.
    ld a,2                          ; 2 = upper screen.
    call 5633                       ; open channel.

    ; fill entire screen with background
    ld hl,background_data
    call fill_screen_data

    ; clear play area
    ld bc,TOPLEFT_VISIBLE
    ld hl,TOTAL_ROWS+TOTAL_ROWS-4
    exx
    ld d,TOTAL_COLUMNS+TOTAL_COLUMNS-4
    ld e,0
    exx
    call set_attr_block

    ; clear level & preview area
    ld bc,PREVIEW_COORDS_TOP        ; setup preview sprites
    ld hl,puyo_none
    call load_2x2_data
    ld bc,PREVIEW_COORDS_BOTTOM
    ld hl,puyo_none
    call load_2x2_data
    ld bc,LP_TOPLEFT                ; clear preview & level area
    ld hl,LP_ROWS
    exx
    ld d,LP_COLUMNS
    ld e,0
    exx
    call set_attr_block             ; load level text
    ld bc,msg_level
    ld hl,msg_level_end
    ld de,LEVEL_TEXT_POSITION
    call print_text
    ld bc,LEVEL_LINE                ; load level attr
    ld hl,1
    exx
    ld d,LP_COLUMNS
    ld e,LEVEL_ATTR
    exx
    call set_attr_block

    ; TODO:
    ; avatar area
    ; clear score area

    ret

; ------------------------------------------------------------------
; set_attr_block: set selected rectangle's attribute to given value
; ------------------------------------------------------------------
; Input: bc  - coordinates of top left cell
;        hl  - number of rows
;        d'  - number of columns
;        e'  - attribute byte
; Output: None
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e, h, l
; ------------------------------------------------------------------
set_attr_block:
    push hl                         ; push loop counter = rows
set_attr_block_loop:
    call get_attr_address           ; get attr addr of left cell
    exx                             ; get num of columns & attr byte
    push de
    exx
    pop hl
    dec h
    ld a,l
    ld (de),a
set_attr_block_row_loop:
    ld a,l
    inc de
    ld (de),a
    dec h
    xor a
    cp h
    jp nz,set_attr_block_row_loop
    ld a,8
    add a,b
    ld b,a
    pop hl
    dec l
    push hl
    xor a
    cp l
    jp nz,set_attr_block_loop
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
; is_wall_hidden: check if given board coordinates are wall/hidden
; ------------------------------------------------------------------
; Input: bc - coordinates (as given by get_board_to_coord)
; Output: e - zero if not wall/hidden, 0xff otherwise
; ------------------------------------------------------------------
; Registers polluted: a
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
    ld a,0
    ret
is_wall_hidden_true:
    ld a,0xff
    ret

; ------------------------------------------------------------------
; blink_delay: delay for CONST_DELAY*(input) time
; ------------------------------------------------------------------
; Input: c - delay loop count
; Output: None
; ------------------------------------------------------------------
; Registers polluted: a, b, c
; ------------------------------------------------------------------
blink_delay:
    ld b,CONST_DELAY
    xor a
blink_delay_loop:
    dec b
    cp b
    jp nz,blink_delay_loop
    dec c
    cp c
    ret z
    ld b,CONST_DELAY
    jp blink_delay_loop

; ------------------------------------------------------------------
; get_2nd_puyo_index: calculate 2nd puyo index from pivot
; ------------------------------------------------------------------
; Input: a - pair orientation
;        c - index of pivot
; Output: c - index of 2nd puyo in pair
; ------------------------------------------------------------------
; Registers polluted: a, c, e
; ------------------------------------------------------------------
get_2nd_puyo_index:
    and %00000011           ; calculate coord of 2nd
    ld e,a
    ld a,0x03
    cp e
    jp z,get_2nd_puyo_index_left
    dec a
    cp e
    jp z,get_2nd_puyo_index_down
    dec a
    cp e
    jp z,get_2nd_puyo_index_right
get_2nd_puyo_index_up:          ; c-1
    dec c
    jp get_2nd_puyo_index_end
get_2nd_puyo_index_right:       ; c+12
    ld a,c
    add a,12
    ld c,a
    jp get_2nd_puyo_index_end
get_2nd_puyo_index_down:        ; c+1
    inc c
    jp get_2nd_puyo_index_end
get_2nd_puyo_index_left:        ; c-12
    ld a,c
    sub 12
    ld c,a
get_2nd_puyo_index_end:
    ret

; ------------------------------------------------------------------
; get_2nd_puyo_coord: calculate 2nd puyo from pivot
; ------------------------------------------------------------------
; Input: a  - pair orientation
;        bc - coordinates of pivot
; Output: bc - coordinates of 2nd puyo in pair
; ------------------------------------------------------------------
; Registers polluted: a, b, c, e
; ------------------------------------------------------------------
get_2nd_puyo_coord:
    and %00000011           ; calculate coord of 2nd
    ld e,a
    ld a,0x03
    cp e
    jp z,get_2nd_puyo_coord_left
    dec a
    cp e
    jp z,get_2nd_puyo_coord_down
    dec a
    cp e
    jp z,get_2nd_puyo_coord_right
get_2nd_puyo_coord_up:          ; b-16
    ld a,b
    sub 16
    ld b,a
    jp get_2nd_puyo_coord_end
get_2nd_puyo_coord_right:       ; c+16
    ld a,c
    add a,16
    ld c,a
    jp get_2nd_puyo_coord_end
get_2nd_puyo_coord_down:        ; b+16
    ld a,b
    add a,16
    ld b,a
    jp get_2nd_puyo_coord_end
get_2nd_puyo_coord_left:        ; c-16
    ld a,c
    sub 16
    ld c,a
get_2nd_puyo_coord_end:
    ret

; ------------------------------------------------------------------
; draw_preview: display preview of next puyo pair
; ------------------------------------------------------------------
; Input: None
; Output: Next pair color displayed next to play area.
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e, h, l
; ------------------------------------------------------------------
draw_preview:
    ld hl,next_pair             ; get colors
    ld a,(hl)
    srl a
    srl a
    srl a
    and 0x07
    or 0x40
    push af
    ld a,(hl)
    and 0x07
    or 0x40
    ld l,a
    ld bc,PREVIEW_COORDS_TOP
    call load_2x2_attr
    pop af
    ld l,a
    ld bc,PREVIEW_COORDS_BOTTOM
    call load_2x2_attr
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
    ld hl,TOTAL_ROWS+TOTAL_ROWS-4
    exx
    ld d,TOTAL_COLUMNS+TOTAL_COLUMNS-4
    ld e,0
    exx
    call set_attr_block

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
    ld a,d                  ; should be puyo_none + orientation*32
    and 0xf0
    sla a
    ld e,a
    ld a,d
    ld d,0
    and 0x80
    cp 0
    jp z,refresh_board_calc
    ld d,1
refresh_board_calc:
    ld hl,puyo_none
    add hl,de
    call load_2x2_data      ; draw puyo
    jp refresh_board_read   ; repeat until stack marker reached
refresh_board_done:
    ret

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
    ld hl,curr_pair+1           ; get current position info
    ld a,(hl)
    push af
    dec hl
draw_curr_pair_calc:
    ld a,(hl)
    ld c,a                      ; calculate coord of pivot & push
    ld b,0
    call get_board_to_coord
    call is_wall_hidden         ; check if pivot is wall
    cp 0
    jp z,draw_curr_pair_push_1  ; if not wall, push normally, else push 0xffff
    ld bc,0xffff
draw_curr_pair_push_1:
    pop af
    push bc
    call get_2nd_puyo_coord     ; get coordinates of 2nd puyo
draw_curr_pair_wall_check:      ; if current cell is wall or hidden, push 0xffff
    call is_wall_hidden
    cp 0
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
    pop bc                      ; erase previous position first
    ld a,0xff
    cp b
    jp z,draw_curr_pair_erase_skip_1   ; if wall, ignore
    call erase_puyo_2x2
draw_curr_pair_erase_skip_1:
    pop bc
    ld a,0xff
    cp b
    jp z,draw_curr_pair_erase_skip_2   ; if wall, ignore
    pop hl
    pop de
    push hl
    push de
    ld a,b
    cp d
    jp nz,draw_curr_pair_erase_pivot   ; if same pivot, don't erase
    ld d,0
    ld a,c
    cp e
    jp z,draw_curr_pair_erase_skip_2
draw_curr_pair_erase_pivot:
    call erase_puyo_2x2
draw_curr_pair_erase_skip_2:
    pop bc
    ld a,0xff
    cp b
    jp z,draw_curr_pair_draw_skip_1
    ld a,(pair_color)           ; draw curr 2nd puyo
    srl a
    srl a
    srl a
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
    ld a,(pair_color)           ; draw curr pivot puyo
    and 0x07
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
; drop_floats: drop all floating puyo down
; ------------------------------------------------------------------
; Input: None
; Output: puyo dropped with animation (delay),
;         player_board updated with all puyos settled
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e, h, l
; ------------------------------------------------------------------
drop_floats:
    ; read the boardmap from bottom right visible cell, push & mark on boardmap
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
    jp z,drop_floats_read_wall
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
    ld a,b                      ; mark # of spaces to drop on boardmap
    and 0x0f
    inc hl
    ld (hl),a
    dec hl
    jp drop_floats_read
drop_floats_read_wall:
    ld e,TOTAL_ROWS
    ld b,0
    jp drop_floats_read

drop_floats_animate:
    ; finish reading all board, start animation
    ; hl - cell address in boardmap
    ; bc - cell coordinates
    ; de - floating cell count
    ; d - space count (cell 2nd byte)
    ld de,0xffff                ; push marker to indicate first run
    push de
    ld hl,player_board+22+22+1  ; start animation from bottom row
    ld bc,0xa018
drop_floats_animate_loop:
    ld a,0x78                   ; check if finished row
    cp c
    jp z,drop_floats_animate_wall_right
    ld d,(hl)                   ; load space count
    xor a
    cp d
    jp z,drop_floats_animate_next_cell  ; if zero, skip
    pop de                      ; check floating cell count
    ld a,0xff
    cp e
    jp z,drop_floats_animate_reset_count
drop_floats_animate_inc_count:  ; if not sentinel, increment
    inc de
    ld a,0xfa
    jp drop_floats_animate_process
drop_floats_animate_reset_count:    ; if sentinel, set to 1
    ld de,1
    ld a,0xfb
drop_floats_animate_process:
    push de                     ; push floating cell count
    push bc                     ; push current cell coordinates
    push hl                     ; push current cell 2nd byte addr
    push hl                     ; push current cell 2nd byte addr
    xor a                       ; check if hidden row
    cp b
    jp z,drop_floats_animate_draw   ; if is, don't erase
    push bc
    call erase_puyo_2x2         ; else erase position
    pop bc
drop_floats_animate_draw:
    pop hl                      ; pop current cell 2nd byte addr
    dec hl                      ; get cell color, load attr at bottom cell
    ld a,(hl)
    and 0x07
    or %01000000
    ld l,a
    ld a,16
    add a,b
    ld b,a
    push bc                     ; push bottom cell coordinates
    call load_2x2_attr
    pop bc                      ; pop bottom cell coordinates to draw puyo
    ld hl,puyo_none
    call load_2x2_data
    pop hl                      ; pop current cell 2nd byte addr
    dec hl                      ; load current cell color
    ld a,(hl)
    and 0x07
    ld (hl),0                   ; clear current cell color
    inc hl                      ; get space count of current byte
    ld d,(hl)
    inc hl                      ; store current color into bottom cell
    ld (hl),a
    inc hl
    dec d                       ; dec space count, write to bottom cell
    ld (hl),d
    dec hl
    dec hl
    ld (hl),0                   ; clear space count of this cell
    pop bc                      ; pop current cell coordinates
drop_floats_animate_next_cell:
    ld a,16                     ; go to next cell on the right
    add a,c
    ld c,a
    ld de,TOTAL_ROWS+TOTAL_ROWS
    add hl,de
    jp drop_floats_animate_loop
drop_floats_animate_wall_right:
    xor a                       ; check if finished hidden row
    cp b
    jp z,drop_floats_animate_loopback
    ; delay
    push bc                     ; push current cell coordinates
    ld b,CONST_DELAY
    xor a
drop_floats_animate_delay:
    dec b
    cp b
    jp nz,drop_floats_animate_delay
    pop bc                      ; pop current cell coordinates
    ; end delay
    ld a,b                      ; move bc to beginning of next row
    ld b,16
    sub b
    ld b,a
    ld c,0x18
    ld de,73+73                 ; distance b/t right wall cell & first visible
    sbc hl,de                   ;   cell on the next row
    jp drop_floats_animate_loop
drop_floats_animate_loopback:
    pop de
    ld a,0xff
    cp e
    jp nz,drop_floats_animate   ; loopback if not done
    ret

; ------------------------------------------------------------------
; clear_puyos: erase matched puyos from board
; ------------------------------------------------------------------
; Input: None
; Output: puyos cleared from play area, boardmap updated
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e, h, l
; ------------------------------------------------------------------
clear_puyos:
    ; read whole board
    ld a,2
    ld (clear_puyos_counter),a
clear_puyos_begin:
    ld bc,0xffff
    push bc
    ld hl,player_board+83+83+1
    ld d,83
    ld e,TOTAL_ROWS
clear_puyos_read:
    ld a,11                     ; check if finished top left cell
    cp d
    jp z,clear_puyos_read_delay
    dec d
    dec hl
    dec hl
    dec e                       ; check if finished column
    jp z,clear_puyos_read_wall
    bit 7,(hl)                  ; check if cell is marked to be cleared
    jp z,clear_puyos_read       ; if not marked, skip cell
    ld b,0                      ; begin check hidden
    ld c,d
    push bc                     ; save bc & hl on stack
    push hl
    call get_board_to_coord
    pop hl                      ; restore hl
    xor a
    cp b                        ; check if cell is in hidden row!!
    jp nz,clear_puyos_not_hidden
    pop bc
    ld (hl),a                   ; if hidden, just erase on board and skip
    dec hl
    ld (hl),a
    inc hl
    jp clear_puyos_read
clear_puyos_not_hidden:
    pop bc                      ; restore bc
    ld a,(clear_puyos_counter)  ; if second pass, skip color
    cp 0
    jp z,clear_puyos_no_color
    dec hl
    ld a,(hl)                   ; get color
    and 0x07
    or %01000000
    ld b,a
    inc hl
clear_puyos_no_color:
    push bc                     ; push: cell color (b), index (c)
    push hl                     ; push hl to save on stack
    push de                     ; push de to save on stack
    ld b,0
    call get_board_to_coord
    ld l,COLOR_WHITE_FLASH
    call load_2x2_attr          ; set marked cell color to white
    pop de
    pop hl
    jp clear_puyos_read         ; loop back to continue reading whole board
clear_puyos_read_wall:
    ld e,TOTAL_ROWS             ; reset wall counter
    jp clear_puyos_read
clear_puyos_read_delay:
    ld c,BLINK_DELAY
    call blink_delay            ; blink delay first to see animation

clear_puyos_write:
    ; begin popping all indices
    pop bc
    ld a,0xff
    cp b
    jp z,clear_puyos_write_done ; if reached stack sentinel, we're done popping
    ld d,b
    ld b,0
    push bc
    call get_board_to_coord     ; get coordinates in bc
    ld a,(clear_puyos_counter)
    cp 0
    jp z,clear_puyos_erase      ; if 2nd pop stage, erase from board
    ld l,d
    call load_2x2_attr          ; flip puyo back to original color
    pop bc
    jp clear_puyos_write
clear_puyos_erase:
    call erase_puyo_2x2         ; erase puyo on screen
    pop bc
    ld hl,player_board          ; erase puyo in memory
    add hl,bc
    add hl,bc
    xor a
    ld (hl),a
    inc hl
    ld (hl),a
    jp clear_puyos_write
clear_puyos_write_done:
    ld a,(clear_puyos_counter)
    cp 0
    jp z,clear_puyos_end        ; if second time here, finish
    dec a
    ld (clear_puyos_counter),a
    ld c,BLINK_DELAY
    call blink_delay
    jp clear_puyos_begin        ; loop back to read board again
clear_puyos_end:
    ret

; ------------------------------------------------------------------
; display_gameover: draw gameover popup
; ------------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e, h, l
; ------------------------------------------------------------------
display_gameover:
    ; print text
    ld bc,msg_blank_line
    ld hl,msg_blank_line_end
    ld de,POPUP_MSG_TOP
    push de
    call print_text
    pop de
    inc d
    push de
    ld bc,msg_game
    ld hl,msg_game_end
    call print_text
    pop de
    inc d
    push de
    ld bc,msg_over
    ld hl,msg_over_end
    call print_text
    pop de
    inc d
    push de
    ld bc,msg_blank_line
    ld hl,msg_blank_line_end
    call print_text

    ; set background color for popup
    ld bc,POPUP_TOPLEFT
    ld hl,POPUP_ROWS
    exx
    ld d,TOTAL_COLUMNS+TOTAL_COLUMNS-4
    ld e,GAMEOVER_ATTR
    exx
    call set_attr_block
    ret

; ------------------------------------------------------------------
; display_pause: draw paused popup
; ------------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e, h, l
; ------------------------------------------------------------------
display_pause:
    ; print text
    ld bc,msg_blank_line
    ld hl,msg_blank_line_end
    ld de,POPUP_MSG_TOP
    push de
    call print_text
    pop de
    inc d
    push de
    ld bc,msg_paused
    ld hl,msg_paused_end
    call print_text
    pop de
    inc d
    push de
    ld bc,msg_paused_underline
    ld hl,msg_paused_underline_end
    call print_text
    pop de
    inc d
    push de
    ld bc,msg_blank_line
    ld hl,msg_blank_line_end
    call print_text

    ; set background color for popup
    ld bc,POPUP_TOPLEFT
    ld hl,POPUP_ROWS
    exx
    ld d,TOTAL_COLUMNS+TOTAL_COLUMNS-4
    ld e,PAUSED_ATTR
    exx
    call set_attr_block
    ret

