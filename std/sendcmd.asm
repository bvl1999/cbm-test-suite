sendcmd
        jsr SETNAM
        lda #$0f
        ldx devid
        tay
        jsr SETLFS
        jsr OPEN
        ldx #$0f
        jsr CHKIN
-       lda iecstatus
        beq +
        jsr GETIN
        sta (strdst),y
        jmp -
+
        lda #$0f
        jmp CLOSE

