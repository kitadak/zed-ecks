; ------------------------------------------------------------
; <routine>: <description>
; ------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------

; ------------------------------------------------------------
; check_clears: Marks puyos to be erased
; ------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------
; Variables:
; curr_idx: index of the current puyo
; board_idx: index that will iterate through the whole board
; old_stack: store stack somewhere else temporarily
; clear_stack: the current stack used for exploring
; cleared_colors: colors that have been cleared
; cleared_count: number of puyos that have been marked erased
; chain_count: the number of times this routine has been called
;              in a row
; ------------------------------------------------------------
check_clears:
check_clears_init:
    ; store stack pointer
    ld (old_stack), sp
    ld sp, clear_stack

    ; int board_idx = 0;
    ; Stack<int> stack;

    ld a, 0xFF                      ; setup stack with sentinel value
    push af

    xor a
    ld (board_idx), a
    ld (curr_idx), a

check_clears_start:
    ; stack.push(curr_idx)
    ld a, (board_idx)
    push af

    ld d, NUM_TO_CLEAR              ; reset matches left

check_clears_main:
    pop af                          ; get a value from the stack

    ; while (!stack.empty())
    cp 0xFF                         ; is our list empty?
    jp z, check_clears_inc          ; go to the next index

    ; curr_idx = stack.pop()
    ld (curr_idx), a                ; set our current index

    ; calculate address
    ld hl, player_board
    ld b, 0
    ld c, a
    sla c
    add hl, bc                      ; hl points to the current puyo
    ld (curr_addr), hl              ; store this address

    ld a, (hl)                      ; get the puyo

    ; is this a valid puyo?
    cp EMPTY_COLOR                  ; check existence
    jp z, check_clears_main
    and COLOR_BITS                  ; isolate color bits
    cp WALL_COLOR                   ; check wall
    jp z, check_clears_main
    cp DELETE_COLOR                 ; check if deleted
    jp z, check_clears_main

    ; mark this puyo as visited
    set BIT_VISIT, (hl)

    ; switch (matches_left) {
    ;   case 4: prev_matches[0] = curr_idx; break;
    ;   case 3: prev_matches[1] = curr_idx; break;
    ;   case 2: prev_matches[2] = curr_idx; break;
    ;   case 1: clear(prev_matches[0..2]); clear(curr_idx); break;
    ;   default: clear (curr_idx) ; // == 0

    ; have we found 4 matching?
    ld a, d                         ; d == matches_left

check_clears_4:
    cp 4
    jp nz, check_clears_3
    dec d
    ld a, (curr_idx)                ; store the current index for later
    ld (prev_matches), a
    jp check_clears_add_neighbors   ; go check neighbors
check_clears_3:
    cp 3
    jp nz, check_clears_2
    dec d
    ld a, (curr_idx)
    ld (prev_matches+1), a
    jp check_clears_add_neighbors

check_clears_2:
    cp 2
    jp nz, check_clears_1
    dec d
    ld a, (curr_idx)
    ld (prev_matches+2), a
    jp check_clears_add_neighbors

check_clears_1:
    cp 1
    jp nz, check_clears_0
    dec d
    ; mark previous 3 and current as cleared
    ld a, (prev_matches)
    call check_clears_mark
    ld a, (prev_matches+1)
    call check_clears_mark
    ld a, (prev_matches+2)
    call check_clears_mark
    ld a, (curr_idx)                  ; NOTE: might not need this
    call check_clears_mark            ; taken care of in check_clears_0
    jp check_clears_add_neighbors

check_clears_0:
    ; mark current puyo as cleared
    ld a, (curr_idx)
    call check_clears_mark


check_clears_add_neighbors:
    ; get a fresh copy
    ld hl, (curr_addr)
    ld a, (hl)

    ; add the neighbors
    ; for (int neighbor : neighborsOf(curr_idx))
    ;   stack.push(neighbor)
check_clears_u:
    ; do we have a neighbor
    bit BIT_UP, a
    jp z, check_clears_r

    ld a, (curr_idx)
    dec a                           ; a contains index of new puyo

    ; have we seen this already
    ld hl, player_board
    ld b, 0
    ld c, a
    sla c

    add hl, bc
    bit BIT_VISIT, (hl)
    jp nz, check_clears_r

    push af                         ; push up puyo onto stack

check_clears_r:
    ld hl, (curr_addr)
    ld a, (hl)
    bit BIT_RIGHT, a
    jp z, check_clears_d

    ld a, (curr_idx)
    add a, 12

    ld hl, player_board
    ld b, 0
    ld c, a
    sla c
    add hl, bc
    bit BIT_VISIT, (hl)
    jp nz, check_clears_d

    push af

    ld hl, (curr_addr)
    ld a, (hl)

check_clears_d:
    ld hl, (curr_addr)
    ld a, (hl)
    bit BIT_DOWN, a
    jp z, check_clears_l

    ld a, (curr_idx)
    inc a

    ld hl, player_board
    ld b, 0
    ld c, a
    sla c
    add hl, bc
    bit BIT_VISIT, (hl)
    jp nz, check_clears_l

    push af

    ld hl, (curr_addr)
    ld a, (hl)

check_clears_l:
    ld hl, (curr_addr)
    ld a, (hl)
    bit BIT_LEFT, a
    jp z, check_clears_main
    ld a, (curr_idx)
    sub 12

    ld hl, player_board
    ld b, 0
    ld c, a
    sla c
    add hl, bc
    bit BIT_VISIT, (hl)
    jp nz, check_clears_main

    push af

    ;ld hl, (curr_addr)
    ;ld a, (hl)

    ; end of explore block
    jp check_clears_main

check_clears_inc:
    ld a, 0xFF                        ; stack is empty, push our sentinel
    push af

    ; board_idx++
    ld hl, board_idx
    inc (hl)
    ld a, (hl)
    cp VISIBLE_END                  ; are we at the end?
    jp z, check_clears_end          ; clean up board
    jp check_clears_start

check_clears_mark:
    ; puyo to be marked as cleared in a
    ld b, 0
    ld c, a
    sla c
    ld hl, player_board
    add hl, bc
    ld a, (hl)
    push hl                         ; store location
    push af                         ; store puyo

    ; save the color for scoring purposes
    and COLOR_BITS                  ; isolate color bits
    ld hl, cleared_colors
check_clears_mark_b:
    cp 1
    jp nz, check_clears_mark_r
    set 0, (hl)
check_clears_mark_r:
    cp 2
    jp nz, check_clears_mark_g
    set 1, (hl)
check_clears_mark_g:
    cp 4
    jp nz, check_clears_mark_y
    set 2, (hl)
check_clears_mark_y:
    cp 6
    jp nz, check_clears_mark_delete
    set 3, (hl)
check_clears_mark_delete:

    pop af                          ; restore puyo
    and 0xf8                        ; mask out the color bits
    or DELETE_COLOR                 ; replace with a special deleted color
    pop hl                          ; restore location
    ld (hl), a

    ; increment score
    ld hl, cleared_count
    inc (hl)

    ret

check_clears_end:
    ; unset visited bits
    ; go through board
    ld c, 95
    ld hl, player_board-2
    ld sp, (old_stack)
check_clear_unset_loop:
    dec c
    ret z
    inc hl
    inc hl
    ld a, (hl)
    and 0x7                          ; is this a wall
    cp 0x7
    jp z, check_clear_unset_loop
    res BIT_VISIT, (hl)
    jp check_clear_unset_loop



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
; Output: a - byte representation of pressed buttons
; ------------------------------------------------------------
; Note: Input will be returned in the following format:
; 76543210
; P  HJASD
; 0 -> Not pressed
; 1 -> Pressed
; bits 5 and 6 are unused
; ------------------------------------------------------------
; Registers Used: a,c
; ------------------------------------------------------------
; With help from:
; Advanced Spectrum Machine Language
; http://www.animatez.co.uk/computers/zx-spectrum/keyboard/
; ------------------------------------------------------------
get_input:
    ld a, 0xFD                  ; load asdfg row
    in a, (0xFE)
    cpl
    and 0x07                    ; isolate ASD (bits 012)
                                ; ASD is already in place!
    ld c, a
    ld a, 0xBF                  ; load hjklenter row
    in a, (0xFE)
    cpl
    and 0x18                    ; isolate JH (bits 34)
                                ; JH is already in place
    or c                        ; combine results
    ld c, a

    ld a, 0xDF                  ; load yuiop row
    in a, (0xFE)
    cpl
    and 0x01                    ; isolate P (bit 0)
    rrca                        ; move P to bit 7
    or c
    ld (curr_input), a          ; store result into curr_input
    ret

; ------------------------------------------------------------
; play_check_input: processes input in play loop, moves puyos
; ------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------
; Variables required:
; LR_timer
; D_timer
; rotate_timer
; prev_input
; ------------------------------------------------------------
; Routine:
; Get Button <---Update prev_input------------------------+
;    |                ^                                   |
;    V                |                                   |
; Is curr pressed?--N-+                                   |
;    |                                                    |
;    Y                                                    |
;    V                                                    |
; Is prev pressed?--N->Execute Action->Set long timer-----+
;    |                                                    |
;    Y                                                    |
;    V                                                    |
; Decrement Timer                                         |
;    |                                                    |
;    V                                                    |
; Is Zero?--N---------------------------------------------+
;    |                                                    |
;    +--Y->Execute Action->Set Short Timer->--------------+
;
; ------------------------------------------------------------
play_check_input:
    call get_input              ; get input data in a and curr_input

    ld a, (curr_input)
    bit BIT_A, a
    call nz, play_check_a

    ld a, (curr_input)
    bit BIT_S, a                ; is it currently pressed?
    call nz, play_check_s

    ld a, (curr_input)
    bit BIT_D, a
    call nz, play_check_d

    ld a, (curr_input)
    bit BIT_H, a
    call nz, play_check_h

    ld a, (curr_input)
    bit BIT_J, a
    call nz, play_check_j

    ld a, (curr_input)
    bit BIT_P, a
    call nz, play_check_p

    ld a, (curr_input)          ; update previous input
    ld (prev_input), a
    ret

    ; check a
play_check_a:
    ld a, (prev_input)
    bit BIT_A, a                ; has this been pressed before
    jp nz, play_check_a_short   ; if so, do nothing

play_check_a_long:
    ld a, INPUT_LONG_DELAY
    ld (LR_timer), a
    call input_move_left
    ret

play_check_a_short:
    ld hl, LR_timer
    dec (hl)
    ret nz
    ld a, INPUT_SHORT_DELAY
    ld (LR_timer), a
    call input_move_left
    ret

    ; check d
play_check_d:
    ld a, (prev_input)
    bit BIT_D, a
    jp nz, play_check_d_short

play_check_d_long:
    ld a, INPUT_LONG_DELAY
    ld (LR_timer), a
    call input_move_right
    ret

play_check_d_short:
    ld hl, LR_timer
    dec (hl)
    ret nz
    ld a, INPUT_SHORT_DELAY
    ld (LR_timer), a
    call input_move_right
    ret

    ; check s
play_check_s:                   ; s repeats immediately
    ld a, (prev_input)
    bit BIT_S, a
    jp nz, play_check_s_short

play_check_s_long:
    ld a, INPUT_SHORT_DELAY
    ld (D_timer), a
    call input_move_down
    ret

play_check_s_short:
    ld hl, D_timer
    dec (hl)
    ret nz
    ld a, INPUT_SHORT_DELAY
    ld (D_timer), a
    call input_move_down
    ret

    ; check h
play_check_h:                   ; rotations can't be repeated
    ld a, (prev_input)
    bit BIT_H, a
    call z, rotate_ccw
    ret

    ; check j
play_check_j:
    ld a, (prev_input)
    bit BIT_J, a
    call z, rotate_cw
    ret

    ; check p
play_check_p:
    ld a, (prev_input)
    bit BIT_P, a
    ret nz
    ld a, (is_paused)           ; flip paused state
    cpl
    ld (is_paused), a
    ret


input_move_left:
    call check_active_left
    cp 0
    ret nz
    ; move puyo left
    ld a, (curr_pair)           ; update previous location
    ld (prev_pair), a
    sub 12                      ; move to the left
    ld (curr_pair), a
    ld a, (curr_pair+1)
    ld (prev_pair+1), a
    ret

    ; check d
input_move_right:
    call check_active_right
    cp 0
    ret nz
    ld a, (curr_pair)
    ld (prev_pair), a
    add a, 12
    ld (curr_pair), a
    ld a, (curr_pair+1)
    ld (prev_pair+1), a
    ret

    ; check s
input_move_down:
    call check_active_below
    cp 0
    ret nz
    ld a, (curr_pair)
    ld (prev_pair), a
    inc a
    ld (curr_pair), a
    ld a, (curr_pair+1)
    ld (prev_pair+1), a
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
    cp 0x3                          ; if left, no checks needed
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
	cp 0x1
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
    cp 0x1                          ; if right, no checks needed
    jp z, rotate_ccw_end
    cp 0
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
	cp 0x3
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

