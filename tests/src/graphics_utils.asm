    org 32687

; ------------------------------------------------------------------
; Main test driver
; ------------------------------------------------------------------
    ld a,1                  ; blue ink on black paper
    ld (23693),a            ; set our screen colours.
    call 3503               ; clear the screen.
    ld a,2                  ; 2 = upper screen.
    call 5633               ; open channel.

    call test_single_cell
    ;call test_fill_screen

inf_loop:                   ; infinite loop to not exit program
    jp inf_loop

; ------------------------------------------------------------------
; test_fill_screen: Test the following functions
;   fill_screen_data
; ------------------------------------------------------------------
test_fill_screen:
    ld hl,puyo_none_0
    call fill_screen_data
    ret

; ------------------------------------------------------------------
; test_single_cell: Test the following functions
;   get_pixel_address
;   get_attr_address
;   load_cell_data
;   load_2x2_data
; ------------------------------------------------------------------
test_single_cell:
    ld c,248                ; load pixel coordinates
    ld b,56                 ; for now, use (0-255,0-191) coordinates
    ld hl,puyo_none_attr    ; load attr data
    call get_attr_address   ; calculate attr addr into de
    ldi                     ; update cell attr
    inc bc                  ; don't want bc decremented!

    ld c,248                ; load pixel coordinates
    ld b,184                ; for now, use (0-255,0-191) coordinates
    ld hl,puyo_none_0       ; load pixel data addr into hl
    call get_pixel_address  ; calculate screen addr into de
    call load_cell_data     ; draw to screen - NOTE: bc corrupted!

    ld c,192                ; load pixel coordinates
    ld b,56                 ; for now, use (0-255,0-191) coordinates
    ld hl,puyo_down         ; load pixel data addr into hl
    call load_2x2_data

    ret

; ------------------------------------------------------------------
; sll8_bc: Shift left logical 3 times on b and c separately.
;          Can be used to convert pixel positions (0-23,0-31) to
;          (0-255,0-191) coordinates.
; ------------------------------------------------------------------
sll8_bc:
    ld a,b                  ; shift right b 3 times
    rla                     ; rla solution: 7+3*4  +7+7=33 cycles
    rla                     ; sla solution:   3*8+7+7+7=45 cycles
    rla
    and %11111000           ; mask out unwanted bits
    ld b,a                  ; save back to b
    ld a,c                  ; do the same to c
    rla
    rla
    rla
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
; Note: X values are 0-255, increment X by 8 to move right once
;       Y values are 0-191, increment X by 8 to move down once
; Caution: Y must be multiple of 8, otherwise unknown behavior
;          X can be any value from 0-255 and cell will stay aligned
; Reference: http://www.animatez.co.uk/
; ------------------------------------------------------------------
get_pixel_address:
    ld a,b          ; get Y2,Y1,Y0
    and %00000111
    or %01000000    ; set base address of screen (3 MLBs = 010)
    ld d,a          ; store in d
    ld a,b          ; get Y7,Y6
    rra
    rra
    rra
    and %00011000
    or d            ; combine with Y2,Y1,Y0 and store in d
    ld d,a
    ld a,b          ; get Y5,Y4,Y3
    rla
    rla
    and %11100000
    ld e,a          ; store in e
    ld a,c          ; get X7-X3
    rra
    rra
    rra
    and %00011111
    or e            ; combine with Y5,Y4,Y3 and store in e
    ld e,a
    ret

; ------------------------------------------------------------------
; TODO: fix this. currently only updates attr in top third of screen
; get_attr_address: Compute attribute address of a cell
; ------------------------------------------------------------------
; Input: b - Y (vertical) pixel position
;        c - X (horizontal) pixel position
; Output: de - attribute address of cell
; ------------------------------------------------------------------
get_attr_address:
    ; space-saving option
    call get_pixel_address
    ld d,%01011000
    ret

    ; time-saving option
    ld d,%01011000  ; base attr addr stored in d
    ld a,b          ; get Y5,Y4,Y3
    rla             ; shift into position and store in e
    rla
    and %11100000
    ld e,a
    ld a,c          ; get X7-X3
    rra             ; shift into position
    rra
    rra
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
load_2x2_data:
    push bc
    call get_pixel_address
    ld bc,32        ; set loop counter in bc to 8
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
    inc b           ; add 8 to b to move down 1 cell...
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    call get_pixel_address
    ld bc,16
    xor a
    jp load_2x2_data_loop   ; draw bottom 2 cells
load_2x2_data_done:
    ret             ; finish copying 16 bytes

; ------------------------------------------------------------------
; TODO: fill all screen (only top third currently)
; fill_screen_data: Fill entire screen with same cell data
; ------------------------------------------------------------------
; Input: hl - address of pixel data, starting from first byte
; Output: cell pixel data copied from hl to entire screen
; ------------------------------------------------------------------
; Note: weird stuff happening with the pixel addr
;       running loop_1 >256 times --> first pixel line overwritten
;       run loop_1, reload bc to 256 --> prints 2 pixel lines (???)
; ------------------------------------------------------------------
fill_screen_data:
    xor a           ; clear register a
    ld bc,3         ; push counter = 3 to stack to draw 3 thirds of screen
    push bc
    ld bc,8         ; push counter = 8 to stack for 8 pixel rows
    push bc
fill_screen_data_third:
    ld de,$4000     ; start addr of top left cell
fill_screen_data_counter:
    ld bc,256       ; draw single pixel line in one third of screen
fill_screen_data_loop_1:
    ldi             ; ld (de),(hl). inc hl. inc de. dec bc.
    dec hl          ; don't want hl incremented
    cp c            ; check if c is zero by comparing to a
    jp nz,fill_screen_data_loop_1   ; loop back while c is nonzero
    inc hl
    pop bc          ; update loop counter
    dec bc
    push bc
    cp c
    jp nz,fill_screen_data_counter
    pop bc

    pop bc          ; XXX - tmp, in progress
    ret

    pop bc          ; update loop counter, draw next third of screen
    dec bc
    push bc
    cp c
    jp nz,fill_screen_data_third
    ret

    ld bc,256
    inc hl
    inc hl
fill_screen_data_loop_2:
    ldi             ; ld (de),(hl). inc hl. inc de. dec bc.
    dec hl          ; don't want hl incremented
    cp c            ; check if c is zero by comparing to a
    jp nz,fill_screen_data_loop_2   ; loop back while c is nonzero
    ret

; ------------------------------------------------------------------
; TODO: Fill entire screen with same attribute data
; ------------------------------------------------------------------

; ------------------------------------------------------------------
; Test puyo sprites (2x2 cells)
; ------------------------------------------------------------------
puyo_none_0:
    defb 222,222,254,254,252,248,224,  0
    defb 222,222,254,254,252,248,224,  0

    defb 0,1,3,15,31,63,123,123
    defb 0,128,192,224,240,248,220,222
    defb 123,123,127,127, 63, 31,  7,  0
    defb 222,222,254,254,252,248,224,  0

puyo_down:
	defb	  0,  0,  1,192,  3,224,  7,240
	defb	 15,248, 31,196, 49,186,110,186
	defb	110,170,106,198,113,254,127,252
	defb	 63,248, 31,224, 15,128,  7,  0
puyo_none_attr:
	defb 66, 66, 66, 66
