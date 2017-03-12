; ==================================================================
; FILE: variables.asm
; ------------------------------------------------------------------
;   Contains macros and variables used across the whole project.
; ==================================================================

; ------------------------------------------------------------------
; Macros/Constants
; ------------------------------------------------------------------

TOPLEFT_VISIBLE equ 0x1818
TOPLEFT_HIDDEN  equ 0x0818
BOARD_SIZE      equ 192
KILL_LOCATION   equ 74  ; Based on byte representation


; Puyo Pairs
; In order:
; BB,BR,BG,BY,RB,RR,RG,RY,GB,GR,GG,GY,YB,YR,YG,YY
; Storage Format:
; 00AAABBB -> A is first color, B is second color
PUYO_PAIRS:
    defb 0x09, 0x0A, 0x0C, 0x0E
    defb 0x11, 0x12, 0x14, 0x16
    defb 0x21, 0x22, 0x24, 0x26
    defb 0x31, 0x32, 0x34, 0x36

; ------------------------------------------------------------------
; Variables/Tables
; ------------------------------------------------------------------

player_board:
    ;defs 66,0
    defs 30,%11111101   ; sample board map for testing purpose
    defs 30,%10110101

next_pair: defs 2,0

player_score: defs 4,0

high_score: defs 4,0

puyos_cleared: defb 0

next_puyos: defb 0, 0

drop_timer: defb 0

current_speed: defb 0

; Active airborne puyo pair
; Must stay in this order for drawing purpose
prev_pair: defb 14,%00000010    ; previous position of current pair
curr_pair: defb 82,%00000011    ; current pair position
pair_color: defb %00000010      ; color of current pair (unused[4]|pivot[2]|other[2])

; Chain power table
; Used for scoring
chain_table:
    defw 4, 20, 24, 32, 48, 96, 160, 240, 320, 480, 700, 800, 900, 999

; Drop time table
; Defines number of frames before the puyo is dropped to the next half row
drop_table:
    defb 32, 23, 20, 16, 13, 10, 7

; Translation table from board position to pixel coordinates
board_to_coord_tab:
    defs 120,0xfb


