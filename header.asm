.include "src/defines.inc"

.segment "HEADER" ; NROM
	.byte "NES"
	.byte $1A
	.byte $02  ; 2 * 16KB PRG ROM
	.byte $01  ; 1 * 8KB CHR ROM
	.byte %00000010 ; mapper and mirroring (battery present)
	.byte %00000000
	.byte $00
	.byte $00
	.byte $00 
	.byte $00, $00, $00, $00, $00  ; filler bytes

.segment "ZEROPAGE"
pointer:						.res 2
joy_held:					    .res 1
joy_status:						.res 1
framecounter:					.res 1
currentOAMpos:                  .res 1
OAMposAtFrame:                  .res 1
temp:							.res 3
flags:                          .res 1  ; programmer flags
timer:                          .res 1  ; yeah
s_PPUCTRL:                      .res 1  ; shadow buffer for PPU regs
s_PPUMASK:                      .res 1

.segment "INTERNALRAM"
bgpalettes:						.res 16
sprpalettes:					.res 16

.segment "FIXEDBANK"
	.include "src/init.asm"
	.include "src/main.asm"
	.include "src/nmi.asm"
	.include "src/irq.asm"
	.include "src/subroutines.asm"
    .include "src/rodata.asm"

.segment "CHR"
	.incbin "src/gfx/fishing.chr"

.segment "VECTORS"
    .word NMI
	.word Reset
	.word IRQ