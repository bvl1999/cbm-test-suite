btoa
        ldy #$2f
        ldx #$3a
        sec
-       iny
        sbc #100
        bcs -
-       dex
        adc #10
        bmi -
        adc #$2f
        pha
        tya
        ldy #0
        cmp #$30
        beq +
        sta (strsrc),y
        iny
+       txa
        cmp #$30
        beq +
        sta (strsrc),y
        iny
+       pla
        sta (strsrc),y
        iny
        lda #0
        sta (strsrc),y
        rts

itoa
!zone itoa {
        stx workptr
        sty workptr+1

        ldy #$05
        lda #0
        sta (strsrc),y
        dey
.next   jsr .div10
        ora #$30
        sta (strsrc),y
        dey 
        bpl .next
        rts

.div10
        LDX #$11
        LDA #$00
        CLC
.divloop
        ROL
        CMP #$0A
        BCC .divskip
        SBC #$0A
.divskip
        ROL workptr
        ROL workptr+1
        DEX
        BNE .divloop
        RTS

}

printint = printint8

printint8
        pha
        lda #<scratchpad
        sta strsrc
        lda #>scratchpad
        sta strsrc+1
        pla
        jsr btoa
print                             ; setup x and y registers for printing a string
        ldy #0
        ldx #$ff
printsubstr                       ; print substring, x = length, y = start position
-       lda (strsrc),y
        beq +
        jsr CHROUT
        dex
        beq +
        iny
        bne -
+       rts

printint16 ; print 16bit int in x (low) and y (high), clobbers a register, call with carry set to preserve leading zeros.
        txa
        pha
        tya
        pha
        php                      ; preserve c flag (and others)
        lda #<scratchpad
        sta strsrc
        lda #>scratchpad
        sta strsrc+1
        jsr itoa
        plp                      ; restore flags so we can check c and display leading zeros if it is set
        bcs +
        ldy #0
        ldx #5
-       lda (strsrc),y
        cmp #$30
        bne +
        dex
        beq +
        inc strsrc
        bne -
+
        jsr print
        pla
        tay
        pla
        tax
        rts

printhex ; print 8bit int in A, make sure to preserve A
        pha
        bcc +
        lda #'$'
        jsr CHROUT
        pla
        pha
+
        and #$f0
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        bcc +
        adc #$06
+       adc #$30
        jsr CHROUT
        pla
        pha
        and #$0f
        cmp #$0a
        bcc +
        adc #$06
+       adc #$30
        jsr CHROUT
        pla
        rts


centerstr
        ldy #0
-       lda (strsrc),y
        beq +
        iny
        bne -
+       sty tmpval
        lda scrwidth
        clc
        adc #1
        sec
        sbc tmpval
        lsr
        tay
        ldx #0
        lda #$20
-       dey
        bmi +
        sta scratchpad,x
        inx
        jmp -
+       ldy #0
-       lda (strsrc),y
        sta scratchpad,x
        beq +
        inx
        iny
        jmp -
+       lda #<scratchpad
        sta strsrc
        lda #>scratchpad
        sta strsrc+1
        rts

printat
        clc
        jsr PLOT
        jmp print

printcentered
        jsr centerstr
        jmp print

printlowercase
        ldy #0
-       lda (strsrc),y
        beq +
        and #$df
        sta (strsrc),y
        iny
        bne -
+       jmp print

printbitfield
        sta tmpval
        lda #'%'
        jsr CHROUT
        lda #<scratchpad
        lda #$00
        sta strsrc
        lda #>scratchpad
        lda #$40
        sta strsrc+1
        lda #$80
        ldy #0
        ldx #7
-       asl tmpval
        bcs +
        lda #$30
        jmp ++
+       lda #$31
++      sta (strsrc),y
        iny
        dex
        bpl -
        lda #0
        sta (strsrc),y
        jmp print

tolower
        lda strsrc
        sta strdst
        lda strsrc+1
        sta strdst+1
        ldy #0
-       lda (strdst),y
        beq ++
        cmp #$61
        bmi +
        cmp #$7b
        bpl +
        and #%11011111
        sta (strdst),y
+       iny
        bne -
        inc strdst + 1
        bne -
++      rts

!macro Print .t {
        lda #<.t
        sta strsrc
        lda #>.t
        sta strsrc+1
        jsr print
}


