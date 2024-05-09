.globalzp pointer, song_pointer, joy_held, joy_status, framecounter, currentOAMpos, OAMposAtFrame, sprites_rendered, temp, flags, timer, s_PPUCTRL, s_PPUMASK

.segment "ZEROPAGE"
pointer:						.res 2  ; general purpose pointer for indirect indexed
song_pointer:                   .res 2
joy_held:					    .res 1  ; buttons held for 1> frame
joy_status:						.res 1  ; results of controller poll (in NMI)
framecounter:					.res 1  ; NMI will modify this and signal to the main thread that VBlank has occured
currentOAMpos:                  .res 1  ; sprite handler stuff
OAMposAtFrame:                  .res 1
sprites_rendered:               .res 1
temp:							.res 3  ; yeah
flags:                          .res 1  ; programmer flags
timer:                          .res 1  ; yeah
s_PPUCTRL:                      .res 1  ; shadow buffer for PPU regs
s_PPUMASK:                      .res 1