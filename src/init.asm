Reset:
	SEI 			; disables interrupts
	CLD 			; disable decimal mode
	LDX #$40        ; disable DMC IRQ
	STX $4017
	LDX #$FF        ; init stack
	TXS 			
	INX 			
	STX PPUCTRL
	STX PPUMASK
	STX $4010 		; disable PCM
:
	BIT PPUSTATUS
	BPL :-  		;wait vblank
	TXA 
CLEARMEM:
	STA $0000, X 
	STA $0100, X
	STA $0300, X
	STA $0400, X 
	STA $0500, X
	STA $0600, X
	STA $0700, X
	LDA #$FF
	STA $0200, X
	LDA #$00
	INX           
	BNE CLEARMEM
: 
	BIT PPUSTATUS
	BPL :-  ;wait vblank
	LDA #$02        
	STA OAMDMA
	NOP 
	LDA #%00000000 ; Increment by 1
	STA PPUCTRL
	
    LDY #0
	JSR load_palette_buffer
    JSR load_palettes

; N163 INIT -------- ;
    LDA #IRQ_DIS
    STA N163_IRQ_HI

    LDA #0 | AUDIO_NO                       ; $8000 = bank 0, disable audio 
    STA N163_PRGSEL0
    LDA #1 | CHRRAM_DIS0 | CHRRAM_DIS1      ; $A000 = bank 1, not using NT as chrram
    STA N163_PRGSEL1
    LDA #2                                  ; $C000 = bank 2
    STA N163_PRGSEL2

    LDA #0                                  ; chr init
    STA N163_CHR0
    LDA #1 
    STA N163_CHR1
    LDA #2
    STA N163_CHR2
    LDA #3 
    STA N163_CHR3
    LDA #4 
    STA N163_CHR4
    LDA #5 
    STA N163_CHR5
    LDA #6 
    STA N163_CHR6
    LDA #7 
    STA N163_CHR7    

    LDA PPUSTATUS                           ; load nametables
    LDA #$20
    STA PPUADDR
    LDA #$00
    STA PPUADDR

    LDA #<fish_nam
    STA pointer
    LDA #>fish_nam 
    STA pointer + 1
    JSR load_nametable

    LDA PPUSTATUS
    LDA #$24
    STA PPUADDR
    LDA #$00
    STA PPUADDR

    LDA #<blank_nam
    STA pointer
    LDA #>blank_nam 
    STA pointer + 1
    JSR load_nametable 

;everything is loaded, now to enable drawing
	
	CLI						; enable interrupts
	
	LDA #%10010000 			; enable NMI, and change background to use 2nd CHR set of tiles ($1000)
	STA PPUCTRL				; enabling sprites and background for left-most 8 pixels
    STA s_PPUCTRL
	LDA #%00011110			; enable sprites and backgrounds in general
	STA PPUMASK
	STA s_PPUMASK

	JMP mainprep