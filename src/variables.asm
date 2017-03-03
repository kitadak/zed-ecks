; Variable locations
player_board: defw 0x8000
next_puyo: defw 0x8050
player_score: defw 0x8052
high_score: defw 0x8056
puyos_cleared: defb 0x8060


; Chain power table
chain_table:
defw 4, 20, 24, 32, 48, 96, 160, 240, 320, 480, 700, 800, 900, 999
