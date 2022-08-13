MAX_ENTITIES    =   4

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
entity_state:                   .res MAX_ENTITIES
entity_direction:               .res MAX_ENTITIES
entity_velocity:                .res MAX_ENTITIES
entity_cam_X:                   .res MAX_ENTITIES
entity_cam_Y:                   .res MAX_ENTITIES
entity_world_X:                 .res MAX_ENTITIES
entity_world_Y:                 .res MAX_ENTITIES
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

.proc update_entity

    RTS 
.endproc 