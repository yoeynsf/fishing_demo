NMI:
    PHA                 ; preserve regs
    TYA
    PHA
    TXA
    PHA

.if .defined(DEBUGGING)
    ; debug: NMI length measurement
    LDA s_PPUMASK
    AND #%00011111    ; remove emphasis
    ORA #%10000001    ; blue emphasis, grayscale
    STA s_PPUMASK
    STA PPUMASK
.endif

    LDA flags
    AND #RENDER_FLAG
    BEQ SkipRendering

    LDA #$00            ;Set the OAM address to 0
    STA OAMADDR
    LDA #$02            ;copy sprite data from $0200 into PPU memory
    STA OAMDMA

    JSR load_palettes   ; copy palette buffer into palette RAM

    LDA s_PPUCTRL       ; copy buffers into regs
    STA PPUCTRL
    LDA s_PPUMASK
    STA PPUMASK

poll_joy:
    LDY joy_status      ; save previous frame's inputs
    LDA #$01            ; poll the controller
    STA JOYPAD1
    LDA #$00
    STA JOYPAD1         ; finish poll
    LDX #$08
:
    LDA JOYPAD1
    LSR
    ROL joy_status
    DEX                 ; repeated 8 times, A, B, SEL, STA, U, D, L, R
    BNE :-
    TYA
    AND joy_status
    STA joy_held


    LDA PPUSTATUS       ; reset latch
    LDA #$00
    STA PPUSCROLL       ; X scroll
    STA PPUSCROLL       ; Y scroll

    LDA flags           ; decrement timer, *if* it is set
    AND #TIMER_FLAG
    BEQ :+
    DEC timer
    BNE :+
    LDA flags           ; if timer has run out, clear the flag
    EOR #TIMER_FLAG
    STA flags
:

    LDA flags           ; check if we need to run fade engine
    AND #PAL_FADEIN
    BEQ :+
    JSR fadein
:
    LDA flags
    AND #PAL_FADEOUT
    BEQ :+
    JSR fadeout
:

    LDA flags
    AND #%11111110    ; turn off render flag
    STA flags

SkipRendering:

    INC framecounter

.if .defined(DEBUGGING)
    ; debug: ft_music_play length measurement
    LDA s_PPUMASK
    AND #%00011111    ; remove emphasis
    ORA #%01100001    ; red emphasis, grayscale
    STA s_PPUMASK
    STA PPUMASK
.endif

    JSR ft_music_play

.if .defined(DEBUGGING)
    ; debug: finish routine length measurement
    LDA s_PPUMASK
    AND #%00011110    ; remove emphasis and grayscale
    STA s_PPUMASK
    STA PPUMASK
.endif

    PLA
    TAX
    PLA
    TAY
    PLA
    RTI
