KEY_R         = 1 << 0      ; aliases for doing anything with the joystatus var
KEY_L         = 1 << 1
KEY_D         = 1 << 2
KEY_U         = 1 << 3
KEY_STA       = 1 << 4
KEY_SEL       = 1 << 5
KEY_B         = 1 << 6
KEY_A         = 1 << 7

PPUCTRL       = $2000       ; defines for NES regs
PPUMASK       = $2001
PPUSTATUS     = $2002
OAMADDR       = $2003
OAMDATA       = $2004
PPUSCROLL     = $2005
PPUADDR       = $2006
PPUDATA       = $2007
OAMDMA        = $4014
JOYPAD1       = $4016
JOYPAD2       = $4017

; Programmer flags, for use with that "flags" variable in the zp
RENDER_FLAG     = 1 << 0    ; 0 = frame not render ready, 1 = frame render ready
TIMER_FLAG      = 1 << 1
PAL_FADEIN      = 1 << 2    ; 0 = don't run fade engine, 1 = run fade engine
PAL_FADEOUT     = 1 << 3    ; 0 = don't run fade engine, 1 = run fade engine

;DEBUGGING = 1              ; highlight routine times with PPU emphasis and grayscale

;------------;
;    N163    :
;------------;
N163_RAM_PORT   =   $4800
N163_IRQ_LOW    =   $5000
N163_IRQ_HI     =   $5800
    IRQ_EN      =   1 << 7
    IRQ_DIS     =   0 << 7
N163_CHR0       =   $8000
N163_CHR1       =   $8800
N163_CHR2       =   $9000
N163_CHR3       =   $9800
N163_CHR4       =   $A000
N163_CHR5       =   $A800
N163_CHR6       =   $B000
N163_CHR7       =   $B800
N163_NT0        =   $C000
N163_NT1        =   $C800
N163_NT2        =   $D000
N163_NT3        =   $D800
N163_PRGSEL0    =   $E000       ; 8K @ $8000-9FFF
    AUDIO_YES   =   0 << 6      ; 0 = Enabled, 1 = Disabled
    AUDIO_NO    =   1 << 6
N163_PRGSEL1    =   $E800       ; 8K @ $A000-BFFF
    CHRRAM_EN0  =   0 << 6      ; Disable CHR-RAM at $0000-$0FFF
    CHRRAM_DIS0 =   1 << 6
                                ; 0: Pages $E0-$FF use NT RAM as CHR-RAM
                                ; 1: Pages $E0-$FF are the last $20 banks of CHR-ROM
    CHRRAM_EN1  =   0 << 7      ; Disable CHR-RAM at $1000-$1FFF
    CHRRAM_DIS1 =   1 << 7
                                ; 0: Pages $E0-$FF use NT RAM as CHR-RAM
                                ; 1: Pages $E0-$FF are the last $20 banks of CHR-ROM
N163_PRGSEL2    =   $F000       ; 8K @ $C000-DFFF
N163_RAM_EN     =   $F800
    PRGRAM0_EN  =   0 << 0      ; $6000-$67FF (0 = write enable)
    PRGRAM0_DIS =   1 << 0
    PRGRAM1_EN  =   0 << 1      ; $6800-$6FFF
    PRGRAM1_DIS =   1 << 0
    PRGRAM2_EN  =   0 << 2      ; $7000-$77FF
    PRGRAM2_DIS =   1 << 0
    PRGRAM3_EN  =   0 << 3      ; $7800-$7FFF
    PRGRAM3_DIS =   1 << 0
    WRITE_EN    =   %0100 << 4

; AUDIO --------

N163_ADDR       = $F800
    AUTOINC_EN  = 1 << 7
    AUTOINC_DIS = 1 << 0
N163_DATA       = $4800

N163_CHANNEL0   = $40
N163_CHANNEL1   = $48
N163_CHANNEL2   = $50
N163_CHANNEL3   = $58
N163_CHANNEL4   = $60
N163_CHANNEL5   = $68
N163_CHANNEL6   = $70
N163_CHANNEL7   = $78

N163_FREQ_LO    = 0
N163_PHASE_LO   = 1
N163_FREQ_MID   = 2
N163_PHASE_MID  = 3
N163_FREQ_HI    = 4
N163_PHASE_HI   = 5
N163_WAVE_ADDR  = 6
N163_VOL        = 7
    CH_0        = 0 << 4
    CH_1        = 1 << 4
    CH_2        = 2 << 4
    CH_3        = 3 << 4
    CH_4        = 4 << 4
    CH_5        = 5 << 4
    CH_6        = 6 << 4
    CH_7        = 7 << 4
;-----------------------------------

