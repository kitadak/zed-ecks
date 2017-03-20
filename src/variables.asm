

; ==================================================================
; FILE: variables.asm
; ------------------------------------------------------------------
;   Contains macros and variables used across the whole project.
; ==================================================================

; ------------------------------------------------------------------
; Macros/Constants
; ------------------------------------------------------------------

; Coordinates / board positions
TOPLEFT_HIDDEN          equ 0x0008
TOPLEFT_VISIBLE         equ 0x1018
TOTAL_ROWS              equ 12
TOTAL_COLUMNS           equ 8
BOARD_SIZE              equ 96
PREVIEW_COORDS_TOP      equ 0x1088
PREVIEW_COORDS_BOTTOM   equ 0x2088
KILL_LOCATION           equ 74  ; Based on byte representation

BIT_VISIT               equ 3
BIT_DELETE              equ 7
NUM_TO_CLEAR            equ 4
DELETE_COLOR            equ 5
EMPTY_COLOR             equ 0
WALL_COLOR              equ 7
COLOR_BITS              equ 7
VISIBLE_END             equ 84

WALL_LEFT               equ 0x08    ; cp c
WALL_RIGHT              equ 0x78    ; cp c
WALL_BOTTOM             equ 0xB0    ; cp b
HIDDEN_ROW              equ 0x00    ; cp b

BIT_P                   equ 7
BIT_H                   equ 4
BIT_J                   equ 3
BIT_D                   equ 2
BIT_S                   equ 1
BIT_A                   equ 0

BIT_UP                  equ 7
BIT_RIGHT               equ 6
BIT_DOWN                equ 5
BIT_LEFT                equ 4

; Delays
INPUT_LONG_DELAY        equ 128
INPUT_SHORT_DELAY       equ 16
DROP_FLOATS_DELAY       equ 255
BLINK_DELAY             equ 255
BLINK_DELAY_2           equ 63


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

EMPTY_BOARD:
    defs 24,0xff
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0xff,0xff
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0xff,0xff
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0xff,0xff
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0xff,0xff
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0xff,0xff
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0xff,0xff
    defs 24,0xff

; ------------------------------------------------------------------
; Graphics Attributes
; ------------------------------------------------------------------

BACKGROUND_ATTR     equ 3
TITLE_BOTTOM_ATTR   equ 0x06
TITLE_FLASH_ATTR    equ 0x86
COLOR_WHITE_FLASH   equ 0x47
PUYO_BLUE           equ 65
PUYO_RED            equ 66
PUYO_GREEN          equ 68
PUYO_YELLOW         equ 70

val_puyo_blue:      defb 65
val_puyo_red:       defb 66
val_puyo_green:     defb 68
val_puyo_yellow:    defb 70

; ------------------------------------------------------------------
; Variables/Tables
; ------------------------------------------------------------------

tmp_counter: defb 0

    defm "Hai PLAYER_BOARD desu"
player_board:
    ;defs 192,0
    defs 24,0xff
    ; test sprites
    defb 0x06,0x00,0x02,0x00,0x06,0x00,0x02,0x00,0x06,0x00,0xf2,0x00
    defb 0xe6,0x00,0xd2,0x00,0xc6,0x00,0xb2,0x00,0xa6,0x00
    defb 0xff,0xff
    defb 0xf6,0x00,0x92,0x00,0x86,0x00,0x72,0x00,0x66,0x00,0x52,0x00
    defb 0x46,0x00,0x32,0x00,0x26,0x00,0x12,0x00,0x06,0x00
    defb 0xff,0xff
    defb 0xf6,0x00,0xa2,0x00,0xf6,0x00,0xa2,0x00,0xf6,0x00,0xa2,0x00
    defb 0xf6,0x00,0xa2,0x00,0xf6,0x00,0xa2,0x00,0xf6,0x00
    defb 0xff,0xff
    defb 0xf6,0x00,0xa2,0x00,0xf6,0x00,0xa2,0x00,0xf6,0x00,0xa2,0x00
    defb 0xf6,0x00,0xa2,0x00,0xf6,0x00,0xa2,0x00,0xf6,0x00
    defb 0xff,0xff
    ; has empty cell
    defb 0xf6,0x00,0xa2,0x00,0xf6,0x00,0x00,0x00,0xf6,0x00,0xa6,0x00
    defb 0xf6,0x00,0xa2,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    defb 0xff,0xff
    defb 0xf6,0x00,0xa2,0x00,0xf6,0x00,0xa2,0x00,0xf6,0x00,0xa2,0x00
    defb 0xf6,0x00,0xa2,0x00,0xf6,0x00,0xa2,0x00,0xf6,0x00
    defb 0xff,0xff
    defs 24,0xff

;next_pair: defb %00100001
next_pair: defb 0

player_score: defs 4,0

high_score: defs 4,0

puyos_cleared: defb 0

drop_timer: defb 0

current_speed: defb 0

is_paused: defb 0

clear_puyos_counter: defb 0

; Active airborne puyo pair
curr_pair: defb 26,%00000010    ; current pair position
prev_pair: defb 82,%00000011    ; previous position of current pair
pair_color: defb %00100001

; Input Variables
curr_input: defb 0
prev_input: defb 0              ; no buttons pressed at beginning
LR_timer: defb 0
D_timer: defb 0
rotate_timer: defb 0


; Clearing Variables
old_stack: defs 2, 0
curr_idx: defb 0
curr_addr: defs 2, 0
board_idx: defb 0
prev_matches: defs 4,0

clear_stack_space: defs 256,0   ; space for stack, as stack goes upwards
clear_stack: defs 2, 0

; Scoring Variables
cleared_colors: defb 0
cleared_count: defb 0
chain_count: defb 0

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
    defs 192,0xfb


