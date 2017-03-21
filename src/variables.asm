
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
KILL_LOCATION           equ 74  ; Based on byte representation

; Info section
LP_TOPLEFT              equ 0x1088
LP_ROWS                 equ 10
LP_COLUMNS              equ 12
LP_TEXT_WIDTH           equ 8
PREVIEW_COORDS_TOP      equ 0x18b0
PREVIEW_COORDS_BOTTOM   equ 0x28b0
LEVEL_LINE              equ 0x4098
SCORE_NUM_LINE          equ 0x5098
;SCORE_LINE              equ 0x1888
LEVEL_NUM               equ 0x40d0
SCORE_NUM               equ 0x5098

; Avatar
AVABOX_TOPLEFT          equ 0x7098
AVABOX_ROWS             equ 8
AVABOX_COLUMNS          equ 8
AVA_TOPLEFT             equ 0x78a0
AVA_THIRD               equ 0x80a0
;AVA_THIRD               equ 0x0000
AVA_COLUMNS             equ 6
AVA_ROWS                equ 6

; Address of character set in ROM starting from '0'
ROM_CHAR_ZERO           equ 0x3d80

; Text positions
LEVEL_TEXT_POSITION     equ 0x0813
AVATAR_PARTITION        equ 0x0c11
;SCORE_TITLE             equ 0x0a11

; In-game "popup"
POPUP_TOPLEFT           equ 0x4018
POPUP_ROWS              equ 4
POPUP_PAUSED_COORD      equ 0x3830
POPUP_GAMEOVER_COORD    equ 0x3828
POPUP_MSG_TOP           equ 0x0803

BIT_VISIT               equ 3
BIT_DELETE              equ 7
NUM_TO_CLEAR            equ 4
DELETE_COLOR            equ 5
EMPTY_COLOR             equ 0
WALL_COLOR              equ 7
COLOR_BITS              equ 7
VISIBLE_END             equ 84

LEVEL_UP        equ 15
MAX_LEVEL       equ 9

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
INPUT_LONG_DELAY        equ 64
INPUT_SHORT_DELAY       equ 8
CONST_DELAY             equ 255
BLINK_DELAY             equ 63
PRESS_DELAY             equ 5
GAMEOVER_DELAY          equ 15

; Messages
msg_blank_line:         defb '            '
msg_blank_line_end:
msg_paused:             defb '   PAUSED   '
msg_paused_end:
msg_game:               defb '  _ GAME _  '
msg_game_end:
msg_over:               defb '    OVER    '
msg_over_end:
msg_paused_underline:   defb '  ________  '
msg_paused_underline_end:
msg_level:              defb 'Level: '
msg_level_end:
msg_score:              defb '   SCORE:   '
msg_score_end:


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
AVA_ATTR            equ %01001111

PAUSED_ATTR         equ %00101001
GAMEOVER_ATTR       equ %11110010
;SCORE_ATTR          equ %00000101
LEVEL_ATTR          equ %01000111
SCORE_NUM_ATTR      equ %01000101

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

next_pair: defb 0

graphics_counter: defb 0

curr_avatar: defb 0

; Drop variables
drop_timer: defb 0
drops_spawned: defb 0
current_level: defb 1

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

clear_stack_space: defs 254,0   ; space for stack, as stack goes upwards
clear_stack: defs 2, 0

; Scoring Variables
player_score: defs 3,0
player_score_bcd: defs 4, 0

cleared_colors: defb 0
cleared_count: defb 0
chain_count: defb 0

; Scoring tables
; use tsuu single player scoring values
chain_table:
    defw 0, 4, 20, 24, 32, 48, 96, 160, 240, 320, 480, 700, 800, 900, 999
; custom scoring values
    ;defw 0, 4, 8, 12, 16, 18, 20, 24, 28, 32, 36, 40, 45, 50, 100

group_table:
    defb 0, 2, 3, 4, 5, 6, 7, 10

color_table:
    defb 0, 3, 6, 12, 24

; number of set bits in a 4-bit value
set_bits_table:
    defb 0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4

; Drop time table
; Defines number of frames before the puyo is dropped to the next half row
drop_table:
    defb 100, 80, 70, 60, 50, 40, 35, 30, 20, 17
    ;Lv.   0   1   2   3   4   5   6   7   8   9

; Translation table from board position to pixel coordinates
board_to_coord_tab:
    defs 192,0xfb
