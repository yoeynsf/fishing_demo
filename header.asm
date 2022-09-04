.include "src/defines.inc"      ; a bunch of defines to make it easier
.include "longbranch.mac"

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

.segment "ZEROPAGE"
pointer:                        .res 2  ; general purpose pointer for indirect indexed
song_pointer:                   .res 2
joy_held:                       .res 1  ; buttons held for 1> frame
joy_status:                     .res 1  ; results of controller poll (in NMI)
framecounter:                   .res 1  ; NMI will modify this and signal to the main thread that VBlank has occured
currentOAMpos:                  .res 1  ; sprite handler stuff
OAMposAtFrame:                  .res 1
sprites_rendered:               .res 1
temp:                           .res 3  ; yeah
flags:                          .res 1  ; programmer flags
timer:                          .res 1  ; yeah
s_PPUCTRL:                      .res 1  ; shadow buffer for PPU regs
s_PPUMASK:                      .res 1

; Palette Handler ;
palette_timer:                  .res 1  ; argument into the fade routine. Stores the delay
palette_pointer:                .res 2  ; pointer so the fade-in knows what colors to go to
palette_interval:               .res 1  ; which step of the fade we're at
palette_temp:                   .res 1  ; used by palette fade out timer
palette_temp2:                  .res 1  ; palette fade in scratch space

.segment "INTERNALRAM"      ; actual free space is $0300-07FF (see config)
bgpalettes:                     .res 16 ; palette buffer (loaded every frame)
sprpalettes:                    .res 16

.segment "AUDIODRIVER"
    .include "src/driver/driver.s"

.segment "AUDIODATA0"
song_bank0:
    .incbin "src/music/music.bin"

.segment "DPCM"
dpcm0:
    .incbin "src/music/samples.bin"

.segment "FIXEDBANK"        ; CA65 is a single-pass assembler, so everything is assembled in the order it is included
    .include "src/init.asm"             ; boilerplate initialization code, mapper init too
    .include "src/main.asm"             ; main thread
    .include "src/nmi.asm"              ; NMI handler
    .include "src/irq.asm"              ; IRQ handler
    .include "src/palette_fade.asm"     ; <- all of the palette related stuff is in here
    .include "src/subroutines.asm"      ; random subroutines
    .include "src/rodata.asm"           ; any data (palettes, nametables (will seperate into banks later))
    .include "src/entity_handler.asm"   ; self explanatory

.segment "CHR"              ; 4K tables
    .incbin "src/gfx/0.chr"     ; sprite
    .incbin "src/gfx/1.chr"     ; bg (fish)

.segment "VECTORS"
    .word NMI
    .word Reset
    .word IRQ
