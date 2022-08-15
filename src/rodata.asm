palette_tablelow:               ; indexed into by the fade engine and whatever other palette thing. just add more entries
    .byte <palette_data0, <palette_data1
palette_tablehigh:
    .byte >palette_data0, >palette_data1
    
palette_data0:
    .byte $0f, $0f, $0f, $0f
    .byte $0f, $0f, $0f, $0f
    .byte $0f, $0f, $0f, $0f
    .byte $0f, $0f, $0f, $0f

    .byte $0f, $0f, $0f, $0f
    .byte $0f, $0f, $0f, $0f
    .byte $0f, $0f, $0f, $0f
    .byte $0f, $0f, $0f, $0f

palette_data1:
    .byte $0F, $15, $25, $35    ; BG
    .byte $0F, $16, $27, $37
    .byte $0F, $19, $29, $39
    .byte $0F, $11, $21, $31

    .byte $0F, $15, $25, $35    ; SPR
    .byte $0F, $17, $27, $37
    .byte $0F, $19, $29, $39
    .byte $0F, $11, $21, $31

spr_fish:
    .byte $01, $00, $00, $00
    .byte $01, $01, $00, $08
    .byte $80

spr_smallfish:
    .byte $01, $02, $00, $00
    .byte $80

blank_nam:
    .incbin "src/gfx/blank.nam"
fish_nam:
    .incbin "src/gfx/fish.nam"