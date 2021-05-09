dumpftab
        +Print .fcmsg
        lda $98
        sec
        jsr printhex
        lda #$0d
        jsr CHROUT
        ldx #0
        stx $fa
-
        txa
        sec
        jsr printhex
        lda #':'
        jsr CHROUT
        lda #' '
        jsr CHROUT
        ldx $fa
        lda $0259,x
        sec
        jsr printhex
        lda #$20
        jsr CHROUT
        ldx $fa
        lda $0263,x
        sec
        jsr printhex
        lda #$20
        jsr CHROUT
        ldx $fa
        lda $026d,x
        sec
        jsr printhex
        lda #$0d
        jsr CHROUT
        inc $fa
        ldx $fa
        cpx #$0a
        bne -
        rts

.fcmsg
!tx "number of open files: "
!byte 0

