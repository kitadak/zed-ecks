

; ==================================================================
; FILE: graphics_utils.asm
; ------------------------------------------------------------------
;   Contains graphics utility routines to draw sprites to screen,
;   clear sprites, etc.
; ==================================================================


; ------------------------------------------------------------------
; test_single_cell: Test the following functions
;   get_pixel_address
;   get_attr_address
;   load_cell_data
;   load_2x2_data
;   clear_puyo_2x2
; ------------------------------------------------------------------
test_single_cell:
    ld c,232                ; load pixel coordinates
    ld b,176                ; for now, use (0-255,0-191) coordinates
    ld l,PUYO_GREEN         ; load attr data
    call load_2x2_attr

    ld c,248                ; load pixel coordinates
    ld b,184                ; for now, use (0-255,0-191) coordinates
    ld hl,puyo_udr          ; load pixel data addr into hl
    call get_pixel_address  ; calculate screen addr into de
    call load_cell_data     ; draw to screen - NOTE: bc corrupted!

    ld c,0                  ; load pixel coordinates
    ld b,72                 ; for now, use (0-255,0-191) coordinates
    ld hl,puyo_d            ; load pixel data addr into hl
    call load_2x2_data

    ld c,176                ; load pixel coordinates
    ld b,176
    call clear_puyo_2x2     ; clear 2x2 cells

    ret

; ------------------------------------------------------------------
; sll8_bc: Shift left logical 3 times on b and c separately.
;          Can be used to convert pixel positions (0-23,0-31) to
;          (0-255,0-191) coordinates.
; ------------------------------------------------------------------
; Registers polluted: a
; ------------------------------------------------------------------
sll8_bc:
    ld a,b                  ; shift right b 3 times
    rlca                    ; rla solution: 7+3*4  +7+7=33 cycles
    rlca                    ; sla solution:   3*8+7+7+7=45 cycles
    rlca
    and %11111000           ; mask out unwanted bits
    ld b,a                  ; save back to b
    ld a,c                  ; do the same to c
    rlca
    rlca
    rlca
    and %11111000
    ld c,a
    ret

; ------------------------------------------------------------------
; get_pixel_address: Compute screen address of a byte
; ------------------------------------------------------------------
; Input: b - Y (vertical) pixel position
;        c - X (horizontal) pixel position
; Output: de - screen address of top byte in cell
; ------------------------------------------------------------------
; Registers polluted: a
; ------------------------------------------------------------------
; Note: X values are 0-255, increment X by 8 to move right once
;       Y values are 0-191, increment X by 8 to move down once
; Caution: Y must be multiple of 8, otherwise unknown behavior
;          X can be any value from 0-255 and cell will stay aligned
; Reference: http://www.animatez.co.uk/
; ------------------------------------------------------------------
get_pixel_address:
    ld a,b          ; get Y2,Y1,Y0
    and %00000111
    or %01000000    ; set base address of screen (3 MSBs = 010)
    ld d,a          ; store in d
    ld a,b          ; get Y7,Y6
    rrca
    rrca
    rrca
    and %00011000
    or d            ; combine with Y2,Y1,Y0 and store in d
    ld d,a
    ld a,b          ; get Y5,Y4,Y3
    rlca
    rlca
    and %11100000
    ld e,a          ; store in e
    ld a,c          ; get X7-X3
    rrca
    rrca
    rrca
    and %00011111
    or e            ; combine with Y5,Y4,Y3 and store in e
    ld e,a
    ret

; ------------------------------------------------------------------
; get_attr_address: Compute attribute address of a cell
; ------------------------------------------------------------------
; Input: b - Y (vertical) pixel position
;        c - X (horizontal) pixel position
; Output: de - attribute address of cell
; ------------------------------------------------------------------
; Registers polluted: a
; ------------------------------------------------------------------
get_attr_address:
    ld a,b          ; get Y7,Y6
    and %11000000
    rlca
    rlca
    or %01011000    ; set base attr addr (6 MSBs = 010110)
    ld d,a          ; store in d
    ld a,b          ; get Y5,Y4,Y3
    rlca            ; shift into position and store in e
    rlca
    and %11100000
    ld e,a
    ld a,c          ; get X7-X3
    rrca            ; shift into position
    rrca
    rrca
    and %00011111
    or e            ; combine with Y5,Y4,Y3 and store in e
    ld e,a
    ret

; ------------------------------------------------------------------
; load_cell_data: Display cell data to screen
; ------------------------------------------------------------------
; Input: de - cell screen address, starting from first row (byte)
;        hl - address of pixel data, starting from first byte
; Output: cell pixel data copied from hl to memory address
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e
; ------------------------------------------------------------------
load_cell_data:
    ld bc,8         ; set loop counter in bc to 8
    xor a           ; clear register a
load_cell_data_loop:
    ldi             ; ld (de),(hl). inc hl. inc de. dec bc.
    dec de          ; don't want de incremented
    inc d           ; move to next byte in cell instead
    cp c            ; check if c is zero by comparing to a
    jp nz,load_cell_data_loop   ; loop back while c is nonzero
    ret             ; finish copying 8 bytes

; ------------------------------------------------------------------
; load_2x2_data: Display 2x2 square pixel data to screen
; ------------------------------------------------------------------
; Input: bc - top left cell's coordinates
;        hl - address of pixel data, starting from first byte
; Output: 2x2 pixel data copied from hl to memory address
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e
; ------------------------------------------------------------------
load_2x2_data:
    push bc
    call get_pixel_address
    ld bc,32        ; set loop counter in bc to 32
    ld a,16         ; set a to 16 to load top 2 cells
load_2x2_data_loop:
    ldi             ; ld (de),(hl). inc hl. inc de. dec bc.
    ldi             ; repeat - load top 2 pixel rows
    dec de          ; don't want de incremented
    dec de
    inc d           ; move to next pixel row
    cp c            ; check if c == a
    jp nz,load_2x2_data_loop    ; loop back while c is nonzero
    xor a           ; clear a, repeat
    cp c            ; check if c is zero this time
    jp z,load_2x2_data_done

    pop bc          ; pop param from stack
    ld a,8          ; add 8 to b to move down 1 cell
    add a,b
    ld b,a
    call get_pixel_address
    ld bc,16
    xor a
    jp load_2x2_data_loop   ; draw bottom 2 cells
load_2x2_data_done:
    ret             ; finish copying 16 bytes

; ------------------------------------------------------------------
; load_2x2_attr: Set 2x2 square attribute
; ------------------------------------------------------------------
; Input: bc - top left cell's coordinates
;        l  - attribute byte
; Output: 2x2 attribute copied to attribute address of 2x2 square
; ------------------------------------------------------------------
; Registers polluted: a, b, d, e
; ------------------------------------------------------------------
load_2x2_attr:
    call get_attr_address   ; get top left cell attr addr
    ld a,l                  ; load a with attr byte
    ld (de),a               ; load top 2 cells
    inc de
    ld (de),a
    ld a,8
    add a,b                 ; get bottom 2 cells' attr addr
    ld b,a
    call get_attr_address
    ld a,l                  ; load bottom 2 cells
    ld (de),a
    inc de
    ld (de),a
    ret

; ------------------------------------------------------------------
; fill_screen_data: Fill entire screen with same cell data
; ------------------------------------------------------------------
; Input: hl - address of pixel data, starting from first byte
; Output: cell pixel data copied from hl to entire screen
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e, h, l
; ------------------------------------------------------------------
; Note: weird stuff happening with the pixel addr
;       running loop_1 >256 times --> first pixel line overwritten
;       run loop_1, reload bc to 256 --> prints 2 pixel lines (???)
; ------------------------------------------------------------------
fill_screen_data:
    ld bc,3         ; push counter = 3 to stack to draw 3 thirds of screen
    push bc
    ld de,$4000     ; start addr of top left cell
    ld bc,8         ; push counter = 8 to stack for 8 pixel rows
    push bc
fill_screen_data_counter:
    ld bc,256       ; draw single pixel line in one third of screen
    xor a           ; clear register a
fill_screen_data_loop:
    ldi             ; ld (de),(hl). inc hl. inc de. dec bc.
    dec hl          ; don't want hl incremented
    cp c            ; check if c is zero by comparing to a
    jp nz,fill_screen_data_loop   ; loop back while c is nonzero
    inc hl
    pop bc          ; update loop counter
    dec bc
    push bc
    cp c
    jp nz,fill_screen_data_counter
    pop bc          ; pop counter = 8 from stack
    pop bc          ; update loop counter, draw next third of screen
    dec bc
    push bc
    ld a,c
    cp 2
    jp z,fill_screen_data_2
    cp 1
    jp z,fill_screen_data_3
    pop bc          ; done, pop counter and return
    ret
fill_screen_data_2:
    ld de,$4800
    jp fill_screen_data_setup
fill_screen_data_3:
    ld de,$5000
fill_screen_data_setup:
    dec hl
    dec hl
    dec hl
    dec hl
    dec hl
    dec hl
    dec hl
    dec hl
    ld bc,8         ; push counter = 8 to stack for 8 pixel rows
    push bc
    jp fill_screen_data_counter

; ------------------------------------------------------------------
; clear_puyo_2x2: set 2x2 sprite at given coordinates to black attr
; ------------------------------------------------------------------
; Input: b - Y coordinate
;        c - X coordinate
; Output: 2x2 puyo sprite goes black
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e, h, l
; ------------------------------------------------------------------
clear_puyo_2x2:
    ld hl,2                 ; push loop counter
    push hl
clear_puyo_2x2_loop:
    call get_attr_address   ; get attr addr of left cell
    xor a
    ld (de),a
    inc de
    ld (de),a
    ld a,8
    add a,b
    ld b,a
    pop hl
    dec hl
    push hl
    xor a
    cp l
    jp nz,clear_puyo_2x2_loop
    pop hl
    ret

; ------------------------------------------------------------------
; populate_coord_tab: Populate boardmap to coordinate table
; ------------------------------------------------------------------
; Input: None
; Output: board_to_coord_tab populated
; ------------------------------------------------------------------
; Registers polluted: a, b, c, d, e, h, l
; ------------------------------------------------------------------
populate_coord_tab:
    ld bc,TOPLEFT_HIDDEN
    ld hl,board_to_coord_tab
    ld de,6                 ; push column counter to stack
    push de
populate_coord_tab_column:
    ld de,10                ; push row counter to stack
    push de
populate_coord_tab_row:
    ld (hl),bc              ; write to table
    inc hl                  ; point hl to next table entry (2 bytes each)
    inc hl
    ld a,16                 ; move down 2 char lines by adding 16 to b
    add a,b
    ld b,a
    pop de                  ; check row counter to see if we reached bottom row
    dec de
    push de
    xor a
    cp e
    jp nz,populate_coord_tab_row
    pop de                  ; check if we finished last column
    pop de
    dec de
    cp e
    jp z,populate_coord_tab_done
    push de
    ld bc,TOPLEFT_HIDDEN
    ld a,6                  ; add 8*(6-e) to c
    sub e
    sla a
    sla a
    sla a
    sla a
    add c
    ld c,a
    jp populate_coord_tab_column
populate_coord_tab_done:
    ret

; ------------------------------------------------------------------
; get_board_to_coord: Translate given board position to coordinates
; ------------------------------------------------------------------
; Input: bc - board position number (0-59)
; Output: coordinates in bc
; ------------------------------------------------------------------
; Registers polluted: h, l
; ------------------------------------------------------------------
get_board_to_coord:
    ld hl,board_to_coord_tab
    add hl,bc
    add hl,bc
    ld c,(hl)
    inc hl
    ld b,(hl)
get_board_to_coord_done:
    ret

; ------------------------------------------------------------------
; Tables
; ------------------------------------------------------------------
board_to_coord_tab:
    defs 120,0xfb
