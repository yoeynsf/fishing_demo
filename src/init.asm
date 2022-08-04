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

	LDY #$00			; palette init
	LDX #$10
:
	LDA palette_data, Y
	STA bgpalettes, Y
	INY
	DEX 
	BNE :-
	LDY #$00
	LDX #$10
:
	LDA palette_data, X
	STA sprpalettes, Y
	INX
	INY
	CPY #$10
	BNE :-
	
	JSR load_palettes

;everything is loaded, now to enable drawing
	
	CLI						; enable interrupts
	
	LDA #%10010000 			; enable NMI, and change background to use 2nd CHR set of tiles ($1000)
	STA PPUCTRL				; enabling sprites and background for left-most 8 pixels
	LDA #%00011110			; enable sprites and backgrounds in general
	STA PPUMASK
	STA s_PPUMASK

	JMP mainprep