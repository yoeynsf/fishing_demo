mainprep:           ; any vars that need to be set up before can be done in here

    LDA #<song_bank0
    STA song_pointer
    LDA #>song_bank0
    STA song_pointer + 1

    LDA #1			; song 1
    LDX #0			; NTSC
    JSR ft_music_init

    LDX #35
    LDY #1
    JSR fadein_palette

.proc main          ; "proc" is just a fancy way of saying scope (everything defined inside is not global)
temp_x  = temp      ; defines for sprite loader. not interpreted as code or nuthin
temp_y  = temp + 1
;----------------------------------------------------------------------
	LDA #$00
	TAX
	TAY
    JSR sprite_prep

    JSR clear_sprites

	LDA framecounter
wait_vblank:
	CMP framecounter	; NMI will modify this and the branch will happen
	BEQ wait_vblank
	JMP main
.endproc
;----------------------------------------------------------------------
