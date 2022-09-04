;---------------------------------------;
;   See defines.inc for flags           ;
;   and header.asm for zeropage         ;
;                                       ;
;   USAGE                               ;
;   fading out:                         ;
;       call fadout_palette with the    ;
;       interval delay in X (>0)        ;
;   fading in:                          ;
;       call fadein_palette with the    ;
;       interval delay in X and an      ;
;       index into the palette table    ;
;       in Y.                           ;
;                                       ;
;   there is a bit of code in the       ;
;   NMI handler to make sure the        ;
;   fades actually run.                 ;
;---------------------------------------;

.proc load_palette_buffer
    LDA palette_tablelow, Y
    STA palette_pointer
    LDA palette_tablehigh, Y
    STA palette_pointer + 1

    LDY #$00                ; palette buffer init
    LDX #$10
:
    LDA (palette_pointer), Y
    STA bgpalettes, Y
    INY
    DEX
    BNE :-
    LDX #$00
    LDY #$10
:
    LDA (palette_pointer), Y
    STA sprpalettes, X
    INX
    INY
    CPX #$10
    BNE :-
    RTS
.endproc

.proc load_palettes
    LDA PPUSTATUS
    LDA #$3F
    STA PPUADDR
    LDA #$00
    STA PPUADDR
    LDX #$00
    LDY #32
:
    LDA bgpalettes, X
    STA PPUDATA
    INX
    DEY
    BNE :-
    LDX #0
    LDY #32
:
    LDA sprpalettes, X
    STA PPUDATA
    INX
    DEX
    BNE :-
    RTS
.endproc

.proc fadeout_palette              ; X = Frame count
    STX palette_timer
    STX palette_temp
    LDA flags
    ORA #PAL_FADEOUT
    STA flags
    JSR fadeout
    RTS
.endproc

.proc fadein_palette               ; X = Frame count, Y = Palette Index
    LDA palette_tablelow, Y
    STA palette_pointer
    LDA palette_tablehigh, Y
    STA palette_pointer + 1

    STX palette_timer
    STX palette_temp
    LDA flags
    ORA #PAL_FADEIN
    STA flags
    JSR fadein
    RTS
.endproc

.proc fadeout                        ; set flag before running routine
    DEC palette_temp

    LDA palette_temp
    BEQ :+
    RTS
:

    LDX #0
check_color:
    LDA bgpalettes, X
    AND #%11110000          ; get the row bits, we're seeing if this is low enough to be set to $0F
    BNE :+
    LDA #$0F
    STA bgpalettes, X
    INX
    CPX #$10
    BEQ :++
    JMP check_color
:
    LDA bgpalettes, X
    SEC
    SBC #$10
    STA bgpalettes, X
    INX
    CPX #$10
    BEQ :+
    JMP check_color
:
    LDX #0
check_spr_color:
    LDA sprpalettes, X
    AND #%11110000          ; get the row bits, we're seeing if this is low enough to be set to $0F
    BNE :+
    LDA #$0F
    STA sprpalettes, X
    INX
    CPX #$10
    BEQ done_interval
    JMP check_spr_color
:
    LDA sprpalettes, X
    SEC
    SBC #$10
    STA sprpalettes, X
    INX
    CPX #$10
    BEQ done_interval
    JMP check_spr_color

done_interval:
    INC palette_interval
    LDA palette_interval
    CMP #4
    BEQ alldone

    LDA palette_timer
    STA palette_temp

    RTS
alldone:
    LDA #0
    STA palette_interval
    LDA flags
    EOR #PAL_FADEOUT
    STA flags
    RTS
.endproc

.proc fadein
    DEC palette_temp
    LDA palette_temp
    BEQ :+
    RTS
:
    LDA palette_interval
    BNE no_prep
    LDY #0
:
    LDA (palette_pointer), Y                ; get the low nibble, and store it into the buffer.
    AND #%00001111
    STA bgpalettes, Y
    INY
    CPY #$20
    BNE :-
no_prep:
    LDA palette_interval
    BEQ done_interval

    LDX #0
    LDY #0
check_bg:
    LDA bgpalettes, Y
    CMP (palette_pointer), Y        ; if not already equal to the target palette, add #$10
    BEQ :+

    LDA bgpalettes, Y
    CLC
    ADC #$10
    STA bgpalettes, Y
    INY
    CPY #$10
    BEQ :++
    JMP check_bg
:
    INY
    CPY #$10
    BEQ :+
    JMP check_bg
:
    LDY #$10
    LDX #0
check_spr_color:
    LDA sprpalettes, X
    CMP (palette_pointer), Y
    BEQ :+
    CLC
    ADC #$10
    STA sprpalettes, X
    INY
    INX
    CPX #$10
    BEQ done_interval
    JMP check_spr_color
:
    INY
    INX
    CPX #$10
    BEQ done_interval
    JMP check_spr_color

done_interval:
    INC palette_interval
    LDA palette_interval
    CMP #4
    BEQ alldone

    LDA palette_timer
    STA palette_temp

    RTS
alldone:
    LDA #0
    STA palette_interval
    LDA flags
    EOR #PAL_FADEIN
    STA flags
    RTS
.endproc