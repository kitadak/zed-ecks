;--------------------------------------------------------------------
; NOT WORKING DO NOT USE
; clear_puyos: Erases 4+ matched puyos,
;              Returns: B - the number of puyos destroyed
;                       C - the colors erased
;
; Algorithm:
;  1. Are we at the end of the board? Return
;  2. Check if puyo is in current spot.
;  3. If there is no puyo, increment and go to 1.
;  4. If the puyo is already visited, increment and go to 1.
;  5. Mark current puyo as visited, record current color, add to stack
;  6. Check puyo directly up/right/down/left.
;  7. If there is no puyo, check the next direction.
;  8. If there is a puyo, add current location to stack, repeat step 6
;     with new puyo.
;  9. Check puyo count, if >= 4, mark all puyos in stack to be cleared
;     and replace clear puyo value with erase.
; 10.
; Neighbor bits are 7-4
; 7 - up
; 6 - right
; 5 - down
; 4 - left
; Color bits are at bits 2-1
; Processed bit is bit 0
;--------------------------------------------------------------------
clear_puyos:
    ; initialize routine
    ld hl, (player_board)           ; copy player_board to tmp_board
    ld de, tmp_board
    ld bc, 60
    ldir

    ; start clearing algorithm
    ld hl, tmp_board                ; get the current location of the board
    ld bc, current_index            ; find the current spot
    add hl, bc                      ; point to the current puyo
    ld a, (hl)                      ; grab the puyo at the current spot
    ld (starting_puyo), hl          ; store the current location
    ld c, 6                         ; isolate the color bits 0b00000110
    and c
    ld e, c                         ; store current color in e
    ld (current_color), a           ; store the current color


    ld b, (hl)                      ; get the starting_puyo
    ld d, 1                         ; set puyo counter to 1

    ; check neighbors
clear_puyos_check_u:
    bit 7, b                        ; check if connected to up
    jp nz, clear_puyos_check_r
    inc hl                          ; puyo above is at (hl + 6)
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    ld a, (hl)
    bit 0, a                        ; check if its been processed
    jp nz, clear_puyos_check_r
    and c                           ; isolate color bits
    cp e
    jp z, clear_puyos_check_r       ; if A != E, jump
    push hl                         ; save location, check next neighbor
    inc d                           ; increment counter
    ld a, 4                         ; if counter >= 4, start delete routine
    cp d
    jp nc, delete_puyos
clear_puyos_check_r:
    ld hl, (starting_puyo)
    bit 6, b                        ; check if connected to up
    jp nz, clear_puyos_check_d
    inc hl                          ; puyo right is at (hl + 1)
    ld a, (hl)
    bit 0, a                        ; check if its been processed
    jp nz, clear_puyos_check_d
    and c                           ; isolate color bits
    cp e
    jp z, clear_puyos_check_d       ; if A != E, jump
    push hl                         ; save location, check next neighbor
    inc d                           ; increment counter
    ld a, 4                         ; if counter >= 4, start delete routine
    cp d
    jp nc, delete_puyos
clear_puyos_check_d:
    ld hl, (starting_puyo)
    bit 5, b                        ; check if connected to up
    jp nz, clear_puyos_check_l
    dec hl                          ; puyo below is at (hl - 6)
    dec hl
    dec hl
    dec hl
    dec hl
    dec hl
    ld a, (hl)
    bit 0, a                        ; check if its been processed
    jp nz, clear_puyos_check_l
    and c                           ; isolate color bits
    cp e
    jp z, clear_puyos_check_l       ; if A != E, jump
    push hl                         ; save location, check next neighbor
    inc d                           ; increment counter
    ld a, 4                         ; if counter >= 4, start delete routine
    cp d
    jp nc, delete_puyos
clear_puyos_check_l:
    ld hl, (starting_puyo)
    bit 6, b                        ; check if connected to up
    jp nz, clear_puyos_check_end
    dec hl                          ; puyo left is at (hl - 1)
    ld a, (hl)
    bit 0, a                        ; check if its been processed
    jp nz, clear_puyos_check_end
    and c                           ; isolate color bits
    cp e
    jp z, clear_puyos_check_end     ; if A != E, jump
    push hl                         ; save location, check next neighbor
    inc d                           ; increment counter
    ld a, 4                         ; if counter >= 4, start delete routine
    cp d
    jp nc, delete_puyos
clear_puyos_check_end:
                                    ; jump to the next puyo on the stack


; 4+ match detected, start deleting puyos
delete_puyos:


current_index:
    defb 0
starting_puyo:
    defb 0
current_color:
    defb 0

; Stack to represent connected puyos
; stack is 120 bytes, as push operations are all 2 bytes long
puyo_stack:
    defs 0, 120

; Board used to determine clears
tmp_board:
    defs 0, 60

; Actual board used by game to represent game state
; represented 1 row at a time, starting from the bottom
;player_board:
;    defs 0, 60

