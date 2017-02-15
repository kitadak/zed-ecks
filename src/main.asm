    org 32687

; ------------------------------------------------------------------
; Main test driver
; ------------------------------------------------------------------
    ld a,1                  ; blue ink on black paper
    ld (23693),a            ; set our screen colours.
    call 3503               ; clear the screen.
    ld a,2                  ; 2 = upper screen.
    call 5633               ; open channel.

    call test_fill_screen
    ;call test_single_cell

inf_loop:                   ; infinite loop to not exit program
    jp inf_loop

