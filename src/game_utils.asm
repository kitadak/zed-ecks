; ------------------------------------------------------------
; <routine>: <description>
; ------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------

; ------------------------------------------------------------
; connect_puyos: Sets the connect bits on all puyos
; ------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------
connect_puyos:
    ld e, 11                        ; start at index-1
connect_puyos_loop:
    inc e                           ; update index
    ld c, e
    call get_puyo                   ; grab current color
    and 0x7                         ; isolate color
    cp 0                            ; if empty, skip this puyo
    jp z, connect_puyos_loop_end
    cp 0x7                          ; if wall, skip this puyo
    jp z, connect_puyos_loop_end
    ld d, a                         ; store current color in d
    push af                         ; store results on to stack

    ; check up
    ld c, e                         ; reload index
    dec c
    call get_puyo
    and 0x7
    cp d                            ; does this match?
    jp nz, connect_puyos_r
    pop af
    or 0x80                         ; set bit 7
    push af                         ; store it

connect_puyos_r:
    ld a, e
    add a, 12                       ; get right index
    ld c, a
    call get_puyo
    and 0x7
    cp d
    jp nz, connect_puyos_d
    pop af                          ; set bit 6
    or 0x40                         ; combine previous results
    push af
connect_puyos_d:
    ld c, e
    inc c
    call get_puyo
    and 0x7
    cp d
    jp nz, connect_puyos_l
    pop af
    or 0x20
    push af
connect_puyos_l:
    ld a, e
    sub 12
    ld c, a
    call get_puyo
    and 0x7
    cp d
    jp nz, connect_puyos_store
    pop af
    or 0x10
    push af

connect_puyos_store:
    ld hl, player_board
    ld b, 0
    ld c, e
    sla c
    add hl, bc
    pop af                          ; get our result
    ld (hl), a

connect_puyos_loop_end:
    ld a, e                         ; are we at the end?
    cp 83                           ; 82 is last index
    jp c, connect_puyos_loop        ; jump if c < 83
    ret

; -------------------------------------------------------------
; check_active_below: checks if next row of either active puyo
; is occupied by another nonactive puyo or the floor
; This assumes that the active puyos are not on the board
; until they are settled
; -------------------------------------------------------------
; Input: None
; Output: a = 0 -> nothing,
;           = nonzero -> something exists
; ------------------------------------------------------------
; NOTE: If the pivot puyo is at the walls (which shouldn't happen),
; expect undefined behavior
; ------------------------------------------------------------
check_active_below:
    ld hl, curr_pair
    ld c, (hl)                      ; get position of pivot [0-94]
    inc c                           ; get the spot below
    call get_puyo
    cp 0                            ; is there a puyo here?
    jp nz, check_active_below_end       ; yes-> jump to end

    ; check second puyo
    ld hl, curr_pair                ; get the original position again
    inc hl                          ; now get the orientation
    ld a, (hl)
    cp 0x00                         ; check if second puyo is on top
    jp z, check_active_below_end    ; if so, we're done checking
    cp 0x02                         ; check if on bottom
    jp nz, check_active_below_r
    ; second puyo on bottom
    dec hl
    ld c, (hl)                      ; load the pivot position
    inc c                           ; point to second puyo
    inc c                           ; point to spot below second puyo
    call get_puyo
    ret                             ; return result (either 0 or puyo)
check_active_below_r:
    cp 0x01                         ; check if on right
    jp nz, check_active_below_l
    ; second puyo on the right
    ld hl, curr_pair
    ld a, (hl)
    add a, 13                       ; right is +12, below that is +13
    ld c, a
    call get_puyo
    ret
check_active_below_l:
    ; second puyo on the left
    ld hl, curr_pair
    ld a, (hl)
    sub 11                          ; left is -12, below that is -11
    ld c, a
    call get_puyo
check_active_below_end:
    ret
; -------------------------------------------------------------
; check_active_left: checks if something exists to the left
; of either puyo
; -------------------------------------------------------------
; Input: None
; Output: a = 0 -> nothing,
;           = nonzero -> something exists
; ------------------------------------------------------------

check_active_left:
    ld hl, curr_pair
    ld a, (hl)
    sub 12
    ld c, a
    call get_puyo
    cp 0
    ret nz                          ; there exists a puyo to the left
; check second puyo
    ld hl, curr_pair
    inc hl
    ld a, (hl)
    cp 0x02                         ; check down orientation
    jp nz, check_active_left_l
; second puyo is on bottom
    ld hl, curr_pair
    ld a, (hl)
    sub 11                          ; check left down
    ld c, a
    call get_puyo
    ret
check_active_left_l:
    cp 0x03
    jp nz, check_active_left_end
; second puyo is on left
    ld hl, curr_pair
    ld a, (hl)
    sub 24                          ; check left left
    ld c, a
    call get_puyo
    ret
check_active_left_end:
    xor a                           ; no need to check up or right
    ret

; -------------------------------------------------------------
; check_active_right: checks if something exists to the right
; of either puyo
; -------------------------------------------------------------
; Input: None
; Output: a = 0 -> nothing,
;           = nonzero -> something exists
; ------------------------------------------------------------

check_active_right:
    ld hl, curr_pair
    ld a, (hl)
    add a, 12
    ld c, a
    call get_puyo
    cp 0
    ret nz                          ; there exists a puyo to the right
    ; check second puyo
    ld hl, curr_pair
    inc hl
    ld a, (hl)
    cp 0x02                         ; only need to check down orientation
    jp nz, check_active_right_r
; second puyo is on bottom
    dec hl                          ; ld hl, curr_pair
    ld a, (hl)
    add a, 13                       ; check right down
    ld c, a
    call get_puyo
    ret
check_active_right_r:
    cp 0x01
    jp nz, check_active_right_end
; second puyo is on right
    dec hl
    ld hl, curr_pair
    ld a, (hl)
    add a, 24                       ; check right right
    ld c, a
    call get_puyo
    ret
check_active_right_end:
    xor a
    ret

; ------------------------------------------------------------
; get_puyo: given index, returns the puyo at that spot
; ------------------------------------------------------------
; Input: c - index of puyo [0-95]
; Output: a - returns the puyo at that location
; ------------------------------------------------------------

get_puyo:
    ld hl, player_board             ; 10
    ld b, 0                         ; 7
    sla c                           ; 8 translate index to byte location
    add hl, bc                      ; 11 point to spot
    ld a, (hl)                      ; 7 load puyo
    ret                             ; 10

; ------------------------------------------------------------
; reset_board: Resets the board to empty
; ------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------
; Registers used: bcdehl
; ------------------------------------------------------------

reset_board:
    ld b, 0
    ld c, BOARD_SIZE
    sla c
    ld de, player_board
    ld hl, EMPTY_BOARD
    ldir
    ret

; ------------------------------------------------------------
; drop_active_puyos: drops the columns of the active puyos
; ------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------
drop_active_puyos:
    ret

; ------------------------------------------------------------
; drop_column: drops any floating puyos in the given column
; ------------------------------------------------------------
; Input: a - index of column (0, 12, 24, 36, 58, 60, 72)
; Output: player_board updated to drop all puyos in a column
; ------------------------------------------------------------
drop_column:
    ret

; ------------------------------------------------------------
; gameover: the gameover sequence
; ------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------
gameover:
    ret

; ------------------------------------------------------------
; gameover_detect : checks for a gameover
; ------------------------------------------------------------
; Input: None
; Output: a - nonzero if gameover, otherwise returns 0
; ------------------------------------------------------------
; Note: this does not directly jump to the gameover sequence
; Main loop will call jump to avoid overflowing call stack
; ------------------------------------------------------------
gameover_detect:
    ld hl, player_board
    ld bc, KILL_LOCATION        ; represents 3rd column, top visible row
    add hl, bc
    ld a, (hl)
    and 0x07                    ; Isolate color bits
    ret                         ; If empty, reg a should now be 0x00
                                ; This will fail if KILL_LOCATION
                                ; points to a wall

; ------------------------------------------------------------
; gen_puyos: generate two randomly colored puyos
; ------------------------------------------------------------
; Input: None
; Output: next_pair: two randomly colored puyos
; ------------------------------------------------------------
; Registers Used: abchl
; ------------------------------------------------------------
gen_puyos:
    call rand8                  ; a <- random value
    and 0x0F                    ; Get a range from [0,15]
    ld hl, PUYO_PAIRS           ; Go to our list of pairs
    ld b, 0
    ld c, a                     ; load the offset
    add hl, bc
    ld a, (hl)                  ; Grab the next colors
    ld (next_pair), a           ; Store the colors
    ret

; ------------------------------------------------------------
; get_input: returns a byte indicating which buttons are pressed
; ------------------------------------------------------------
; Input: None
; Output: c - byte representation of pressed buttons
; ------------------------------------------------------------
; Note: Input will be returned in the following format:
; 76543210
; PW HJASD
; 0 -> Not pressed
; 1 -> Pressed
; bit 5 will is unused and will not be taken into account
; ------------------------------------------------------------
; Registers Used: a,c
; ------------------------------------------------------------
; With help from:
; Advanced Spectrum Machine Language
; http://www.animatez.co.uk/computers/zx-spectrum/keyboard/
; ------------------------------------------------------------
get_input:
    ld a, 0xFB                  ; load qwert row
    in a, (0xFE)
    cpl                         ; invert input
    and 0x02                    ; isolate W (bit 1)
    rrca                        ; move W to bit 6
    rrca
    rrca
    ld c, a                     ; store in C

    ld a, 0xFB                  ; load asdfg row
    in a, (0xFE)
    cpl
    and 0x07                    ; isolate ASD (bits 012)
                                ; ASD is already in place!
    or c                        ; combine previous results
    ld c, a
    ld a, 0xBF                  ; load hjklenter row
    in a, (0xFE)
    cpl
    and 0x24                    ; isolate JH (bits 34)
                                ; JH is already in place
    or c
    ld c, a

    ld a, 0xDF                  ; load yuiop row
    in a, (0xFE)
    cpl
    and 0x01                    ; isolate P (bit 0)
    rrca                        ; move P to bit 7
    or c
    ld c, a                     ; store result in c
    ret

; ------------------------------------------------------------
; play_check_input: processes input in play loop, moves puyos
; ------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------
; Variables required:
; LR_timer
; UD_timer
; rotate_timer
; prev_input
; ------------------------------------------------------------
play_check_input:
    call get_input              ; get input data in c
    ; check a



input_move_left:

    ; move puyo left





    ; check d
input_move_right:
    ; check s

input_move_down:

    ; check j
input_rotate_cw:

    ; check h
input_rotate_ccw:

    ; check p
input_pause:

    ret

; ------------------------------------------------------------
; process_clears: clears 4+ connected puyos
; ------------------------------------------------------------
; Input: None
; Output: 0 if no clears occured, else clears occured
; ------------------------------------------------------------
process_clears
    ret

; ------------------------------------------------------------
; reset_drop_timer: Resets the timer to the current speed
; ------------------------------------------------------------
; Input: None
; Output: drop_timer - time till next drop
; ------------------------------------------------------------
; Registers Used: bc, hl
; ------------------------------------------------------------

reset_drop_timer:
    ld bc, current_speed
    ld hl, drop_table
    add hl, bc
    ld (drop_timer), hl
    ret


; ------------------------------------------------------------
; settle_puyos: Drops any floating puyos to the ground
; ------------------------------------------------------------
; Input: None
; Output:  a - 1 if this can still be updated, 0 if no more updates
;          player_board: Updated board
; ------------------------------------------------------------
; Note: Board representation is top->down left->right
; This routine first looks for an empty space and moves
; anything above it downwards.
; ------------------------------------------------------------
;;settle_puyos:
;;    ld hl, player_board
;;    ld bc, BOARD_SIZE-1             ; start at last puyo
;;    add hl, bc
;;    ld d, 0                         ; checks if nothing can be done
;;
;;    ld b, 6                         ; check 6 columns
;;settle_puyos_column_loop:
;;    ld c, 10                        ; check 10 rows (all but last)
;;
;;settle_puyos_row_loop:
;;    ld a, (hl)                      ; grab a puyo
;;    dec hl                          ; point to next
;;    cp 0x01                         ; check if empty
;;    jp z, settle_puyos_loop_end     ; if not empty, go to next
;;
;;    ld a, (hl)                      ; grab puyo above
;;    cp 0x01
;;    jp nz, settle_puyos_loop_end    ; if empty, go to next puyo
;;
;;    ld (hl), 0                      ; clear above
;;    inc hl                          ; point to below
;;    ld (hl), a                      ; update with puyo
;;    dec hl                          ; return to original position
;;
;;    ld d, 1                         ; a drop has been made
;;
;;settle_puyos_loop_end:
;;    dec c                           ; repeat this 10 times
;;    jp nz, settle_puyos_row_loop
;;    dec hl                          ; skip the top row
;;    dec b
;;    jp nz, settle_puyos_column_loop
;;
;;    ld a, d                         ; has the board been updated?
;;    ret


; ------------------------------------------------------------
; spawn_puyos: puts puyos onto the field
; ------------------------------------------------------------
; Input: next_pair: two randomly colored puyos
; Output: player_board: updated with new puyos
;         curr_pair: the current pair position
;         prev_pair: the previous pair position
; ------------------------------------------------------------
spawn_puyos:
    ld a, 37                    ; spawns begin at 37i,36i
    ld (curr_pair), a           ; reset initial positions
    ld (prev_pair), a
    ld a, 0
    ld (curr_pair+1), a
    ld hl, next_pair
    ld a, (next_pair)
    ld (pair_color), a
    call gen_puyos              ; generate new puyos after
    ret

; ------------------------------------------------------------
; rand8: gets a random value based on the R register
; ------------------------------------------------------------
; Input: None
; Output: a - a random 8-bit number
; ------------------------------------------------------------
; Based on: www.z80.info/pseudo-random.txt
; Note: might want to try replacing
; add a,b -> add a,r
; and removing ld b,a
; ------------------------------------------------------------
rand8:
    ld a, r
    ld b, a
    rrca
    rrca
    rrca
    xor 0x1f
    add a, b
    sbc a, 255
    ret




; ------------------------------------------------------------------
; rotate_cw: Rotate current puyo pair clockwise
; ------------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------------
;
; ------------------------------------------------------------------
rotate_cw:
    ld a, (curr_pair)               ; store curr location into previous
    ld (prev_pair), a
    ld a, (curr_pair+1)             ; get orientation
    cp 0x03                         ; if left, no checks needed
    jp z, rotate_cw_end
    cp 0x00
rotate_cw_u:
	jp nz,rotate_cw_r

	; check if puyo exists to the right
    ld a, (curr_pair)
    ld c, 12
    add a, c
    ld c, a
    call get_puyo
    cp 0
    jp z, rotate_cw_end      ; if nothing, rotation is fine
    ; something exists, need to shift curr_pair left
    ld hl, curr_pair
    ld a, (hl)
    ld c, 12
    sub c
    ld (hl), a

	jp rotate_cw_end

rotate_cw_r:
	cp 0x03
	jp nz,rotate_cw_d

    ; check if puyo exists below
    ld a, (curr_pair)
    inc a                           ; get index of below
    ld c, a
    call get_puyo
    cp 0
    jp z, rotate_cw_end      ; if nothing, rotation is fine
    ; something exists, need to shift puyo upward
    ; NOTE: This means players can keep rotating upward
    ; May cause strange issues unless we reset the drop timer
    ld hl, curr_pair
    dec (hl)
    jp rotate_cw_end
rotate_cw_d:
    ld a, (curr_pair)
    ld c, 12                        ; need to check left
    sub c
    ld c, a
    call get_puyo
    cp 0
    jp z, rotate_cw_end
    ld hl, curr_pair                ; something exists, move right
    ld a, (hl)
    ld c, 12
    add a, c
    ld (hl), a
rotate_cw_end:
	; 00->01->10->11->00
	; increment last two bits
    ld hl, curr_pair
    inc hl                          ; hl now points to orientation byte
    ld a, (hl)
    ld (prev_pair+1), a             ; store old orientation
    inc a                           ; update orientation
    and 0x03
    ld (hl), a
	ret

; ------------------------------------------------------------------
; rotate_ccw: Rotate current puyo pair counterclockwise
; ------------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------------
;
; ------------------------------------------------------------------
rotate_ccw:
    ld a, (curr_pair)               ; store curr location into previous
    ld (prev_pair), a
    ld a, (curr_pair+1)             ; get orientation
    cp 0x01                         ; if right, no checks needed
    jp z, rotate_ccw_end
    cp 0x00
rotate_ccw_u:
	jp nz,rotate_ccw_l
    ld a, (curr_pair)
    ld c, 12                        ; need to check left
    sub c
    ld c, a
    call get_puyo
    cp 0
    jp z, rotate_ccw_end
    ld hl, curr_pair                ; something exists, move right
    ld a, (hl)
    ld c, 12
    add a, c
    ld (hl), a

	jp rotate_ccw_end

rotate_ccw_l:
	cp 0x01
	jp nz,rotate_ccw_d

    ; check if puyo exists below
    ld a, (curr_pair)
    inc a                           ; get index of below
    ld c, a
    call get_puyo
    cp 0
    jp z, rotate_ccw_end      ; if nothing, rotation is fine
    ; something exists, need to shift puyo upward
    ; NOTE: This means players can keep rotating upward
    ; May cause strange issues unless we reset the drop timer
    ld hl, curr_pair
    dec (hl)
    jp rotate_ccw_end
rotate_ccw_d:
	; check if puyo exists to the right
    ld a, (curr_pair)
    ld c, 12
    add a, c
    ld c, a
    call get_puyo
    cp 0
    jp z, rotate_ccw_end      ; if nothing, rotation is fine
    ; something exists, need to shift curr_pair left
    ld hl, curr_pair
    ld a, (hl)
    ld c, 12
    sub c
    ld (hl), a

rotate_ccw_end:
	; 11->10->01->00->11
	; decrement last two bits
    ld hl, curr_pair
    inc hl                          ; hl now points to orientation byte
    ld a, (hl)
    ld (prev_pair+1), a             ; store old orientation
    dec a                           ; update orientation
    and 0x03
    ld (hl), a
	ret

; ------------------------------------------------------------
; update_score: Updates the score
; ------------------------------------------------------------
; Input: a - puyos cleared
;        b - chain count
;        c - color bonus
;        d - group bonus
; Output: a - 0 if score was not updated, otherwise 1
;        player_score - updated
;
; ------------------------------------------------------------

update_score:
    ret

