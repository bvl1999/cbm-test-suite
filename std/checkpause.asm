; wait.. how long depends on value of 'pause'
; 0: wait briefly
; 1: wait longer
; 2: wait till space bar pressed

check_pause
        lda pause
        bne +
        ldy #30
        jmp .wait2
+       cmp #2
        beq +
        jmp .wait
+       lda #<.pressspacemsg
        sta strsrc
        lda #>.pressspacemsg
        sta strsrc+1
        jsr print
        lda #$7f
        sta $dc00
-       lda $dc01
        and #$10
        beq -
-       lda $dc01
        and #$10
        bne -
        lda #0
        sta $d0
        rts
.wait   ldy #180
.wait2  lda #$e0
--      cmp $d012
        bne --
-       cmp $d012
        beq -
        dey
        bne --
        rts
.pressspacemsg
!byte 5
!tx "hit space to continue"
!byte $0d, 0
