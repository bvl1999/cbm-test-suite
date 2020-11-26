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
}
    jsr init_data
    jmp main_menu


do_exit
!ifdef c128 {
    pla
    sta $d030
    pla
    sta $d011
}
    rts


