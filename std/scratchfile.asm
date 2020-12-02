cmdbuf=$0200
scratch_file
        stx strsrc
        sty strsrc+1
        tay
        lda #0
        sta (strsrc),y

!ifdef c128 {
        lda #0
        ldx #0
        jsr SETBNK
}

        lda #<cmdbuf
        sta strdst
        lda #>cmdbuf
        sta strdst+1
        lda #'s'
        sta cmdbuf
        lda #':'
        sta cmdbuf+1
        lda #0
        sta cmdbuf+2
        jsr strcat
        lda #<cmdbuf
        sta strdst
        lda #>cmdbuf
        sta strdst+1
        jsr strlen
        tya
        ldx #<cmdbuf
        ldy #>cmdbuf
        jmp sendcmd
