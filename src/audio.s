.macpack longbranch

.export song_bank0, dpcm0, ft_music_addr, ft_music_init, ft_music_play

.segment "AUDIODRIVER"
    .include "driver/driver.s"

.segment "AUDIODATA0"
song_bank0:
    .incbin "music/music.bin"

.segment "DPCM"
dpcm0:
    .incbin "music/samples.bin"