slot_number     = temp
ID_buf          = temp + 1

    TXA                         ; restore X to original index
    LSR   
    TAX
    STX ID_buf

    LDX slot_number

    LDA entity_velocity_X, X
    CLC 
    ADC #$60
    STA entity_velocity_X, X

    LDA entity_cam_X, X
    ADC #0
    STA entity_cam_X, X 

    LDA entity_velocity_Y, X
    CLC 
    ADC #$44
    STA entity_velocity_Y, X

    LDA entity_cam_Y, X
    ADC #0
    STA entity_cam_Y, X 

    TXA 
    ASL 
    TAX 
    LDA #<spr_smallfish
    STA entity_cel_pointer, X
    LDA #>spr_smallfish
    STA entity_cel_pointer + 1, X

    LDX slot_number
    JMP update_entity::next