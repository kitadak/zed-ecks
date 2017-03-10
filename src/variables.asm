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
; Note: These pairs are stored in little endian
; which means they will be reversed when stored
PUYO_PAIRS:
    defw 0x0101, 0x0102, 0x0104, 0x0106
    defw 0x0201, 0x0202, 0x0204, 0x0206
    defw 0x0401, 0x0402, 0x0404, 0x0406
    defw 0x0601, 0x0602, 0x0604, 0x0606

; ------------------------------------------------------------------
; Variables/Tables
; ------------------------------------------------------------------

player_board:
    ;defs 66,0
    defs 30,%11111101   ; sample board map for testing purpose
    defs 30,%10110101

next_puyo: defs 2,0

player_score: defs 4,0

high_score: defs 4,0

puyos_cleared: defb 0

next_puyos: defb 0, 0

drop_timer: defb 0

current_speed: defb 0

; Active airborne puyo pair
; Must stay in this order for drawing purpose
prev_pair: defb 0x99    ; previous position of current pair
curr_puyo: defb 0x77    ; current pair position
pair_color: defb 0x06   ; color of current pair (unused[4]|pivot[2]|other[2])

; Chain power table
; Used for scoring
chain_table:
    defw 4, 20, 24, 32, 48, 96, 160, 240, 320, 480, 700, 800, 900, 999

; Drop time table
; Defines number of frames before the puyo is dropped to the next half row
drop_table:
    defb 25, 23, 20, 16, 13, 10, 7

; Translation table from board position to pixel coordinates
board_to_coord_tab:
    defs 120,0xfb


