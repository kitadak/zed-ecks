begin_test:

; orientation: down, curr_puyo at index 20, second puyo is blocked
check_active_below_test_1:
    ld a, 1                         ; test_1 = blue
    call 8859
    call check_active_below
    cp 0
    jp z, test_fail
; orientation: left, curr_puyo at 45, second puyo is blocked
check_active_below_test_2:
    ld a, 45
    ld (curr_pair), a
    ld a, 3
    ld (curr_pair+1), a
    ld a, 3                         ; test_2 = magenta
    call 8859
    call check_active_below
    cp 0
    jp z, test_fail
; orientation: right, curr_pair at 45, neither are blocked
check_active_below_test_3:
    ld a, 45
    ld (curr_pair), a
    ld a, 1
    ld (curr_pair+1), a
    ld a, 5                         ; test_5 = cyan
    call 8859
    call check_active_below
    cp 0
    jp nz, test_fail                ; expect nothing
; orientation: top, curr_pair at 70, pivot is blocked
check_active_below_test_4:
    ld a, 45
    ld (curr_pair), a
    xor a
    ld (curr_pair+1), a
    ld a, 6                         ; test_5 = yellow
    call 8859
    call check_active_below
    cp 0
    jp nz, test_fail

test_end:                           ; green = success
    ld a, 4                         ; successful border is green
    call 8859
    jp test_end

test_fail:
    jp test_fail

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

get_puyo:
    ld hl, player_board
    ld b, 0
    sla c                           ; translate index to byte location
    add hl, bc                      ; point to spot
    ld a, (hl)                      ; load puyo
    ret

curr_pair: defb 21,%0000010         ; puyo is on top, look at 21i
player_board:
    defs 24,0xff
    defb 0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff
    defb 0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0xfa,0xff
    defb 0xff,0xff
    defb 0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff
    defb 0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0xfb,0xff
    defb 0xff,0xff
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
    defb 0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff,0x00,0xff
    defb 0xff,0xff
    defs 24,0xff

