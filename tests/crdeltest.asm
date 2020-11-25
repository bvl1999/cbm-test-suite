loopcount
        !word 0

file_create_test

!zone file_create_test {
        sei
        lda #$00   ; disable kernal messages
        sta $9d
        lda #0
        sta loopcount
        sta loopcount+1
        +Print .count_msg
        sec
        jsr PLOT
        stx xpos
        sty ypos
        jsr .print_count
        lda #$0d
        jsr CHROUT
        jsr CHROUT

.test_loop
        lda #0
        sta $d020
        lda #0
        sta $d021
        jsr .do_save_file
        bcs .loop_end
        jsr .print_count
        jsr blink
        inc loopcount
        bne .test_loop
        inc loopcount+1
        bne .test_loop

.loop_end
        lda #1
        sta pause
        cli
        rts


.do_save_file
;        lda #extra_display
;        sta extra
;        lda #147
;        jsr CHROUT

!ifdef c128 {
        lda #loadbank
        ldx #0
        jsr SETBNK
}

        lda #$05
        ldx #<scratchfile
        ldy #>scratchfile
        jsr SETNAM
        lda #$0f
        ldx devid
        ldy #$0f
        jsr SETLFS
        jsr OPEN
        bcc ++
        jmp .ropen_error
+
        ldx #$0f
        jsr CHKIN 
-
        lda iecstatus
        bne +
        jsr GETIN
        jsr CHROUT
        jmp -
+
        jsr CLRCHN
++
        lda #$0f
        tax
        tay
        jsr CLOSE

!ifdef c128 {
        lda #loadbank
        ldx #0
        jsr SETBNK
}

        lda #3
        ldx #<testfile
        ldy #>testfile
        jsr SETNAM
        lda #1
        ldx devid
        ldy #2
        jsr SETLFS
        lda #<savebase
        sta kworkptr1
        tax
        lda #>savebase
        sta kworkptr1+1
        adc #$01
        tay
        lda #kworkptr1
        jsr SAVE
        bcc +
        jmp .save_error
+
        lda #$0d
        jsr CHROUT
        rts


.print_count
        ldx xpos
        ldy ypos
        clc
        jsr PLOT
        ldx loopcount
        ldy loopcount+1
        sec
        jmp printint16

.ropen_error
        pha
        +Print .ropen_error_msg
        pla
        jsr printint
        lda #$0d
        jsr CHROUT
        lda #2
        sta pause
        sec
        rts

.save_error
        pha
        +Print .save_error_msg
        pla
        jsr printint
        lda #$0d
        jsr CHROUT
        lda #2
        sta pause
        sec
        rts

.count_msg
!byte 147
!tx "completed create/deletes: "
!byte 0

.save_error_msg
!byte 150
!tx "save error: "
!byte 0

.finished_msg
!byte $0d,153
!tx "finished!"
!byte $0d,0

.ropen_error_msg
!byte 150
!tx "error opening file: "
!byte 0
}
