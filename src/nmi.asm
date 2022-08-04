NMI:
    PHA
    LDA DoNmi
    BNE NoSkipNMI
    
NoSkipNMI:
    INC DoNmi   
    TYA        
    PHA       
    TXA
    PHA
    PHP

	LDA #$00            ;Set the OAM address to 0
    STA OAMADDR
	LDA #$02    		;copy sprite data from $0200 into PPU memory
    STA OAMDMA
	
	JSR load_palettes

	LDA s_PPUCTRL 		;Choose nametable 0 as the base nametable address
    STA PPUCTRL

    LDA s_PPUMASK
    STA PPUMASK

poll_joy:
    LDY joy_status      ; save previous frame's inputs
	LDA #$01  			; poll the controller
	STA JOYPAD1
	LDA #$00
	STA JOYPAD1 		; finish poll 
	LDX #$08
:	
	LDA JOYPAD1
    LSR
    ROL joy_status
    DEX     			; repeated 8 times, A, B, SEL, STA, U, D, L, R
	BNE :-
    TYA 
    AND joy_status       
    STA joy_held 


    LDA PPUSTATUS  		;the next write to $2005 will be the X scroll
	LDA #$00
    STA PPUSCROLL  		
	STA PPUSCROLL

    LDA flags			; decrement timer, *if* it is set
	AND #TIMER_FLAG
	BEQ :+
	DEC timer
	BNE :+
	LDA flags			; if timer has run out, clear the flag
	EOR #%00000001
	STA flags
:

	INC framecounter
	
	LDA #$00
	STA DoNMI
	PLP
	PLA
    	TAX
    	PLA       
    	TAY
	
SkipWholeNMI:
    	PLA        
    	RTI
