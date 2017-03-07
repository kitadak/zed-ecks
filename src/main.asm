
; ------------------------------------------------------------------
; Macros
; ------------------------------------------------------------------
TOPLEFT_VISIBLE equ 0x1818
TOPLEFT_HIDDEN  equ 0x0818
TOTAL_CELLS     equ 60

; ------------------------------------------------------------------
; Main test driver
; ------------------------------------------------------------------
    ld a,background_attr    ; black ink on purple paper, no bright, no flash
    ld (23693),a            ; set our screen colours.
    call 3503               ; clear the screen.
    ld a,2                  ; 2 = upper screen.
    call 5633               ; open channel.

    call populate_coord_tab
    call init_background
    call update_board_pixel ; test
    call test_single_cell

inf_loop:                   ; infinite loop to not exit program
    jp inf_loop

