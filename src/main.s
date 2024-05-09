.export mainprep

.importzp song_pointer, joy_held, joy_status, framecounter, temp
.import spawn_entity, despawn_entity, update_entity, load_entity_sprites, clear_sprites, song_bank0, ID_fish, ft_music_init, fadein_palette, sprite_prep

.include "defines.inc"
.segment "FIXEDBANK"

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
    ; debug: main length measurement
    ; LDA s_PPUMASK
    ; AND #%00011111    ; remove emphasis
    ; ORA #%11100001    ; black emphasis, grayscale
    ; STA s_PPUMASK
    ; STA PPUMASK

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
    LDX #1
    JSR spawn_entity
:

    LDA joy_held
    AND #KEY_B
    BNE :+
    LDA joy_status
    AND #KEY_B  
    BEQ :+
    LDX #1
    JSR despawn_entity
:
    JSR update_entity
    
    ; debug: load_entity_sprites length measurement
    ; LDA s_PPUMASK
    ; AND #%00011111    ; remove emphasis
    ; ORA #%00100001    ; red emphasis, grayscale
    ; STA s_PPUMASK
    ; STA PPUMASK

    JSR load_entity_sprites

    ; debug: clear_sprites length measurement
    ; LDA s_PPUMASK
    ; AND #%00011111    ; remove emphasis
    ; ORA #%01000001    ; green emphasis, grayscale
    ; STA s_PPUMASK
    ; STA PPUMASK

    JSR clear_sprites
    
    ; debug: finish routine length measurement
    ; LDA s_PPUMASK
    ; AND #%00011110    ; remove emphasis and grayscale
    ; STA s_PPUMASK
    ; STA PPUMASK

    LDA framecounter
wait_vblank:
    CMP framecounter    ; NMI will modify this and the branch will happen
    BEQ wait_vblank
    JMP main
.endproc
;----------------------------------------------------------------------
