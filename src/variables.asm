; Constants
BOARD_SIZE: equ 60

KILL_LOCATION: equ 23

; Variables

player_board: defs 66,0
next_puyo: defs 2,0

player_score: defs 4,0

high_score: defs 4,0

puyos_cleared: defb 0

next_puyos: defb 0, 0

drop_timer: defb 0

current_speed: defb 0

curr_puyo: defs 1,0x77

; Chain power table
; Used for scoring
chain_table:
    defw 4, 20, 24, 32, 48, 96, 160, 240, 320, 480, 700, 800, 900, 999

; Drop time table
; Defines number of frames before the puyo is dropped to the next half row
drop_table:
    defb 25, 23, 20, 16, 13, 10, 7

