.importzp OAMposAtFrame, currentOAMpos, sprites_rendered, pointer, temp

.export load_sprites, clear_sprites, load_nametable, sprite_prep
.export spr_fish, spr_smallfish, blank_nam, fish_nam
.export palette_data0, palette_data1, palette_tablehigh, palette_tablelow

.include "defines.inc"
.segment "FIXEDBANK"

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
    INC sprites_rendered
    JMP :-
    donesprite:
    STX currentOAMpos
	RTS
.endproc 
 
.proc clear_sprites
    LDA sprites_rendered
    CMP #64
    BEQ done
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
done:
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

palette_tablelow:               ; indexed into by the fade engine and whatever other palette thing. just add more entries
    .byte <palette_data0, <palette_data1
palette_tablehigh:
    .byte >palette_data0, >palette_data1
    
palette_data0:
    .byte $0f, $0f, $0f, $0f
    .byte $0f, $0f, $0f, $0f
    .byte $0f, $0f, $0f, $0f
    .byte $0f, $0f, $0f, $0f

    .byte $0f, $0f, $0f, $0f
    .byte $0f, $0f, $0f, $0f
    .byte $0f, $0f, $0f, $0f
    .byte $0f, $0f, $0f, $0f

palette_data1:
    .byte $0F, $15, $25, $35    ; BG
    .byte $0F, $16, $27, $37
    .byte $0F, $19, $29, $39
    .byte $0F, $11, $21, $31

    .byte $0F, $15, $25, $35    ; SPR
    .byte $0F, $17, $27, $37
    .byte $0F, $19, $29, $39
    .byte $0F, $11, $21, $31

spr_fish:
    .byte $01, $00, $00, $00
    .byte $01, $01, $00, $08
    .byte $80

spr_smallfish:
    .byte $01, $02, $00, $00
    .byte $80

blank_nam:
    .incbin "src/gfx/blank.nam"
fish_nam:
    .incbin "src/gfx/fish.nam"

.segment "CHR"              ; 4K tables
	.incbin "src/gfx/0.chr"     ; sprite   
    .incbin "src/gfx/1.chr"     ; bg (fish)
