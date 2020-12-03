openseqw
        jsr .open_start
        lda #<.seqwext
        sta strsrc
        lda #>.seqwext
        sta strsrc+1
        jmp .open_end

openseqr
        jsr .open_start
        lda #<.seqrext
        sta strsrc
        lda #>.seqrext
        sta strsrc+1
        jmp .open_end

openprgr
        jsr .open_start
        lda #<.prgrext
        sta strsrc
        lda #>.prgrext
        sta strsrc+1
        jmp .open_end

openprgw
        jsr .open_start
        lda #<.prgwext
        sta strsrc
        lda #>.prgwext
        sta strsrc+1
        jmp .open_end



.open_start
        stx strsrc                 ; store pointer to filename
        sty strsrc+1
        sta tmpval
        lda #<cmdbuf
        sta strdst
        lda #>cmdbuf
        sta strdst+1
        ldy #0
-
!ifdef c128 {
        ldx fnbank
        lda #strsrc
        jsr INDFET
} else {
        lda (strsrc),y
}

        sta (strdst),y
        iny
        dec tmpval
        bne -
        lda #0
        sta (strdst),y
        rts

.open_end
        jsr strcat
!ifdef c128 {
        lda #0
        sta fnbank
}
        lda #<cmdbuf
        sta strdst
        lda #>cmdbuf
        sta strdst+1
        jsr strlen
        tya
        ldx strdst
        ldy strdst+1
        jsr SETNAM
        jmp OPEN

.seqwext
!tx ",w,s"
!byte 0
.seqrext
!tx ",r,s"
!byte 0
.prgwext
!tx ",w,p"
!byte 0
.prgrext
!tx ",r,p"
!byte 0
