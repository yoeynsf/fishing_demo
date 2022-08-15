MAX_ENTITIES    =   64

;----------------;
;   Entity IDs   ;
;----------------;

ID_null     =   $00
ID_fish     =   $01

;-------------------;
;   Entity States   ;
;-------------------;

STATE_null      =   $00
STATE_normal    =   $01

.segment "ZEROPAGE"
entity_cel_pointer:             .res MAX_ENTITIES * 2            

.segment "INTERNALRAM"
entity_ID:                      .res MAX_ENTITIES
;entity_state:                   .res MAX_ENTITIES
;entity_direction:               .res MAX_ENTITIES
entity_velocity_X:              .res MAX_ENTITIES
entity_velocity_Y:              .res MAX_ENTITIES
entity_cam_X:                   .res MAX_ENTITIES
entity_cam_Y:                   .res MAX_ENTITIES
;entity_world_X:                 .res MAX_ENTITIES
;entity_world_Y:                 .res MAX_ENTITIES
entity_anim_timer:              .res MAX_ENTITIES

.segment "FIXEDBANK"

.proc spawn_entity          ; entity ID in X 
    STX temp
    
    LDX #MAX_ENTITIES       ; cycle backwards because it's faster 
:
    DEX                     ; find a free spot
    BMI done
    LDA entity_ID, X
    BNE :-

    LDA temp 
    STA entity_ID, X
done:
    RTS 
.endproc 

.proc despawn_entity
    STX temp 

    LDX #MAX_ENTITIES
:
    DEX 
    BMI done
    LDA entity_ID, X
    BEQ :-
    CMP temp
    BNE :-
    LDA #ID_null
    STA entity_ID, X
    STA entity_cam_X, X
;    STA entity_state, X
;    STA entity_direction, X
    STA entity_velocity_X, X
    STA entity_velocity_Y, X
    STA entity_cam_X, X
    STA entity_cam_Y, X              
;    STA entity_world_X, X         
;    STA entity_world_Y, X
    STA entity_anim_timer, X
    TXA 
    ASL 
    TAX 
    LDA #ID_null
    STA entity_cel_pointer, X
    STA entity_cel_pointer + 1, X 
done:
    RTS 
.endproc

entity_update_table:
    .word $0000, fish_handler

.proc update_entity

    LDX #0
    STX temp
check_entity:
    LDA entity_ID, X                ; grab ID, and if not zero, index into jump table and go 
    BEQ next
    ASL 
    TAX
    LDA entity_update_table, X
    STA pointer 
    LDA entity_update_table + 1, X
    STA pointer + 1
    JMP (pointer)
next:
    INC temp
    INX 
    CPX #MAX_ENTITIES
    BNE check_entity

    RTS 
.endproc 


.proc fish_handler
    .include "fish_AI.asm"
.endproc 

.proc load_entity_sprites
temp_x      =   temp
temp_y      =   temp + 1
interval    =   temp + 2

    LDX #0
    STX interval
check_slot:
    LDA entity_ID, X 
    BEQ next
    JMP load_sprite
next: 
    INC interval
    INX
    LDA interval
    CMP #MAX_ENTITIES
    BEQ done
    JMP check_slot
load_sprite:
    LDA entity_cam_X, X
    STA temp_x
    LDA entity_cam_Y, X
    STA temp_y
    TXA 
    ASL
    TAX 
    LDA entity_cel_pointer, X 
    STA pointer 
    LDA entity_cel_pointer + 1, X
    STA pointer + 1
    JSR load_sprites 
    LDX interval
    JMP next
done:
    RTS
.endproc