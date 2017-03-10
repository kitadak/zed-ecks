; ------------------------------------------------------------
; <routine>: <description>
; ------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------

; -------------------------------------------------------------
; check_next_row: checks if next row of either active puyo
; is occupied by another nonactive puyo
; -------------------------------------------------------------
; Input: None
; Output: a - 0 if nothing, else something exists
; ------------------------------------------------------------
check_next_row:
    ret

; ------------------------------------------------------------
; reset_board: Resets the board to empty
; ------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------
; Registers used: abcdefhl
; ------------------------------------------------------------

reset_board:
    ld bc, BOARD_SIZE
    ld a, 0
    ld hl, player_board
reset_board_loop:
    ld (hl), a                  ; fills board with 0s, inc walls
    inc hl
    dec bc
    jp nz, reset_board_loop
; reset left wall
    ld hl, player_board
    ld a, 7
    ld bc, 12                   ; Length of vertical walls
reset_board_left:
    ld (hl), a
    inc hl
    inc hl
    dec bc
    jp nz, reset_board_left
; reset right wall
    ld hl, player_board
    ld bc, 168                  ; byte pos of right wall
    add hl, bc
    ld bc, 12
reset_board_right:
    ld (hl), a
    inc hl
    inc hl
    dec bc
    jp nz, reset_board_right
; reset the bottom wall
    ld hl, player_board
    ld bc, 46                   ; move to the last row, second block from the left
    add hl, bc
    ld de, 24                   ; jump by 24 to move horizontally
    ld (hl), a                  ; fill 6 blocks
    add hl, bc
    ld (hl), a
    add hl, bc
    ld (hl), a
    add hl, bc
    ld (hl), a
    add hl, bc
    ld (hl), a
    add hl, bc
    ld (hl), a
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
; Input: a - index of column (0, 10, 20, 30, 40, 50)
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
; Output: next_puyos: two randomly colored puyos
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
    ld bc, (hl)                 ; Grab the values of the two puyos
    ld a, b
    ld (next_puyo), a
    ld a, c
    ld (next_puyo+1), a
    ret

; ------------------------------------------------------------
; play_check_input: processes input in play loop, moves puyos
; ------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------
play_check_input:
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
settle_puyos:
    ld hl, player_board
    ld bc, BOARD_SIZE-1             ; start at last puyo
    add hl, bc
    ld d, 0                         ; checks if nothing can be done

    ld b, 6                         ; check 6 columns
settle_puyos_column_loop:
    ld c, 10                        ; check 10 rows (all but last)

settle_puyos_row_loop:
    ld a, (hl)                      ; grab a puyo
    dec hl                          ; point to next
    cp 0x01                         ; check if empty
    jp z, settle_puyos_loop_end     ; if not empty, go to next

    ld a, (hl)                      ; grab puyo above
    cp 0x01
    jp nz, settle_puyos_loop_end    ; if empty, go to next puyo

    ld (hl), 0                      ; clear above
    inc hl                          ; point to below
    ld (hl), a                      ; update with puyo
    dec hl                          ; return to original position

    ld d, 1                         ; a drop has been made

settle_puyos_loop_end:
    dec c                           ; repeat this 10 times
    jp nz, settle_puyos_row_loop
    dec hl                          ; skip the top row
    dec b
    jp nz, settle_puyos_column_loop

    ld a, d                         ; has the board been updated?
    ret


; ------------------------------------------------------------
; spawn_puyos: puts puyos onto the field
; ------------------------------------------------------------
; Input: next_puyos: two randomly colored puyos
; Output: player_board: updated with new puyos
;         active_puyos: the puyos that are being controlled
; ------------------------------------------------------------
spawn_puyos:
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

