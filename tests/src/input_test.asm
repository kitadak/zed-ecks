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
    or c
    ld c, a

    ld a, 0xDF                  ; load yuiop row
    in a, (0xFE)
    cpl
    and 0x01                    ; isolate P (bit 0)
    rrca                        ; move P to bit 7
    or c
    ld (current_input), a       ; store result in c

test_p:
    bit 7, a
    jp z, test_w
    ld a, 2
    call 8859
test_w:
    ld hl, current_input
    ld a, (hl)

    bit 6, a
    jp z, test_j
    ld a, 3
    call 8859
test_j:
    ld hl, current_input
    ld a, (hl)

    bit 3, a
    jp z, test_h
    ld a, 4
    call 8859
test_h:
    ld hl, current_input
    ld a, (hl)

    bit 4, a
    jp z, test_a
    ld a, 5
    call 8859
test_a:
    ld hl, current_input
    ld a, (hl)
    bit 0, a
    jp z, test_s
    ld a, 6
    call 8859
test_s:
    ld hl, current_input
    ld a, (hl)
    bit 1, a
    jp z, test_d
    ld a, 7
    call 8859
test_d:
    ld hl, current_input
    ld a, (hl)
    bit 2, a
    jp z, get_input
    ld a, 0
    call 8859
    jp get_input


current_input: defb 0
