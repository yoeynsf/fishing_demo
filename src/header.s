.import NMI, Reset, IRQ

.segment "HEADER" ; NAMCO 163, NES 2.0 header
	.byte "NES", $1A
	.byte $02           ; 2 * 16KB PRG ROM
	.byte $01           ; 1 * 8KB CHR ROM
	.byte %00110001     ; mapper and mirroring (vertical)
	.byte %00011000     ; NES 2.0
	.byte %00110000     ; submapper 3
	.byte $00
	.byte $00 
	.byte $00, $00, $00, $00, $00  ; filler bytes

.segment "VECTORS"
    .word NMI
	.word Reset
	.word IRQ