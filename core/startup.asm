devid
!byte 12

; startup code here... devid is at $080d or 1c0d for automation purposes.

!ifdef c128 {
    lda $d011
    and #$7f
    pha
    lda $d030
    pha
    lda scrwidth
    cmp #79
    bne +
    lda #1
    sta $d030
    lda $d011
    and #%01101111
    sta $d011
+
} else {
    lda #$36
    sta $01
}
    lda dv
    sta devid
    jmp main_menu


do_exit
!ifdef c128 {
    pla
    sta $d030
    pla
    sta $d011
} else {
    lda #$37
    sta $01
}
    rts


