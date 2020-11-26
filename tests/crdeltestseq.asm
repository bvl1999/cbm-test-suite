file_create_test_seq

!zone file_create_test_seq {
        sei
        lda #$ff   ; enable kernal messages
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
        ldx #<.scratchfile
        ldy #>.scratchfile
        jsr SETNAM
        lda #$0f
        ldx devid
        ldy #$0f
        jsr SETLFS
        jsr OPEN
        bcc ++
        jmp .open_error
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

        lda #7
        ldx #<.testfile
        ldy #>.testfile
        jsr SETNAM
        lda #1
        ldx devid
        ldy #2
        jsr SETLFS
        jsr OPEN
        bcc +
        jmp .open_error
+
;        +Print .writing_msg
        ldx #1
        jsr CHKOUT
        lda #<savebase
        sta kworkptr1
        lda #>savebase
        sta kworkptr1+1
        ldy #0
-
        lda (kworkptr1),y
        jsr CHROUT
        iny
        bne -
        jsr CLRCHN
        lda #1
        jsr CLOSE
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

.open_error
        pha
        +Print .open_error_msg
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
!tx "completed create/write/deletes: "
!byte 0

.writing_msg
!tx "writing file..."
!byte 0

.finished_msg
!byte $0d,153
!tx "finished!"
!byte $0d,0

.open_error_msg
!byte 150
!tx "error opening file: "
!byte 0
.scratchfile
!tx "s:"
.testfile
!tx "ctx,w,p"
!byte 0,0,0,0

}
