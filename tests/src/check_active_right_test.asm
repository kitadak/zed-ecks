check_active_right_test_1:
    ld a, 1                         ; test_1 = blue
    call 8859

    ld a, 45                        ; puyos to the right, down orientation
    ld (curr_pair),a
    ld a, 2

    call check_active_right
    cp 0
    jp z, test_fail                 ; should find a puyo
; orientation: right, curr_puyo at 45, second puyo is blocked
check_active_right_test_2:
    ld a, 3                         ; test_2 = magenta
    call 8859

    ld a, 80                        ; checking right wall
    ld (curr_pair), a
    ld a, 0
    ld (curr_pair+1), a

    call check_active_right
    cp 0
    jp z, test_fail                 ; should find a puyo
; orientation: right, curr_pair at 45, neither are blocked
check_active_right_test_3:
    ld a, 5                         ; test_3 = cyan
    call 8859

    ld a, 20                        ; puyos two spots to the right
    ld (curr_pair), a
    ld a, 1
    ld (curr_pair+1), a

    call check_active_right
    cp 0
    jp nz, test_fail                ; expect nothing
; orientation: top, curr_pair at 70, pivot is blocked
check_active_right_test_4:
    ld a, 6                         ; test_4 = yellow
    call 8859

    ld a, 43                        ; bottom puyo is blocked
    ld (curr_pair), a
    ld a, 2
    ld (curr_pair+1), a

    call check_active_right
    cp 0
    jp z, test_fail

test_end:                           ; green = success
    ld a, 4                         ; successful border is green
    call 8859
    jp test_end

test_fail:
    jp test_fail

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
    dec hl                          ;ld hl, curr_pair
    ld a, (hl)
    add a, 13
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
    add a, 24
    ld c, a
    call get_puyo
    ret
check_active_right_end:
    xor a
    ret


get_puyo:
    ld hl, player_board             ; 10
    ld b, 0                         ; 7
    sla c                           ; 8 translate index to byte location
    add hl, bc                      ; 11 point to spot
    ld a, (hl)                      ; 7 load puyo
    ret                             ; 10

curr_pair: defb 21,%0000010         ; puyo is on top, look at 21i
player_board:
    defs 24,0xff
    defb 0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff
    defb 0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff
    defb 0xff,0xff
    defb 0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff
    defb 0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff
    defb 0xff,0xff
    defb 0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff
    defb 0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff
    defb 0xff,0xff
    defb 0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff
    defb 0x00,0xff,0x00,0xff,0xfd,0xff,0xfc,0xff,0xf5,0xff
    defb 0xff,0xff
    defb 0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff
    defb 0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0xfb,0xff
    defb 0xff,0xff
    defb 0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff
    defb 0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0xfa,0xff
    defb 0xff,0xff
    defs 24,0xff

