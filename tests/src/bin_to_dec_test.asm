    ld e, 0x00
    ld hl, 0xFFFF
; Routine for converting a 24-bit binary number to decimal
; In: E:HL = 24-bit binary number (0-16777215)
; Out: DE:HL = 8 digit decimal form (packed BCD)
; Changes: AF, BC, DE, HL & IX

; by Alwin Henseler

                 LD C,E
                 PUSH HL
                 POP IX          ; input value in C:IX
                 LD HL,1
                 LD D,H
                 LD E,H          ; start value corresponding with 1st 1-bit
                 LD B,24         ; bitnr. being processed + 1

FIND1:           ADD IX,IX
                 RL C            ; shift bit 23-0 from C:IX into carry
                 JR C,NEXTBIT
                 DJNZ FIND1      ; find highest 1-bit

; All bits 0:
                 RES 0,L         ; least significant bit not 1 after all ..
                 RET

DBLLOOP:         LD A,L
                 ADD A,A
                 DAA
                 LD L,A
                 LD A,H
                 ADC A,A
                 DAA
                 LD H,A
                 LD A,E
                 ADC A,A
                 DAA
                 LD E,A
                 LD A,D
                 ADC A,A
                 DAA
                 LD D,A          ; double the value found so far
                 ADD IX,IX
                 RL C            ; shift next bit from C:IX into carry
                 JR NC,NEXTBIT   ; bit = 0 -> don't add 1 to the number
                 SET 0,L         ; bit = 1 -> add 1 to the number
NEXTBIT:         DJNZ DBLLOOP

inf:
    jp inf
