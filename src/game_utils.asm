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
; spawn_puyos: spawns two randomly colored puyos
; ------------------------------------------------------------
; Input: None
; Output: next_puyos: two randomly colored puyos
; ------------------------------------------------------------
spawn_puyos:
    call rand8
    and 0x0C                    ; 0b00001100 - isolates color bits
    ld bc, (next_puyo)
    ld (bc), a
    call rand8
    and 0x0C
    ld bc, (next_puyo)
    inc bc
    ld (bc), a

    ret

next_puyos:
    defb 0, 0

; ------------------------------------------------------------
; detect_gameover: checks for a gameover
; ------------------------------------------------------------
; Input: None
; Output: a - 0x01 if gameover, otherwise 0x00
; ------------------------------------------------------------
detect_gameover:
    ld a, (player_board)
    ld b, 23                    ; represents 3rd column, top visible row
    add b
    and 0x03                    ; Isolate status bits
    cp 0x01                     ; Check if puyo exists
    jp z, gameover
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
; settle_puyos: Drops any floating puyos to the ground
; ------------------------------------------------------------
; Input: None
; Output:  a - 1 if this can still be updated, 0 if no more updates
;          player_board: Updated board
; ------------------------------------------------------------
; Note: Board representation is top->down left->right
; e.g.: 0 11 22 33 44 55
;       1 12 23 34 45 56
;       2 13 24 35 46 57
; This routine first looks for an empty space and moves
; anything above it downwards.
; ------------------------------------------------------------
settle_puyos:
    ld hl, (player_board)
    ld bc, 65                       ; start at last puyo
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
; clear_board: Empties the board
; ------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------

clear_board:
    ld bc, 66
    ld a, 0
    ld hl, (player_board)
clear_board_loop:
    ld (hl), a
    inc hl
    dec bc
    jp nz, clear_board_loop
    ret

; ------------------------------------------------------------
; update_score: Updates the score
; ------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------

update_score:

