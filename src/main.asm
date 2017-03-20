
; ------------------------------------------------------------------
; Main test driver
; ------------------------------------------------------------------
    ld a,BACKGROUND_ATTR    ; black ink on purple paper, no bright, no flash
    ld (23693),a            ; set our screen colours.
    call 3503               ; clear the screen.
    ld a,2                  ; 2 = upper screen.
    call 5633               ; open channel.

    call populate_coord_tab
    ;call reset_board
    call init_background
    call connect_puyos
    call check_clears
    call refresh_board      ; test
    call test_single_cell   ; test
    ;call drop_floats       ; test

inf_loop:                   ; infinite loop to not exit program
    ;call play_check_input
    ;call draw_curr_pair     ; test
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

main_init:
    call populate_coord_tab
    ; call greets
    ; call title_screen

main_title:

main_game_start:
    call reset_game

main_loop_spawn:
    call gameover_detect
    cp 0
    jp nz, gameover
    call spawn_puyos
    call drop_timer_reset
main_loop_drop:
    ; draw active puyo
    ld hl, drop_timer           ; update drop timer
    dec (hl)
    ld a, (hl)
    cp 0
    jp nz, main_loop_input
    call check_active_below     ; if zero, puyo moving down
    cp 0                        ; drop/settle if anything is below
    jp nz, main_loop_clear_init
    ; nothing below, update curr_pair position
    call input_move_down        ; this will also reset the drop timer
    jp main_loop_drop

main_loop_move_puyo:
    ; call move_puyo_down
    call drop_timer_reset
    jp main_loop_drop

main_loop_input:
    call play_check_input
    ; if down was pressed, need to reset timer
    jp main_loop_drop

main_loop_clear_init:
    ; write active puyo to board
main_loop_clear:
    call drop_floats            ; drop any floating puyos
    call refresh_board
    call connect_puyos
    call check_clears           ; mark the clears
    cp 0
    jp z, main_loop_spawn       ; nothing to clear, go spawn a new puyo
    ; call deletes
    jp main_loop_clear          ; keep chaining clears/settles

reset_game:                     ; reset all variables
    xor a
    ld (next_pair), a
    ld (player_score), a
    ld (player_score+1), a
    ld (player_score+2), a
    ld (puyos_cleared), a
    ld (drop_timer), a
    ld (drops_spawned), a
    ld (curr_pair), a
    ld (curr_pair+1), a
    ld (prev_pair), a
    ld (prev_pair+1), a
    ld (pair_color), a

    ld (curr_input), a
    ld (prev_input), a
    ld (LR_timer), a

    ld (curr_idx), a
    ld (board_idx), a

    ld (cleared_colors), a
    ld (cleared_count), a
    ld (chain_count), a

    inc a
    ld (current_level), a       ; current level starts at 1
    ret
