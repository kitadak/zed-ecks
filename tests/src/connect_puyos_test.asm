connect_puyos_test_1:
    ld a, 2
    call 8859
    call connect_puyos
asdf:
    jp asdf

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

get_puyo:
    ld hl, player_board             ; 10
    ld b, 0                         ; 7
    sla c                           ; 8 translate index to byte location
    add hl, bc                      ; 11 point to spot
    ld a, (hl)                      ; 7 load puyo
    ret                             ; 10


player_board:
    defs 24,0xff
    defb 0x01,0xff,0x01,0xff,0x01,0xff,0x01,0xff,0x01,0xff,0x01,0xff
    defb 0x01,0xff,0x01,0xff,0x01,0xff,0x01,0xff,0xfa,0xff
    defb 0xff,0xff
    defb 0x02,0xff,0x02,0xff,0x02,0xff,0x02,0xff,0x02,0xff,0x02,0xff
    defb 0x02,0xff,0x02,0xff,0x02,0xff,0x02,0xff,0xfb,0xff
    defb 0xff,0xff
    defb 0x03,0xff,0x03,0xff,0x03,0xff,0x03,0xff,0x03,0xff,0x03,0xff
    defb 0x02,0xff,0x02,0xff,0x02,0xff,0x02,0xff,0x02,0xff
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

