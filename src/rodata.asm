palette_tablelow:
    .byte <palette_data0
palette_tablehigh:
    .byte >palette_data0
    
palette_data0:
    .byte $0F, $15, $25, $35
    .byte $0F, $16, $27, $37
    .byte $0F, $19, $29, $39
    .byte $0F, $11, $21, $31

    .byte $0F, $15, $25, $35
    .byte $0F, $17, $27, $37
    .byte $0F, $19, $29, $39
    .byte $0F, $11, $21, $31