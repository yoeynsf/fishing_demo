mainprep:           ; any vars that need to be set up before can be done in here

    LDA #0			; song 1
    LDX #0			; NTSC
    JSR ft_music_init

.proc main          ; "proc" is just a fancy way of saying scope (everything defined inside is not global)
temp_x  = temp      ; defines for sprite loader. not interpreted as code or nuthin
temp_y  = temp + 1
;----------------------------------------------------------------------
	LDA #$00
	TAX
	TAY
    JSR sprite_prep

    LDA joy_status
    AND #KEY_A      ; isolate the bit and see if it's pressed
    BEQ :+
    LDX #4
    LDY #0
    JSR fadein_palette
:
    LDA joy_status
    AND #KEY_B 
    BEQ :+
    LDX #4
    JSR fadeout_palette
:

    JSR clear_sprites

	LDA framecounter
wait_vblank:
	CMP framecounter	; NMI will modify this and the branch will happen
	BEQ wait_vblank
	JMP main
.endproc
;----------------------------------------------------------------------
