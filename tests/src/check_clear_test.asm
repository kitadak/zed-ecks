check_clear_test:
    ld a, 2
    out (254), a
    call check_clears
test_end:
    ld a, 4
    out (254), a
    jp test_end

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


BIT_VISIT       equ 3
NUM_TO_CLEAR    equ 4
DELETE_COLOR    equ 5
EMPTY_COLOR     equ 0
WALL_COLOR      equ 7
COLOR_BITS      equ 7
VISIBLE_END     equ 84

BIT_UP      equ 7
BIT_RIGHT   equ 6
BIT_DOWN    equ 5
BIT_LEFT    equ 4


; row of 5 red puyos connected at the bottom
player_board:
    ;defs 192,0
    defs 24,0xff
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0x66,0x00,0xa6,0x00,0x86,0x00,0x00,0x00,0x42,0x00
    defb 0xff,0xff
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0x16,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x52,0x00
    defb 0xff,0xff
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x52,0x00
    defb 0xff,0xff
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x52,0x00
    defb 0xff,0xff
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x12,0x00
    defb 0xff,0xff
    ; has empty cell
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0xff,0xff
    defs 24,0xff
;;    defs 24,0xff
;;    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
;;    defb 0x06,0x00,0x06,0x00,0x06,0x00,0x00,0x00,0x00,0x00
;;    defb 0xff,0xff
;;    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
;;    defb 0x06,0x00,0x00,0x00,0x04,0x00,0x00,0x00,0x00,0x00
;;    defb 0xff,0xff
;;    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
;;    defb 0x00,0x00,0x03,0x00,0x04,0x00,0x03,0x00,0x42,0x00
;;    defb 0xff,0xff
;;    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
;;    defb 0x00,0x00,0x00,0x00,0x04,0x00,0x03,0x00,0x52,0x00
;;    defb 0xff,0xff
;;    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
;;    defb 0x00,0x00,0x03,0x00,0x03,0x03,0x03,0x00,0x12,0x00
;;    defb 0xff,0xff
;;    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
;;    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
;;    defb 0xff,0xff
;;    defs 24,0xff

; Clearing Variables
curr_idx: defb 0
curr_addr: defs 2, 0
board_idx: defb 0
prev_matches: defs 4,0

old_stack: defs 2, 0
clear_stack_space: defs 256, 0
clear_stack: defs 2, 0
end_of_memory: defs 1024, 0xDF






