.proc sprite_prep
	LDA OAMposAtFrame
    CLC 
    ADC #32
    STA currentOAMpos
    STA OAMposAtFrame
	RTS
.endproc

.proc load_sprites
temp_x  = temp              ; defines for sprite loader
temp_y  = temp + 1
;-------------------
    LDY #0
    LDX currentOAMpos       ;We're about to render a sprite so get the next free one.
:
	LDA (pointer), Y         ;Y position
    BMI donesprite
    CLC
    ADC temp_y
    SEC
    SBC #1                  ; compensate for the +1 scanline delay
    STA $0200, X
    INY
    INX
    LDA (pointer), Y        ;Tile Number
    STA $0200, X
    INY
    INX
    LDA (pointer), Y        ;Attributes
    STA $0200, X
    INY
    INX
    LDA (pointer), Y        ;X position
    CLC
    ADC temp_x
    STA $0200, X
    INY
    INX
    JMP :-
    donesprite:
    STX currentOAMpos
	RTS
.endproc 
 
.proc clear_sprites
    LDX currentOAMpos
    LDA #$FF
    Clear:
    STA $0200, X
    INX
    INX
    INX
    INX
    CPX OAMposAtFrame
    BNE Clear
    RTS
.endproc 

.proc load_nametable
	LDY #0
	LDX #4
:
	LDA (pointer), Y 
	STA PPUDATA
	INY
	BNE :-	
	INC pointer + 1
	DEX
	BNE :- 
	RTS
.endproc 
