init_data
        +Print .init_message
!ifdef c128 {
        lda #strsrc
        sta $02b9                      ; set pointer address for indsta
}
        lda #<savebase
        sta strsrc
        sta $fd
        lda #>savebase
        sta strsrc+1
        sta $fe

-       ldy #0
        jsr prng
!ifdef c128 {
        ldx #loadbank
        jsr INDSTA
} else {
        sta (strsrc),y
}
        sta $d020
        inc strsrc
        bne -
        inc strsrc+1
        lda strsrc+1
        cmp #maxpage
        bne -
        rts


.init_message
!byte 147
!tx "generating test data..."
!byte 0
