sendcmd
        jsr SETNAM
        lda #$0f
        ldx devid
        tay
        jsr SETLFS
        jsr OPEN
        ldx #$0f
        jsr CHKIN
        ldy #0
-       lda iecstatus
        bne +
        jsr GETIN
        sta (strdst),y
        iny
        jmp -
+
        lda #0
        sta (strdst),y
        lda #$0f
        jmp CLOSE

