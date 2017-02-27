; ------------------------------------------------------------
; rand8- gets a random value based on the R register
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
; spawn_puyos - spawns two randomly colored puyos
; ------------------------------------------------------------
; Input: None
; Output: next_puyos: two randomly colored puyos
; ------------------------------------------------------------
spawn_puyos:
    call rand8
    and 0x0C                    ; 0b00001100 - isolates color bits
    ld (next_puyos), a
    call rand8
    and 0x0C
    ld (next_puyos+1), a
    ret

next_puyos:
    defb 0, 0

; ------------------------------------------------------------
; detect_gameover - checks for a gameover
; ------------------------------------------------------------
; Input: None
; Output: a - 0x01 if gameover, otherwise 0x00
; ------------------------------------------------------------
detect_gameover:
    ld a, (player_board+57)
    and 0x03                    ; Isolate status bits
    cp 0x01                     ; Check if puyo exists
    jp z, game_over
    ret

; ------------------------------------------------------------
; game_over: - the gameover sequence
; ------------------------------------------------------------
; Input: None
; Output: None
; ------------------------------------------------------------
game_over:
    ret




