
; ------------------------------------------------------------------
; Main Game Loop
; ------------------------------------------------------------------

main_init:
    call populate_coord_tab
    call start_greets

main_title:
    call init_title
    call start_theme_music
    call reset_game
    call init_background

main_game_start:
    ld ix,game_start_music_data
    call play_sound_effect

main_loop_spawn:
    call gameover_detect
    cp 0
    jp nz, gameover
    call check_avatar
    call spawn_puyos
    call draw_preview
    call draw_curr_pair
    call drop_timer_reset
main_loop_drop:
    ld c, 3
    call blink_delay

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
    call write_pair_to_board
main_loop_clear:
    call drop_floats            ; drop any floating puyos
    ld ix,puyodrop_music_data
    call play_sound_effect
    call connect_puyos
    call refresh_board
    call check_clears           ; mark the clears
    cp 0
    jp z, main_reset_score_vars       ; nothing to clear, go spawn a new puyo

    ld hl,chain_count
    inc (hl)
    ld a,(hl)

    ; play appropriate chain up to 7
    cp 1
    jr z, chain1_se
    cp 2
    jr z, chain2_se
    cp 3
    jr z, chain3_se
    cp 4
    jr z, chain4_se
    cp 5
    jr z, chain5_se
    cp 6
    jr z, chain6_se
    jr chain7_se

chain1_se:
    ld ix,rensa1_music_data
    jr main_loop_clear_continue
chain2_se:
    ld ix,rensa2_music_data
    jr main_loop_clear_continue
chain3_se:
    ld ix,rensa3_music_data
    jr main_loop_clear_continue
chain4_se:
    ld ix,rensa4_music_data
    jr main_loop_clear_continue
chain5_se:
    ld ix,rensa5_music_data
    jr main_loop_clear_continue
chain6_se:
    ld ix,rensa6_music_data
    jr main_loop_clear_continue
chain7_se:
    ld ix,rensa7_music_data

main_loop_clear_continue:
    call play_sound_effect
    call clear_puyos
    call update_score
    call print_score
    ld hl,avatar_happy          ; print happy avatar if possible
    call print_avatar
    jp main_loop_clear          ; keep chaining clears/settles

main_reset_score_vars:
    xor a
    ld (cleared_colors), a
    ld (chain_count), a
    ld (cleared_count), a
    ld a,(curr_avatar)
    cp 0
    jp z,main_reset_score_vars_avatar_normal
    ld hl,avatar_worried
    call print_avatar
    jp main_loop_spawn
main_reset_score_vars_avatar_normal:
    ld hl,avatar_normal
    call print_avatar
    jp main_loop_spawn

reset_game:                     ; reset all variables
    call reset_board
    xor a
    ld (next_pair), a
    ld (player_score), a
    ld (player_score+1), a
    ld (player_score+2), a
    ld (player_score_bcd), a
    ld (player_score_bcd+1), a
    ld (player_score_bcd+2), a
    ld (player_score_bcd+3), a

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

