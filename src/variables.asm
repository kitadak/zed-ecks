; Variable locations
;player_board: defs 66,0
player_board:
next_puyo: defs 2,0
player_score: defs 4,0
high_score: defs 4,0
puyos_cleared: defb 0
curr_puyo: defs 1,0x77

; labels
BOARD_SIZE: equ 60
KILL_LOCATION: equ 23
; Chain power table
;chain_table:
;defw 4, 20, 24, 32, 48, 96, 160, 240, 320, 480, 700, 800, 900, 999
