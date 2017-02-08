    org 32687
    ld a,2                  ; red ink on black paper
    ld (23693),a            ; set our screen colours.
    call 3503               ; clear the screen.
    ld a,2                  ; 2 = upper screen.
    call 5633               ; open channel.

; ------------------------------------------------------------------
; Test driver for get_pixel_address and load_cell_data
; ------------------------------------------------------------------
    ld c,0                  ; load pixel coordinates
    ld b,184                ; for now, use (0-255,0-191) coordinates
    ld hl,puyo_none_0       ; load pixel data addr into hl
    call get_pixel_address  ; calculate screen addr into de
    call load_cell_data     ; draw to screen
inf_loop:                   ; infinite loop to not exit program
    jp inf_loop

; ------------------------------------------------------------------
; srl8_bc: Shift right logical 3 times on b and c separately.
;          Can be used to convert pixel positions (0-23,0-31) to
;          (0-255,0-191) coordinates.
; ------------------------------------------------------------------
srl3_bc:
    ld a,b                  ; shift right b 3 times
    rra                     ; rra solution: 7+3*4  +7+7=33 cycles
    rra                     ; sra solution:   3*8+7+7+7=45 cycles
    rra
    and %00011111           ; mask out unwanted bits
    ld b,a                  ; save back to b
    ld a,c                  ; do the same to c
    rra
    rra
    rra
    and %00011111
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
    ld a,c          ; get X4-X0
    rra
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
; Output: cell pixel data copied from de to memory address
; ------------------------------------------------------------------
load_cell_data:
    ld c,8          ; set loop counter in bc to 8
    ld b,0
    xor a           ; clear register a
load_cell_data_loop:
    ldi             ; ld (de),(hl). inc hl. inc de. dec bc.
    dec de          ; don't want de incremented
    inc d           ; move to next byte in cell instead
    cp c            ; check if c is zero by comparing to a
    jp nz,load_cell_data_loop   ; loop back while c is nonzero
    ret             ; finish copying 8 bytes

; ------------------------------------------------------------------
; Test zero connect puyo sprite (2x2 cells)
; ------------------------------------------------------------------
puyo_none_0:
    defb 0,1,3,15,31,63,123,123
    defb 0,128,192,224,240,248,220,222
    defb 123,123,127,127, 63, 31,  7,  0
    defb 222,222,254,254,252,248,224,  0
