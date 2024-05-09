.export IRQ

.include "defines.inc"
.segment "FIXEDBANK"

IRQ:
    PHA         
    TYA        
    PHA       
    TXA
    PHA

	PLA
    TAX
    PLA       
    TAY
    PLA    
	RTI 