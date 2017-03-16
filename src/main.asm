
; ------------------------------------------------------------------
; Main test driver
; ------------------------------------------------------------------
    ld a,BACKGROUND_ATTR    ; black ink on purple paper, no bright, no flash
    ld (23693),a            ; set our screen colours.
    call 3503               ; clear the screen.
    ld a,2                  ; 2 = upper screen.
    call 5633               ; open channel.

    call populate_coord_tab
    call reset_board
    call init_background
    call connect_puyos
    call refresh_board      ; test
    call test_single_cell   ; test
    ;call drop_floats        ; test

inf_loop:                   ; infinite loop to not exit program
    call play_check_input
    call draw_curr_pair     ; test
    jp inf_loop

; ------------------------------------------------------------------
; Test drop loop (no user input, new board representation)
; ------------------------------------------------------------------
test_init:
    ld a,25
    ld (drop_timer),a
test_play_drop_loop:


; ------------------------------------------------------------------
; Main Game Loop
; ------------------------------------------------------------------

play_init:
    call reset_game
    call gen_puyos

play_main_loop:
    call gameover_detect
    cp 0
    jp nz, gameover
    call spawn_puyos
    call reset_drop_timer

play_drop_loop:
    ;call redraw_board          ; update the board with the new puyos
    call play_check_input       ; move or rotate the puyo if required

    ld hl, (drop_timer)         ; update timer
    dec hl
    ld (drop_timer), hl
    cp 0
    call z, check_active_below  ; check if next row is occupied
    cp 0
    jp z, play_drop_loop        ; puyo hasn't moved down a row yet


    ; puyo has stopped
    ; drop remaining floating puyos
    call drop_active_puyos

play_clear_loop:            ; start clearing chain
    call process_clears
    cp 0
    jp nz, play_clear_loop
    jp play_main_loop

reset_game:
    ret
