; Misalliance
;
; 256 bytes intro for ZX Spectrum by Tomasz Slanina ( dox/joker )
; 1st place in 256b zx spectrum compo @ Silly Venture 2k21


BUFFER      equ $b000
WHITE       equ 7+7*8+64
RED         equ 2
CHPOSS      equ 114
ATTRS       equ $5800
SCREEN      equ $4000
BOX         equ 4

    org $b200

    dw $5800+4+18*32 
    dw $5800+9+2*32
    dw $5800+9+6*32
    dw $5800+19+10*32
    dw $5800+14+2*32
    dw $5800+7+14*32
    dw $5800+14+14*32
    dw $5800+14+10*32
    dw $5800+9+10*32
    dw $5800+19+6*32
    dw $5800+14+18*32
    dw $5800+14+6*32
    dw $5800+24+18*32
    dw $5800+19+2*32
    dw $5800+21+14*32

start:
    xor a
    ld iyl,a
    ld h,$b2
    ld l,a
    exx
    ld hl,ATTRS 

.clrscr:
    ld [hl], RED+8*RED
    inc hl
    bit 2,h
    jr z,.clrscr

.mainloop:
    exx
    inc e
    ld a,e
    and %11

.retmod:
    jr nz,.after2
    push de

    ld a,l
    cp 30
    jr nz,.skpnext

    ld l,c ;0 
    ld a,iyl
    cp 2
    jr z,.nowhite
    inc iyl

.skpnext
    ld e,[hl]
    inc hl
    push hl
    ld h,[hl]
    ld l,e
    ld a,iyl
    bit 0,a  ;bit 0,iyl -> invalid!?
    ld a,WHITE
    jr z,.setwhite
    ld a,r

.setwhite:
    ld c,BOX
    ld de,32-BOX
.inr2:
    ld b,BOX

.inr1:
    ld [hl],a
    inc hl

    djnz .inr1
    add hl,de
    dec c
    jr nz,.inr2

    pop hl
    inc hl
    jr .after1

.nowhite:
    exx

    ld hl,ATTRS
    ld c,24

.bcol:
    ld b,32

.brow:
    bit 6,[hl]
    jr nz,.upper2
    ld a,c
    cp 11
    ld a,RED+8*6
    jr c,.upper1
    ld a,5+1*8

.upper1:    
    ld [hl],a

.upper2: 
    ld a,[hl]
    out(254),a 
    inc hl
    djnz .brow
    dec c
    jr nz,.bcol
 
    ld [.opmod],a
    ld a,$18
    ld [.retmod],a
    
.after1:
    pop de

.after2:
    exx
    ld hl,BUFFER
    push hl

.fill:
    ld [hl],-1
    inc l
    djnz .fill
 
    ld l,CHPOSS
    ld de,chessdata
    ld c,6

.write:
    ld a,[de]
    and %11111000
    rra
    rra
    ld b,a
    ld a,[de]
    and $7
    add a,a

.store:
    ld [hl],a
    inc l
    djnz .store
    inc de
    dec c
    jr nz,.write

    ld de,SCREEN
    pop hl ; buffer
    exx
    ld a,e
    exx
    ld b,192

.byteloop:   
    add a, [hl]
    inc hl
    push af

 .opmod:   
    xor l
    out [254],a

    ld a,l
    cp CHPOSS
    ld a,c
    jr nc,.cskip
    inc a

.cskip:
    ld [.modjump+1],a
    pop af
    bit 4,a
    ex de,hl
    push af
    ld a,c
    jr z,.noput
    cpl

.noput    
    push bc
    push hl
    ld b,32

.icploop:  
    ld [hl],a
    inc hl
    bit 0,l

.modjump:    
    jr z,.noneg
    cpl

.noneg:
    djnz .icploop
    pop hl

    inc h
    ld a,h
    and $07
    jr nz,.end
    ld a,l
    sub $E0
    ld l,a
    sbc a,a
    and $F8
    add a,h
    ld h,a

.end:
    ex de,hl
    pop bc
    pop af
    djnz .byteloop

    jp  .mainloop

chessdata:
    db 1*8+7
    db 2*8+5
    db 2*8+4
    db 2*8+3
    db 3*8+2
    db $f9

end start
