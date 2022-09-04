mainprep:           ; any vars that need to be set up before can be done in here

    LDA #<song_bank0
    STA song_pointer
    LDA #>song_bank0
    STA song_pointer + 1

    LDA #4          ; song 5
    LDX #0          ; NTSC
    JSR ft_music_init

    LDX #35
    LDY #1
    JSR fadein_palette

.proc main          ; "proc" is just a fancy way of saying scope (everything defined inside is not global)
temp_x  = temp      ; defines for sprite loader. not interpreted as code or nuthin
temp_y  = temp + 1
;----------------------------------------------------------------------
.if .defined(DEBUGGING)
    ; debug: main length measurement
    LDA s_PPUMASK
    AND #%00011111    ; remove emphasis
    ORA #%11100001    ; black emphasis, grayscale
    STA s_PPUMASK
    STA PPUMASK
.endif

    LDA #$00
    TAX
    TAY
    JSR sprite_prep

    LDA joy_held
    AND #KEY_A
    BNE :+
    LDA joy_status
    AND #KEY_A
    BEQ :+
    LDX #ID_fish
    JSR spawn_entity
:

    LDA joy_held
    AND #KEY_B
    BNE :+
    LDA joy_status
    AND #KEY_B
    BEQ :+
    LDX #ID_fish
    JSR despawn_entity
:
    JSR update_entity

.if .defined(DEBUGGING)
    ; debug: load_entity_sprites length measurement
    LDA s_PPUMASK
    AND #%00011111    ; remove emphasis
    ORA #%00100001    ; red emphasis, grayscale
    STA s_PPUMASK
    STA PPUMASK
.endif

    JSR load_entity_sprites

.if .defined(DEBUGGING)
    ; debug: clear_sprites length measurement
    LDA s_PPUMASK
    AND #%00011111    ; remove emphasis
    ORA #%01000001    ; green emphasis, grayscale
    STA s_PPUMASK
    STA PPUMASK
.endif

    JSR clear_sprites

.if .defined(DEBUGGING)
    ; debug: finish routine length measurement
    LDA s_PPUMASK
    AND #%00011110    ; remove emphasis and grayscale
    STA s_PPUMASK
    STA PPUMASK
.endif

    ; this frame is now ready for rendering
    LDA flags
    ORA #RENDER_FLAG
    STA flags

    LDA framecounter
wait_vblank:
    CMP framecounter    ; NMI will modify this and the branch will happen
    BEQ wait_vblank
    JMP main
.endproc
;----------------------------------------------------------------------
