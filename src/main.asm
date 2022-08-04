mainprep:


.proc main
temp_x  = temp      ; defines for sprite loader
temp_y  = temp + 1
;----------------------------------------------------------------------
	LDA #$00
	TAX
	TAY
    JSR sprite_prep

    LDA joy_status
    AND #KEY_A 
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
	CMP framecounter	
	BEQ wait_vblank
	JMP main
.endproc
;----------------------------------------------------------------------
