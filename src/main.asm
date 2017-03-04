; ------------------------------------------------------------------
; Main test driver
; ------------------------------------------------------------------
    ld a,1                  ; blue ink on black paper
    ld (23693),a            ; set our screen colours.
    call 3503               ; clear the screen.
    ld a,2                  ; 2 = upper screen.
    call 5633               ; open channel.

    ;call test_fill_screen
    ;call test_single_cell

inf_loop:                   ; infinite loop to not exit program
    jp inf_loop

; ------------------------------------------------------------------
; Main Game Loop
; ------------------------------------------------------------------

play_init:
    call reset_game
    call gen_puyos

play_main_loop:
    call gameover_detect
    jp z, gameover
    call spawn_puyos
    call reset_drop_timer

play_drop_loop:
    ;call redraw_board      ; update the board with the new puyos
    call play_check_input   ; move or rotate the puyo if required

    ld hl, (drop_timer)     ; update timer
    dec hl
    ld (drop_timer), hl
    call z, check_next_row  ; check if next row is occupied
    jp z, play_drop_loop    ; puyo hasn't moved down a row yet


    ; puyo has stopped
    ; drop remaining floating puyos
    call drop_active_puyos

play_clear_loop:            ; start clearing chain
    call process_clears
    jp nz, play_clear_loop
    jp play_main_loop

reset_game:
    ret
