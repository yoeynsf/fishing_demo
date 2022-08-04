.segment "BANK0"
mainprep:


.proc main
temp_x  = temp      ; defines for sprite loader
temp_y  = temp + 1
;----------------------------------------------------------------------
	LDA #$00
	TAX
	TAY
    JSR sprite_prep



    JSR clear_sprites
	LDA framecounter
wait_vblank:
	CMP framecounter	
	BEQ wait_vblank
	JMP main
.endproc
;----------------------------------------------------------------------
