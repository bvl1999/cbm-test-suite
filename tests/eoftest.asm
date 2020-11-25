fnlen=7
startsize=200
stepsize=1
extra_display=$40

!ifdef c128 {

savebase=$0400
loadbank=1
maxpages=$fa

} else {

savebase=$1000
maxpages=$c0

}

file_size_test
!zone file_size_test {
        sei
        lda #$ff   ; enable kernal messages
        sta $9d

        ldx #<startsize
        stx file_len
        ldx #>startsize
        stx file_len+1

test_loop
        lda #0
        sta $d020
        lda #0
        sta $d021
        jsr do_save_file
        bcs loop_end
        jsr do_test_read
        bcs loop_end
        jsr blink
        clc
        lda file_len
        adc #<stepsize
        sta file_len
        lda file_len+1
        adc #>stepsize
        sta file_len+1
        cmp #maxpages
        bcc test_loop

loop_end
        lda #2
        sta pause
        cli
        rts

blink
        ldx #0
        ldy #0
-       iny
        bne -
        inx
        bne -
        rts

do_save_file
        lda #extra_display
        sta extra
        lda #147
        jsr CHROUT
        lda #0
        sta .flags
        sta bytes_read
        sta bytes_read+1

        +Print .testing_length
        ldx file_len
        ldy file_len+1
        jsr printint16
        lda #$0d
        jsr CHROUT

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
        bcc +
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
        clc
        adc file_len
        tax
        lda #>savebase
        sta kworkptr1+1
        adc file_len+1
        tay
        dex                             ; decrease save end by 2..... yeah I'm lazy..
        cpx #$ff
        bne +
        dey
+       dex
        cpx #$ff
        bne +
        dey
+
        lda #kworkptr1
      
        jsr SAVE
        bcc +
        jmp .save_error
+
        lda #$0d
        jsr CHROUT

        lda #<savebase
        sta kworkptr1
        lda #>savebase
        sta kworkptr1+1
        lda #kworkptr1
        sta $02c8
        sec
        jsr PLOT
        stx xpos
        sty ypos
;        jsr CLALL
        clc
        rts




do_test_read
!ifdef c128 {
        lda #loadbank
        ldx #0
        jsr SETBNK
}
        lda #7
        ldx #<testfile
        ldy #>testfile
        jsr SETNAM
        lda #1
        ldx devid
        ldy #4
        jsr SETLFS
        jsr OPEN
        bcc .ropen_ok
        jmp .ropen_error
.ropen_ok
        ldx #1
        jsr CHKIN
        bcc +
        jmp .ropen_error
+
        jsr GETIN      ; read and throw away load address
        inc bytes_read ; but count it...
        jsr GETIN      ; read and throw away load address
        inc bytes_read ; but count it...
        jmp .check_eof
.restart_read
        ldx #1
        jsr CHKIN
.check_eof
        lda iecstatus
        beq .read_next
        jmp .read_end
.read_next
        jsr GETIN
        sta readv
;        sta $d020
        bit .flags
        bpl .noprint

        lda extra
        cmp #extra_display
        bne +
        jsr .print_count
        +Print .missing_eof_msg
        lda extra
+
        and #$07
        bne +
        lda #$0d
        jsr CHROUT
+
        lda readv
        clc
        jsr printhex
        lda #' '
        jsr CHROUT
        dec extra
        bne +
        jmp .error
+
        inc bytes_read
        bne .check_eof
        inc bytes_read+1
        jmp .check_eof
.noprint
        lda readv
        ldy #0
!ifdef c128 {
        ldx #loadbank
        jsr INDCMP
} else {
        cmp (kworkptr1),y
}
        beq +
        jmp .data_error
+
        inc kworkptr1
        bne +
        inc kworkptr1+1
+
        lda kworkptr1+1
        cmp kworkptr2+1
        bne .nocheck
        lda kworkptr1
        cmp kworkptr2
        bne .nocheck
        lda .flags
        ora #$80
        sta .flags
.nocheck
        inc bytes_read
        beq .count_ok
        jmp .check_eof
.count_ok
        inc bytes_read+1
        jsr .print_count
        jmp .check_eof
        jmp .restart_read

.read_end
        jsr CLRCHN
        lda #1
        jsr CLOSE
        ldx xpos
        ldy ypos
        clc
        jsr PLOT
        +Print .count_msg
        ldx bytes_read
        ldy bytes_read+1
        sec
        jsr printint16

        lda bytes_read
        cmp file_len
        bne .fl_error
        lda bytes_read+1
        cmp file_len+1
        bne .fl_error
        +Print .finished_msg
        cli
        clc
        rts

.fl_error
        +Print .short_read_msg
        ldx file_len
        ldy file_len+1
        jsr printint16
        lda #$0d
        jsr CHROUT
        cli
        sec
        rts

.print_count
        ldx xpos
        ldy ypos
        clc
        jsr PLOT
        +Print .count_msg
        ldx bytes_read
        ldy bytes_read+1
        sec
        jmp printint16

.error
        jsr CLRCHN
        lda #1
        jsr CLOSE
        +Print .too_many_bytes
.error_exit
        ldx bytes_read
        ldy bytes_read+1
        sec
        jsr printint16
        +Print .bytes_msg
        cli
        sec
        rts

.data_error
        jsr CLRCHN
        lda #1
        jsr CLOSE
        +Print .data_error_msg
        ldx bytes_read
        ldy bytes_read+1
        jsr printint16
        lda #$0d
        jsr CHROUT
        lda kworkptr1+1
        sec
        jsr printhex
        lda kworkptr1
        clc
        jsr printhex
        lda #':'
        jsr CHROUT
        lda readv
        sec
        jsr printhex
        lda #','
        jsr CHROUT
        ldy #0
!ifdef c128 {
        ldx #loadbank
        lda #kworkptr1
        jsr INDFET
} else {
        lda (kworkptr1),y
}
        sec
        jsr printhex
        lda #$0d
        jsr CHROUT

        cli
        sec
        rts

.ropen_error
        pha
        +Print .ropen_error_msg
        pla
        jsr printint
        lda #$0d
        jsr CHROUT
        sec
        rts

.save_error
        pha
        +Print .save_error_msg
        pla
        jsr printint
        lda #$0d
        jsr CHROUT
        sec
        rts

.save_error_msg
!byte 150
!tx "save error: "
!byte 0

.count_msg
;!byte $13
!tx "bytes read: "
!byte 0

.finished_msg
!byte $0d,153
!tx "finished!"
!byte $0d,0

.short_read_msg
!byte $0d,150
!tx "premature end of file!"
!byte $0d
!tx "expected bytes: "
!byte 0

.missing_eof_msg
!byte $0d,150
!tx "expected eof but got data:"
!byte 0
.data_error_msg
!byte $0d,150
!tx "data error at byte "
!byte 0

.bytes_msg
!tx " bytes"
!byte $0d,0

.ropen_error_msg
!byte 150
!tx "error opening file: "
!byte 0

.too_many_bytes
!byte $0d
!tx "aborted after "
!byte 0

.testing_length
!byte 8,5,14
!tx "testing length: "
!byte 0

.flags
!byte 0

}


file_len
!word $0001
bytes_read
!word 0
scratchfile
!tx "s:"
testfile
!tx "ctx,r,p"
!byte 0,0,0,0
xpos
!byte 0
ypos
!byte 0
extra
!byte $40
readv
!byte 0
.end
