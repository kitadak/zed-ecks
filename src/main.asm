
; ------------------------------------------------------------------
; Main test driver
; ------------------------------------------------------------------
    ld a,background_attr    ; black ink on purple paper, no bright, no flash
    ld (23693),a            ; set our screen colours.
    call 3503               ; clear the screen.
    ld a,2                  ; 2 = upper screen.
    call 5633               ; open channel.

    call init_background
    call test_single_cell

inf_loop:                   ; infinite loop to not exit program
    jp inf_loop

