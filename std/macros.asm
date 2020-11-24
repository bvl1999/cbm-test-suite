!macro Print .t {
        lda #<.t
        sta strsrc
        lda #>.t
        sta strsrc+1
        jsr print
}

